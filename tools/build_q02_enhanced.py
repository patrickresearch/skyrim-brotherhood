#!/usr/bin/env python3
"""Build the Q02 "Cold Waters" Enhanced arc (dialogue/drafts/enhanced/Q02/, E46/E48-E56) into plugin-text/ with
tools/flow_compiler.py. Pattern: tools/build_q01_enhanced.py.

What this generator owns
  * FormID range 0xA000-0xAEFF (flow topics, branches, scenes, flow globals, INFOs; keys in tools/flow_ids_Q02.json).
    clean_range() deletes ONLY files whose FormID is listed in that idmap (lesson 1 of docs/plan/Q02-Q03-Enhanced-Plan.md);
    nothing else in plugin-text/ is removed by the compile step.
  * Fixed records 0xAF10-0xAF40 (NPCs, voice types, faction, books, misc items, follow package) written by make_records().
  * Patches of the existing quest 004100 (stages, objectives, aliases, properties, fragments), the scene topics of
    scene 004125 (night scene) and the regenerated kill scene 004127.
  * The legacy Q02 topics 0x4130-0x41B0 (E50) are removed once by remove_legacy() (--write); build_q02_records.py is retired.
It never touches CK-owned records (Packages 00595E-005960, Cells, Doors, Activator refs ...).

Usage:
  python tools/build_q02_enhanced.py --activate   # merge the Enhanced rows into dialogue/Q02.csv, Journal.csv, Books.csv (once, idempotent)
  python tools/build_q02_enhanced.py              # compile and print the report (writes nothing)
  python tools/build_q02_enhanced.py --write      # write records, fragments, quest patch, script constants

NEVER run tools/plugin_text.ps1 ToPlugin or tools/sync_dev.ps1 from here: the ESP has one writer at a time (E17).
"""
import csv
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import flow_compiler as fc  # noqa: E402

REPO = fc.REPO
TEXT = fc.TEXT
SCRIPTS = fc.SCRIPTS
P = "NightsHarvest.esp"
NL = "\n"
Q02 = 0x004100
PLAYER = "000014:Skyrim.esm"
GOLD = "00000F:Skyrim.esm"
ENH = REPO / "dialogue" / "drafts" / "enhanced" / "Q02"

# ------------------------------------------------------------------------------------------------ fixed records
ID_NPC_ENF, ID_NPC_COUR = 0xAF10, 0xAF11
ID_VT_ENF, ID_VT_COUR = 0xAF12, 0xAF13
ID_FAC_ENF = 0xAF14
ID_BOOK_LEDGER, ID_MISC_KNIFE, ID_MISC_TOKEN, ID_MISC_SEAL, ID_BOOK_CIPHER = 0xAF30, 0xAF31, 0xAF32, 0xAF33, 0xAF34
ID_PKG_SINGS_FOLLOW = 0xAF40
# existing Q02 globals (dialogue state derived from the game, not from flow globals)
G_RESULT, G_HALDOR_SAVED, G_UNPROVEN, G_FALLBACK, G_FRAGMENT = 0x410D, 0x410E, 0x410F, 0x4113, 0x4115
# placed refs of the existing NPCs (plugin-text, checked 01.10.2026) - fallbacks for the getters in NHV_Q02Script
REF_SINGS, REF_TORBJORN, REF_DRINKS, REF_HJORALD, REF_HALDOR, REF_AELIUS = 0x5190, 0x5191, 0x5192, 0x5194, 0x5195, 0x5953

QUEST_FILE = TEXT / "Quests" / "NHV_Q02_ColdWaters - 004100_NightsHarvest.esp.yaml"
SCRIPT = SCRIPTS / "NHV_Q02Script.psc"
QF = SCRIPTS / "QF_NHV_Q02_ColdWaters_02004100.psc"


def rd(p):
    return p.read_text(encoding="utf-8")


def wr(p, t):
    p.write_text(t, encoding="utf-8", newline="\n")


# ------------------------------------------------------------------------------------------------ CSV rows
def load_csv(p):
    raw = p.read_bytes()
    rows = list(csv.DictReader(open(p, encoding="utf-8-sig", newline="")))
    return rows, list(rows[0].keys()), b"\r\n" in raw


def save_csv(p, rows, fields, crlf):
    with open(p, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=fields, lineterminator="\r\n" if crlf else "\n")
        w.writeheader()
        w.writerows(rows)


def master_rows():
    rows = {}
    for name in ("Q02.csv", "Journal.csv", "Books.csv"):
        for r in csv.DictReader(open(REPO / "dialogue" / name, encoding="utf-8-sig", newline="")):
            rows.setdefault(r["LineID"], r)
    return rows


ROWS = master_rows()


def L(tok):
    """'010_4000' -> 'NHV_Q02_010_4000'"""
    return "NHV_Q02_" + tok


def spk(tok):
    return ROWS[L(tok)]["Speaker"]


def jnum(line):
    return int(line.rsplit("_", 1)[1])


# ------------------------------------------------------------------------------------------------ node helpers
NODES, CODE, LANE = [], {}, {}


def node(nid, stage, lines=(), choices=None, nxt=None, effects=None, code=None, req=None, lane="Main", **kw):
    d = dict(id=nid, stage=stage, title=nid, lines=[L(n) for n in lines])
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


def C(tok, to, **requires):
    d = dict(line=L(tok), to=to)
    if requires:
        d["requires"] = requires
    return d


def seq(base, toks, stage, nxt=None, effects=None, code=None, req=None, lane="Main", tail=None):
    """Exchange (player and NPC lines) -> chain of one-choice hubs; NPC lines before the first player line belong to `base`."""
    segs, cur = [], (None, [])
    for t in toks:
        if spk(t) == "Player":
            segs.append(cur)
            cur = (t, [])
        else:
            cur[1].append(t)
    segs.append(cur)
    for k, (pt, npc) in enumerate(segs):
        nid = base if k == 0 else f"{base}_{k}"
        last = k + 1 == len(segs)
        ch = None
        if not last:
            ch = [C(segs[k + 1][0], f"{base}_{k + 1}")]
        elif tail:
            ch = tail
        node(nid, stage, npc, choices=ch, nxt=(nxt if last and not tail else None),
             effects=(effects if last else None), code=(code if last else None), req=(req if k == 0 else None), lane=lane)


_Q = [0]


def q02(call):
    """Fragment snippet calling NHV_Q02Script; the variable name is unique per snippet (one fragment may hold several)."""
    _Q[0] += 1
    v = f"kQ02_{_Q[0]}"
    return [f'NHV_Q02Script {v} = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script',
            f"If {v} != None", f"    {v}.{call}", "EndIf"]


def fobj(done, show):
    return [f"NHV_Util.FlowObjective(0x004100, {done}, {show})"]


def GO(*parts):
    out = []
    for p in parts:
        out += p
    return out


