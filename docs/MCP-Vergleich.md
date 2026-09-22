# MCP-Server und Werkzeuge für das ESP: Vergleich

Stand: 22.09.2026, zu E17. Ergänzt `docs/TOOLING.md`, Abschnitt 4.

**Methode:** GitHub-API (Metadaten, Dateilisten, Releases), READMEs und der Quelltext der Kandidaten. Nichts wurde geklont, gebaut oder ausgeführt. Für `SehtMCP` (18 Dateien, 168 KB) und `houseCARL` (190 Dateien, 4,3 MB) habe ich den C#-Quelltext nach Prozessstarts, Netzwerk, Löschen, Registry, nativem Interop und Zugriffen auf Nutzerordner durchsucht und die Treffer gelesen. Das ist ein Musterscan und kein Audit. Was die Autoren über Funktionen schreiben, habe ich nicht nachgeprüft.

## Ergebnis in einer Tabelle

| Kandidat | Was es wirklich ist | Reife | Lizenz | Schreibt ESP | Einschätzung |
|---|---|---|---|---|---|
| **Spriggit** (Mutagen-Projekt) | CLI: ESP ↔ YAML | 130 Sterne, aktiv (Push 10.07.2026), von uns getestet | GPL-3.0 | ja, per Text | Basis, bleibt |
| **houseCARL** (Avick3110) | MCP-Server, 31 Tools, Mutagen 0.54.4 | 22 Releases (v2.0.2 vom 15.09.), 34 Sterne, ca. 2.900 Commits seit 04.06.2026 | GPL-3.0 | ja: neues Patch-Plugin, „Extend“, „In-Place“ | **eingerichtet, Pilot bestanden (22.09.)** |
| **SehtMCP** (tel-0s) | MCP-Server, 52 Tools, Mutagen 0.54.4 | erstellt 19.09.2026, 4 Commits, 0 Sterne, keine Releases | GPL-3.0 | ja, mit Staging und Backup | später für Navmesh prüfen |
| **SkyrimCK-MCP** (Pyrhame) | **kein MCP-Server**, sondern ein Einzelprogramm für ein anderes Mod | 1 Commit, 13 Sterne | GitHub erkennt keine Lizenz (README nennt MIT) | nur dieses eine ESP | ausschließen |
| **creation-kit-mcp-v2** (nawnie) | Python-Projekt mit eingecheckten Binärdateien, für Codex gedacht | 1 Commit, 177 MB | unklar | behauptet ja | ausschließen (nicht prüfbar) |
| **Claude Code Modding Toolkit** (Nexus 176043, GitHub `WingedGuardian`) | Skills, Wissensbasis, Sicherheits-Hooks, Node/Python-Werkzeuge; kein MCP-Server | 15 Sterne | MIT | ja, für gezielte Edits | Ideengeber, nicht nötig |
| **xEdit-Automation-Skill** (BB-84C) | „geforkter xEdit-Daemon“ als Skill | Quelle und Lizenz nicht ermittelbar | unbekannt | ja | nicht bewertbar |
| **SkyLink AI / SkryimMCM** | SKSE-Plugin plus MCP für den **laufenden** Spielzustand | 0–9 Sterne | unklar | nein | nur Testhilfe, später |
| **SkyrimNet** | KI-NPC-Mod, MCP nur zum Abfragen | 323 Sterne | – | nein | anderer Zweck |
| **vortex-skyrimse-mcp** | Diagnose von Vortex-Profilen | 1 Stern | MIT | nein | ausschließen (Vortex tabu) |

## Kandidaten im Einzelnen

