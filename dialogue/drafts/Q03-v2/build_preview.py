"""Validate/render inactive Q03 editorial draft."""
import csv,hashlib,json,runpy
from collections import deque
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
def read(p):
 with p.open(encoding="utf-8",newline="") as f:return list(csv.DictReader(f))
def ok(req,s):return all(s.get(k)==v for k,v in (req or {}).items())
def main():
 flow=json.loads((HERE/"flow.json").read_text());rows=read(HERE/"Q03.csv");journal=read(HERE/"Journal.csv");books=read(HERE/"Books.csv")
 lint=runpy.run_path(str(ROOT/"tools/dialogue_lint.py"));lint["CUSTOM_VOICED_SPEAKERS"].update({"Thyra","Joric"});lint["VANILLA_SPEAKERS"].add("Urag");errors=[];warnings=[];ids={};texts={}
 for name in ("Q03.csv","Journal.csv","Books.csv"):lint["check_file"](HERE/name,errors,warnings,ids,texts)
 if errors:raise ValueError("\n".join(errors))
 active={r["LineID"] for p in (ROOT/"dialogue").glob("*.csv") for r in read(p)};assert not active.intersection(ids)
 for x in json.loads((HERE/"baseline.json").read_text()):
  assert hashlib.sha256((ROOT/x["path"]).read_bytes()).hexdigest()==x["sha256"];assert hashlib.sha256((HERE/x["snapshot"]).read_bytes()).hexdigest()==x["sha256"]
 nodes={n["id"]:n for n in flow["nodes"]};lm={r["LineID"]:r for r in rows};used=[]
 for n in nodes.values():
  used+=n["lines"]
  for c in n.get("choices",[]):
   assert c["to"] in nodes
   if "line" in c:used.append(c["line"]);assert lm[c["line"]]["Speaker"]=="Player"
  for e in ("next","otherwise"):
   if e in n:assert n[e] in nodes
 assert set(used)==set(lm) and len(used)==len(set(used))
 reached=set();ends=set()
 for archmage in (False,True):
  for tolfdir in (False,True):
   for score in (False,True):
    s=dict(flow["initial"],archmage=archmage,tolfdir=tolfdir,record=score);q=deque([(flow["start"],s)]);seen=set()
    while q:
     key,s=q.popleft();sig=(key,tuple(sorted(s.items())))
     if sig in seen:continue
     seen.add(sig);n=nodes[key]
     if not ok(n.get("when"),s):q.append((n["otherwise"],s));continue
     assert ok(n.get("requires"),s),key;s=dict(s,**n.get("effects",{}));reached.add(key)
     if int(n["stage"])>=20:assert s["foundTower"] or key in ("urag","record","record_fail","bribe_record","archmage_record","persuade_record","widow","widow_nirelda")
     if int(n["stage"])>=30:assert s["foundTower"]
     if int(n["stage"])>=40:assert s["pillars"]
     if int(n["stage"])>=50:assert s["briefed"]
     if int(n["stage"])>=60:assert s["examPassed"] or s["combatYield"] or key in ("correspondence","poison_reveal","poison_limit")
     if n.get("terminal"):assert s["outcome"]!="none";ends.add(s["outcome"])
     ts=([n["next"]] if "next" in n else [])+[c["to"] for c in n.get("choices",[]) if ok(c.get("requires"),s)]
     assert ts or n.get("terminal"),key
     for t in ts:assert int(nodes[t]["stage"])>=int(n["stage"]);q.append((t,s))
 assert reached==set(nodes),f"Unreachable: {set(nodes)-reached}";assert {"recruited","college","released","dead"}.issubset(ends)
 render(flow,rows,journal,books);print(f"Validated {len(rows)} dialogue, {len(journal)} journal, {len(books)} new book; {len(nodes)} nodes; outcomes {sorted(ends)}.")
def render(flow,rows,journal,books):
 lm={r["LineID"]:r for r in rows};bm={r["LineID"]:r for r in books};out=["# Q03 V2 – The Scholar's Sin","","**Inactive editorial draft.** Q02 is complete; Nirelda's examination follows the same Listener authority established in Q00/Q01.",""]
 for n in flow["nodes"]:
  out += [f'## Stage {n["stage"]} · {n["title"]}',""]
  if n.get("direction"):out += [f'**Direction:** {n["direction"]}',""]
  for k in n["lines"]:out += [f'**{lm[k]["Speaker"]}** · `{k}`',"",f'> {lm[k]["Text"]}',""]
  for k in n.get("bookLines",[]):
   if k in bm:out += [f'**Found item: {bm[k]["Topic"]}** · `{k}`',"",'> '+bm[k]["Text"].replace("\\n","\n> "),""]
  for c in n.get("choices",[]):out += [f'- {lm[c["line"]]["Text"] if "line" in c else "World event: "+c["ui"]} → `{c["to"]}`']
  if n.get("next"):out += [f'Continue: `{n["next"]}`.',""]
 out += ["## Journal variants",""]+[f'**Stage {r["Stage"]} · {r["Topic"]}** `{r["LineID"]}`\n\n> {r["Text"]}\n' for r in journal];(HERE/"Lesefassung.md").write_text("\n".join(out),encoding="utf-8")
 data=json.dumps({"flow":flow,"rows":rows,"books":books},ensure_ascii=False).replace("<","\\u003c")
 page='''<!doctype html><meta charset="utf-8"><title>Night's Harvest · Q03 V2</title><style>body{max-width:850px;margin:auto;padding:2em;background:#131517;color:#eee;font:18px Georgia;line-height:1.55}.speech{border-left:3px solid #a76;padding:.5em 1em;margin:1em 0;background:#202225}.speaker{font:14px system-ui;color:#e9b18d}button{display:block;width:100%;padding:.8em;margin:.5em 0;background:#272c32;color:#fff;border:1px solid #777;text-align:left;font-size:16px}small{color:#baafa2}</style><h1>Q03 V2 – The Scholar's Sin</h1><p><small>INACTIVE OFFLINE TEST · world events are simulated</small></p><main id="m"></main><div id="c"></div><script id="data" type="application/json">__DATA__</script><script>const d=JSON.parse(document.getElementById("data").textContent),g=Object.fromEntries(d.flow.nodes.map(n=>[n.id,n])),r=Object.fromEntries(d.rows.map(x=>[x.LineID,x]));let s={...d.flow.initial,archmage:false,record:false},cur=d.flow.start;function ok(x){return Object.entries(x||{}).every(([k,v])=>s[k]===v)}function enter(i){let n=g[i];if(!ok(n.when))return enter(n.otherwise);s={...s,...n.effects};cur=i;render()}function render(){let n=g[cur],m=document.getElementById("m"),c=document.getElementById("c");m.innerHTML=`<small>Stage ${n.stage} · ${cur}</small><h2>${n.title}</h2>`+(n.direction?`<p>${n.direction}</p>`:"")+n.lines.map(k=>`<div class="speech"><div class="speaker">${r[k].Speaker}</div><div>${r[k].Text}</div></div>`).join("");c.innerHTML="";(n.choices||[]).filter(x=>ok(x.requires)).forEach(x=>{let b=document.createElement("button");b.textContent=x.line?r[x.line].Text:"World event: "+x.ui;b.onclick=()=>enter(x.to);c.append(b)});if(n.next){let b=document.createElement("button");b.textContent="Continue";b.onclick=()=>enter(n.next);c.append(b)}}enter(cur)</script>''';(HERE/"Lesetest.html").write_text(page.replace("__DATA__",data),encoding="utf-8")
if __name__=="__main__":main()
