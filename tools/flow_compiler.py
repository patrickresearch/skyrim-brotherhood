#!/usr/bin/env python3
"""Compile a V2 dialogue flow (dialogue/drafts/<Q>-v2/flow.json + CSV) into Spriggit YAML records and Papyrus
fragments. Rule 4: every response/prompt text is read from the CSV, never written here.

Model
-----
* A node with `line` choices is a *hub*. Every choice becomes a top-level player topic whose INFO is visible
  only while the quest stage matches and the hub's cursor global holds the hub ordinal (conditions, not scripts).
* The answer to a choice is the *chain* behind it: node lines, effects, `next` links, stage changes. The first
  speaker run is the INFO itself (its speaker is the host, checked with GetIsID); the remaining runs become a
  generated scene that the INFO fragment starts. A stage change (or a spec hook) ends a "piece"; the next piece
  is described by the spec (`entries`): "auto" scene (starts right away), "scene_ext" (an existing script starts
  it), "greet" (ForceGreet package + INFO) or "say" (existing topic, handled by the caller).
* When a chain ends in another hub, the last fragment sets the cursor to that hub. All state lives in Globals.
* Fragments only call NHV_Util.FlowSet / FlowStage / FlowScene (Global functions, additive in NHV_Util).
"""
import csv
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TEXT = REPO / "plugin-text"
SCRIPTS = REPO / "Data" / "Source" / "Scripts"
P = "NightsHarvest.esp"

OPN = {"==": None, ">=": "GreaterThanOrEqualTo", ">": "GreaterThan", "<=": "LessThanOrEqualTo", "<": "LessThan",
       "!=": "NotEqualTo"}


def fk(n):
    return f"{n:06X}:{P}"


def q(t):
    return "'" + t.replace("'", "''") + "'"


class FlowError(Exception):
    pass


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


