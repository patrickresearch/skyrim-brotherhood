#!/usr/bin/env python3
"""Build ElevenLabs preparation sheets for selected vanilla speakers."""

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [ROOT / "dialogue" / name for name in ("Q00.csv", "Q01.csv", "Q02.csv", "Sanctuary.csv")]
SPEAKERS = {
    "Babette": "Babette-ElevenLabs.csv",
    "NightMother": "NightMother-ElevenLabs.csv",
}


def direction(speaker: str, topic: str, emotion: str) -> str:
    if speaker == "Babette":
        if "Memorial" in topic or emotion == "Sad":
            return "Childlike but ancient; keep the sadness matter-of-fact and never sentimental."
        return "Bright, mischievous and precise; the voice is a child, the timing belongs to an immortal assassin."
    if "NM_" in topic or "Night" in topic:
        return "Distant, breath-soft and ceremonial; leave space around names and speak as if from behind stone."
    return "Distant and maternal, with restrained authority; never turn the line into a theatrical shout."


for speaker, filename in SPEAKERS.items():
    rows = []
    for source in SOURCES:
        with source.open(encoding="utf-8", newline="") as handle:
            for row in csv.DictReader(handle):
                if row["Speaker"] != speaker:
                    continue
                rows.append(
                    {
                        "LineID": row["LineID"],
                        "Source": source.name,
                        "Topic": row["Topic"],
                        "Text": row["Text"],
                        "Emotion": row["Emotion"],
                        "Direction": direction(speaker, row["Topic"], row["Emotion"]),
                        "Filename": f"{row['LineID']}.wav",
                    }
                )
    output = ROOT / "dialogue" / "voice" / filename
    with output.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["LineID", "Source", "Topic", "Text", "Emotion", "Direction", "Filename"])
        writer.writeheader()
        writer.writerows(rows)
    print(f"Wrote {len(rows)} {speaker} lines to {output}")