### houseCARL
- **Umfang:** 31 Tools für Records (lesen, prüfen, ändern, anlegen, entfernen, kopieren, ESL-Kompaktierung, Merge), Papyrus (kompilieren, dekompilieren), BSA, NIF, SkyPatcher, SKSE-Reader und Nexus-Abfragen. Kennt 133 Record-Typen. Enthält Validierung von Dialogen und FaceGen.
- **Schreiben:** Standard ist ein neues Plugin in einem **neuen MO2-Mod-Ordner**, das nicht aktiv ist, bevor du es in MO2 aktivierst. Daneben „Extend“ und „In-Place“; In-Place überschreibt ein benanntes Plugin, verlangt beim ersten Mal eine ausdrückliche Bestätigung und legt **keine Backups** an.
- **Sicherheitsmechanik laut README:** Prüfung vor dem Schreiben (Typen, Feldpfade, Enums, FormLinks), Trockenlauf, Rücklesen der geschriebenen Felder, Erkennung von Änderungen auf der Platte.
- **Quelltext-Scan:** keine Registry-Zugriffe, kein natives Interop. Prozesse nur für ein BSA-Werkzeug und den Papyrus-Compiler, im Setup für `dotnet --list-runtimes`. Netzwerk nur im Nexus-Client (`api.nexusmods.com`), nach Beschreibung nur lesend, ein API-Schlüssel kommt im Code nicht vor. Löschen nur bei temporären Dateien (Stichprobe der ersten Treffer). Zugriff auf `Documents\My Games\Skyrim Special Edition` nur lesend für Papyrus- und Crash-Logs.
- **Installation:** `houseCARL-2.0.2.zip` (13,1 MB, 73 Downloads) mit `houseCARL-Setup.exe`. Der Setup-Assistent schreibt in die **Nutzerkonfiguration** (`~/.claude.json`) und installiert Skills nach `~/.claude/skills`. Voraussetzung: .NET Runtime 9 **und** ASP.NET Core Runtime 9 (bei uns sind Runtime 6 und SDK 10 installiert), MO2-Profil, Claude Code ab 2.1.143. Alternativ Bau aus dem Quelltext (.NET 9 SDK, `scripts/build-plugin.ps1`).
- **Beobachtungen:** Sehr aktive Entwicklung, stark KI-gestützt (`CLAUDE.md`, `AGENTS.md`, 227 Dateien unter `.claude/skills`, ein Commit von „claude“). Zwei Konten zusammen ca. 2.900 Commits, eines davon anonymisiert. 41 offene Issues und PRs.
- **Grenzen laut Doku:** Plugin-Identität (FormKey, ModKey, Master) nicht schreibbar, keine xEdit- oder CK-Anbindung, nur was Mutagen modelliert.
- **Passung zu uns:** Braucht ein MO2-Profil, und das haben wir (`C:\Dev\brotherhood-devenv\MO2`). Dialogvalidierung ist für die geplanten rund 2.200 Zeilen nützlich. Unklar ist, ob sich ein komplett neues Plugin mit unseren zwei Mastern sauber anlegen lässt, weil die Master als „nicht schreibbar“ gelten.

### SehtMCP
- **Umfang:** 52 Tools: Plugins (ESP, ESM, ESL), generische Record-Bearbeitung mit Schema-Erkennung, Transaktionen mit Checkpoints, Zellen und Platzierung, **Navmesh-Erzeugung** für neue Innenzellen mit Türverknüpfung, NIF- und BSA-Werkzeuge, Papyrus-Compiler, ZIP-Paket.
- **Qualität der Umsetzung:** Schreibzugriffe nur im konfigurierten Workspace (Pfadprüfung gegen Ausbrechen), Speichern über Staging-Datei mit **binärem Rücklesen**, dann atomarer Austausch mit Backup, Erkennung externer Änderungen, feste NuGet-Versionen mit Lock-Datei. Kein Netzwerkzugriff im Quelltext. Prozessstarts nur für CK, NifSkope und den Papyrus-Compiler (Pfade aus der Konfiguration).
- **Ehrliche Grenzen laut Autor:** Nie im CK, in xEdit oder im Spiel geladen. Quests: Stages, Ziele, Bedingungen und Script-Anhänge, aber keine Fragment-Generierung. Kein FaceGen, keine Lip-Dateien, kein Navmesh über Zellgrenzen. Lokalisierte Plugins nur lesbar.
- **Risiko:** Drei Tage alt, alle Versionen 0.1 bis 0.3 am selben Tag, ein Autor, keine Releases. Bau aus dem Quelltext nötig (.NET 10 SDK haben wir).
- **Passung zu uns:** Das Navmesh für das Deep Sanctuary (M1.3, 11 Räume) wäre der einzige echte Mehrwert gegenüber houseCARL. Bis er in einem echten CK-Test bestanden hat, ist das nicht verlässlich.

### SkyrimCK-MCP
- README und Gemini beschreiben einen Server, der Quests, Packages, Scenes und Sounds baut. Im Repository liegt aber nur `src/Program.cs` (2.481 Zeilen, französische Kommentare): ein Konsolenprogramm, das **ein bestimmtes ESP** („AutoWalk“ für SkyrimNVDA) aufbaut. Es enthält weder MCP-Protokoll noch Werkzeugdefinitionen. Das eigene `CLAUDE.md` nennt den Server als geplant („Phase 2“).
- Abhängig von zwei unveränderten Klonen von `esper` und `balsa` (Lizenz laut eigener Notiz „zu prüfen“), .NET 8 SDK. Nicht empfohlen.

