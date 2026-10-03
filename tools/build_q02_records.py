#!/usr/bin/env python3
"""STILLGELEGT (01.10.2026, E50): NICHT MEHR AUSFUEHREN.
Q02 wird seit der Enhanced-Fassung von tools/build_q02_enhanced.py gebaut. Dieser Generator loescht beim Lauf alle
0041xx-Dateien und schreibt die Quest 004100 neu, kennt aber die CK-Ergaenzungen an der Quest (Properties 005954/005961/0057D1/
0057D8/0057D9/005956, Alias-Packages 005960/00595F) und die Enhanced-Aenderungen (Stages 15/45/55, Aliase 8-10, Objectives,
Properties) nicht und wuerde sie ebenso zerstoeren wie die entfernten Alt-Topics wieder anlegen (Lehre 1, docs/plan/Q02-Q03-Enhanced-Plan.md).
Er bleibt nur als historische Referenz im Repo.

Generate the Q02 "Cold Waters" records (FormIDs 004100-0041FF) as Spriggit YAML in plugin-text/ plus the
QF/TIF/SF fragment scripts (M2.2). Re-runnable: existing Q02 files (FormID range 0041xx) are deleted first.

Usage: python tools/build_q02_records.py
Afterwards: tools/plugin_text.ps1 -Direction ToPlugin -Force, then -Direction ToText -Force (round trip),
tools/build.ps1 -Clean, tools/csv_to_plugin.py --check, tools/silent_voice.py.
Texts are NEVER written by hand here: every response/prompt text is read from dialogue/Q02.csv (Rule 4).
"""
import sys

if __name__ == "__main__":
    sys.exit("build_q02_records.py ist stillgelegt (E50): tools/build_q02_enhanced.py benutzen. Dieser Generator wuerde CK-Aenderungen und die Enhanced-Records zerstoeren.")
import csv
import glob
import os
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TEXT = REPO / "plugin-text"
SCRIPTS = REPO / "Data" / "Source" / "Scripts"
P = "NightsHarvest.esp"
Q = 0x4100  # quest
QFK = f"{Q:06X}:{P}"
VEYRA = "000817:" + P
PLAYER = "000014:Skyrim.esm"
DEBUG = "000800:" + P

ROWS = {r["LineID"]: r for r in csv.DictReader(open(REPO / "dialogue" / "Q02.csv", encoding="utf-8-sig", newline=""))}


def L(n):
    return "NHV_Q02_" + n


def fk(n):
    return f"{n:06X}:{P}"


def q(t):
    return "'" + t.replace("'", "''") + "'"


# ---------------------------------------------------------------- id plan
FIX = {}
ids = iter(range(0x4101, 0x4200))


def take(name=None):
    v = next(ids)
    if name:
        FIX[name] = v
    return v


for n in ("VoiceSings", "VoiceTorbjorn", "VoiceDrinksTheBrine", "VoiceHaldor", "VoiceAelius", "VoiceHjorald"):
    take(n)
for n in ("Sings", "Torbjorn", "Drinks", "Haldor", "Aelius", "Hjorald"):
    take("npc" + n)
GLOBALS = ["NHV_Q02_Result", "NHV_Q02_HaldorSaved", "NHV_Q02_Flag_SingsUnproven", "NHV_Q02_Flag_VeyraDisapproval",
           "NHV_Q02_Flag_SideA_Done", "NHV_Q02_Flag_SideB_Done", "NHV_Q02_Flag_AeliusFallback",
           "NHV_Q02_Flag_RewardGiven", "NHV_Q02_FragmentFound", "NHV_Q02_BriefDone", "NHV_Q02_LedgerHeard",
           "NHV_Q02_TrialAnnounced", "NHV_Q02_HollowGreeted", "NHV_Q02_JudgeGreeted", "NHV_Q02_SurrenderGreeted",
           "NHV_Q02_DebriefGreeted"]
G = {g: take() for g in GLOBALS}
BOOK = take()
ACT = {n: take() for n in ("LatestVictim", "TrackClue1", "TrackClue2", "TrackClue3")}
MSG = {n: take() for n in ("Track01", "Track02", "Track03")}
SCENE = {n: take() for n in ("01HaldorDocks", "02VeyraHollow", "03AeliusKill")}
PKG = {n: take() for n in ("VeyraBriefGreet", "SingsHollowGreet", "SingsJudgeGreet", "HjoraldSurrenderGreet",
                           "VeyraDebriefGreet")}

NPCS = {  # key: (id, editor id, name, race, voice key, alias id)
    "Sings": (FIX["npcSings"], "NHV_SingsBeneathIce", "Sings-Beneath-Ice", "013740:Skyrim.esm", "VoiceSings", 2),
    "Torbjorn": (FIX["npcTorbjorn"], "NHV_TorbjornIceVein", "Torbjorn Ice-Vein", "013746:Skyrim.esm", "VoiceTorbjorn", 3),
    "Drinks": (FIX["npcDrinks"], "NHV_DrinksTheBrine", "Drinks-the-Brine", "013740:Skyrim.esm", "VoiceDrinksTheBrine", 4),
    "Haldor": (FIX["npcHaldor"], "NHV_HaldorFrostKnuckle", "Haldor Frost-Knuckle", "013746:Skyrim.esm", "VoiceHaldor", 5),
    "Aelius": (FIX["npcAelius"], "NHV_AeliusVarro", "Aelius Varro", "013744:Skyrim.esm", "VoiceAelius", 6),
    "Hjorald": (FIX["npcHjorald"], "NHV_WatchSergeantHjorald", "Watch-Sergeant Hjorald", "013746:Skyrim.esm",
                "VoiceHjorald", 7),
}
ALIAS = {"Veyra": 1, "Sings": 2, "Torbjorn": 3, "Drinks": 4, "Haldor": 5, "Aelius": 6, "Hjorald": 7}
BASE = {k: fk(v[0]) for k, v in NPCS.items()}
BASE["Veyra"] = VEYRA

