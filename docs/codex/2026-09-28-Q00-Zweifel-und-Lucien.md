# Auftrag an Codex: Q00-Nachgespräch „Zweifel“ und Luciens Geist

**Was:** Neue Zeilen für das Ende von Q00 und für einen dauerhaften Geist in der Deep Sanctuary:
1. **Veyra – Zweifel (neue Stage 80, nach der Contract-Szene, vor Stage 100):** Veyra spricht den Spieler an; sie
   spürt, dass er ihr noch nicht ganz traut. Sie bietet an, jemanden zu rufen, den der Listener bereits getroffen hat
   und der für sie bürgen kann, dass sie im Namen Sithis' arbeitet. Spieleroptionen: annehmen / ablehnen
   (höflich oder schroff). Beide Wege beenden Q00; danach startet Q01 automatisch.
2. **Später nachholen:** Ein Thema bei Veyra, solange Lucien noch nicht gerufen wurde („About the one who could vouch
   for you…“), mit derselben Annahme-Reaktion.
3. **Die Beschwörung:** 1–2 Zeilen Veyra während des Rufs, dann Luciens erste Worte beim Erscheinen.
4. **Lucien – Stage-Gespräch:** Der Spieler fragt Lucien nach Veyra. Lucien bestätigt, dass er sie kennt, und bürgt
   für sie. 3–5 Zeilen, dazu 1–2 Spielerprompts.
5. **Lucien – dauerhafte Gespräche (questunabhängig):** 5–8 kurze Themen zur Dark Brotherhood und seiner
   Vergangenheit (z. B. Cheydinhal, die Speaker-Rolle, der Verrat an der Familie seiner Zeit, das Leben als
   Spectral Assassin, der neue Listener, Veyra aus seiner Sicht). Je Thema 1 Spielerprompt, 2–4 Antwortzeilen.

**Warum:** Wunsch des Entwicklers (28.09.2026). Lucien wird ein dauerhafter Bewohner der Deep Sanctuary.

**Wo/Format:** Neue Zeilen in `dialogue/Q00.csv` (Stage 80, Topics z. B. `Veyra_Doubt`, `Veyra_DoubtRetry`,
`Veyra_Summon`, `Lucien_Vouch`) und für die dauerhaften Gespräche eine neue Datei `dialogue/Lucien.csv`
(Quest `NHV_Sys_Sanctuary` oder wie in deinem Schema üblich). Journal: eine Zeile für Stage 80 in
`dialogue/Journal.csv`. LineIDs nach deinem Schema; Speaker `Veyra` bzw. `Lucien`.

**Randbedingungen:**
- **Lore:** Lucien Lachance, Speaker der Dark Brotherhood in Cyrodiil (Cheydinhal-Sanctuary, Oblivion-Ära), vor
  rund 200 Jahren gestorben; in Skyrim erscheint er als Spectral Assassin im Dienst des Listeners. Veyra diente
  laut Konzept u. a. in Bravil und Cheydinhal („once of Cheydinhal“) – Lucien kann sie also aus jener Zeit kennen.
  Er kennt den Spieler, falls dieser ihn schon beschworen hat; formuliere so, dass es auch ohne diese Begegnung
  funktioniert („the Listener has heard of me“ o. ä.) oder vermerke die Bedingung.
- **E23 bleibt hart:** Lucien bürgt für Veyras Treue zu Sithis, verrät aber nichts über ihre Natur oder Herkunft;
  er darf andeuten, dass sie „schon damals“ unverändert war, ohne es zu erklären.
- **Ton:** Lucien höflich, trocken, leicht theatralisch, loyal zur Familie; keine Wiederholung von Vanilla-Zeilen.
- Vertonung: Lucien über xVASynth (falls Modell vorhanden), Veyra über ElevenLabs – kurze, gut sprechbare Sätze.
- Autorenprofil `docs/concept/Veyra-Autorenprofil.md`; amerikanische Schreibweise; danach `python tools/dialogue_lint.py dialogue/`.
