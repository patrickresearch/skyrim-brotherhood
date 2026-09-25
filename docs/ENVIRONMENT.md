# Lokale Umgebung – Night's Harvest

Vom Entwickler in M0 auszufüllen. Claude liest diese Datei vor jedem Build- oder Tool-Befehl und fragt nach, wenn ein Wert fehlt. Keine Passwörter oder Tokens eintragen.

## System

| Punkt | Wert |
|---|---|
| Betriebssystem | Windows 11 Home, 10.0.26200 |
| Shell für Claude Code | PowerShell 5.1 (primär), Git Bash |
| Python | 3.14.7 |
| Git | 2.55.0.windows.5 |

## Getrennte Umgebung (verbindlich ab 22.09.2026)

Das Live-Spiel wird aktiv gespielt und bleibt unangetastet. Alles rund um den Mod läuft getrennt davon:

| Was | Ort | Regel |
|---|---|---|
| Live-Spiel (Steam, Vortex-Deployment) | `C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition` | nur lesen |
| Live-Einstellungen, Saves, Load Order | `C:\Users\Vanessa Bubu Schmidt\Documents\My Games\Skyrim Special Edition`, `%LOCALAPPDATA%\Skyrim Special Edition` | nur lesen |
| Vortex (Zustand, Profile, Mods, Downloads) | `%APPDATA%\Vortex`, Installation `C:\Program Files\Black Tree Gaming Ltd\Vortex` | nicht anfassen |
| Repository (Quellen, Doku, Tools) | `C:\Users\Vanessa Bubu Schmidt\Desktop\Utils\dev\brotherhood` | hier wird entwickelt |
| Dev-Kopie des Spiels (Vanilla, USSEP, SkyUI, SKSE, CK, CKPE) | `C:\Dev\brotherhood-devenv\SkyrimSE-Dev` | hier laufen CK, Builds, Tests |
| Testumgebung (Mod Organizer 2 2.5.2, portable) | `C:\Dev\brotherhood-devenv\MO2` | zeigt auf die Dev-Kopie; Profil `Default` mit eigenen INIs und Saves. Seit 23.09.2026 eine frisch aufgesetzte Instanz (die ursprüngliche war fehlerhaft, siehe unten) – liegt unter `C:\Dev\brotherhood-devenv\MO2-broken-archive`, falls je gebraucht |
| Backups vom 22.09.2026 (schreibgeschützt) | `C:\Dev\brotherhood-devenv\backups\` | je Ordner eine `MANIFEST.sha256` (SHA-256 je Datei) |

Backups:

- `2026-09-22_0015`: Vortex-Zustand (`state.v2`, Profile, Snapshots, Masterlist, Userlist, Einstellungen), alle INI-Dateien aus `Documents\My Games` (darunter `Skyrim.ini` und `SkyrimCustom.ini`), `plugins.txt`, `loadorder.txt`, Deployment-Manifeste, CK-INIs (39 Dateien).
- `2026-09-22_0032-saves`: alle Saves (2.683 Dateien, 751 MB), jede Datei per Hash geprüft.
- Nicht gesichert: Mod-Staging (`Vortex\skyrimse\mods`, ca. 58 GB) und Vortex-Downloads (ca. 35 GB).
- Alle Backup-Dateien tragen das NTFS-Attribut „schreibgeschützt“.

**Testumgebung:** MO2 lädt die Dev-Kopie über `ModOrganizer.ini` (`gamePath`), nicht das Live-Spiel. Das Profil `Default` nutzt profilspezifische INIs (`skyrim.ini` mit eingeschaltetem Papyrus-Logging) und einen eigenen Saves-Ordner (`LocalSaves`, `LocalSettings`). MO2 kennt SKSE, Skyrim, Creation Kit und den Virtual-Folder-Explorer; alle zeigen auf die Dev-Kopie. Nach dem Umzug nach `C:\Dev` meldet MO2 keine Warnung mehr.

**Gelöst (23.09.2026):** `SkyrimSE.exe` brach über die ursprüngliche MO2-Instanz nach ca. 1 s ab. Ursache war eine Kombination aus vier Problemen (fehlende USSEP-Master, die fehlerhafte alte MO2-Instanz selbst, eine unvollständige SKSE-Installation, SkyUI-Registrierungs-Timing) – Details und volle Diagnose-Geschichte: `docs/tests/M0.6.md`, Abschnitt „Auflösung Spielstartproblem“. M1.1 läuft seither ingame fehlerfrei (Startbedingung, MCM).

**Schreibschutz:** `.claude/settings.json` und `.claude/hooks/protect_live.py` sperren Claude Code für Live-Spielordner, `Documents\My Games`, `%LOCALAPPDATA%\Skyrim Special Edition`, Vortex und Backups. Testen: `python .claude/hooks/protect_live.py --selftest`.

**Restrisiko:** Papyrus-Logs, SKSE-Logs und Screenshots schreibt das Spiel vermutlich in den echten `Documents\My Games`-Ordner, weil MO2 nur INIs und Saves umleitet. Das ist ungeprüft. Nach dem ersten Spielstart die INIs dort mit dem Backup vergleichen und prüfen, ob ein Ordner `__MO_Saves` entstanden ist.

## Spiel & Tools

Die Tabelle beschreibt das Live-Spiel und die Werkzeuge. Für die Entwicklung gilt die Dev-Kopie.

| Tool | Version | Pfad |
|---|---|---|
| Skyrim SE/AE | 1.6.1170.0 (AE) | `C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition` |
| SKSE64 | Loader 0.2.2.8, passend zu Spiel 1.6.1170. Data-Paket (`Data\Scripts\*.pex` + `Data\Scripts\Source\*.psc`, 62 Dateipaare – SKSE ersetzt u. a. `Actor`, `Quest`, `ObjectReference`, `UI`, `Utility`, `Game` durch erweiterte Versionen) seit 23.09.2026 vollständig installiert, aus dem offiziellen 2.2.6-Archiv (skse.silverlock.org/download/archive) – Script-API ist versionsstabil, Diskrepanz zu Loader 2.2.8 irrelevant. Ohne das komplette Paket: SkyUI „Error Code 7“ | `<Dev>\skse64_loader.exe` |
| Creation Kit | 1.7.99.0 | `<Dev>\CreationKit.exe` |
| CKPE | 0.6-b701, nur in der Dev-Kopie entpackt, ungetestet | `<Dev>\ckpe_loader.exe` |
| Papyrus-Compiler (Bethesda) | vorhanden | `<Dev>\Papyrus Compiler\PapyrusCompiler.exe` |
| VS Code | installiert, Papyrus-Extension installiert | `C:\Users\Vanessa Bubu Schmidt\AppData\Local\Programs\Microsoft VS Code` |
| Pyro | Build 1656807840 (Juli 2022), enthält bsarch | `<Repo>\.tools\pyro\pyro.exe` (lokal, ignoriert) |
| Spriggit CLI | 0.41.0 | `<Repo>\.tools\Spriggit\Spriggit.CLI.exe` (lokal, ignoriert) |
| SSEEdit (xEdit) | 4.1.5f | `<Repo>\.tools\SSEEdit\SSEEdit.exe` (lokal, ignoriert) |
| SkyUI SDK (nur `SKI_ConfigBase.psc`, `SKI_QuestBase.psc`) | von github.com/schlangster/skyui, Pfad `dist/Data/Scripts/Headers/`, `master`-Branch (22.09.) | `<Repo>\.tools\skyui-sdk\` (lokal, ignoriert). Neu holen: `curl -sL "https://raw.githubusercontent.com/schlangster/skyui/master/dist/Data/Scripts/Headers/SKI_ConfigBase.psc" -o .tools/skyui-sdk/SKI_ConfigBase.psc` (und entsprechend für `SKI_QuestBase.psc`). Kein Nexus-Download/-Login nötig, Quelle ist öffentlich |
| LOOT | 0.29.2 (winget) | `C:\Users\Vanessa Bubu Schmidt\AppData\Local\Programs\LOOT\LOOT.exe` |
| GitHub CLI | 2.101.0, noch nicht angemeldet (`gh auth login` macht der Entwickler) | `C:\Program Files\GitHub CLI\gh.exe` |
| .NET SDK | 10.0.401 | `C:\Program Files\dotnet` |
| .NET Runtime + ASP.NET Core Runtime 9 | 9.0.20 (für houseCARL, winget) | `C:\Program Files\dotnet\shared` |
| houseCARL (MCP-Server, E17) | 2.0.2, ohne Setup-Assistenten installiert, Pilot bestanden (22.09.) | `C:\Dev\brotherhood-devenv\tools\houseCARL`, registriert in `.mcp.json` im Repo. Details: `docs/MCP-Vergleich.md` |
| 7-Zip | installiert | `C:\Program Files\7-Zip\7z.exe` |
| Vortex | Installationspfad eintragen; Daten unter `C:\Users\Vanessa Bubu Schmidt\AppData\Roaming\Vortex` | Profile: Clean, Heavy, Legacy, Voice (M0.1) |
| Papyrus-Log | Live-INI: Logging aus, unverändert. Dev-Profil: Logging an (`MO2\profiles\Default\skyrim.ini`) | vermutlich `C:\Users\Vanessa Bubu Schmidt\Documents\My Games\Skyrim Special Edition\Logs\Script\Papyrus.0.log` (nach dem ersten Testlauf prüfen) |

Der Live-Spielordner enthält ein stark gemoddetes Vortex-Deployment (177 aktive Plugins). Statt eines Clean-Profils in Vortex (M0.1) gilt für die Entwicklung die Dev-Kopie.

## Papyrus-Quellen für Imports

`<Dev>` steht für `C:\Dev\brotherhood-devenv\SkyrimSE-Dev`.

| Quelle | Pfad | Stand |
|---|---|---|
| Vanilla (aus `Scripts.zip`) | `<Dev>\Data\Source\Scripts` | 14.301 unveränderte Quellen (AE inkl. Creation Club) |
| SKSE | `<Dev>\Data\Scripts\Source` | 328 `.psc` aus dem Live-Ordner kopiert (SKSE, evtl. einzelne Mod-Quellen dabei); SKSE-Quellen haben Vorrang vor Vanilla |
| SkyUI SDK | `<Repo>\.tools\skyui-sdk` | Erledigt (22.09.): von GitHub geholt, siehe Tabelle oben. `NightsHarvest.ppj` importiert `.\.tools\skyui-sdk` (der führende `.\` ist nötig, ein reiner `.tools\...`-Pfad wird von Pyro falsch mit dem Arbeitsverzeichnis verkettet) |

## Befehle

| Zweck | Befehl |
|---|---|
| Build (Scripts kompilieren) | `powershell -File tools\build.ps1` (`-Clean` kompiliert alles neu). Ruft Pyro mit `NightsHarvest.ppj` und `--game-path` der Dev-Kopie auf und bricht ab, wenn der Pfad auf das Live-Spiel zeigt |
| Nur Scripts kompilieren | wie Build |
| Repo → Dev-Kopie (`.pex`, `NHV_*.psc`, optional ESP) | `powershell -File tools\sync_dev.ps1 -Direction ToDev [-IncludeEsp]` |
| Dev-Kopie → Repo (ESP, SEQ, FaceGen vom CK) | `powershell -File tools\sync_dev.ps1 -Direction FromDev` (liest `<Dev>\Data` und `MO2\overwrite`, nimmt die neuere Datei, überschreibt keine neuere Repo-Datei ohne `-Force`) |
| Release-Archiv (BSA + FOMOD als `dist\NightsHarvest-<Version>.7z`) | `powershell -File tools\package.ps1` (braucht ein echtes ESP in `Data\`) |
| Live-Spiel unberührt? | `powershell -File tools\verify_live_untouched.ps1` (nur lesend, vergleicht mit dem Backup) |
| Text → ESP (Claude bearbeitet `plugin-text/`, E17) | `powershell -File tools\plugin_text.ps1 -Direction ToPlugin` (schreibt `Data\NightsHarvest.esp`, schreibt den Text danach kanonisch neu; verweigert das Überschreiben eines neueren ESP) |
| ESP → Text (nach jeder CK-Session, nach `sync_dev.ps1 -Direction FromDev`) | `powershell -File tools\plugin_text.ps1 -Direction ToText` |
| Spriggit direkt | `.tools\Spriggit\Spriggit.CLI.exe convert-from-plugin ... --PackageName Spriggit.Yaml --PackageVersion 0.41.0` bzw. `convert-to-plugin --InputPath plugin-text --OutputPath <ESP>`. `--PackageVersion` ist Pflicht |
| Dialog-Lint | `python tools/dialogue_lint.py dialogue/` |

Spriggit-Deserialize (Text → ESP) ist seit E17 erlaubt, aber nur nach der Ein-Schreiber-Regel (CLAUDE.md, Regel 7). Dafür gibt es `tools/plugin_text.ps1` (siehe Tabelle oben).

**Bekannte Spriggit-Limitation (23.09.2026, Version 0.41.0, aktuell):** Ein `QuestLogEntry` (Journal-Text an einer Quest-Stage, Feld `Entry`) lässt sich per YAML **nicht deserialisieren**, sobald die Liste mindestens einen Eintrag hat – `convert-to-plugin` stürzt hart ab mit `System.ArgumentException: Could not convert to Mutagen.Bethesda.Skyrim.QuestLogEntry+Flag: 0` (auch mit explizit gesetztem `Flags: None`, das ebenfalls nicht als gültiger Enum-Wert akzeptiert wird – der Enum hat offenbar keinen benannten Nullwert). Eine leere Liste (`LogEntries: []`) funktioniert; Stages ganz ohne `LogEntries`-Feld funktionieren. Getestet: kein neueres Spriggit-Release verfügbar (0.41.0 ist aktuell). **Workaround:** Quest-Stages nur mit `Index` (und ggf. Stage-`Flags` wie `ShutDownStage`) per YAML anlegen, Journal-Text für jede Stage direkt im CK eintragen (Quest Stages-Tab, Text einfügen) – die Texte stehen bereits in `dialogue/Journal.csv`. Betrifft aktuell `NHV_Q00_ShadowAtTheDoor`.

## Hinweise für Claude Code unter Windows

- Pfade mit Leerzeichen immer in Anführungszeichen.
- Der Build darf nur in das Staging unter `Data/` bzw. in den Build-Ordner aus `NightsHarvest.ppj` schreiben, nie in den Live-Spielordner. Kopien in die Dev-Kopie sind erlaubt.
- Schreibzugriffe auf Live-Spielordner, `Documents\My Games`, `%LOCALAPPDATA%\Skyrim Special Edition` und Vortex sind tabu, außer der Entwickler gibt sie im Einzelfall frei.

**CK-Compiler und SKSE-Scripts (25.09.2026):** Der Compiler im Creation Kit (Fragment-Fenster) sucht Quellen nur in `<Dev>\Data\Source\Scripts`, Pyro durchsucht zusätzlich `<Dev>\Data\Scripts\Source`. `SKSE.psc` und `ModEvent.psc` lagen nur dort; ohne Kopie nach `Data\Source\Scripts` scheitern CK-Fragmente, die `NHV_CoreScript`/`NHV_Util` ansprechen („variable SKSE is undefined“). Beide Dateien wurden in der Dev-Kopie kopiert (bei Neuaufbau der Dev-Kopie wiederholen). Der CK meldet bei erfolgreichem Kompilieren nichts.
