#!/usr/bin/env python3
"""Report CSV LineIDs that do not exist in plugin-text/DialogTopics (responses via ScriptNotes, prompts via prompt=).

Usage: python tools/lineid_check.py dialogue/Sanctuary.csv [dialogue/Lucien.csv ...]
Exit code 1 if anything is missing. Complements csv_to_plugin.py --check, which only compares lines that already exist.
"""

import csv
import glob
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent


def main(paths):
    text = "".join(Path(f).read_text(encoding="utf-8") for f in
                   glob.glob(str(REPO / "plugin-text" / "DialogTopics" / "**" / "*.yaml"), recursive=True))
    bad = 0
    for fn in paths:
        rows = list(csv.DictReader(open(fn, encoding="utf-8-sig", newline="")))
        miss = [r["LineID"] for r in rows if r["LineID"] not in text]
        bad += len(miss)
        print(f"{fn}: {len(rows)} lines, {len(miss)} missing {miss[:60]}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
