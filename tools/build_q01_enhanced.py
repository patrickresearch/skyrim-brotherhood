#!/usr/bin/env python3
"""Build the Q01 "Enhanced" arc (dialogue/drafts/enhanced/Q01/) into plugin-text/ with tools/flow_compiler.py.

The enhanced draft is written as linear exchanges (player line, NPC answer, ...). seq() turns such an exchange into a
chain of one-choice hubs, so every player line is a menu entry the player selects; NPC-first passages become
Hello/scene entries. The world events (map markers, scavengers, watchpost, Quintus' whereabouts, ...) call functions
of NHV_Q01Script; the CK-side work is described in docs/ck/M1.7-Q01-Enhanced-CK-Anleitung.md.

Usage: python tools/build_q01_enhanced.py --activate   # merge the enhanced CSVs into dialogue/*.csv first (once)
       python tools/build_q01_enhanced.py              # compile and print the report
       python tools/build_q01_enhanced.py --write      # write records, fragments, quest patches
"""
import csv
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import flow_compiler as fc  # noqa: E402
import build_q01_v2 as v2   # noqa: E402  (helpers only)

REPO = fc.REPO
TEXT = fc.TEXT
P = "NightsHarvest.esp"
NL = "\n"
Q01 = 0x004000
ENH = REPO / "dialogue" / "drafts" / "enhanced" / "Q01"
V2DIR = REPO / "dialogue" / "drafts" / "Q01-v2"

# fixed FormIDs of the new records (0x7F10-0x7F3F are reserved for them)
ID_SCAV, ID_SCOUT = 0x7F20, 0x7F21
ID_VSCAV, ID_VSCOUT = 0x7F22, 0x7F23
ID_MARKER = 0x7F24
ID_BOOKS = {"EirikLedger": 0x7F11, "BurnedNote": 0x7F12, "OculatusFieldNote": 0x7F13, "MoorsideRegister": 0x7F14,
             "PatrolSlip": 0x7F15}
ID_LETTER = 0x7F10
ID_PKG_VEYRA = 0x7F30

# ------------------------------------------------------------------------------------------------ rows / helpers
ROWS = {r["LineID"]: r for r in csv.DictReader(open(ENH / "Q01.csv", encoding="utf-8-sig", newline=""))}
BY_NUM = {int(k.rsplit("_", 1)[1]): k for k in ROWS}
JROWS = {r["LineID"]: r for r in csv.DictReader(open(ENH / "Journal.csv", encoding="utf-8-sig", newline=""))}
JBY = {int(k.rsplit("_", 1)[1]): k for k in JROWS}
BROWS = {r["LineID"]: r for r in csv.DictReader(open(ENH / "Books.csv", encoding="utf-8-sig", newline=""))}
BBY = {int(k.rsplit("_", 1)[1]): k for k in BROWS}


def L(n):
    return BY_NUM[n]


def spk(n):
    return ROWS[BY_NUM[n]]["Speaker"]


NODES, CODE, LANE = [], {}, {}


def node(nid, stage, lines=(), choices=None, nxt=None, effects=None, code=None, req=None, lane="Main", **kw):
    d = dict(id=nid, stage=stage, title=nid, lines=[L(n) if isinstance(n, int) else n for n in lines])
    if choices:
        d["choices"] = choices
    if nxt:
        d["next"] = nxt
    if effects:
        d["effects"] = effects
    if req:
        d["requires"] = req
    d.update(kw)
    NODES.append(d)
    if code:
        CODE[nid] = code
    LANE[nid] = lane
    return d


