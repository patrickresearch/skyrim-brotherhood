#!/usr/bin/env python3
"""Keep the dialogue texts in plugin-text/ in line with the CSV master script (Rule 4: dialogue/*.csv is the source).

Every NPC response in an INFO carries its LineID in ScriptNotes ("NHV_Q00_010_11"); the player prompt of the INFO
is linked through the first response's ScriptNotes ("NHV_Q00_010_11 prompt=NHV_Q00_010_10"). This tool

  --backfill REF   links responses/prompts that have no LineID yet by exact text against the CSVs at git ref REF
                   (the CSV state the plugin texts were built from), then
  (default)        copies the current CSV texts into plugin-text/ and reports what changed,
  --check          only reports differences (exit 1 if any).

Afterwards: tools/plugin_text.ps1 -Direction ToPlugin, python tools/silent_voice.py (subtitle durations).
"""

import argparse
import csv
import glob
import io
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
LINEID = re.compile(r"^NHV_(?:[A-Za-z0-9]+_\d{3}_\d{2,3}|SYS_[A-Za-z0-9]+_\d+)$")


def csv_rows(texts):
    rows = {}
    for text in texts:
        for r in csv.DictReader(io.StringIO(text)):
            if r.get("LineID"):
                rows[r["LineID"]] = r
    return rows


def current_rows():
    return csv_rows(p.read_text(encoding="utf-8") for p in (REPO / "dialogue").glob("*.csv"))


def rows_at(ref):
    names = subprocess.run(["git", "ls-tree", "--name-only", ref, "dialogue/"], cwd=REPO, capture_output=True,
                           text=True, check=True).stdout.split()
    texts = [subprocess.run(["git", "show", f"{ref}:{n}"], cwd=REPO, capture_output=True, text=True,
                            encoding="utf-8", check=True).stdout for n in names if n.endswith(".csv")]
    return csv_rows(texts)


def unquote(v):
    v = v.strip()
    if v.startswith("'") and v.endswith("'"):
        return v[1:-1].replace("''", "'")
    if v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    return v


def quote(text):
    return "'" + text.replace("'", "''") + "'"


RESP = re.compile(r"(?m)^(    Value: )(.*)\n(  ScriptNotes: )(.*)$")
PROMPT = re.compile(r"(?m)^(Prompt:\n  TargetLanguage: \w+\n  Value: )(.*)$")


def parse_notes(notes):
    notes = unquote(notes)
    lid = notes.split(" ")[0] if notes else ""
    prompt = re.search(r"prompt=(\S+)", notes)
    return (lid if LINEID.match(lid) else ""), (prompt.group(1) if prompt else ""), notes


def backfill(ref):
    old = rows_at(ref)
    by_text = {}
    for lid, r in old.items():
        by_text.setdefault(r["Text"].strip(), []).append(lid)
    linked = ambiguous = 0
    for p in glob.glob(str(REPO / "plugin-text/DialogTopics/*/Responses/*.yaml")):
        s = Path(p).read_text(encoding="utf-8")
        orig = s

        def fix(m):
            nonlocal linked, ambiguous
            lid, prompt, notes = parse_notes(m.group(4))
            if lid:
                return m.group(0)
            cands = by_text.get(unquote(m.group(2)).strip(), [])
            if len(cands) != 1:
                ambiguous += bool(cands)
                return m.group(0)
            linked += 1
            new = cands[0] + (" " + notes if notes else "")
            return f"{m.group(1)}{m.group(2)}\n{m.group(3)}{quote(new)}"

        s = RESP.sub(fix, s)
        pm = PROMPT.search(s)
        first = RESP.search(s)
        if pm and first:
            lid, prompt, notes = parse_notes(first.group(4))
            cands = by_text.get(unquote(pm.group(2)).strip(), [])
            if not prompt and len(cands) == 1:
                new_notes = (notes + " " if notes else "") + f"prompt={cands[0]}"
                s = s[:first.start(4)] + quote(new_notes) + s[first.end(4):]
                linked += 1
        if s != orig:
            Path(p).write_text(s, encoding="utf-8", newline="\n")
    print(f"backfill against {ref}: {linked} link(s) added, {ambiguous} ambiguous text(s) skipped")


def sync(check_only):
    rows = current_rows()
    changes, missing, unlinked = [], [], 0
    for p in glob.glob(str(REPO / "plugin-text/DialogTopics/*/Responses/*.yaml")):
        s = Path(p).read_text(encoding="utf-8")
        orig = s

        def fix(m):
            nonlocal unlinked
            lid, _prompt, _notes = parse_notes(m.group(4))
            if not lid:
                unlinked += 1
                return m.group(0)
            if lid not in rows:
                missing.append(lid)
                return m.group(0)
            want = rows[lid]["Text"].strip()
            if unquote(m.group(2)) != want:
                changes.append((lid, unquote(m.group(2)), want))
                return f"{m.group(1)}{quote(want)}\n{m.group(3)}{m.group(4)}"
            return m.group(0)

        s = RESP.sub(fix, s)
        first = RESP.search(s)
        pm = PROMPT.search(s)
        if first and pm:
            _lid, prompt, _notes = parse_notes(first.group(4))
            if prompt:
                if prompt not in rows:
                    missing.append(prompt)
                else:
                    want = rows[prompt]["Text"].strip()
                    if unquote(pm.group(2)) != want:
                        changes.append((prompt, unquote(pm.group(2)), want))
                        s = s[:pm.start(2)] + quote(want) + s[pm.end(2):]
        if s != orig and not check_only:
            Path(p).write_text(s, encoding="utf-8", newline="\n")
    for lid, old, new in changes:
        print(f"{'DIFF' if check_only else 'UPDATED'} {lid}\n    old: {old}\n    new: {new}")
    for lid in sorted(set(missing)):
        print(f"MISSING {lid}: in the plugin, not in any CSV")
    print(f"{len(changes)} text(s) {'differ' if check_only else 'updated'}, {len(set(missing))} missing, "
          f"{unlinked} response(s) without LineID")
    return 1 if (check_only and changes) or missing else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--backfill", metavar="REF")
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    if args.backfill:
        backfill(args.backfill)
    return sync(args.check)


if __name__ == "__main__":
    sys.exit(main())