# ------------------------------------------------------------------------------------------------ the arc (E49 stage order)
def build_nodes():
    NODES.clear(), CODE.clear(), LANE.clear()
    # ---- stage 10 ---------------------------------------------------------------------------------------------------
    # Veyra's briefing is a hub with the player's opener (lesson 3: no Hello, no ForceGreet); it is not gating.
    seq("start", ["010_4090", "010_4000", "010_4001", "010_4002", "010_4004", "010_4005"], 10)
    # Torbjorn (records). 4010 is the way on: he sends the player to the sealed tidehouse first (E49: 15 before 20).
    node("torb", 10, [], choices=[C("010_4003", "torb_1")], lane="Torb")
    node("torb_1", 10, ["010_4006", "010_4007"], nxt="torb_hub", lane="Torb")
    node("torb_hub", 10, [], choices=[C("010_4008", "complaints"), C("010_4010", "to_tide")], lane="Torb")
    node("complaints", 10, ["010_4011", "010_4012"], nxt="torb_hub", lane="Torb")
    node("to_tide", 15, ["010_4091"], lane="Torb")
    # Drinks-the-Brine (Q2-05: the question "Who else knows the night shifts?" is asked of Drinks, not of Torbjorn)
    seq("drinks", ["010_4009", "010_4013"], 10, lane="Drinks",
        tail=[C("010_4014", "brine_check"), C("010_4015", "brine_bribe", bribe=True), C("010_4016", "brine_leave")])
    node("brine_check", 10, [], when={"persuade": True}, otherwise="brine_no", nxt="brine_yes", lane="Drinks")
    node("brine_no", 10, ["010_4017"], lane="Drinks")
    node("brine_bribe", 10, ["010_4018"], nxt="brine_yes", code=q02("PayBribe()"), lane="Drinks")
    node("brine_yes", 10, ["010_4019", "010_4020"], lane="Drinks")
    node("brine_leave", 10, [], lane="Drinks")
    # ---- stage 15: the sealed tidehouse -----------------------------------------------------------------------------
    seq("hj", ["015_4093", "015_4200", "015_4201", "015_4202", "015_4203", "015_4204"], 15, lane="Hj", nxt="hj_wait",
        code=q02("OnTidehouseBriefed()"))
    node("hj_wait", 15, [], choices=[C("015_4094", "hj_ledger", ledger=True)], lane="Hj")
    node("hj_ledger", 20, ["015_4214", "015_4215"], lane="Hj")
    # the enforcers guard the room: they talk first, then every enforcer of the room turns hostile (E54)
    seq("tide_enf", ["015_4210", "015_4211", "015_4212", "015_4213"], 15, lane="Enf", code=q02("TidehouseHostile()"))
    # ---- stage 20: the body (Torbjorn) ------------------------------------------------------------------------------
    # no flag check: stage 20 is only reached through the ledger talk (or a CK activator, patched at runtime), and a stage that is
    # reached any other way must never leave the body talk unavailable (Opus review 01.10.2026)
    node("body_open", 20, [], choices=[C("020_4095", "body")], lane="Torb")
    node("body", 20, ["020_4000", "020_4001"], choices=[C("020_4002", "body_a"), C("020_4003", "body_w")], lane="Torb")
    node("body_a", 30, ["020_4005"], lane="Torb")
    node("body_w", 30, ["020_4004", "020_4005"], lane="Torb")
    # ---- stage 45: salt yard and sluice (only the "Haldor was saved" path, E49) -------------------------------------
    node("salt", 45, [], choices=[C("035_4300", "salt_a")], lane="Salt")
    node("salt_a", 45, ["035_4301", "035_4302"], nxt="salt_b", lane="Salt")
    node("salt_b", 45, [], choices=[C("035_4303", "salt_c")], lane="Enf")
    node("salt_c", 45, ["035_4304", "035_4305"], nxt="salt_d", lane="Enf")
    node("salt_d", 45, [], choices=[C("035_4306", "salt_force"), C("035_4311", "salt_slip")], lane="Enf")
    node("salt_force", 45, ["035_4307"], nxt="salt_e", lane="Enf")
    node("salt_e", 45, [], choices=[C("035_4308", "salt_fight")], lane="Enf")
    node("salt_fight", 45, [], code=q02("SaltYardHostile()"), lane="Enf")
    node("salt_slip", 45, ["035_4310"], code=q02("SaltYardSlip()"), lane="Enf")
    # ---- stage 50: Sings in the Drowned Hollow (alone with the player: E51) ------------------------------------------
    node("hollow", 50, [], choices=[C("050_4096", "hollow_a")], lane="Sings")
    node("hollow_a", 50, ["050_4000"], choices=[C("050_4001", "identity")], lane="Sings")
    node("identity", 50, ["050_4099", "050_4002", "050_4003"], nxt="rescue_gate")
    node("rescue_gate", 50, [], when={"rescued": True}, otherwise="confess", nxt="rescue_question")
    node("rescue_question", 50, ["050_4004"], choices=[C("050_4005", "rescue_reply"), C("050_4006", "rescue_reply")],
         lane="Sings")
    node("rescue_reply", 50, ["050_4007"], nxt="confess")
    node("confess", 50, ["050_4008", "050_4009"], nxt="sings_hub")
    node("sings_hub", 50, [], choices=[C("050_4010", "reprisal"), C("050_4011", "veezara"), C("050_4012", "shadow"),
                                       C("050_4013", "purpose"), C("050_4014", "prop")], lane="Sings")
    node("reprisal", 50, ["050_4015", "050_4016"], nxt="sings_hub")
    node("veezara", 50, ["050_4017", "050_4018"], nxt="sings_hub")
    node("shadow", 50, ["050_4019", "050_4020"], nxt="sings_hub")
    node("purpose", 50, ["050_4021", "050_4022"], nxt="sings_hub")
    # the proposal (Veyra is not in the Hollow, E51): the player names the test, Sings answers
    node("prop", 50, ["050_4601"], choices=[C("050_4602", "prop_b")], lane="Sings")
    node("prop_b", 50, ["050_4603"], choices=[C("050_4604", "prop_c")], lane="Sings")
    node("prop_c", 50, ["050_4027", "050_4031"], nxt="trial_hub")
    node("trial_hub", 50, [], choices=[C("050_4033", "hate"), C("050_4034", "trial_why"), C("055_4400", "aelius_watch"),
                                       C("050_4035", "trial_wait")], lane="Sings")
    node("hate", 50, ["050_4036", "050_4037"], nxt="trial_hub")
    node("trial_why", 50, ["050_4039"], nxt="trial_hub")
    node("trial_wait", 50, ["050_4038"], nxt="trial_hub")
    # ---- stage 55: watch Aelius BEFORE the authorization (E52) ------------------------------------------------------
    node("aelius_watch", 55, ["055_4401"], nxt="aelius_obs")
    node("aelius_obs", 55, ["055_4402", "055_4403", "055_4404"], effects={"aeliusObserved": True}, nxt="obs_hub",
         lane="Sings")
    node("obs_hub", 55, [], choices=[C("055_4405", "obs_a")], lane="Sings")
    node("obs_a", 55, ["050_4040"], nxt="obs_choice")
    node("obs_choice", 55, [], choices=[C("050_4041", "authorize", aeliusObserved=True), C("050_4042", "obs_wait")],
         lane="Sings")
    node("obs_wait", 55, ["050_4038"], nxt="obs_choice")
    node("authorize", 60, ["050_4043"])
    # ---- stage 60: the trial (scene 004127, started by the kill watch) ----------------------------------------------
    node("kill", 60, ["060_4001", "060_4002", "060_4003", "060_4004", "060_4005"])
    # ---- stage 70: the desk, the courier, the list, the judgment ------------------------------------------------------
    node("desk_s", 70, ["070_4000", "070_4001"], nxt="desk_hub", lane="Sings")
    node("desk_p", 70, ["060_4006", "070_4000", "070_4001"], nxt="desk_hub", lane="Sings")
    node("desk_o", 70, ["060_4000", "070_4000", "070_4001"], nxt="desk_hub", lane="Sings")
    judge = [C("070_4006", "j_s", killer="sings"), C("070_4006", "j_p", killer="player"),
             C("070_4006", "j_o", killer="other")]
    node("desk_hub", 70, [], choices=list(judge), lane="Sings")
    node("courier", 70, ["070_4500", "070_4501"], nxt="cour_hub", lane="Cour")
    node("cour_hub", 70, [], choices=[C("070_4502", "cour_a")], lane="Cour")
    node("cour_a", 70, ["070_4503", "070_4504"], nxt="cour_hub2", lane="Cour")
    node("cour_hub2", 70, [], choices=[C("070_4505", "cour_end")], lane="Cour")
    node("cour_end", 70, [], effects={"courierInterrupted": True}, code=q02("CourierFlees()"), nxt="list_open", lane="Cour")
    node("list_open", 70, ["070_4002", "070_4003"], nxt="list", lane="Sings")
    node("list", 70, [], choices=[C("070_4004", "list_kind"), C("070_4005", "list_limits")] + list(judge), lane="Sings")
    node("list_kind", 70, ["070_4007", "070_4008"], nxt="list")
    node("list_limits", 70, ["070_4009"], nxt="list")
    node("j_s", 70, ["070_4010", "070_4011"], choices=[C("070_4012", "recruit"), C("070_4013", "release"),
                                                       C("070_4014", "silence"), C("070_4015", "surrender")], lane="Sings")
    node("j_p", 70, ["070_4016"], choices=[C("070_4017", "recruit_u"), C("070_4018", "release"),
                                           C("070_4019", "silence"), C("070_4020", "surrender")], lane="Sings")
    node("j_o", 70, ["070_4021"], choices=[C("070_4022", "recruit_u"), C("070_4023", "release"),
                                           C("070_4024", "silence"), C("070_4025", "surrender")], lane="Sings")
    node("recruit", 70, ["070_4026", "070_4027"], code=q02("JudgeRecruit()"))
    node("recruit_u", 70, ["070_4028", "070_4029"], code=q02("JudgeRecruit()"))
    node("release", 70, ["070_4030", "070_4031"], code=q02("JudgeRelease()"))
    node("silence", 70, ["070_4032"], code=q02("JudgeSilence()"))
    node("surrender", 70, ["070_4033", "070_4034"], code=q02("FinishSurrender()"))
    # ---- stage 100: the debrief (Veyra, in the Sanctuary: E51), the table (lesson 4), Sings at home ---------------------
    node("report", 100, [], choices=[C("100_4000", "rr", o_rec=True), C("100_4001", "ru", o_unp=True),
                                     C("100_4002", "rl", o_rel=True), C("100_4003", "rd", o_dead=True),
                                     C("100_4004", "rs", o_sur=True)])
    node("rr", 100, ["100_4005", "100_4006"], nxt="rf")
    node("ru", 100, ["100_4007", "100_4008"], nxt="rf")
    node("rl", 100, ["100_4009", "100_4010"], nxt="rf")
    node("rd", 100, ["100_4011", "100_4012"], nxt="rf")
    node("rs", 100, ["100_4013", "100_4014"], nxt="rf")
    node("rf", 100, [], when={"listRead": True}, otherwise="frag_rec", nxt="frag_hub")
    node("frag_hub", 100, [], choices=[C("100_4015", "frag_p")])
    node("frag_p", 100, ["100_4016"], nxt="fa")
    node("frag_rec", 100, ["100_4017", "100_4018"], nxt="fa")
    # E55: Fragment 2 is handed over once at the debrief for everybody who does not hold it yet (GiveFragmentIfMissing)
    node("fa", 100, ["100_4019", "100_4020"], code=GO(q02("GiveFragmentDebrief()"), fobj(100, 101)), nxt="fa_c")
    node("fa_c", 100, [], choices=[C("100_4021", "pattern"), C("100_4022", "connect"), C("100_4023", "fin")])
    node("pattern", 100, ["100_4024"], nxt="fa_c")
    node("connect", 100, ["100_4025"], nxt="fa_c")
    node("fin", 100, ["100_4098"], code=GO(fobj(101, 0), q02("OpenMapTable()")))
    node("tablehub", 100, [], choices=[C("100_4092", "tablego")])
    node("tablego", 100, [], code=q02("OpenTableMenu()"))
    node("home", 100, ["100_4026", "100_4027"], nxt="home_hub", lane="Home")
    node("home_hub", 100, [], choices=[C("100_4028", "home_more"), C("100_4029", "home_babette")], lane="Home")
    node("home_more", 100, ["100_4030", "100_4031"], nxt="home_hub", lane="Home")
    node("home_babette", 100, ["100_4032", "100_4033"], nxt="home_hub", lane="Home")
    return NODES


