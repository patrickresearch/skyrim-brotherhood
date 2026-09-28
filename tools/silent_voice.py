#!/usr/bin/env python3
"""Silent voice files for Night's Harvest (E10).

Skyrim only shows a dialogue line for as long as its voice file plays. Without a file, player-topic
responses flash by and scene lines never play at all. This tool writes one silent .fuz per NPC
response, long enough to read the subtitle, so the mod needs neither voice acting nor Fuz Ro D-oh.

Source of truth is plugin-text/ (Spriggit YAML of NightsHarvest.esp): quests, dialogue topics and
their INFOs. For every response it computes the engine's voice path

    Sound/Voice/NightsHarvest.esp/<VoiceType>/<Quest>_<Topic>_<00 + INFO id>_<ResponseNumber>.fuz

with quest and topic EditorID shortened to 25 characters together (see voice_heads(); the plain
"quest 10 + topic 15" rule from UESP and houseCARL is wrong for scene lines without a topic EditorID,
which cost the Standoff scene its voice files on 25.09.2026). The voice type comes from the
INFO's Speaker, otherwise from its GetIsID conditions (one file per possible speaker). A line without
either is an error: the engine picks the folder from the speaking actor, which the tool cannot know.

Audio: 16-bit mono 44.1 kHz silence -> xWMAEncode -> .xwm, wrapped as .fuz without lip data.
Duration: words / wps + 1 s (Fuz Ro D-oh's formula), at least 2 s.

Files the tool did not write (e.g. real recordings later) are never touched; the list of generated
files lives in silent_voice.manifest next to them. Stale generated files are removed.

Usage:
    python tools/silent_voice.py            # generate/update Data/Sound/Voice/NightsHarvest.esp
    python tools/silent_voice.py --check    # only report: expected files, missing, unresolved speakers

Exit code 0 if everything is resolved (and, with --check, present), 1 otherwise.
"""

import argparse
import hashlib
import re
import struct
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLUGIN = "NightsHarvest.esp"
TEXT = REPO / "plugin-text"
OUT = REPO / "Data" / "Sound" / "Voice" / PLUGIN
MANIFEST = "silent_voice.manifest"
DEFAULT_ENCODER = Path(r"C:\Dev\brotherhood-devenv\SkyrimSE-Dev\Tools\Audio\xwmaencode.exe")
SAMPLE_RATE = 44100

# Voice types of the vanilla speakers our lines use, read with houseCARL (Skyrim.esm), 25.09.2026.
# Our own NPCs are resolved from plugin-text/Npcs + plugin-text/VoiceTypes.
VANILLA_VOICES = {
    "01C3AB:Skyrim.esm": "MaleUniqueNazir",          # Nazir
    "01D4B7:Skyrim.esm": "FemaleChild",              # Babette
    "09BCAF:Skyrim.esm": "MaleUniqueCicero",         # CiceroDawnstar (Dawnstar Sanctuary)
    "01BDB1:Skyrim.esm": "MaleUniqueCicero",         # Cicero (Falkreath Sanctuary)
    "022440:Skyrim.esm": "FemaleUniqueNightMother",  # DBNightMotherTalkingActivator
    "03BB85:Skyrim.esm": "FemaleUniqueNightMother",  # DBNightMotherVoiceNPC
}
# Vanilla voice types our own speakers use (VTYP FormKey -> EditorID), read from Skyrim.esm, 26.09.2026.
VANILLA_VOICE_TYPES = {
    "01BDB6:Skyrim.esm": "FemaleUniqueNightMother",
    "074765:Skyrim.esm": "MaleUniqueDBSpectralLachance",  # NHV_LucienSpirit (Spectral Assassin voice), 28.09.2026
}


def read(path):
    return path.read_text(encoding="utf-8").replace("\r\n", "\n")


def top_value(text, key):
    m = re.search(rf"^{key}: (.+)$", text, re.M)
    return m.group(1).strip() if m else None