class Flow:
    def __init__(self, spec):
        self.s = spec
        self.qname = spec["quest"]
        self.flow = spec["flow_data"] if "flow_data" in spec else json.load(open(REPO / spec["flow"], encoding="utf-8"))
        self.N = {n["id"]: n for n in self.flow["nodes"]}
        self.rows = {}
        for path in [spec["csv"]] + list(spec.get("extra_csv", [])):
            for r in csv.DictReader(open(REPO / path, encoding="utf-8-sig", newline="")):
                if r.get("LineID"):
                    self.rows.setdefault(r["LineID"], r)
        self.idmap_path = REPO / spec["idmap"]
        raw = json.loads(self.idmap_path.read_text(encoding="utf-8")) if self.idmap_path.exists() else {}
        self.ids = raw.get("ids", {})
        self.ords = raw.get("ord", {})
        self.lo, self.hi = spec["id_range"]
        self.next_id = max([self.lo] + [u + 1 for u in self.ids.values()])
        self.files = {}
        self.scripts = {}
        self.scenes_made = []
        self.topics_made = 0
        self.greets = []          # dict(node, topic, package fid, host, stage, cursor ordinal)
        self.visited = set()
        self.say_code = {}
        self.notes = []

    # ------------------------------------------------------------------ ids / ordinals
    def fid(self, key):
        if key not in self.ids:
            if self.next_id > self.hi:
                raise FlowError("FormID range exhausted")
            self.ids[key] = self.next_id
            self.next_id += 1
        return self.ids[key]

    def save_ids(self):
        self.idmap_path.write_text(json.dumps(dict(ids=self.ids, ord=self.ords), indent=1, sort_keys=True) + "\n",
                                   encoding="utf-8")

    def ordinal(self, kind, key):
        k = f"{kind}:{key}"
        if k not in self.ords:
            base = 1 if kind == "hub" else 1000
            self.ords[k] = max([base - 1] + [v for kk, v in self.ords.items() if kk.startswith(kind + ":")]) + 1
        return self.ords[k]

    # ------------------------------------------------------------------ state / conditions
    def gname(self, key):
        return f"{self.s['prefix']}_{key}"

    def gid(self, key):
        return self.fid("G:" + key)

    def enum_values(self, key):
        vals = ["none"]
        init = self.flow.get("initial", {}).get(key)
        if isinstance(init, str) and init not in vals:
            vals.append(init)
        for n in self.flow["nodes"]:
            srcs = [n.get("effects", {}), n.get("requires", {}), n.get("when", {})]
            srcs += [c.get("requires", {}) for c in n.get("choices", [])]
            for src in srcs:
                v = src.get(key)
                if isinstance(v, str) and v not in vals:
                    vals.append(v)
        return vals

    def num(self, key, val):
        if isinstance(val, bool):
            return 1 if val else 0
        if isinstance(val, int):
            return val
        return self.enum_values(key).index(val)

    def state_keys(self):
        world, speech = self.s.get("world", {}), self.s.get("speech", {})
        used = set()
        for n in self.flow["nodes"]:
            if n.get("obsolete"):
                continue
            for src in [n.get("effects", {}), n.get("requires", {}), n.get("when", {})] + \
                       [c.get("requires", {}) for c in n.get("choices", [])]:
                used.update(src.keys())
        return [k for k in self.flow.get("initial", {}) if k in used and k not in world and k not in speech]

    def state_cond(self, key, val):
        world = self.s.get("world", {})
        if key in world:
            return world[key](val, self)
        sp = self.s.get("speech", {})
        if key in sp:
            return cond("GetActorValue", ["ActorValue: Speech"], ">=" if val else "<", sp[key],
                        extra=["RunOnType: Reference", "Reference: 000014:Skyrim.esm"])
        op = "=="
        if isinstance(val, str) and val.startswith("!"):
            op, val = "!=", val[1:]
        return cond("GetGlobalValue", [f"Global: {fk(self.gid(key))}"], op, self.num(key, val))

    def conds_lines(self, conds):
        out = []
        for c in conds:
            k = c[0]
            if k == "stage":
                out += cond("GetStage", [f"Quest: {self.s['qkey']}"], c[1], c[2])
            elif k == "cursor":
                vals = c[2] if isinstance(c[2], (list, tuple)) else [c[2]]
                for i, v in enumerate(vals):
                    out += cond("GetGlobalValue", [f"Global: {fk(self.gid('Cursor' + c[1]))}"], "==", v,
                                flags=["OR"] if i < len(vals) - 1 else ())
            elif k == "state":
                out += self.state_cond(c[1], c[2])
            elif k == "host":
                out += cond("GetIsID", [f"Object: {self.s['hosts'][c[1]]['base']}"])
            elif k == "raw":
                out += c[1]
            else:
                raise FlowError("unknown condition " + str(c))
        return out

    # ------------------------------------------------------------------ graph walking
    def hub_choices(self, n):
        return [c for c in n.get("choices", []) if "line" in c]

    def lane_of(self, nid):
        return self.s.get("lanes", {}).get(nid, "Main")

    def walk(self, nid, stage, seen=(), root=False):
        """-> [dict(conds, items, end)]. items: ('N',id) ('L',line) ('E',k,v) ('C',code) ('S',stage) ('IF',(k,v),items).
        end: ('hub',id) ('entry',id) ('ui',id) ('term',id) ('none',id)."""
        if nid in seen:
            raise FlowError(f"cycle at {nid}")
        seen = seen + (nid,)
        self.visited.add(nid)
        n = self.N[nid]
        if n.get("obsolete"):
            raise FlowError(f"chain reaches obsolete node {nid}")
        entries = self.s.get("entries", {})
        w = n.get("when")
        prev = seen[-2] if len(seen) > 1 else None
        inlined = prev is not None and prev in self.s.get("inline_entry_from", {}).get(nid, ())
        if nid in entries and not root and not inlined:
            ent = entries[nid]
            items = []
            if ent.get("set_stage", ent["kind"] != "ui") and n["stage"] != stage:
                items.append(("S", n["stage"]))
            if ent["kind"] == "ui":
                items += [("E", k, v) for k, v in n.get("effects", {}).items()]
                if self.s.get("node_code", {}).get(nid):
                    items.append(("C", list(self.s["node_code"][nid])))
            kind_end = "ui" if ent["kind"] == "ui" else "entry"
            here = dict(conds=[], items=items, end=(kind_end, nid))
            if w and ent["kind"] != "ui":
                (wk, wv), = w.items()
                neg = (not wv) if isinstance(wv, bool) else "!" + str(wv)
                res = [dict(conds=[("state", wk, wv)], items=items, end=here["end"])]
                for v in self.walk(n["otherwise"], stage, seen):
                    res.append(dict(conds=[("state", wk, neg)] + v["conds"], items=v["items"], end=v["end"]))
                return res
            return [here]
        at_end = self.s.get("stage_at_end", ())
        items = []
        cur = stage
        if n["stage"] != cur and nid not in at_end:
            items.append(("S", n["stage"]))   # the stage change ends the piece in front of this node
            cur = n["stage"]
        items.append(("N", nid))
        effs = dict(n.get("effects", {}))
        effs.update(self.s.get("node_effects", {}).get(nid, {}))
        body = [("L", l) for l in n.get("lines", [])] + [("E", k, v) for k, v in effs.items()]
        if self.s.get("node_code", {}).get(nid):
            body.append(("C", list(self.s["node_code"][nid])))
        if nid in at_end and n["stage"] != cur:
            body.append(("S", n["stage"]))
            cur = n["stage"]
        if w and not root:
            (wk, wv), = w.items()
            other, nxt = n.get("otherwise"), n.get("next")
            if other and other == nxt and not n.get("choices"):
                out = []
                for v in self.walk(nxt, cur, seen):
                    out.append(dict(conds=v["conds"], items=[("N", nid)] + [("IF", (wk, wv), body)] + v["items"],
                                    end=v["end"]))
                return out
            res = []
            for v in self._continue(n, nid, items + body, cur, seen):
                res.append(dict(conds=[("state", wk, wv)] + v["conds"], items=v["items"], end=v["end"]))
            neg = (not wv) if isinstance(wv, bool) else "!" + str(wv)
            for v in self.walk(other, cur, seen):
                res.append(dict(conds=[("state", wk, neg)] + v["conds"], items=v["items"], end=v["end"]))
            return res
        return self._continue(n, nid, items + body, cur, seen)

    def _continue(self, n, nid, items, cur, seen):
        if self.hub_choices(n):
            return [dict(conds=[], items=items, end=("hub", nid))]
        if n.get("choices"):
            return [dict(conds=[], items=items, end=("ui", nid))]
        if n.get("terminal"):
            return [dict(conds=[], items=items, end=("term", nid))]
        if not n.get("next"):
            return [dict(conds=[], items=items, end=("none", nid))]
        return [dict(conds=v["conds"], items=items + v["items"], end=v["end"])
                for v in self.walk(n["next"], cur, seen)]

    def speaker(self, line):
        r = self.rows.get(line)
        if not r:
            raise FlowError("line not in CSV: " + line)
        return r["Speaker"]

    def expand_ifs(self, items):
        variants = [([], [])]
        for it in items:
            if it[0] == "IF":
                (k, v), body = it[1], it[2]
                neg = (not v) if isinstance(v, bool) else "!" + str(v)
                nv = []
                for conds, its in variants:
                    nv.append((conds + [("state", k, v)], its + body))
                    nv.append((conds + [("state", k, neg)], its))
                variants = nv
            else:
                variants = [(c, i + [it]) for c, i in variants]
        return variants

    def add_hooks(self, items):
        h = self.s.get("hooks", {})
        out = []
        for it in items:
            if it[0] == "IF":
                out.append(("IF", it[1], self.add_hooks(it[2])))
                continue
            if it[0] == "L" and it[1] in h.get("before", {}):
                out.append(("X", h["before"][it[1]], "line:" + it[1]))
            out.append(it)
            if it[0] == "L" and it[1] in h.get("after", {}):
                out.append(("X", h["after"][it[1]], "after:" + it[1]))
        return out

    def split_pieces(self, items, stage):
        pieces, cur = [], dict(first=None, firstline=None, items=[], boundary=None, key=None, stage=stage)
        for it in items:
            if it[0] in ("S", "X"):
                cur["boundary"] = it
                pieces.append(cur)
                nstage = it[1] if it[0] == "S" else cur["stage"]
                cur = dict(first=None, firstline=None, items=[], boundary=None,
                           key=it[2] if it[0] == "X" else None, stage=nstage)
                continue
            if it[0] == "N" and cur["first"] is None:
                cur["first"] = it[1]
                cur["stage"] = self.N[it[1]]["stage"] if cur["stage"] is None else cur["stage"]
            if it[0] == "L" and cur["firstline"] is None:
                cur["firstline"] = it[1]
            cur["items"].append(it)
        pieces.append(cur)
        return pieces

    def runs(self, items):
        out = []
        for it in items:
            if it[0] == "L":
                sp = self.speaker(it[1])
                if out and out[-1]["speaker"] == sp and out[-1]["cond"] is None:
                    out[-1]["lines"].append(it[1])
                else:
                    out.append(dict(speaker=sp, lines=[it[1]], cond=None))
            elif it[0] == "IF":
                for r in self.runs(it[2]):
                    r["cond"] = it[1]
                    out.append(r)
        return out

    def effects(self, items):
        out = []
        for it in items:
            if it[0] == "E":
                out.append((it[1], it[2]))
            elif it[0] == "IF":
                out += self.effects(it[2])
        return out

    # ------------------------------------------------------------------ code helpers
    def cursor_code(self, end, from_lane):
        kind, nid = end[0], end[1]
        code = []
        if kind == "hub":
            lane = self.lane_of(nid)
            if from_lane and from_lane != lane:
                code.append(f"NHV_Util.FlowSet(0x{self.gid('Cursor' + from_lane):06X}, 0)")
            code.append(f"NHV_Util.FlowSet(0x{self.gid('Cursor' + lane):06X}, {self.ordinal('hub', nid)})")
        else:
            lane = from_lane or "Main"
            reset = f"NHV_Util.FlowSet(0x{self.gid('Cursor' + lane):06X}, 0)"
            start = self.entry_start_code(nid) if kind == "entry" else []
            if not any(l.startswith(reset[:-3]) for l in start):   # the entry sets this cursor itself
                code.append(reset)
            code += start
            if kind == "ui" and self.s["entries"].get(nid, {}).get("then_hub"):
                hub = self.s["entries"][nid]["then_hub"]
                code.append(f"NHV_Util.FlowSet(0x{self.gid('Cursor' + self.lane_of(hub)):06X}, {self.ordinal('hub', hub)})")
        return code

    def piece_code(self, items):
        code = []
        for it in items:
            if it[0] == "E":
                code += self.effect_code([(it[1], it[2])])
            elif it[0] == "C":
                code += list(it[1])
            elif it[0] == "IF":
                code += self.piece_code(it[2])
        return code

    def effect_code(self, effs):
        out = []
        skip = set(self.s.get("world", {})) | set(self.s.get("speech", {}))
        for k, v in effs:
            if k in skip:
                continue   # derived from the game state, no global to write
            out.append(f"NHV_Util.FlowSet(0x{self.gid(k):06X}, {self.num(k, v)})")
            for gform in self.s.get("mirror", {}).get(k, []):
                out.append(f"NHV_Util.FlowSet({gform}, {self.num(k, v)})")
        return out

    def stage_code(self, stage):
        return [f"NHV_Util.FlowStage(0x{self.s['qform']:06X}, {stage})"]

    def write_script(self, name, kind, code):
        hidden = {"TopicInfo": "TopicInfo Hidden", "Scene": "Scene Hidden"}[kind]
        o = [";BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment",
             ";NEXT FRAGMENT INDEX 1", f"Scriptname {name} Extends {hidden}", "", ";BEGIN FRAGMENT Fragment_0"]
        if kind == "TopicInfo":
            o += ["Function Fragment_0(ObjectReference akSpeakerRef)", "Actor akSpeaker = akSpeakerRef as Actor"]
        else:
            o.append("Function Fragment_0()")
        o += [";BEGIN CODE"] + code + [";END CODE", "EndFunction", ";END FRAGMENT", "",
                                       ";END FRAGMENT CODE - Do not edit anything between this and the begin comment"]
        self.scripts[name] = "\r\n".join(o) + "\r\n"

    def vmad_info(self, script):
        return ["VirtualMachineAdapter:", "  Scripts:", f"  - Name: {script}", "  ScriptFragments:",
                "    MutagenObjectType: ScriptFragments", f"    FileName: {script}", "    OnEnd:",
                "      ExtraBindDataVersion: 1", f"      ScriptName: {script}", "      FragmentName: Fragment_0"]

    # ------------------------------------------------------------------ record emitters
    def put(self, folder, eid, fid, lines):
        self.files[TEXT / folder / f"{eid} - {fid:06X}_{P}.yaml"] = "\n".join(lines) + "\n"

    def resp_lines(self, lines, prompt_line=None):
        if not lines:   # silent answer: one '...' response (suspected: an empty response text keeps the topic out of the dialogue menu; Q01 test 01.10.2026)
            return ["Responses:", "- EmotionValue: 30", "  ResponseNumber: 1", "  Unknown2: 0x000000",
                    "  Unknown3: 0x000000", "  Text:", "    TargetLanguage: English", "    Value: '...'",
                    "  ScriptNotes: NHV_SILENT" + (f" prompt={prompt_line}" if prompt_line else ""), "  Edits: ''"]
        o = ["Responses:"]
        for i, l in enumerate(lines, 1):
            row = self.rows[l]
            if row["Emotion"] not in ("Neutral", ""):
                o += [f"- Emotion: {row['Emotion']}", f"  EmotionValue: {row['Value']}"]
            else:
                o.append(f"- EmotionValue: {row['Value'] or 30}")
            o += [f"  ResponseNumber: {i}", "  Unknown2: 0x000000", "  Unknown3: 0x000000", "  Text:",
                  "    TargetLanguage: English", f"    Value: {q(row['Text'].strip())}"]
            notes = l + (f" prompt={prompt_line}" if i == 1 and prompt_line else "")
            o += [f"  ScriptNotes: {notes}", "  Edits: ''"]
        return o

    def domain_of(self, speakers):
        return "Sys" if any(sp in self.s.get("sys_speakers", ()) for sp in speakers) else "Q"

    def quest_key(self, domain):
        return self.s["qkey"] if domain == "Q" else self.s["syskey"]

    def make_info(self, eid, n, ifid, lines, conds, prompt_line, tif_code, speaker=None, force_subtitle=False,
                  prev=None, link_to=None, goodbye=False):
        o = [f"FormKey: {fk(ifid)}", f"EditorID: {eid}_INFO{n:02d}"]
        if tif_code:
            name = f"TIF__02{ifid:06X}"
            self.write_script(name, "TopicInfo", tif_code)
            o += self.vmad_info(name)
        flags = (["ForceSubtitle"] if force_subtitle else []) + (["Goodbye"] if goodbye else [])
        if flags:
            o += ["Flags:", "  Flags:"] + [f"  - {f}" for f in flags]
        else:
            o.append("Flags: {}")
        o += [f"PreviousDialog: {fk(prev) if prev else 'Null'}", "FavorLevel: None"]
        o += self.resp_lines(lines, prompt_line)
        if conds:
            o.append("Conditions:")
            o += self.conds_lines(conds)
        if prompt_line:
            o += ["Prompt:", "  TargetLanguage: English", f"  Value: {q(self.rows[prompt_line]['Text'].strip())}"]
        if speaker:
            o.append(f"Speaker: {self.s['hosts'][speaker]['base']}")
        return o

    def scene_topic(self, key, speaker, lines, domain):
        tfid, ifid = self.fid("T:" + key), self.fid("I:" + key)
        eid = f"{self.s['prefix']}_{key}"
        rec = [f"FormKey: {fk(tfid)}", f"EditorID: {eid}", "Priority: 60", f"Quest: {self.quest_key(domain)}",
               "Category: Scene", "Subtype: Scene", "SubtypeName: SCEN"]
        d = TEXT / "DialogTopics" / f"{eid} - {tfid:06X}_{P}"
        self.files[d / "RecordData.yaml"] = "\n".join(rec) + "\n"
        o = self.make_info(eid, 1, ifid, lines, [], None, None, speaker=speaker, force_subtitle=True)
        self.files[d / "Responses" / f"{eid}_INFO01 - {ifid:06X}_{P}.yaml"] = "\n".join(o) + "\n"
        self.topics_made += 1
        return tfid

    def scene_record(self, key, runs, end_code, domain, existing=None, sf_prefix=()):
        if existing:
            sfid, seid, sfname = existing["fid"], existing["eid"], existing["sfname"]
        else:
            sfid = self.fid("S:" + key)
            seid = f"NHV_Scn_{self.qname}_{key}"
            sfname = f"SF_{self.s['prefix']}_02{sfid:06X}"   # script names are limited to 38 characters
        aliases = self.s["aliases"][domain]
        self.write_script(sfname, "Scene", list(sf_prefix) + list(end_code))
        o = [f"FormKey: {fk(sfid)}", f"EditorID: {seid}", "VirtualMachineAdapter:", "  Scripts:",
             f"  - Name: {sfname}", "  ScriptFragments:", "    MutagenObjectType: ScriptFragments",
             f"    FileName: {sfname}", "    OnEnd:", "      ExtraBindDataVersion: 1", f"      ScriptName: {sfname}",
             "      FragmentName: Fragment_0", "Flags: []", "Phases:"]
        for r in runs:
            o.append("- Name: ''")
            if r.get("cond"):
                o.append("  StartConditions:")
                o += ["  " + l for l in self.conds_lines([("state", r["cond"][0], r["cond"][1])])]
            o += ["  Unused2: {}", "  EditorWidth: 200"]
        used = []
        for r in runs:
            if r["speaker"] not in used:
                used.append(r["speaker"])
        o.append("Actors:")
        for sp in used:
            o += [f"- ID: {aliases[sp]}", "  Flags: []", "  BehaviorFlags:", "  - DeathEnd", "  - CombatEnd",
                  "  - DialoguePause"]
        o.append("Actions:")
        for i, r in enumerate(runs):
            t = self.scene_topic(f"{key}_{i + 1:02d}", r["speaker"], r["lines"], domain)
            o += [f"- Name: {r['lines'][0]}", f"  ActorID: {aliases[r['speaker']]}", f"  Index: {i + 1}",
                  f"  StartPhase: {i}", f"  EndPhase: {i}", f"  Topic: {fk(t)}", "  HeadtrackActorID: -1",
                  "  LoopingMax: 10", "  LoopingMin: 1", "  Emotion: Neutral", "  EmotionValue: 0"]
        o += [f"Quest: {self.quest_key(domain)}", f"LastActionIndex: {len(runs)}",
              "VNAM: 0x00000000000000000300000003000000"]
        self.put("Scenes", seid, sfid, o)
        self.scenes_made.append((seid, sfid, len(runs)))
        return sfid

    SCENE_STARTS = ("FlowScene(", "StartSummonCall", "StartVeyraTrial", "OnMemorialChosen", "EnterDeepTogether")

    def starts_scene(self, code):
        return any(m in l for l in code for m in self.SCENE_STARTS)

    def entry_of(self, pc):
        e = self.s.get("entries", {})
        for k in (pc.get("key"), pc["firstline"] and "line:" + pc["firstline"], pc.get("first")):
            if k and k in e:
                return dict(e[k], name=k)
        return None

    def scene_fid(self, ent, pkey):
        if ent.get("existing"):
            return ent["existing"]["fid"]
        return self.fid("S:" + pkey)

    def _start(self, ent, name, pkey):
        kind = ent["kind"]
        if kind == "auto" or (kind == "scene_ext" and ent.get("start_tpl")):
            sid = self.scene_fid(ent, pkey)
            if ent.get("start_tpl"):
                return [l.replace("{sid}", f"{sid:06X}") for l in ent["start_tpl"]]
            return [f"NHV_Util.FlowScene(0x{sid:06X})"]
        if kind in ("greet", "greeting", "fork"):
            lane = ent.get("lane", "Main")
            code = [f"NHV_Util.FlowSet(0x{self.gid('Cursor' + lane):06X}, {self.ordinal('entry', name)})"]
            for ln, nm in ent.get("also", []):   # further threads armed together with this entry
                code.append(f"NHV_Util.FlowSet(0x{self.gid('Cursor' + ln):06X}, {self.ordinal('entry', nm)})")
            return code
        return list(ent.get("start", []))

    def entry_start_code(self, nid):
        """Code that makes the entry `nid` happen (a chain ended in it)."""
        return self._start(self.s["entries"][nid], nid, f"R_{nid}_p0")

    def emit_chain(self, key, items, end, lane, mode, stage):
        """mode 'choice': returns dict(host, lines, code) for the answering INFO.
        mode 'entry': emits the first piece as an entry scene/greet; returns None."""
        inl = set(self.s.get("inline_stage", ()))
        if inl:
            # a stage change in front of a node of the same conversation takes effect at the end of the chain
            moved, kept = [], []
            for i, it in enumerate(items):
                if it[0] == "S" and i + 1 < len(items) and items[i + 1][0] == "N" and items[i + 1][1] in inl:
                    moved.append(it)
                else:
                    kept.append(it)
            items = kept + moved
        items = self.add_hooks(items)
        pieces = self.split_pieces(items, stage)
        final_boundary = None
        skip = set(self.s.get("world", {})) | set(self.s.get("speech", {}))
        if len(pieces) > 1 and not any(it[0] in ("L", "C") or (it[0] == "E" and it[1] not in skip)
                                       for it in pieces[-1]["items"]):
            pieces.pop()
            b = pieces[-1]["boundary"]
            final_boundary = self.stage_code(b[1]) if b[0] == "S" else list(b[1])
            pieces[-1]["boundary"] = None
        n = len(pieces)
        tails, starts = [None] * n, [None] * n
        for idx in range(n - 1, -1, -1):
            pc = pieces[idx]
            tail = self.piece_code(pc["items"])
            if idx == n - 1:
                tail += final_boundary or []
                tail += self.cursor_code(end, lane)
            else:
                b = pc["boundary"]
                tail += self.stage_code(b[1]) if b[0] == "S" else list(b[1])
                tail += starts[idx + 1] or []
            tails[idx] = tail
            ent = self.entry_of(pc)
            pc["entry"] = ent
            if idx > 0 or mode == "entry":
                if not ent:
                    raise FlowError(f"piece {idx} of {key} (first={pc['first']}, key={pc['key']}, "
                                    f"line={pc['firstline']}) needs an entry in the spec")
                starts[idx] = self._start(ent, ent["name"], f"{key}_p{idx}")
        result = None
        for idx, pc in enumerate(pieces):
            runs = self.runs(pc["items"])
            if idx == 0 and mode == "choice":
                if not runs:
                    # the player's line has no NPC answer: a silent INFO carries the state change
                    result = dict(host=None, lines=[], code=tails[0], goodbye=self.starts_scene(tails[0]))
                    continue
                first, rest = runs[0], runs[1:]
                if rest:
                    sid = self.scene_record(f"{key}_p0", rest, tails[0],
                                            self.domain_of([r["speaker"] for r in rest]))
                    lane0 = lane or "Main"
                    # a scene needs the dialogue closed: leave the menu and hide the choices until the scene ends
                    code = [f"NHV_Util.FlowSet(0x{self.gid('Cursor' + lane0):06X}, 0)", f"NHV_Util.FlowScene(0x{sid:06X})"]
                else:
                    code = tails[0]
                result = dict(host=first["speaker"], lines=first["lines"], code=code,
                              goodbye=self.starts_scene(code))
                continue
            self.emit_entry(key, idx, pc, runs, tails[idx], pc["entry"])
        return result

    def emit_entry(self, key, idx, pc, runs, tail, ent):
        kind = ent["kind"]
        if kind in ("none", "say", "ui"):
            return
        if not runs:
            raise FlowError(f"entry piece {key}_p{idx} has no NPC line")
        pkey = f"{key}_p{idx}"
        if ent.get("existing"):
            pkey = "X_" + ent["existing"]["eid"]   # shared scene: same ids however the chain got here
        if kind in ("auto", "scene_ext"):
            domain = ent.get("domain") or self.domain_of([r["speaker"] for r in runs])
            self.scene_record(pkey, runs, tail, domain, existing=ent.get("existing"),
                              sf_prefix=ent.get("sf_prefix", ()))
            return
        if kind in ("greet", "greeting"):
            self.emit_greet(pkey, ent, pc, runs, tail, greeting=(kind == "greeting"))
            return
        raise FlowError("unknown entry kind " + kind)

    def emit_greet(self, pkey, ent, pc, runs, tail, greeting=False):
        first, rest = runs[0], runs[1:]
        lane = ent.get("lane", "Main")
        ce = ent.get("cursor_entry", ent["name"])
        eord = [self.ordinal("entry", x) for x in ce] if isinstance(ce, (list, tuple)) else self.ordinal("entry", ce)
        host = first["speaker"]
        tfid, ifid = self.fid("T:" + pkey), self.fid("I:" + pkey)
        eid = f"{self.s['prefix']}_{pkey}"
        stage = pc["stage"]
        if rest:
            sid = self.scene_record(f"{pkey}_rest", rest, tail, self.domain_of([r["speaker"] for r in rest]))
            code = [f"NHV_Util.FlowSet(0x{self.gid('Cursor' + lane):06X}, 0)", f"NHV_Util.FlowScene(0x{sid:06X})"]
        else:
            code = tail
        d = TEXT / "DialogTopics" / f"{eid} - {tfid:06X}_{P}"
        if greeting:
            rec = [f"FormKey: {fk(tfid)}", f"EditorID: {eid}", "Priority: 80", f"Quest: {self.quest_key('Q')}",
                   "Category: Misc", "Subtype: Hello", "SubtypeName: HELO"]
        else:
            rec = [f"FormKey: {fk(tfid)}", f"EditorID: {eid}", "Priority: 60", f"Quest: {self.quest_key('Q')}",
                   "SubtypeName: CUST"]
        self.files[d / "RecordData.yaml"] = "\n".join(rec) + "\n"
        conds = [("stage", "==", stage), ("cursor", lane, eord), ("host", host)] + list(ent.get("extra_conds", []))
        if greeting:   # a Hello topic also plays as an ambient greeting: only when the player is talking to the NPC
            conds.append(("raw", cond("IsInDialogueWithPlayer", [], "==", 1)))
        o = self.make_info(eid, 1, ifid, first["lines"], conds, None, code, speaker=host, force_subtitle=True,
                           goodbye=self.starts_scene(code))
        self.files[d / "Responses" / f"{eid}_INFO01 - {ifid:06X}_{P}.yaml"] = "\n".join(o) + "\n"
        self.topics_made += 1
        if not greeting:
            self.greets.append(dict(node=ent["name"], topic=tfid, pkg=self.fid("K:" + pkey), pkey=pkey, host=host,
                                    stage=stage, ordinal=eord, lane=lane, alias=ent.get("alias"),
                                    pkg_conds=ent.get("pkg_conds", [])))

    def emit_roots(self):
        for nid, ent in self.s.get("entries", {}).items():
            if nid.startswith(("line:", "after:")) or ent["kind"] in ("ui", "fork"):
                continue
            n = self.N[nid]
            stage0 = self.s.get("root_from_stage", {}).get(nid, n["stage"])
            for k, v in enumerate(self.walk(nid, stage0, root=True), 1):
                variants = [([], v["items"])] if ent["kind"] in ("scene_ext", "auto") else self.expand_ifs(v["items"])
                for conds2, items2 in variants:
                    key = f"R_{nid}" if k == 1 else f"R_{nid}_v{k}"
                    if ent["kind"] == "say":
                        self.say_code[nid] = self.cursor_code(v["end"], None)
                        continue
                    self.emit_chain(key, items2, v["end"], None, "entry", stage0)

    # ------------------------------------------------------------------ hubs
    def hub_nodes(self):
        return [n for n in self.flow["nodes"] if self.hub_choices(n) and not n.get("obsolete")]

    def return_choices(self):
        """Choices without an NPC answer that lead straight back to a hub ('back'): they are not emitted; the
        target hub's choices stay visible while the cursor sits on the sub-hub instead. -> {hub: [sub hubs]}"""
        subs, skip = {}, set()
        for h in self.hub_nodes():
            for ci, c in enumerate(self.hub_choices(h), 1):
                t = self.N[c["to"]]
                if not t.get("lines") and self.hub_choices(t) and not t.get("when") and c["to"] != h["id"]                         and not t.get("effects"):
                    subs.setdefault(c["to"], []).append(h["id"])
                    skip.add((h["id"], ci))
        return subs, skip

    def default_host(self, h):
        """Who answers a silent choice of hub h: the spec's default or the first NPC speaker of the hub's choices."""
        d = self.s.get("default_host", {}).get(h["id"])
        if d:
            return d
        for c in self.hub_choices(h):
            for v in self.walk(c["to"], h["stage"]):
                for it in v["items"]:
                    if it[0] == "L":
                        return self.speaker(it[1])
        return self.s["fallback_host"]

    def emit_hubs(self):
        subs, skip = {}, set()   # silent INFOs replace the old "drop the back-choice" scheme
        for h in self.hub_nodes():
            hid = h["id"]
            lane = self.lane_of(hid)
            ho = self.ordinal("hub", hid)
            ho_all = [ho] + [self.ordinal("hub", sh) for sh in subs.get(hid, [])]
            self.visited.add(hid)
            for ci, c in enumerate(self.hub_choices(h), 1):
                if (hid, ci) in skip:
                    self.notes.append(f"dropped back-choice {hid}/{ci}: {c['line']}")
                    continue
                tkey = f"{hid}_{ci}"
                tfid = self.fid("T:" + tkey)
                bfid = self.fid("B:" + tkey)
                eid = f"{self.s['prefix']}_{tkey}"
                d = TEXT / "DialogTopics" / f"{eid} - {tfid:06X}_{P}"
                self.files[d / "RecordData.yaml"] = "\n".join(
                    [f"FormKey: {fk(tfid)}", f"EditorID: {eid}", "Priority: 60", f"Branch: {fk(bfid)}",
                     f"Quest: {self.s['qkey']}", "SubtypeName: CUST"]) + "\n"
                self.put("DialogBranches", eid + "_Branch", bfid,
                         [f"FormKey: {fk(bfid)}", f"EditorID: {eid}_Branch", f"Quest: {self.s['qkey']}",
                          "Category: Player", "Flags:", "- TopLevel", f"StartingTopic: {fk(tfid)}"])
                self.topics_made += 1
                variants = []
                for v in self.walk(c["to"], h["stage"]):
                    for conds2, items2 in self.expand_ifs(v["items"]):
                        variants.append((v["conds"] + conds2, items2, v["end"]))
                prev, k = None, 0
                for vconds, vitems, vend in variants:
                    k += 1
                    ch = self.emit_chain(f"{tkey}_v{k}", vitems, vend, lane, "choice", h["stage"])
                    ifid = self.fid(f"I:{tkey}:{k}")
                    host = ch["host"] or self.default_host(h)
                    conds = [("stage", "==", h["stage"]), ("cursor", lane, ho_all), ("host", host)]
                    for src in (h.get("requires", {}), c.get("requires", {})):
                        for rk, rv in src.items():
                            conds.append(("state", rk, rv))
                    conds += vconds
                    o = self.make_info(eid, k, ifid, ch["lines"], conds, c["line"] if k == 1 else c["line"],
                                       ch["code"], prev=prev, goodbye=ch.get("goodbye", False))
                    self.files[d / "Responses" / f"{eid}_INFO{k:02d} - {ifid:06X}_{P}.yaml"] = "\n".join(o) + "\n"
                    prev = ifid

    # ------------------------------------------------------------------ globals / output
    def emit_globals(self):
        names = ["Cursor" + lane for lane in sorted(set(list(self.s.get("lanes", {}).values()) + ["Main"]))]
        names += self.state_keys()
        for k in names:
            gid = self.gid(k)
            self.put("Globals", self.gname(k), gid, ["MutagenObjectType: GlobalShort", f"FormKey: {fk(gid)}",
                                                     f"EditorID: {self.gname(k)}", "Data: 0"])
        self.global_names = names

    def clean_range(self):
        pat = re.compile(r" - ([0-9A-F]{6})_NightsHarvest\.esp")
        for p in list(TEXT.rglob("*")):
            m = pat.search(str(p))
            if p.is_file() and m and self.lo <= int(m.group(1), 16) <= self.hi:
                p.unlink()
        for d in sorted((x for x in TEXT.rglob("*") if x.is_dir()), key=lambda x: len(x.parts), reverse=True):
            if not any(d.iterdir()):
                d.rmdir()   # topic folders left empty would break Spriggit (no RecordData.yaml)
        for p in SCRIPTS.glob("*.psc"):
            m = re.match(r"(?:TIF_|SF_).*_?02([0-9A-F]{6})\.psc$", p.name)
            if m and self.lo <= int(m.group(1), 16) <= self.hi:
                p.unlink()

    def write_all(self):
        self.clean_range()
        for path, text in self.files.items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8", newline="\n")
        for name, text in self.scripts.items():
            (SCRIPTS / f"{name}.psc").write_text(text, encoding="utf-8", newline="")
        self.save_ids()
