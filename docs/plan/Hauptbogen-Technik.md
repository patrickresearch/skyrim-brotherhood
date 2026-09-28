# Hauptbogen-Technik: NHV_Sys_Oculatus

Technisches Skelett für die in `docs/plan/Hauptbogen-Oculatus.md` priorisierten Vorschläge (V1 Heat-Mechanik,
V3 Chiffre-Schlüssel, V4/V6 Interludes, V9 Gleaning-Text). Alle Angaben sind **Vorschlag**, noch nicht im CK
umgesetzt. Beschreibt nur additive Erweiterungen; nichts an bestehenden Scripts, Properties oder Stages wird
geändert oder entfernt (Regel 3, `docs/CONVENTIONS.md` Papyrus-Regel 9).

## 1. Neue System-Quest

**`NHV_Sys_Oculatus`** (Quest, Start Game Enabled, analog zu `NHV_Sys_Core`/`NHV_Sys_Family`). Lebt neben den
bestehenden System-Quests, nicht als Kind einer Story-Quest, damit sie Q00–Q06 überdauert und unabhängig von
laufenden/gestoppten Story-Quests Zustand hält (gleiches Prinzip wie `NHV_Sys_Family`).

**Script `NHV_OculatusScript`** (neu, Basis Quest):

```
; Eigenschaften (Properties)
Int Property iHeat = 0 Auto Hidden          ; 0–5, siehe Stufen unten
Int Property iScriptVersion = 1 Auto Hidden  ; Versionierung wie NHV_CoreScript

; Öffentliche Funktionen (additiv, von Contract-Scripts aufgerufen)
Function ReportEvidenceLeft()       ; Heat + 1, Obergrenze 5
Function ReportEvidenceDestroyed()  ; Heat unverändert, Kommentar-Flag setzen
Function ReportAgentSilenced()      ; Heat - 1, Untergrenze 0
Function ReportCoverStorySuccess()  ; Heat - 1, Untergrenze 0
Int Function GetHeatStage()         ; 0–1 = "Unbemerkt", 2–3 = "Fragt nach", 4 = "Handelt", 5 = "Vollalarm"

; Maintenance (aus NHV_CoreScript.Maintenance() aufgerufen, additiv)
Function Maintenance()              ; stellt iHeat sicher (nie None/uninitialisiert), Idempotent
```

**Wichtig für Save-Sicherheit:** `NHV_CoreScript.Maintenance()` bekommt einen zusätzlichen, nummerierten
Migrationsschritt, der `NHV_Sys_Oculatus` bei Bedarf startet und `iHeat` auf 0 setzt, falls die Quest neu
installiert wird (Bestandsspieler, die vor diesem Update in Q03–Q06 stehen). Kein bestehender Migrationsschritt
wird verändert, nur ein neuer angehängt (Konvention: „jede Migration ein eigener, nummerierter Schritt“).

## 2. Wie Contract-Quests Beweise melden

`NHV_ContractBaseScript` (Basisklasse Q01–Q05) bekommt **eine neue, optionale Property** und **keine
Pflichtaufrufe** in bestehenden Funktionen – bestehende Stage-Logik bleibt unangetastet:

```
NHV_OculatusScript Property OculatusSys Auto Hidden   ; per CK im Objektfenster gesetzt, wie andere Quest-Properties
```

Die Report-Funktionen (`ReportEvidenceLeft()` usw.) werden **nicht** automatisch von `NHV_ContractBaseScript`
aufgerufen, sondern gezielt aus neuen, additiven Stage-Fragmenten oder Dialog-Ergebnis-Skripten der einzelnen
Q01–Q05-Quests heraus (z. B. ein neues Fragment an einer neuen, optionalen Stage-Verzweigung „Burn the
evidence“ ruft `OculatusSys.ReportEvidenceDestroyed()`). Das hält `NHV_ContractBaseScript` selbst unverändert
in seiner bestehenden Phasenlogik und vermeidet, dass die Basisklasse für alle fünf Quests gleichzeitig
angefasst werden muss – jede Quest bindet sich nur dort ein, wo tatsächlich eine neue Spielerentscheidung
entsteht. **Beschreibung, keine Änderung:** Die bestehenden Funktionen/Properties/States von
`NHV_ContractBaseScript` selbst bleiben unangetastet; nur eine neue Property wird ergänzt.

