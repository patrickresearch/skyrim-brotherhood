---
name: dialogue-csv
description: Dialogzeilen und Ingame-Texte für Night's Harvest schreiben, überarbeiten oder prüfen – im CSV-Master-Skript unter dialogue/, auf Englisch, im Ton der Dark Brotherhood. Verwenden bei neuen Szenen, Quest-Dialogen, Banter, Greetings, Kampf- und Follower-Zeilen, Speech-Checks, Journaleinträgen, Büchern oder Briefen, beim Kürzen oder Vertonen von Zeilen und beim Abgleich mit dem CK-Export.
---

# Dialog-CSV für Night's Harvest

Das CSV-Master-Skript ist die einzige Quelle für Ingame-Text. Aus ihm entstehen CK-Einträge, Übersetzungen und später die Vertonung. Eine Zeile, die nur im CK oder in einem Script steht, geht für all das verloren.

## Ablauf

1. **Kontext laden:** Konzept-Abschnitt der Quest (Stages, Entscheidungstabelle, vorhandenes Skript), Charakterbogen der Sprecher (Abschnitte 3, 9, 11), `docs/DIALOGUE.md`.
2. **Bestand prüfen:** Gibt es die Szene schon in `dialogue/<Quest>.csv`? Konzept-Skripte (z. B. Q00) werden übernommen, nicht neu erfunden; Abweichungen nur mit Begründung in `Notes`.
3. **Schreiben:** Zeilen im CSV-Format aus `docs/DIALOGUE.md`. `LineID`s im Format `NHV_<Quest>_<Stage>_<Nr.>`, nie eine alte ID wiederverwenden.
4. **Prüfen:** `python tools/dialogue_lint.py dialogue/` ausführen (sobald vorhanden), danach Subagent `lore-editor` auf die geänderten Zeilen ansetzen.
5. **Übergabe:** Zusammenfassung mit neuen und geänderten LineIDs, Topics und Conditions; bei Bedarf CK-Anleitung über den Skill `ck-guide`.

## Handwerk

- **Eine Absicht pro Response.** Lieber drei kurze Responses als eine lange.
- **Subtext statt Erklärung.** Figuren wissen, was sie meinen; sie sagen es selten direkt.
- **Spielerzeilen** als Haltung formulieren, nicht als Frage nach Information („I don't bargain with ghosts.“ statt „What do you want?“), maximal 80 Zeichen. Jede Wahl muss in 2 Sekunden lesbar sein.
- **Entscheidungen hörbar machen:** Wenn eine Wahl Folgen hat, reagieren später mindestens eine Figur und das Journal darauf.
- **Vertonbarkeit:** Keine Zahlen in Ziffern, keine Abkürzungen, keine Klammern im gesprochenen Text. Emotion und Stärke für jede NPC-Zeile setzen.
- **Figurenstimme:** Vor dem Schreiben die Sprechproben der Figur im Konzept lesen. Kurze Probe laut „hören“: Könnte diese Zeile auch eine andere Figur sagen? Dann umschreiben.
- **Lore:** Nur Begriffe und Fakten, die im Konzept oder in der Vanilla-Lore belegt sind. Unsicheres markieren (`Notes: LORE-CHECK`), nicht erfinden.

## Journal, Bücher, Briefe

- Journal-Ziele knapp und im Imperativ („Speak with Veyra in the Sanctuary“), Quest-Beschreibungen in der zweiten Person, Vergangenheitsform, 1–3 Sätze pro Stage.
- Bücher und Briefe (z. B. Dispatch-Fragmente) in eigener Datei `dialogue/Books.csv` mit `Speaker = Book` und dem Titel in `Topic`.

## Lieferformat

```markdown
### Dialog <Quest> – <Szene/Thema>
Datei: dialogue/<Quest>.csv  |  Neu: <Anzahl>  |  Geändert: <Anzahl>
| LineID | Sprecher | Text (gekürzt) | Condition |
Lint: grün/rot (Befunde)  |  lore-editor: offen/erledigt
Offene Fragen: …
```
