# Plan: Q02 Cold Waters und Q03 The Scholar's Sin – Enhanced-Arc (neue Dialoge, erweiterte Story)

Stand: 01.10.2026. Auftrag des Entwicklers: Q02 und Q03 bekommen neue Dialoge und die erweiterte Story, gebaut nach dem Muster von Q01 Enhanced (E45). Diese Datei ist der Arbeitsplan für eine **frische Session**. Sie fasst auch die Lehren aus dem Q01-Test zusammen (Abschnitt 6), damit dieselben Fehler nicht noch einmal entstehen.

## 1. Rollen und Modelle

| Rolle | Modell | Aufgabe |
|---|---|---|
| Entwicklung | **Sonnet 5.5** (Subagent `general-purpose` mit `model: sonnet`) | Generator-Spezifikation, Scripts, Records per Spriggit-Text, CSV-Einarbeitung, Tests, CK-Anleitungen |
| Kontrolle und Feedback-Schleifen | **Opus 5.5** (Subagent `general-purpose` mit `model: opus`, dazu `papyrus-reviewer`, `lore-editor`) | Konzept- und Lore-Review, Code-Review, Abgleich Generator ↔ ESP, Befundliste, Freigabe je Phase |
| Hauptsession | Orchestrierung | Aufträge an die Subagents, Zusammenführen, Sync in die Dev-Kopie, Statuspflege |

**Schleife je Phase:** Sonnet liefert → Opus prüft (Befundliste mit Datei:Zeile, Schwere) → Sonnet arbeitet Befunde ein → Opus gibt frei. Höchstens drei Runden je Phase; offene Punkte kommen als Frage an den Entwickler.

## 2. Ausgangslage (zuerst prüfen, nicht annehmen)

- `docs/PROGRESS.md` (Kurzfassung, Nächster Schritt), `docs/ROADMAP.md` (M2.2, M2.3), `docs/DECISIONS.md` (E42 Map Table, E45 Q01 Enhanced, offene Entscheidungen E05, E16, E17; **nicht selbst festlegen**).
- Q02: Grundausbau ist im Plugin (M2.2, 50 Topics aus `dialogue/Q02.csv`, Szenen, Packages, Activators, Record-Builder `tools/build_q02_records.py`, Quest `NHV_Q02_ColdWaters` 004100). Enhanced-Draft: `dialogue/drafts/enhanced/Q02/` (Story-Arc, Lesefassung, `flow.json`, `Q02.csv`, `Journal.csv`, `Books.csv`, Charaktere, Items).
- Q03: Draft in `dialogue/drafts/enhanced/Q03/` und `dialogue/drafts/Q03-v2/`; ein Generator `tools/build_q03_enhanced.py` existiert. Plugin-Stand von Q03 prüfen (Quest, Records), er ist vermutlich nicht gebaut.
- Muster zum Nachbauen: `tools/build_q01_enhanced.py` und `tools/flow_compiler.py`, Doku in `docs/ARCHITECTURE.md` („Dialog-V2“), `docs/DECISIONS.md` E43–E45.
- Übergang von Q01: Map Table (`NHV_MapTableScript`, `docs/ck/M2.0-Map-Table.md`) und Veyras Hello am Table; Fallback-Option „Windhelm. I will take that name.“ (`NHV_Q01_100_2811`). Q03 startet nach Q02 ebenfalls über den Map Table (Button 1 „Winterhold“, Property `Q03`).

## 3. Phasen

### Phase A – Bestandsaufnahme und Design-Review (Opus, kein Code)
1. Opus liest Story-Arc, Lesefassung, `flow.json`, CSVs von Q02 und Q03 und vergleicht sie mit dem gebauten Stand und mit `docs/concept/` (Quelle der Wahrheit für Design). Ergebnis: **Lückenliste** (fehlende Zeilen, Bedingungen, Welt-Ereignisse, Objectives, Items) und **Lore-/Logikbefunde** (zum Beispiel Sprecher-Wechsel, tote Enden, Zustandsflags ohne Setzer).
2. Ergebnis wird als Befundliste in `docs/plan/Q02-Q03-Enhanced-Befunde.md` abgelegt. Entscheidungen, die das Konzept ändern, gehen als Frage an den Entwickler (nicht still ändern) und werden in `docs/DECISIONS.md` eingetragen (E46 ff.).