# the kill scene tail needs one variable shared by two calls; spelled out here instead of the q02() helper
KILL_CODE = ['NHV_Q02Script kQ02_K = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script',
             "If kQ02_K != None", "    kQ02_K.EndAeliusKillScene(kQ02_K.KillAelius())", "EndIf"]

INITIAL = {"aeliusObserved": False, "courierInterrupted": False,
           "persuade": True, "bribe": True, "ledger": False, "rescued": False, "listRead": False, "killer": "none",
           "o_rec": False, "o_unp": False, "o_rel": False, "o_dead": False, "o_sur": False, "recruited": False}


# ------------------------------------------------------------------------------------------------ world conditions
def _glob(gid, val):
    return fc.cond("GetGlobalValue", [f"Global: {fc.fk(gid)}"], "==", val)


def _item(form, op, n):
    return fc.cond("GetItemCount", [f"ItemOrList: {form}"], op, n, extra=["RunOnType: Reference", f"Reference: {PLAYER}"])


def w_ledger(val, flow):
    return _item(fc.fk(ID_BOOK_LEDGER), ">=" if val else "<", 1)


def w_bribe(val, flow):
    return _item(GOLD, ">=" if val else "<", 25)


def w_rescued(val, flow):
    return _glob(G_HALDOR_SAVED, 1 if val else 0)


def w_listread(val, flow):
    return _glob(G_FRAGMENT, 1 if val else 0)


def w_killer(val, flow):
    """killer: derived from the existing Q02 globals. sings = neither the player killed him (SingsUnproven) nor Aelius was
    already gone (AeliusFallback); player = SingsUnproven; other = AeliusFallback. Only the positive forms are used."""
    if val == "sings":
        return _glob(G_UNPROVEN, 0) + _glob(G_FALLBACK, 0)
    if val == "player":
        return _glob(G_UNPROVEN, 1)
    if val == "other":
        return _glob(G_FALLBACK, 1)
    raise fc.FlowError("killer value " + str(val))


def w_rec(val, flow):
    return _glob(G_RESULT, 1) + _glob(G_UNPROVEN, 0) + _glob(G_FALLBACK, 0)


def w_unp(val, flow):
    # Result == 1 AND (SingsUnproven == 1 OR AeliusFallback == 1)
    return _glob(G_RESULT, 1) + fc.cond("GetGlobalValue", [f"Global: {fc.fk(G_UNPROVEN)}"], "==", 1, flags=["OR"]) + \
        _glob(G_FALLBACK, 1)


