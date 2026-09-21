# Werkzeuge & Voraussetzungen – Night's Harvest

Stand: 22.09.2026. Was für die Entwicklung gebraucht wird, was schon da ist und was fehlt. Lokale Pfade und Versionen stehen in `docs/ENVIRONMENT.md`. Die Angaben zu den MCP-Servern stammen aus deren GitHub-Beschreibungen; ich habe keinen davon getestet.

## 1. Bereits vorhanden

| Was | Stand |
|---|---|
| Skyrim AE | 1.6.1170, Steam |
| SKSE64 | Loader 0.2.2.8, DLLs für 1.6.1170 und 1.5.97 |
| Creation Kit | 1.7.99.0 |
| Bethesda Papyrus-Compiler | `Papyrus Compiler\PapyrusCompiler.exe` |
| Archive.exe (BSA packen) | `Tools\Archive` im Spielordner |
| Vanilla- und SKSE-Script-Quellen | `Data\Source\Scripts`, `Data\Scripts\Source` |
| Git 2.55, Python 3.14.7, VS Code | installiert |
| USSEP, SkyUI (Spiel) | im Data-Ordner |

## 2. Muss installiert oder beschafft werden

**Stand 22.09.:** Installiert sind `gh` (noch nicht angemeldet), LOOT, .NET SDK 10, 7-Zip und die Papyrus-Extension. SSEEdit, Spriggit und Pyro sind nach `.tools/` entpackt. Dev-Kopie, Backups (inkl. Saves), Schreibschutz und die MO2-Testumgebung stehen (Abschnitt 5), CKPE liegt in der Dev-Kopie. Offen: SkyUI SDK, Ingame-Test über MO2, Skyrim 1.5.97, Fuz Ro D-oh, Test-Saves.