FILES = {}  # path -> text


def put(folder, eid, fid, lines, sub=None):
    name = f"{eid} - {fid:06X}_{P}.yaml"
    path = TEXT / folder / (sub or "") / name if sub else TEXT / folder / name
    FILES[path] = "\n".join(lines) + "\n"


# ---------------------------------------------------------------- conditions
OPN = {"==": None, ">=": "GreaterThanOrEqualTo", ">": "GreaterThan", "<=": "LessThanOrEqualTo", "<": "LessThan",
       "!=": "NotEqualTo"}


def cond(fn, data, op="==", val=1, extra=(), flags=()):
    o = ["- MutagenObjectType: ConditionFloat"]
    if OPN[op]:
        o.append(f"  CompareOperator: {OPN[op]}")
    if flags:
        o += ["  Flags:"] + [f"  - {f}" for f in flags]
    o += ["  Data:", f"    MutagenObjectType: {fn}ConditionData"]
    o += [f"    {e}" for e in extra] + [f"    {d}" for d in data]
    if float(val) != 0:
        o.append(f"  ComparisonValue: {val}")
    return o


def C(*items):
    """items: ('stage',op,v) ('id',key) ('glob',name,op,v) ('speech',op,v) ('gold',op,v) ('result',v)"""
    out = []
    for it in items:
        k = it[0]
        if k == "stage":
            out += cond("GetStage", [f"Quest: {QFK}"], it[1], it[2])
        elif k == "id":
            key = it[1]
            if key in ALIAS and key != "Veyra":
                out += cond("GetIsAliasRef", [f"ReferenceAliasIndex: {ALIAS[key]}"] if ALIAS[key] else [], flags=["OR"])
            out += cond("GetIsID", [f"Object: {BASE[key]}"])
        elif k == "glob":
            out += cond("GetGlobalValue", [f"Global: {fk(G[it[1]])}"], it[2], it[3])
        elif k == "speech":
            out += cond("GetActorValue", ["ActorValue: Speech"], it[1], it[2],
                        extra=["RunOnType: Reference", f"Reference: {PLAYER}"])
        elif k == "gold":
            out += cond("GetItemCount", ["ItemOrList: 00000F:Skyrim.esm"], it[1], it[2],
                        extra=["RunOnType: Reference", f"Reference: {PLAYER}"])
    return out


# ---------------------------------------------------------------- fragment scripts
def write_script(name, kind, fragments, props=(), body_extra=""):
    """fragments: list of (function_body_lines). props: (type, name)"""
    o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment",
         f";NEXT FRAGMENT INDEX {len(fragments)}"]
    hidden = {"TopicInfo": "TopicInfo Hidden", "Scene": "Scene Hidden", "Quest": "Quest Hidden"}[kind]
    o.append(f"Scriptname {name} Extends {hidden}")
    o.append("")
    for i, code in enumerate(fragments):
        o.append(f";BEGIN FRAGMENT Fragment_{i}")
        if kind == "TopicInfo":
            o += [f"Function Fragment_{i}(ObjectReference akSpeakerRef)", "Actor akSpeaker = akSpeakerRef as Actor"]
        else:
            o.append(f"Function Fragment_{i}()")
        o += [";BEGIN CODE"] + code + [";END CODE", "EndFunction", ";END FRAGMENT", ""]
    o.append(";END FRAGMENT CODE - Do not edit anything between this and the begin comment")
    o.append("")
    for t, n in props:
        o.append(f"{t} Property {n} Auto")
    (SCRIPTS / f"{name}.psc").write_text("\r\n".join(o) + "\r\n", encoding="utf-8", newline="")


def vmad_info(scriptname, props):
    o = ["VirtualMachineAdapter:", "  Scripts:", f"  - Name: {scriptname}"]
    if props:
        o.append("    Properties:")
        for n, v in props.items():
            o += ["    - MutagenObjectType: ScriptObjectProperty", f"      Name: {n}", f"      Object: {v}"]
    o += ["  ScriptFragments:", "    MutagenObjectType: ScriptFragments", f"    FileName: {scriptname}", "    OnEnd:",
          "      ExtraBindDataVersion: 1", f"      ScriptName: {scriptname}", "      FragmentName: Fragment_0"]
    return o


# ---------------------------------------------------------------- dialogue
TOPICS = []  # dicts


def T(name, infos, prompt=None, kind="player", top=True, links=(), speaker=None):
    TOPICS.append(dict(name=name, infos=infos, prompt=prompt, kind=kind, top=top, links=list(links), speaker=speaker))


def I(resp, conds=(), tif=None, props=None, ptypes=None):
    return dict(resp=resp, conds=list(conds), tif=tif, props=props or {}, ptypes=ptypes or {})


def QC(expr):  # TIF code helpers
    return f"(GetOwningQuest() as NHV_Q02Script).{expr}"


def setg(g):  # code + property
    return ([f"{g}.SetValueInt(1)"], {g: fk(G[g])}, {g: "GlobalVariable"})