### creation-kit-mcp-v2
- 1 Commit, 177 MB, darin 190 DLLs, 31 EXEs und 50 `.pyd`-Dateien sowie mitgelieferte Bibliotheken. Für Codex gedacht. Die README räumt selbst ein, dass Quest-Aliase und Scripts bei Starfield ungetestet sind. Eingecheckte Binärdateien lassen sich nicht sinnvoll prüfen. Nicht empfohlen.

### Toolkit von Nexus (176043) und Gemini-Hinweis
- Der von Gemini genannte „Skyrim-Claude Code Modder's Toolkit“ ist ein Paket aus Skills, Wissensbasis (über 1.300 Zeilen), Sicherheits-Hooks und Hilfswerkzeugen (Node-Wrapper für `XEditLib.dll`, Spriggit, PyNifly). Es ist **kein** MCP-Server. Nach eigener Aussage kann es komplexe Quest-Dialogketten oder Multi-Actor-Packages nicht zuverlässig aus dem Nichts bauen. Die Hooks (Löschschutz, Backups) sind eine Anregung für unseren eigenen Hook.
- Der Absatz zum „Skyrim Creation Kit MCP Server“ und zur Bibliothek `esper` bezieht sich auf SkyrimCK-MCP (siehe oben), nicht auf das Toolkit.

## Einrichtung und Pilot (22.09.2026, mit Freigabe)

**Download und Prüfung:** `houseCARL-2.0.2.zip` (13,07 MB) von der GitHub-Release-Seite geladen. SHA-256 lokal `dcb3…c4b19`, identisch mit dem von GitHub gemeldeten Digest. Inhalt vor dem Entpacken über `7z l` gesichtet: 293 Dateien, 50,9 MB entpackt, nur zwei ausführbare Dateien (`houseCARL-Setup.exe`, `server/housecarl-mcp.exe`), beide unsigniert (`NotSigned`, wie bei den meisten kleinen Community-Tools).

**Installation ohne Setup-Assistenten**, damit `~/.claude.json` und `~/.claude/skills` unberührt bleiben (README, Abschnitt „By hand“, nachvollzogen):
- `housecarl/` (Server, Skills, `.claude-plugin/`) nach `C:\Dev\brotherhood-devenv\tools\houseCARL` kopiert, nicht nach `~/.claude/skills`.
- Server projektweit über `.mcp.json` im Repo registriert (`type: stdio`, `command` zeigt auf `server\housecarl-mcp.exe`), statt in eine globale Nutzerkonfiguration einzutragen. `env` setzt `HouseCarl__Mo2InstanceDir` auf unsere Dev-MO2-Instanz und `HOUSECARL_DATA_DIR` auf `tools\houseCARL-data`.
- Laufzeiten: `Microsoft.DotNet.Runtime.9` und `Microsoft.DotNet.AspNetCore.9` (beide 9.0.20) per `winget` installiert. Beide Installationen brauchten eine UAC-Bestätigung; der erste Versuch blieb ohne Rückmeldung des Entwicklers über eine Stunde an der Zustimmung hängen und wurde abgebrochen, der zweite lief nach seiner Bestätigung durch.
- **Hook erweitert:** `.claude/hooks/protect_live.py` prüft jetzt auch `mcp__*`-Aufrufe (Argumente auf Live-Pfade durchsucht) und `.claude/settings.json` matcht den Hook zusätzlich auf `mcp__.*`. Selbsttest: 25 von 25 Fällen, davon 5 neu für MCP.

**Pilot:** Server über ein eigenes Test-Skript gestartet (ein minimaler MCP-Stdio-Client, nur für diesen Test, nicht Teil des Repos), `housecarl_load_order_status` gegen unsere Dev-MO2-Instanz aufgerufen (7 Plugins, davon 2 implizite Master, passt zu Vanilla + USSEP + SkyUI + 2 Master), danach mit `housecarl_create` eine Quest `NHVPilot_Sys_Core` (Start Game Enabled, Script `NHV_CoreScript`, Property auf einen neu angelegten Global) in ein neues Wegwerf-Plugin `NHVPilot.esp` geschrieben. houseCARL legt das automatisch in einen eigenen, in MO2 noch nicht aktivierten Mod-Ordner (`houseCARL - NHVPilot`). Über Spriggit zurückgelesen: strukturell identisch mit unserem eigenen, per Spriggit erzeugten `NHV_Sys_Core` (gleicher Aufbau von `VirtualMachineAdapter.Scripts`, `Properties`, `Flags`), Unterschied nur `NextAliasID: 0` statt `1` (Standardwert bei einer Quest ohne Alias, unbedenklich). Der Pilot-Mod-Ordner wurde danach gelöscht.
- **Erster Start ohne Laufzeit-Trick bestätigt:** Ein zweiter Lauf ohne `DOTNET_ROLL_FORWARD` (also genau der Weg, den `.mcp.json` nimmt) initialisiert den Server korrekt und listet alle 31 Tools.
- **Live-Spiel nach jedem Schritt geprüft** (`tools\verify_live_untouched.ps1`): 19 von 19 gesicherten Dateien identisch, 0 neue Einträge, Saves unverändert. `Data\NightsHarvest.esp` im Repo hat vorher und nachher denselben Hash.

