# Auftrag an Codex: Die Familie spricht über Veyra (questunabhängig)

**Was:** Ergänzungen in `dialogue/Sanctuary.csv`: je ein Thema „über Veyra“ für **Babette** und **Cicero** (Nazir hat
`Nazir_Veyra` schon), dazu ein kurzes Thema bei **Veyra** selbst, in dem der Spieler sie fragt, wie die Familie sie
aufnimmt. Je Thema 1 Spielerprompt + 2–4 Antwortzeilen, gern mit einer kurzen Nachfrage (`…Follow`).

**Warum:** Entwicklerwunsch (29.09.2026): Veyra und die Vanilla-Familie sollen auch außerhalb einer Quest-Stage über
Veyra ansprechbar sein – für mehr Immersion.

**Wo/Format:** `dialogue/Sanctuary.csv`, gleiches Schema wie die bestehenden Themen (`Babette_Veyra`,
`Babette_VeyraFollow`, `Cicero_Veyra`, `Cicero_VeyraFollow`, `Veyra_Family`, `Veyra_FamilyFollow`). Bedingung:
ab Q00 Stage 100 (Veyra ist Teil der Familie).

**Randbedingungen:**
- Babette: trocken, spöttisch, jahrhundertealt im Kinderkörper; misstrauisch-neugierig gegenüber einer Frau, die
  „älter wirkt, als sie aussieht“.
- Cicero: sprunghaft, Night-Mother-fixiert; die Night Mother hat Veyra anerkannt – das ärgert und fasziniert ihn.
  Varianten, falls Cicero tot ist, sind nicht nötig (dann erscheint das Thema nicht).
- E23: keine Aussage über Veyras Natur/Herkunft; Andeutungen erlaubt.
- Kurze, gut sprechbare Sätze (Vertonung: xVASynth bzw. ElevenLabs). Danach `python tools/dialogue_lint.py dialogue/`.