def tif(*parts):
    code, props, pt = [], {}, {}
    for c, p, t in parts:
        code += c
        props.update(p)
        pt.update(t)
    return code, props, pt


def code(*lines):
    return (list(lines), {}, {})


def II(resp, conds=(), t=None):
    return I(resp, conds, t)


S10 = ("stage", "==", 10)
STAGE_10_20 = [("stage", ">=", 10), ("stage", "<=", 20)]

# 1 Veyra brief (ForceGreet, Veyra speaks first)
T("VeyraBrief", [I(["010_01", "010_02", "010_03"], [("stage", "==", 10), ("id", "Veyra"), ("glob", "NHV_Q02_BriefDone", "==", 0)],
                   tif(setg("NHV_Q02_BriefDone")))], speaker="Veyra")
# 2 Torbjorn / Docks
T("Docks", [
    I(["020_01", "020_02"], [("stage", "==", 20), ("id", "Torbjorn")], code("GetOwningQuest().SetStage(30)")),
    I(["010_11", "010_12"], [("stage", "==", 10), ("id", "Torbjorn")])], prompt="010_10")
TORB = lambda: [("stage", ">=", 10), ("id", "Torbjorn")]
T("DocksCount", [I(["010_14"], TORB())], prompt="010_13", top=False)
T("DocksComplaints", [I(["010_16"], TORB())], prompt="010_15", top=False)
T("DocksArgonians", [I(["010_18"], TORB(), tif(setg("NHV_Q02_LedgerHeard")))], prompt="010_17", top=False)
T("DocksKnot", [I(["020_04"], [("stage", ">=", 20), ("id", "Torbjorn")])], prompt="020_03", top=False)
T("DocksBody", [I(["020_06"], [("stage", ">=", 20), ("id", "Torbjorn")])], prompt="020_05", top=False)
T("DocksLast", [I(["020_08"], [("stage", ">=", 20), ("id", "Torbjorn")])], prompt="020_07", top=False)
# Drinks
DR = [("stage", ">=", 10), ("stage", "<=", 20), ("id", "Drinks")]
T("DrinksAsk", [I(["010_19", "010_21"], DR + [("glob", "NHV_Q02_LedgerHeard", "==", 1)]), I(["010_21"], DR)],
  prompt="010_20")
T("DrinksPersuade", [I(["010_31"], DR + [("speech", ">=", 30)]), I(["010_32"], DR + [("speech", "<", 30)])],
  prompt="010_30", top=False)
T("DrinksBribe", [I(["010_41"], DR + [("gold", ">=", 25)],
                    code("Game.GetPlayer().RemoveItem(Game.GetForm(0x0000000F), 25, False, akSpeaker)"))],
  prompt="010_40", top=False)
# Scene 1 topics
T("HaldorHarass", [I(["030_01", "030_02"])], kind="scene", speaker="Haldor")
T("HaldorPull", [I(["030_10"], [("glob", "NHV_Q02_HaldorSaved", "==", 1)]),
                 I(["030_03"], [("glob", "NHV_Q02_HaldorSaved", "==", 0)])], kind="scene", speaker="Haldor")
# Stage 50: Sings greeting + flat menu
SG = [("stage", "==", 50), ("id", "Sings")]
SM = SG + [("glob", "NHV_Q02_HollowGreeted", "==", 1)]
T("SingsHollowGreet", [I(["050_01", "050_02"], SG + [("glob", "NHV_Q02_HollowGreeted", "==", 0), ("glob", "NHV_Q02_HaldorSaved", "==", 1)],
                         tif(setg("NHV_Q02_HollowGreeted"))),
                       I(["050_01"], SG + [("glob", "NHV_Q02_HollowGreeted", "==", 0)], tif(setg("NHV_Q02_HollowGreeted")))],
  speaker="Sings")
T("SingsBrotherhood", [I(["050_11", "050_30", "050_31"], SM)], prompt="050_10")
T("SingsWitness", [I(["050_21", "050_30", "050_31"], SM + [("glob", "NHV_Q02_HaldorSaved", "==", 0)])], prompt="050_20")
T("SingsBodies", [I(["050_41"], SM)], prompt="050_40")
T("SingsKillWell", [I(["050_51"], SM)], prompt="050_50")
T("SingsProtect", [I(["050_53"], SM)], prompt="050_52")
T("SingsHands", [I(["050_55"], SM)], prompt="050_54")
T("SingsAelius", [I(["050_57"], SM + [("glob", "NHV_Q02_TrialAnnounced", "==", 0)], code(QC("StartVeyraHollowScene()")))],
  prompt="050_56")
T("SingsVeezara", [I(["050_59"], SM)], prompt="050_58")
# Scene 2
for nm, sp, r in (("HollowV1", "Veyra", ["050_60"]), ("HollowS1", "Sings", ["050_61"]),
                  ("HollowV2", "Veyra", ["050_62", "050_63"]), ("HollowS2", "Sings", ["050_64"]),
                  ("HollowV3", "Veyra", ["050_65"]), ("HollowS3", "Sings", ["050_67"]),
                  ("HollowV4", "Veyra", ["050_68", "050_69", "050_66"])):
    T(nm, [I(r)], kind="scene", speaker=sp)
