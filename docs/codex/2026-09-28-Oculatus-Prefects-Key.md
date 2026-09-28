# Auftrag: Oculatus Prefect's Key (Chiffre-Schlüssel)

**Wofür:** Neues Buch `NHV_Book_PrefectsKey`, Teil des Hauptbogen-Vorschlags V3 (`docs/plan/
Hauptbogen-Oculatus.md`, Abschnitt 2.4). Erklärt dem Spieler die einfache Verschiebe-Chiffre, mit der die
fünf `[cipher]`-Stellen in den Oculatus Dispatches (`B03_Builders_Record_and_Oculatus_Dispatches.md`)
verschlüsselt sind. Fundort noch offen (Livia Maro in Q06 oder Aelius in Q02) – Text so schreiben, dass er an
beiden Fundorten funktioniert (kein Verweis auf einen bestimmten Fundort im Text selbst).

**Was schreiben:**
1. Das Buch selbst (ca. 100–150 Wörter): ein knappes, bürokratisches Penitus-Oculatus-Schreiben (interner
   Chiffre-Schlüssel für Feldagenten), Ton trocken-militärisch, keine Erklärung „für den Spieler“ – es liest
   sich wie ein echtes internes Dokument, das der Prefect an seine Agenten ausgegeben hat. Es soll eine simple
   Buchstaben-Verschiebung (Caesar-Shift, fester Wert, vom Entwickler im CK frei wählbar) beschreiben, ohne
   dass die konkrete Verschiebungszahl zwingend im Fließtext stehen muss – Codex kann eine Zahl frei wählen
   oder sie als Platzhalter `<SHIFT>` markieren, das legt der Entwickler im CK fest.
2. Fünf kurze „Decoded“-Ergänzungstexte (`NHV_Note_Dispatch01_Decoded` bis `_05`), je 15–30 Wörter: die
   aufgelöste Klartext-Version der `[cipher]`-Stellen in den fünf Original-Fragmenten (siehe Quelle unten,
   jede `[cipher]`-Markierung braucht einen Ersatztext). Inhalt soll den roten Faden vertiefen, nicht
   widersprechen – z. B. konkretere Hinweise auf Methoden des Zirkels, Namen von Informanten, oder eine
   Andeutung auf Zweifel innerhalb des Zirkels (Anschluss an Vorschlag V5 „The Doubter“, optional).

**Speichern:** Nicht in `dialogue/*.csv` (das sind Bücher, keine Dialogzeilen) – Format und Ablage laut
`docs/DIALOGUE.md` für Bücher klären; vorläufig als Fließtext in dieser Antwort liefern, Claude überträgt es
danach in die richtige Struktur (Buch-Record-Text, kein CSV-Import nötig).

**Grenzen:** Amerikanisches Englisch. Keine neuen Lore-Fakten über Livia Maros tatsächliche Pläne, die dem
Finale (`Q06_Blood_Harvest.md`) widersprechen. Keine Enthüllung von Veyras Herkunft (E23 ist mod-interne
Autorenwahrheit, nicht objektiv im Buch bestätigbar). Kein Bezug auf ein Artefakt oder Ritual (siehe
Lore-Grenze in `docs/concept/Veyra-Autorenprofil.md`).

**Technik:** Claude legt daraus 1 Buch-Record (`NHV_Book_PrefectsKey`) und 5 Buch-Records (additiv zu den
bestehenden Dispatches, keine Änderung der Originale) an. Kein Script nötig (Variante A aus
`docs/plan/Hauptbogen-Technik.md` Abschnitt 3: Veyra decodiert per Dialog, kein `OnItemAdded`).

**Quelle für die `[cipher]`-Stellen:** `dialogue/NightsHarvest-dialoge-und-lore/dialogue/books/
B03_Builders_Record_and_Oculatus_Dispatches.md`, Fragmente I–V (Register of Sacraments, List of Informants,
Order for Whisperbane, Notes for the Prefect, Contract of Blades) – Claude liefert bei Bedarf den vollen
Fragmenttext auf Anfrage, hier nur als Referenz genannt, um den Auftrag kurz zu halten.
