#!/usr/bin/env python3
"""Import real voice recordings (ElevenLabs, xVASynth, ...) as .fuz files for Night's Harvest.

Input: audio files (mp3/wav/ogg/flac) whose file name contains the CSV LineID, e.g.
    voice_in/NHV_Q00_010_92.mp3   or   voice_in/Veyra - NHV_Q00_010_92 - take2.mp3
The LineID is looked up in plugin-text (response ScriptNotes, written by tools/csv_to_plugin.py) to get
the subtitle text and every engine path of that response (same naming as tools/silent_voice.py).

Per file:  ffmpeg -> 16-bit mono 44.1 kHz WAV -> LipGenerator (CK, lip sync from WAV + text)
           -> xWMAEncode -> .fuz (FUZE v1: lip + xWMA) at every target path.
The target paths are removed from silent_voice.manifest, so tools/silent_voice.py treats them as real
recordings from now on and never overwrites them. Delete a .fuz to go back to the silent file.

Tools come from the dev copy (docs/ENVIRONMENT.md); nothing is written outside the repository.

Usage:
    python tools/voice_import.py                      # import everything in voice_in/
    python tools/voice_import.py --in D:/eleven/veyra  # other input folder
    python tools/voice_import.py --check               # show what would be written, write nothing
    python tools/voice_import.py --list NHV_Q00_010    # list LineIDs (prefix) with speaker/voice type/text
"""
import argparse
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import silent_voice as sv  # noqa: E402  (shared naming rules)

TOOLS = Path(r"C:\Dev\brotherhood-devenv\SkyrimSE-Dev\Tools")
FFMPEG = TOOLS / "LipGen" / "LipGenerator" / "ffmpeg.exe"
LIPGEN = TOOLS / "LipGen" / "LipGenerator" / "LipGenerator.exe"
XWMA = TOOLS / "Audio" / "xwmaencode.exe"
AUDIO_EXT = {".mp3", ".wav", ".ogg", ".flac", ".m4a"}
LINE_ID = re.compile(r"NHV_[A-Z0-9]+_\d{3}_\d{2,3}")
# Automatic ffmpeg effects per voice type (disable with --no-fx). The Night Mother speaks from the coffin:
# a short dark echo plus slight muffling, close to her vanilla lines.
FX_BY_VOICE = {
    "FemaleUniqueNightMother": "aecho=0.8:0.55:55|110:0.35|0.22,lowpass=f=7000,volume=1.15",
}


def response_items(text):
    """[(ResponseNumber, subtitle, LineID)] of an INFO."""
    m = re.search(r"^Responses:\n((?:[- ] .*\n?)+)", text, re.M)
    if not m:
        return []
    out = []
    for item in re.split(r"(?m)^(?=- )", m.group(1)):
        if not item.strip():
            continue
        num = re.search(r"(?m)^(?:- |  )ResponseNumber: (\d+)", item)
        note = re.search(r"(?m)^  ScriptNotes: (\S+)", item)
        lines = item.split("\n")
        value = ""
        for i, line in enumerate(lines):
            vm = re.match(r"^    Value: (.*)$", line)
            if vm and i > 0 and lines[i - 1].strip().startswith("TargetLanguage"):
                value = sv.scalar(vm.group(1), lines[i + 1:])
                break
        if note and LINE_ID.fullmatch(note.group(1)):
            out.append((int(num.group(1)) if num else 0, value or "", note.group(1)))
    return out


def index_lines():
    """LineID -> {"text", "paths": [voice-relative .fuz paths], "where"}."""
    quests, voices = sv.load_quests(), sv.load_voice_types()
    idx = {}
    for topic_dir in sorted((sv.TEXT / "DialogTopics").iterdir()):
        rec = topic_dir / "RecordData.yaml"
        if not rec.exists():
            continue
        t = sv.read(rec)
        topic_edid = sv.top_value(t, "EditorID") or ""
        quest_edid = quests.get(sv.top_value(t, "Quest"))
        if not quest_edid:
            continue
        for info_file in sorted((topic_dir / "Responses").glob("*.yaml")):
            it = sv.read(info_file)
            info_key = sv.top_value(it, "FormKey")
            speaker = sv.top_value(it, "Speaker")
            cands = [speaker] if speaker else re.findall(r"GetIsIDConditionData\n\s+Object: (\S+)", it)
            vts = sorted({voices[c] for c in cands if c in voices})
            for num, text, lid in response_items(it):
                paths = [f"{vt}/{head}_{sv.form_id_part(info_key)}_{num}.fuz"
                         for head in sv.voice_heads(quest_edid, topic_edid) for vt in vts]
                e = idx.setdefault(lid, {"text": text, "paths": [], "where": f"{topic_edid} / INFO {info_key}"})
                e["paths"] += [p for p in paths if p not in e["paths"]]
    return idx


def run(cmd):
    r = subprocess.run([str(c) for c in cmd], capture_output=True, text=True)
    if r.returncode:
        raise RuntimeError(f"{Path(str(cmd[0])).name} failed ({r.returncode}): {r.stdout[-400:]} {r.stderr[-400:]}")
    return r


def make_fuz(src, text, tmp, af=None):
    wav, lip, xwm = tmp / "line.wav", tmp / "line.lip", tmp / "line.xwm"
    for f in (wav, lip, xwm):
        if f.exists():
            f.unlink()
    run([FFMPEG, "-y", "-loglevel", "error", "-i", src] + (["-af", af] if af else []) +
        ["-ac", "1", "-ar", str(sv.SAMPLE_RATE), "-sample_fmt", "s16", wav])
    lip_data = b""
    try:
        run([LIPGEN, wav, text, f"-OutputFileName:{lip}"])
        if lip.exists():
            lip_data = lip.read_bytes()
    except RuntimeError as e:  # a missing lip file is not fatal: the line plays, the mouth just stays still
        print(f"  WARN lip: {e}")
    if not lip_data:
        print("  WARN no .lip generated (mouth will not move)")
    run([XWMA, wav, xwm])
    return b"FUZE" + struct.pack("<II", 1, len(lip_data)) + lip_data + xwm.read_bytes()