# after scene: acceptance
SA = SG + [("glob", "NHV_Q02_TrialAnnounced", "==", 1)]
GO60 = code("GetOwningQuest().SetStage(60)")
T("SingsFrame", [I(["050_71", "050_95"], SA, GO60)], prompt="050_70")
T("SingsLeash", [I(["050_81", "050_95"], SA + [("speech", ">=", 30)], GO60)], prompt="050_80")
T("SingsIWill", [I(["050_91", "050_95"], SA, GO60)], prompt="050_90")
# Scene 3
for nm, sp, r in (("KillA1", "Aelius", ["060_01"]), ("KillS1", "Sings", ["060_02"]),
                  ("KillA2", "Aelius", ["060_03", "060_05"]), ("KillS2", "Sings", ["060_06"]),
                  ("KillA3", "Aelius", ["060_07"]), ("KillS3", "Sings", ["060_08"]),
                  ("KillA4", "Aelius", ["060_09"]), ("KillS4", "Sings", ["060_04"])):
    T(nm, [I(r)], kind="scene", speaker=sp)
# Stage 70
J = [("stage", "==", 70), ("id", "Sings")]
JG = J + [("glob", "NHV_Q02_JudgeGreeted", "==", 1)]
JR = JG + [("glob", "NHV_Q02_Result", "==", 0)]
T("SingsJudgeGreet", [
    I(["070_01", "070_02", "070_03", "070_05", "070_06", "070_04"],
      J + [("glob", "NHV_Q02_JudgeGreeted", "==", 0), ("glob", "NHV_Q02_FragmentFound", "==", 1)], tif(setg("NHV_Q02_JudgeGreeted"))),
    I(["070_01", "070_04"], J + [("glob", "NHV_Q02_JudgeGreeted", "==", 0)], tif(setg("NHV_Q02_JudgeGreeted")))],
  speaker="Sings")
T("SingsAccountable", [I(["070_08"], JG + [("glob", "NHV_Q02_FragmentFound", "==", 1)])], prompt="070_07")
T("JudgeRecruit", [I(["070_11"], JR, code(QC("JudgeRecruit()")))], prompt="070_10")
T("JudgeRelease", [I(["070_21"], JR, code(QC("JudgeRelease()")))], prompt="070_20")
T("JudgeSilence", [I(["070_31"], JR, code(QC("JudgeSilence()")))], prompt="070_30")
T("JudgeSurrender", [I(["070_41"], JR, code(QC("JudgeSurrender()")))], prompt="070_40")
T("HjoraldTakes", [I(["070_42", "070_43"], [("id", "Hjorald"), ("glob", "NHV_Q02_Result", "==", 4),
                                            ("glob", "NHV_Q02_SurrenderGreeted", "==", 0)],
                     tif(setg("NHV_Q02_SurrenderGreeted"), code(QC("FinishSurrender()"))))], speaker="Hjorald")
# Stage 100
D = [("stage", ">=", 100), ("id", "Veyra"), ("glob", "NHV_Q02_DebriefGreeted", "==", 0)]
DT = tif(setg("NHV_Q02_DebriefGreeted"), code(QC("GiveRecruitReward()")))
T("VeyraDebrief", [I(["100_01"], D + [("glob", "NHV_Q02_Result", "==", 1)], DT),
                   I(["100_02"], D + [("glob", "NHV_Q02_Result", "==", 3)], DT),
                   I(["100_03"], D + [("glob", "NHV_Q02_Result", "==", 2)], DT),
                   I(["100_04"], D + [("glob", "NHV_Q02_Result", "==", 4)], DT)],
  speaker="Veyra", links=["DebriefFragment", "DebriefMoral"])
DV = [("stage", ">=", 100), ("id", "Veyra")]
T("DebriefFragment", [I(["100_11"], DV + [("glob", "NHV_Q02_FragmentFound", "==", 1)])], prompt="100_10", top=False)
T("DebriefMoral", [I(["100_06"], DV)], prompt="100_05", top=False)

LINKS = {"Docks": ["DocksCount", "DocksKnot"], "DocksCount": ["DocksComplaints"], "DocksComplaints": ["DocksArgonians"],
         "DocksKnot": ["DocksBody"], "DocksBody": ["DocksLast"], "DrinksAsk": ["DrinksPersuade", "DrinksBribe"]}
for t in TOPICS:
    t["links"] = LINKS.get(t["name"], t["links"])


