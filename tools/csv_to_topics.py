#!/usr/bin/env python3
"""Create player-menu dialogue topics in plugin-text/ (Spriggit YAML) from a CSV master script (Rule 4).

Pattern (same as NHV_Q00_CIC_Remembers01): every CSV topic whose first row is a Player line becomes

    DialogBranch (Player, TopLevel)  ->  DialogTopic (CUST)  ->  one INFO
                                                                 Prompt = Player line
                                                                 Responses = the NPC rows, in CSV order

A topic called "<X>Follow" is not a menu entry of its own: it is created in the branch of topic "<X>" and linked
from <X>'s INFO (LinkTo), so it only appears right after the parent's answer.

Conditions come from the CSV "Conditions" column (";"-separated), see parse_condition(). For speakers without a
GetIsID condition the base NPC of the speaker is added, because tools/silent_voice.py resolves the voice folder
from GetIsID (or the INFO Speaker).

Topics that already exist (by EditorID "NHV_<prefix>_<Topic>") are skipped, so re-running after Codex added rows
only creates the new topics. FormIDs are allocated from --range (first free ID above what plugin-text\\ holds).

Usage:
    python tools/csv_to_topics.py dialogue/Sanctuary.csv --prefix Sys --range 004500-0045FF [--only REGEX] [--dry-run]

Afterwards: tools/plugin_text.ps1 -Direction ToPlugin -Force, then -Direction ToText -Force (round trip),
python tools/csv_to_plugin.py --check, python tools/silent_voice.py.
"""

import argparse
import csv
import glob
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TEXT = REPO / "plugin-text"
PLUGIN = "NightsHarvest.esp"

QUEST_OF = {"Sanctuary": "NHV_Sys_Sanctuary", "Q00": "NHV_Q00_ShadowAtTheDoor", "Q01": "NHV_Q01_TheUnansweredSacrament",
            "Lucien": "NHV_Sys_Sanctuary"}
# Vanilla references/bases the CSV conditions name by nickname.
REFS = {"CiceroRef": "01E64A:Skyrim.esm", "CiceroDawnstarRef": "09BCB0:Skyrim.esm"}
BASE_OF_SPEAKER = {"Nazir": "01C3AB:Skyrim.esm", "Babette": "01D4B7:Skyrim.esm", "Cicero": "09BCAF:Skyrim.esm",
                   "Lucien": "004400:NightsHarvest.esp"}
VANILLA_CELLS = {}
OPS = {"==": None, ">=": "GreaterThanOrEqualTo", ">": "GreaterThan", "<=": "LessThanOrEqualTo", "<": "LessThan",
       "!=": "NotEqualTo"}


def q(text):
    return "'" + text.replace("'", "''") + "'"


def top_value(t, key):
    m = re.search(rf"^{key}: (.+)$", t, re.M)
    return m.group(1).strip() if m else None


def index_records():
    """EditorID -> FormKey for everything in plugin-text (all folders), plus used FormIDs."""
    ed, used = {}, set()
    for f in glob.glob(str(TEXT / "**" / "*"), recursive=True):
        p = Path(f)
        if not p.is_file() or p.suffix not in (".yaml", ".esp") and not p.name.endswith(".yaml"):
            continue
        try:
            t = p.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        fk, eid = top_value(t, "FormKey"), top_value(t, "EditorID")
        if fk and eid:
            ed[eid] = fk
        if fk and fk.endswith(":" + PLUGIN):
            used.add(int(fk.split(":")[0], 16))
    return ed, used


def alias_index(quest_eid):
    for f in (TEXT / "Quests").glob("*.yaml"):
        t = f.read_text(encoding="utf-8").replace("\r\n", "\n")
        if top_value(t, "EditorID") != quest_eid:
            continue
        out, cur = {}, 0
        for m in re.finditer(r"(?m)^- (?:ID: (\d+)\n  )?Name: (\S+)$", t.split("\nAliases:\n", 1)[-1]):
            idx = int(m.group(1)) if m.group(1) else cur
            out[m.group(2)] = idx
            cur = idx + 1
        return out
    return {}


class Ctx:
    def __init__(self):
        self.ed, self.used = index_records()
        self.aliases = {}

    def form(self, name):
        if re.match(r"^[0-9A-F]{6}:", name):
            return name
        if name in REFS:
            return REFS[name]
        if name in self.ed:
            return self.ed[name]
        raise SystemExit(f"unknown record name in condition: {name}")

    def alias(self, quest_eid, name):
        if quest_eid not in self.aliases:
            self.aliases[quest_eid] = alias_index(quest_eid)
        if name not in self.aliases[quest_eid]:
            raise SystemExit(f"alias {name} not found in quest {quest_eid}")
        return self.aliases[quest_eid][name]


