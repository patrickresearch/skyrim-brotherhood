#!/usr/bin/env python3
"""Dialogue lint for Night's Harvest (docs/DIALOGUE.md).

Checks every dialogue/*.csv file for:
  - correct header (11 columns, exact order)
  - LineID uniqueness across ALL files
  - NPC lines <= 25 words, player lines <= 80 characters
  - Emotion from the fixed list, Value 0-100
  - VoiceType matches Speaker (custom -> NHV_Voice..., vanilla -> Vanilla,
    Generic -> ALL, Player/Journal/Book -> "-")
  - duplicate identical Text within the same Quest
  - UTF-8 without BOM

Not yet implemented (documented limitation, see README below):
  - spelling (only if the optional `pyspellchecker` package is installed;
    project terms in tools/wordlist.txt are always accepted)
  - CK-export comparison (needs a CK dialogue export, not available before M1)

Usage:
    python tools/dialogue_lint.py dialogue/
    python tools/dialogue_lint.py dialogue/ --ck-export path/to/export.csv

Exit code 0 if only warnings, 1 if at least one error.
"""

import argparse
import csv
import re
import sys
from collections import defaultdict
from pathlib import Path

HEADER = ["LineID", "Quest", "Stage", "Topic", "Speaker", "VoiceType",
          "Emotion", "Value", "Text", "Conditions", "Notes"]
EMOTIONS = {"Neutral", "Anger", "Disgust", "Fear", "Sad", "Happy", "Surprise", "Puzzled"}
NON_VOICED_SPEAKERS = {"Player", "Journal", "Book"}
# Known speakers so far; extend as new recruits/NPCs are written (docs/CONVENTIONS.md VoiceType pattern).
CUSTOM_VOICED_SPEAKERS = {"Veyra", "Hrefna"}
VANILLA_SPEAKERS = {"Nazir", "Babette", "Cicero", "NightMother"}
LINEID_RE = re.compile(r"^NHV_(?:[A-Za-z0-9]+_\d{3}_\d{2}|SYS_[A-Za-z0-9]+_\d+)$")


def load_wordlist(path: Path) -> set:
    if not path.exists():
        return set()
    return {w.strip().lower() for w in path.read_text(encoding="utf-8").splitlines() if w.strip() and not w.startswith("#")}


def check_file(path: Path, errors: list, warnings: list, all_ids: dict, quest_texts: dict):
    raw = path.read_bytes()
    if raw.startswith(b"\xef\xbb\xbf"):
        errors.append(f"{path}: Datei hat eine UTF-8-BOM, docs/CONVENTIONS.md verlangt UTF-8 ohne BOM")
        raw = raw[3:]
    text = raw.decode("utf-8")
    reader = csv.reader(text.splitlines())
    rows = list(reader)
    if not rows:
        errors.append(f"{path}: Datei ist leer")
        return
    header = rows[0]
    if header != HEADER:
        errors.append(f"{path}: Kopfzeile stimmt nicht. Erwartet {HEADER}, gefunden {header}")
        return
    for i, row in enumerate(rows[1:], start=2):
        if len(row) != len(HEADER):
            errors.append(f"{path}:{i}: {len(row)} Spalten statt {len(HEADER)}")
            continue
        line_id, quest, stage, topic, speaker, voice, emotion, value, txt, cond, notes = row

        if not LINEID_RE.match(line_id):
            warnings.append(f"{path}:{i}: LineID '{line_id}' passt nicht zum Muster aus docs/DIALOGUE.md")
        if line_id in all_ids:
            errors.append(f"{path}:{i}: LineID '{line_id}' bereits vergeben in {all_ids[line_id]}")
        else:
            all_ids[line_id] = f"{path}:{i}"

        if emotion not in EMOTIONS:
            errors.append(f"{path}:{i}: Emotion '{emotion}' nicht in der erlaubten Liste {sorted(EMOTIONS)}")
        try:
            v = int(value)
            if not (0 <= v <= 100):
                errors.append(f"{path}:{i}: Value {value} außerhalb 0-100")
        except ValueError:
            errors.append(f"{path}:{i}: Value '{value}' ist keine Zahl")

        if speaker == "Player":
            if len(txt) > 80:
                errors.append(f"{path}:{i}: Spielerzeile hat {len(txt)} Zeichen (> 80): \"{txt[:50]}...\"")
        elif speaker not in ("Journal", "Book"):
            words = len(txt.split())
            if words > 25:
                errors.append(f"{path}:{i}: NPC-Zeile hat {words} Woerter (> 25): \"{txt[:50]}...\"")

        if speaker in NON_VOICED_SPEAKERS:
            if voice != "-":
                warnings.append(f"{path}:{i}: Speaker '{speaker}' erwartet VoiceType '-', gefunden '{voice}'")
        elif speaker in CUSTOM_VOICED_SPEAKERS:
            if not voice.startswith("NHV_Voice"):
                errors.append(f"{path}:{i}: Speaker '{speaker}' (eigene Figur) braucht VoiceType NHV_Voice..., gefunden '{voice}'")
        elif speaker in VANILLA_SPEAKERS:
            if voice != "Vanilla":
                errors.append(f"{path}:{i}: Speaker '{speaker}' (Vanilla-Figur) braucht VoiceType 'Vanilla', gefunden '{voice}'")
        elif speaker == "Generic":
            if voice != "ALL":
                errors.append(f"{path}:{i}: Speaker 'Generic' braucht VoiceType 'ALL', gefunden '{voice}'")
        else:
            warnings.append(f"{path}:{i}: unbekannter Speaker '{speaker}' - Registry in tools/dialogue_lint.py ergaenzen, falls neu")

        key = (quest, txt.strip())
        if key in quest_texts:
            warnings.append(f"{path}:{i}: Text identisch mit {quest_texts[key]} innerhalb Quest '{quest}': \"{txt[:50]}...\"")
        else:
            quest_texts[key] = f"{path}:{i}"