def drop_from_manifest(paths):
    man = sv.read_manifest()
    changed = [p for p in paths if p in man]
    for p in changed:
        del man[p]
    if changed:
        (sv.OUT / sv.MANIFEST).write_text("".join(f"{k}\t{v}\n" for k, v in sorted(man.items())),
                                          encoding="utf-8", newline="\n")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--in", dest="src", type=Path, default=sv.REPO / "voice_in", help="input folder")
    ap.add_argument("--check", action="store_true", help="report only")
    ap.add_argument("--no-fx", action="store_true", help="no automatic voice-type effects (FX_BY_VOICE)")
    ap.add_argument("--list", metavar="PREFIX", help="list LineIDs starting with PREFIX")
    ap.add_argument("--from-text", metavar="DIR", type=Path, action="append",
                    help="copy audio files named after their TEXT (xVASynth default output, cut at ~70 chars) "
                         "into the input folder as <LineID>.<ext>; repeatable")
    ap.add_argument("--export", metavar="DIR", type=Path,
                    help="write one <VoiceType>.csv (LineID,Text,Missing) per voice type into DIR, for xVASynth/ElevenLabs")
    args = ap.parse_args()

    idx = index_lines()
    if args.from_text:
        import shutil
        norm = lambda s: re.sub(r"[^a-z0-9]+", " ", s.lower()).strip()
        texts = [(lid, norm(e["text"])) for lid, e in idx.items() if e["paths"]]
        args.src.mkdir(parents=True, exist_ok=True)
        copied = unmatched = 0
        for d in args.from_text:
            for f in sorted(d.glob("*")):
                if f.suffix.lower() not in AUDIO_EXT or f.stem.startswith("temp-"):
                    continue
                key = norm(f.stem)
                hits = sorted({lid for lid, t in texts if key and t.startswith(key)})
                if len(hits) != 1:
                    print(f"NOMATCH {f.name}: " + ("no line with this text" if not hits else "ambiguous: " + ", ".join(hits)))
                    unmatched += 1
                    continue
                shutil.copy2(f, args.src / f"{hits[0]}{f.suffix.lower()}")
                print(f"COPY    {f.name} -> {hits[0]}{f.suffix.lower()}")
                copied += 1
        print(f"{copied} copied to {args.src}, {unmatched} unmatched")
        return 1 if unmatched else 0
    if args.export is not None:
        import csv
        args.export.mkdir(parents=True, exist_ok=True)
        man = sv.read_manifest()
        by_vt = {}
        for lid, e in idx.items():
            for vt in sorted({p.split("/")[0] for p in e["paths"]}):
                # "yes" = still silent (no real recording imported yet)
                silent = any(p in man for p in e["paths"] if p.startswith(vt + "/"))
                by_vt.setdefault(vt, []).append((lid, e["text"], "yes" if silent else "no"))
        for vt, rows in sorted(by_vt.items()):
            with open(args.export / f"{vt}.csv", "w", encoding="utf-8", newline="") as fh:
                w = csv.writer(fh)
                w.writerow(["LineID", "Text", "Missing"])
                w.writerows(sorted(rows))
            print(f"{vt}: {len(rows)} line(s) -> {args.export / (vt + '.csv')}")
        return 0
    if args.list is not None:
        for lid in sorted(k for k in idx if k.startswith(args.list)):
            e = idx[lid]
            vts = sorted({p.split("/")[0] for p in e["paths"]})
            print(f"{lid}\t{','.join(vts)}\t{e['text']}")
        return 0

    missing_tools = [t for t in (FFMPEG, LIPGEN, XWMA) if not t.exists()]
    if missing_tools and not args.check:
        print("Missing tools: " + ", ".join(map(str, missing_tools)), file=sys.stderr)
        return 1
    files = sorted(f for f in args.src.glob("*") if f.suffix.lower() in AUDIO_EXT) if args.src.exists() else []
    if not files:
        print(f"No audio files in {args.src}")
        return 1
    ok = bad = 0
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        for f in files:
            m = LINE_ID.search(f.stem)
            e = idx.get(m.group(0)) if m else None
            if not e or not e["paths"]:
                print(f"SKIP  {f.name}: " + ("no LineID in name" if not m else f"{m.group(0)} not in plugin"))
                bad += 1
                continue
            print(f"{'CHECK' if args.check else 'OK   '} {f.name} -> {m.group(0)} ({len(e['paths'])} file(s)): {e['text'][:70]}")
            if args.check:
                ok += 1
                continue
            vts = {p.split("/")[0] for p in e["paths"]}
            fx = None if args.no_fx else next((FX_BY_VOICE[v] for v in vts if v in FX_BY_VOICE), None)
            if fx:
                print(f"  fx: {fx}")
            try:
                data = make_fuz(f, e["text"], tmp, fx)
            except RuntimeError as err:
                print(f"  ERROR {err}")
                bad += 1
                continue
            for rel in e["paths"]:
                target = sv.OUT / rel
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
            drop_from_manifest(e["paths"])
            ok += 1
    print(f"{ok} imported{' (check only)' if args.check else ''}, {bad} skipped/failed")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
