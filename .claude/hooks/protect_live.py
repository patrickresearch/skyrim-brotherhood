#!/usr/bin/env python3
"""PreToolUse hook: protects the live Skyrim installation, Vortex and the backups.

Reads the hook payload (JSON) from stdin and answers with a permission decision:
  deny        writes to the live game, its settings/saves/load order or Vortex
  ask         copy-like commands that mention those paths, any write command that
              mentions the backups, edits of this hook or of the Claude Code settings
  no output   everything else, including plain reads

Paths are matched after normalisation (case, slashes, %VAR%, $env:VAR, ~, 8.3 names).
This is a safety net against mistakes, not a security boundary: variables built at
run time or paths assembled from parts are not resolved.

Self-test:  python .claude/hooks/protect_live.py --selftest
"""

import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DEVENV = r"C:\Dev\brotherhood-devenv"  # dev copy of the game, MO2 and the backups
PROFILE = os.environ.get("USERPROFILE", "")
LOCAL = os.environ.get("LOCALAPPDATA", "")
ROAMING = os.environ.get("APPDATA", "")

ENV_TOKENS = {"localappdata": LOCAL, "appdata": ROAMING, "userprofile": PROFILE, "home": PROFILE}
ALIASES_83 = {
    "vaness~1": "vanessa bubu schmidt",
    "progra~2": "program files (x86)",
    "progra~1": "program files",
}

DESTRUCTIVE = re.compile(
    r"(?<![\w/.-])(remove-item|rm|del|erase|rmdir|rd|ri|move-item|mv|mi|move|rename-item|ren|rni"
    r"|set-content|sc|add-content|ac|clear-content|out-file|set-itemproperty|remove-itemproperty"
    r"|set-acl|attrib|icacls|takeown|cacls|truncate|shred|sed\s+-i"
    r"|robocopy[^|;\n]*\s/(?:mir|purge|mov|move)\b)(?![\w-])"
)
COPYISH = re.compile(
    r"(?<![\w/.-])(copy-item|ci|cp|copy|xcopy|robocopy|new-item|ni|mkdir|md|touch|install"
    r"|7z|7za|tar|expand-archive|unzip|mklink|ln|invoke-webrequest|iwr|curl|wget"
    r"|start-bitstransfer|tee|tee-object|dd|chmod|chown|write_text|write_bytes|shutil"
    r"|os\.(?:remove|rename|replace|makedirs|unlink)|rmtree|copyfile|copytree"
    r"|open\([^)]*['\"][wax])(?![\w-])"
)


def norm(text):
    t = text.lower().replace("\\", "/")
    t = re.sub(r"/{2,}", "/", t)
    return re.sub(r"(?<![a-z0-9:])/([a-z])/", r"\1:/", t)


def expand(text):
    t = text.lower()
    for name, value in ENV_TOKENS.items():
        if not value:
            continue
        for form in ("${env:%s}" % name, "$env:%s" % name, "%%%s%%" % name, "${%s}" % name, "$%s" % name):
            t = t.replace(form, value.lower())
    if PROFILE:
        home = PROFILE.lower()
        t = re.sub(r"(?<![\w~])~(?=[/\\])", lambda _m: home, t)
    for short, long_name in ALIASES_83.items():
        t = t.replace(short, long_name)
    return norm(t)


def root(path):
    return norm(path).rstrip("/")


def build_roots():
    live = [("das Live-Spiel", root(r"C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition")),
            ("Vortex", root(r"C:\Program Files\Black Tree Gaming Ltd\Vortex"))]
    if PROFILE:
        live.append(("die Live-Einstellungen und Saves",
                     root(os.path.join(PROFILE, "Documents", "My Games", "Skyrim Special Edition"))))
    if LOCAL:
        live.append(("die Live-Load-Order", root(os.path.join(LOCAL, "Skyrim Special Edition"))))
    if ROAMING:
        live.append(("Vortex", root(os.path.join(ROAMING, "Vortex"))))
    backup = [("die Backups", root(os.path.join(DEVENV, "backups")))]
    return live, backup


LIVE, BACKUP = build_roots()
OWN_FILES = [root(os.path.join(REPO, ".claude", "hooks"))]


def under(path, base):
    return path == base or path.startswith(base + "/")