def w_result(n):
    return lambda val, flow: _glob(G_RESULT, n)


WORLD = {"ledger": w_ledger, "bribe": w_bribe, "rescued": w_rescued, "listRead": w_listread, "killer": w_killer,
         "o_rec": w_rec, "o_unp": w_unp, "o_rel": w_result(3), "o_dead": w_result(2), "o_sur": w_result(4),
         "recruited": w_result(1)}

SPEC_BASE = dict(
    quest="Q02", qform=Q02, qkey="004100:" + P, syskey="004100:" + P, prefix="NHV_Q02E",
    csv="dialogue/Q02.csv", extra_csv=["dialogue/Journal.csv", "dialogue/Books.csv"],
    idmap="tools/flow_ids_Q02.json", id_range=(0xA000, 0xAEFF),
    hosts={"Veyra": dict(base="000817:" + P), "Sings": dict(base="004107:" + P), "Torbjorn": dict(base="004108:" + P),
           "DrinksTheBrine": dict(base="004109:" + P), "HaldorFrostKnuckle": dict(base="00410A:" + P),
           "Aelius": dict(base="00410B:" + P), "Hjorald": dict(base="00410C:" + P),
           "DockEnforcer": dict(base=f"{ID_NPC_ENF:06X}:{P}"), "ImperialCourier": dict(base=f"{ID_NPC_COUR:06X}:{P}"),
           "Babette": dict(base="01D4B7:Skyrim.esm")},
    aliases={"Q": {"Veyra": 1, "Sings": 2, "Torbjorn": 3, "DrinksTheBrine": 4, "HaldorFrostKnuckle": 5, "Aelius": 6,
                   "Hjorald": 7, "DockEnforcer": 8, "ImperialCourier": 9, "Babette": 10}, "Sys": {}},
    sys_speakers=(), fallback_host="Veyra", world=WORLD,
    speech={"persuade": 30},   # (Persuade) line: Speech >= 30; the bribe is real gold (>= 25), paid once by PayBribe()
    inline_stage=("to_tide", "hj_ledger", "body_a", "body_w", "aelius_watch", "authorize"),
    # surrender: the outcome is settled in the chain (JudgeSurrender moves Hjorald next to the player), Hjorald's line is a delayed scene
    hooks=dict(before={"NHV_Q02_070_4034": q02("JudgeSurrender()"), "NHV_Q02_100_4033": q02("MoveBabetteNear()")}),
)


def q02_spec():
    nodes = build_nodes()
    CODE["kill"] = KILL_CODE
    flow = dict(version=4, status="ENHANCED", start="start", initial=INITIAL, nodes=nodes)
    spec = dict(SPEC_BASE)
    spec.update(flow_data=flow, lanes={k: v for k, v in LANE.items() if v != "Main"}, node_code=dict(CODE))
    # who answers a silent choice (a player line without an NPC answer): the person the player is talking to (lesson 2)
    spec["default_host"] = {"drinks_1": "DrinksTheBrine", "tide_enf_1": "DockEnforcer", "tide_enf_2": "DockEnforcer",
                            "salt_e": "DockEnforcer", "cour_hub2": "ImperialCourier", "tablehub": "Veyra",
                            "hj_wait": "Hjorald"}
    spec["entries"] = {
        "tide_enf": dict(kind="greeting", lane="Enf"),
        "courier": dict(kind="scene_ext", set_stage=False),
        "list_open": dict(kind="scene_ext", set_stage=False, start_tpl=q02("DelayScene(0x{sid}, 3.0)")),
        "aelius_obs": dict(kind="scene_ext", set_stage=False, start=q02("BeginAeliusObservation()")),
        "kill": dict(kind="scene_ext", set_stage=False,
                     existing=dict(fid=0x4127, eid="NHV_Scn_Q02_03AeliusKill", sfname="SF_NHV_Scn_Q02_03Kill_02004127")),
        "desk_s": dict(kind="scene_ext", set_stage=False),
        "desk_p": dict(kind="scene_ext", set_stage=False),
        "desk_o": dict(kind="scene_ext", set_stage=False),
        "home": dict(kind="greeting", lane="Home", extra_conds=[("state", "recruited", True)]),
        "line:NHV_Q02_070_4034": dict(kind="auto", start_tpl=q02("DelayScene(0x{sid}, 3.0)")),
        "line:NHV_Q02_100_4033": dict(kind="auto", start_tpl=q02("DelayScene(0x{sid}, 3.0)")),
    }
    return spec


# stage -> objective index (= the stage number, so saves keep their objective states), log row, events
OBJ_ROW = {10: 5000, 15: 5200, 20: 5002, 30: 5004, 40: 5006, 45: 5300, 50: 5008, 55: 5500, 60: 5010, 70: 5012,
           71: 5700, 100: 5014, 101: 5016}
LOG_ROW = {10: 5001, 15: 5201, 20: 5003, 30: 5005, 40: 5007, 45: 5301, 50: 5009, 55: 5501, 60: 5011, 70: 5013, 100: 5015}
STAGES = [10, 15, 20, 30, 40, 45, 50, 55, 60, 70, 100]
EVENT_OBJ = [71, 101]


def jrow_text(f, num):
    for lid, r in f.rows.items():
        if lid.startswith("NHV_Q02_") and lid.endswith(f"_{num}") and r.get("Speaker") == "Journal":
            return r["Text"].strip()
    raise KeyError(num)