def emit_dialogue():
    keys = {}
    for t in TOPICS:
        keys[t["name"]] = dict(topic=take(), branch=None, infos=[])
        if t["kind"] == "player" and t["top"]:
            keys[t["name"]]["branch"] = take()
        for _ in t["infos"]:
            keys[t["name"]]["infos"].append(take())
    for t in TOPICS:
        k = keys[t["name"]]
        eid = L(t["name"])
        # branch inheritance for follow-ups: branch of the topic that links to it
        if t["kind"] == "player" and not t["top"]:
            parent = next(p for p in TOPICS if t["name"] in p["links"])
            while keys[parent["name"]]["branch"] is None:
                parent = next(p for p in TOPICS if parent["name"] in p["links"])
            k["branch_ref"] = keys[parent["name"]]["branch"]
        else:
            k["branch_ref"] = k["branch"]
        rec = [f"FormKey: {fk(k['topic'])}", f"EditorID: {eid}", "Priority: 60"]
        if t["kind"] == "scene":
            rec += [f"Quest: {QFK}", "Category: Scene", "Subtype: Scene", "SubtypeName: SCEN"]
        else:
            rec += [f"Branch: {fk(k['branch_ref'])}", f"Quest: {QFK}", "SubtypeName: CUST"]
        d = TEXT / "DialogTopics" / f"{eid} - {k['topic']:06X}_{P}"
        FILES[d / "RecordData.yaml"] = "\n".join(rec) + "\n"
        if k["branch"]:
            put("DialogBranches", eid + "_Branch", k["branch"],
                [f"FormKey: {fk(k['branch'])}", f"EditorID: {eid}_Branch", f"Quest: {QFK}", "Category: Player", "Flags:",
                 "- TopLevel", f"StartingTopic: {fk(k['topic'])}"])
        prompt_txt = ROWS[L(t["prompt"])]["Text"].strip() if t["prompt"] else None
        prev = None
        for n, info in enumerate(t["infos"], 1):
            iid = k["infos"][n - 1]
            ieid = f"{eid}_INFO{n:02d}"
            o = [f"FormKey: {fk(iid)}", f"EditorID: {ieid}"]
            tifname = None
            if info["tif"]:
                tcode, tprops, tptypes = info["tif"]
                tifname = f"TIF__02{iid:06X}"
                write_script(tifname, "TopicInfo", [tcode], [(tptypes[n2], n2) for n2 in tprops])
                o += vmad_info(tifname, tprops)
            if t["kind"] == "scene" or prompt_txt is None:
                o += ["Flags:", "  Flags:", "  - ForceSubtitle"]
            else:
                o.append("Flags: {}")
            o += [f"PreviousDialog: {fk(prev) if prev else 'Null'}", "FavorLevel: None"]
            if t["links"]:
                o += ["LinkTo:"] + [f"- {fk(keys[c]['topic'])}" for c in t["links"]]
            o.append("Responses:")
            for i, r in enumerate(info["resp"], 1):
                row = ROWS[L(r)]
                if row["Emotion"] != "Neutral":
                    o += [f"- Emotion: {row['Emotion']}", f"  EmotionValue: {row['Value']}"]
                else:
                    o.append(f"- EmotionValue: {row['Value']}")
                o += [f"  ResponseNumber: {i}", "  Unknown2: 0x000000", "  Unknown3: 0x000000", "  Text:",
                      "    TargetLanguage: English", f"    Value: {q(row['Text'].strip())}"]
                notes = L(r) + (f" prompt={L(t['prompt'])}" if i == 1 and t["prompt"] else "")
                o += [f"  ScriptNotes: {notes}", "  Edits: ''"]
            if info["conds"]:
                o.append("Conditions:")
                o += C(*info["conds"])
            if prompt_txt is not None:
                o += ["Prompt:", "  TargetLanguage: English", f"  Value: {q(prompt_txt)}"]
            spk = t["speaker"]
            if spk:
                o.append(f"Speaker: {BASE[spk]}")
            FILES[d / "Responses" / f"{ieid} - {iid:06X}_{P}.yaml"] = "\n".join(o) + "\n"
            prev = iid
    return keys


KEYS = emit_dialogue()
TK = {n: k["topic"] for n, k in KEYS.items()}

# ---------------------------------------------------------------- simple records
for n, (fid, eid, nm, race, vk, al) in NPCS.items():
    base = (TEXT / "Npcs" / "NHV_Hakan - 004006_NightsHarvest.esp.yaml").read_text(encoding="utf-8")
    base = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fk(fid)}", base, count=1)
    base = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", base, count=1)
    base = re.sub(r"(?m)^Voice: .*$", f"Voice: {fk(FIX[vk])}", base, count=1)
    base = re.sub(r"(?m)^Race: .*$", f"Race: {race}", base, count=1)
    base = re.sub(r"(?m)^Packages:\n(?:- .*\n)+", "", base, count=1)
    base = base.replace("Value: Hakan", f"Value: {nm}", 1)
    FILES[TEXT / "Npcs" / f"{eid} - {fid:06X}_{P}.yaml"] = base
for v in ("VoiceSings", "VoiceTorbjorn", "VoiceDrinksTheBrine", "VoiceHaldor", "VoiceAelius", "VoiceHjorald"):
    put("VoiceTypes", "NHV_" + v, FIX[v], [f"FormKey: {fk(FIX[v])}", f"EditorID: NHV_{v}", "Flags:", "- AllowDefaultDialog"])
for g, v in G.items():
    put("Globals", g, v, ["MutagenObjectType: GlobalShort", f"FormKey: {fk(v)}", f"EditorID: {g}", "Data: 0"])

# dispatch book (text from dialogue/Books.csv)
bk = {r["LineID"]: r for r in csv.DictReader(open(REPO / "dialogue" / "Books.csv", encoding="utf-8-sig", newline=""))}
paras = [p.strip() for p in bk["NHV_SYS_BOOK_82"]["Text"].replace("\\n", "\n").split("\n\n") if p.strip()]
btext = [f'<p align="center"><font size="32">{paras[0]}</font></p>'] + [f'<p align="left">{p}</p>' for p in paras[1:]]
o = [f"FormKey: {fk(BOOK)}", "EditorID: NHV_Note_Dispatch02", "ObjectBounds:", "  First: -6, -9, 0", "  Second: 6, 8, 1",
     "Name:", "  TargetLanguage: English", "  Value: Oculatus Dispatch", "Model:",
     "  File: Clutter\\Books\\JournalLowPoly01.nif", "  Data: 0x020000000000000000000000", "BookText:",
     "  TargetLanguage: English", "  Value: >-"]