def mentions(text, base):
    start = 0
    while True:
        i = text.find(base, start)
        if i < 0:
            return False
        j = i + len(base)
        if j >= len(text) or not (text[j].isalnum() or text[j] in "_-."):
            return True
        start = i + 1


def file_decision(path):
    p = expand(path)
    for name, base in LIVE:
        if under(p, base):
            return "deny", "Schreibschutz: %s darf nicht verändert werden. Entwickelt wird im Repo und in der Dev-Kopie (docs/ENVIRONMENT.md)." % name
    for name, base in BACKUP:
        if under(p, base):
            return "deny", "Schreibschutz: %s sind unveränderlich. Neue Backups legt der Entwickler an oder gibt sie im Einzelfall frei." % name
    if any(under(p, b) for b in OWN_FILES) or re.search(r"/\.claude/settings(\.local)?\.json$", p):
        return "ask", "Der Schreibschutz-Hook oder die Claude-Code-Einstellungen sollen geändert werden. Bitte bestätigen."
    return None


def shell_decision(command):
    t = expand(command)
    live_hits = [(n, b) for n, b in LIVE if mentions(t, b)]
    backup_hits = [(n, b) for n, b in BACKUP if mentions(t, b)]
    destructive = bool(DESTRUCTIVE.search(t))
    copyish = bool(COPYISH.search(t))
    if live_hits:
        names = ", ".join(sorted({n for n, _ in live_hits}))
        redirect = any(re.search(r">{1,2}\s*[\"']?" + re.escape(b), t) for _, b in live_hits)
        if destructive or redirect:
            return "deny", "Schreibschutz: Der Befehl nennt %s und enthält einen schreibenden oder löschenden Aufruf. Live-Spiel und Vortex bleiben unangetastet." % names
        if copyish:
            return "ask", "Der Befehl nennt %s und kopiert oder entpackt Dateien. Bitte prüfen, dass das Live-Spiel nur Quelle ist, nie Ziel." % names
    if backup_hits and (destructive or copyish or re.search(r">{1,2}\s*[\"']?" + re.escape(backup_hits[0][1]), t)):
        return "ask", "Der Befehl schreibt in oder verändert die Backups. Bitte bestätigen."
    return None


def mcp_decision(tool, tin):
    """MCP servers run outside this hook, so only their arguments can be checked: any argument
    that names the live game, its settings or Vortex is denied, the backups need a confirmation."""
    text = expand(json.dumps(tin, ensure_ascii=False))
    live_hits = sorted({n for n, b in LIVE if mentions(text, b)})
    if live_hits:
        return "deny", "Schreibschutz: Der MCP-Aufruf %s nennt %s. Live-Spiel und Vortex bleiben unangetastet." % (tool, ", ".join(live_hits))
    if any(mentions(text, b) for _, b in BACKUP):
        return "ask", "Der MCP-Aufruf %s nennt die Backups. Bitte bestätigen." % tool
    return None


def decide(payload):
    tool = payload.get("tool_name", "")
    tin = payload.get("tool_input", {}) or {}
    if tool in ("Edit", "Write", "NotebookEdit", "MultiEdit"):
        return file_decision(tin.get("file_path") or tin.get("notebook_path") or "")
    if tool in ("Bash", "PowerShell"):
        return shell_decision(tin.get("command", ""))
    if tool.startswith("mcp__"):
        return mcp_decision(tool, tin)
    return None


