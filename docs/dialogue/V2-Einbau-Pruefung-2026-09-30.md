# V2-Dialoge Q00–Q02: Passung zu Stages und Technik, Einbauplan

Stand: 30.09.2026. Geprüft: `dialogue/drafts/Q00-v2`, `Q01-v2`, `Q02-v2` (CSV, flow.json, README) gegen
Plugin (`plugin-text/`) und Scripts. Noch nichts davon ist eingebaut.

## Gesamtbild

- Alle drei Entwürfe benutzen **nur Stages, die im Plugin existieren**, und keine unbekannten Globals.
- Die CSV-Bedingungen prüfen **nur die Stage**. Die eigentliche Verzweigung (Pflichtblöcke, Nachfragen,
  Vertagen, Ausgänge) steht in `flow.json` als Lesetest-Zustände. Beim Einbau wird jeder dieser Zustände
  zu einem echten CK-Mechanismus (Topic-Verlinkung, Global, Quest-Variable oder Fragment).
- Umfang: Q00 222 Zeilen, Q01 218, Q02 152, alle neu (IDs ab x_1000, Topics `V2_*`), **keine Vertonung**.
  Die bisher vertonten Zeilen werden ersetzt; die stillen Sprachdateien (E21) müssen neu erzeugt werden.

| Quest | Zustände in flow.json, die Technik brauchen |
|---|---|
| Q00 | `heardPlan`, `heardMethod`, `heardAuthority` (3 Pflichtblöcke vor Zusage), `returned`, `heardInvitation`, `accepted`, `pause` (Vertagen), `memorial` (3), `cicero`/`initiates` (Vanilla-Präsenz), `lucien`/`witnessAccepted` |
| Q01 | `diary` (Tagebuch gelesen), `confessed`, `briefed`, `authorized`, `triedPersuade`/`triedIntimidate`, `coerced`, `persuade`/`intimidate` (Speech-Check), `hrefnaDead`, `fragment`, `pause` |
| Q02 | `watched`/`rescued` (Stage 30), `tracked`, `persuade`/`bribe`, `confessed`, `briefed`, `authorized`, `dead` + Täter (Sings/Spieler/anderer), `unproven`, `listRead`, `pause` |

## Q00 – Befunde

1. **Lucien in den Standoff (E41):** Die V2-Zeilen für Stage 80 und 100 setzen den Contract voraus:
   - `080_1000` „Before you go …“: Im Standoff geht Veyra, nicht der Listener → umformulieren.
   - `080_1004/1005/1007/1008` (Ablehnungen) entfallen, weil die Beschwörung Pflicht ist.
   - `080_1006` nennt Ledger und Hrefna, die es im Standoff noch nicht gibt → umformulieren.
   - `100_1000` „Will you hear **her**?“ – Lucien ist männlich → vermutlich Fehler („him“).
   - `100_1015/1016` (späterer Ruf) entfallen.
   - Nazir steht im Standoff daneben, hat aber keine Reaktion auf Lucien → 1–2 Zeilen fehlen.
   - Nach der Bürgschaft fehlt Luciens Abgangszeile; das Wiedersehen in der Deep Sanctuary fehlt.
   Die übrigen Lucien-Zeilen (`100_1001–1003`, `1008–1012`, `1021–1027`) passen ohne Änderung.
2. **Stage 80 entfällt:** Ohne Zeugen-Angebot endet Q00 nach dem ersten Lead (Stage 60) → 100.
3. **Stage 15** hat nur eine Zeile. Das passt (Veyra geht ins Windpeak Inn).

## Q01 – Befunde

1. **Stage 20** hat in V2 keine Zeilen mehr (Hofgespräche mit Hrefna entfallen, sie spricht erst am
   Lager). Die bisherigen Hof-INFOs müssen deaktiviert werden.
2. **E40 (Attentat)** passt: V2 beschreibt keinen Kampf zwischen Hrefna und Quintus.
3. **Veyra kommt ans Lager** (40 → 50) und lässt den Listener die Prüfung autorisieren → neue Szene bzw.
   Package am Lager; das bisherige Veyra-Erscheinen (`NHV_Mk_Q01_VeyraAppearSpot`) ist wiederverwendbar.
4. **Quintus' Tochter**: Hrefna erfährt davon in Stage 50 → Info-Quelle (Dialog oder Fund) festlegen.
5. **„Vorerst zurückziehen“** in Stage 50 ist ein neuer Ausgang ohne Tötung → Stage bleibt 50, Rückkehr
   möglich.
6. **Map Table:** V2 sagt, nach dem Debrief sind die vier übrigen Contracts „am Map Table wählbar“.
   Das System existiert noch nicht; Q02 hat auch keinen Start-Hook. **Entscheidung nötig**
   (Map Table jetzt bauen oder vorerst Q02 direkt starten und die Zeile neutral halten).
7. Die Ausgänge (Aufnahme / Freilassung / Schweigen) entsprechen `JudgeRecruit/Release/Silence`.

## Q02 – Befunde

1. **Stage 30:** V2 hat drei Haltungen (retten / beobachten / unterbrechen), gebaut sind zwei (eingreifen
   per Angriff auf Sings / zusehen). „Retten“ braucht die noch nicht verdrahtete Aktivierung von Haldor
   (`NHV_Q02_HaldorAliasScript.Rescue()`).
2. **Stage 40** hat keine Dialogzeilen (Spurensuche und Beschatten laufen über Welt und Script) – passt.
3. **Stage 50:** Geständnis in der Hollow, dann Veyra – passt zur gebauten Szene
   `NHV_Scn_Q02_02VeyraHollow`, deren Zeilen aber ersetzt werden.
4. **Stage 60/70:** Drei Varianten des Urteils je nach Täter (Sings / Spieler / anderer). Der Script-Stand
   kennt „Spieler hat getötet“ (`EndAeliusKillScene(bPlayerKilled)`) und den Fallback – das reicht,
   braucht aber ein Global für die Bedingungen.
5. **Oculatus-Liste** wird in V2 nach Aelius' Tod gefunden → passt zum versteckten Fund von heute.
6. Die Ausgänge entsprechen `JudgeRecruit/Release/Silence/Surrender`; „Jarl's guards“ = Hjorald-Übergabe.
7. **Belohnung** `ShadowscaleWraps` ist jetzt verknüpft; V2 erwähnt sie nicht → prüfen, ob Veyra sie im
   Debrief übergibt (Konzept sagt ja).

## Einbauplan

Jede Quest ist ein eigenes Arbeitspaket (eine Session je Quest, `/work-package`):

1. **Q00 V2 + E41** zuerst. Vorher liefert Codex die angepassten Lucien-Zeilen (Liste oben, Auftrag
   `docs/codex/2026-09-30-Q00-Lucien-im-Standoff.md`). Dann: V2-Topics generieren, alte Q00-INFOs
   stilllegen, Stage 12 + Lucien-Szene, Stage 80 stilllegen, stille Voice-Dateien, CK-Anleitung, Test.
2. **Q01 V2**, nach Entscheidung zum Map Table.
3. **Q02 V2**, inklusive dritter Haltung in Stage 30.

Save-Sicherheit: Bis 0.1.0 dürfen alte INFOs/Topics noch entfernt werden. Scripts und Stage-Nummern
bleiben additiv.
