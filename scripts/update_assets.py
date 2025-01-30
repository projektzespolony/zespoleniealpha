#!/usr/bin/env python3

import os
import subprocess
import sys

PathLike = os.PathLike[str] | str


class AnsiColors:
    gray: str = "\033[30m"
    green: str = "\033[32m"
    red: str = "\033[31m"
    blue: str = "\033[34m"
    reverse: str = "\033[7m"
    reset: str = "\033[0m"


colors = AnsiColors()


class GitCommandError(Exception):
    cmd: list[str]
    output: str
    returncode: int
    cwd: PathLike | None

    def __init__(
        self,
        cmd: list[str],
        output: str,
        returncode: int,
        cwd: PathLike | None = None,
    ) -> None:
        self.cmd = cmd
        self.output = output
        self.returncode = returncode
        self.cwd = cwd
        super().__init__(
            f"Command failed with exit code {returncode} in directory: {cwd}",
        )


def print_git_command_error(e: GitCommandError) -> None:
    print(f"  ---> Command: {' '.join(e.cmd)}", file=sys.stderr)
    print(f"  ---> Command output:")
    print(e.output, file=sys.stderr)
    print(f"  ---> Command return code: {e.returncode}", file=sys.stderr)
    print(f"  ---> Directory: {e.cwd}", file=sys.stderr)


class GitNotFoundError(Exception):
    """Raised when git or git-lfs is not installed"""

    def __init__(self, command: str) -> None:
        super().__init__(f"{command} is not available. Please install it and try again")


class ActionNeededError(Exception):
    error_message: str
    action_message: str
    parent_exception: Exception | None

    def __init__(
        self,
        error_message: str,
        action_message: str,
        parent_exception: Exception | None = None,
    ) -> None:
        self.error_message = error_message
        self.action_message = action_message
        self.parent_exception = parent_exception
        super().__init__(error_message)


def raise_command_error(
    cmd: list[str],
    output: str,
    code: int,
    cwd: PathLike | None = None,
) -> None:
    raise GitCommandError(cmd, output, code, cwd)


