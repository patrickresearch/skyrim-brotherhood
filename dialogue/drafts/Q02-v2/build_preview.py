"""Validate and render the isolated Q02 editorial edition."""
import csv, hashlib, json, runpy
from collections import deque
from pathlib import Path

HERE=Path(__file__).resolve().parent; ROOT=HERE.parents[2]
def read(p):
    with p.open(encoding="utf-8",newline="") as f:return list(csv.DictReader(f))
def matches(req,state): return all(state.get(k)==v for k,v in (req or {}).items())
def validate(flow,rows,journal,books):
    lint=runpy.run_path(str(ROOT/"tools/dialogue_lint.py")); lint["CUSTOM_VOICED_SPEAKERS"].update({"DrinksTheBrine","HaldorFrostKnuckle","Hjorald"})
    errors=[];warnings=[];ids={};texts={}
    for name in ("Q02.csv","Journal.csv","Books.csv"):lint["check_file"](HERE/name,errors,warnings,ids,texts)
    if errors: raise ValueError("\n".join(errors))
    active={r["LineID"] for p in (ROOT/"dialogue").glob("*.csv") for r in read(p)}
    assert not active.intersection(ids),"Draft ID collision"
    for item in json.loads((HERE/"baseline.json").read_text()):
        assert hashlib.sha256((ROOT/item["path"]).read_bytes()).hexdigest()==item["sha256"]
        assert hashlib.sha256((HERE/item["snapshot"]).read_bytes()).hexdigest()==item["sha256"]
    nodes={n["id"]:n for n in flow["nodes"]}; line_map={r["LineID"]:r for r in rows}; used=[]
    for n in nodes.values():
        used+=n["lines"]
        for c in n.get("choices",[]):
            assert c["to"] in nodes
            if "line" in c:used.append(c["line"]);assert line_map[c["line"]]["Speaker"]=="Player"
        for e in ("next","otherwise"):
            if e in n:assert n[e] in nodes
        for b in n.get("bookLines",[]):assert b in {r["LineID"] for r in books}|{ "NHV_SYS_BOOK_82" }
    assert set(used)==set(line_map) and len(used)==len(set(used))
    reached=set();ends=set()
    for persuade in (False,True):
      for bribe in (False,True):
       q=deque([(flow["start"],dict(flow["initial"],persuade=persuade,bribe=bribe))]);seen=set()
       while q:
        key,state=q.popleft();sig=(key,tuple(sorted(state.items())))
        if sig in seen:continue
        seen.add(sig);n=nodes[key]
        if not matches(n.get("when"),state):q.append((n["otherwise"],state));continue
        assert matches(n.get("requires"),state),key
        state=dict(state,**n.get("effects",{}));reached.add(key)
        if int(n["stage"])>=30:assert state["watched"] or key=="night",f"Night watch missing: {key}"
        if int(n["stage"])>=50:assert state["confessed"] or key in ("hollow","identity","rescue_gate","rescue_question","rescue_reply","confess")
        if int(n["stage"])>=60 and key not in ("aelius_state","aelius_early"):assert state["authorized"]
        if key=="judgment":assert state["killer"]=="sings"
        if key=="judgment_player":assert state["killer"]=="player"
        if key=="judgment_other":assert state["killer"]=="other"
        if n.get("terminal"):assert state["outcome"]!="none";ends.add((state["killer"],state["outcome"]))
        targets=([n["next"]] if "next" in n else [])+[c["to"] for c in n.get("choices",[]) if matches(c.get("requires"),state)]
        assert targets or n.get("terminal"),key
        for t in targets:assert int(nodes[t]["stage"])>=int(n["stage"]);q.append((t,state))
    assert reached==set(nodes),f"Unreachable: {set(nodes)-reached}"
    assert {x[1] for x in ends}>={"recruited","released","surrendered","dead"}
    print(f"Validated {len(rows)} dialogue, {len(journal)} journal, {len(books)} new books; {len(nodes)} nodes; {len(ends)} outcomes.")
    print("Active Q02/Journal/Books and snapshots unchanged; no ID collisions.")