def check_spelling(files: list, wordlist: set, warnings: list):
    try:
        from spellchecker import SpellChecker  # type: ignore
    except ImportError:
        warnings.append("Rechtschreibpruefung uebersprungen: Paket 'pyspellchecker' nicht installiert (optional, siehe Kopfkommentar).")
        return
    checker = SpellChecker(language="en")
    checker.word_frequency.load_words(wordlist)
    word_re = re.compile(r"[A-Za-z']+")
    for path in files:
        rows = list(csv.reader(path.read_text(encoding="utf-8").splitlines()))
        for i, row in enumerate(rows[1:], start=2):
            if len(row) != len(HEADER):
                continue
            txt = row[8]
            words = [w.lower() for w in word_re.findall(txt)]
            unknown = checker.unknown(words)
            unknown = {w for w in unknown if w not in wordlist}
            if unknown:
                warnings.append(f"{path}:{i}: moegliche Tippfehler {sorted(unknown)}: \"{txt[:50]}...\"")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("directory", type=Path, help="Ordner mit den dialogue/*.csv Dateien")
    ap.add_argument("--ck-export", type=Path, default=None, help="Optional: CK-Export zum Abgleich der LineIDs (noch nicht implementiert)")
    ap.add_argument("--wordlist", type=Path, default=None, help="Wortliste fuer Tamriel-Begriffe (Default: tools/wordlist.txt)")
    args = ap.parse_args()

    files = sorted(args.directory.glob("*.csv"))
    if not files:
        print(f"Keine .csv-Dateien in {args.directory} gefunden.")
        return 1

    errors: list = []
    warnings: list = []
    all_ids: dict = {}
    quest_texts: dict = {}
    for f in files:
        check_file(f, errors, warnings, all_ids, quest_texts)

    wordlist_path = args.wordlist or (Path(__file__).parent / "wordlist.txt")
    check_spelling(files, load_wordlist(wordlist_path), warnings)

    if args.ck_export:
        warnings.append("--ck-export ist noch nicht implementiert (kein CK-Export vor M1 verfuegbar).")

    print(f"Geprueft: {len(files)} Dateien, {len(all_ids)} LineIDs.")
    for w in warnings:
        print(f"WARNUNG  {w}")
    for e in errors:
        print(f"FEHLER   {e}")
    print(f"\n{len(errors)} Fehler, {len(warnings)} Warnungen.")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
