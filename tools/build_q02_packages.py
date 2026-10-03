#!/usr/bin/env python3
"""Q02 NPC ambient packages (Cold Waters): writes plugin-text/Packages/NHV_Pkg_Q02_*.yaml for FormIDs 0xAF50-0xAF63,
registers them in the NPC records (base package lists) and in SingsAlias of quest 004100 (alias packages).

Plan and table: docs/plan/Q02-NPC-Packages.md. Idempotent: running it twice changes nothing.
It is outside the idmap range of build_q02_enhanced.py (0xA000-0xAEFF, flow_ids_Q02.json), so that generator's clean_range
never deletes these files; build_q02_enhanced.py --write calls apply() at the end because its make_npcs() rewrites the
Dock Enforcer / Imperial Courier records (and would drop their package entries).

Usage:  python tools/build_q02_packages.py          (write files, patch NPCs and quest)
        python tools/build_q02_packages.py --check  (report only, writes nothing)
Never writes the ESP (E17).
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEXT = ROOT / "plugin-text"
P = "NightsHarvest.esp"
QUEST = "004100:NightsHarvest.esp"

SANDBOX = "01C254:Skyrim.esm"   # template "Sandbox" (Data keys 0/1/3/4/5/6/7/14/25/27/29/31, DataInputVersion 10)
SLEEP = "019717:Skyrim.esm"     # template "Sleep" (Data keys 0/1/2/6/8/11/13/15/17-22/24/25/26, DataInputVersion 6)

# kind "sb" = Sandbox, "sl" = Sleep. For "sl" the fixed bed is looked up in BEDS (package EditorID -> FormKey of the bed ref).
# Without an entry the package searches a bed near its location (vanilla "DefaultSleepEditorLoc" pattern) until the CK bed
# refs exist (CK task N6: create the ref, enter its FormKey below, run this tool again).
VANILLA_ASSEMBLAGE_CELL = "016776:Skyrim.esm"        # WindhelmArgonianAssemblage (Vanilla, only referenced, never edited)
BEDS = {
    "DrinksNightSleep": "0C92F3:Skyrim.esm",          # Vanilla CommonBed01 ref in the Assemblage (reference only)
    # "TorbjornNightSleep":  "xxxxxx:NightsHarvest.esp",   # NHV_Bed_Q02_Torbjorn (CK N6)
    # "SingsHideoutNight":   "xxxxxx:NightsHarvest.esp",   # NHV_Bed_Q02_Sings (CK N6, in the Drowned Hollow)
    # "AeliusNightSleep":    "xxxxxx:NightsHarvest.esp",   # NHV_Bed_Q02_Aelius (CK N6, in the harbor office 0057DC)
}

# loc: ("editor", r) | ("self", r) | ("ref", "0057D8", r) | ("cell", "XXXXXX:Plugin.esm")
# conds: GetStage of quest 004100; (op, value[, "or"]) with the "or" entry joined to the NEXT one by OR, all others by AND
# time: None (all day) or (start hour, duration in minutes)
PKGS = [
    # id, eid, kind, loc, time, conds, flags
    (0xAF50, "SingsHideoutDay",    "sb", ("ref", "0057D8", 384), (6, 840), [("<", 40)],                dict(sleep=0, sit=1, wander=1)),
    (0xAF51, "SingsHideoutNight",  "sl", ("ref", "0057D8", 1024), (20, 600), [("<", 30)],              {}),
    (0xAF52, "SingsLurkWater",     "sb", ("ref", "00595D", 256), (20, 600), [("==", 30)],              dict(sleep=0, sit=0, wander=0)),
    (0xAF53, "SingsHollow",        "sb", ("ref", "0057D8", 256), None, [(">=", 45), ("<", 55)],        dict(sleep=0, sit=1, wander=1)),
    (0xAF54, "SingsHold",          "sb", ("self", 128), None, [(">=", 60), ("<", 100)],                dict(sleep=0, sit=0, wander=0)),
    (0xAF55, "TorbjornWork",       "sb", ("editor", 512), (6, 840), [],                                dict(sleep=0, sit=1, wander=1)),
    (0xAF56, "TorbjornNightSleep", "sl", ("editor", 2000), (20, 600), [("<", 10, "or"), (">=", 30)],   {}),
    (0xAF57, "TorbjornNightAwake", "sb", ("editor", 256), (20, 600), [(">=", 10), ("<", 30)],          dict(sleep=0, sit=1, wander=0)),
    (0xAF58, "DrinksWork",         "sb", ("editor", 768), (6, 840), [("<", 45, "or"), (">=", 50)],     dict(sleep=0, sit=0, wander=1)),
    (0xAF59, "DrinksNightSleep",   "sl", ("cell", VANILLA_ASSEMBLAGE_CELL), (20, 600), [("<", 10, "or"), (">=", 50)], {}),
    (0xAF5A, "DrinksNightAwake",   "sb", ("editor", 384), (20, 600), [(">=", 10), ("<", 45)],          dict(sleep=0, sit=1, wander=0)),
    (0xAF5B, "DrinksSaltYard",     "sb", ("self", 256), None, [(">=", 45), ("<", 50)],                 dict(sleep=0, sit=0, wander=1)),
    (0xAF5C, "HaldorDocks",        "sb", ("editor", 512), None, [("<", 45, "or"), (">=", 100)],                           dict(sleep=0, sit=1, wander=1)),
    (0xAF5D, "HjoraldPost",        "sb", ("editor", 512), (6, 840), [],                                dict(sleep=0, sit=0, wander=1)),
    (0xAF5E, "HjoraldNight",       "sb", ("editor", 192), (20, 600), [],                               dict(sleep=0, sit=0, wander=0)),
    (0xAF5F, "AeliusDay",          "sb", ("editor", 256), (6, 840), [],                                dict(sleep=0, sit=1, wander=0)),
    (0xAF60, "EnforcerPost",       "sb", ("editor", 384), None, [],                                    dict(sleep=0, sit=0, wander=1)),
    (0xAF61, "CourierWait",        "sb", ("editor", 128), None, [],                                    dict(sleep=0, sit=0, wander=0)),
    (0xAF62, "AeliusNightAwake",   "sb", ("editor", 256), (20, 600), [(">=", 55), ("<", 60)],          dict(sleep=0, sit=1, wander=0)),
    (0xAF63, "AeliusNightSleep",   "sl", ("editor", 2000), (20, 600), [("<", 55, "or"), (">=", 60)],   {}),
]
BY_EID = {p[1]: p[0] for p in PKGS}

# NPC file (FormID) -> package EditorIDs in priority order (first = highest). Conditions are disjoint inside each list.
NPC_PKGS = {
    "004107": ["SingsHideoutDay", "SingsHideoutNight", "SingsLurkWater"],
    "004108": ["TorbjornWork", "TorbjornNightSleep", "TorbjornNightAwake"],
    "004109": ["DrinksSaltYard", "DrinksWork", "DrinksNightSleep", "DrinksNightAwake"],
    "00410A": ["HaldorDocks"],
    "00410B": ["AeliusNightAwake", "AeliusNightSleep", "AeliusDay"],
    "00410C": ["HjoraldPost", "HjoraldNight"],
    "00AF10": ["EnforcerPost"],
    "00AF11": ["CourierWait"],
}
ALIAS_SINGS = ["SingsHollow", "SingsHold"]   # appended to SingsAlias (ID 2) of quest 004100 after the CK/generator entries


def fk(i):
    return f"{i:06X}:{P}"


def eol_of(t):
    return "\r\n" if "\r\n" in t else "\n"


def cond_block(conds):
    out = []
    for c in conds:
        op, val = c[0], c[1]
        out.append("- MutagenObjectType: ConditionFloat")
        if op == "<":
            out.append("  CompareOperator: LessThan")
        elif op == ">=":
            out.append("  CompareOperator: GreaterThanOrEqualTo")
        if len(c) > 2:
            out += ["  Flags:", "  - OR"]
        out += ["  Data:", "    MutagenObjectType: GetStageConditionData", f"    Quest: {QUEST}",
                f"  ComparisonValue: {val}"]
    return out


def head(pid, eid, tm, conds, sleeping):
    L = [f"FormKey: {fk(pid)}", f"EditorID: NHV_Pkg_Q02_{eid}"]
    if sleeping:
        L += ["Flags:", "- WeaponsUnequipped"]
    L += ["Type: Package", "PreferredSpeed: " + ("Run" if sleeping else "Walk"), "InterruptFlags:"]
    L += ["- " + x for x in ("HellosToPlayer", "RandomConversations", "ObserveCombatBehavior", "GreetCorpseBehavior",
                             "ReactionToPlayerActions", "FriendlyFireComments", "AggroRadiusBehavior", "AllowIdleChatter",
                             "WorldInteractions", "0x400", "0x800", "0x1000", "0x2000", "0x4000", "0x8000")]
    L += ["ScheduleMonth: -1", "ScheduleDayOfWeek: Any"]
    if tm:
        L += [f"ScheduleHour: {tm[0]}", "ScheduleMinute: 0"]
    else:
        L += ["ScheduleHour: -1", "ScheduleMinute: -1"]
    L += ["Unknown3: 0x000000"]
    if tm:
        L += [f"ScheduleDurationInMinutes: {tm[1]}"]
    if conds:
        L += ["Conditions:"] + cond_block(conds)
    return L


def loc_block(loc):
    L = ["    Location:", "      Target:"]
    if loc[0] == "editor":
        L += ["        MutagenObjectType: LocationFallback", "        Type: NearEditorLocation", f"      Radius: {loc[1]}"]
    elif loc[0] == "self":
        L += ["        MutagenObjectType: LocationFallback", "        Type: NearSelf", f"      Radius: {loc[1]}"]
    elif loc[0] == "cell":
        L += ["        MutagenObjectType: LocationCell", f"        Link: {loc[1]}"]
    else:
        L += ["        MutagenObjectType: LocationTarget", f"        Link: {loc[1]}:{P}", f"      Radius: {loc[2]}"]
    return L


def b(key, val):
    o = [f"- Key: {key}", "  Value:", "    MutagenObjectType: PackageDataBool"]
    if val:
        o.append("    Data: True")
    return o


EVENTS = ["OnBegin:", "  Topics:", "  - MutagenObjectType: TopicReference", "OnEnd:", "  Topics:",
          "  - MutagenObjectType: TopicReference", "OnChange:", "  Topics:", "  - MutagenObjectType: TopicReference"]


def build_package(pid, eid, kind, loc, tm, conds, fl):
    if kind == "sl":
        L = head(pid, eid, tm, conds, True)
        L += [f"PackageTemplate: {SLEEP}", "DataInputVersion: 6", "Data:", "- Key: 0", "  Value:",
              "    MutagenObjectType: PackageDataLocation"] + loc_block(loc)
        bed = BEDS.get(eid)
        L += ["- Key: 1", "  Value:", "    MutagenObjectType: PackageDataTarget", "    Target:"]
        if bed:
            L += ["      MutagenObjectType: PackageTargetSpecificReference", f"      Reference: {bed}"]
        else:
            L += ["      MutagenObjectType: PackageTargetObjectType", "      Type: TouchActorEffects"]  # vanilla default: bed search
        L += ["- Key: 2", "  Value:", "    MutagenObjectType: PackageDataObjectList", "    Data: 0"]
        # keys 15 (lock doors) and 13 (warn before locking) are OFF: public cells and shared houses stay unlocked
        L += (b(6, 0) + b(8, 0) + b(15, 0) + b(13, 0) + b(11, 0) + b(17, 0) + b(18, 1) + b(19, 1) + b(20, 1) + b(21, 1)
              + b(25, 1) + b(22, 1))
        L += ["- Key: 26", "  Value:", "    MutagenObjectType: PackageDataFloat", "    Data: 300",
              "- Key: 24", "  Value:", "    MutagenObjectType: PackageDataFloat", "    Data: 50"]
        return L + ["XnamMarker: 0x05"] + EVENTS
    L = head(pid, eid, tm, conds, False)
    L += [f"PackageTemplate: {SANDBOX}", "DataInputVersion: 10", "Data:", "- Key: 0", "  Value:",
          "    MutagenObjectType: PackageDataLocation"] + loc_block(loc)
    L += (b(1, 1) + b(3, fl["sleep"]) + b(4, 1) + b(5, 1) + b(6, fl["sit"]) + b(7, fl["wander"]) + b(14, 0) + b(25, 0)
          + b(27, 0))
    L += ["- Key: 29", "  Value:", "    MutagenObjectType: PackageDataFloat", "    Data: 50"] + b(31, 1)
    return L + ["XnamMarker: 0x20"] + EVENTS


def pkg_path(pid, eid):
    return TEXT / "Packages" / f"NHV_Pkg_Q02_{eid} - {pid:06X}_{P}.yaml"


def write_packages(check):
    n = 0
    for pid, eid, kind, loc, tm, conds, fl in PKGS:
        text = "\r\n".join(build_package(pid, eid, kind, loc, tm, conds, fl)) + "\r\n"
        p = pkg_path(pid, eid)
        for stale in (TEXT / "Packages").glob(f"NHV_Pkg_Q02_* - {pid:06X}_{P}.yaml"):   # renamed package: drop the old file
            if stale != p:
                n += 1
                if not check:
                    stale.unlink()
        old = p.read_bytes().decode("utf-8") if p.exists() else None
        if old != text:
            n += 1
            if not check:
                p.write_bytes(text.encode("utf-8"))
    return n


def patch_npcs(check):
    n = 0
    for npc, eids in NPC_PKGS.items():
        files = list((TEXT / "Npcs").glob(f"* - {npc}_{P}.yaml"))
        if len(files) != 1:
            print(f"WARN: NPC {npc}: {len(files)} files")
            continue
        p = files[0]
        t = p.read_bytes().decode("utf-8")
        nl = eol_of(t)
        mine = [f"- {fk(BY_EID[e])}" for e in eids]
        # package list of this tool in the record = every "- 00AFxx" entry of the 0xAF50-0xAF63 range: rewrite it as a block
        m = re.search(rf"(?m)^Packages:{nl}((?:- [0-9A-F]{{6}}:[A-Za-z.]+{nl})+)", t)
        if m:
            kept = [x for x in m.group(1).split(nl) if x and not re.match(r"- 00AF(5[0-9A-F]|6[0-3]):", x)]
            new = nl.join(mine + kept) + nl
            if new == m.group(1):
                continue
            n += 1
            if not check:
                t = t[:m.start(1)] + new + t[m.end(1):]
        else:
            n += 1
            if not check:
                t = re.sub(r"(?m)^Class: ", f"Packages:{nl}" + nl.join(mine) + f"{nl}Class: ", t, count=1)
        if not check:
            p.write_bytes(t.encode("utf-8"))
    return n


def patch_quest(check):
    p = next((TEXT / "Quests").glob(f"* - 004100_{P}.yaml"))
    t = p.read_bytes().decode("utf-8")
    nl = eol_of(t)
    mine = [f"  - {fk(BY_EID[e])}" for e in ALIAS_SINGS]
    if all(m in t for m in mine):
        return 0
    if check:
        return 1
    i = t.index(f"- ID: 2{nl}  Name: SingsAlias{nl}")
    j = t.index(f"  PackageData:{nl}", i) + len(f"  PackageData:{nl}")
    k = j
    while t.startswith("  - ", k):                    # end of the existing package list
        k = t.index(nl, k) + len(nl)
    add = "".join(m + nl for m in mine if m not in t)
    t = t[:k] + add + t[k:]
    p.write_bytes(t.encode("utf-8"))
    return 1


def apply(check=False):
    a, b_, c = write_packages(check), patch_npcs(check), patch_quest(check)
    print(f"q02 packages: {a} package files, {b_} NPC records, {c} quest patch changed" + (" (check only)" if check else ""))
    return a + b_ + c


if __name__ == "__main__":
    apply("--check" in sys.argv)
