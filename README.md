# Night's Harvest

Skyrim-Special-Edition-Mod für die Dark Brotherhood. Nach „Hail Sithis!“ taucht die Dunmer **Veyra Othren** in der Dawnstar Sanctuary auf, öffnet einen versiegelten Flügel und schickt den Spieler auf fünf Rekrutierungs-Contracts (Q01–Q05) und ein Finale (Q06). Danach rekrutiert der Spieler frei über den Black Ledger.

- **Plugin:** `NightsHarvest.esp`, EditorID-Präfix `NHV_`
- **Plattform:** Skyrim SE 1.5.97 und AE 1.6.x, nur PC
- **Abhängigkeiten:** SKSE64, SkyUI
- **Auslieferung:** FOMOD für Vortex (auch MO2)
- **Stand:** M0 Setup & Toolchain, siehe [docs/ROADMAP.md](docs/ROADMAP.md)

## Struktur

```text
CLAUDE.md          Anweisungen für Claude Code
.claude/           Skills und Subagents
.github/           Label-Definition, Issue-Template
Data/              Mod-Staging (ESP, Source/Scripts, Interface/Translations)
plugin-text/       Spriggit-Export des ESP
dialogue/          CSV-Master-Skript aller Ingame-Texte
tools/             Python-Tools (Lint, GitHub-Setup)
fomod/             info.xml, ModuleConfig.xml, Bilder
docs/              Ziel, Roadmap, Architektur, Konventionen, Konzept, Test- und CK-Protokolle
```

Kompilierte Scripts (`.pex`), BSA und Release-Archive werden nicht versioniert; Pyro erzeugt sie aus `NightsHarvest.ppj`.

## Dokumentation

| Datei | Inhalt |
|---|---|
| [docs/GOAL.md](docs/GOAL.md) | Ziel, Scope v1.0, Figuren, Quests |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Meilensteine, Arbeitspakete, Status |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Plugin, Quests, Aliase, Scripts, Save-Sicherheit |
| [docs/CONVENTIONS.md](docs/CONVENTIONS.md) | EditorIDs, Papyrus-Regeln, Git, Versionierung |
| [docs/DIALOGUE.md](docs/DIALOGUE.md) | Dialog-Stil und CSV-Format |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Entscheidungen E01 ff. |
| [docs/TESTING.md](docs/TESTING.md) | Testprofile, Break-Tests, Definition of Done |
| [docs/ENVIRONMENT.md](docs/ENVIRONMENT.md) | Lokale Pfade und Build-Befehle |
| [docs/TOOLING.md](docs/TOOLING.md) | Benötigte Werkzeuge, MCP-Optionen für das ESP |
| [docs/concept/](docs/concept/) | Vollständiges Konzept (Quelle der Wahrheit für Design) |

## Arbeitsweise

- Das ESP wird nur im Creation Kit bearbeitet. Jede CK-Session endet mit einem Export nach `plugin-text/` und einem Commit.
- `main` ist immer spielbar. Commit-Format: `[Q00] Szene 1: Marker und Packages`.
- Ab Build 0.1.0 gelten die Save-Regeln aus [docs/CONVENTIONS.md](docs/CONVENTIONS.md): nichts umbenennen oder entfernen, nur additiv erweitern.

## GitHub einrichten (einmalig)

1. Privates Repository anlegen und das lokale Repo verbinden (`origin`, erster Push).
2. Labels anlegen: `python tools/github_setup.py` (mit `gh`, `--dry-run` zeigt vorher die Befehle).
3. Project-Board „Night's Harvest“ mit den Spalten Backlog → Bereit → In Arbeit → Test → Fertig anlegen und mit dem Repository verknüpfen.