def selftest():
    game = r"C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition"
    dev = DEVENV
    cases = [
        ("Edit live ini", {"tool_name": "Edit", "tool_input": {"file_path": game + r"\Data\x.esp"}}, "deny"),
        ("Write Vortex", {"tool_name": "Write", "tool_input": {"file_path": ROAMING + r"\Vortex\state.v2\x"}}, "deny"),
        ("Write live Documents", {"tool_name": "Write", "tool_input": {"file_path": PROFILE + r"\Documents\My Games\Skyrim Special Edition\Skyrim.ini"}}, "deny"),
        ("Write backup", {"tool_name": "Write", "tool_input": {"file_path": dev + r"\backups\a\b.txt"}}, "deny"),
        ("Edit repo doc", {"tool_name": "Edit", "tool_input": {"file_path": REPO + r"\docs\GOAL.md"}}, None),
        ("Write dev copy", {"tool_name": "Write", "tool_input": {"file_path": dev + r"\SkyrimSE-Dev\x.txt"}}, None),
        ("Edit hook", {"tool_name": "Edit", "tool_input": {"file_path": REPO + r"\.claude\hooks\protect_live.py"}}, "ask"),
        ("Edit settings", {"tool_name": "Edit", "tool_input": {"file_path": REPO + r"\.claude\settings.json"}}, "ask"),
        ("Read-only listing", {"tool_name": "PowerShell", "tool_input": {"command": "Get-ChildItem '%s\\Data' | Select-Object -First 3" % game}}, None),
        ("Read plugins.txt via env", {"tool_name": "PowerShell", "tool_input": {"command": "Get-Content \"$env:LOCALAPPDATA\\Skyrim Special Edition\\plugins.txt\""}}, None),
        ("Remove live file", {"tool_name": "PowerShell", "tool_input": {"command": "Remove-Item '%s\\Data\\x.esp'" % game}}, "deny"),
        ("Set-Content via env", {"tool_name": "PowerShell", "tool_input": {"command": "Set-Content -Path \"$env:APPDATA\\Vortex\\startup.json\" -Value x"}}, "deny"),
        ("bash rm forward slashes", {"tool_name": "Bash", "tool_input": {"command": "rm -f '/c/Program Files (x86)/Steam/steamapps/common/Skyrim Special Edition/Data/x.esp'"}}, "deny"),
        ("redirect into live ini", {"tool_name": "Bash", "tool_input": {"command": "echo x > \"$USERPROFILE/Documents/My Games/Skyrim Special Edition/Skyrim.ini\""}}, "deny"),
        ("robocopy from live to dev", {"tool_name": "PowerShell", "tool_input": {"command": "robocopy '%s\\Data' '%s\\SkyrimSE-Dev\\Data' Skyrim.esm" % (game, dev)}}, "ask"),
        ("7z extract into live", {"tool_name": "PowerShell", "tool_input": {"command": "& 7z x a.zip -o'%s'" % game}}, "ask"),
        ("backup write", {"tool_name": "PowerShell", "tool_input": {"command": "Set-Content '%s\\backups\\x\\MANIFEST.sha256' a" % dev}}, "ask"),
        ("backup read", {"tool_name": "PowerShell", "tool_input": {"command": "Get-Content '%s\\backups\\x\\MANIFEST.sha256'" % dev}}, None),
        ("unrelated delete in dev copy", {"tool_name": "PowerShell", "tool_input": {"command": "Remove-Item '%s\\SkyrimSE-Dev\\x.txt'" % dev}}, None),
        ("git status", {"tool_name": "Bash", "tool_input": {"command": "git status --short"}}, None),
        ("MCP mit Live-Pfad", {"tool_name": "mcp__housecarl__set_mo2_instance", "tool_input": {"path": game}}, "deny"),
        ("MCP mit Live-Documents", {"tool_name": "mcp__housecarl__apply", "tool_input": {"file": PROFILE + r"\Documents\My Games\Skyrim Special Edition\Skyrim.ini"}}, "deny"),
        ("MCP mit Backup-Pfad", {"tool_name": "mcp__housecarl__apply", "tool_input": {"file": dev + r"\backups\x"}}, "ask"),
        ("MCP mit Dev-Pfad", {"tool_name": "mcp__housecarl__load_order_status", "tool_input": {"instance": dev + r"\MO2"}}, None),
        ("MCP ohne Pfad", {"tool_name": "mcp__housecarl__records", "tool_input": {"plugin": "NightsHarvest.esp", "type": "Quest"}}, None),
    ]
    failed = 0
    for name, payload, expected in cases:
        result = decide(payload)
        got = result[0] if result else None
        ok = got == expected
        failed += 0 if ok else 1
        print("%-4s %-30s erwartet=%-5s erhalten=%s" % ("ok" if ok else "FAIL", name, expected, got))
    print("%d von %d Fällen bestanden" % (len(cases) - failed, len(cases)))
    return 1 if failed else 0


def main():
    if "--selftest" in sys.argv:
        return selftest()
    try:
        raw = sys.stdin.buffer.read().decode("utf-8", "replace")
        result = decide(json.loads(raw))
    except Exception as exc:  # fail open, but say so
        sys.stderr.write("protect_live.py: %s\n" % exc)
        return 0
    if result:
        decision, reason = result
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse",
                                                 "permissionDecision": decision,
                                                 "permissionDecisionReason": reason}}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
