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
| Testumgebung (Mod Organizer 2 2.5.2, portable) | `C:\Dev\brotherhood-devenv\MO2` | zeigt auf die Dev-Kopie; Profil `Default` mit eigenen INIs und Saves |
| Backups vom 22.09.2026 (schreibgeschützt) | `C:\Dev\brotherhood-devenv\backups\` | je Ordner eine `MANIFEST.sha256` (SHA-256 je Datei) |

Backups:

- `2026-09-22_0015`: Vortex-Zustand (`state.v2`, Profile, Snapshots, Masterlist, Userlist, Einstellungen), alle INI-Dateien aus `Documents\My Games` (darunter `Skyrim.ini` und `SkyrimCustom.ini`), `plugins.txt`, `loadorder.txt`, Deployment-Manifeste, CK-INIs (39 Dateien).
- `2026-09-22_0032-saves`: alle Saves (2.683 Dateien, 751 MB), jede Datei per Hash geprüft.
- Nicht gesichert: Mod-Staging (`Vortex\skyrimse\mods`, ca. 58 GB) und Vortex-Downloads (ca. 35 GB).
- Alle Backup-Dateien tragen das NTFS-Attribut „schreibgeschützt“.

**Testumgebung:** MO2 lädt die Dev-Kopie über `ModOrganizer.ini` (`gamePath`), nicht das Live-Spiel. Das Profil `Default` nutzt profilspezifische INIs (`skyrim.ini` mit eingeschaltetem Papyrus-Logging) und einen eigenen Saves-Ordner (`LocalSaves`, `LocalSettings`). MO2 kennt SKSE, Skyrim, Creation Kit und den Virtual-Folder-Explorer; alle zeigen auf die Dev-Kopie. Nach dem Umzug nach `C:\Dev` meldet MO2 keine Warnung mehr.

**Bekanntes Problem (22.09.2026):** `SkyrimSE.exe` aus der Dev-Kopie bricht nur über MO2 nach ca. 1 s ab; per direktem Doppelklick ohne MO2 startet es normal. Liegt also an MO2s Virtualisierung (usvfs) in dieser Umgebung. Details und Diagnose: `docs/tests/M0.6.md`, Abschnitt „Bekanntes Problem: Spielstart“. Ingame-Test bis zur Klärung zurückgestellt.

**Schreibschutz:** `.claude/settings.json` und `.claude/hooks/protect_live.py` sperren Claude Code für Live-Spielordner, `Documents\My Games`, `%LOCALAPPDATA%\Skyrim Special Edition`, Vortex und Backups. Testen: `python .claude/hooks/protect_live.py --selftest`.

**Restrisiko:** Papyrus-Logs, SKSE-Logs und Screenshots schreibt das Spiel vermutlich in den echten `Documents\My Games`-Ordner, weil MO2 nur INIs und Saves umleitet. Das ist ungeprüft. Nach dem ersten Spielstart die INIs dort mit dem Backup vergleichen und prüfen, ob ein Ordner `__MO_Saves` entstanden ist.

## Spiel & Tools

Die Tabelle beschreibt das Live-Spiel und die Werkzeuge. Für die Entwicklung gilt die Dev-Kopie.

| Tool | Version | Pfad |
|---|---|---|
| Skyrim SE/AE | 1.6.1170.0 (AE) | `C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition` |
| SKSE64 | Loader 0.2.2.8; Live-Ordner hat DLLs für 1.6.1170 und 1.5.97, die Dev-Kopie nur 1.6.1170 | `<Dev>\skse64_loader.exe` |
| Creation Kit | 1.7.99.0 | `<Dev>\CreationKit.exe` |
| CKPE | 0.6-b701, nur in der Dev-Kopie entpackt, ungetestet | `<Dev>\ckpe_loader.exe` |
| Papyrus-Compiler (Bethesda) | vorhanden | `<Dev>\Papyrus Compiler\PapyrusCompiler.exe` |
| VS Code | installiert, Papyrus-Extension installiert | `C:\Users\Vanessa Bubu Schmidt\AppData\Local\Programs\Microsoft VS Code` |
| Pyro | Build 1656807840 (Juli 2022), enthält bsarch | `<Repo>\.tools\pyro\pyro.exe` (lokal, ignoriert) |
| Spriggit CLI | 0.41.0 | `<Repo>\.tools\Spriggit\Spriggit.CLI.exe` (lokal, ignoriert) |
| SSEEdit (xEdit) | 4.1.5f | `<Repo>\.tools\SSEEdit\SSEEdit.exe` (lokal, ignoriert) |
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
| SkyUI SDK | | fehlt: `SKI_ConfigBase.psc` liegt nicht vor. Das SkyUI-Archiv in `downloads/` enthält nur `.pex`. Ablage künftig unter `<Repo>\.tools\skyui-sdk`, nicht im Spielordner. Wird ab M1.1 gebraucht |

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

## Hinweise für Claude Code unter Windows

- Pfade mit Leerzeichen immer in Anführungszeichen.
- Der Build darf nur in das Staging unter `Data/` bzw. in den Build-Ordner aus `NightsHarvest.ppj` schreiben, nie in den Live-Spielordner. Kopien in die Dev-Kopie sind erlaubt.
- Schreibzugriffe auf Live-Spielordner, `Documents\My Games`, `%LOCALAPPDATA%\Skyrim Special Edition` und Vortex sind tabu, außer der Entwickler gibt sie im Einzelfall frei.
