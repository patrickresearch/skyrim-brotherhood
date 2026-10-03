"""Validate the isolated Q00 draft and derive its reading copies from CSV.

Run from any directory. Writes only Lesefassung.md and Lesetest.html here.
Does not import dialogue into the plugin or generate audio.
"""
import csv
import hashlib
import json
import runpy
from collections import deque
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def read_rows(path):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


def matches(requirements, state):
    return all(state.get(key) == value for key, value in requirements.items())


def validate(flow, rows, journal):
    # Reuse project rules without changing the active linter or its speaker registry.
    lint = runpy.run_path(str(ROOT / "tools/dialogue_lint.py"))
    lint["VANILLA_SPEAKERS"].add("Lucien")
    errors, warnings, ids, texts = [], [], {}, {}
    for name in ("Q00.csv", "Journal.csv"):
        lint["check_file"](HERE / name, errors, warnings, ids, texts)
    if errors:
        raise ValueError("\n".join(errors))
    for warning in warnings:
        print("WARNING:", warning)
    active_ids = {r["LineID"] for p in (ROOT / "dialogue").glob("*.csv") for r in read_rows(p)}
    collisions = active_ids & set(ids)
    # E41 intentionally promotes the new Stage-12 IDs into the active Q00/Journal masters.
    assert collisions <= {line_id for line_id in collisions if "_012_" in line_id}, "Draft IDs overlap active masters"
    original = json.loads((HERE / "baseline.json").read_text(encoding="utf-8"))
    assert hashlib.sha256((HERE / "Q00-original.csv.snapshot").read_bytes()).hexdigest() == original[0]["sha256"]
    for item in json.loads((HERE / "reviewed-baseline.json").read_text(encoding="utf-8")):
        actual = hashlib.sha256((ROOT / item["path"]).read_bytes()).hexdigest()
        assert actual == item["sha256"], f"Protected source changed: {item['path']}"

    active_rows = [r for r in rows if "obsolete (E41)" not in r["Notes"]]
    active_flow = [node for node in flow["nodes"] if not node.get("obsolete")]
    nodes = {node["id"]: node for node in active_flow}
    assert len(nodes) == len(active_flow), "Duplicate node"
    line_map = {r["LineID"]: r for r in active_rows}
    used = []
    for node in nodes.values():
        used.extend(node["lines"])
        for line in node["lines"]:
            assert line in line_map and line_map[line]["Speaker"] != "Player"
        for choice in node.get("choices", []):
            assert choice["to"] in nodes
            if "line" in choice:
                used.append(choice["line"])
                assert line_map[choice["line"]]["Speaker"] == "Player"
        for edge in ("next", "otherwise"):
            if edge in node:
                assert node[edge] in nodes
        assert node.get("terminal") or node.get("next") or node.get("choices"), node["id"]
    assert len(used) == len(set(used)) and set(used) == set(line_map), "Unused or duplicated dialogue"

    reached, accepted_states, finishes = set(), 0, 0
    for cicero in (False, True):
        for initiates in (False, True):
            initial = dict(flow["initial"], cicero=cicero, initiates=initiates)
            queue = deque([(flow["start"], initial)])
            seen = set()
            ended = False
            while queue:
                key, state = queue.popleft()
                signature = (key, tuple(sorted(state.items())))
                if signature in seen:
                    continue
                seen.add(signature)
                node = nodes[key]
                if not matches(node.get("when", {}), state):
                    queue.append((node["otherwise"], state))
                    continue
                assert matches(node.get("requires", {}), state), f"Ungated entry: {key}"
                state = dict(state, **node.get("effects", {}))
                reached.add(key)
                if node["stage"] >= 15:
                    assert state["heardInvitation"], "Departure before recruitment is explained"
                if key == "summon":
                    assert state["witnessAccepted"], "Witness revealed without explicit acceptance"
                if not state["lucien"]:
                    visible = [line_map[line]["Text"] for line in node["lines"]]
                    visible += [line_map[c["line"]]["Text"] if "line" in c else c["ui"]
                                for c in node.get("choices", []) if matches(c.get("requires", {}), state)]
                    assert all("lucien" not in text.lower() for text in visible), f"Early reveal: {key}"
                if key == "accept":
                    assert all(state[k] for k in ("returned", "heardPlan", "heardMethod", "heardAuthority"))
                    accepted_states += 1
                if key in ("doubt", "end", "finished"):
                    assert state["accepted"] and state["memorial"] in (1, 2, 3)
                if key == "retry":
                    assert not state["lucien"]
                if node.get("terminal"):
                    ended = True
                    finishes += 1
                targets = ([node["next"]] if "next" in node else [])
                targets += [c["to"] for c in node.get("choices", []) if matches(c.get("requires", {}), state)]
                for target in targets:
                    assert nodes[target]["stage"] >= node["stage"], f"Stage regression: {key} -> {target}"
                    queue.append((target, state))
            assert ended, "Profile cannot finish"
    assert reached == set(nodes), f"Unreachable: {set(nodes) - reached}"
    assert all("lucien" not in row["Text"].lower() for row in journal if int(row["Stage"]) <= 10)
    print(f"Validated {len(rows)} dialogue lines, {len(journal)} journal texts, {len(nodes)} nodes.")
    print(f"Four profiles complete; {accepted_states} acceptance states gated; {finishes} ending states.")
    print("Original snapshot intact; active masters match reviewed parallel-work baseline. No active LineID collision.")


