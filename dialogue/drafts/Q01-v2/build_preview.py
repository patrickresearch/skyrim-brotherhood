"""Validate the inactive Q01 edition and derive offline reading copies.

No active CSV, plugin, script, voice or game file is changed.
Run: python dialogue/drafts/Q01-v2/build_preview.py
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


def validate(flow, rows, journal, books, reference):
    lint = runpy.run_path(str(ROOT / "tools/dialogue_lint.py"))
    errors, warnings, ids, texts = [], [], {}, {}
    for name in ("Q01.csv", "Journal.csv", "Books.csv"):
        lint["check_file"](HERE / name, errors, warnings, ids, texts)
    if errors:
        raise ValueError("\n".join(errors))
    for warning in warnings:
        print("WARNING:", warning)
    active_ids = {r["LineID"] for p in (ROOT / "dialogue").glob("*.csv") for r in read_rows(p)}
    assert not active_ids.intersection(ids), "Draft ID collides with an active master"
    for item in json.loads((HERE / "baseline.json").read_text(encoding="utf-8")):
        for path in (ROOT / item["path"], HERE / item["snapshot"]):
            assert hashlib.sha256(path.read_bytes()).hexdigest() == item["sha256"], f"Baseline changed: {path}"
    nodes = {n["id"]: n for n in flow["nodes"]}
    assert len(nodes) == len(flow["nodes"])
    line_map = {r["LineID"]: r for r in rows}
    book_map = {r["LineID"]: r for r in books + reference}
    used, used_books = [], set()
    for n in nodes.values():
        used.extend(n["lines"])
        for key in n["lines"]:
            assert key in line_map and line_map[key]["Speaker"] != "Player"
        for c in n.get("choices", []):
            assert c["to"] in nodes
            if "line" in c:
                used.append(c["line"])
                assert line_map[c["line"]]["Speaker"] == "Player"
        for edge in ("next", "otherwise"):
            if edge in n:
                assert n[edge] in nodes
        for key in n.get("bookLines", []):
            assert key in book_map
            used_books.add(key)
        assert n.get("terminal") or n.get("next") or n.get("choices"), f"Dead end: {n['id']}"
    assert len(used) == len(set(used)) and set(used) == set(line_map), "Missing/reused dialogue"
    assert {r["LineID"] for r in books}.issubset(used_books), "Unused new book paragraph"

    reached, endings, total_states = set(), set(), 0
    for persuade in (False, True):
        for intimidate in (False, True):
            initial = dict(flow["initial"], persuade=persuade, intimidate=intimidate)
            queue = deque([(flow["start"], initial)])
            seen, profile_end = set(), False
            while queue:
                key, state = queue.popleft()
                signature = (key, tuple(sorted(state.items())))
                if signature in seen:
                    continue
                seen.add(signature)
                n = nodes[key]
                if not matches(n.get("when", {}), state):
                    queue.append((n["otherwise"], state))
                    continue
                assert matches(n.get("requires", {}), state), f"Ungated entry: {key}"
                state = dict(state, **n.get("effects", {}))
                reached.add(key)
                if n["stage"] >= 30:
                    assert state["investigated"], "Confrontation without cellar investigation"
                if n["stage"] >= 50:
                    assert state["confessed"], "Trial before confession"
                if key in ("authorize", "choice_kill", "hrefna_attack", "player_takes_over"):
                    assert state["briefed"], "Action without explanation"
                if n["stage"] >= 60:
                    assert state["authorized"] and state["killer"] in ("hrefna", "player"), "Judgment before death"
                if key == "diary_confront":
                    assert state["diary"]
                if key.startswith("home"):
                    assert state["outcome"] == "recruited" and not state["hrefnaDead"]
                if key == "release_letter":
                    assert state["outcome"] == "released" and not state["hrefnaDead"]
                if key == "debrief_dead":
                    assert state["hrefnaDead"] and state["outcome"] == "dead"
                if key == "debrief_proven":
                    assert state["killer"] == "hrefna" and not state["coerced"] and not state["triedIntimidate"]
                if key == "debrief_after_threat":
                    assert state["killer"] == "hrefna" and not state["coerced"] and state["triedIntimidate"]
                if key == "debrief_coerced":
                    assert state["killer"] == "hrefna" and state["coerced"]
                if key == "debrief_unproven":
                    assert state["killer"] == "player"
                if state["hrefnaDead"]:
                    assert all(line_map[x]["Speaker"] != "Hrefna" for x in n["lines"]), "Dead Hrefna speaks"
                if n.get("terminal"):
                    assert state["fragment"] and state["outcome"] != "none"
                    profile_end = True
                    endings.add((state["route"], state["killer"], state["outcome"], state["coerced"], state["diary"]))
                targets = [n["next"]] if "next" in n else []
                targets += [c["to"] for c in n.get("choices", []) if matches(c.get("requires", {}), state)]
                assert targets or n.get("terminal"), f"No available choice: {key}"
                for target in targets:
                    assert nodes[target]["stage"] >= n["stage"], f"Stage regression: {key} -> {target}"
                    queue.append((target, state))
            assert profile_end, "Speech profile cannot finish"
            total_states += len(seen)
    assert reached == set(nodes), f"Unreachable nodes: {set(nodes) - reached}"
    assert {x[0] for x in endings} == {"room", "road"}
    assert {x[2] for x in endings} == {"recruited", "released", "dead"}
    print(f"Validated {len(rows)} dialogue lines, {len(journal)} journal texts, {len(books)} new book paragraphs.")
    print(f"{len(nodes)} nodes; four Speech profiles; {len(endings)} ending variants; {total_states} states checked.")
    print("Original masters and snapshots unchanged. No active ID collisions. Optional spellchecker not run.")


def markdown(flow, rows, journal, books, reference):
    line_map = {r["LineID"]: r for r in rows}
    book_map = {r["LineID"]: r for r in books + reference}
    out = ["# Q01 V2 – The Unanswered Sacrament", "",
           "**Inaktive Lesefassung vom 29.09.2026.** Aus CSV und flow.json erzeugt. Aktive Dialoge und Stimmen bleiben erhalten.", "",
           "Anschluss: Q00 abgeschlossen, Veyras Ledger erhalten. Hrefna ist eine mögliche Kandidatin; der Listener hat ihr keinen Platz versprochen.", "",
           "Die Auswahlziele verlinken Folgegespräche. Regieknöpfe simulieren Weltvorgänge. Conditions/Gates sind hier ein Autorenablauf, keine fertige Plugin-Integration.", ""]
    for n in flow["nodes"]:
        out += [f'<a id="{n["id"]}"></a>', f'## Stage {n["stage"]} · {n["title"]}', ""]
        if n.get("when"):
            out += [f'Bedingung: `{json.dumps(n["when"], ensure_ascii=False)}`. Sonst: [{n["otherwise"]}](#{n["otherwise"]}).', ""]
        if n.get("requires"):
            out += [f'Voraussetzung: `{json.dumps(n["requires"], ensure_ascii=False)}`.', ""]
        if n.get("direction"):
            out += [f'**Regie:** {n["direction"]}', ""]
        for key in n["lines"]:
            r = line_map[key]
            out += [f'**{r["Speaker"]}** · `{key}`', "", f'> {r["Text"]}', ""]
        for key in n.get("bookLines", []):
            r = book_map[key]
            source = "V2-Buchmaster" if key.startswith("NHV_Q01") else "unveränderte Buchreferenz"
            out += [f'**Fundstück: {r["Topic"]}** · `{key}` · {source}', "", "> " + r["Text"].replace("\\n", "\n").replace("\n", "\n> "), ""]
        for c in n.get("choices", []):
            label = line_map[c["line"]]["Text"] if "line" in c else "Regie: " + c["ui"]
            condition = f' · nur `{json.dumps(c["requires"], ensure_ascii=False)}`' if c.get("requires") else ""
            identifier = f' · `{c["line"]}`' if "line" in c else ""
            out += [f'- [{label}](#{c["to"]}){identifier}{condition}']
        if n.get("choices"):
            out += [""]
        if n.get("next"):
            out += [f'Weiter: [{n["next"]}](#{n["next"]}).', ""]
        if n.get("pause"):
            out += ["Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.", ""]
        if n.get("terminal"):
            out += ["**Ende des Lesetests.**", ""]
    out += ["## Journalvarianten", ""]
    for r in journal:
        out += [f'**Stage {r["Stage"]} · {r["Topic"]}** · `{r["LineID"]}`', "", f'> {r["Text"]}', "", r["Notes"], ""]
    (HERE / "Lesefassung.md").write_text("\n".join(out), encoding="utf-8")


PAGE = r'''<!doctype html>
<html lang="de"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Night's Harvest · Q01 V2 Lesetest</title><style>
body{margin:0;background:#131517;color:#e9e5df;font:18px/1.6 Georgia,serif}main{max-width:900px;margin:auto;padding:32px 24px 90px}header{border-bottom:1px solid #555;padding-bottom:20px}h1{font-size:32px;margin:8px 0}h2{font-size:25px}small,.meta,button,label,summary{font-family:system-ui,sans-serif}.meta,small{color:#bcb8b0}p{margin:10px 0}.speech{border-left:2px solid #946d55;padding:12px 22px;margin:22px 0;background:#1c1e20}.speaker{color:#e5b291;font-family:system-ui;font-size:14px}.book{white-space:pre-wrap;background:#24211d;padding:20px}.chosen{color:#bdcddd;font-style:italic}button{display:block;width:100%;text-align:left;background:#24282d;border:1px solid #555;color:#f3ece2;padding:13px 16px;margin:10px 0;cursor:pointer;font-size:16px;border-radius:5px}button:hover,button:focus-visible{background:#374048;border-color:#e5b291;outline:2px solid #e5b291}button:disabled{opacity:.35;cursor:default}input{accent-color:#b67d58}label{display:inline-block;margin:8px 20px 8px 0;font-size:15px}.note{background:#292622;padding:12px 16px;font:15px/1.5 system-ui}.id{display:none}body.ids .id{display:inline;color:#aaa;font-size:12px}details{margin-top:28px;border-top:1px solid #555;padding-top:16px}#history{font-size:16px;white-space:pre-wrap}.controls{display:flex;gap:12px}.controls button{width:auto;font-size:14px}
</style><main><header><small>INAKTIVE TEXTFASSUNG · 29.09.2026</small><h1>The Unanswered Sacrament</h1><p>Q01 V2 · Von einer unbeantworteten Bitte zur bewussten Entscheidung</p><p class="meta">Offline-Lesetest. Kein Eingriff in Skyrim, aktive Dialoge, Sprachdateien oder Queststände. Weltvorgänge und Speech-Checks werden simuliert.</p>
<label><input id="persuade" type="checkbox" checked> Überreden gelingt</label><label><input id="intimidate" type="checkbox" checked> Einschüchtern gelingt</label><label><input id="ids" type="checkbox"> LineIDs anzeigen</label><p class="meta">Check-Ergebnisse gelten nach Neustart. Fehlgeschlagene Versuche bleiben im jeweiligen Durchlauf verbraucht.</p><div class="controls"><button id="reset">Mit diesen Einstellungen neu beginnen</button><button id="back">Einen Schritt zurück</button></div></header><section id="content" aria-live="polite"></section><div id="choices"></div><details><summary>Bisheriger Gesprächsverlauf</summary><div id="history"></div></details></main>
<script id="data" type="application/json">__DATA__</script><script>
const data=JSON.parse(document.getElementById('data').textContent),graph=Object.fromEntries(data.flow.nodes.map(n=>[n.id,n])),rows=Object.fromEntries(data.rows.map(r=>[r.LineID,r])),books=Object.fromEntries(data.books.map(r=>[r.LineID,r]));let state,history,current,stack,lastChoice;
const el=id=>document.getElementById(id),matches=r=>Object.entries(r||{}).every(([k,v])=>state[k]===v);
function add(parent,tag,text,cls){const x=document.createElement(tag);x.textContent=text;if(cls)x.className=cls;parent.append(x);return x;}
function button(text,target,spoken){const b=add(el('choices'),'button',text);b.onclick=()=>{stack.push({state:{...state},history:[...history],current,lastChoice});lastChoice=spoken?text:'';history.push((spoken?'Player: ':'Regie: ')+text);enter(target);};}
function enter(id){const n=graph[id];if(!matches(n.when))return enter(n.otherwise);if(!matches(n.requires))throw Error('Gesperrter Einstieg: '+id);current=id;Object.assign(state,n.effects||{});history.push('\n['+n.title+']');n.lines.forEach(key=>history.push(rows[key].Speaker+': '+rows[key].Text));render();}
function render(){const n=graph[current];el('content').replaceChildren();el('choices').replaceChildren();add(el('content'),'p','Stage '+n.stage+' · '+current,'meta');add(el('content'),'h2',n.title);if(lastChoice)add(el('content'),'p','Player: '+lastChoice,'chosen');if(n.direction)add(el('content'),'p',n.direction,'note');n.lines.forEach(key=>{const r=rows[key],block=add(el('content'),'div','','speech');add(block,'div',r.Speaker,'speaker');add(block,'span',key,'id');add(block,'p',r.Text);});(n.bookLines||[]).forEach(key=>{const r=books[key];add(el('content'),'p',r.Topic+' · '+key,'meta');add(el('content'),'div',r.Text.replaceAll('\\n','\n'),'book');});if(n.pause)add(el('content'),'p','Vertagt. Der Fortgang setzt am offenen Gespräch an. Es wurde kein weiterer Ausgang beschlossen.','note');(n.choices||[]).filter(c=>matches(c.requires)).forEach(c=>button(c.line?rows[c.line].Text:c.ui,c.to,!!c.line));if(n.next)button(n.pause?'Gespräch / Begegnung wieder aufnehmen':'Weiter – nächsten Block / Weltvorgang ansehen',n.next,false);if(n.terminal)add(el('content'),'p','Q01-Lesetest abgeschlossen. Die übrigen Kern-Contracts können nun am Map Table gewählt werden.','note');el('history').textContent=history.join('\n');el('back').disabled=!stack.length;}
function reset(){state={...data.flow.initial,persuade:el('persuade').checked,intimidate:el('intimidate').checked};history=[];stack=[];lastChoice='';enter(data.flow.start);}
el('back').onclick=()=>{const prev=stack.pop();if(!prev)return;({state,history,current,lastChoice}=prev);render();};el('reset').onclick=reset;el('ids').onchange=()=>document.body.classList.toggle('ids',el('ids').checked);reset();
</script></html>'''


def main():
    flow = json.loads((HERE / "flow.json").read_text(encoding="utf-8"))
    rows, journal, books = (read_rows(HERE / name) for name in ("Q01.csv", "Journal.csv", "Books.csv"))
    reference = read_rows(HERE / "Books-original.csv.snapshot")
    validate(flow, rows, journal, books, reference)
    markdown(flow, rows, journal, books, reference)
    used = {key for n in flow["nodes"] for key in n.get("bookLines", [])}
    payload = json.dumps({"flow": flow, "rows": rows, "books": books + [r for r in reference if r["LineID"] in used]}, ensure_ascii=False).replace("<", "\\u003c")
    (HERE / "Lesetest.html").write_text(PAGE.replace("__DATA__", payload), encoding="utf-8")
    print("Generated Lesefassung.md and standalone Lesetest.html.")


if __name__ == "__main__":
    main()