for i, pline in enumerate(btext):
    if i:
        o.append("")
    o.append("    " + pline)
o += ["Flags:", "- CantBeTaken", "Teaches:", "  MutagenObjectType: BookTeachesNothing", "InventoryArt: 0B7E3D:Skyrim.esm",
      "Description:", "  TargetLanguage: English", "  Value: ''"]
put("Books", "NHV_Note_Dispatch02", BOOK, o)

# tracking messages (texts from CSV)
for i, (n, fid) in enumerate(MSG.items(), 1):
    put("Messages", f"NHV_Msg_Q02_{n}", fid,
        [f"FormKey: {fk(fid)}", f"EditorID: NHV_Msg_Q02_{n}", "Description:", "  TargetLanguage: English", "  Value: >-",
         "    " + ROWS[L(f"040_0{i}")]["Text"].strip(), "INAM: 0x00000000", "Flags:", "- MessageBox"])
# activators with the generic stage script


def activator(n, eid, name, req, tgt, msg):
    fid = ACT[n]
    o = [f"FormKey: {fk(fid)}", f"EditorID: {eid}", "VirtualMachineAdapter:", "  Scripts:",
         "  - Name: NHV_Q02_StageActivatorScript", "    Properties:",
         "    - MutagenObjectType: ScriptObjectProperty", "      Name: OwningQuest", f"      Object: {QFK}",
         "    - MutagenObjectType: ScriptObjectProperty", "      Name: NHV_Cfg_Debug", f"      Object: {DEBUG}",
         "    - MutagenObjectType: ScriptIntProperty", "      Name: RequiredStage", f"      Data: {req}",
         "    - MutagenObjectType: ScriptIntProperty", "      Name: TargetStage", f"      Data: {tgt}"]
    if msg:
        o += ["    - MutagenObjectType: ScriptObjectProperty", "      Name: ClueMessage", f"      Object: {fk(MSG[msg])}"]
    o += ["ObjectBounds:", "  First: -43, 0, -20", "  Second: 43, 2, 20", "Name:", "  TargetLanguage: English",
          f"  Value: {name}", "Model:", "  File: Clutter\\WeaponRack\\WRPlaque01.nif", "  Data: 0x020000000000000000000000",
          "MarkerColor: '#00CC4C33'", "Flags: []"]
    put("Activators", eid, fid, o)


activator("LatestVictim", "NHV_Act_Q02_LatestVictim", "Examine the body", 10, 20, None)
activator("TrackClue1", "NHV_Act_Q02_TrackClue1", "Examine the marks", 40, 0, "Track01")
activator("TrackClue2", "NHV_Act_Q02_TrackClue2", "Examine the marks", 40, 0, "Track02")
activator("TrackClue3", "NHV_Act_Q02_TrackClue3", "Follow the trail", 40, 50, "Track03")
FILES = {k: v.replace("\n\n", "\n\n") for k, v in FILES.items()}

# ---------------------------------------------------------------- packages (ForceGreet, template from Q00 DoubtGreet)
tpl = (TEXT / "Packages" / "NHV_Pkg_Q00_VeyraDoubtGreet - 004590_NightsHarvest.esp.yaml").read_text(encoding="utf-8")
head, tail = tpl.split("Conditions:\n", 1)
_, rest = tail.split("OwnerQuest:", 1)
PKGDEF = {
    "VeyraBriefGreet": ("BriefGreet", "VeyraBrief", [("stage", "==", 10), ("glob", "NHV_Q02_BriefDone", "==", 0)]),
    "SingsHollowGreet": ("SingsHollowGreet", "SingsHollowGreet", [("stage", "==", 50), ("glob", "NHV_Q02_HollowGreeted", "==", 0)]),
    "SingsJudgeGreet": ("SingsJudgeGreet", "SingsJudgeGreet", [("stage", "==", 70), ("glob", "NHV_Q02_JudgeGreeted", "==", 0)]),
    "HjoraldSurrenderGreet": ("HjoraldSurrenderGreet", "HjoraldTakes", [("glob", "NHV_Q02_Result", "==", 4),
                                                                        ("glob", "NHV_Q02_SurrenderGreeted", "==", 0)]),
    "VeyraDebriefGreet": ("VeyraDebriefGreet", "VeyraDebrief", [("stage", ">=", 100), ("glob", "NHV_Q02_DebriefGreeted", "==", 0)]),
}
for key, (short, topic, conds) in PKGDEF.items():
    fid = PKG[key]
    eid = f"NHV_Pkg_Q02_{short}"
    h = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fk(fid)}", head, count=1)
    h = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", h, count=1)
    r = rest.replace("000815:NightsHarvest.esp", QFK, 1)
    r = r.replace("00457B:NightsHarvest.esp", fk(TK[topic]), 1)
    FILES[TEXT / "Packages" / f"{eid} - {fid:06X}_{P}.yaml"] = h + "Conditions:\n" + "\n".join(C(*conds)) + "\nOwnerQuest:" + r