def seq(base, nums, stage, nxt=None, effects=None, code=None, req=None, lane="Main", tail=None):
    """Exchange -> chain of one-choice hubs. nums: enhanced line numbers (player and NPC)."""
    segs, cur = [], (None, [])
    for n in nums:
        if spk(n) == "Player":
            segs.append(cur)
            cur = (n, [])
        else:
            cur[1].append(n)
    segs.append(cur)
    for k, (pn, npc) in enumerate(segs):
        nid = base if k == 0 else f"{base}_{k}"
        last = k + 1 == len(segs)
        ch = None
        if not last:
            ch = [dict(line=L(segs[k + 1][0]), to=f"{base}_{k + 1}")]
        elif tail:
            ch = tail
        node(nid, stage, npc, choices=ch, nxt=(nxt if last and not tail else None),
             effects=(effects if last else None), code=(code if last else None), req=(req if k == 0 else None), lane=lane)


_Q = [0]


def q01(call):
    """Fragment snippet calling NHV_Q01Script; the variable name is unique per snippet (one fragment may hold several)."""
    _Q[0] += 1
    v = f"kQ01_{_Q[0]}"
    return [f'NHV_Q01Script {v} = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script',
            f"If {v} != None", f"    {v}.{call}", "EndIf"]


def fobj(done, show):
    return [f"NHV_Util.FlowObjective(0x004000, {done}, {show})"]


def GO(*parts):
    out = []
    for p in parts:
        out += p
    return out


