#!/bin/sh

with_warning=0

fatal() {
	echo "  ---> ERROR: $1"
	exit 1
}

nonfatal() {
	echo "  ---> Non-fatal error: $1"
	with_warning="true"
	:
}

run_command() {
	echo "---> Running:" "$@" >/dev/stderr
	"$@"
	return $?
}

command -v git >/dev/null || fatal "git command is not available. Please install git and try again (sudo apt install git)"
command -v git-lfs >/dev/null || fatal "git lfs is not available. Please install git-lfs and try again (sudo apt install git-lfs)"

for cmd in cut dirname grep sed tr; do
	command -v $cmd >/dev/null || fatal "$cmd command is not available. Please install $cmd and try again."
done

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir" || nonfatal "Failed to change directory to the script location"

main_repo_path="$(git rev-parse --show-superproject-working-tree)"
if [ -z "$main_repo_path" ]; then
	main_repo_path="$(git rev-parse --show-toplevel)"
fi

run_command cd "$main_repo_path" || fatal "Failed to enter the main repository root directory"

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_branch" = "main" ]; then
	fatal "You are on the main branch. You should create your own branch first before making changes."
fi

if ! git diff --cached --exit-code -- . ':(exclude)assets' >/dev/null; then
	fatal "There are already staged changes outside the assets directory. Please commit or stash them before running this script. Run git status for more info"
fi

if ! [ -d assets ]; then
	run_command git submodule update --init || fatal "Failed to initialize and update git submodules"
	echo
	echo "---> The assets git submodule has been initialized."
	echo "---> Please install the pre-commit git hooks for the assets submodule."
	echo "---> After installing the git hooks, re-run this script to continue."
	echo
	exit 0
fi

run_command cd assets || fatal "Failed to change directory to assets"

if [ "$(git rev-parse --abbrev-ref HEAD)" = "HEAD" ]; then
	run_command git switch main || fatal "Failed to switch to branch main"
fi

run_command git fetch origin main || fatal "Failed to fetch latest changes from remote origin"
run_command git rebase origin/main || fatal "Failed to rebase latest changes from assets repository"

if [ -z "$(git status --porcelain)" ]; then
	echo
	echo "---> The latest changes from the assets main branch have been pulled into the assets submodule."
	echo "---> No changes detected in the assets directory. Nothing has been pushed and no additional commits have been made."
	echo
	exit 0
fi

changed_filenames="$(git status --porcelain | cut -c4- | grep -v '\.import$' | sed 's/.*\///')"

run_command git add . || fatal "Failed to add changes in assets submodule"

commit_message="Update assets"
if [ -n "$changed_filenames" ]; then
	commit_message="Update assets: $(echo "$changed_filenames" | tr -s '\n' ' ')"
fi

run_command git commit -m "$commit_message" || fatal "Failed to commit changes in assets git submodule"
run_command git push origin HEAD:main || nonfatal "Failed to push assets changes to assets repository"

run_command cd .. || fatal "Failed to change directory back to main repository"

run_command git add assets || fatal "Failed to add updated submodule reference to main repository"
run_command git commit -m "$commit_message" || fatal "Failed to commit updated submodule reference in main repository"

echo
echo "---> Changes in the assets repository should have been pushed. The assets repository should now contain your changes."
echo "---> A new commit in the main repo should update the reference of the assets git submodule with your changes."
echo "---> The new commit message: $commit_message"
echo '---> You can change the commit message with: git commit --amend -m "Update assets: Add a plethora of curious images, each a whisper of wonder"'
echo

if [ "$with_warning" = "true" ]; then
	echo
	echo "--->"
	echo "---> Please check the results of commands above. An ERROR has occurred."
	echo "--->"
	echo
fi