# ---------------------------------------------------------------- scenes
def scene(key, eid, sfshort, actors, seq, endcode):
    fid = SCENE[key]
    sfname = f"SF_NHV_Scn_Q02_{sfshort}_02{fid:06X}"
    write_script(sfname, "Scene", [endcode])
    o = [f"FormKey: {fk(fid)}", f"EditorID: {eid}", "VirtualMachineAdapter:", "  Scripts:", f"  - Name: {sfname}",
         "  ScriptFragments:", f"    FileName: {sfname}", "    OnEnd:", "      ExtraBindDataVersion: 1",
         f"      ScriptName: {sfname}", "      FragmentName: Fragment_0", "Flags: []", "Phases:"]
    o += ["- Name: ''", "  Unused2: {}", "  EditorWidth: 200"] * len(seq)
    o.append("Actors:")
    for a in actors:
        o += [f"- ID: {a}", "  Flags: []", "  BehaviorFlags:", "  - DeathEnd", "  - CombatEnd", "  - DialoguePause"]
    o.append("Actions:")
    for i, (topic, aid) in enumerate(seq):
        o += [f"- Name: {L(topic)}", f"  ActorID: {aid}", f"  Index: {i + 1}", f"  StartPhase: {i}", f"  EndPhase: {i}",
              f"  Topic: {fk(TK[topic])}", "  HeadtrackActorID: 0", "  LoopingMax: 10", "  LoopingMin: 1",
              "  Emotion: Neutral", "  EmotionValue: 0"]
    o += [f"Quest: {QFK}", f"LastActionIndex: {len(seq)}", "VNAM: 0x00000000000000000300000003000000"]
    put("Scenes", eid, fid, o)


scene("01HaldorDocks", "NHV_Scn_Q02_01HaldorDocks", "01Docks", [2, 5], [("HaldorHarass", 5), ("HaldorPull", 5)],
      ["NHV_Q02Script kQ02 = GetOwningQuest() as NHV_Q02Script", "If kQ02 != None", "    kQ02.EndHaldorDocksScene()", "EndIf"])
scene("02VeyraHollow", "NHV_Scn_Q02_02VeyraHollow", "02Hollow", [1, 2],
      [("HollowV1", 1), ("HollowS1", 2), ("HollowV2", 1), ("HollowS2", 2), ("HollowV3", 1), ("HollowS3", 2), ("HollowV4", 1)],
      ["NHV_Q02Script kQ02 = GetOwningQuest() as NHV_Q02Script", "If kQ02 != None", "    kQ02.EndVeyraHollowScene()", "EndIf"])
scene("03AeliusKill", "NHV_Scn_Q02_03AeliusKill", "03Kill", [2, 6],
      [("KillA1", 6), ("KillS1", 2), ("KillA2", 6), ("KillS2", 2), ("KillA3", 6), ("KillS3", 2), ("KillA4", 6), ("KillS4", 2)],
      ["NHV_Q02Script kQ02 = GetOwningQuest() as NHV_Q02Script", "If kQ02 != None", "    Bool bPlayerKilled = kQ02.KillAelius()", "    kQ02.EndAeliusKillScene(bPlayerKilled)", "EndIf"])

# ---------------------------------------------------------------- quest
STAGES = {10: "Investigate the bodies in Windhelm's harbor.", 20: "Examine the latest victim.",
          30: "Watch the docks at night.", 40: "Follow the killer without being seen.", 50: "Confront the killer.",
          60: "Help Sings-Beneath-Ice kill Aelius the harbor clerk.", 70: "Decide Sings-Beneath-Ice's fate.",
          100: "Return to Veyra."}
qfname = f"QF_NHV_Q02_ColdWaters_02{Q:06X}"
ORD = list(STAGES)
qf = []
for i, st in enumerate(ORD):
    c = []
    prev = ORD[i - 1] if i else None
    if prev:
        c.append(f"SetObjectiveCompleted({prev})")
    c.append(f"SetObjectiveDisplayed({st})")
    if st in (10, 100):
        c += ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None", "    kQ02.FillVeyraAlias()", "EndIf"]
    if st == 30:
        c += ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None", "    kQ02.SetHaldorSaved(False)",
              "    kQ02.BeginNightWatch()", "EndIf"]
    if st == 50:
        c += ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None", "    kQ02.MoveSingsToHollow()", "EndIf"]
    if st == 60:
        c += ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None", "    kQ02.BeginKillWatch()", "EndIf"]
    if st == 70:
        c += ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None", "    kQ02.GiveOculatusFragment()", "EndIf"]
    qf.append(c)
write_script(qfname, "Quest", qf)


def objprop(name, obj, alias=None):
    o = ["    - MutagenObjectType: ScriptObjectProperty", f"      Name: {name}", f"      Object: {obj}"]
    if alias is not None:
        o.append(f"      Alias: {alias}")
    return o