def scalar(raw, following):
    """YAML scalar as Spriggit writes it: plain, '...' or "..." on one line, or a >-/|- block."""
    raw = raw.strip()
    if raw.startswith("'") and raw.endswith("'"):
        return raw[1:-1].replace("''", "'")
    if raw.startswith('"') and raw.endswith('"'):
        return bytes(raw[1:-1], "utf-8").decode("unicode_escape")
    if raw[:1] in (">", "|"):
        lines = []
        for line in following:
            if line.strip() and not line.startswith("      "):
                break
            lines.append(line.strip())
        return (" " if raw[0] == ">" else "\n").join(l for l in lines if l)
    return raw


def voice_heads(quest, topic):
    """The <Quest>_<Topic> part(s) of a voice file name.

    Rule derived from all 75,408 names in Skyrim - Voices_en0.bsa (25.09.2026): quest and topic share
    25 characters. Without a topic EditorID (scene lines) the quest keeps up to 25
    (relationshipmarriagefin__00002f50_1). If both are long, the quest gets 10 and the topic 15
    (darkbrothe_dbnazirinfodeek); a short quest leaves the rest to the topic (db10_db10nazirsancplayerre).
    A quest over 10 characters with a topic of 1-14 characters and more than 25 in total has no vanilla
    example; both candidates are returned then.
    """
    if len(quest) + len(topic) <= 25:
        return [f"{quest}_{topic}"]
    heads = []
    for qlen in (max(10, 25 - len(topic)), 10 if topic else 25):
        q = quest[:qlen]
        head = f"{q}_{topic[:25 - len(q)]}"
        if head not in heads:
            heads.append(head)
    return heads


def form_id_part(form_key):
    local, _plugin = form_key.split(":", 1)
    return "00" + local.upper()


def load_voice_types():
    voices = dict(VANILLA_VOICES)
    vtypes = dict(VANILLA_VOICE_TYPES)
    for f in (TEXT / "VoiceTypes").glob("*.yaml"):
        t = read(f)
        vtypes[top_value(t, "FormKey")] = top_value(t, "EditorID")
    # Our own speakers: NPCs and talking activators (e.g. NHV_NightMotherVoice) carry a Voice field.
    for folder in ("Npcs", "TalkingActivators"):
        for f in (TEXT / folder).glob("*.yaml"):
            t = read(f)
            voice = top_value(t, "Voice")
            if voice in vtypes:
                voices[top_value(t, "FormKey")] = vtypes[voice]
    return voices


def load_quests():
    quests = {}
    for f in (TEXT / "Quests").glob("*.yaml"):
        t = read(f)
        quests[top_value(t, "FormKey")] = top_value(t, "EditorID")
    return quests


def parse_responses(text):
    """[(ResponseNumber, text)] of the INFO's top-level Responses list."""
    m = re.search(r"^Responses:\n((?:[- ] .*\n?)+)", text, re.M)
    if not m:
        return []
    out = []
    for item in re.split(r"(?m)^(?=- )", m.group(1)):
        if not item.strip():
            continue
        lines = item.split("\n")
        num = re.search(r"(?m)^(?:- |  )ResponseNumber: (\d+)", item)
        value = None
        for i, line in enumerate(lines):
            vm = re.match(r"^    Value: (.*)$", line)
            if vm and i > 0 and lines[i - 1].strip().startswith("TargetLanguage"):
                value = scalar(vm.group(1), lines[i + 1:])
                break
        out.append((int(num.group(1)) if num else 0, value or ""))
    return out