**Offen:**
- Nexus-Werkzeuge (`housecarl_nexus_*`) sind read-only laut Doku und Quelltext, aber im Pilot nicht aufgerufen.
- `housecarl_check` (Validierungs-Sweep für Dialog, Scripts, FaceGen) noch nicht getestet.
- Noch keine echte Night's-Harvest-Arbeit über houseCARL, nur der Wegwerf-Pilot.
- Ob sich unser eigentliches `NightsHarvest.esp` mit `into=` erweitern lässt (statt eines neuen Patches), ist ungetestet.

## Empfehlung

1. **Spriggit bleibt die Basis.** Es ist bewiesen, diff-bar in Git und Teil derselben Mutagen-Familie. Alles, was ein MCP-Server schreibt, exportieren wir danach mit `tools\plugin_text.ps1 -Direction ToText` zurück in den Text.
2. **houseCARL als Beschleuniger einführen, unter Auflagen:**
   - Download von `houseCARL-2.0.2.zip` nur mit deiner ausdrücklichen Freigabe; ich liste und prüfe den Inhalt (Dateien, Hashes, Signatur), **bevor** etwas läuft.
   - **Kein** `houseCARL-Setup.exe`, damit `~/.claude.json` und `~/.claude/skills` unberührt bleiben. Stattdessen den Server entpacken nach `C:\Dev\brotherhood-devenv\tools\houseCARL` und projektweit über `.mcp.json` registrieren.
   - .NET Runtime 9 und ASP.NET Core 9 installieren (winget).
   - **Hook erweitern:** Der Schreibschutz-Hook prüft heute nur Edit, Write, Bash und PowerShell. MCP-Aufrufe (`mcp__…`) würden an ihm vorbei laufen. Vor dem ersten Einsatz erhält er eine Prüfung der Tool-Argumente auf geschützte Pfade.
   - **Vor jeder Sitzung committen**, weil In-Place keine Backups anlegt.
   - **Pilot** an einem Wegwerf-Plugin, dann Vergleich mit unserem Spriggit-ESP, dann erst `NightsHarvest.esp`. Dabei klären, ob sich ein neues Plugin mit den Mastern `Skyrim.esm` und `Update.esm` anlegen lässt.
3. **SehtMCP zurückstellen** bis M1.3 und nur für Navmesh betrachten, wenn es dann in einem echten CK-Test bestanden hat.
4. **Ausschließen:** SkyrimCK-MCP, creation-kit-mcp-v2, vortex-skyrimse-mcp. **Später vielleicht:** SkyLink AI als Testhilfe.
5. **Ohnehin selbst bauen:** ein Generator von `dialogue/*.csv` nach Spriggit-YAML (Dialoge, ca. 2.200 Zeilen) und ein Linkprüfer, der FormKeys gegen die Master abgleicht. Beides braucht keinen fremden Server und macht uns von der Reife der MCP-Projekte unabhängig.

## Offen und ungeprüft

- Kein Kandidat wurde von mir gebaut oder gestartet. Aussagen zu Funktionen stammen aus README, Dokumentation und Quelltext, nicht aus eigenen Tests.
- Bei houseCARL habe ich nur Muster im Quelltext gesucht. Nicht geprüft: die 27 Löschstellen vollständig, das Verhalten des Setup-Programms, der Inhalt der Release-ZIP gegenüber dem Quelltext.
- Ob sich die Nexus-Werkzeuge von houseCARL abschalten lassen, habe ich nicht gefunden. Sie arbeiten nach Beschreibung nur lesend.
- Ob ein von einem MCP-Server erzeugtes ESP im CK lädt, ist bei keinem Kandidaten nachgewiesen, auch nicht bei unserem eigenen (bisher nur Mutagen-Rückprobe).