pl = {  # sorted alphabetically like the CK
    "AeliusAlias": (QFK, 6), "AeliusKillScene": (fk(SCENE["03AeliusKill"]), None),
    "Core": ("000801:" + P, None), "DrinksAlias": (QFK, 4), "Gold001": ("00000F:Skyrim.esm", None),
    "HaldorAlias": (QFK, 5), "HaldorDocksScene": (fk(SCENE["01HaldorDocks"]), None), "HjoraldAlias": (QFK, 7),
    "NHV_Cfg_Debug": (DEBUG, None), "NHV_FamilyFaction": ("000807:" + P, None),
    "NHV_Q02_Flag_AeliusFallback": (fk(G["NHV_Q02_Flag_AeliusFallback"]), None),
    "NHV_Q02_Flag_RewardGiven": (fk(G["NHV_Q02_Flag_RewardGiven"]), None),
    "NHV_Q02_Flag_SideA_Done": (fk(G["NHV_Q02_Flag_SideA_Done"]), None),
    "NHV_Q02_Flag_SideB_Done": (fk(G["NHV_Q02_Flag_SideB_Done"]), None),
    "NHV_Q02_Flag_SingsUnproven": (fk(G["NHV_Q02_Flag_SingsUnproven"]), None),
    "NHV_Q02_Flag_VeyraDisapproval": (fk(G["NHV_Q02_Flag_VeyraDisapproval"]), None),
    "NHV_Q02_FragmentFound": (fk(G["NHV_Q02_FragmentFound"]), None),
    "NHV_Q02_HaldorSaved": (fk(G["NHV_Q02_HaldorSaved"]), None), "NHV_Q02_Result": (fk(G["NHV_Q02_Result"]), None),
    "NHV_Q02_TrialAnnounced": (fk(G["NHV_Q02_TrialAnnounced"]), None), "NHV_Status_Sings": ("000812:" + P, None),
    "OculatusFragment2": (fk(BOOK), None), "PlayerRef": (PLAYER, None), "SingsAlias": (QFK, 2),
    "SingsFamilySlotAlias": ("000813:" + P, 3), "TorbjornAlias": (QFK, 3), "VeyraAlias": (QFK, 1),
    "VeyraHollowScene": (fk(SCENE["02VeyraHollow"]), None),
}
o = [f"FormKey: {QFK}", "EditorID: NHV_Q02_ColdWaters", "VirtualMachineAdapter:", "  Scripts:", "  - Name: NHV_Q02Script",
     "    Properties:"]
for n in sorted(pl):
    o += objprop(n, *pl[n])
o += [f"  - Name: {qfname}", f"  FileName: {qfname}", "  Fragments:"]
for i, st in enumerate(ORD):
    o += [f"  - Stage: {st}", "    Unknown2: 1", f"    ScriptName: {qfname}", f"    FragmentName: Fragment_{i}"]
o.append("  Aliases:")


def alias_scr(idx, scripts):
    r = ["  - Property:", "      Name: ''", f"      Object: {QFK}", f"      Alias: {idx}", "    Scripts:"]
    for sn, pr in scripts:
        r += [f"    - Name: {sn}", "      Properties:"]
        for pn, pv in pr:
            r += ["      - MutagenObjectType: ScriptObjectProperty", f"        Name: {pn}", f"        Object: {pv}"]
    return r


o += alias_scr(0, [("NHV_ContractPlayerAliasScript", [("OwningContract", QFK)])])
o += alias_scr(2, [("NHV_ContractRecruitAliasScript", [("NHV_Cfg_Debug", DEBUG), ("OwningContract", QFK),
                                                          ("StatusGlobal", "000812:" + P)]),
                   ("NHV_Q02_SingsAliasScript", [("NHV_Cfg_Debug", DEBUG), ("OwningQuest", QFK)])])
o += alias_scr(5, [("NHV_Q02_HaldorAliasScript", [("NHV_Cfg_Debug", DEBUG), ("OwningQuest", QFK)])])
o += ["Name:", "  TargetLanguage: English", "  Value: Cold Waters", "Priority: 90", "Type: DarkBrotherhood", "Stages:"]
for st, txt in STAGES.items():
    o += [f"- Index: {st}", "  LogEntries:", "  - Flags:" + (" []" if st != 100 else "")]
    if st == 100:
        o.append("    - CompleteQuest")
    o += ["    Entry:", "      TargetLanguage: English", f"      Value: {q(txt)}"]
o.append("Objectives:")
for st, txt in STAGES.items():
    o += [f"- Index: {st}", "  Flags: []", "  DisplayText:", "    TargetLanguage: English", f"    Value: {q(txt)}"]
o += ["NextAliasID: 8", "Aliases:"]
o += ["- Name: PlayerRefAlias", "  Flags:", "  - Optional", f"  ForcedReference: {PLAYER}", "  VoiceTypes: Null"]
o += ["- ID: 1", "  Name: VeyraAlias", "  Flags:", "  - Optional", "  PackageData:", f"  - {fk(PKG['VeyraBriefGreet'])}",
      f"  - {fk(PKG['VeyraDebriefGreet'])}", "  VoiceTypes: Null"]
pk = {"Sings": [PKG["SingsHollowGreet"], PKG["SingsJudgeGreet"]], "Hjorald": [PKG["HjoraldSurrenderGreet"]]}
for n in ("Sings", "Torbjorn", "Drinks", "Haldor", "Aelius", "Hjorald"):
    fid, eid, nm, race, vk, al = NPCS[n]
    o += [f"- ID: {al}", f"  Name: {n}Alias", "  Flags:", "  - Optional", f"  UniqueActor: {fk(fid)}"]
    if n in pk:
        o += ["  PackageData:"] + [f"  - {fk(x)}" for x in pk[n]]
    o.append("  VoiceTypes: Null")
put("Quests", "NHV_Q02_ColdWaters", Q, o)
# quest file name pattern in repo: "<EditorID> - <ID>_NightsHarvest.esp.yaml"

# ---------------------------------------------------------------- write
if max(int(re.search(r"^FormKey: (\w{6})", v, re.M).group(1), 16) for v in FILES.values() if v.startswith("FormKey")) > 0x41FF:
    sys.exit("FormID range exhausted")
for f in glob.glob(str(TEXT / "**" / "*"), recursive=True):
    pth = Path(f)
    if pth.is_file() and re.search(r" - 0041[0-9A-F]{2}_NightsHarvest\.esp", str(pth)):
        pth.unlink()
for path, text in FILES.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8", newline="\n")
print(f"{len(FILES)} files written")