# ------------------------------------------------------------------------------------------------ the arc
def build_nodes():
    NODES.clear(), CODE.clear(), LANE.clear()
    # 1 briefing + Hakan (both at stage 10; Hakan's thread runs beside Veyra's)
    seq("briefing", range(2000, 2007), 10, nxt="hakan")
    seq("hakan", range(2010, 2021), 10, nxt="reed", lane="Hakan")
    # 2 reedbed scavengers (Hello), then the marker goes back to Hakan (Hello, only with the marker in the inventory)
    seq("reed", range(2021, 2026), 12, code=q01("ReedbedHostile()"), lane="Scav")
    seq("hret", [2026, 2027, 2028, 2029], 12, nxt="farm", effects={"markerReturned": True}, lane="Hakan",
        code=GO(q01("OnMarkerReturned()"), fobj(9003, 9004)))
    # 3 the farm (Veyra is with the player from stage 20), then the boot prints
    seq("farm", range(2100, 2108), 20, nxt="tracks")
    seq("tracks", [2108, 2109], 20, nxt="scout", effects={"farmInspected": True}, req={"clue": True},
        code=GO(q01("EnableMarker(2)"), fobj(9005, 9006)))
    # 4 watchpost: the scout answers once the soldiers are down
    # the scout is a hub (always available at stage 25, no Hello that can be missed): the player opens with the evidence (2121),
    # the scout answers 2122 ... 2126; 2120 (observation without a listener) stays unused (ingame test 01.10.2026)
    seq("scout", range(2121, 2127), 25, nxt="camp", effects={"scoutTold": True}, lane="Scout",
        code=q01("GoToCamp()"))
    # 5 Hrefna's camp (ambush scene 402B), story questions before the plan
    camp = [2110, 2111, 2112, 2200, 2201, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2215, 2216, 2217, 2218,
            2211, 2212, 2213, 2214]  # 2209/2210 ("come back with me") dropped: she waits in the camp until the player returns (01.10.2026)
    seq("camp", camp, 30, nxt="qintro")
    # 6 Quintus in Morthal
    seq("qintro", range(2303, 2312), 40, nxt="qreveal")
    seq("qreveal", range(2312, 2316), 40, nxt="qtruth", effects={"truth": True}, code=fobj(9011, 9012))
    seq("qtruth", [2316, 2317], 40, nxt="docs")
    seq("docs", [2320, 2321, 2322, 2323], 42, nxt="qchoice", effects={"documents": True}, req={"letter": True},
        code=fobj(9012, 9013))
    node("qchoice", 45, choices=[dict(line=L(2330), to="qstays"), dict(line=L(2332), to="qlie")])
    node("qstays", 45, [2331], nxt="campret", effects={"qloc": "inn"})
    node("qlie", 45, [2333], nxt="campret", effects={"qloc": "farm"}, code=q01("QuintusToFarm()"))
    seq("campret", [2340, 2341, 2342], 48, nxt="inn")
    # 7 the inn: Hrefna reads, then the three ways
    inn_tail = [dict(line=L(2370), to="k_inn", requires={"qloc": "inn"}),
                dict(line=L(2372), to="k_farm", requires={"qloc": "farm"}),
                dict(line=L(2380), to="c_inn", requires={"qloc": "inn"}),
                dict(line=L(2382), to="c_farm", requires={"qloc": "farm"}),
                dict(line=L(2390), to="p_inn", requires={"qloc": "inn"}),
                dict(line=L(2392), to="p_farm", requires={"qloc": "farm"})]
    # the player hands Hrefna the letter (2359, only with the letter in the inventory); 2360/2361 are her reaction after reading it
    seq("inn", [2359, 2360, 2361, 2362], 50, tail=inn_tail, req={"letter": True})
    CODE["inn_1"] = q01("TakeLetter()")  # runs with her reaction: the letter leaves the inventory
    node("k_inn", 55, [2371], nxt="k_common")
    node("k_farm", 55, [2373], nxt="k_common")
    node("k_common", 55, [2560, 2561, 2562, 2563], effects={"result": "proven", "qloc": "inn"},
         code=q01("HrefnaKillsQuintus()"))
    node("c_inn", 55, [2381], nxt="c_common", code=q01("QuintusToInn()"))
    node("c_farm", 55, [2381], nxt="c_common", code=q01("QuintusToInn()"))
    seq("c_common", [2570, 2571, 2572, 2573], 55, effects={"result": "unproven"}, code=q01("CaptureOutcome()"))
    node("p_inn", 55, [2391], nxt="pfinal", code=q01("QuintusToFarm()"))
    node("p_farm", 55, [2393], nxt="pfinal", code=q01("QuintusToFarm()"))
    seq("pfinal", [2580, 2581, 2582], 55, effects={"result": "unproven"}, code=q01("QuintusHostile()"))
    # 8 papers, fragment, judgment (Hrefna), debrief (Veyra)
    seq("papers", range(2600, 2607), 60, nxt="fchoice")
    node("fchoice", 60, choices=[dict(line=L(2620), to="fmiss"), dict(line=L(2622), to="ffound")])
    node("fmiss", 60, [2621], nxt="judgment", effects={"fragment": False})
    node("ffound", 60, [], nxt="judgment", effects={"fragment": True}, code=q01("GiveOculatusFragment()"))
    node("judgment", 70, [2700], choices=[dict(line=L(2701), to="j1", requires={"result": "proven"}),
                                          dict(line=L(2703), to="j2", requires={"result": "unproven"}),
                                          dict(line=L(2705), to="j3"), dict(line=L(2707), to="j4")])
    node("j1", 70, [2702], nxt="debrief", code=q01("JudgeRecruit()"))
    node("j2", 70, [2704], nxt="debrief", code=q01("JudgeRecruit()"))
    node("j3", 70, [2706], nxt="debrief", code=q01("JudgeRelease()"))
    node("j4", 70, [2708], nxt="debrief", code=q01("JudgeSilence()"))
    node("debrief", 100, [2800], choices=[dict(line=L(2801), to="d1")])
    node("d1", 100, [2802], nxt="dsw")
    node("dsw", 100, [], nxt="d2", **{"when": {"fragment": True}, "otherwise": "d3"})
    seq("d2", [2803, 2804, 2805], 100, code=q01("OpenMapTable()"))
    node("d3", 100, [2806], code=q01("OpenMapTable()"))
    # Q01 -> Q02: Veyra waits at the map table and greets once (Hello) when the player comes close; armed by OpenMapTable()
    node("table", 100, [2810], nxt="tablehub")
    # fallback to the map table (the table may be out of reach): the player asks Veyra, the script starts Q02 like the table menu does
    node("tablehub", 100, [], choices=[dict(line=L(2811), to="tablego")])
    node("tablego", 100, [], code=q01("StartQ02FromTable()"))
    # 9 V2 kitchen scene (Nazir, Hrefna) after "Recruit"
    v2f = json.load(open(V2DIR / "flow.json", encoding="utf-8"))
    for n in v2f["nodes"]:
        if n["id"] in ("home", "home_hrefna", "home_nazir", "finished"):
            n = dict(n)
            n.pop("requires", None)
            NODES.append(n)
            LANE[n["id"]] = "Main"
    return NODES