def markdown(flow, rows, journal):
    by_id = {r["LineID"]: r for r in rows}
    out = ["# Q00 V2 – vollständige Lesefassung", "",
           "**Inaktiver Entwurf vom 29.09.2026.** Aus Q00.csv und flow.json erzeugt. "
           "Diese Redaktion verändert den aktiven Master nicht. Spielertext und Responses stammen ausschließlich aus CSV.", "",
           "Lies die Pflichtblöcke in Reihenfolge; die Auswahlziele führen zu Nachfragen oder Fortsetzungen. "
           "`Weiter` und Ortswechsel sind Regie des Lesetests, keine gesprochenen Spielerzeilen. "
           "Zum Durchklicken: Lesetest.html neben dieser Datei öffnen. Details zur späteren Aktivierung: README.md.", ""]
    for node in flow["nodes"]:
        if node.get("obsolete"):
            continue
        out += [f'<a id="{node["id"]}"></a>', f'## {node["title"]}', "",
                f'**Stage {node["stage"]} · {node["id"]}**', ""]
        if node.get("when"):
            out += [f'Nur bei `{json.dumps(node["when"])}`; sonst [{node["otherwise"]}](#{node["otherwise"]}).', ""]
        if node.get("requires"):
            out += [f'Voraussetzung im Lesetest: `{json.dumps(node["requires"])}`.', ""]
        if node.get("direction"):
            out += [f'*Regie: {node["direction"]}*', ""]
        for line in node["lines"]:
            row = by_id[line]
            out += [f'**{row["Speaker"]}** · `{line}` · {row["Emotion"]} {row["Value"]}', "", f'> {row["Text"]}', ""]
        for choice in node.get("choices", []):
            row = by_id.get(choice.get("line"))
            label = f'{row["Text"]} (`{row["LineID"]}`)' if row else f'Regie: {choice["ui"]}'
            gate = f' — nur bei `{json.dumps(choice["requires"])}`' if choice.get("requires") else ""
            out += [f'- {label} → [{choice["to"]}](#{choice["to"]}){gate}']
        out += [""]
        if node.get("next"):
            verb = "Gespräch pausiert; beim Wiederansprechen" if node.get("pause") else "Weiter"
            out += [f'{verb} → [{node["next"]}](#{node["next"]}).', ""]
        if node.get("effects"):
            out += [f'Nach vollständigem Block im Lesetest: `{json.dumps(node["effects"])}`.', ""]
    out += ["## Journalvarianten", ""]
    for row in journal:
        out += [f'**Stage {row["Stage"]} · {row["Topic"]}** · `{row["LineID"]}`', "", f'> {row["Text"]}', ""]
    (HERE / "Lesefassung.md").write_text("\n".join(out), encoding="utf-8")