### Phase B – Q02 Enhanced bauen (Sonnet)
1. `tools/build_q02_enhanced.py` nach dem Muster von `build_q01_enhanced.py`: Knoten, Entries, `default_host`, Welt-Bedingungen, QF-Fragmente, Konstanten.
2. Neue Records (Items, Bücher, Activators, Packages, ggf. NPCs) per Spriggit-Text mit festen FormIDs im reservierten Bereich; Records, die der CK später besitzt, werden **nicht** vom Generator überschrieben (siehe Abschnitt 6, Punkt 1).
3. Scripts: Weltereignisse und Watches nach dem Q01-Muster (Abschnitt 6), kompilieren (`tools/build.ps1`), `papyrus-reviewer`.
4. Dialog: Einarbeitung nach `dialogue/Q02.csv` (Master) inkl. Journal und Bücher, `dialogue_lint.py`, `silent_voice.py`, `lore-editor`.
5. ESP schreiben (`plugin_text.ps1 ToPlugin`), Sync (`sync_dev.ps1 ToDev -IncludeEsp`) nur bei geschlossenem Spiel und CK.

### Phase C – Q03 Enhanced bauen (Sonnet)
Wie Phase B für Q03; zusätzlich: Start über den Map Table (Winterhold, Property `Q03` am Table-Script setzen – CK-Schritt, Script ist vorbereitet) und der Anschluss an Q02 (Abschluss Q02 → Veyra weist auf den Table, nach dem Muster `OpenMapTable()` in Q01).

### Phase D – Kontrolle (Opus, je Quest)
Checkliste für den Abgleich Generator ↔ ESP ↔ Scripts:
- jede **stille** Spielerzeile hat den richtigen Sprecher (`default_host`), keine Hubs bei Veyra, die zu Gesprächen mit anderen NPCs gehören;
- nach jedem Knoten-Code, der den Cursor setzt, wird der Cursor **nicht** vom Kettenende überschrieben (Aufrufe mit verzögertem Setzen);
- Package-Stage-Grenzen decken alle Stages ab (kein Spalt, keine Überlappung), Follow-Packages beginnen erst nach dem Gespräch, das sie auslöst;
- jeder Alias, auf den ein Script zugreift, hat eine Rückfalllösung (Ref aus FormID) und der Fallback springt nicht still auf die nächste Stage;
- keine Hello-Topics für Pflichtgespräche (stattdessen Hub mit Spielerzeile, siehe Lehren);
- jede Welt-Bedingung (Item im Inventar, Flag) hat einen Setzer im Script oder im CK-Platzierungsplan;
- Save-Kompatibilität (CLAUDE.md Regel 3): nur additive Änderungen.

### Phase E – CK-Anleitungen und Testpläne (Sonnet schreibt, Opus prüft auf Präzision)
Pflichtinhalt jeder Anleitung (Vorlage: `docs/ck/M1.7-Q01-Enhanced-CK-Anleitung.md`):
- **Pro Schritt**: Wo (Menü, Fenster, **Reiter**), Was (genaue Eingaben, EditorIDs, FormIDs), Ergebnis.
- **Jede Aufgabe ist klar markiert** als **NEU ERSTELLEN** (Record oder Ref fehlt im ESP), **NUR KONTROLLIEREN** (existiert, Werte prüfen) oder **ÄNDERN** (Wert ist falsch/fehlt).
- Vanilla-Namen mit Model-Pfad (zum Suchen im Object Window, geprüft über `housecarl_records`, nicht geraten).
- Koordinaten, Zellen und Abstände dort, wo Scripts sie brauchen (zum Beispiel „alle Soldaten in einer Zelle“).
- Checkliste am Ende; Rückmeldeformat („Q0x Enhanced im CK fertig“, Zellen melden für `docs/ARCHITECTURE.md`).
- Testplan unter `docs/tests/` mit erwarteten Log-Zeilen und Konsolenbefehlen (**kein `cqf`**, siehe unten).

### Phase F – Übergabe
Status in `docs/ROADMAP.md` auf „Test“, Eintrag in `docs/PROGRESS.md`, Commit-Vorschlag. „Fertig“ setzt nur der Entwickler nach dem Ingame-Test.

## 4. Reihenfolge und Abnahmen
A → (Abnahme durch den Entwickler: Lücken- und Entscheidungsliste) → B → D(Q02) → E(Q02) → C → D(Q03) → E(Q03) → F. Nach Q02 ein Ingame-Test, bevor Q03 gebaut wird (Fehler aus Q02 nicht in Q03 wiederholen).

