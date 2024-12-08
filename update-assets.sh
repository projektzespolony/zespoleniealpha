#!/bin/sh

with_warning=0

fatal() {
	echo "  ---> Fatal error: $1"
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

for cmd in cut grep sed tr; do
	command -v $cmd >/dev/null || fatal "$cmd command is not available. Please install $cmd and try again"
done

command -v git >/dev/null || fatal "git command is not available. Please install git and try again (apt install git)"

run_command cd "$(git rev-parse --show-toplevel)" || fatal "Failed to enter the main repository root directory"

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_branch" = "main" ]; then
	fatal "You are on the main branch. You should create your own branch first before making changes."
fi

run_command git submodule update --init || fatal "Failed to initialize and update git submodules"

run_command cd assets || fatal "Failed to change directory to assets"
run_command git pull origin main || nonfatal "Failed to pull latest changes from assets repository"

changed_filenames="$(git status --porcelain | cut -c4- | grep -v '\.import$' | sed 's/.*\///')"

run_: git add . || fatal "Failed to add changes in assets submodule"

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
echo '---> You can change the commit message with: git commit --amend -m "Update assets: Add XYZ images"'

if [ "$with_warning" = "true" ]; then
	echo
	echo "---> Please check the results of commands above. An error has occurred."
fi
