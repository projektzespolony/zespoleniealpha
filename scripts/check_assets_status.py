#!/usr/bin/env python3

import subprocess
import sys

EXIT_SUCCESS: int = 0
EXIT_FAILURE: int = 1

ERROR_UNCOMMITTED_CHANGES: str = (
    "---> ERROR: Assets directory contains uncommitted changes."
)
ERROR_COMMIT_INSTRUCTIONS: str = (
    "---> ACTION REQUIRED: Please commit your changes in the assets directory first.\n"
    "---> You can use the update_assets script to commit your changes to both the assets submodule and the main repository automatically.\n"
    "---> Run the script with the command: python scripts/update_assets.py"
)


def check_assets_status() -> int:
    try:
        result = subprocess.run(
            ["git", "status", "--porcelain", "assets"],
            capture_output=True,
            text=True,
            check=True,
        )
        changes = result.stdout.strip()

        if changes:
            print(ERROR_UNCOMMITTED_CHANGES)
            print(ERROR_COMMIT_INSTRUCTIONS)
            return EXIT_FAILURE

        return EXIT_SUCCESS

    except subprocess.CalledProcessError as e:
        print(f"---> ERROR: Failed to check assets status: {e}")
        return EXIT_FAILURE


if __name__ == "__main__":
    sys.exit(check_assets_status())