# ------------------------------------------------------------------------------------------------ activation (CSV master)
# rows of the draft that are replaced / not built (E51: Veyra is not in the Hollow). Not carried into the master.
DROP = {"050_4023", "050_4024", "050_4025", "050_4026", "050_4028", "050_4029", "050_4030", "050_4032", "050_4044"}
OVERRIDE = {   # token -> field overrides (small text work, E51 and lore-editor review 01.10.2026; Codex / lore-editor follow-up requested)
    "050_4027": dict(Text="He paid us fairly. Used our names."),
    "050_4031": dict(Text="Aelius is the one man I would have kept outside my anger. You chose well, or you chose cruelly."),
    "050_4033": dict(Text="Will killing Aelius free you of every hatred?"),
    "050_4034": dict(Text="Why would you agree to this?"),
    "050_4036": dict(Speaker="Sings", VoiceType="NHV_VoiceSings",
                     Text="No. One act cannot empty a lifetime. It can show whether anger is the only voice I obey."),
    "050_4037": dict(Speaker="Sings", VoiceType="NHV_VoiceSings",
                     Text="Afterward, there will still be a man for you to judge. Me."),
    "050_4038": dict(Speaker="Sings", VoiceType="NHV_VoiceSings", Text="Then take your time. The test will wait. So will I."),
}
NEW_ROWS = [  # (token, speaker, voicetype, emotion, value, text, note)
    ("010_4090", "Player", "-", "Neutral", "50", "Windhelm. What am I walking into?",
     "Phase B opener (lesson 3): Veyra's briefing is a hub, not a Hello."),
    ("010_4091", "Torbjorn", "NHV_VoiceTorbjorn", "Neutral", "30",
     "The east pier will keep. The old tidehouse will not. Sergeant Hjorald sealed it after the fourth body. Read the log first.",
     "Phase B bridge (E49: stage 15 before 20); answer to 010_4010."),
    ("015_4093", "Player", "-", "Neutral", "50", "Torbjorn sent me about the old tidehouse.",
     "Phase B opener for Hjorald (lesson 3)."),
    ("015_4094", "Player", "-", "Neutral", "50", "I have the log from the tidehouse.",
     "Phase B opener; visible only with the ledger in the inventory."),
    ("020_4095", "Player", "-", "Neutral", "50", "The log is read. Show me the body.",
     "Phase B opener for Torbjorn at the body (stage 20)."),
    ("050_4096", "Player", "-", "Neutral", "50", "You are the one the docks whisper about.",
     "Phase B opener for Sings in the Hollow (lesson 3)."),
    ("050_4601", "Sings", "NHV_VoiceSings", "Neutral", "30",
     "A place beyond the docks. Then name what it asks of a man like me.",
     "E51 rewrite: Veyra's proposal is not spoken in the Hollow; answer to 050_4014."),
    ("050_4602", "Player", "-", "Neutral", "50", "The family tests its own. One killing, with no hatred in it.",
     "E51 rewrite (replaces Veyra 050_4026/4028)."),
    ("050_4603", "Sings", "NHV_VoiceSings", "Puzzled", "35",
     "No hatred. Then you do not mean anyone I have drowned. Whom do you mean?", "E51 rewrite."),
    ("050_4604", "Player", "-", "Neutral", "50", "Aelius, the harbor clerk. He has wronged no one that I know. That is the test.",
     "E51 rewrite (replaces Veyra 050_4028/4030)."),
    ("100_4092", "Player", "-", "Neutral", "50", "Show me the table.",
     "Phase B table fallback (lesson 4); no pin order is assumed (E48)."),
    ("100_4098", "Veyra", "NHV_VoiceVeyra", "Neutral", "30",
     "The ledger will keep it. The table is open whenever you want the next pin.",
     "Phase B: closes the debrief, order-neutral (E48)."),
]
JOURNAL_OVERRIDE = {   # LineID suffix -> text (E51/E52 consequences, lore-editor review)
    "050_5009": "Sings-Beneath-Ice confessed the drownings. You named Aelius, the harbor clerk, as a test he would never have chosen himself.",
    "060_5010": "Witness Sings-Beneath-Ice's test: the killing of Aelius.",
    "060_5011": "You authorized the test against Aelius. His kindness to the Argonians of the harbor made the choice no easier.",
}
BOOK_NOTES = {"070_6000": "E55: text of NHV_Note_Dispatch02 (Fragment 2), part 1", "070_6001": "E55: text of NHV_Note_Dispatch02 (Fragment 2), part 2",
              "070_6200": "Tidehouse ledger recovered at stage 15 (item NHV_Book_Q02_TidehouseLedger, E49); partial link to Aelius"}
BOOK_TEXT = {"070_6200": None}   # heading dash unified with the dispatch (em dash), see activate()
CIPHER_ROW = ("070_6300", "Book", "-", "Neutral", "50",
              "PRIVATE RECKONING — A. VARRO\n\nThe eastern ledgers I write in the old shift. Count the piers between the tidehouse and the sluice, and move every letter forward by that count. Three. The northern copies need no other key.",
              "E56: optional cipher key in Aelius' desk; Phase B draft text (lore-editor review 01.10.2026), Codex / lore-editor follow-up requested.")


def legacy_line_ids():
    """LineIDs that the kept legacy scene topics (scene 004126, VeyraHollow, E51 dead content) still reference."""
    ids = set()
    for fid in KEEP_SCENE_TOPICS:
        for d in (TEXT / "DialogTopics").glob(f"* - {fid:06X}_{P}"):
            for r in (d / "Responses").glob("*.yaml"):
                for m in re.finditer(r"ScriptNotes: (NHV_[A-Za-z0-9_]+)", rd(r)):
                    ids.add(m.group(1))
    return ids


KEEP_SCENE_TOPICS = {0x4149, 0x414B, 0x416A, 0x416C, 0x416E, 0x4170, 0x4172, 0x4174, 0x4176}


def activate():
    enh, ef, ec = load_csv(ENH / "Q02.csv")
    act, af, ac = load_csv(REPO / "dialogue" / "Q02.csv")
    keep_legacy = legacy_line_ids()
    out = []
    for r in enh:
        tok = r["LineID"][len("NHV_Q02_"):]
        if tok in DROP:
            continue
        r = dict(r)
        r["Conditions"] = ""
        if tok in OVERRIDE:
            r.update(OVERRIDE[tok])
            r["Notes"] = "ENHANCED E46/E51; revised 01.10.2026 (Sings voice instead of Veyra / lore-editor review); follow-up review requested"
        else:
            r["Notes"] = ("ENHANCED E46; " + r["Notes"]).strip("; ")
        out.append(r)
    have = {r["LineID"] for r in out}
    for tok, sp, vt, em, val, text, note in NEW_ROWS:
        lid = L(tok)
        if lid in have:
            continue
        out.append({"LineID": lid, "Quest": "Q02", "Stage": str(int(tok[:3])), "Topic": "Enhanced_PhaseB", "Speaker": sp,
                    "VoiceType": vt, "Emotion": em, "Value": val, "Text": text, "Conditions": "",
                    "Notes": "ENHANCED E46; " + note})
    legacy = [dict(r, Notes=("LEGACY (scene 004126 stays as dead content, E51); " + r["Notes"]).strip("; "))
              for r in act if r["LineID"] in keep_legacy and r["LineID"] not in have]
    save_csv(REPO / "dialogue" / "Q02.csv", out + legacy, af, ac)
    print(f"Q02.csv: {len(out)} enhanced rows + {len(legacy)} legacy rows (scene 004126)")
    # journal: Enhanced rows are added or refreshed in place (our rows), the eight V1 rows (_90 / _98) are removed (E50)
    new, nf, _ = load_csv(ENH / "Journal.csv")
    cur, cf, cc = load_csv(REPO / "dialogue" / "Journal.csv")
    cur = [r for r in cur if not re.match(r"NHV_Q02_\d{3}_(90|98)$", r["LineID"])]
    pos = {r["LineID"]: i for i, r in enumerate(cur)}
    added = 0
    for r in new:
        r = dict(r)
        r["Conditions"] = ""
        suf = r["LineID"][len("NHV_Q02_"):]
        if suf in JOURNAL_OVERRIDE:
            r["Text"] = JOURNAL_OVERRIDE[suf]
        if suf.startswith("035_"):
            r["Stage"] = "45"   # draft stage 35 -> E49 stage 45
        r["Notes"] = f"ENHANCED E46/E49; stage {r['Stage']} (objective index = stage number; 71 and 101 are event objectives)"
        if r["LineID"] in pos:
            cur[pos[r["LineID"]]] = r
        else:
            cur.append(r)
            added += 1
    save_csv(REPO / "dialogue" / "Journal.csv", cur, cf, cc)
    print("Journal.csv: added", added)
    # books: refreshed in place as well
    nb, nbf, _ = load_csv(ENH / "Books.csv")
    cb, cbf, cbc = load_csv(REPO / "dialogue" / "Books.csv")
    pos = {r["LineID"]: i for i, r in enumerate(cb)}
    addb = 0
    rows_b = []
    for r in nb:
        r = dict(r)
        suf = r["LineID"][len("NHV_Q02_"):]
        r["Conditions"] = ""
        r["Notes"] = "ENHANCED E46/E55; " + BOOK_NOTES.get(suf, r["Notes"])
        if suf == "070_6200":
            r["Text"] = r["Text"].replace("TIDEHOUSE WATCH LEDGER - EASTERN PIER", "TIDEHOUSE WATCH LEDGER — EASTERN PIER")
        rows_b.append(r)
    tok, sp, vt, em, val, text, note = CIPHER_ROW
    rows_b.append({"LineID": L(tok), "Quest": "Q02", "Stage": "70", "Topic": "Enhanced_CipherKey", "Speaker": sp,
                   "VoiceType": vt, "Emotion": em, "Value": val, "Text": text.replace("\\n", "\n"), "Conditions": "",
                   "Notes": note})
    for r in rows_b:
        if r["LineID"] in pos:
            cb[pos[r["LineID"]]] = r
        else:
            cb.append(r)
            addb += 1
    for r in cb:
        if r["LineID"] == "NHV_SYS_BOOK_82" and "superseded" not in r["Notes"]:
            r["Notes"] = (r["Notes"] + "; " if r["Notes"] else "") + "superseded by NHV_Q02_070_6000/6001 (E55)"
    save_csv(REPO / "dialogue" / "Books.csv", cb, cbf, cbc)
    print("Books.csv: added", addb)


