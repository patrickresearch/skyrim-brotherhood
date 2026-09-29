#!/usr/bin/env python3
"""Export the current Q01 dialogue, journal, and book rows to a readable Markdown file."""

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "dialogue" / "Q01-Gesamtdialoge-2026-09-28.md"


def read_csv(path, predicate):
    with path.open(encoding="utf-8", newline="") as handle:
        return [row for row in csv.DictReader(handle) if predicate(row)]


dialogue = read_csv(ROOT / "dialogue" / "Q01.csv", lambda row: row["Quest"] == "Q01")
journal = read_csv(ROOT / "dialogue" / "Journal.csv", lambda row: row["Quest"] == "Q01")
books = read_csv(ROOT / "dialogue" / "Books.csv", lambda row: row["Quest"] == "Q01")

stages = sorted({row["Stage"] for row in dialogue}, key=lambda value: int(value))
lines = ["# Q01 – The Unanswered Sacrament: Gesamtdialoge", "", "Automatisch aus den CSV-Mastern erzeugt. Ingame-Texte bleiben englisch; Notes und Conditions dienen dem CK-Einbau.", ""]
for stage in stages:
    lines.extend([f"## Stage {stage}", ""])
    for row in [item for item in dialogue if item["Stage"] == stage]:
        lines.extend([
            f"### `{row['LineID']}` · {row['Speaker']} · `{row['Topic']}`",
            "",
            f"> {row['Text']}",
            "",
            f"**Conditions:** `{row['Conditions'] or '—'}`  ",
            f"**Notes:** {row['Notes'] or '—'}",
            "",
        ])
lines.extend(["## Journal", ""])
for row in journal:
    lines.extend([f"- `{row['LineID']}` · Stage {row['Stage']}: **{row['Text']}** — {row['Notes'] or '—'}", ""])
lines.extend(["## Q01-Bücher und Dokumente", ""])
for row in books:
    lines.extend([f"### `{row['LineID']}` · `{row['Topic']}`", "", f"> {row['Text']}", "", f"**Notes:** {row['Notes'] or '—'}", ""])

OUT.parent.mkdir(exist_ok=True)
OUT.write_text("\n".join(lines), encoding="utf-8")
print(f"Wrote {len(dialogue)} dialogue lines, {len(journal)} journal rows, and {len(books)} book rows to {OUT}")