INITIAL = {"markerReturned": False, "farmInspected": False, "scoutYield": False, "scoutTold": False, "truth": False,
           "documents": False, "qloc": "none", "result": "none", "fragment": False, "letter": False, "clue": False}


def letter_world(val, flow):
    return fc.cond("GetItemCount", [f"ItemOrList: {ID_LETTER:06X}:{P}"], ">=" if val else "<", 1,
                   extra=["RunOnType: Reference", f"Reference: {v2.PLAYER}"])


def clue_world(val, flow):
    return fc.cond("GetItemCount", [f"ItemOrList: {ID_BOOKS['PatrolSlip']:06X}:{P}"], ">=" if val else "<", 1,
                   extra=["RunOnType: Reference", f"Reference: {v2.PLAYER}"])


def marker_world(val, flow):
    return fc.cond("GetItemCount", [f"ItemOrList: {ID_MARKER:06X}:{P}"], ">=" if val else "<", 1,
                   extra=["RunOnType: Reference", f"Reference: {v2.PLAYER}"])


SPEC_BASE = dict(
    quest="Q01", qform=Q01, qkey="004000:" + P, syskey="000809:" + P, prefix="NHV_Q01V2",
    csv="dialogue/Q01.csv", extra_csv=["dialogue/Journal.csv", "dialogue/Books.csv"],
    idmap="tools/flow_ids_Q01.json", id_range=(0x7000, 0x7FFF),
    hosts={"Veyra": dict(base="000817:" + P), "Nazir": dict(base="01C3AB:Skyrim.esm"),
           "Hakan": dict(base="004006:" + P), "Hrefna": dict(base="004007:" + P), "Quintus": dict(base="004008:" + P),
           "MarshScavenger": dict(base=f"{ID_SCAV:06X}:{P}"), "OculatusScout": dict(base=f"{ID_SCOUT:06X}:{P}")},
    aliases={"Q": {"Veyra": 1, "Hakan": 2, "Hrefna": 3, "Quintus": 4, "Nazir": 5, "OculatusScout": 6}, "Sys": {}},
    sys_speakers=(), fallback_host="Veyra",
    world={"letter": letter_world, "marker": marker_world, "clue": clue_world},
    inline_stage=("k_inn", "k_farm", "c_inn", "c_farm", "p_inn", "p_farm", "campret", "qchoice", "docs", "papers",
                  "fchoice"),
    hooks=dict(before={"NHV_Q01_055_2560": q01("QuintusToInn()")}),
)


def q01_spec():
    nodes = build_nodes()
    flow = dict(version=3, status="ENHANCED", start="briefing", initial=INITIAL, nodes=nodes)
    spec = dict(SPEC_BASE)
    spec.update(flow_data=flow, lanes={k: v for k, v in LANE.items() if v != "Main"}, node_code=dict(CODE))
    # who answers a silent choice (the player line without an NPC answer): the person the player is talking to, not the fallback Veyra
    # (ingame test 01.10.2026: "Then we go together" and "Now choose ..." were only offered by Veyra, Hrefna did not follow)
    spec["default_host"] = {"docs": "Quintus", "docs_2": "Quintus", "campret": "Hrefna", "campret_1": "Hrefna",
                            "inn": "Hrefna", "inn_1": "Hrefna"}
    spec["entries"] = {
        "reed": dict(kind="greeting", lane="Scav", also=[("Hakan", "hret")]),
        "hret": dict(kind="greeting", lane="Hakan", extra_conds=[("state", "marker", True)]),
        "camp": dict(kind="scene_ext", set_stage=False,
                     existing=dict(fid=0x402B, eid="NHV_Scn_Q01_01CampAmbush",
                                   sfname="SF_NHV_Scn_Q01_01CampAmbush_0200402B"),
                     sf_prefix=q01("EndCampAmbush()")),
        "qintro": dict(kind="greeting", lane="Main"),
        "pfinal": dict(kind="greeting", lane="Main"),
        "papers": dict(kind="greeting", lane="Main"),
        "judgment": dict(kind="greeting", lane="Main"),
        "debrief": dict(kind="greeting", lane="Main"),
        "table": dict(kind="greeting", lane="Main"),
        "home": dict(kind="scene_ext",
                     existing=dict(fid=0x7F01, eid="NHV_Scn_Q01_04Home", sfname="SF_NHV_Scn_Q01_04Home_02007F01")),
        "line:NHV_Q01_055_2560": dict(kind="auto", start_tpl=q01("DelayScene(0x{sid}, 3.0)")),
    }
    return spec