# ------------------------------------------------------------------------------------------------ legacy removal (E50)
def remove_legacy():
    """Delete the 0x412D-0x41B0 player topics, their branches, the five ForceGreet packages and the TIF scripts (E50, lesson 3).
    Kept: the scene topics of scenes 004125 (patched) and 004126 (dead content, E51). Scene 004127 is regenerated."""
    gone = []
    dt = TEXT / "DialogTopics"
    for d in sorted(dt.iterdir()):
        m = re.search(r" - ([0-9A-F]{6})_NightsHarvest\.esp$", d.name)
        if not m or not (0x412D <= int(m.group(1), 16) < 0x41B0) or int(m.group(1), 16) in KEEP_SCENE_TOPICS:
            continue
        for r in (d / "Responses").glob("*.yaml"):
            mi = re.search(r" - ([0-9A-F]{6})_NightsHarvest", r.name)
            if mi:
                gone.append(f"TIF__02{mi.group(1)}.psc")
        for p in sorted(d.rglob("*"), reverse=True):
            p.unlink() if p.is_file() else p.rmdir()
        d.rmdir()
    for p in (TEXT / "DialogBranches").glob("NHV_Q02_*_Branch - 0041*"):
        p.unlink()
    for n in ("004128", "004129", "00412A", "00412B", "00412C"):
        for p in (TEXT / "Packages").glob(f"NHV_Pkg_Q02_* - {n}_NightsHarvest.esp.yaml"):
            p.unlink()
    for name in gone:
        p = SCRIPTS / name
        if p.exists():
            p.unlink()
    print(f"legacy removed: {len(gone)} INFO scripts, topics/branches/packages of 0x4130-0x41B0")


# ------------------------------------------------------------------------------------------------ the Flow with a safe clean
class Flow(fc.Flow):
    def __init__(self, spec):
        super().__init__(spec)
        self.hubs_seen = []

    def clean_range(self):
        """Lesson 1: only files whose FormID is in OUR idmap are removed (no range sweep)."""
        owned = set(self.ids.values())
        pat = re.compile(r" - ([0-9A-F]{6})_NightsHarvest\.esp")
        for p in list(TEXT.rglob("*")):
            m = pat.search(str(p))
            if p.is_file() and m and int(m.group(1), 16) in owned:
                p.unlink()
        for d in sorted((x for x in TEXT.rglob("*") if x.is_dir()), key=lambda x: len(x.parts), reverse=True):
            if not any(d.iterdir()):
                d.rmdir()
        for p in SCRIPTS.glob("*.psc"):
            m = re.match(r"(?:TIF_|SF_).*_?02([0-9A-F]{6})\.psc$", p.name)
            if m and int(m.group(1), 16) in owned:
                p.unlink()


# ------------------------------------------------------------------------------------------------ records
def make_npcs(f):
    base = rd(TEXT / "Npcs" / "NHV_Q01_MarshScavenger - 007F20_NightsHarvest.esp.yaml")

    def clone(fid, eid, name, voice, faction):
        t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(fid)}", base, count=1)
        t = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", t, count=1)
        t = re.sub(r"(?m)^Voice: .*$", f"Voice: {fc.fk(voice)}", t, count=1)
        t = t.replace("Value: Marsh Scavenger", f"Value: {name}", 1)
        if faction:
            t = t.replace(f"Voice: {fc.fk(voice)}",
                          f"Factions:{NL}- Faction: {fc.fk(faction)}{NL}  Fluff: 0x000000{NL}Voice: {fc.fk(voice)}", 1)
        return t
    f.files[TEXT / "Npcs" / f"NHV_Q02_DockEnforcer - {ID_NPC_ENF:06X}_{P}.yaml"] = \
        clone(ID_NPC_ENF, "NHV_Q02_DockEnforcer", "Dock Enforcer", ID_VT_ENF, ID_FAC_ENF)
    f.files[TEXT / "Npcs" / f"NHV_Q02_ImperialCourier - {ID_NPC_COUR:06X}_{P}.yaml"] = \
        clone(ID_NPC_COUR, "NHV_Q02_ImperialCourier", "Imperial Courier", ID_VT_COUR, None)
    for fid, eid in ((ID_VT_ENF, "NHV_VoiceDockEnforcer"), (ID_VT_COUR, "NHV_VoiceImperialCourier")):
        f.put("VoiceTypes", eid, fid, [f"FormKey: {fc.fk(fid)}", f"EditorID: {eid}", "Flags:", "- AllowDefaultDialog"])
    f.put("Factions", "NHV_Fac_DockEnforcer", ID_FAC_ENF,
          [f"FormKey: {fc.fk(ID_FAC_ENF)}", "EditorID: NHV_Fac_DockEnforcer", "Name:", "  TargetLanguage: English",
           "  Value: Dock Enforcers"])
    # no Relations on purpose: an Enemy relation to the PlayerFaction made the enforcers unapproachable (their talk comes first);
    # hostility is set by script (StartCombat), no crime group means no bounty (E54). Add the relation in the CK after the test if wanted.
    for fid, eid, name in ((ID_MISC_KNIFE, "NHV_MISC_Q02_HaldorKnife", "Haldor's Knife"),
                           (ID_MISC_TOKEN, "NHV_MISC_Q02_SluiceToken", "Sluice Token"),
                           (ID_MISC_SEAL, "NHV_MISC_Q02_ImperialSeal", "Imperial Seal")):
        f.put("MiscItems", eid, fid, [f"FormKey: {fc.fk(fid)}", f"EditorID: {eid}", "Name:", "  TargetLanguage: English",
                                      f"  Value: {fc.q(name)}"])


def book_paras(text):
    raw = text.replace("\\n", "\n")
    paras = [p.strip() for p in raw.split("\n\n") if p.strip()]
    title = paras[0] if paras and paras[0] == paras[0].upper() and len(paras[0]) < 60 else None
    body = paras[1:] if title else paras
    return title, [p.replace("\n", "<br>") for p in body]


