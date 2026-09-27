# Auftrag an Codex: Inschriften der Gedenkplaketten (Q00, Memorial Wall)

**Was:** Inschriften für sechs Namensplaketten an der Memorial Wall der Deep Sanctuary: Festus Krex, Gabriella,
Arnbjorn, Veezara, Astrid (Wahl 1: bei den anderen) und Astrid (Wahl 3: darunter, kleiner).

**Warum:** Nach Veyras Zeremonie (Q00 Stage 60, Konzept Szene 5) werden die Plaketten eingeblendet. Derzeit tragen
sie nur den Vanilla-Namen als Record-Name (Platzhalter).

**Wo/Format:**
- Neue Zeilen in `dialogue/Books.csv` (oder einer eigenen CSV, falls dir das lieber ist), Topic `MemorialPlaques`,
  Speaker `Book`, Stage 60, je eine Zeile pro Plakette; LineIDs fortlaufend nach deinem Schema.
- Pro Plakette: **Name** (Crosshair-Text, max. ca. 40 Zeichen, z. B. „Festus Krex“ oder „Festus Krex, Mage of the
  Family“) und optional ein **Epitaph** (ein Satz, max. ca. 120 Zeichen) für eine spätere Lesefunktion.
- Notes-Spalte: Record `NHV_Act_Q00_Plaque<Name>` (003DA1–A5); Astrid klein nutzt denselben Record wie Astrid groß
  – falls die kleine Variante einen anderen Text braucht, bitte vermerken, dann lege ich einen sechsten Record an.

**Randbedingungen:**
- Veyra hat die Namen selbst gemeißelt („I'll carve their names myself“): nüchtern, würdevoll, keine Heldenpathos.
- Astrid klein: „Remembered, but not honored“ – das darf die Inschrift spüren lassen, ohne zu urteilen.
- Lore: Namen und Rollen wie in Vanilla; kein Nachname für Gabriella, Arnbjorn, Veezara, Astrid erfinden.
- Autorenprofil `docs/concept/Veyra-Autorenprofil.md`; amerikanische Schreibweise.
