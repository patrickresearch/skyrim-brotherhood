#!/usr/bin/env python3
"""Build the Q00 V2 dialogue records (E41) from dialogue/drafts/Q00-v2/{flow.json,Q00.csv} with tools/flow_compiler.py.

Usage: python tools/build_q00_v2.py            # compile and print the report only
       python tools/build_q00_v2.py --write    # write plugin-text/ records, fragment scripts and the ID map
Afterwards: tools/plugin_text.ps1 -Direction ToPlugin -Force, ToText (round trip), tools/build.ps1 -Clean,
python tools/silent_voice.py.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import flow_compiler as fc  # noqa: E402

P = "NightsHarvest.esp"
CORE = ['NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript',
        'If kCore != None']
SANCT = ['NHV_SanctuaryScript kSanct = Game.GetFormFromFile(0x000809, "NightsHarvest.esp") as NHV_SanctuaryScript',
         'If kSanct != None']


def core(call):
    return CORE + [f"    kCore.{call}", "EndIf"]


def dead(ref, val):
    return fc.cond("GetDead", [], "==", val, extra=["RunOnType: Reference", f"Reference: {ref}:Skyrim.esm"])


def cicero(val, flow):
    # Cicero of the Sanctuary (09BCB0) and the Falkreath one (01E64A): present when neither is dead.
    if val:
        return dead("09BCB0", 0) + dead("01E64A", 0)
    a = dead("09BCB0", 1)
    b = dead("01E64A", 1)
    a.insert(1, "  Flags:")
    a.insert(2, "  - OR")
    return a + b


SUMMON_FINISH = SANCT + ["    kSanct.FinishSummonCall()", "EndIf"]
CALL_START = SANCT + ['    kSanct.StartSummonCall(Game.GetFormFromFile(0x{sid}, "NightsHarvest.esp") as Scene)', "EndIf"]

SPEC = dict(
    quest="Q00", qform=0x000815, qkey="000815:" + P, syskey="000809:" + P,
    prefix="NHV_Q00V2", flow="dialogue/drafts/Q00-v2/flow.json", csv="dialogue/drafts/Q00-v2/Q00.csv",
    extra_csv=["dialogue/drafts/Q00-v2/Journal.csv"],
    idmap="tools/flow_ids_Q00.json", id_range=(0x6000, 0x6FFF),
    hosts={
        "Veyra": dict(base="000817:" + P), "Nazir": dict(base="01C3AB:Skyrim.esm"),
        "Babette": dict(base="01D4B7:Skyrim.esm"), "Cicero": dict(base="09BCAF:Skyrim.esm"),
        "Lucien": dict(base="004400:" + P), "NightMother": dict(base="0037EC:" + P),
    },
    aliases={"Q": {"Veyra": 0, "Nazir": 1, "Babette": 2, "Cicero": 3},
             "Sys": {"Nazir": 0, "Babette": 1, "Cicero": 2, "Lucien": 4, "Veyra": 5}},
    sys_speakers=("Lucien",),
    fallback_host="Veyra",
    world={"cicero": cicero},
    lanes={"nm_hub": "NM"},
    stage_at_end=("exit",),
    mirror={"memorial": ["0x000814"]},
    hooks=dict(
        before={"NHV_Q00_012_1008": SUMMON_FINISH, "NHV_Q00_050_1010": core("EnterDeepTogether()")},
        after={"NHV_Q00_012_1013": core("OnLucienVouchEnded()")},
    ),
    node_code={
        "travel": core("BeginVeyraReturnToSanctuary()") + ["NHV_Util.FlowObjective(0x000815, 30, 31)"],
        "memorial_equal": ["NHV_Util.FlowObjective(0x000815, 60, 61)"],
        "memorial_none": ["NHV_Util.FlowObjective(0x000815, 60, 61)"],
        "memorial_small": ["NHV_Util.FlowObjective(0x000815, 60, 61)"],
        "lead_accept": core("CompleteQ00()"),
    },
    entries={
        "standoff": dict(kind="scene_ext",
                         existing=dict(fid=0x2B4E, eid="NHV_Scn_Q00_01Standoff",
                                       sfname="SF_NHV_Scn_Q00_01Standoff_02002B4E"),
                         sf_prefix=core("RefreezeStandoff()")),
        "nm_start": dict(kind="say"),
        "inn_early": dict(kind="greeting", lane="Main"),
        "cicero_memory": dict(kind="greet", lane="Main"),
        "inn_return": dict(kind="greeting", lane="Main"),
        "proposal_start": dict(kind="scene_ext",
                               existing=dict(fid=0x6F01, eid="NHV_Scn_Q00_07Proposal",
                                             sfname="SF_NHV_Scn_Q00_07Proposal_02006F01")),
        "veil": dict(kind="scene_ext",
                     existing=dict(fid=0x37F0, eid="NHV_Scn_Q00_02VeiledPassage",
                                   sfname="SF_NHV_Scn_Q00_02Veiled_020037F0"),
                     sf_prefix=core("OnVeiledPassageSceneEnd()")),
        "door_revealed": dict(kind="scene_ext", set_stage=False,
                              existing=dict(fid=0x37F7, eid="NHV_Scn_Q00_03EnterDeep",
                                            sfname="SF_NHV_Scn_Q00_03EnterDeep_020037F7"),
                              sf_prefix=core("OnEnterDeepSceneEnd()")),
        "memorial_intro": dict(kind="scene_ext", set_stage=False,
                               existing=dict(fid=0x380A, eid="NHV_Scn_Q00_05Memorial",
                                             sfname="SF_NHV_Scn_Q00_05Memorial_0200380A"),
                               sf_prefix=core("OnMemorialSceneEnd()")),
        "first_lead": dict(kind="scene_ext", set_stage=False,
                           existing=dict(fid=0x3819, eid="NHV_Scn_Q00_06Contract",
                                         sfname="SF_NHV_Scn_Q00_06Contract_02003819"),
                           sf_prefix=core("OnContractSceneEnd()"),
                           start=core("OnMemorialChosen()")),
        "before_mother": dict(kind="ui"),
        "end": dict(kind="ui"),
        # Stage 12: Lucien's mandatory summoning (three ways into it, one shared block)
        "stage12_departure": dict(kind="auto", domain="Sys", start_tpl=CALL_START),
        "stage12_blade": dict(kind="auto", domain="Sys", start_tpl=CALL_START),
        "stage12_dismiss": dict(kind="auto", domain="Sys", start_tpl=CALL_START),
        "line:NHV_Q00_012_1008": dict(kind="scene_ext", domain="Sys",
                                      existing=dict(fid=0x458A, eid="NHV_Scn_Sys_LucienArrival",
                                                    sfname="SF_NHV_Scn_Sys_LucienArrival_0200458A")),
        "line:NHV_Q00_050_1010": dict(kind="scene_ext",
                                      existing=dict(fid=0x6F02, eid="NHV_Scn_Q00_09DeepIntro",
                                                    sfname="SF_NHV_Scn_Q00_09DeepIntro_02006F02"),
                                      sf_prefix=core("OnDeepIntroEnd()")),
        "after:NHV_Q00_012_1013": dict(kind="auto",
                                      existing=dict(fid=0x6F03, eid="NHV_Scn_Q00_08LucienExit",
                                                    sfname="SF_NHV_Scn_Q00_08LucienExit_02006F03")),
    },
)


TEXT = fc.TEXT
SCRIPTS = fc.SCRIPTS
QUEST_FILE = TEXT / "Quests" / "NHV_Q00_ShadowAtTheDoor - 000815_NightsHarvest.esp.yaml"
STAGE_TEXT = {  # stage -> (objective line, log line) from the V2 journal
    10: ("NHV_Q00_010_1039", "NHV_Q00_010_1040"), 12: ("NHV_Q00_012_1014", "NHV_Q00_012_1015"),
    20: ("NHV_Q00_020_1022", "NHV_Q00_020_1023"), 30: ("NHV_Q00_030_1061", "NHV_Q00_030_1062"),
    40: ("NHV_Q00_040_1005", "NHV_Q00_040_1006"), 50: ("NHV_Q00_050_1017", "NHV_Q00_050_1018"),
    60: ("NHV_Q00_060_1033", "NHV_Q00_060_1034"), 100: (None, "NHV_Q00_100_1018"),
}
EXTRA_OBJ = {31: "NHV_Q00_030_1063", 61: "NHV_Q00_060_1035"}
NL = "\n"


def rd(path):
    return path.read_text(encoding="utf-8")


def wr(path, text):
    path.write_text(text, encoding="utf-8", newline="\n")


def jtext(f, line):
    return f.rows[line]["Text"].strip()


def obj_block(idx, text):
    return (f"- Index: {idx}{NL}  Flags: []{NL}  DisplayText:{NL}    TargetLanguage: English{NL}"
            f"    Value: {fc.q(text)}{NL}")


def patch_quest(f):
    s = rd(QUEST_FILE)
    stages, objs = s.split(NL + "Objectives:" + NL, 1)
    if "- Index: 12" + NL not in stages:
        stages = stages.replace("- Index: 15" + NL + "  LogEntries:",
                                f"- Index: 12{NL}  LogEntries:{NL}  - Flags: []{NL}    Entry:{NL}      TargetLanguage: English{NL}"
                                f"      Value: {fc.q(jtext(f, STAGE_TEXT[12][1]))}{NL}- Index: 15{NL}  LogEntries:", 1)
    for st, (obj, log) in STAGE_TEXT.items():
        pat = re.compile(r"(- Index: %d\n(?:  .*\n)*?      Value: )(.*)\n" % st)
        stages = pat.sub(lambda m: m.group(1) + fc.q(jtext(f, log)) + NL, stages, count=1)
        if obj:
            if f"- Index: {st}{NL}  Flags: []{NL}  DisplayText" not in objs:
                objs = obj_block(st, jtext(f, obj)) + objs if st == 12 else objs
            pat = re.compile(r"(- Index: %d\n  Flags: \[\]\n  DisplayText:\n    TargetLanguage: English\n    Value: )(.*)\n" % st)
            objs = pat.sub(lambda m: m.group(1) + fc.q(jtext(f, obj)) + NL, objs, count=1)
    for idx, line in EXTRA_OBJ.items():
        if f"- Index: {idx}{NL}" not in objs:
            head, sep, tail = objs.partition("NextAliasID:")
            objs = head + obj_block(idx, jtext(f, line)) + sep + tail
    s = stages + NL + "Objectives:" + NL + objs
    if "  - Stage: 12" + NL not in s:
        s = s.replace("  - Stage: 15" + NL,
                      f"  - Stage: 12{NL}    Unknown2: 1{NL}    ScriptName: QF_NHV_Q00_ShadowAtTheDoor_02000815{NL}"
                      f"    FragmentName: Fragment_9{NL}  - Stage: 15{NL}", 1)
    s = s.replace("  - 004590:NightsHarvest.esp" + NL, "")
    live = {fc.fk(g["pkg"]) for g in f.greets}
    def drop_stale(m):
        return m.group(0) if (m.group(1) + ":NightsHarvest.esp") in live else ""
    s = re.sub(r"  - (006[0-9A-F]{3}):NightsHarvest\.esp\n", drop_stale, s)   # packages of an earlier run
    for g in f.greets:
        host_block = "- Name: Veyra" + NL if g["host"] == "Veyra" else "- ID: 3" + NL + "  Name: Cicero" + NL
        i = s.index(host_block)
        j = s.index("  PackageData:" + NL, i) + len("  PackageData:" + NL)
        line = f"  - {fc.fk(g['pkg'])}{NL}"
        if line not in s:
            s = s[:j] + line + s[j:]
    wr(QUEST_FILE, s)


def make_packages(f):
    tpl = rd(TEXT / "Packages" / "NHV_Pkg_Q02_BriefGreet - 004128_NightsHarvest.esp.yaml")
    head, tail = tpl.split("Conditions:" + NL, 1)
    _, rest = tail.split("OwnerQuest:", 1)
    rest = rest.replace("004100:NightsHarvest.esp", "000815:NightsHarvest.esp", 1)
    rest = rest.replace("00412D:NightsHarvest.esp", "@TOPIC@", 1)
    for g in f.greets:
        eid = f"NHV_Pkg_Q00V2_{g['pkey']}"
        fid = g["pkg"]
        h = head.replace("FormKey: 004128:NightsHarvest.esp", f"FormKey: {fc.fk(fid)}", 1)
        h = h.replace("EditorID: NHV_Pkg_Q02_BriefGreet", f"EditorID: {eid}", 1)
        conds = f.conds_lines([("stage", "==", g["stage"]), ("cursor", g["lane"], g["ordinal"])])
        text = h + "Conditions:" + NL + NL.join(conds) + NL + "OwnerQuest:" + rest.replace("@TOPIC@", fc.fk(g["topic"]))
        f.files[TEXT / "Packages" / f"{eid} - {fid:06X}_{P}.yaml"] = text


def patch_nm_call(f):
    d = TEXT / "DialogTopics" / "NHV_Q00_NM_Call - 0037ED_NightsHarvest.esp" / "Responses"
    path = next(d.glob("*.yaml"))
    s = rd(path)
    a = s.index("Responses:" + NL)
    b = s.index("Conditions:" + NL)
    s = s[:a] + NL.join(f.resp_lines(f.N["nm_start"]["lines"])) + NL + s[b:]
    wr(path, s)


def patch_core_quest():
    path = TEXT / "Quests" / "NHV_Sys_Core - 000801_NightsHarvest.esp.yaml"
    s = rd(path)
    blk = ("    - MutagenObjectType: ScriptObjectProperty" + NL + "      Name: VeyraDoubtTopic" + NL
           + "      Object: 00457B:NightsHarvest.esp" + NL)
    wr(path, s.replace(blk, ""))


def write_qf(f):
    def frag(i, code):
        return ([f";BEGIN FRAGMENT Fragment_{i}", f"Function Fragment_{i}()", ";BEGIN CODE"] + code
                + [";END CODE", "EndFunction", ";END FRAGMENT", ""])
    corec = ['NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript',
             "If kCore != None"]
    cm = f"0x{f.gid('CursorMain'):06X}"
    cn = f"0x{f.gid('CursorNM'):06X}"
    nm_ord = f.ordinal("hub", "nm_hub")
    inn_ord = f.ordinal("entry", "inn_early")
    code = {
        6: ["SetObjectiveCompleted(50)", "SetObjectiveDisplayed(60)"],
        1: ["SetObjectiveDisplayed(10)", f"NHV_Util.FlowSet({cm}, 0)", f"NHV_Util.FlowSet({cn}, 0)"],
        5: ["setObjectiveCompleted(40)", "setObjectiveDisplayed(50)"],
        3: ["SetObjectiveCompleted(10)", "If IsObjectiveDisplayed(12)", "    SetObjectiveCompleted(12)", "EndIf",
            "SetObjectiveCompleted(15)",
            "SetObjectiveDisplayed(20)", f"NHV_Util.FlowSet({cn}, {nm_ord})", f"NHV_Util.FlowSet({cm}, {inn_ord})"]
           + corec + ["    kCore.SendVeyraToWindpeak()", "    kCore.UpdateNightMother()", "EndIf"],
        2: ["SetObjectiveCompleted(10)", "If IsObjectiveDisplayed(12)", "    SetObjectiveCompleted(12)", "EndIf",
            "SetObjectiveDisplayed(15)"] + corec
           + ["    kCore.BeginVeyraExitSanctuary()", "EndIf"],
        7: ["SetObjectiveCompleted(60)", "If IsObjectiveDisplayed(61)", "    SetObjectiveCompleted(61)", "EndIf",
            "If IsObjectiveDisplayed(80)", "    SetObjectiveCompleted(80)", "EndIf", "CompleteQuest()"],
        4: ["SetObjectiveCompleted(20)", "SetObjectiveDisplayed(30)"] + corec
           + ["    kCore.SendVeyraToWindpeak()", "    kCore.DismissLucien()", "EndIf"],
        0: ["setObjectiveCompleted(30)", "If IsObjectiveDisplayed(31)", "    SetObjectiveCompleted(31)", "EndIf",
            "setObjectiveDisplayed(40)"] + corec + ["    kCore.BeginVeiledPassage()", "EndIf"],
        8: ["SetObjectiveCompleted(60)"],
        9: ["SetObjectiveCompleted(10)", "SetObjectiveDisplayed(12)"],
    }
    o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment", ";NEXT FRAGMENT INDEX 10",
         "Scriptname QF_NHV_Q00_ShadowAtTheDoor_02000815 Extends Quest Hidden", ""]
    for name in ("Veyra", "Babette", "Cicero", "Nazir"):
        o += [f";BEGIN ALIAS PROPERTY {name}", ";ALIAS PROPERTY TYPE ReferenceAlias",
              f"ReferenceAlias Property Alias_{name} Auto", ";END ALIAS PROPERTY", ""]
    for i in (6, 1, 5, 3, 2, 7, 4, 0, 8, 9):
        o += frag(i, code[i])
    o += [";END FRAGMENT CODE - Do not edit anything between this and the begin comment", ""]
    (SCRIPTS / "QF_NHV_Q00_ShadowAtTheDoor_02000815.psc").write_text("\r\n".join(o), encoding="utf-8", newline="")


def main():
    write = "--write" in sys.argv
    f = fc.Flow(SPEC)
    f.emit_globals()
    f.emit_hubs()
    f.emit_roots()
    make_packages(f)
    print(f"topics {f.topics_made}, scenes {len(f.scenes_made)}, scripts {len(f.scripts)}, files {len(f.files)}")
    print("greets:", [(g["node"], g["host"], g["stage"], g["ordinal"]) for g in f.greets])
    print("say codes:", f.say_code)
    live = {n["id"] for n in f.flow["nodes"] if not n.get("obsolete")}
    print("unvisited:", sorted(live - f.visited))
    for n in f.notes:
        print("note:", n)
    if write:
        f.write_all()
        patch_quest(f)
        patch_nm_call(f)
        patch_core_quest()
        write_qf(f)
        print("written")


if __name__ == "__main__":
    main()
