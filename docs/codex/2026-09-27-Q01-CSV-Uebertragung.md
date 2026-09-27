# Auftrag: Q01-CSV-Uebertragung

**Wofür:** Quest Q01 „The Unanswered Sacrament" (Hrefna Stormhollow, Morthal/Hjaalmarch). Die komplette
Questline ist bereits als fertiges Dialogskript vorhanden, aber noch nicht im CSV-Master-Format
angelegt. `dialogue/Q01.csv` existiert noch nicht.

**Was schreiben:** Keine neuen Zeilen erfinden – die Zeilen stehen schon vollständig in
`dialogue/NightsHarvest-dialoge-und-lore/dialogue/script/Q01_The_Unanswered_Sacrament.md`
(Whisper/Hunt/Observation/Trial/Judgement/Homecoming, LineIDs `010_01`…`100_30`) und in
`dialogue/NightsHarvest-dialoge-und-lore/dialogue/script/FAM_Hrefna.md` (Alltag/Follower/Kampf/
Persönliches, LineIDs `HRE_001`…`HRE_153`). Bitte beide Quellen 1:1 in das CSV-Master-Format von
`docs/DIALOGUE.md` übertragen: pro Zeile Topic-Name, Sprecher, Emotion, Text, Bedingungen/Regie aus der
Spalte „Bedingung / Regie" in eine Conditions-Spalte übersetzen (z. B. „→ Stage 40" wird zur
Stage-Bedingung, „[Flag Unproven]" zur Global-Bedingung `NHV_Flag_HrefnaUnproven == 1`, „auf FAM_01" zu
den Follower-Slot-Bedingungen wie in anderen Familienmitgliedern). Amerikanische Schreibweise
beibehalten (Quelltext ist bereits amerikanisch).

**LineID-Schema:** `NHV_Q01_<Stage>_<Nr>` für die Questzeilen (z. B. `NHV_Q01_010_01` für „Tell me about
the Sacrament from Hjaalmarch."; Zahlen aus dem Quellskript direkt übernehmen, nicht neu vergeben – das
Journal (`dialogue/Journal.csv`) referenziert bereits `NHV_Q01_040_05`, `NHV_Q01_050_07` als
Fortsetzungspunkte, also müssen die Questdialoge in derselben Nummerierung liegen). Für die
Alltagszeilen aus `FAM_Hrefna.md` das dort schon verwendete Schema `NHV_SYS_HRE_<Nr>` (VoiceType
`NHV_VoiceHrefna`, Grundbedingung `NHV_Status_Hrefna == 1`).

**Speichern:** `dialogue/Q01.csv` (Questzeilen) und Ergänzung der Hrefna-Alltagszeilen im
familienweiten Alltags-CSV, falls es laut `docs/DIALOGUE.md` ein gemeinsames Family-CSV gibt, sonst
`dialogue/Hrefna.csv` – bitte an `docs/DIALOGUE.md` orientieren, welche Datei für Follower-/Alltagszeilen
vorgesehen ist. Bestehende LineIDs aus `dialogue/Journal.csv` (Journal-Texte, nicht die Questdialoge)
nicht anfassen.

**Grenzen:** Keine neuen Inhalte, keine Spoiler zusätzlich zu dem, was im Quellskript steht. Der
Kernsatz „Grief kills once, Listener. Sithis wants those who can kill twice." (050_01, Veyra) und alle
Speech-Check-Zeilen (Persuade/Intimidate bei 050_20, 050_50, 050_60) müssen wortgleich bleiben, da sie
bereits im Konzept (`docs/concept/konzept.md` Abschnitt 7) zitiert werden.

**Technik:** Danach baut Claude die Records aus der CSV (`tools/csv_to_plugin.py`, `tools/silent_voice.py`
für unvertonte Zeilen, siehe E21) und lässt den `lore-editor`-Subagenten die übertragenen Zeilen gegen
`docs/DIALOGUE.md` und die Lore prüfen. Jede Spieler-Option braucht mindestens eine nicht-leere
NPC-Antwort (bereits im Quellskript so aufgebaut, beim Übertragen nicht verlieren).
