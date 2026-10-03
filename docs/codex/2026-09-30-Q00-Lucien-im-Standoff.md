# Auftrag: Q00 – Luciens Beschwörung ans Ende des Standoffs verlegen (E41)

> **Update 30.09.2026:** Grundlage ist jetzt die V2-Fassung `dialogue/drafts/Q00-v2/Q00.csv`, nicht der
> alte Master. Welche V2-Zeilen (`080_1000–1008`, `100_1000–1027`) passen, entfallen oder umformuliert
> werden müssen, steht in `docs/dialogue/V2-Einbau-Pruefung-2026-09-30.md`, Abschnitt „Q00 – Befunde“.
> Änderungen bitte direkt in der V2-CSV, mit neuen LineIDs `NHV_Q00_012_1000` ff. für Stage 12.

**Wofür:** Q00 „A Shadow at the Door“. Bisher bot Veyra Luciens Geist erst **nach dem ersten Contract**
als Zeugen an (Stage 80, E35: annehmen / höflich ablehnen / schroff ablehnen). Neu (E41, Entwickler
30.09.2026): Veyra ist im Standoff gerade zum ersten Mal aufgetaucht, niemand kann sie einschätzen.
Genau dort ruft sie **verpflichtend** Lucien als Bürgen. Danach geht es wie bisher weiter
(Veyra verlässt die Sanctuary, Stage 15/20 Night Mother).

**Neuer Ablauf:**
1. Standoff-Befragung wie bisher (E22): freie Fragen, dann eine ausdrückliche Abschlusswahl.
2. **Neu, Stage 12:** Nach jeder Abschlusswahl (Urteil der Night Mother / Drohung / Verweisung)
   ruft Veyra Lucien. Keine Ablehnungsoption. Lucien erscheint, bürgt für ihre freiwillige Treue zu
   Sithis (Bekanntschaft aus Cheydinhal, E35-Lore bleibt), löst sich wieder auf.
3. Stage 15: Veyra verlässt die Sanctuary, Stage 20: Night Mother – unverändert.
4. Nach Öffnung der Deep Sanctuary (ab Stage 50) steht Lucien dort dauerhaft, mit seinen sieben
   Dauerthemen (`dialogue/Lucien.csv`, bleiben).
5. Stage 80 (Zweifel-Angebot) **entfällt**. Nach dem Contract endet Q00 direkt mit Stage 100.

**Was schreiben / anpassen:**
- **Ruf im Standoff** (ersetzt `NHV_Q00_080_*` und die Annahme-Einstiege): Veyra kündigt an, dass sie
  jemanden ruft, den die Familie kennt; Übergang aus allen drei Abschlusswahlen, auch aus Drohung und
  Verweisung (dort mit Trotz statt Einverständnis). 2–4 Zeilen Veyra.
- **Ruf- und Ankunftszeilen** `SYS_LUC_02–06`: an den neuen Kontext anpassen. Nazir ist anwesend und
  misstrauisch, Babette und Cicero ggf. in Hörweite. Kein „du hast mir nach dem Contract misstraut“.
- **Bürgschaft** (`Lucien_Vouch`/`Lucien_VouchEnd`): an den Standoff anpassen. Optional je eine kurze
  Reaktion von Nazir (1 Zeile) nach der Bürgschaft.
- **Abgang:** 1 Zeile Lucien, bevor er sich auflöst (Andeutung, dass er zurückkehrt, ohne die Deep
  Sanctuary zu verraten).
- **Wiedersehen:** 1 Zeile Lucien beim ersten Ansprechen in der Deep Sanctuary.
- **Journal:** Stage-12-Eintrag (EN), z. B. Richtung „Witness Veyra's proof.“; `NHV_Q00_080_09` wird
  nicht mehr verwendet.

**Speichern:** `dialogue/Q00.csv`, `dialogue/Lucien.csv`, `dialogue/Journal.csv`. Neue LineIDs im
Schema `NHV_Q00_012_<Nr>`; bestehende LineIDs nicht umnummerieren. Nicht mehr benutzte Zeilen
(`NHV_Q00_080_*`, Retry-Einstieg `SYS_LUC_01`) nicht löschen, sondern in der Notes-Spalte als
`obsolete (E41)` markieren.

**Grenzen:** Amerikanische Schreibweise. E23 (Veyras Herkunft) bleibt verborgen. Keine frühere
Vanilla-Beschwörung Luciens voraussetzen. Keine Enthüllungen zu Q01–Q06. Ton der bestehenden
Standoff-Zeilen halten.

**Technik (Claude, nach der Textlieferung):** Stage 12 in `NHV_Q00`, Abschlusswahlen des Standoffs
setzen 12 statt 15; Ruf/Ankunft/Bürgschaft als Szene; Ende setzt 15. Stage-80-Zweig und
Drei-Tage-Fallback im Core stilllegen (Save-sicher, additiv). Lucien nach der Bürgschaft deaktivieren,
ab Stage 50 am `NHV_Mk_Sys_LucienSpot` aktivieren.