def book_yaml(tpl_text, fid, eid, name, title, paras):
    t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(fid)}", tpl_text, count=1)
    t = re.sub(r"(?m)^EditorID: .*$", f"EditorID: {eid}", t, count=1)
    t = re.sub(r"(?m)^(Name:\n  TargetLanguage: English\n  Value: ).*$", lambda m: m.group(1) + fc.q(name), t, count=1)
    a = t.index("  Value: >-" + NL) + len("  Value: >-" + NL)
    b = min(i for i in (t.find("Flags:", a), t.find("Keywords:", a)) if i >= 0)
    out = [f'    <p align="center"><font size="32">{title}</font></p>']
    for p in paras:
        out += ["", f'    <p align="left">{p}</p>']
    return t[:a] + NL.join(out) + NL + t[b:]


def make_books(f):
    tpl = rd(TEXT / "Books" / "NHV_Book_Q01_BurnedNote - 007F12_NightsHarvest.esp.yaml")
    for fid, eid, name, row in ((ID_BOOK_LEDGER, "NHV_Book_Q02_TidehouseLedger", "Tidehouse Watch Ledger", "070_6200"),
                                (ID_BOOK_CIPHER, "NHV_Book_Q02_CipherKey", "Reckoning Sheet", "070_6300")):
        title, paras = book_paras(f.rows[L(row)]["Text"])
        f.files[TEXT / "Books" / f"{eid} - {fid:06X}_{P}.yaml"] = book_yaml(tpl, fid, eid, name, title or name, paras)
    # the dispatch (Fragment 2): ONE item, text = rows 6000 + 6001 (E55, Q2-17)
    fp = TEXT / "Books" / "NHV_Note_Dispatch02 - 00411D_NightsHarvest.esp.yaml"
    t6000, t6001 = f.rows[L("070_6000")]["Text"], f.rows[L("070_6001")]["Text"]
    title, paras = book_paras(t6000 + "\\n\\n" + t6001)
    cur = rd(fp)
    a = cur.index("  Value: >-" + NL) + len("  Value: >-" + NL)
    b = cur.index("Flags:", a)
    out = [f'    <p align="center"><font size="32">{title or "PENITUS OCULATUS"}</font></p>']
    for p in paras:
        out += ["", f'    <p align="left">{p}</p>']
    f.files[fp] = cur[:a] + NL.join(out) + NL + cur[b:]


def make_package(f):
    src = rd(TEXT / "Packages" / "NHV_Pkg_Q01_VeyraFollow - 007F30_NightsHarvest.esp.yaml")
    t = re.sub(r"(?m)^FormKey: .*$", f"FormKey: {fc.fk(ID_PKG_SINGS_FOLLOW)}", src, count=1)
    t = re.sub(r"(?m)^EditorID: .*$", "EditorID: NHV_Pkg_Q02_SingsFollow", t, count=1)
    t = t.replace("004000:NightsHarvest.esp", "004100:NightsHarvest.esp")
    t = t.replace("  ComparisonValue: 20" + NL, "  ComparisonValue: 55" + NL, 1)
    t = t.replace("  ComparisonValue: 70" + NL, "  ComparisonValue: 60" + NL, 1)   # follows from stage 55 up to (excluding) 60
    f.files[TEXT / "Packages" / f"NHV_Pkg_Q02_SingsFollow - {ID_PKG_SINGS_FOLLOW:06X}_{P}.yaml"] = t


def patch_docks_scene(f):
    """Scene 004125 (night scene) keeps its CK-added package action: only the response texts of its two topics change."""
    base = TEXT / "DialogTopics"
    targets = {
        "NHV_Q02_HaldorHarass - 004149": {"NHV_Q02_HaldorHarass_INFO01 - 00414A": ["030_4000"]},
        "NHV_Q02_HaldorPull - 00414B": {"NHV_Q02_HaldorPull_INFO01 - 00414C": ["030_4002"],   # Haldor was saved
                                        "NHV_Q02_HaldorPull_INFO02 - 00414D": ["030_4001"]},
    }
    for tdir, infos in targets.items():
        for iname, toks in infos.items():
            p = base / f"{tdir}_{P}" / "Responses" / f"{iname}_{P}.yaml"
            s = rd(p)
            a = s.index("Responses:" + NL)
            m = re.search(r"(?m)^(Conditions|Speaker|Prompt):", s[a:])
            b = a + (m.start() if m else len(s) - a)
            new = NL.join(f.resp_lines([L(t) for t in toks])) + NL
            f.files[p] = s[:a] + new + s[b:]


# ------------------------------------------------------------------------------------------------ quest patch / fragments / constants
def patch_quest(f):
    s = rd(QUEST_FILE)
    frag = "  Fragments:" + NL
    for i, st in enumerate(STAGES):
        frag += (f"  - Stage: {st}{NL}    Unknown2: 1{NL}    ScriptName: QF_NHV_Q02_ColdWaters_02004100{NL}"
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
                + f"    Entry:{NL}      TargetLanguage: English{NL}      Value: {fc.q(jrow_text(f, LOG_ROW[st]))}{NL}")
    objs = ""
    for idx in sorted(OBJ_ROW):
        objs += (f"- Index: {idx}{NL}  Flags: []{NL}  DisplayText:{NL}    TargetLanguage: English{NL}"
                 f"    Value: {fc.q(jrow_text(f, OBJ_ROW[idx]))}{NL}")
    s = head + "Stages:" + NL + out + "Objectives:" + NL + objs + "NextAliasID:" + tail
    # aliases 8 (enforcer), 9 (courier), 10 (Babette): Optional, script filled (Babette: unique actor)
    if "Name: EnforcerAlias" not in s:
        s = s.replace("NextAliasID: 8" + NL, "NextAliasID: 11" + NL, 1)
        s = s.rstrip(NL) + NL + (f"- ID: 8{NL}  Name: EnforcerAlias{NL}  Flags:{NL}  - Optional{NL}  VoiceTypes: Null{NL}"
                                  f"- ID: 9{NL}  Name: CourierAlias{NL}  Flags:{NL}  - Optional{NL}  VoiceTypes: Null{NL}"
                                  f"- ID: 10{NL}  Name: BabetteAlias{NL}  Flags:{NL}  - Optional{NL}"
                                  f"  UniqueActor: 01D4B7:Skyrim.esm{NL}  VoiceTypes: Null{NL}")
    # script properties for the new aliases and the ledger (the CK-placed refs are set in the CK)
    if "Name: EnforcerAlias" not in s.split("Aliases:" + NL)[0]:
        props = ""
        for name, alias in (("EnforcerAlias", 8), ("CourierAlias", 9), ("BabetteAlias", 10)):
            props += (f"    - MutagenObjectType: ScriptObjectProperty{NL}      Name: {name}{NL}"
                      f"      Object: 004100:NightsHarvest.esp{NL}      Alias: {alias}{NL}")
        props += (f"    - MutagenObjectType: ScriptObjectProperty{NL}      Name: TidehouseLedger{NL}"
                  f"      Object: {fc.fk(ID_BOOK_LEDGER)}{NL}")
        marker = "  - Name: QF_NHV_Q02_ColdWaters_02004100" + NL
        i = s.index(marker)
        s = s[:i] + props + s[i:]
    # Torbjorn and Hjorald carry the stage transitions 10/15/20/30: Protected while the quest holds them (Opus review 01.10.2026)
    for nm in ("TorbjornAlias", "HjoraldAlias"):
        old = f"  Name: {nm}{NL}  Flags:{NL}  - Optional{NL}"
        if old in s:
            s = s.replace(old, old + f"  - Protected{NL}", 1)
    # the five ForceGreet packages are retired (lesson 3); Sings follows the player while he watches Aelius (stage 55-59)
    for pk in ("004128", "00412C", "004129", "00412A", "00412B"):
        s = s.replace(f"  - {pk}:NightsHarvest.esp{NL}", "")
    s = s.replace("  PackageData:" + NL + "  VoiceTypes: Null" + NL, "  VoiceTypes: Null" + NL)
    follow = f"  - {fc.fk(ID_PKG_SINGS_FOLLOW)}{NL}"
    i = s.index("- ID: 2" + NL + "  Name: SingsAlias" + NL)
    j = s.index("  PackageData:" + NL, i) + len("  PackageData:" + NL)
    if follow not in s[i:j + 120]:
        s = s[:j] + follow + s[j:]
    wr(QUEST_FILE, s)