# stage -> objectives shown when the stage is set (journal rows); events show the others
STAGE_OBJ = {
    10: [9001, 9002], 12: [9003], 20: [9005], 25: [9007], 30: [9008, 9009], 40: [9010], 42: [], 45: [], 48: [],
    50: [9014], 55: [9015], 60: [9016, 9017], 70: [9018, 9019], 100: [9020, 9021],
}
EVENT_OBJ = [9004, 9006, 9011, 9012, 9013]
STAGE_LOG = {10: 9001, 12: 9003, 20: 9005, 25: 9007, 30: 9008, 40: 9010, 42: 9012, 45: 9013, 48: 9014, 50: 9014,
             55: 9015, 60: 9016, 70: 9018, 100: 9020}
STAGES = sorted(STAGE_LOG)
QUEST_FILE = fc.TEXT / "Quests" / "NHV_Q01_TheUnansweredSacrament - 004000_NightsHarvest.esp.yaml"
SCRIPT = fc.SCRIPTS / "NHV_Q01Script.psc"
QF = fc.SCRIPTS / "QF_NHV_Q01_TheUnansweredSacra_02004000.psc"


def rd(p):
    return p.read_text(encoding="utf-8")


def wr(p, t):
    p.write_text(t, encoding="utf-8", newline="\n")


def jtext(f, n):
    return f.rows[JBY[n]]["Text"].strip()


# ------------------------------------------------------------------------------------------------ activation
def activate():
    def load(p):
        raw = p.read_bytes()
        rows = list(csv.DictReader(open(p, encoding="utf-8-sig", newline="")))
        return rows, list(rows[0].keys()), b"\r\n" in raw

    def save(p, rows, fields, crlf):
        with open(p, "w", encoding="utf-8", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=fields, lineterminator="\r\n" if crlf else "\n")
            w.writeheader()
            w.writerows(rows)
    enh, ef, ec = load(ENH / "Q01.csv")
    act, af, ac = load(REPO / "dialogue" / "Q01.csv")
    if any(r["LineID"] == enh[0]["LineID"] for r in act):
        print("Q01.csv already contains the enhanced rows")
    else:
        keep = [r for r in act if re.search(r"_100_10(3[5-9]|4[0-6])$", r["LineID"])]   # the kitchen scene lines
        for r in enh:
            r["Notes"] = ("ENHANCED E45; " + r["Notes"]).strip("; ")
        save(REPO / "dialogue" / "Q01.csv", enh + keep, af, ac)
        print("Q01.csv:", len(enh), "enhanced rows +", len(keep), "kitchen rows")
    for name in ("Journal.csv", "Books.csv"):
        new, nf, _ = load(ENH / name)
        cur, cf, cc = load(REPO / "dialogue" / name)
        have = {r["LineID"] for r in cur}
        add = [r for r in new if r["LineID"] not in have]
        newids = {x["LineID"] for x in new}
        for r in cur:
            if name == "Journal.csv" and r["LineID"].startswith("NHV_Q01_") and "superseded" not in r["Notes"] \
                    and r["LineID"] not in newids:
                r["Notes"] = (r["Notes"] + "; " if r["Notes"] else "") + "superseded by Enhanced text"
        save(REPO / "dialogue" / name, cur + add, cf, cc)
        print(name, "added", len(add))