def cond_block(function, data_lines, op, value, extra=()):
    lines = ["- MutagenObjectType: ConditionFloat"]
    if OPS[op]:
        lines.append(f"  CompareOperator: {OPS[op]}")
    lines.append("  Data:")
    lines.append(f"    MutagenObjectType: {function}ConditionData")
    for e in extra:
        lines.append(f"    {e}")
    lines += [f"    {d}" for d in data_lines]
    if float(value) != 0:
        lines.append(f"  ComparisonValue: {value}")
    return lines


def parse_condition(text, ctx, quest_eid):
    """'GetStage NHV_Q00_ShadowAtTheDoor >= 100' -> YAML lines. Supported: GetStage, GetIsID, GetDead [Ref],
    GetIsAliasRef, GetGlobalValue, GetInCell."""
    parts = text.split()
    op_i = next(i for i, p in enumerate(parts) if p in OPS)
    op, value = parts[op_i], parts[op_i + 1]
    fn, args = parts[0], parts[1:op_i]
    if fn == "GetStage":
        return cond_block("GetStage", [f"Quest: {ctx.form(args[0])}"], op, value)
    if fn == "GetIsID":
        return cond_block("GetIsID", [f"Object: {ctx.form(args[0])}"], op, value)
    if fn == "GetDead":
        if args:
            return cond_block("GetDead", [], op, value, ["RunOnType: Reference", f"Reference: {ctx.form(args[0])}"])
        return cond_block("GetDead", [], op, value)
    if fn == "GetIsAliasRef":
        idx = ctx.alias(quest_eid, args[0])
        return cond_block("GetIsAliasRef", [f"ReferenceAliasIndex: {idx}"] if idx else [], op, value)
    if fn == "GetGlobalValue":
        return cond_block("GetGlobalValue", [f"Global: {ctx.form(args[0])}"], op, value)
    if fn == "GetInCell":
        return cond_block("GetInCell", [f"Cell: {ctx.form(args[0])}"], op, value)
    raise SystemExit(f"unsupported condition function: {fn}")


def read_topics(csv_path, only):
    rows = list(csv.DictReader(open(csv_path, encoding="utf-8-sig", newline="")))
    topics, order = {}, []
    for r in rows:
        t = r["Topic"]
        if only and not re.search(only, t):
            continue
        if t not in topics:
            topics[t] = []
            order.append(t)
        topics[t].append(r)
    return topics, order