**Beispiel-Hook Q01** (rein illustrativ, tatsächliche Stage-Nummern legt das CK-Team fest): Nach Stage 60
(„Search Quintus's belongings“, Fund von Fragment 1) eine neue, **optionale** Handlung am Leichnam/Tatort:
Dialog- oder Aktivator-Option „Cover his tracks“ → Fragment im Fundort verschwindet trotzdem nicht (nie
blockierend), aber ruft `OculatusSys.ReportEvidenceDestroyed()`.

## 3. Chiffre-Puzzle (V3), ohne SKSE-DLL

**Ansatz:** rein buch-/dialogbasiert, kein eigenes Minigame-UI. Zwei Varianten, siehe unten.

**Datenmodell:** Die fünf `[cipher]`-Stellen der bestehenden Dispatches (`NHV_Note_Dispatch01`–`05`) bleiben
unverändert im Original. Für jede existiert ein neues, additives Buch `NHV_Note_Dispatch01_Decoded` bis `_05`,
das den gleichen Text mit aufgelösten Klartextstellen zeigt (reiner Content-Unterschied, kein Script-Bezug).

**Schlüssel-Item:** `NHV_Book_PrefectsKey` (neues Buch), Fundort laut Plan-Dokument bei Livia Maro in Q06 oder
optional früher bei Aelius in Q02 – endgültiger Fundort ist eine offene Entscheidung (siehe Plan-Dokument
Abschnitt 9).

**Variante A – Veyra-Dialog (empfohlen, schlank):** Neuer Dialog-Branch bei Veyra, Condition
`GetItemCount NHV_Book_PrefectsKey >= 1`. Für jedes im Spielerinventar oder Aliasbesitz vorhandene
`NHV_Note_DispatchXX` bietet ein Topic „Decode this for me“ an; Ergebnis: `AddItem` des passenden
`_Decoded`-Buchs, `RemoveItem` nicht nötig (Original bleibt im Inventar). Keine neuen Scripts, nur Dialog +
Conditions + Ergebnis-Papyrus-Fragment mit 1–2 `AddItem()`-Aufrufen. Passt zu Papyrus-Regel 2 („Conditions vor
Scripts“) und Regel 3 (kurze Fragmente).

**Variante B – automatisches Script (mehr Aufwand):** `OnItemAdded()`-Event auf eine Referenzalias oder ein
Quest-Script, das bei Erhalt des Schlüssels alle bereits vorhandenen Fragmente prüft und automatisch
decodierte Varianten hinzufügt. Mehr Immersion, aber ein zusätzliches Event-Script nötig; Empfehlung bleibt
Variante A für v1.0.

**Save-Sicherheit:** Beide Varianten sind rein additiv (neue Items, neuer Dialog-Branch), keine neuen Stages,
kein Risiko für bestehende Spielstände ohne den Patch.

## 4. Interludes V4/V6 (Encounter-Technik)

**V4 „First Blood“:** 1 neue Encounter-FormList `NHV_FormList_OculatusMercs` (2–3 Templates, wiederverwendbar),
1 Story-Manager-Quest-Event oder einfacher: ein Encounter-Zone-Eintrag auf bereits vorhandenen
Zufallsbegegnungs-Mechanismen entlang der Straßen (Details CK-Anleitung). Condition auf
`NHV_Sys_Oculatus.iHeat >= 1`.

**V6 „Knock at Dawnstar“:** 1 Encounter mit 3–4 Agenten-Templates, platziert in einer **Wildnis-Zelle im
Umland von Dawnstar**, ausdrücklich **nicht** in `DawnstarSanctuary` selbst (verhindert eine zusätzliche
Zell-Kopie nach E16 – die bestehende Zell-Kopie-Liste in `docs/ARCHITECTURE.md` bleibt unverändert). Condition
auf `iHeat >= 3`. Optionales Verhör-Dialogset mit Ergebnis `OculatusSys.ReportAgentSilenced()`.

**Beide:** keine Navmesh-Edits, keine neuen Zell-Kopien, Encounter-Trigger über Story Manager oder
Trigger-Boxen (Papyrus-Regel 1: kein Polling).

## 5. Gleaning-Text (V9)

Reine Textarbeit, keine neuen Records außer optional 1–2 Notizen/Dialogzeilen pro Mission. Kein technischer
Aufwand in diesem Dokument gesondert zu beschreiben – siehe Codex-Briefs.

## 6. FormID-Bereich

**Vorschlag:** `0x004200`–`0x0042FF` für alle neuen Records dieses Hauptbogens (Quest, Script-Instanzen,
Bücher, FormList, Dialog-Topics, Encounter-Referenzen). Liegt außerhalb der laut `docs/ARCHITECTURE.md`
bereits vergebenen Bereiche (dort zuletzt referenziert: `0004DDA0` für FaceGen, `003D8B`/`0193EE`/`012FB4` als
Vanilla-Zell-Referenzen – beide Bereiche liegen nicht in `0x0042xx`). **Vor endgültiger Nutzung im CK: aktuell
höchste vergebene NHV-FormID im Plugin prüfen** (z. B. per Housecarl-Record-Abfrage), da diese Übersicht nicht
alle bisher im CK vergebenen IDs kennt – nur eine Bereichs-Empfehlung, keine Kollisionsgarantie.

## 7. Save-Kompatibilitäts-Checkliste für diesen Hauptbogen

- `NHV_Sys_Oculatus` ist eine **neue** Quest → bei Bestandsspielständen erst nach dem Patch aktiv;
  `NHV_CoreScript.Maintenance()` muss sie idempotent starten (Prüfung `GetStageDone` o. Ä., analog bestehendem
  Muster).
- `iHeat` startet bei 0 für alle – auch für Spieler, die bereits mitten in Q03–Q06 stehen. Das ist akzeptiert
  (kein rückwirkendes „Bestrafen“ für Alt-Saves), da Heat ohnehin nur Zusatzinhalt freischaltet, nichts
  blockiert.
- Keine neue Property, kein neuer State, keine neue Funktion an `NHV_ContractBaseScript` **entfernt oder
  umbenannt** – nur eine neue, optionale Property (`OculatusSys`) ergänzt.
- Alle neuen Dialoge/Bücher/Encounter sind rein additiv; keine bestehende Stage wird umnummeriert.
- Migration in `NHV_CoreScript.Maintenance()`: neuer, eigener nummerierter Schritt, bestehende Schritte
  unverändert.
- Kein SKSE-DLL, keine neue harte Abhängigkeit; alle Mechaniken (Heat-Zähler, Chiffre, Encounter) laufen über
  Standard-Papyrus, Globals/Quest-Variablen, Conditions und Dialoge.

## 8. Was noch fehlt / offen

- Exakte Stage-Nummern für die neuen optionalen Verzweigungen in Q01–Q05 (CK-Arbeit, pro Quest im jeweiligen
  Arbeitspaket).
- Entscheidung Fundort Schlüssel-Buch (Livia in Q06 vs. Aelius in Q02) – siehe Plan-Dokument Abschnitt 9.
- Entscheidung UI-Sichtbarkeit von `iHeat` (nur narrativ über Veyra vs. zusätzlicher MCM-Debug-Wert).