def collect(voices):
    """All expected voice files: list of dicts; plus a list of problems."""
    quests = load_quests()
    lines, problems = [], []
    for topic_dir in sorted((TEXT / "DialogTopics").iterdir()):
        rec = topic_dir / "RecordData.yaml"
        if not rec.exists():
            continue
        t = read(rec)
        topic_edid = top_value(t, "EditorID") or ""
        quest_edid = quests.get(top_value(t, "Quest"))
        for info_file in sorted((topic_dir / "Responses").glob("*.yaml")):
            it = read(info_file)
            info_key = top_value(it, "FormKey")
            responses = parse_responses(it)
            if not responses:
                continue
            where = f"{topic_edid or topic_dir.name} / INFO {info_key}"
            if not quest_edid:
                problems.append(f"{where}: topic has no quest of this plugin")
                continue
            speaker = top_value(it, "Speaker")
            candidates = [speaker] if speaker else re.findall(
                r"GetIsIDConditionData\n\s+Object: (\S+)", it)
            vts = sorted({voices[c] for c in candidates if c in voices})
            unknown = [c for c in candidates if c not in voices]
            if unknown:
                problems.append(f"{where}: no voice type known for {', '.join(unknown)} (add to VANILLA_VOICES)")
            if not vts:
                if not unknown:
                    problems.append(f"{where}: no Speaker and no GetIsID condition, voice type unknown")
                continue
            for num, text in responses:
                if num < 1:
                    problems.append(f"{where}: response without ResponseNumber")
                    continue
                for head in voice_heads(quest_edid, topic_edid):
                    name = f"{head}_{form_id_part(info_key)}_{num}.fuz"
                    for vt in vts:
                        lines.append({"path": f"{vt}/{name}", "text": text, "where": where})
    return lines, problems


def duration(text, wps):
    words = len(re.findall(r"[\w'-]+", text))
    return max(2.0, words / wps + 1.0)


def silent_fuz(seconds, encoder, tmp):
    wav = tmp / "silence.wav"
    xwm = tmp / "silence.xwm"
    with wave.open(str(wav), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SAMPLE_RATE)
        w.writeframes(b"\x00\x00" * int(seconds * SAMPLE_RATE))
    if xwm.exists():
        xwm.unlink()
    r = subprocess.run([str(encoder), str(wav), str(xwm)], capture_output=True, text=True)
    if r.returncode or not xwm.exists():
        raise RuntimeError(f"xWMAEncode failed ({r.returncode}): {r.stdout} {r.stderr}")
    audio = xwm.read_bytes()
    # FUZE header: magic, version 1, lip size 0 (no lip data), then the xWMA stream.
    return b"FUZE" + struct.pack("<II", 1, 0) + audio


def fingerprint(seconds):
    return hashlib.sha1(f"{seconds:.2f}".encode()).hexdigest()[:12]


def read_manifest():
    path = OUT / MANIFEST
    entries = {}
    if path.exists():
        for line in read(path).splitlines():
            if "\t" in line:
                rel, fp = line.split("\t", 1)
                entries[rel] = fp
    return entries


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    ap.add_argument("--wps", type=float, default=2.5, help="words per second (default 2.5)")
    ap.add_argument("--encoder", type=Path, default=DEFAULT_ENCODER, help="path to xWMAEncode.exe")
    args = ap.parse_args()

    voices = load_voice_types()
    lines, problems = collect(voices)
    old = read_manifest()

    if args.check:
        missing = [l for l in lines if not (OUT / l["path"]).exists()]
        for l in lines:
            print(("MISSING " if l in missing else "ok      ") + l["path"])
        for p in problems:
            print("ERROR   " + p)
        print(f"{len(lines)} expected, {len(missing)} missing, {len(problems)} problem(s)")
        return 1 if missing or problems else 0

    if not args.encoder.exists():
        print(f"xWMAEncode not found: {args.encoder}", file=sys.stderr)
        return 1
    OUT.mkdir(parents=True, exist_ok=True)
    manifest, written, kept, foreign = {}, 0, 0, 0
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        for l in lines:
            target = OUT / l["path"]
            secs = duration(l["text"], args.wps)
            fp = fingerprint(secs)
            if target.exists() and l["path"] not in old:
                foreign += 1  # a real recording (or a file we did not write): leave it alone
                continue
            manifest[l["path"]] = fp
            if target.exists() and old.get(l["path"]) == fp:
                kept += 1
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(silent_fuz(secs, args.encoder, tmp))
            written += 1
    removed = 0
    for rel in old:
        if rel not in manifest and (OUT / rel).exists():
            (OUT / rel).unlink()
            removed += 1
    (OUT / MANIFEST).write_text("".join(f"{k}\t{v}\n" for k, v in sorted(manifest.items())),
                                encoding="utf-8", newline="\n")
    for p in problems:
        print("ERROR   " + p)
    print(f"{len(lines)} voice file(s): {written} written, {kept} unchanged, {removed} stale removed, "
          f"{foreign} foreign kept; {len(problems)} problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
