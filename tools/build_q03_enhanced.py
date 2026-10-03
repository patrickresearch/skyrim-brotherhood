#!/usr/bin/env python3
"""Build the inactive Q03 Enhanced reading draft from the Q03 V2 baseline."""

from __future__ import annotations

import csv
import json
from copy import deepcopy
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "dialogue" / "drafts" / "Q03-v2"
OUT = ROOT / "dialogue" / "drafts" / "enhanced" / "Q03"


FIELDS = [
    "LineID", "Quest", "Stage", "Topic", "Speaker", "VoiceType",
    "Emotion", "Value", "Text", "Conditions", "Notes",
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def enhanced_id(line_id: str) -> str:
    prefix, suffix = line_id.rsplit("_", 1)
    return f"{prefix}_{int(suffix) + 3000:04d}"


def enhanced_rows(filename: str) -> tuple[list[dict[str, str]], dict[str, str]]:
    rows = read_csv(BASE / filename)
    mapping: dict[str, str] = {}
    for row in rows:
        old = row["LineID"]
        new = enhanced_id(old)
        mapping[old] = new
        row["LineID"] = new
        row["Notes"] = "Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired."
    return rows, mapping


def row(line_id: str, stage: int, topic: str, speaker: str, voice: str,
        emotion: str, text: str, notes: str = "") -> dict[str, str]:
    return {
        "LineID": line_id,
        "Quest": "Q03",
        "Stage": str(stage),
        "Topic": topic,
        "Speaker": speaker,
        "VoiceType": voice,
        "Emotion": emotion,
        "Value": "30" if speaker not in {"Player", "Journal", "Book"} else "50",
        "Text": text,
        "Conditions": f"GetStage NHV_Q03_TheScholarsSin == {stage}",
        "Notes": notes,
    }


def add_dialogue() -> list[dict[str, str]]:
    return [
        row("NHV_Q03_015_4200", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Puzzled", "You are asking about Aurantil? Read the margin, too.", "New College witness; no Vanilla record change."),
        row("NHV_Q03_015_4201", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "You signed one of these statements."),
        row("NHV_Q03_015_4202", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "What did you see after the blast?"),
        row("NHV_Q03_015_4203", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "Why did your account change?"),
        row("NHV_Q03_015_4204", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "I have enough. Keep your margin."),
        row("NHV_Q03_015_4205", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Fear", "I was an apprentice. I saw smoke, a broken focus crystal, and Nirelda pulling me clear."),
        row("NHV_Q03_015_4206", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Anger", "The master wanted certainty. I had only a room full of witnesses who remembered different fire."),
        row("NHV_Q03_015_4207", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Anger", "She chose a person before she chose an explanation. I have never forgiven her for making that difficult."),
        row("NHV_Q03_015_4208", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Neutral", "The margin is a copy, not a verdict. It still names the focus crystal and the first witness."),
        row("NHV_Q03_015_4209", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "Give me the copied margin."),
        row("NHV_Q03_015_4210", 15, "Enhanced_Selveni", "Player", "-", "Neutral", "Leave it here. The College can keep its own doubt."),
        row("NHV_Q03_015_4211", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Sad", "Take it. Return it if the College asks what you learned."),
        row("NHV_Q03_015_4212", 15, "Enhanced_Selveni", "Selveni", "NHV_VoiceSelveni", "Sad", "Then take the road with only Urag's version. It is safer for the College."),
        row("NHV_Q03_025_4250", 25, "Enhanced_Roadside", "Player", "-", "Neutral", "The south road has a cold silence to it. Search the waystation."),
        row("NHV_Q03_025_4251", 25, "Enhanced_Roadside", "RoadSurvivor", "NHV_VoiceRoadSurvivor", "Fear", "Do not go to the tower. The woman with the fire was not taking coin."),
        row("NHV_Q03_025_4252", 25, "Enhanced_Roadside", "Player", "-", "Neutral", "Treat the survivor first."),
        row("NHV_Q03_025_4253", 25, "Enhanced_Roadside", "Player", "-", "Neutral", "Inspect the burned pack."),
        row("NHV_Q03_025_4254", 25, "Enhanced_Roadside", "Player", "-", "Neutral", "Follow the scorch marks."),
        row("NHV_Q03_025_4255", 25, "Enhanced_RoadsideAid", "RoadSurvivor", "NHV_VoiceRoadSurvivor", "Fear", "The frost took my brother. She measured his breath until the fire went out."),
        row("NHV_Q03_025_4256", 25, "Enhanced_RoadsideAid", "Player", "-", "Neutral", "You are alive. Tell the College what you saw when you can."),
        row("NHV_Q03_025_4257", 25, "Enhanced_RoadsidePack", "Player", "-", "Neutral", "The pack is burned from the inside. No coin was taken."),
        row("NHV_Q03_025_4258", 25, "Enhanced_RoadsidePack", "RoadSurvivor", "NHV_VoiceRoadSurvivor", "Fear", "Take the token. It was my brother's. Nirelda took nothing else."),
        row("NHV_Q03_025_4259", 25, "Enhanced_RoadsideTracks", "Player", "-", "Neutral", "The scorch marks stop where the snow begins. Someone wanted the trail to end."),
        row("NHV_Q03_025_4260", 25, "Enhanced_RoadsideTracks", "RoadSurvivor", "NHV_VoiceRoadSurvivor", "Fear", "The light moved uphill. I never saw a face, only a hand bright with fire."),
        row("NHV_Q03_025_4261", 25, "Enhanced_RoadsideResolved", "Veyra", "NHV_VoiceVeyra", "Neutral", "A witness, a token, and a road that refuses to name its dead."),
        row("NHV_Q03_035_4350", 35, "Enhanced_Resonance", "Nirelda", "NHV_VoiceNirelda", "Neutral", "The pillars open the first chamber. The second responds to what you carry."),
        row("NHV_Q03_035_4351", 35, "Enhanced_Resonance", "Player", "-", "Neutral", "Use Selveni's focus fragment."),
        row("NHV_Q03_035_4352", 35, "Enhanced_Resonance", "Player", "-", "Neutral", "Break the chamber before it can test us."),
        row("NHV_Q03_035_4353", 35, "Enhanced_Resonance", "Player", "-", "Neutral", "Wait and watch the mechanism."),
        row("NHV_Q03_035_4354", 35, "Enhanced_ResonanceFragment", "Nirelda", "NHV_VoiceNirelda", "Fear", "You brought a fragment from the College. It remembers the shape of my first mistake."),
        row("NHV_Q03_035_4355", 35, "Enhanced_ResonanceBreak", "Nirelda", "NHV_VoiceNirelda", "Anger", "Fire is not a key merely because I wield it."),
        row("NHV_Q03_035_4356", 35, "Enhanced_ResonanceWait", "Nirelda", "NHV_VoiceNirelda", "Puzzled", "Patience gives the tower time to decide whether you are worth the stairs."),
        row("NHV_Q03_035_4357", 35, "Enhanced_ResonanceEnd", "Nirelda", "NHV_VoiceNirelda", "Neutral", "The frostfire ward is quiet. Continue, but do not touch the empty crystal cradle."),
        row("NHV_Q03_045_4450", 45, "Enhanced_ConsentLedger", "Player", "-", "Neutral", "Before we continue, show me the names in your ledger."),
        row("NHV_Q03_045_4451", 45, "Enhanced_ConsentLedger", "Nirelda", "NHV_VoiceNirelda", "Neutral", "Names, dates, responses. I released three subjects when they asked. I kept the others when they did not."),
        row("NHV_Q03_045_4452", 45, "Enhanced_ConsentLedger", "Player", "-", "Neutral", "Read the page marked 'refused'."),
        row("NHV_Q03_045_4453", 45, "Enhanced_ConsentRefusal", "Nirelda", "NHV_VoiceNirelda", "Fear", "The page is blank. I could not make a measurement from a refusal."),
        row("NHV_Q03_045_4454", 45, "Enhanced_ConsentLedger", "Player", "-", "Neutral", "You wrote down consent after the fact."),
        row("NHV_Q03_045_4455", 45, "Enhanced_ConsentAfter", "Nirelda", "NHV_VoiceNirelda", "Fear", "I wrote down the moment I understood that consent changes the experiment."),
        row("NHV_Q03_045_4456", 45, "Enhanced_ConsentLedger", "Player", "-", "Neutral", "Close the ledger."),
        row("NHV_Q03_045_4457", 45, "Enhanced_ConsentClose", "Nirelda", "NHV_VoiceNirelda", "Puzzled", "A boundary without an explanation is still a boundary. You keep surprising me."),
        row("NHV_Q03_065_4650", 65, "Enhanced_DeadDrop", "Player", "-", "Neutral", "The letter was hidden behind a false panel."),
        row("NHV_Q03_065_4651", 65, "Enhanced_DeadDrop", "Nirelda", "NHV_VoiceNirelda", "Neutral", "A countermark. L.M. sent it through another hand."),
        row("NHV_Q03_065_4652", 65, "Enhanced_DeadDrop", "Player", "-", "Neutral", "Keep the seal with the fragments."),
        row("NHV_Q03_065_4653", 65, "Enhanced_DeadDrop", "Player", "-", "Neutral", "Burn the seal. It teaches us nothing yet."),
        row("NHV_Q03_065_4654", 65, "Enhanced_DeadDropKeep", "Nirelda", "NHV_VoiceNirelda", "Fear", "It teaches you that distance can be part of a murder."),
        row("NHV_Q03_065_4655", 65, "Enhanced_DeadDropBurn", "Player", "-", "Neutral", "Then we keep the distance in mind."),
    ]


def add_journal() -> list[dict[str, str]]:
    return [
        row("NHV_Q03_015_5200", 15, "Enhanced_JournalObjective", "Journal", "-", "Neutral", "Cross-check the Aurantil file with a College witness.", "New subphase; no active Stage numbering assumed."),
        row("NHV_Q03_015_5201", 15, "Enhanced_JournalLog", "Journal", "-", "Neutral", "Selveni's copied margin complicates the College's account of Nirelda's expulsion.", ""),
        row("NHV_Q03_025_5250", 25, "Enhanced_JournalObjective", "Journal", "-", "Neutral", "Search the abandoned waystation on the south road.", ""),
        row("NHV_Q03_025_5251", 25, "Enhanced_JournalLog", "Journal", "-", "Neutral", "A survivor and a burned pack place Nirelda's tests between rescue and cruelty.", ""),
        row("NHV_Q03_035_5350", 35, "Enhanced_JournalObjective", "Journal", "-", "Neutral", "Pass the resonance chamber beneath the Four Stillnesses.", ""),
        row("NHV_Q03_035_5351", 35, "Enhanced_JournalLog", "Journal", "-", "Neutral", "The focus fragment opens a ward tied to Nirelda's first experiment.", ""),
        row("NHV_Q03_045_5450", 45, "Enhanced_JournalObjective", "Journal", "-", "Neutral", "Read Nirelda's consent ledger before answering her questions.", ""),
        row("NHV_Q03_045_5451", 45, "Enhanced_JournalLog", "Journal", "-", "Neutral", "Her notes distinguish refusal, consent, and the moments she chose to ignore both.", ""),
        row("NHV_Q03_065_5650", 65, "Enhanced_JournalObjective", "Journal", "-", "Neutral", "Search the false panel for the order's countermark.", ""),
        row("NHV_Q03_065_5651", 65, "Enhanced_JournalLog", "Journal", "-", "Neutral", "L.M. used a seal and distance to keep the poison order deniable.", ""),
    ]


def add_books() -> list[dict[str, str]]:
    return [
        row("NHV_Q03_015_6150", 15, "Enhanced_CollegeMargin", "Book", "-", "Neutral", "COLLEGE MARGIN\n\nThe focus crystal failed before the second flare. Aurantil pulled Selveni clear. Three witnesses called it an accident; none agreed on who lit the room. The file closes around the uncertainty.", "Found in the College witness's copied notes."),
        row("NHV_Q03_035_6350", 35, "Enhanced_FrostfireNote", "Book", "-", "Neutral", "FROSTFIRE WARD\n\nThe ward responds to carried evidence. A fragment remembers the hand that broke it. Fire opens nothing by force alone; patience leaves fewer burns.", "Found beneath the resonance chamber."),
        row("NHV_Q03_065_6650", 65, "Enhanced_Countermark", "Book", "-", "Neutral", "COUNTERMARK\n\nA black seal pressed into wax. No name, no office, only a route and a payment mark. The hand that orders a death need not stand near the body.", "Optional evidence beside the Whisperbane order."),
    ]


def remap(value: object, mapping: dict[str, str]) -> object:
    if isinstance(value, str):
        return mapping.get(value, value)
    if isinstance(value, list):
        return [remap(item, mapping) for item in value]
    if isinstance(value, dict):
        return {key: remap(item, mapping) for key, item in value.items()}
    return value


def build_flow(mapping: dict[str, str]) -> dict:
    flow = json.loads((BASE / "flow.json").read_text(encoding="utf-8"))
    flow = remap(flow, mapping)
    flow["version"] = 4
    flow["status"] = "INACTIVE_ENHANCED_DRAFT"
    flow["initial"].update({"collegeWitness": False, "roadEvidence": False, "resonance": False, "ledgerRead": False, "countermarkKept": False})

    nodes = {node["id"]: node for node in flow["nodes"]}
    nodes["record_fail"]["next"] = "selveni"
    nodes["record_tower"]["next"] = "selveni"
    nodes["record_witness"]["next"] = "selveni"
    nodes["widow_nirelda"]["next"] = "road"
    for choice in nodes["widow"]["choices"]:
        if choice.get("line") == mapping["NHV_Q03_020_1003"]:
            choice["to"] = "road"
    for node_id in ("pillars_notes", "pillars_force", "pillars_careful"):
        nodes[node_id]["next"] = "resonance"
    for node_id in ("heal", "let_die", "interrupt"):
        nodes[node_id]["next"] = "consent_ledger"
    nodes["poison_reveal"]["next"] = "dead_drop"
    nodes["poison_limit"]["next"] = "dead_drop"

    def n(node_id: str, stage: int, title: str, lines: list[str], **kwargs: object) -> dict:
        node = {"id": node_id, "stage": stage, "title": title, "lines": lines}
        node.update(kwargs)
        return node

    additions = [
        n("selveni", 15, "Eine College-Zeugin ergänzt die Akte", ["NHV_Q03_015_4200", "NHV_Q03_015_4201"], choices=[
            {"line": "NHV_Q03_015_4202", "to": "selveni_accident"},
            {"line": "NHV_Q03_015_4203", "to": "selveni_changed"},
            {"line": "NHV_Q03_015_4204", "to": "widow"},
        ]),
        n("selveni_accident", 15, "Die erste Zeugenaussage", ["NHV_Q03_015_4205", "NHV_Q03_015_4206"], next="selveni_copy"),
        n("selveni_changed", 15, "Die Aussage, die sich veränderte", ["NHV_Q03_015_4207", "NHV_Q03_015_4208"], next="selveni_copy"),
        n("selveni_copy", 15, "Eine Kopie ohne Urteil", [], choices=[
            {"line": "NHV_Q03_015_4209", "to": "selveni_take"},
            {"line": "NHV_Q03_015_4210", "to": "selveni_leave"},
        ]),
        n("selveni_take", 15, "Die Randnotiz wird gesichert", ["NHV_Q03_015_4211"], next="widow", effects={"collegeWitness": True}, bookLines=["NHV_Q03_015_6150"]),
        n("selveni_leave", 15, "Die Randnotiz bleibt im College", ["NHV_Q03_015_4212"], next="widow"),
        n("road", 25, "Die verlassene Wegstation", ["NHV_Q03_025_4250", "NHV_Q03_025_4251"], choices=[
            {"line": "NHV_Q03_025_4252", "to": "road_aid"},
            {"line": "NHV_Q03_025_4253", "to": "road_pack"},
            {"line": "NHV_Q03_025_4254", "to": "road_tracks"},
        ]),
        n("road_aid", 25, "Der Überlebende", ["NHV_Q03_025_4255", "NHV_Q03_025_4256"], next="road_resolved"),
        n("road_pack", 25, "Der verbrannte Rucksack", ["NHV_Q03_025_4257", "NHV_Q03_025_4258"], next="road_resolved"),
        n("road_tracks", 25, "Die verklingenden Spuren", ["NHV_Q03_025_4259", "NHV_Q03_025_4260"], next="road_resolved"),
        n("road_resolved", 25, "Die Spur zum Turm", ["NHV_Q03_025_4261"], next="tower", effects={"roadEvidence": True}),
        n("resonance", 35, "Die Resonanzkammer", ["NHV_Q03_035_4350"], choices=[
            {"line": "NHV_Q03_035_4351", "to": "resonance_fragment"},
            {"line": "NHV_Q03_035_4352", "to": "resonance_break"},
            {"line": "NHV_Q03_035_4353", "to": "resonance_wait"},
        ]),
        n("resonance_fragment", 35, "Der Fokus erinnert sich", ["NHV_Q03_035_4354", "NHV_Q03_035_4357"], next="observation", effects={"resonance": True}, bookLines=["NHV_Q03_035_6350"]),
        n("resonance_break", 35, "Feuer ist kein Schlüssel", ["NHV_Q03_035_4355", "NHV_Q03_035_4357"], next="observation", effects={"resonance": True}),
        n("resonance_wait", 35, "Geduld im Frostfeuer", ["NHV_Q03_035_4356", "NHV_Q03_035_4357"], next="observation", effects={"resonance": True}),
        n("consent_ledger", 45, "Das Einverständnis im Ledger", ["NHV_Q03_045_4450", "NHV_Q03_045_4451"], choices=[
            {"line": "NHV_Q03_045_4452", "to": "consent_refusal"},
            {"line": "NHV_Q03_045_4454", "to": "consent_after"},
            {"line": "NHV_Q03_045_4456", "to": "consent_close"},
        ]),
        n("consent_refusal", 45, "Eine leere Seite", ["NHV_Q03_045_4453"], next="question_intro", effects={"ledgerRead": True}),
        n("consent_after", 45, "Ein verspätetes Verständnis", ["NHV_Q03_045_4455"], next="question_intro", effects={"ledgerRead": True}),
        n("consent_close", 45, "Eine gesetzte Grenze", ["NHV_Q03_045_4457"], next="question_intro", effects={"ledgerRead": True}),
        n("dead_drop", 65, "Der falsche Boden", ["NHV_Q03_065_4650", "NHV_Q03_065_4651"], bookLines=["NHV_Q03_065_6650"], choices=[
            {"line": "NHV_Q03_065_4652", "to": "dead_drop_keep"},
            {"line": "NHV_Q03_065_4653", "to": "dead_drop_burn"},
        ]),
        n("dead_drop_keep", 65, "Das Siegel bleibt im Ledger", ["NHV_Q03_065_4654"], next="judgment", effects={"countermarkKept": True}),
        n("dead_drop_burn", 65, "Das Siegel wird verbrannt", ["NHV_Q03_065_4655"], next="judgment"),
    ]
    flow["nodes"].extend(additions)
    return flow


def render_markdown(flow: dict, dialogue: list[dict[str, str]], journals: list[dict[str, str]], books: list[dict[str, str]]) -> None:
    lines = [
        "# Q03 Enhanced - Lesefassung",
        "",
        "Diese Fassung ist ein inaktiver Enhanced-Draft. Q03-V2 und der aktive Master bleiben unverändert.",
        "",
    ]
    lookup = {item["LineID"]: item for item in dialogue}
    book_lookup = {item["LineID"]: item for item in books}
    for node in flow["nodes"]:
        lines.extend([f"## Stage {node['stage']} - {node['title']}", ""])
        if node.get("direction"):
            lines.extend([f"**Direction:** {node['direction']}", ""])
        for line_id in node.get("lines", []):
            item = lookup[line_id]
            lines.extend([f"### `{line_id}` - {item['Speaker']} - Topic `{item['Topic']}`", "", f"> {item['Text']}", ""])
            if item.get("Notes"):
                lines.extend([f"**Notes:** {item['Notes']}", ""])
        for line_id in node.get("bookLines", []):
            if line_id in book_lookup:
                item = book_lookup[line_id]
                lines.extend([f"### Found item: `{line_id}` - {item['Topic']}", "", f"> {item['Text'].replace(chr(10), chr(10) + '> ')}", ""])
        for choice in node.get("choices", []):
            label = lookup[choice["line"]]["Text"] if "line" in choice else f"World event: {choice['ui']}"
            lines.append(f"- {label} -> `{choice['to']}`")
        if node.get("next"):
            lines.extend([f"Continue: `{node['next']}`.", ""])
        lines.append("")
    lines.append("## Journal variants")
    lines.append("")
    for item in journals:
        lines.extend([f"### Stage {item['Stage']} - `{item['LineID']}` - {item['Topic']}", "", f"> {item['Text']}", ""])
    (OUT / "Lesefassung.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    dialogue, dialogue_map = enhanced_rows("Q03.csv")
    journals, journal_map = enhanced_rows("Journal.csv")
    books, book_map = enhanced_rows("Books.csv")
    dialogue.extend(add_dialogue())
    journals.extend(add_journal())
    books.extend(add_books())
    write_csv(OUT / "Q03.csv", dialogue)
    write_csv(OUT / "Journal.csv", journals)
    write_csv(OUT / "Books.csv", books)
    flow = build_flow({**dialogue_map, **book_map})
    (OUT / "flow.json").write_text(json.dumps(flow, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    render_markdown(flow, dialogue, journals, books)


if __name__ == "__main__":
    main()