PAGE = r'''<!doctype html>
<html lang="de"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Night's Harvest · Q00 V2 Lesetest</title>
<style>
body{margin:0;background:#131517;color:#e9e5df;font:18px/1.6 Georgia,serif}main{max-width:900px;margin:auto;padding:32px 24px 90px}
header{border-bottom:1px solid #555;padding-bottom:20px}h1{font-size:32px;margin:8px 0}h2{font-size:25px}
small,.meta,button,label,summary{font-family:system-ui,sans-serif}.meta,small{color:#bcb8b0}p{margin:10px 0}
.speech{border-left:2px solid #946d55;padding:12px 22px;margin:22px 0;background:#1c1e20}.speaker{color:#e5b291;font-family:system-ui;font-size:14px}
button{display:block;width:100%;text-align:left;background:#24282d;border:1px solid #555;color:#f3ece2;padding:13px 16px;margin:10px 0;cursor:pointer;font-size:16px;border-radius:5px}
button:hover,button:focus-visible{background:#374048;border-color:#e5b291;outline:2px solid #e5b291}input{accent-color:#b67d58}label{display:inline-block;margin:8px 20px 8px 0;font-size:15px}
.note{background:#292622;padding:12px 16px;font:15px/1.5 system-ui}.id{display:none}body.ids .id{display:inline;color:#888;font-size:12px}
details{margin-top:32px;border-top:1px solid #555;padding-top:16px}#history{font-size:16px;white-space:pre-wrap}#reset{width:auto;font-size:14px}a{color:#e5b291}
</style><main><header><small>INAKTIVE TEXTFASSUNG · 29.09.2026</small><h1>A Shadow at the Door</h1>
<p>Q00 V2 · Gesprächsfolge zum Durchspielen</p><p class="meta">Dieser Lesetest simuliert Entscheidungen und Übergänge. Er verändert weder Skyrim noch Queststände, Sprachdateien oder das Plugin.</p>
<label><input id="cicero" type="checkbox" checked> Cicero lebt</label><label><input id="initiates" type="checkbox"> Initiates vorhanden</label>
<label><input id="ids" type="checkbox"> LineIDs anzeigen</label><button id="reset">Mit diesen Einstellungen neu beginnen</button></header>
<section id="content" aria-live="polite"></section><div id="choices"></div><details><summary>Bisheriger Gesprächsverlauf</summary><div id="history"></div></details></main>
<script id="data" type="application/json">__DATA__</script><script>
const data=JSON.parse(document.getElementById('data').textContent), graph=Object.fromEntries(data.flow.nodes.map(n=>[n.id,n]));
const rows=Object.fromEntries(data.rows.map(r=>[r.LineID,r]));let state,history,current;
const el=id=>document.getElementById(id), matches=r=>Object.entries(r||{}).every(([k,v])=>state[k]===v);
function add(parent,tag,text,cls){const x=document.createElement(tag);x.textContent=text;if(cls)x.className=cls;parent.append(x);return x;}
function button(text,go){const b=add(el('choices'),'button',text);b.onclick=go;}
function enter(id){let n=graph[id];if(!matches(n.when))return enter(n.otherwise);
 if(!matches(n.requires))throw Error('Gesperrter Einstieg: '+id);
 current=id;Object.assign(state,n.effects||{});el('content').replaceChildren();el('choices').replaceChildren();
 add(el('content'),'p','Stage '+n.stage+' · '+id,'meta');add(el('content'),'h2',n.title);
 if(n.direction)add(el('content'),'p',n.direction,'note');
 history.push('\n['+n.title+']');
 n.lines.forEach(key=>{const r=rows[key],block=add(el('content'),'div','','speech');add(block,'div',r.Speaker,'speaker');add(block,'span',key,'id');add(block,'p',r.Text);history.push(r.Speaker+': '+r.Text);});
 if(n.pause)add(el('content'),'p','Das Gespräch ist vertagt. Wiederansprechen setzt genau hier fort; keine neue Zustimmung wird angenommen.','note');
 (n.choices||[]).filter(c=>matches(c.requires)).forEach(c=>{const r=rows[c.line];button(r?r.Text:c.ui,()=>{history.push((r?'Player: ':'Regie: ')+(r?r.Text:c.ui));enter(c.to);});});
 if(n.next)button(n.pause?'Veyra / Gruppe erneut ansprechen':'Weiter – nächsten Block / Weltvorgang ansehen',()=>enter(n.next));
 if(n.terminal)add(el('content'),'p','Lesetest abgeschlossen. Im Spiel wäre Q01 jetzt aktiv. Danke fürs Prüfen.','note');
 el('history').textContent=history.join('\n');
}
function reset(){state={...data.flow.initial,cicero:el('cicero').checked,initiates:el('initiates').checked};history=[];enter(data.flow.start);}
el('ids').onchange=()=>document.body.classList.toggle('ids',el('ids').checked);el('reset').onclick=reset;reset();
</script></html>'''


def main():
    flow = json.loads((HERE / "flow.json").read_text(encoding="utf-8"))
    rows, journal = read_rows(HERE / "Q00.csv"), read_rows(HERE / "Journal.csv")
    validate(flow, rows, journal)
    markdown(flow, rows, journal)
    payload = json.dumps({"flow": flow, "rows": rows}, ensure_ascii=False).replace("<", "\\u003c")
    (HERE / "Lesetest.html").write_text(PAGE.replace("__DATA__", payload), encoding="utf-8")
    print("Derived Lesefassung.md and Lesetest.html from draft CSV + flow.json.")


if __name__ == "__main__":
    main()
