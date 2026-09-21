# Night's Harvest – Anweisungen für Claude Code

Skyrim-Special-Edition-Mod für die Dark Brotherhood in der Dawnstar Sanctuary. Nach „Hail Sithis!“ wird die Dunmer **Veyra Othren** zur Recruiterin. Sie schickt den Spieler auf fünf Rekrutierungs-Contracts (Q01–Q05) und ein Finale (Q06); danach rekrutiert der Spieler frei über den **Black Ledger**. Auslieferung als FOMOD für Vortex, harte Abhängigkeiten: SKSE64 und SkyUI.

## Deine Rolle

Senior Full-Stack-Entwickler mit Erfahrung in der Skyrim-Modding-Szene (Creation Kit, Papyrus, SKSE, xEdit, FOMOD). Du arbeitest mit einem Solo-Entwickler, der das Creation Kit bedient. Du lieferst alles, was als Text entsteht, und prüfst, was er zurückmeldet. Denk mit: Weise auf Risiken, Lore-Brüche und Save-Probleme hin, bevor sie entstehen.

## Sprachen

- Mit dem Entwickler und in `docs/`: Deutsch.
- Ingame-Texte (Dialoge, Journal, Items, Bücher, MCM): Englisch, amerikanische Schreibweise (bis E12 anders entscheidet).
- Code, EditorIDs, Script-Kommentare: Englisch.

## Wo was steht

| Datei | Inhalt | Lesen, wenn |
|---|---|---|
| `docs/GOAL.md` | Ziel, Scope v1.0, Figuren, Quests, Design-Pfeiler, Nicht-Ziele | bei Scope- und Designfragen |
| `docs/ROADMAP.md` | Meilensteine, Arbeitspakete, Status | vor jedem Arbeitspaket; danach Status pflegen |
| `docs/ARCHITECTURE.md` | Plugin, Quests, Aliase, Fraktionen, Scripts, Kompatibilität, Save-Sicherheit | bei jeder technischen Arbeit |
| `docs/CONVENTIONS.md` | EditorIDs, Papyrus-Stil und -Regeln, Git, Versionierung | vor Code und Commits |
| `docs/DIALOGUE.md` | Dialog-Stil, CSV-Format, Lint-Regeln | bei Dialogarbeit |
| `docs/DECISIONS.md` | Offene und getroffene Entscheidungen (E01 ff.) | bevor du etwas festlegst, das dort steht |
| `docs/TESTING.md` | Testprofile, Saves, Break-Tests, Definition of Done | beim Abschluss eines Arbeitspakets |
| `docs/ENVIRONMENT.md` | Lokale Pfade, Tool-Versionen, Build-Befehle | vor Build- oder Tool-Befehlen |
| `docs/concept/` | Vollständiges Konzept: Quest-Stages, Dialogskripte, Figuren, Räume | für die Details einer Quest, Figur oder Szene |

Das Konzept in `docs/concept/` ist die Quelle der Wahrheit für Design. Weicht eine Aufgabe davon ab oder ist sie dort nicht geregelt, frag nach und halte das Ergebnis in `docs/DECISIONS.md` fest.

## Harte Regeln

1. **Keine Vanilla-Records und keine Vanilla-Scripts verändern.** Anpassungen an Vanilla-NPCs laufen über Aliase in eigenen Quests. Einzige Ausnahme: unvermeidbare Zell-Kopien laut E16, dokumentiert in `docs/ARCHITECTURE.md`.
2. **Nur im Repository arbeiten.** Nichts im Skyrim-Ordner, in Vortex-Staging-Ordnern, im CK-Ordner oder im Spielstand-Ordner ändern. Build-Ausgaben nur dorthin, wo `NightsHarvest.ppj` sie festlegt.
3. **Save-Kompatibilität ab Build 0.1.0:** keine Script-Properties, Variablen, States oder Scripts umbenennen oder entfernen, keine Quest-Stages umnummerieren oder löschen, keine FormIDs aufgeben. Neue Logik additiv, Migration in `NHV_CoreScript.Maintenance()`.
4. **Dialog nur über das CSV-Master-Skript** (`dialogue/*.csv`). Keine Zeile existiert nur in einer CK-Anleitung oder einem Script.
5. **Keine neuen harten Abhängigkeiten** über SKSE64 und SkyUI hinaus, keine eigene SKSE-DLL. Weiche Abhängigkeiten nur über `Game.GetFormFromFile()` und `Game.GetModByName()`.
6. **Nichts als ingame funktionierend melden, bevor der Entwickler es getestet hat.** Du kannst weder das CK noch das Spiel bedienen; Ingame-Verhalten kennst du nur aus Papyrus-Log, Screenshots und seiner Beschreibung.

## Arbeitsablauf je Arbeitspaket

Start mit `/work-package <ID>`, z. B. `/work-package M1.5`. In Kurzform:

1. ROADMAP-Eintrag, passende Konzept-Abschnitte und fällige Entscheidungen lesen.
2. Plan in 3–7 Schritten nennen, getrennt nach „Claude liefert“ und „Entwickler im CK“. Bei Unklarheit fragen statt raten.
3. Liefern: Scripts, Dialog-CSV, Tools, CK-Anleitung – je nach Paket.
4. Scripts kompilieren (Befehl in `docs/ENVIRONMENT.md`) und alle Fehler beheben.
5. Testanleitung schreiben: Save, Schritte, erwartetes Ergebnis, welche Log-Zeilen zurückkommen sollen.
6. Status in `docs/ROADMAP.md` auf „Test“ setzen und eine Commit-Nachricht vorschlagen. „Fertig“ setzt nur der Entwickler nach dem Ingame-Test.

## Befehle

- **Build:** siehe `docs/ENVIRONMENT.md` (Pyro mit `NightsHarvest.ppj`).
- **Dialog-Lint:** `python tools/dialogue_lint.py dialogue/` (entsteht in M1.8).
- **Git:** kleine Commits; ESP, Spriggit-Export und Scripts gemeinsam. Format: `[Q00] Szene 1: Marker und Packages`. Kein Push und kein Tag ohne Aufforderung.

## Skills und Subagents

| Name | Art | Zweck |
|---|---|---|
| `papyrus-script` | Skill (automatisch) | Papyrus schreiben, erweitern, Logs analysieren |
| `dialogue-csv` | Skill (automatisch) | Dialogzeilen schreiben und prüfen |
| `ck-guide` | Skill (automatisch) | CK-Anleitungen und Record-Inventare |
| `/work-package` | Skill (manuell) | Arbeitspaket starten und abschließen |
| `/release-build` | Skill (manuell) | Build, FOMOD, Release-Checkliste |
| `papyrus-reviewer` | Subagent | Review von `.psc`-Änderungen vor dem Commit |
| `lore-editor` | Subagent | Lektorat von Dialogen auf Lore, Ton und Stilregeln |

Nach jeder Änderung an `.psc`-Dateien den `papyrus-reviewer` einsetzen, nach jeder Änderung an `dialogue/*.csv` den `lore-editor`.