# ------------------------------------------------------------------------------------------------ records
def make_npcs(f):
    base = rd(TEXT / "Npcs" / "NHV_Hakan - 004006_NightsHarvest.esp.yaml")

    def clone(fid, eid, name, voice, unique, protected):
        t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(fid)}", base, count=1)
        t = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", t, count=1)
        t = re.sub(r"(?m)^Voice: .*$", f"Voice: {fc.fk(voice)}", t, count=1)
        t = t.replace("Value: Hakan", f"Value: {name}", 1)
        # Hakan carries his own dock packages (CK + NHV_Pkg_Q01_Hakan*): the clones must not inherit them,
        # they keep the vanilla sandbox (DefaultSandboxCurrentLocation256).
        t = re.sub(r"(?ms)^Packages:
(?:- [0-9A-F]{6}:[^
]+
)+", "Packages:
- 0956B8:Skyrim.esm
", t, count=1)
        if not unique:
            t = t.replace("  Flags:" + NL + "  - Unique" + NL, "  Flags: []" + NL, 1)
        if protected:
            t = t.replace("  - Unique" + NL, "  - Unique" + NL + "  - Protected" + NL, 1)
        return t
    f.files[TEXT / "Npcs" / f"NHV_Q01_MarshScavenger - {ID_SCAV:06X}_{P}.yaml"] = \
        clone(ID_SCAV, "NHV_Q01_MarshScavenger", "Marsh Scavenger", ID_VSCAV, False, False)
    f.files[TEXT / "Npcs" / f"NHV_Q01_OculatusScout - {ID_SCOUT:06X}_{P}.yaml"] = \
        clone(ID_SCOUT, "NHV_Q01_OculatusScout", "Oculatus Scout", ID_VSCOUT, True, True)
    for fid, eid in ((ID_VSCAV, "NHV_VoiceMarshScavenger"), (ID_VSCOUT, "NHV_VoiceOculatusScout")):
        f.put("VoiceTypes", eid, fid, [f"FormKey: {fc.fk(fid)}", f"EditorID: {eid}", "Flags:", "- AllowDefaultDialog"])
    f.put("MiscItems", "NHV_Item_Q01_RedFerryMarker", ID_MARKER,
          [f"FormKey: {fc.fk(ID_MARKER)}", "EditorID: NHV_Item_Q01_RedFerryMarker", "Name:", "  TargetLanguage: English",
           "  Value: Red Ferry Marker"])


def book_body(title, texts):
    paras = []
    for t in texts:
        paras += [p.strip() for p in t.replace("\\n", "\n").split("\n\n") if p.strip()]
    out = [f'    <p align="center"><font size="32">{title}</font></p>']
    for p in paras:
        out += ["", f'    <p align="left">{p}</p>']
    return NL.join(out)


def make_books(f):
    tpl = rd(TEXT / "Books" / "NHV_Book_HrefnaReleaseLetter - 004010_NightsHarvest.esp.yaml")

    def make(fid, eid, name, title, texts):
        t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(fid)}", tpl, count=1)
        t = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", t, count=1)
        t = re.sub(r"(?m)^(Name:\n  TargetLanguage: English\n  Value: ).*$", lambda m: m.group(1) + name, t, count=1)
        a = t.index("  Value: >-" + NL) + len("  Value: >-" + NL)
        b = t.index("Keywords:")
        return t[:a] + book_body(title, texts) + NL + t[b:]
    titles = {"EirikLedger": (9101, "Eirik's Account"), "BurnedNote": (9102, "Burned Sacrament Note"),
              "OculatusFieldNote": (9103, "Oculatus Field Note"), "MoorsideRegister": (9104, "Moorside Guest Register"),
              "PatrolSlip": (9107, "Imperial Patrol Slip")}
    for key, (num, name) in titles.items():
        f.files[TEXT / "Books" / f"NHV_Book_Q01_{key} - {ID_BOOKS[key]:06X}_{P}.yaml"] = \
            make(ID_BOOKS[key], f"NHV_Book_Q01_{key}", name, name, [BROWS[BBY[num]]["Text"]])
    f.files[TEXT / "Books" / f"NHV_Book_QuintusPrivateLetter - {ID_LETTER:06X}_{P}.yaml"] = \
        make(ID_LETTER, "NHV_Book_QuintusPrivateLetter", "A Private Letter", "A Private Letter",
             [BROWS[BBY[9105]]["Text"]])
    fp = TEXT / "Books" / "NHV_Item_OculatusFragment1 - 00400F_NightsHarvest.esp.yaml"
    frag = rd(fp)
    a = frag.index("  Value: >-" + NL) + len("  Value: >-" + NL)
    b = frag.index("Flags:")
    f.files[fp] = frag[:a] + book_body("Oculatus Dispatch", [BROWS[BBY[9106]]["Text"]]) + NL + frag[b:]