## 5. Regeln (CLAUDE.md, unverändert)
Keine Vanilla-Records oder -Scripts ändern; nur im Repository arbeiten; Dialog nur über die CSV-Master-Dateien; keine neuen harten Abhängigkeiten; nichts als ingame funktionierend melden, bevor der Entwickler es getestet hat; **ein Schreiber am ESP zur Zeit** (nach Textänderungen öffnet und speichert der Entwickler das ESP einmal im CK); kein Commit/Push ohne Aufforderung. Kleine Textarbeiten darf Claude selbst machen (danach `lore-editor`), größere Texte gehen als Brief nach `docs/codex/`.

## 6. Lehren aus dem Q01-Test (verbindlich beachten)
1. **Generator-Bereinigung löscht CK-eigene Records:** `flow_compiler.clean_range` löscht beim Schreiben alle Dateien im ID-Bereich der Quest (bei Q01 0x7000–0x7FFF). Records, die der CK besitzt (NPC-Basen, Voice-Types, Misc-Items, Packages mit CK-Änderungen), **nach jedem Teilbuild aus dem ESP zurückholen** (Muster: `Spriggit convert-from-plugin` in ein Temp-Verzeichnis, fehlende Dateien kopieren) – oder die Records außerhalb des Bereichs anlegen. **Nie den Voll-Lauf `--write` benutzen**, wenn CK-Änderungen am NPC/Package existieren.
2. **Stille Spielerzeilen** (ohne NPC-Antwort) bekommen einen Antworttext `'...'` (leerer Text blendet das Thema aus) und müssen über `default_host` dem richtigen Gesprächspartner zugeordnet werden (Standard ist Veyra!).
3. **Kein Hello für Pflichtgespräche:** Hello zündet nur bei Nähe und passender Bedingung und lässt sich verpassen. Besser ein Hub mit einer Spielerzeile (immer anwählbar). Hello nur für Begrüßungen, die verzichtbar sind.
4. **Kettenende setzt den Cursor auf 0:** Knoten-Code, der den Cursor setzt, wird durch das Fragment am Kettenende überschrieben. Cursor verzögert setzen (Timer-Flag im Quest-Script, Beispiel `OpenMapTable()`).
5. **Ghost-Flag verhindert Gespräche** (Lucien, Scout). Nie `SetGhost(True)` auf Gesprächspartner.
6. **Optionale Aliase füllen sich nicht, wenn die Ref nicht geladen ist:** Script-Zugriff über `GetScout()`-Muster (Alias oder platzierte Ref per FormID, dann `ForceRefTo`); Fallback-Sprünge nur bei wirklich fehlender oder toter Ref.
7. **Lücken bei Package-Stage-Grenzen:** `CampWait` bis Stage 99 und ein Escort bis 59 haben Hrefna ab Stage 60 weglaufen lassen. Grenzen immer als Tabelle prüfen.
8. **Follow-Packages erst nach dem Gespräch:** Ein Escort ab Stage 48 schickt NPCs sofort los. Escort erst mit der Stage, die das Gespräch setzt.
9. **Ein Quest-Script, ein Timer:** `RegisterForSingleUpdate` überschreibt. Neue Watches in `OnUpdate` einhängen und in `RearmWatches()` eintragen.
10. **Nach jedem Generatorlauf** `silent_voice.py` ausführen (Dateinamen hängen an den INFO-FormIDs) und `dialogue_lint.py`.
11. **Konsole:** `cqf` funktioniert beim Entwickler nicht. Rettungs- und Testwege **im Script oder Dialog** bauen. Refs sind in der Konsole nur per FormID ansprechbar (`prid 06xxxxxx`, Slot 06).
12. **Map-Table-Aktivierung:** Die Vanilla-Karte `CWMap02` ist eine flache Platte ohne Kollision und nicht anklickbar. Ersetzt durch eigenen Activator `NHV_Act_MapTable` (Model `CWMapMarkers02.nif`) plus Static `CivilWarMap02` für die Optik. Fallback: Veyras Gesprächsoption.
13. **Logs:** Das Spiel schreibt `Papyrus.0.log` in den Documents-Ordner; der Entwickler kopiert es ins Repo-Root. Auf den Zeitstempel achten (ein altes Log ist wertlos). Den Documents-Ordner liest Claude nicht.
14. **ESP-Sync nur bei geschlossenem Spiel** (die Datei ist sonst gesperrt). Skripte lassen sich auch bei laufendem Spiel kopieren, wirken aber erst nach dem Laden eines Saves.
15. **Konzept ist die Quelle der Wahrheit** (`docs/concept/`). Abweichungen als Frage, nicht als Fakt.