def write_constants(f):
    lines = [
        "; BEGIN FLOW CONSTANTS (generated by tools/build_q02_enhanced.py - do not edit)",
        f"Int Property FLOW_CURSOR_MAIN = {f.gid('CursorMain')} AutoReadOnly",
        f"Int Property FLOW_HUB_TABLE = {f.ordinal('hub', 'tablehub')} AutoReadOnly",
        f"Int Property FLOW_CURSOR_HOME = {f.gid('CursorHome')} AutoReadOnly",
        f"Int Property FLOW_ENTRY_HOME = {f.ordinal('entry', 'home')} AutoReadOnly",
        f"Int Property FLOW_CURSOR_SINGS = {f.gid('CursorSings')} AutoReadOnly",
        f"Int Property FLOW_HUB_OBS = {f.ordinal('hub', 'obs_hub')} AutoReadOnly",
        f"Int Property FLOW_HUB_DESK = {f.ordinal('hub', 'desk_hub')} AutoReadOnly",
        f"Int Property FLOW_AELIUS_OBSERVED = {f.gid('aeliusObserved')} AutoReadOnly",
        f"Int Property FLOW_SCENE_OBS = {f.fid('S:R_aelius_obs_p0')} AutoReadOnly",
        f"Int Property FLOW_SCENE_COURIER = {f.fid('S:R_courier_p0')} AutoReadOnly",
        f"Int Property FLOW_SCENE_LIST = {f.fid('S:R_list_open_p0')} AutoReadOnly",
        f"Int Property FLOW_SCENE_DESK_S = {f.fid('S:R_desk_s_p0')} AutoReadOnly",
        f"Int Property FLOW_SCENE_DESK_P = {f.fid('S:R_desk_p_p0')} AutoReadOnly",
        f"Int Property FLOW_SCENE_DESK_O = {f.fid('S:R_desk_o_p0')} AutoReadOnly",
        f"Int Property FLOW_COURIER_DONE = {f.gid('courierInterrupted')} AutoReadOnly",
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
    def fs(lane, kind, key):
        return f"NHV_Util.FlowSet(0x{f.gid('Cursor' + lane):06X}, {f.ordinal(kind, key)})"

    def frag(i, code):
        return ([f";BEGIN FRAGMENT Fragment_{i}", f"Function Fragment_{i}()", ";BEGIN CODE"] + code
                + [";END CODE", "EndFunction", ";END FRAGMENT", ""])
    kq = ["NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script", "If kQ02 != None"]
    o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment",
         f";NEXT FRAGMENT INDEX {len(STAGES)}", "Scriptname QF_NHV_Q02_ColdWaters_02004100 Extends Quest Hidden", ""]
    shown = []
    extra = {
        10: [fs("Main", "hub", "start"), fs("Torb", "hub", "torb"), fs("Drinks", "hub", "drinks")] + kq +
            ["    kQ02.FillVeyraAlias()", "    kQ02.PatchStageActivators()", "EndIf"],
        15: [fs("Hj", "hub", "hj"), fs("Enf", "entry", "tide_enf")] + kq +
            ["    kQ02.PatchStageActivators()", "    kQ02.BeginTidehouse()", "EndIf"],
        20: [fs("Torb", "hub", "body_open")] + kq + ["    kQ02.PatchStageActivators()", "EndIf"],
        30: kq + ["    kQ02.PatchStageActivators()", "    kQ02.SetHaldorSaved(False)", "    kQ02.BeginNightWatch()", "EndIf"],
        45: [fs("Salt", "hub", "salt")] + kq + ["    kQ02.PatchStageActivators()", "    kQ02.BeginSaltYard()", "EndIf"],
        50: [fs("Sings", "hub", "hollow")] + kq + ["    kQ02.MoveSingsToHollow()", "EndIf"],
        55: kq + ["    kQ02.BeginAeliusObservation()", "EndIf"],   # idempotent; also the entry point after a setstage
        60: kq + ["    kQ02.BeginKillWatch()", "EndIf"],
        70: kq + ["    kQ02.OnStage70()", "EndIf"],
        100: [fs("Main", "hub", "report")] + kq + ["    kQ02.FillVeyraAlias()", "    kQ02.BeginDebriefWatch()", "EndIf"],
    }
    for i, st in enumerate(STAGES):
        code = []
        for n in shown + EVENT_OBJ:
            code += [f"If IsObjectiveDisplayed({n})", f"    SetObjectiveCompleted({n})", "EndIf"]
        code.append(f"SetObjectiveDisplayed({st})")
        shown = sorted(set(shown + [st]))
        code += extra.get(st, [])
        o += frag(i, code)
    o += [";END FRAGMENT CODE - Do not edit anything between this and the begin comment", ""]
    QF.write_text("\r\n".join(o), encoding="utf-8", newline="")


# ------------------------------------------------------------------------------------------------ main
def main():
    if "--activate" in sys.argv:
        activate()
        return
    write = "--write" in sys.argv
    fc.Flow.SCENE_STARTS = fc.Flow.SCENE_STARTS + ("DelayScene(",)   # a delayed scene start closes the dialogue (Goodbye)
    f = Flow(q02_spec())
    f.emit_globals()
    f.emit_hubs()
    f.emit_roots()
    print(f"topics {f.topics_made}, scenes {len(f.scenes_made)}, scripts {len(f.scripts)}, files {len(f.files)}")
    live = {n["id"] for n in f.flow["nodes"] if not n.get("obsolete")}
    print("unvisited:", sorted(live - f.visited))
    for n in f.notes:
        print("note:", n)
    print("hub ordinals:", {k.split(":", 1)[1]: v for k, v in sorted(f.ords.items(), key=lambda kv: kv[1]) if k.startswith("hub:")})
    print("entry ordinals:", {k.split(":", 1)[1]: v for k, v in f.ords.items() if k.startswith("entry:")})
    print("ids used: 0x%04X - 0x%04X" % (min(f.ids.values()), max(f.ids.values())))
    if write:
        remove_legacy()
        make_npcs(f)
        make_books(f)
        make_package(f)
        patch_docks_scene(f)
        f.write_all()
        patch_quest(f)
        write_constants(f)
        write_qf(f)
        import build_q02_packages  # ambient NPC packages 0xAF50-0xAF61: make_npcs() just rewrote AF10/AF11, patch_quest() kept SingsAlias
        build_q02_packages.apply()
        print("written")


if __name__ == "__main__":
    main()