def make_package(f):
    ep = TEXT / "Packages" / "NHV_Pkg_Hrefna_EscortPlayer - 00498E_NightsHarvest.esp.yaml"
    src = rd(ep)
    t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(ID_PKG_VEYRA)}", src, count=1)
    t = re.sub(r"(?m)^EditorID: .*$", "EditorID: NHV_Pkg_Q01_VeyraFollow", t, count=1)
    t = t.replace("  ComparisonValue: 40" + NL, "  ComparisonValue: 20" + NL, 1)
    t = t.replace("  ComparisonValue: 60" + NL, "  ComparisonValue: 70" + NL, 1)
    f.files[TEXT / "Packages" / f"NHV_Pkg_Q01_VeyraFollow - {ID_PKG_VEYRA:06X}_{P}.yaml"] = t
    # Hrefna follows the player from stage 48 (she waits in the camp until then)
    f.files[ep] = src.replace("  ComparisonValue: 40" + NL, "  ComparisonValue: 48" + NL, 1) if "ComparisonValue: 48" not in src else src


def patch_quest(f):
    s = rd(QUEST_FILE)
    frag = "  Fragments:" + NL
    for i, st in enumerate(STAGES):
        frag += (f"  - Stage: {st}{NL}    Unknown2: 1{NL}    ScriptName: QF_NHV_Q01_TheUnansweredSacra_02004000{NL}"
                 f"    FragmentName: Fragment_{i}{NL}")
    a = s.index("  Fragments:" + NL)
    b = s.index("  Aliases:" + NL, a)
    s = s[:a] + frag + s[b:]
    head, rest = s.split("Stages:" + NL, 1)
    tail = rest.split("NextAliasID:", 1)[1]
    out = ""
    for st in STAGES:
        out += (f"- Index: {st}{NL}  LogEntries:{NL}"
                + (f"  - Flags:{NL}    - CompleteQuest{NL}" if st == 100 else f"  - Flags: []{NL}")
                + f"    Entry:{NL}      TargetLanguage: English{NL}      Value: {fc.q(jtext(f, STAGE_LOG[st]))}{NL}")
    objs = "".join(v2.obj_block(n, jtext(f, n)) for n in sorted(JBY))
    s = head + "Stages:" + NL + out + "Objectives:" + NL + objs + "NextAliasID:" + tail
    if "Name: ScoutAlias" not in s:
        s = s.replace("NextAliasID: 6" + NL, "NextAliasID: 7" + NL, 1)
        s = s.rstrip(NL) + NL + (f"- ID: 6{NL}  Name: ScoutAlias{NL}  Flags:{NL}  - Optional{NL}"
                                  f"  UniqueActor: {fc.fk(ID_SCOUT)}{NL}  VoiceTypes: Null{NL}")
    line = f"  - {fc.fk(ID_PKG_VEYRA)}{NL}"
    i = s.index("- ID: 1" + NL + "  Name: VeyraAlias" + NL)
    j = s.index("  PackageData:" + NL, i) + len("  PackageData:" + NL)
    if line not in s[i:j + 80]:
        s = s[:j] + line + s[j:]
    wr(QUEST_FILE, s)