def run_command(
    cmd: list[str],
    cwd: PathLike | None = None,
    silent: bool = False,
) -> tuple[str, int]:
    if not silent:
        print(f"---> {colors.blue}Running{colors.reset}: {' '.join(cmd)}")

    process = subprocess.run(
        cmd,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    output = os.linesep.join(
        filter(
            None,
            [process.stdout.rstrip(os.linesep), process.stderr.rstrip(os.linesep)],
        ),
    )

    if not silent:
        print(colors.gray, end="")
        print(output, end="")
        print(colors.reset)

    return output, process.returncode


def check_required_commands() -> None:
    required_commands = ["git", "git-lfs"]
    for cmd in required_commands:
        try:
            _ = subprocess.run([cmd], capture_output=True, check=False)
        except FileNotFoundError:
            raise ActionNeededError(
                f"{cmd} command has not been found.",
                f"Install the required commands: {', '.join(required_commands)}",
            )


def get_main_repo_path(cwd: PathLike) -> PathLike:
    output, code = run_command(
        ["git", "rev-parse", "--show-superproject-working-tree"],
        cwd=cwd,
        silent=True,
    )
    if code != 0 or output == "":
        output, code = run_command(["git", "rev-parse", "--show-toplevel"], silent=True)
        if code != 0:
            raise_command_error(["git", "rev-parse", "--show-toplevel"], output, code)
    return output


def check_current_branch(repo_path: PathLike) -> None:
    output, code = run_command(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=repo_path,
        silent=True,
    )
    if code != 0:
        raise_command_error(["git", "rev-parse"], output, code, repo_path)
    if output == "main":
        raise ActionNeededError(
            "You are on the main branch. We don't want to make changes to the main branch directly.",
            "Please switch to a different branch before proceeding.",
        )


def check_staged_changes_besides_assets(repo_path: PathLike) -> None:
    _, code = run_command(
        ["git", "diff", "--cached", "--exit-code", "--", ".", ":(exclude)assets"],
        cwd=repo_path,
        silent=True,
    )
    if code != 0:
        raise ActionNeededError(
            "There are already staged changes besides the assets directory. Let's commit assets updates separately from other changes.",
            "Please commit or stash the changes besides the assets directory.",
        )


def initialize_assets_submodule(
    main_repo_path: PathLike,
    assets_repo_path: PathLike,
) -> bool:
    if os.path.isdir(assets_repo_path):
        return False

    output, code = run_command(
        ["git", "submodule", "update", "--init"],
        cwd=main_repo_path,
    )
    if code != 0:
        raise_command_error(
            ["git", "submodule", "update", "--init"],
            output,
            code,
            main_repo_path,
        )

    print("\n")
    print("---> The git submodules have been initialized.")
    print("---> Please install the pre-commit git hooks for the assets submodule.")
    print("---> After installing the git hooks, re-run this script to continue.")
    print("\n")
    return True


def update_assets_repository(assets_repo_path: PathLike) -> str | None:
    current_branch_output, code = run_command(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=assets_repo_path,
        silent=True,
    )
    if code != 0:
        raise_command_error(
            ["git", "rev-parse"],
            current_branch_output,
            code,
            assets_repo_path,
        )
    if current_branch_output == "HEAD":
        switch_output, code = run_command(
            ["git", "switch", "main"],
            cwd=assets_repo_path,
        )
        if code != 0:
            raise_command_error(
                ["git", "switch", "main"],
                switch_output,
                code,
                assets_repo_path,
            )

    fetch_output, code = run_command(
        ["git", "fetch", "origin", "main"],
        cwd=assets_repo_path,
    )
    if code != 0:
        raise_command_error(
            ["git", "fetch", "origin", "main"],
            fetch_output,
            code,
            assets_repo_path,
        )

    rebase_output, code = run_command(
        ["git", "rebase", "origin/main"],
        cwd=assets_repo_path,
    )
    if code != 0:
        try:
            raise_command_error(
                ["git", "rebase", "origin/main"],
                rebase_output,
                code,
                assets_repo_path,
            )
        except GitCommandError as e:
            raise ActionNeededError(
                "Could not rebase the assets repository.",
                "Please pull the remote changes from the assets repository manually. This may require resolving conflicts.",
                parent_exception=e,
            )

    status_output, code = run_command(
        ["git", "status", "--porcelain"],
        cwd=assets_repo_path,
        silent=True,
    )
    if code != 0:
        raise_command_error(
            ["git", "status", "--porcelain"],
            status_output,
            code,
            assets_repo_path,
        )
    if not status_output:
        print("---> There are no changes in the assets directory.\n")
        return None

    changed_files = [
        line[3:].split("/")[-1]
        for line in status_output.splitlines()
        if not line.endswith(".import")
    ]
    add_output, code = run_command(["git", "add", "."], cwd=assets_repo_path)
    if code != 0:
        raise_command_error(["git", "add", "."], add_output, code, assets_repo_path)

    commit_message = "Update assets"
    if changed_files:
        commit_message = f"Update assets: {' '.join(changed_files)}"

    commit_output, code = run_command(
        ["git", "commit", "-m", commit_message],
        cwd=assets_repo_path,
    )
    if code != 0:
        raise_command_error(
            ["git", "commit", "-m", commit_message],
            commit_output,
            code,
            assets_repo_path,
        )

    _, code = run_command(["git", "push", "origin", f"HEAD:main"], cwd=assets_repo_path)
    if code != 0:
        print(
            "  ---> ERROR: Failed to push assets changes to assets repository.",
            file=sys.stderr,
        )

    return commit_message


def update_main_repository(main_repo_path: PathLike, commit_message: str) -> None:
    output, code = run_command(["git", "add", "assets"], cwd=main_repo_path)
    if code != 0:
        raise_command_error(["git", "add", "assets"], output, code, main_repo_path)

    output, code = run_command(
        ["git", "commit", "-m", commit_message],
        cwd=main_repo_path,
    )
    if code != 0:
        raise_command_error(
            ["git", "commit", "-m", commit_message],
            output,
            code,
            main_repo_path,
        )


def print_final_message(commit_message: str) -> None:
    """Print final status message"""
    print(
        "\n---> Changes in the assets repository should have been pushed. The assets repository should now contain your changes.",
    )
    print(
        "---> A new commit in the main repo has been created to update the reference of the assets git submodule with your changes.",
    )
    print(f"---> The new commit message: {commit_message}")
    print(
        '---> You can change the commit message with: git commit --amend -m "Update assets: Add a plethora of curious images, each a whisper of wonder"\n',
    )


def enable_ansi_colors() -> None:
    if os.name == "nt":
        _ = subprocess.call("", shell=True)


def main() -> int:
    try:
        enable_ansi_colors()
        check_required_commands()

        script_dir = os.path.dirname(os.path.abspath(__file__))
        main_repo_path = get_main_repo_path(script_dir)
        assets_repo_path = os.path.join(main_repo_path, "assets")

        print(f"---> Running commands in {main_repo_path}")

        check_current_branch(main_repo_path)
        check_staged_changes_besides_assets(main_repo_path)

        if initialize_assets_submodule(main_repo_path, assets_repo_path):
            return 0

        print(f"---> Running commands in {assets_repo_path}")

        commit_message = update_assets_repository(assets_repo_path)
        if not commit_message:
            return 0

        print(f"---> Running commands in {main_repo_path}")

        update_main_repository(main_repo_path, commit_message)
        print_final_message(commit_message)

        return 0

    except GitCommandError as e:
        print("\n")
        print(
            f"  ---> {colors.red}ERROR{colors.reset}: An error occurred while running a git command.",
        )
        print_git_command_error(e)
        print(
            "  ---> Please analyze the {colors.red}ERROR{colors.reset} above. Use the command output to determine the cause of the error. You may need to resolve the error manually through git.",
        )
        return 1

    except ActionNeededError as e:
        print(
            f"  ---> {colors.red}ERROR{colors.reset}: {e.error_message}",
            file=sys.stderr,
        )
        print(
            f"  ---> {colors.red}ACTION NEEDED{colors.reset}: {e.action_message}",
            file=sys.stderr,
        )
        if isinstance(e.parent_exception, GitCommandError):
            print("  ---> This error originated from a failed git command.")
            print_git_command_error(e.parent_exception)
        print(
            f"  ---> Please take the necessary actions to resolve the {colors.red}ERROR{colors.reset}.",
        )
        return 1

    except Exception as e:
        print(
            f"  ---> {colors.red}ERROR{colors.reset}: {e}",
            file=sys.stderr,
        )
        print(
            f"  ---> This is an unexpected error coming from the script itself.",
            file=sys.stderr,
        )
        return 1


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3

import os
import subprocess
import sys
from functools import reduce

DEFAULT_BRANCH_NAME = "main"
ASSETS_DIR_NAME = "assets"
WITH_PRE_COMMIT = True
MAX_COMMIT_MESSAGE_LENGTH = 70
UPDATE_ASSETS_COMMIT_MESSAGE = "Update assets"

PathLike = os.PathLike[str] | str


class AnsiColors:
    gray: str = "\033[30m"
    red: str = "\033[31m"
    blue: str = "\033[34m"
    reset: str = "\033[0m"


colors = AnsiColors()


class CommandError(Exception):
    cmd: list[str]
    output: str
    returncode: int
    cwd: PathLike | None

    def __init__(
        self,
        cmd: list[str],
        output: str,
        returncode: int,
        cwd: PathLike | None = None,
    ) -> None:
        self.cmd = cmd
        self.output = output
        self.returncode = returncode
        self.cwd = cwd
        super().__init__(
            f"Command failed with exit code {returncode} in directory: {cwd}",
        )


class GitNotFoundError(Exception):
    """Raised when git or git-lfs is not installed"""

    def __init__(self, command: str) -> None:
        super().__init__(f"{command} is not available. Please install it and try again")


class ActionNeededError(Exception):
    error_message: str
    action_message: str
    parent_exception: Exception | None

    def __init__(
        self,
        error_message: str,
        action_message: str,
        parent_exception: Exception | None = None,
    ) -> None:
        self.error_message = error_message
        self.action_message = action_message
        self.parent_exception = parent_exception
        super().__init__(error_message)


def raise_command_error(
    cmd: list[str],
    output: str,
    code: int,
    cwd: PathLike | None = None,
) -> None:
    raise CommandError(cmd, output, code, cwd)


def print_command_error(e: CommandError) -> None:
    print(f" -> Command: {' '.join(e.cmd)}")
    print(f" -> Command output:")
    if e.output.strip():
        print(e.output)
    print(f" -> Command return status code: {e.returncode}")
    print(f" -> Directory: {e.cwd}")


def run_command(
    cmd: list[str],
    cwd: PathLike | None = None,
    silent: bool = False,
    check: bool = True,
) -> tuple[str, int]:
    if not silent:
        print(f"---> {colors.blue}Running{colors.reset}: {' '.join(cmd)}")

    process = subprocess.run(
        cmd,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    output = os.linesep.join(
        filter(
            None,
            [process.stdout.rstrip(os.linesep), process.stderr.rstrip(os.linesep)],
        ),
    )

    if not silent:
        print(output, end="")

    if not silent and output.strip():
        print(os.linesep)

    if check and process.returncode != 0:
        raise CommandError(cmd, output, process.returncode, cwd)

    return output, process.returncode


def check_required_commands() -> None:
    required_commands = ["git", "git-lfs"]
    if WITH_PRE_COMMIT:
        required_commands.append("pre-commit")

    for cmd in required_commands:
        try:
            _ = subprocess.run([cmd], capture_output=True, check=False)
        except FileNotFoundError as e:
            raise ActionNeededError(
                f"{cmd} command has not been found.",
                f"Install the required commands: {', '.join(required_commands)}",
            ) from e


def get_main_repo_path(cwd: PathLike) -> PathLike:
    output, code = run_command(
        ["git", "rev-parse", "--show-superproject-working-tree"],
        cwd=cwd,
        silent=True,
        check=False,
    )
    if code != 0 or output == "":
        output, _ = run_command(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=cwd,
            silent=True,
        )
    return output


def check_current_branch(main_repo_path: PathLike) -> None:
    output, _ = run_command(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=main_repo_path,
        silent=True,
    )
    if output == DEFAULT_BRANCH_NAME:
        raise ActionNeededError(
            "You are on the main branch. We don't want to make changes to the main branch directly.",
            "Please switch to a different branch before proceeding.",
        )


def check_staged_changes_besides_assets(main_repo_path: PathLike) -> None:
    _, code = run_command(
        ["git", "diff", "--cached", "--exit-code", "--", ".", ":(exclude)assets"],
        cwd=main_repo_path,
        silent=True,
        check=False,
    )
    if code != 0:
        raise ActionNeededError(
            "There are already staged changes besides the assets directory. Let's commit assets updates separately from other changes.",
            "Unstage the changes besides the assets directory or stash them.",
        )


def update_assets_submodule(main_repo_path: PathLike) -> None:
    _ = run_command(
        ["git", "submodule", "update", "--init"],
        cwd=main_repo_path,
    )


def build_names_summary(names: list[str], max_length: int, delimiter: str) -> str:
    def will_fit(current: str, next_name: str) -> bool:
        return len(current) + len(delimiter) + len(next_name) <= max_length

    def join_names(acc: str, name: str) -> str:
        return f"{acc}{delimiter}{name}" if will_fit(acc, name) else acc

    assets_list: str = reduce(join_names, names, "").lstrip(delimiter)
    needs_ellipsis = len(delimiter.join(names)) > max_length

    return f"{assets_list}{delimiter}..." if needs_ellipsis else assets_list


def update_assets_repository(assets_repo_path: PathLike) -> str | None:
    current_branch, _ = run_command(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=assets_repo_path,
        silent=True,
    )

    if current_branch == "HEAD":
        _ = run_command(
            ["git", "switch", DEFAULT_BRANCH_NAME],
            cwd=assets_repo_path,
        )

    _ = run_command(
        ["git", "fetch", "origin", DEFAULT_BRANCH_NAME],
        cwd=assets_repo_path,
    )

    try:
        _ = run_command(
            ["git", "rebase", f"origin/{DEFAULT_BRANCH_NAME}"],
            cwd=assets_repo_path,
        )
    except CommandError as e:
        raise ActionNeededError(
            "Could not rebase the assets repository.",
            "Please pull the remote changes from the assets repository manually. This may involve resolving conflicts.",
            parent_exception=e,
        ) from e

    status_output, _ = run_command(
        ["git", "status", "--porcelain"],
        cwd=assets_repo_path,
        silent=True,
    )

    if not status_output:
        print()
        print("---> The assets repository is up to date.")
        print("---> There are no changes in the assets directory to commit.")
        return None

    added_assets_names = [
        line[3:].split("/")[-1]
        for line in status_output.splitlines()
        if not line.startswith(" D") and not line.endswith(".import")
    ]

    commit_message = UPDATE_ASSETS_COMMIT_MESSAGE
    if added_assets_names:
        file_names_summary = build_names_summary(
            added_assets_names, MAX_COMMIT_MESSAGE_LENGTH - len(commit_message), ", "
        )

        commit_message = f"{commit_message}: {file_names_summary}"

    _ = run_command(["git", "add", "."], cwd=assets_repo_path)

    _ = run_command(
        ["git", "commit", "-m", commit_message],
        cwd=assets_repo_path,
    )

    _, code = run_command(
        ["git", "push", "origin", f"HEAD:{DEFAULT_BRANCH_NAME}"],
        cwd=assets_repo_path,
        check=False,
    )
    if code != 0:
        print(
            "---> ERROR: Failed to push assets changes to assets repository.",
        )

    return commit_message


def commit_assets_to_main_repository(
    main_repo_path: PathLike, commit_message: str
) -> None:
    _ = run_command(["git", "add", ASSETS_DIR_NAME], cwd=main_repo_path)
    _ = run_command(
        ["git", "commit", "-m", commit_message],
        cwd=main_repo_path,
    )


def enable_ansi_colors() -> None:
    if os.name == "nt":
        _ = subprocess.call("", shell=True)


def are_pre_commit_hooks_installed(repo_path: PathLike) -> bool:
    pre_commit_hook_path = os.path.join(repo_path, ".git", "hooks", "pre-commit")
    return os.path.isfile(pre_commit_hook_path)


def check_pre_commit_hooks_installed(repo_path: PathLike) -> None:
    if not WITH_PRE_COMMIT:
        return

    if are_pre_commit_hooks_installed(repo_path):
        return

    _ = run_command(
        ["pre-commit", "install"],
        cwd=repo_path,
    )


def main() -> int:
    try:
        enable_ansi_colors()
        check_required_commands()

        script_dir = os.path.dirname(os.path.abspath(__file__))
        main_repo_path = get_main_repo_path(script_dir)
        assets_repo_path = os.path.join(main_repo_path, ASSETS_DIR_NAME)

        print(f"---> Running commands in {main_repo_path}")

        update_assets_submodule(main_repo_path)

        check_pre_commit_hooks_installed(main_repo_path)
        check_current_branch(main_repo_path)

        print(f"---> Running commands in {assets_repo_path}")

        check_pre_commit_hooks_installed(assets_repo_path)
        commit_message = update_assets_repository(assets_repo_path)
        if not commit_message:
            return 0

        print(f"---> Running commands in {main_repo_path}")

        check_staged_changes_besides_assets(main_repo_path)
        commit_assets_to_main_repository(main_repo_path, commit_message)

        print(
            "---> Changes in the assets repository should be pushed. The assets repository should now contain your changes."
        )
        print(
            "---> A new commit in the main repo has been created to update the reference of the assets git submodule with your changes."
        )
        print(f"---> The new commit message: {commit_message}")
        print(
            '---> You can change the commit message with: git commit --amend -m "Update assets: Add a plethora of images"'
        )

        return 0

    except CommandError as e:
        print(f"{colors.gray}--------------------------------{colors.reset}")
        print(
            f"---> {colors.red}ERROR{colors.reset}: An error occurred while running a git command.",
        )
        print_command_error(e)
        print(
            f"---> Please analyze the {colors.red}ERROR{colors.reset} above. Use the command output to determine the cause of the error. You may need to resolve the error manually through git.",
        )
        return 1

    except ActionNeededError as e:
        print(f"{colors.gray}--------------------------------{colors.reset}")
        print(
            f"---> {colors.red}ERROR{colors.reset}: {e.error_message}",
        )
        print(
            f"---> {colors.red}ACTION REQUIRED{colors.reset}: {e.action_message}",
        )
        if isinstance(e.parent_exception, CommandError):
            print("---> This error originated from a failed git command.")
            print_command_error(e.parent_exception)
        print(
            f"---> Please take the necessary actions to resolve the {colors.red}ERROR{colors.reset}.",
        )
        return 1

    except Exception as e:
        print(f"{colors.gray}--------------------------------{colors.reset}")
        print(
            f"---> {colors.red}ERROR{colors.reset}: {e}",
        )
        print(
            f"---> This is an unexpected error coming from the script itself.",
        )
        return 1


if __name__ == "__main__":
    sys.exit(main())
