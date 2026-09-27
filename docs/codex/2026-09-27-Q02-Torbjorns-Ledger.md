# Auftrag: Q02 – Nebenaufgabe „Torbjorn's Ledger“ (Vorschlag, nicht im Konzept)

**Wofür:** [Vorschlag] optionale Nebenaufgabe zu Q02 „Cold Waters“, siehe
`docs/plan/Q02-Cold-Waters.md` Abschnitt 7. Drei kurze Hafenlog-Notizen, verstreut in
`WindhelmWarehouse` und `WindhelmBloodworks`, aus Torbjorn Ice-Veins nüchterner Sicht auf die vier
früheren Ertrunkenen. Rein atmosphärisch, ändert nichts an Sings' Schicksal. **Nur schreiben, wenn
der Entwickler diese Nebenaufgabe bestätigt hat** – sie ist noch keine getroffene Entscheidung.

**Was schreiben:**
- Drei kurze Notizen (Buch-Text, je 3–5 Sätze), Ich-Perspektive Torbjorns oder Log-Stil
  (Datum/Name/Kurzvermerk), passend zu seinem Charakter aus
  `docs/concept/Q02-Nebenfiguren-Autorenprofile.md`: mürrisch, praktisch, zählt statt zu trauern.
  Jede Notiz nennt knapp einen der vier früheren Toten (Name frei erfinden, Nord, keine Überschneidung
  mit Hauptplot-Namen).
- Eine zusätzliche Torbjorn-Debriefzeile (1 Satz), gesprochen, sobald der Spieler alle drei Notizen
  hat.

**Speichern:** Notizen als neue Book-Einträge in `dialogue/Books.csv` (gleiche Spaltenstruktur wie
`NHV_SYS_BOOK_82`), Quest `Q02`, Stage 10, Records `NHV_Book_Q02_HarborLog01`/`02`/`03`
(siehe `docs/plan/Q02-Records.md`). Die gesprochene Torbjorn-Zeile in `dialogue/Q02.csv`, Topic
`Q02_Docks`, Speaker `Torbjorn`, LineID `NHV_Q02_010_9x` (nächste freie Nummer nach `010_41`).

**Grenzen:** Amerikanische Schreibweise, keine neuen Lore-Fakten über die Haupthandlung, keine
Wiederholung der Knoten-/Nachtwache-Hinweise (die gehören zum Hauptpfad, nicht zu dieser
Nebenaufgabe). Notizen dürfen keine Ortsangaben enthalten, die im CK schwer umzusetzen wären
(einfach: „auf einem Regal“, „in einer Kiste“).

**Technik:** `NHV_Q02Script.CompleteSideQuestA()` (bereits implementiert) prüft
`GetItemCount` auf alle drei Bücher und schaltet danach 50 Gold plus die Debriefzeile frei.
