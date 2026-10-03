#!/usr/bin/env python3
"""Build the Q01 V2 dialogue records from dialogue/drafts/Q01-v2/{flow.json,Q01.csv} with tools/flow_compiler.py.

Usage: python tools/build_q01_v2.py            # compile and print the report only
       python tools/build_q01_v2.py --write    # write plugin-text/ records, fragment scripts, ID map, quest patches
Afterwards: tools/plugin_text.ps1 -Direction ToPlugin -Force, tools/build.ps1, python tools/silent_voice.py.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import flow_compiler as fc  # noqa: E402

P = "NightsHarvest.esp"
NL = "\n"
Q01 = 0x004000
PLAYER = "000014:Skyrim.esm"


def q01(call):
    return ['NHV_Q01Script kQ01 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script',
            "If kQ01 != None", f"    kQ01.{call}", "EndIf"]


def item_world(form):
    def fn(val, flow):
        return fc.cond("GetItemCount", [f"ItemOrList: {form}:{P}"], ">=" if val else "<", 1,
                       extra=["RunOnType: Reference", f"Reference: {PLAYER}"])
    return fn


def stage_world(val, flow):
    return fc.cond("GetStage", [f"Quest: 004000:{P}"], ">=" if val else "<", 20)


def persuade(val, flow):
    return fc.cond("GetActorValue", ["ActorValue: Speech"], ">=" if val else "<", 30,
                   extra=["RunOnType: Reference", f"Reference: {PLAYER}"])


def intimidate(val, flow):
    return fc.cond("GetIntimidateSuccess", [], "==", 1 if val else 0)


SPEC = dict(
    quest="Q01", qform=Q01, qkey="004000:" + P, syskey="000809:" + P,
    prefix="NHV_Q01V2", flow="dialogue/drafts/Q01-v2/flow.json", csv="dialogue/drafts/Q01-v2/Q01.csv",
    extra_csv=["dialogue/drafts/Q01-v2/Journal.csv", "dialogue/drafts/Q01-v2/Books.csv"],
    idmap="tools/flow_ids_Q01.json", id_range=(0x7000, 0x7FFF),
    hosts={
        "Veyra": dict(base="000817:" + P), "Nazir": dict(base="01C3AB:Skyrim.esm"),
        "Hakan": dict(base="004006:" + P), "Hrefna": dict(base="004007:" + P), "Quintus": dict(base="004008:" + P),
    },
    aliases={"Q": {"Veyra": 1, "Hakan": 2, "Hrefna": 3, "Quintus": 4, "Nazir": 5}, "Sys": {}},
    sys_speakers=(),
    fallback_host="Veyra",
    world={"investigated": stage_world, "diary": item_world("00400E"), "fragment": item_world("00400F"),
           "persuade": persuade, "intimidate": intimidate},
    lanes={"hakan_body": "Hakan", "hakan_farm": "Hakan", "hakan_warning": "Hakan", "quintus_cover": "Hakan"},
    inline_stage=("accusation", "judgment"),
    inline_entry_from={"judgment": ("papers_confirm",)},
    root_from_stage={"judgment": 60},
    node_effects={"silence": {"outcome": "dead", "hrefnaDead": True}},
    node_code={
        "authorize": ["NHV_Util.FlowObjective(0x004000, 50, 51)"],
        "persuade_pass": q01("HrefnaAgreesToKill()"),
        "intimidate_pass": q01("HrefnaAgreesToKill()"),
        "player_takes_over": q01("PlayerWillKill()"),
        "recruit_knife": q01("JudgeRecruit()"),
        "release_confirm": q01("JudgeRelease()"),
        "silence": q01("JudgeSilence()"),
        "fragment_recovery": q01("GiveOculatusFragment()"),
    },
    entries={
        "brief": dict(kind="greeting", lane="Main"),
        "hakan_start": dict(kind="greeting", lane="Hakan"),
        "farm": dict(kind="ui", set_stage=True),
        "camp": dict(kind="scene_ext", set_stage=False,
                     existing=dict(fid=0x402B, eid="NHV_Scn_Q01_01CampAmbush",
                                   sfname="SF_NHV_Scn_Q01_01CampAmbush_0200402B"),
                     sf_prefix=q01("EndCampAmbush()")),
        "veyra_arrives": dict(kind="scene_ext", set_stage=False,
                              existing=dict(fid=0x4030, eid="NHV_Scn_Q01_02VeyraTrial",
                                            sfname="SF_NHV_Scn_Q01_02VeyraTrial_02004030"),
                              sf_prefix=q01("EndVeyraTrial()"), start=q01("StartVeyraTrial()")),
        "room": dict(kind="greeting", lane="Main"),
        "road": dict(kind="greeting", lane="Main"),
        "kill_hrefna": dict(kind="greeting", lane="Main"),
        "kill_player": dict(kind="greeting", lane="Main"),
        "papers": dict(kind="fork", lane="Main"),
        "papers_read": dict(kind="greeting", lane="Main", cursor_entry="papers", extra_conds=[("state", "fragment", True)]),
        "judgment": dict(kind="greeting", lane="Main", cursor_entry="papers", extra_conds=[("state", "fragment", False)]),
        "return": dict(kind="ui", then_hub="report"),
        "after": dict(kind="ui"),
        "home": dict(kind="scene_ext",
                     existing=dict(fid=0x7F01, eid="NHV_Scn_Q01_04Home", sfname="SF_NHV_Scn_Q01_04Home_02007F01")),
    },
)

QUEST_FILE = fc.TEXT / "Quests" / "NHV_Q01_TheUnansweredSacrament - 004000_NightsHarvest.esp.yaml"
SCRIPT = fc.SCRIPTS / "NHV_Q01Script.psc"
QF = fc.SCRIPTS / "QF_NHV_Q01_TheUnansweredSacra_02004000.psc"
STAGES = {  # stage -> (objective line, [(condition items, log line)])
    10: ("NHV_Q01_010_1036", [([], "NHV_Q01_010_1037")]),
    20: ("NHV_Q01_020_1000", [([], "NHV_Q01_020_1001")]),
    30: ("NHV_Q01_030_1012", [([], "NHV_Q01_030_1013")]),
    40: ("NHV_Q01_040_1038", [([], "NHV_Q01_040_1039")]),
    50: ("NHV_Q01_050_1055", [([], "NHV_Q01_050_1056")]),
    60: ("NHV_Q01_060_1007", [([("state", "killer", "player")], "NHV_Q01_060_1010"), ([], "NHV_Q01_060_1008")]),
    70: ("NHV_Q01_070_1024", [([], "NHV_Q01_070_1025")]),
    100: ("NHV_Q01_100_1047", [([("state", "outcome", "released")], "NHV_Q01_100_1052"),
                                ([("state", "outcome", "dead")], "NHV_Q01_100_1054"),
                                ([("state", "killer", "player")], "NHV_Q01_100_1050"),
                                ([], "NHV_Q01_100_1048")]),
}
EXTRA_OBJ = {51: "NHV_Q01_050_1057", 61: "NHV_Q01_060_1009", 101: "NHV_Q01_100_1049", 102: "NHV_Q01_100_1051",
             103: "NHV_Q01_100_1053"}


def rd(p):
    return p.read_text(encoding="utf-8")


def wr(p, t):
    p.write_text(t, encoding="utf-8", newline="\n")


def obj_block(idx, text):
    return (f"- Index: {idx}{NL}  Flags: []{NL}  DisplayText:{NL}    TargetLanguage: English{NL}"
            f"    Value: {fc.q(text)}{NL}")


def patch_quest(f):
    s = rd(QUEST_FILE)
    # remove the approach scene (V2 has no approach lines) and add the Nazir alias
    s = s.replace("    - MutagenObjectType: ScriptObjectProperty" + NL + "      Name: QuintusApproachScene" + NL
                  + "      Object: 004037:NightsHarvest.esp" + NL, "")
    if "Name: NazirAlias" not in s:
        s = s.replace("NextAliasID: 5" + NL, "NextAliasID: 6" + NL, 1)
        s = s.rstrip(NL) + NL + ("- ID: 5" + NL + "  Name: NazirAlias" + NL + "  Flags:" + NL + "  - Optional" + NL
                                 + "  ForcedReference: 01C3AD:Skyrim.esm" + NL + "  VoiceTypes: Null" + NL)
    # stages with (conditional) journal entries
    head, rest = s.split("Stages:" + NL, 1)
    _, tail = rest.split("Objectives:" + NL, 1)
    out = []
    for st, (obj, logs) in STAGES.items():
        out.append(f"- Index: {st}{NL}")
        out.append(f"  LogEntries:{NL}")
        for conds, line in logs:
            out.append(f"  - Flags:{NL}    - CompleteQuest{NL}" if st == 100 else f"  - Flags: []{NL}")
            if conds:
                out.append(f"    Conditions:{NL}")
                out.append(NL.join("    " + l for l in f.conds_lines(conds)) + NL)
            out.append(f"    Entry:{NL}      TargetLanguage: English{NL}      Value: {fc.q(f.rows[line]['Text'].strip())}{NL}")
    objs = []
    for st, (obj, _) in STAGES.items():
        objs.append(obj_block(st, f.rows[obj]["Text"].strip()))
    for idx, line in EXTRA_OBJ.items():
        objs.append(obj_block(idx, f.rows[line]["Text"].strip()))
    tail_rest = tail.split("NextAliasID:", 1)[1]
    s = head + "Stages:" + NL + "".join(out) + "Objectives:" + NL + "".join(objs) + "NextAliasID:" + tail_rest
    wr(QUEST_FILE, s)


def write_constants(f):
    kmap = f.enum_values("killer")
    lines = [
        "; BEGIN FLOW CONSTANTS (generated by tools/build_q01_v2.py - do not edit)",
        f"Int Property FLOW_KILLER = {f.gid('killer')} AutoReadOnly",
        f"Int Property FLOW_KILLER_HREFNA = {kmap.index('hrefna')} AutoReadOnly",
        f"Int Property FLOW_KILLER_PLAYER = {kmap.index('player')} AutoReadOnly",
        f"Int Property FLOW_CURSOR_MAIN = {f.gid('CursorMain')} AutoReadOnly",
        f"Int Property FLOW_ENTRY_KILL_HREFNA = {f.ordinal('entry', 'kill_hrefna')} AutoReadOnly",
        f"Int Property FLOW_ENTRY_KILL_PLAYER = {f.ordinal('entry', 'kill_player')} AutoReadOnly",
        "; END FLOW CONSTANTS",
    ]
    raw = SCRIPT.read_bytes().decode("utf-8")
    crlf = "\r\n" in raw
    s = raw.replace("\r\n", "\n")
    a = s.index("; BEGIN FLOW CONSTANTS")
    b = s.index("; END FLOW CONSTANTS") + len("; END FLOW CONSTANTS")
    s = s[:a] + "\n".join(lines) + s[b:]
    if crlf:
        s = s.replace("\n", "\r\n")
    SCRIPT.write_bytes(s.encode("utf-8"))


def write_qf(f):
    def frag(i, code):
        return ([f";BEGIN FRAGMENT Fragment_{i}", f"Function Fragment_{i}()", ";BEGIN CODE"] + code
                + [";END CODE", "EndFunction", ";END FRAGMENT", ""])
    cm = f"0x{f.gid('CursorMain'):06X}"
    ch = f"0x{f.gid('CursorHakan'):06X}"
    killer = f"0x{f.gid('killer'):06X}"
    outcome = f"0x{f.gid('outcome'):06X}"
    kmap, omap = f.enum_values("killer"), f.enum_values("outcome")
    kq = ["NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script"]
    code = {
        0: ["SetObjectiveDisplayed(10)", f"NHV_Util.FlowSet({ch}, {f.ordinal('entry', 'hakan_start')})",
            f"NHV_Util.FlowSet({cm}, {f.ordinal('entry', 'brief')})"],
        1: ["SetObjectiveCompleted(10)", "SetObjectiveDisplayed(20)"] + kq + ["If kQ01 != None", "    kQ01.BeginCampWatch()", "EndIf"],
        2: ["SetObjectiveCompleted(20)", "SetObjectiveDisplayed(30)"],
        3: ["SetObjectiveCompleted(30)", "SetObjectiveDisplayed(40)"],
        4: ["SetObjectiveCompleted(40)", "SetObjectiveDisplayed(50)"] + kq + ["If kQ01 != None", "    kQ01.MakeQuintusMortal()", "EndIf"],
        5: ["SetObjectiveCompleted(50)", "If IsObjectiveDisplayed(51)", "    SetObjectiveCompleted(51)", "EndIf",
            f"If NHV_Util.FlowGet({killer}) == {kmap.index('player')}", "    SetObjectiveDisplayed(61)", "Else",
            "    SetObjectiveDisplayed(60)", "EndIf"],
        6: ["SetObjectiveCompleted(60)", "If IsObjectiveDisplayed(61)", "    SetObjectiveCompleted(61)", "EndIf",
            "SetObjectiveDisplayed(70)"],
        7: ["SetObjectiveCompleted(70)", f"Int iOutcome = NHV_Util.FlowGet({outcome})",
            f"If iOutcome == {omap.index('released')}", "    SetObjectiveDisplayed(102)",
            f"ElseIf iOutcome == {omap.index('dead')}", "    SetObjectiveDisplayed(103)",
            f"ElseIf NHV_Util.FlowGet({killer}) == {kmap.index('player')}", "    SetObjectiveDisplayed(101)", "Else",
            "    SetObjectiveDisplayed(100)", "EndIf"],
    }
    o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment", ";NEXT FRAGMENT INDEX 8",
         "Scriptname QF_NHV_Q01_TheUnansweredSacra_02004000 Extends Quest Hidden", ""]
    for i in range(8):
        o += frag(i, code[i])
    o += [";END FRAGMENT CODE - Do not edit anything between this and the begin comment", ""]
    QF.write_text("\r\n".join(o), encoding="utf-8", newline="")


def patch_books(f):
    tpl = rd(fc.TEXT / "Books" / "NHV_Book_HrefnaReleaseLetter - 004010_NightsHarvest.esp.yaml")

    def body(title, lines):
        paras = []
        for l in lines:
            paras += [p.strip() for p in f.rows[l]["Text"].replace("\\n", "\n").split("\n\n") if p.strip()]
        out = [f'    <p align="center"><font size="32">{title}</font></p>']
        for p in paras:
            out += ["", f'    <p align="left">{p}</p>']
        return NL.join(out)

    def make(fid, eid, name, title, lines):
        t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(fid)}", tpl, count=1)
        t = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", t, count=1)
        t = re.sub(r"(?m)^(Name:\n  TargetLanguage: English\n  Value: ).*$", lambda m: m.group(1) + name, t, count=1)
        a = t.index("  Value: >-" + NL) + len("  Value: >-" + NL)
        b = t.index("Keywords:")
        return t[:a] + body(title, lines) + NL + t[b:]
    rel = make(0x4010, "NHV_Book_HrefnaReleaseLetter", "A Letter from Hrefna", "A Letter from Hrefna",
               ["NHV_Q01_100_1045", "NHV_Q01_100_1046"])
    wr(fc.TEXT / "Books" / "NHV_Book_HrefnaReleaseLetter - 004010_NightsHarvest.esp.yaml", rel)
    letter = make(0x7F10, "NHV_Book_QuintusPrivateLetter", "A Private Letter", "A Private Letter",
                  ["NHV_Q01_050_1053", "NHV_Q01_050_1054"])
    wr(fc.TEXT / "Books" / "NHV_Book_QuintusPrivateLetter - 007F10_NightsHarvest.esp.yaml", letter)


def main():
    write = "--write" in sys.argv
    f = fc.Flow(SPEC)
    f.emit_globals()
    f.emit_hubs()
    f.emit_roots()
    print(f"topics {f.topics_made}, scenes {len(f.scenes_made)}, scripts {len(f.scripts)}, files {len(f.files)}")
    print("greets:", [(g["node"], g["host"], g["stage"], g["ordinal"]) for g in f.greets])
    live = {n["id"] for n in f.flow["nodes"] if not n.get("obsolete")}
    print("unvisited:", sorted(live - f.visited))
    for n in f.notes:
        print("note:", n)
    print("enums:", {k: f.enum_values(k) for k in ("killer", "outcome", "route")})
    if write:
        f.write_all()
        patch_quest(f)
        write_constants(f)
        write_qf(f)
        patch_books(f)
        print("written")


if __name__ == "__main__":
    main()
