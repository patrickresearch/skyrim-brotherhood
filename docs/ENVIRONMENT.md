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

**Testumgebung:** MO2 lädt die Dev-Kopie über `ModOrganizer.ini` (`gamePath`), nicht das Live-Spiel. Das Profil `Default` nutzt profilspezifische INIs (`skyrim.ini` mit eingeschaltetem Papyrus-Logging) und einen eigenen Saves-Ordner (`LocalSaves`, `LocalSettings`). MO2 kennt SKSE, Skyrim, Creation Kit und den Virtual-Folder-Explorer; alle zeigen auf die Dev-Kopie. Die Warnung von MO2, dass die Instanz auf dem Desktop liegt (Systemordner), ist offen. Ingame noch nicht getestet.

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
| Build (Scripts, BSA, Archiv) | (in M0.3 eintragen, z. B. Pyro mit `NightsHarvest.ppj`) |
| Nur Scripts kompilieren | (eintragen) |
| Spriggit-Serialize (ESP → `plugin-text/`) | `.tools\Spriggit\Spriggit.CLI.exe convert-from-plugin --InputPath "Data\NightsHarvest.esp" --OutputPath plugin-text --GameRelease SkyrimSE --PackageName Spriggit.Yaml` (noch nicht getestet, M0.5) |
| Dialog-Lint | `python tools/dialogue_lint.py dialogue/` |

Spriggit-Deserialize (Text → ESP) wird hier bewusst nicht eingetragen: Das ESP ändert nur der Entwickler im Creation Kit.

## Hinweise für Claude Code unter Windows

- Pfade mit Leerzeichen immer in Anführungszeichen.
- Der Build darf nur in das Staging unter `Data/` bzw. in den Build-Ordner aus `NightsHarvest.ppj` schreiben, nie in den Live-Spielordner. Kopien in die Dev-Kopie sind erlaubt.
- Schreibzugriffe auf Live-Spielordner, `Documents\My Games`, `%LOCALAPPDATA%\Skyrim Special Edition` und Vortex sind tabu, außer der Entwickler gibt sie im Einzelfall frei.