| Was | Wofür | Paket |
|---|---|---|
| GitHub CLI (`gh`) und privates Repo | Push, Labels, Board | M0.4 |
| Vortex-Profile Clean, Heavy, Legacy, Voice | Testumgebungen; der Data-Ordner ist jetzt ein stark gemodetes Deployment | M0.1 |
| CKPE (Creation Kit Platform Extended) | CK-Abstürze und Limits; Version zur CK-Version 1.7.99 prüfen | M0.2 |
| VS-Code-Extension „Papyrus“ | Syntax, Go-to-Definition | M0.3 |
| [Pyro](https://github.com/fireundubh/pyro) | Build: kompilieren, BSA packen, Archiv. Fertige `.exe`, braucht kein Python. Letzter Release Juli 2022 | M0.3 |
| SkyUI SDK (Quellen, separater Nexus-Download) | `SKI_ConfigBase.psc` fehlt, ohne sie lässt sich das MCM nicht kompilieren | vor M1.1 |
| [Spriggit CLI](https://github.com/Mutagen-Modding/Spriggit) | ESP ↔ Text (`plugin-text/`) | M0.5 |
| SSEEdit (xEdit) | Konflikte, ITM/UDR, Record-Inventur | M0.5 |
| LOOT | Load Order | M0.5 |
| 7-Zip | Release-Archiv | M6 |
| Skyrim SE 1.5.97 (eigene Kopie) | Legacy-Profil, Test zum Meilensteinende | M6.4 |
| Fuz Ro D-oh | stumme Zeilen mit Untertitel-Dauer beim Testen | M1.8 |
| Test-Saves T01–T08 | Einstiege für Tests | ab M1 |
| Papyrus-Logging einschalten | `Skyrim.ini` `[Papyrus]`: `bEnableLogging`, `bEnableTrace`, `bLoadDebugInformation` stehen auf 0 | vor dem ersten Test |

### Download-Links (Windows 11)

winget 1.29 ist vorhanden; die IDs habe ich mit `winget search` geprüft. Nexus-Downloads brauchen ein Konto und lassen sich nicht per winget holen. Die Nexus-Seiten konnte ich nicht öffnen (403), die Dateilisten dort sind also ungeprüft.

| Tool | Download | Installation |
|---|---|---|
| GitHub CLI | [cli.github.com](https://cli.github.com/) | `winget install --id GitHub.cli`, danach `gh auth login` |
| LOOT | [loot.github.io](https://loot.github.io/) | `winget install --id LOOT.LOOT` (0.29.2) |
| 7-Zip | [7-zip.org](https://www.7-zip.org/) | `winget install --id 7zip.7zip` |
| .NET SDK 10 | [dotnet.microsoft.com](https://dotnet.microsoft.com/download/dotnet/10.0) | `winget install --id Microsoft.DotNet.SDK.10` (installiert, 10.0.401). Spriggit 0.41 und SehtMCP brauchen .NET 10 |
| SSEEdit (xEdit) | [GitHub-Releases](https://github.com/TES5Edit/TES5Edit/releases) (4.1.5f, `.7z`) oder [Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/164) | entpacken, `xEdit.exe` in `SSEEdit.exe` umbenennen; Ordner außerhalb des Spielordners |
| Spriggit CLI | [GitHub-Releases](https://github.com/Mutagen-Modding/Spriggit/releases) (0.41.0), [Doku](https://mutagen-modding.github.io/Spriggit/cli/) | Asset für Windows laden; die Dateinamen konnte ich nicht auslesen. Befehle laut Doku: `convert-from-plugin` (ESP → Text) und `convert-to-plugin` (Text → ESP) |
| Pyro | [GitHub-Releases](https://github.com/fireundubh/pyro/releases), [Wiki](https://wiki.fireundubh.com/pyro) | ZIP entpacken (enthält bsarch), Pfad in `docs/ENVIRONMENT.md` eintragen |
| CKPE | [GitHub-Releases](https://github.com/Perchik71/Creation-Kit-Platform-Extended/releases), [Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/71371) | Inhalt in den Spielordner neben `CreationKit.exe` entpacken, `ckpe_loader.exe` startet das CK |
| SkyUI SDK | [SkyUI SE auf Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/12604?tab=files), Quellen auf [GitHub](https://github.com/schlangster/skyui) | zur installierten SkyUI-Version passendes SDK; ältere SDK-Dateien vorher entfernen |
| VS-Code-Extension „Papyrus“ | in VS Code unter Erweiterungen suchen | |

**Achtung CKPE:** Laut CKPE-Wiki unterstützt es die Skyrim-CK-Versionen 1.5.73, 1.6.1130 und 1.6.1378.1. Version 1.7.x ist dort nicht aufgeführt, installiert ist 1.7.99.0. Vor der Installation auf der Releases-Seite prüfen, ob eine passende Version existiert. Sonst braucht M0.2 eine ältere CK-Version.

## 3. Zugriff für Claude

- **Lesen** kann ich den Spielordner und `C:\Users\Vanessa Bubu Schmidt\Documents\My Games\Skyrim Special Edition` (beide freigegeben). Ich lese dort nur; Änderungen brauchen deine ausdrückliche Zustimmung im Einzelfall.
- **Schreiben** darf ich weiter nur im Repository (Regel 2 in `CLAUDE.md`).
- Das Creation Kit und das Spiel kann ich nicht bedienen; das bleibt beim Entwickler.

## 4. MCP-Server für das ESP (entschieden, E17)

**Ausführliche Analyse aller Kandidaten: [docs/MCP-Vergleich.md](MCP-Vergleich.md) (22.09.2026). Kurzfassung: houseCARL ist der beste Kandidat (mit Auflagen), SehtMCP für Navmesh später, SkyrimCK-MCP ist kein MCP-Server.** Die Tabelle unten stammt aus der ersten Recherche und ist dort korrigiert.

Es gibt MCP-Server, mit denen Claude ein ESP ohne Creation Kit lesen und schreiben kann:

| Server | Umfang laut Beschreibung | Voraussetzungen | Reife |
|---|---|---|---|
| [SkyrimCK-MCP](https://github.com/Pyrhame/SkyrimCK-MCP) | Quests mit Scripts und Aliasen, Packages mit Conditions, Szenen, Sounds, Zell-Overrides | .NET 8 SDK, `esper` und `balsa` selbst klonen und bauen | Alpha, MIT, 1 Autor |
| [SehtMCP](https://github.com/tel-0s/SehtMCP) | 133 Record-Typen, Validierung, Navmesh-Baking (Recast), NIF-Prüfung, Papyrus-Diagnose, atomares Speichern mit Backups, schreibt nur im Workspace | .NET 10 SDK, Windows x64 | Version 0.3.0, GPL-3.0, kaum genutzt |
| [houseCARL](https://www.nexusmods.com/skyrimspecialedition/mods/181738) | Modding-MCP mit 1.174 indizierten Typen; nicht näher geprüft | | unklar |
| [SkyLink AI / SkyrimMCM](https://github.com/WraithFallen/SkryimMCM) | anderer Zweck: liest und ändert den Zustand des laufenden Spiels (74 Tools) | Spielmod, nur für Test-Profile | nicht geprüft |

**Was auch mit MCP beim Entwickler bleibt:** Zellen bauen und Objekte platzieren (Deep Sanctuary, ca. 1.200–1.700 Referenzen), Navmesh über Zellgrenzen, Beleuchtung und Room Bounds, FaceGen (Strg+F4), Lip-Sync und der Ingame-Test. SehtMCP nennt selbst: kein FaceGen, kein Lip, kein Navmesh über mehrere Zellen.

**Was Claude damit übernehmen könnte:** Globals, Fraktionen, FormLists, Messages, Items und Spells, NPC-Werte, Quests mit Stages und Aliasen, Packages, Dialog-Topics und -INFOs aus dem CSV, Szenen. Das ist der größte Teil der CK-Arbeit in M1.1, M1.4, M1.5 und M1.6.

### Empfehlung (Stand vor der Entscheidung)

Entschieden am 22.09.2026: Claude bearbeitet das ESP (E17). Umgesetzt wird zuerst mit Spriggit; ein MCP-Server folgt nach Quelltextprüfung und Freigabe.

1. **Spike in M0** an einem Wegwerf-Plugin, nicht an `NightsHarvest.esp`: Globals, Quest mit Alias und Script, eine Dialogzeile. Danach im CK öffnen und speichern. Verglichen werden SehtMCP, SkyrimCK-MCP und Spriggit-Deserialize (Text → ESP, nutzt ohnehin Mutagen).
2. **Ein Schreiber zur Zeit:** Das ESP ist nicht mergebar. CK und Claude bearbeiten es nie gleichzeitig. Jede Übergabe endet mit Spriggit-Export und Commit; nach jedem Claude-Eingriff öffnet der Entwickler das ESP einmal im CK und speichert, bevor er weiterarbeitet.
3. **Dokumente anpassen, sobald entschieden ist:** `docs/ENVIRONMENT.md` (Deserialize ist dort bewusst ausgeschlossen), `docs/ROADMAP.md` (Spalte „Wer“), `docs/TESTING.md` und die Skill `ck-guide`. Die Entscheidung gehört als E17 in `docs/DECISIONS.md`.

Regel 6 (nichts als ingame funktionierend melden) bleibt bestehen: Ein gültiges ESP ist nicht dasselbe wie ein funktionierender Quest-Ablauf.

## 5. Schutz des aktiven Spiels (Stand 22.09.2026)

Der Spielordner ist ein aktives Vortex-Deployment mit 177 aktiven Plugins. Er wird nur gelesen. Alles rund um den Mod läuft in einer getrennten Umgebung; Orte und Regeln stehen in `docs/ENVIRONMENT.md`, Abschnitt „Getrennte Umgebung“.

### Was am 22.09. entstanden ist

| Was | Ergebnis |
|---|---|
| Backup | `brotherhood-devenv\backups\2026-09-22_0015`: 38 Dateien (Vortex-Zustand, alle INIs aus `Documents\My Games`, `plugins.txt`, `loadorder.txt`, Deployment-Manifeste, CK-INIs). Jede Datei per SHA-256 gegen das Original geprüft, 0 Abweichungen, `MANIFEST.sha256` liegt bei. Vortex und Skyrim liefen dabei nicht |
| Dev-Kopie | `brotherhood-devenv\SkyrimSE-Dev`, 13,2 GB: `SkyrimSE.exe` 1.6.1170, SKSE, Creation Kit, Papyrus-Compiler, Tools, Vanilla-Master (Skyrim, Update, Dawnguard, HearthFires, Dragonborn) mit BSAs, USSEP, SkyUI. Keine Creation-Club-Inhalte und keine anderen Mods. Programmdateien und Master per Hash, BSAs per Größe mit dem Original verglichen |
| Papyrus-Quellen in der Kopie | `Data\Source\Scripts`: 14.301 Vanilla-Quellen aus `Scripts.zip`. `Data\Scripts\Source`: 328 `.psc` aus dem Live-Ordner (SKSE, dort können einzelne Mod-Quellen dabei sein) |
| CKPE | in der Dev-Kopie entpackt (`ckpe_loader.exe`, `winhttp.dll`, überschreibt dort `Tools\LipGen`). Nicht getestet. Im Live-Ordner ist weder `winhttp.dll` noch `ckpe_loader.exe` vorhanden (geprüft) |
| SkyUI-Archiv aus `downloads/` | nicht verwendet: kein SDK, und die Hashes weichen von der installierten Version ab |
| Saves-Backup | `brotherhood-devenv\backups\2026-09-22_0032-saves`: 2.683 Dateien, 751 MB, jede Datei per SHA-256 geprüft, 0 Fehler. Quelle danach unverändert |
| Schreibschutz | Alle 2.723 Backup-Dateien NTFS-schreibgeschützt. Für Claude Code: PreToolUse-Hook `.claude/hooks/protect_live.py` (20 Selbsttest-Fälle bestanden) plus Deny-Regeln in `.claude/settings.json`. Der Hook hat in dieser Sitzung einen Testbefehl mit Live-Pfad und `Remove-Item` blockiert, ein Schreibversuch in die Backups wurde von den Settings abgelehnt |
| Testumgebung | Mod Organizer 2 2.5.2 (portable, `Mod.Organizer-2.5.2.7z` von github.com/ModOrganizer2, 142,7 MB, SHA-256 `E6376EFD87FD5DDD95AEE959405E8F067AFA526EA6C2C0C5AA03C5108BF4A815`, GitHub nennt keinen Vergleichswert) in `brotherhood-devenv\MO2`. Ein Testlauf hat die Instanz akzeptiert: Spiel `Skyrim Special Edition` (Steam, ID 489830) in der Dev-Kopie, Executables SKSE, Skyrim, Creation Kit, Explorer, Plugins DLCs, USSEP, SkyUI |
| Git | `main` mit zwei Commits, `dev` mit dem Hook-Commit, `origin` = `patrickresearch/skyrim-brotherhood`, nichts gepusht |

Korrektur zu meiner früheren Angabe: Die Live-Quellen in `Data\Source\Scripts` (14.339 `.psc`) sind nicht stark vermischt. 38 Dateien stammen von Mods (z. B. `AFW_`), 7 weichen von Vanilla ab, vermutlich durch USSEP.

### Grenzen der Trennung

- **Nur über MO2 spielen:** Die Dev-Kopie darf nicht direkt gestartet werden (nicht `SkyrimSE.exe`, nicht `skse64_loader.exe` aus dem Ordner). Sonst benutzt sie die INIs, die `plugins.txt` und den Saves-Ordner des Live-Spiels. Über MO2 gilt das Profil `Default` mit eigenen INIs und Saves (`LocalSaves`, `LocalSettings`).
- **Restrisiko Logs:** Papyrus-Logs, SKSE-Logs und Screenshots schreibt das Spiel vermutlich weiter in den echten `Documents\My Games`-Ordner (neue Dateien, keine Überschreibung). Ungeprüft. Nach dem ersten Spielstart die INIs dort mit dem Backup vergleichen und prüfen, ob ein Ordner `__MO_Saves` entstanden ist.
- **Creation Kit:** Die `CreationKit.ini` nutzt relative Pfade (`Data\`, `Saves\`), das CK arbeitet also im `Data`-Ordner der Kopie. Ob es zusätzlich etwas unter `Documents\My Games` schreibt, ist ungeprüft. Nach dem ersten CK-Start sind die INIs dort mit dem Backup zu vergleichen.
- **Start ohne Steam-Ordner:** Die Kopie enthält `steam_appid.txt` (489830). Der Start ist ungetestet; Steam muss laufen.

Für Kompatibilitätstests gegen die echte Load Order dient später ein eigenes Profil, nie das Live-Spiel.

## 6. Kompatibilität mit deiner aktiven Load Order

Aus `plugins.txt` (aktive Plugins), nur gelesen. Die Einstufung beruht auf den Plugin-Namen; den Inhalt der Mods habe ich noch nicht geprüft. Was direkt unsere Bereiche berührt:

| Mod | Betrifft | Risiko | Was tun |
|---|---|---|---|
| `Sanctuary Reborn.esp` | Dawnstar Sanctuary, Zugang zur Deep Sanctuary, Q00 | **hoch** | Falls beide dieselbe Zelle ändern: Zell-Kopie in unserem ESP (E16, Option A) kann die Änderungen überdecken, wenn wir später laden. Daher zu E16 eher Option B (Script-Tür ohne Zell-Kopie) oder ein Patch. Vor M1.3 in xEdit die Zelle `DawnstarSanctuary` prüfen |
| `The Brotherhood of Old.esp` | Dark-Brotherhood-Erweiterung, Sanctuary | mittel bis hoch | Auf Neben-NPCs, Zellen und geänderte „Hail Sithis!“-Abläufe prüfen |
| `CiceroMarriageSE.esp` | Cicero | mittel | Optionale Cicero-Aliase müssen mit einem Ehepartner-Cicero klarkommen (Test T02/T03) |
| `Skyrim Ladies - Astrid.esp` | Astrid, Memorial Wall in Q00 | niedrig bis mittel | Prüfen, ob Astrids Record oder Referenzen verändert werden |
| `UFO - Ultimate Follower Overhaul.esp`, `Missing Follower Dialogue Fix.esp`, `Better Stealth AI for Followers.esp` | Rekruten als Follower (E01) | mittel | Testfall BT09; Rekruten dürfen nicht in `CurrentFollowerFaction` landen, außer im Kompatibilitätsmodus |
| `Missives - Unique Dawnstar / Morthal / Winterhold / Falkreath Board.esp` | Quest-Aushänge in Q01 (Morthal), Q03 (Winterhold) | niedrig | Prüfen, ob sie Zellen von Q01/Q03 kopieren |
| `Snowy AF Windhelm.esp`, `Windhelm Lighthouse.esp`, `JK's College of Winterhold.esp`, `Enhanced Solitude SSE.esp`, Whiterun-Mods | Stadtszenen Q02, Q03 | mittel | `MoveTo` auf XMarker an Stellen, die frei bleiben (Konzept 15); jeweils in xEdit auf Zellkonflikte prüfen |
| `Distinct Interiors.esp`, ELFX-Plugins, `Darker Interior Ambient Fog.esp` | Beleuchtung der Innenräume | niedrig | Deep Sanctuary mit eigenem Lighting Template; Screenshots in Heavy-Profil |
| `alternate start - live another life.esp` | Startbedingung | niedrig | Startbedingung an den Questabschluss gebunden, nicht an den Spielbeginn (bereits so geplant) |
| `Mantella.esp`, `EngineFixes.dll`, `FaceGenFixes.dll`, `BackportedESLSupport.dll`, JContainers | Voice, Engine-Verhalten, FaceGen, ESL | niedrig | Voice-Profil, T-Saves nach CK-FaceGen prüfen; E04 (ESP/ESL) entscheiden |

Für Konflikte reicht SSEEdit im Nur-Lese-Modus gegen diese Load Order; `Check for Errors` und Cleaning werden nicht auf Live-Plugins ausgeführt.

### Offene Schritte

1. MO2 einmal öffnen (`brotherhood-devenv\MO2\ModOrganizer.exe`), „Show tutorial?“ mit Nein beantworten, Executables und Plugin-Liste ansehen. Die Warnung „Instanz liegt auf dem Desktop“ ist offen; ein Ordner außerhalb des Desktops wäre sauberer (dann müssen `ModOrganizer.ini` und diese Doku angepasst werden).
2. SSEEdit in MO2 als Executable eintragen (`<Repo>\.tools\SSEEdit\SSEEdit.exe`).
3. Ersten Spielstart über MO2 mit dem Profil `Default` testen und danach die Live-Dateien gegen das Backup prüfen (Restrisiko Logs).
4. CKPE in der Dev-Kopie über MO2 mit dem Creation Kit testen (CKPE und MO2 zusammen sind ungeprüft).
5. Sichtbarkeit des GitHub-Repos klären: `skyrim-brotherhood` ist öffentlich, `docs/ROADMAP.md` (M0.4) sieht ein privates Repo vor. Erst danach pushen.
6. E16 vor M1.3 entscheiden, mit Blick auf Sanctuary Reborn.
