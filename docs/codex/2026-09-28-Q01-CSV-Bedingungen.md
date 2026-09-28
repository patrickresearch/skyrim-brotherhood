# Auftrag an Codex: Bedingungen in `dialogue/Q01.csv` an das Plugin angleichen

**Was:** Einige Einträge in der Spalte `Conditions` von `dialogue/Q01.csv` verweisen auf Globals, die es nicht
gibt, oder sind unvollständig. Beim Einbau ins Plugin (E32, 28.09.2026) wurden sie technisch ersetzt. Die CSV
ist die Quelle der Wahrheit (CLAUDE.md, Regel 4) und soll wieder mit dem Plugin übereinstimmen.

**Warum:** Sonst würde ein späterer Abgleich (`tools/csv_to_plugin.py`) die alten, nicht funktionierenden
Bedingungen zurückbringen.

**Wo/Format:** Nur die Spalte `Conditions` der betroffenen Zeilen in `dialogue/Q01.csv`; Texte nicht ändern.

| Stelle | Bisher in der CSV | Im Plugin umgesetzt |
|---|---|---|
| Stage-70-Urteil (Recruit/Release/Silence) | `GetGlobalValue NHV_Q01_Result == 0` | `GetStage NHV_Q01_TheUnansweredSacrament == 70` (das Urteil setzt Stage 100 und sperrt sich damit selbst) |
| Stage-100-Debrief mit Fragment | `GetGlobalValue NHV_Q01_FragmentFound ==` (Wert fehlt) | `GetItemCount NHV_Item_OculatusFragment1 >= 1` (Spieler) bzw. `== 0` für die Veyra-Übergabe |
| `Q01_Farm`-Zeilen mit Hrefna als Sprecherin (Stage 20) | Stage 20 | frühestens ab Stage 30 (vorher ist Hrefna nicht begegnet) |

**Randbedingungen:**
- Die exakten LineIDs stehen in `docs/dialogue/Q01-Gesamtdialoge-2026-09-28.md` bzw. im Plugin (ScriptNotes).
- Hinweis zu E32: Quintus' zwei Tötungsvarianten (Zimmer nachts / Straße morgens) laufen im Plugin vorerst
  über eine gemeinsame Szene. Falls die Zeilen dafür ortsgebunden formuliert sind („this room“, „this
  road“), bitte eine ortsneutrale Fassung vorschlagen oder vermerken.
- Nach der Änderung `python tools/dialogue_lint.py dialogue/` ausführen.