def render(flow,rows,journal,books,active_books):
    by={r["LineID"]:r for r in rows};all_books=books+active_books;bk={r["LineID"]:r for r in all_books};out=["# Q02 V2 – Cold Waters","","**Inactive editorial draft.** Q00/Q01 are complete; Q02 begins as a chosen contract. Existing voice masters remain untouched.",""]
    for n in flow["nodes"]:
        out += [f'## Stage {n["stage"]} · {n["title"]}',""]
        if n.get("direction"):out += [f'**Direction:** {n["direction"]}',""]
        for k in n["lines"]:out += [f'**{by[k]["Speaker"]}** · `{k}`',"",f'> {by[k]["Text"]}',""]
        for k in n.get("bookLines",[]):
            if k in bk:out += [f'**Found item: {bk[k]["Topic"]}** · `{k}`',"",'> '+bk[k]["Text"].replace("\\n","\n> "),""]
        for c in n.get("choices",[]):
            label=by[c["line"]]["Text"] if "line" in c else "World event: "+c["ui"];out += [f'- [{label}](#{c["to"]})']
        if n.get("next"):out += [f'Continue: `{n["next"]}`.',""]
    out += ["## Journal variants",""]+[f'**Stage {r["Stage"]} · {r["Topic"]}** `{r["LineID"]}`\n\n> {r["Text"]}\n' for r in journal]
    (HERE/"Lesefassung.md").write_text("\n".join(out),encoding="utf-8")
    payload=json.dumps({"flow":flow,"rows":rows,"books":all_books},ensure_ascii=False).replace("<","\\u003c")
    page='''<!doctype html><meta charset="utf-8"><title>Night's Harvest · Q02 V2</title><style>body{max-width:850px;margin:auto;padding:2em;background:#131517;color:#eee;font:18px Georgia;line-height:1.55}.speech{border-left:3px solid #a76;padding:.5em 1em;margin:1em 0;background:#202225}.speaker{font:14px system-ui;color:#e9b18d}button{display:block;width:100%;padding:.8em;margin:.5em 0;background:#272c32;color:#fff;border:1px solid #777;text-align:left;font-size:16px}small{color:#baafa2}</style><h1>Q02 V2 – Cold Waters</h1><p><small>INACTIVE OFFLINE TEST · world events are simulated</small></p><main id="main"></main><div id="choices"></div><script id="data" type="application/json">__DATA__</script><script>const d=JSON.parse(document.getElementById("data").textContent),g=Object.fromEntries(d.flow.nodes.map(n=>[n.id,n])),r=Object.fromEntries(d.rows.map(x=>[x.LineID,x])),b=Object.fromEntries(d.books.map(x=>[x.LineID,x]));let s={...d.flow.initial,persuade:true,bribe:true},cur=d.flow.start;function ok(x){return Object.entries(x||{}).every(([k,v])=>s[k]===v)}function enter(id){let n=g[id];if(!ok(n.when))return enter(n.otherwise);s={...s,...n.effects};cur=id;render()}function render(){let n=g[cur],m=document.getElementById("main"),c=document.getElementById("choices");m.innerHTML=`<small>Stage ${n.stage} · ${cur}</small><h2>${n.title}</h2>`+(n.direction?`<p>${n.direction}</p>`:"")+n.lines.map(k=>`<div class="speech"><div class="speaker">${r[k].Speaker}</div><div>${r[k].Text}</div></div>`).join("")+(n.bookLines||[]).map(k=>b[k]?`<pre>${b[k].Text.replaceAll("\\\\n","\\n")}</pre>`:"").join("");c.innerHTML="";(n.choices||[]).filter(x=>ok(x.requires)).forEach(x=>{let q=document.createElement("button");q.textContent=x.line?r[x.line].Text:"World event: "+x.ui;q.onclick=()=>enter(x.to);c.append(q)});if(n.next){let q=document.createElement("button");q.textContent="Continue";q.onclick=()=>enter(n.next);c.append(q)}if(n.terminal)m.innerHTML+="<p>Test complete.</p>"}enter(cur)</script>'''
    (HERE/"Lesetest.html").write_text(page.replace("__DATA__",payload),encoding="utf-8")
def main():
    flow=json.loads((HERE/"flow.json").read_text());rows=read(HERE/"Q02.csv");journal=read(HERE/"Journal.csv");books=read(HERE/"Books.csv");active_books=read(ROOT/"dialogue/Books.csv");validate(flow,rows,journal,books);render(flow,rows,journal,books,active_books)
if __name__=="__main__":main()