def build(csv_path, prefix, rng, only, dry, follows):
    ctx = Ctx()
    topics, order = read_topics(csv_path, only)
    lo, hi = (int(x, 16) for x in rng.split("-"))
    nxt = max([u for u in ctx.used if lo <= u <= hi] + [lo - 1]) + 1
    made = []

    def take():
        nonlocal nxt
        if nxt > hi:
            raise SystemExit("FormID range exhausted")
        v = nxt
        nxt += 1
        return f"{v:06X}:{PLUGIN}"

    topic_key, branch_of = {}, {}
    plan = []
    for name in order:
        rows = topics[name]
        if rows[0]["Speaker"] != "Player":
            print(f"skip {name}: first row is not a Player line (needs manual wiring)")
            continue
        eid = f"NHV_{prefix}_{name}"
        if eid in ctx.ed:
            topic_key[name] = ctx.ed[eid]
            continue  # already in the plugin
        plan.append(name)
    # parents first so that FormKeys of follow-ups exist when the parent INFO gets its LinkTo
    keys = {}
    for name in plan:
        follow = parent_of(name, topics, follows) is not None
        keys[name] = {"branch": None if follow else take(), "topic": take(), "info": take()}
    for n, k in keys.items():
        topic_key[n] = k["topic"]

    for name in plan:
        rows = topics[name]
        k = keys[name]
        eid = f"NHV_{prefix}_{name}"
        base = parent_of(name, topics, follows)
        branch_key = k["branch"] or (keys[base]["branch"] if base in keys else None)
        if branch_key is None and base:  # parent already existed: read its branch from the plugin
            branch_key = parent_branch(ctx, f"NHV_{prefix}_{base}")
        prompt, resp = rows[0], rows[1:]
        quest_eid = QUEST_OF[rows[0]["Quest"]]
        quest_key = ctx.form(quest_eid)
        conds = []
        seen_ids = False
        for c in rows[-1]["Conditions"].split(";"):
            c = c.strip()
            if not c:
                continue
            seen_ids |= c.startswith("GetIsID")
            conds += parse_condition(c, ctx, quest_eid)
        sp = resp[0]["Speaker"] if resp else ""
        if not seen_ids and sp in BASE_OF_SPEAKER:
            conds += cond_block("GetIsID", [f"Object: {BASE_OF_SPEAKER[sp]}"], "==", "1")
        children = [c for c in topics if parent_of(c, topics, follows) == name]
        link_lines = []
        if children:
            link_lines = ["LinkTo:"] + [f"- {topic_key[c]}" for c in children if c in topic_key]
        resp_lines = []
        for i, r in enumerate(resp, 1):
            if r["Emotion"] != "Neutral":
                resp_lines.append(f"- Emotion: {r['Emotion']}")
                resp_lines.append(f"  EmotionValue: {r['Value']}")
            else:
                resp_lines.append(f"- EmotionValue: {r['Value']}")
            resp_lines += [f"  ResponseNumber: {i}", "  Unknown2: 0x000000", "  Unknown3: 0x000000", "  Text:",
                           "    TargetLanguage: English", f"    Value: {q(r['Text'].strip())}"]
            notes = r["LineID"] + (f" prompt={prompt['LineID']}" if i == 1 else "")
            resp_lines += [f"  ScriptNotes: {notes}", "  Edits: ''"]
        info = ["FormKey: " + k["info"], f"EditorID: {eid}_INFO01", "Flags: {}", "PreviousDialog: Null",
                "FavorLevel: None"] + link_lines + ["Responses:"] + resp_lines + ["Conditions:"] + conds + [
            "Prompt:", "  TargetLanguage: English", f"  Value: {q(prompt['Text'].strip())}"]
        topic = ["FormKey: " + k["topic"], f"EditorID: {eid}", "Priority: 60", f"Branch: {branch_key}",
                 f"Quest: {quest_key}", "SubtypeName: CUST"]
        files = {TEXT / "DialogTopics" / f"{eid} - {k['topic'][:6]}_{PLUGIN}" / "RecordData.yaml": topic,
                 TEXT / "DialogTopics" / f"{eid} - {k['topic'][:6]}_{PLUGIN}" / "Responses" /
                 f"{eid}_INFO01 - {k['info'][:6]}_{PLUGIN}.yaml": info}
        if k["branch"]:
            files[TEXT / "DialogBranches" / f"{eid}_Branch - {k['branch'][:6]}_{PLUGIN}.yaml"] = [
                "FormKey: " + k["branch"], f"EditorID: {eid}_Branch", f"Quest: {quest_key}", "Category: Player",
                "Flags:", "- TopLevel", f"StartingTopic: {k['topic']}"]
        for path, lines in files.items():
            made.append(path)
            if not dry:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"{'would create' if dry else 'created'} {len(plan)} topic(s), {len(made)} file(s); next free FormID {nxt:06X}")


def parent_of(name, topics, follows):
    """'<X>Follow' follows '<X>'; --follow CHILD=PARENT names other links (e.g. Lucien_VouchEnd=Lucien_Vouch)."""
    if name in follows:
        return follows[name]
    if name.endswith("Follow") and name[:-6] in topics:
        return name[:-6]
    return None


def parent_branch(ctx, parent_eid):
    for f in glob.glob(str(TEXT / "DialogTopics" / f"{parent_eid} - *" / "RecordData.yaml")):
        b = top_value(Path(f).read_text(encoding="utf-8"), "Branch")
        if b:
            return b
    raise SystemExit(f"parent topic {parent_eid} not found")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("csv")
    ap.add_argument("--prefix", required=True, help='EditorID prefix part: NHV_<prefix>_<Topic>')
    ap.add_argument("--range", required=True, help="FormID range, e.g. 004500-0045FF")
    ap.add_argument("--only", help="regex on the CSV Topic column")
    ap.add_argument("--follow", action="append", default=[], metavar="CHILD=PARENT",
                    help="topic CHILD is a follow-up of PARENT (besides the <X>Follow naming rule)")
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    build(a.csv, a.prefix, a.range, a.only, a.dry_run, dict(f.split("=", 1) for f in a.follow))


if __name__ == "__main__":
    sys.exit(main())
