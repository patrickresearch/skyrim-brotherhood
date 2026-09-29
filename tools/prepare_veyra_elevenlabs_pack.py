#!/usr/bin/env python3
"""Build a Veyra ElevenLabs recording/import sheet from the dialogue master."""

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [ROOT / "dialogue" / name for name in ("Q00.csv", "Q01.csv", "Q02.csv", "Sanctuary.csv")]
OUTPUT = ROOT / "dialogue" / "voice" / "Veyra-ElevenLabs.csv"


def direction(topic: str, emotion: str) -> str:
    topic_lower = topic.lower()
    if "standoff" in topic_lower:
        return "Low, measured, almost conversational; keep the threat under the words."
    if "memorial" in topic_lower:
        return "Quiet and grave; leave a small pause before names and after the final thought."
    if "hollow" in topic_lower or "q02" in topic_lower:
        return "Dry, controlled, observant; irony stays cold rather than playful."
    if "sanctuary" in topic_lower or "veyra_" in topic_lower:
        return "Intimate and restrained; sound old without sounding frail."
    return f"Restrained and deliberate; emotion: {emotion.lower()}."


rows = []
for source in SOURCES:
    with source.open(encoding="utf-8", newline="") as handle:
        for row in csv.DictReader(handle):
            if row["Speaker"] != "Veyra":
                continue
            rows.append(
                {
                    "LineID": row["LineID"],
                    "Source": source.name,
                    "Topic": row["Topic"],
                    "Text": row["Text"],
                    "Emotion": row["Emotion"],
                    "Direction": direction(row["Topic"], row["Emotion"]),
                    "Filename": f"{row['LineID']}.wav",
                }
            )

OUTPUT.parent.mkdir(exist_ok=True)
with OUTPUT.open("w", encoding="utf-8", newline="") as handle:
    writer = csv.DictWriter(handle, fieldnames=["LineID", "Source", "Topic", "Text", "Emotion", "Direction", "Filename"])
    writer.writeheader()
    writer.writerows(rows)

print(f"Wrote {len(rows)} Veyra lines to {OUTPUT}")
