#!/usr/bin/env python3
"""Create or update the GitHub labels of the project from .github/labels.json.

Idempotent: `gh label create --force` updates labels that already exist.
Requires the GitHub CLI (`gh`), logged in, run inside the cloned repository.
The GitHub Project board (columns Backlog -> Bereit -> In Arbeit -> Test -> Fertig)
is created by hand in the GitHub UI, see README.md.

Usage:
    python tools/github_setup.py [--dry-run]
"""

import json
import subprocess
import sys
from pathlib import Path

LABELS_FILE = Path(__file__).resolve().parent.parent / ".github" / "labels.json"


def main() -> int:
    dry_run = "--dry-run" in sys.argv[1:]
    labels = json.loads(LABELS_FILE.read_text(encoding="utf-8"))
    for label in labels:
        cmd = [
            "gh", "label", "create", label["name"],
            "--color", label["color"],
            "--description", label.get("description", ""),
            "--force",
        ]
        print(" ".join(cmd) if dry_run else f"label {label['name']}")
        if dry_run:
            continue
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(result.stderr.strip(), file=sys.stderr)
            return result.returncode
    return 0


if __name__ == "__main__":
    sys.exit(main())