def write_constants(f):
    lines = [
        "; BEGIN FLOW CONSTANTS (generated by tools/build_q01_enhanced.py - do not edit)",
        f"Int Property FLOW_CURSOR_MAIN = {f.gid('CursorMain')} AutoReadOnly",
        f"Int Property FLOW_ENTRY_PAPERS = {f.ordinal('entry', 'papers')} AutoReadOnly",
        f"Int Property FLOW_ENTRY_TABLE = {f.ordinal('entry', 'table')} AutoReadOnly",
        f"Int Property FLOW_SCOUT_YIELD = {f.gid('scoutYield')} AutoReadOnly",
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
    kq = ["NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script", "If kQ01 != None"]
    o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment",
         f";NEXT FRAGMENT INDEX {len(STAGES)}", "Scriptname QF_NHV_Q01_TheUnansweredSacra_02004000 Extends Quest Hidden", ""]
    shown = []
    for i, st in enumerate(STAGES):
        code = []
        for n in shown + EVENT_OBJ:
            code += [f"If IsObjectiveDisplayed({n})", f"    SetObjectiveCompleted({n})", "EndIf"]
        for n in STAGE_OBJ.get(st, []):
            code.append(f"SetObjectiveDisplayed({n})")
        shown = sorted(set(shown + STAGE_OBJ.get(st, [])))
        if st == 10:
            code += [f"NHV_Util.FlowSet(0x{f.gid('CursorMain'):06X}, {f.ordinal('hub', 'briefing')})",
                     f"NHV_Util.FlowSet(0x{f.gid('CursorHakan'):06X}, {f.ordinal('hub', 'hakan')})"] + kq + \
                ["    kQ01.FillVeyraAlias()", "EndIf"]
        if st == 20:
            code += kq + ["    kQ01.FillVeyraAlias()", "    kQ01.BeginVeyraWatch()", "EndIf"]
        if st == 25:
            code += kq + ["    kQ01.EnableMarker(2)", "    kQ01.BeginWatchpostWatch()", "EndIf"]
        if st == 30:
            code += kq + ["    kQ01.EnableMarker(3)", "    kQ01.BeginCampWatch()", "EndIf"]
        if st == 100:
            code += kq + ["    kQ01.BeginDebriefWatch()", "EndIf"]
        if st == 55:
            code += kq + ["    kQ01.MakeQuintusMortal()", "EndIf"]
        if st == 70:
            code += ['NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript',
                     "If kCore != None", "    kCore.CompleteVeyraReturnToSanctuary()", "EndIf"]
        o += frag(i, code)
    o += [";END FRAGMENT CODE - Do not edit anything between this and the begin comment", ""]
    QF.write_text("\r\n".join(o), encoding="utf-8", newline="")


def main():
    if "--activate" in sys.argv:
        activate()
        return
    write = "--write" in sys.argv
    f = fc.Flow(q01_spec())
    f.emit_globals()
    f.emit_hubs()
    f.emit_roots()
    print(f"topics {f.topics_made}, scenes {len(f.scenes_made)}, scripts {len(f.scripts)}, files {len(f.files)}")
    live = {n["id"] for n in f.flow["nodes"] if not n.get("obsolete")}
    print("unvisited:", sorted(live - f.visited))
    print("enums:", {k: f.enum_values(k) for k in ("qloc", "result")})
    for n in f.notes:
        print("note:", n)
    if write:
        make_npcs(f)
        make_books(f)
        make_package(f)
        f.write_all()
        patch_quest(f)
        write_constants(f)
        write_qf(f)
        print("written")


if __name__ == "__main__":
    main()
