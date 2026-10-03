# CK-1: Nur Kontrollieren (Q00, Q01, Q02)

Stand: 02.10.2026 (Fassung 2, Aufteilung der Datei `Q00-Q02-CK-Anleitung-Final.md`). **Nichts hiervon ist ingame getestet.** Diese Anleitung enthält nur Aufgaben vom Typ **K = NUR KONTROLLIEREN**: Der Record existiert im ESP, du gleichst Werte ab und meldest Abweichungen. **Du legst hier nichts an und änderst nichts**, außer es steht ausdrücklich da (K-ALL-02 kopiert Dateien, keine Records). Fehlt etwas: nicht selbst anlegen (Regel 3), melden.
Schwesterdateien: `CK-2-Nur-Aendern.md` (Ä), `CK-3-Nur-Neu.md` (N), Einstieg und Reihenfolge: `README-CK-Anleitungen.md` (dort auch die Grundgriffe im CK, Fragen, Nach-dem-CK, Testhinweise).

**Wie sicher ist was?** „Laut Export“ = aus `plugin-text/` nachgelesen. **(geprüft)** = über `housecarl_records` gegen `Skyrim.esm` geprüft. **(im CK prüfen)** = nicht prüfbar. Zeigt dein CK etwas anderes als beschrieben, melde, was du siehst.

## Einstieg und Voraussetzung (E17, Ein-Schreiber-Regel)

1. Das ESP wurde von Claude aus dem Repo-Stand geschrieben (`tools\plugin_text.ps1 -Direction ToPlugin`) und per `tools\sync_dev.ps1 -Direction ToDev -IncludeEsp` in die Dev-Kopie gelegt. **Starte das CK erst, wenn Claude „ESP geschrieben und synchronisiert“ gemeldet hat.**
2. Das CK läuft aus der Dev-Kopie `C:\Dev\brotherhood-devenv\SkyrimSE-Dev` (nie aus dem Live-Spiel, nie aus Vortex-Staging).
3. **Ein Schreiber am ESP (E17):** CK und Claude schreiben nie gleichzeitig. Solange das CK offen ist, schreibt Claude nichts.
4. Keine Vanilla-Records ändern (Regel 1). Diese Anleitung ändert ohnehin nichts an Records.

## Übersichtstabelle

Prio: **P1** blockiert den Test, **P2** wichtig, **P3** später/optional. „Wann“: Phase 0 = vor allem anderen (README), Phase 3 = erst nach CK-2 und CK-3 (die Kontrolle prüft deren Ergebnis).

| Neue ID | Quest | Ort | Prio | Aufwand | Wann | Kurzbeschreibung |
|---|---|---|---|---|---|---|
| K-ALL-01 | alle | Repo, Dev-Kopie | P1 | 10 min | Phase 0 | ESP-Stand, Skripte, Backup |
| K-ALL-02 | alle | Dev-Kopie (Dateikopie) | P1 | 10 min | Phase 0 | CK-Compiler: SKSE-Quellen bereitstellen (`ObjectReference.psc`) |
| K-ALL-03 | alle | CK | P1 | 10 min | Phase 0 | CK starten, Ladewarnungen notieren |
| K-ALL-04 | Q00/Q02 | Zellen (Vanilla-Altlasten) | P3 | 20 min | Phase 3 | Nur melden, nichts löschen |
| K-ALL-05 | alle | FaceGen-Dateien | P2 | 10 min | Phase 3 | Fremd-NIF 0004DDA0, Vollständigkeit |
| K-ALL-06 | Q01/Q02 | Bücher/Items | P2 | 15 min | Phase 3 | Platzierungs-Kontrolle |
| K-ALL-07 | alle | CK | P1 | 10 min | am Ende | Speichern, schließen (nach CK-2 und CK-3) |
| K-Q00-01 | Q00 | Quest 000815, Lucien, Sys-Quests | P2 | 20 min | Phase 3 | Packages, Aliase, Lucien-Records |
| K-Q00-02 | Q00/Q01 | Dawnstar Sanctuary und Deep Sanctuary | P2 | 20 min | Phase 3 | Ladetür, Veyras Türweg (K5) |
| K-Q00-03 | Q00 | Deep Sanctuary | P3 | 15 min | Phase 3 | Lucien, Memorial-Marker, Plaketten |
| K-Q00-04 | Q00 | Deep Sanctuary, Dawnstar-Tür | P2 | 20 min | Phase 3 | Navmesh beobachten |
| K-Q00-05 | Q00 | `NHV_DeepSanctuaryCell` | P3 | 10 min | Phase 3 | Encounter Zone „Never Resets“, Owner (Teile a, f von C5) |
| K-Q01-01 | Q01 | Packages, Aliase, Soldaten | P2 | 30 min | Phase 3 | K1–K7 aus Q01-NPC-Packages |
| K-Q01-02 | Q01 | Marker, Betten, Farmtür | P2 | 30 min | Phase 3 | Navmesh-Kontrolle |
| K-Q01-03 | Q01 | `MorthalMoorsideInn` | P2 | 5 min | Phase 3 | Freies Bett im Inn (B6) |
| K-Q02-01 | Q02 (M2.0) | Ledger Room, Map Table | P2 | 15 min | Phase 3 | Properties, Z-Abstand Marker/Tisch |
| K-Q02-02 | Q02 | Quest 004100 | P1 | 15 min | Phase 3 | Aliase 0–10, Stages, Objectives, Protected |
| K-Q02-03 | Q02 | Quest 004100, Alias `SingsAlias` | P1 | 10 min | Phase 3 | Alias-Packages, keine ForceGreet |
| K-Q02-04 | Q02 | Fraktion AF14, Package AF40, NPCs AF10/AF11 | P2 | 15 min | Phase 3 | Enforcer-Fraktion, Follow-Package |
| K-Q02-05 | Q02 | 20 Packages AF50–AF63, NPC-Records | P1 | 30 min | Phase 3 | Laden ohne Warnung, Reihenfolge |
| K-Q02-06 | Q02 | Szenen 004125/004127 und 0xA0xx | P2 | 20 min | Phase 3 | Aliase, Phasen, Packages |
| K-Q02-07 | Q02 | Quest 004100, Aliase 2/5/8/9 | P1 | 15 min | Phase 3 | **Neu:** Alias-Typ prüfen (Sings, Haldor), Ersatz für „Persistent“ |
| K-Q02-08 | Q02 | Vanilla `WindhelmArgonianAssemblage` | P2 | 20 min | Phase 3 | Nur ansehen, nichts speichern |
| K-Q02-09 | Q02 | Docks, Kontor | P2 | 15 min | Phase 3 | Marsh Hitch, Aelius nachts, Dispatch-Ownership |
| K-Q02-10 | Q02 | Docks, Hollow, Kontor | P1 | 30 min | Phase 3 | Navmesh an neuen Refs |
| K-Q02-11 | Q02 | Bett-FormKeys | P2 | 5 min | Phase 3 | Nur melden (`BEDS` trägt Claude ein) |

Anzahl: 26 Aufgaben (übergreifend 7, Q00 5, Q01 3, Q02 11).

### Zuordnungstabelle alte ID (Q00-Q02-CK-Anleitung-Final.md) zu neuer ID (alle drei Dateien)

| Alt | Neu | Datei | Bemerkung |
|---|---|---|---|
| A1 | K-ALL-01 | CK-1 | |
| (neu) | K-ALL-02 | CK-1 | SKSE-Quellen für den CK-Compiler (Compile-Fehler `SetDisplayName`) |
| A2 | K-ALL-03 | CK-1 | |
| A3 | K-ALL-04 | CK-1 | |
| G2 | K-ALL-05 | CK-1 | |
| H2 | K-ALL-06 | CK-1 | |
| I1 | K-ALL-07 | CK-1 | Abschluss; CK-2/CK-3 enden mit Zwischenspeichern |
| I2 | Rückmeldung | CK-1 (Abschluss), Ergänzungen in CK-2/CK-3 | |
| B12 | K-Q00-01 | CK-1 | |
| C4 | K-Q00-02 | CK-1 | betrifft auch Q01 (K5) |
| D13 | K-Q00-03 | CK-1 | |
| F4 | K-Q00-04 | CK-1 | |
| C5 (Teile a, f) | K-Q00-05 | CK-1 | |
| C5 (Teil e) | Ä-Q00-01 | CK-2 | Beleuchtung |
| C5 (Teile b, c, d) | N-Q00-01 | CK-3 | Räume, Room Bounds, Enable-Parents |
| B10 | K-Q01-01 | CK-1 | |
| F3 | K-Q01-02 | CK-1 | |
| D11 (Zeile B6) | K-Q01-03 | CK-1 | Inn-Bett nur prüfen |
| D11 (B1–B5) | N-Q01-01 | CK-3 | |
| D12 | N-Q01-02 | CK-3 | |
| C3 | Ä-Q01-01 | CK-2 | Farmtür |
| E3 | Ä-Q01-02 | CK-2 | Sleep-Packages auf Bett-Refs |
| B11 | K-Q02-01 | CK-1 | Map Table, Start von Q02 |
| B1 | K-Q02-02 | CK-1 | |
| B2 | K-Q02-03 | CK-1 | |
| B3 | K-Q02-04 | CK-1 | |
| B4 | K-Q02-05 | CK-1 | |
| B5 | K-Q02-06 | CK-1 | |
| (neu, aus B8/B9) | K-Q02-07 | CK-1 | Alias-Typ statt „Persistent“ |
| D9 | K-Q02-08 | CK-1 | |
| D10 | K-Q02-09 | CK-1 | |
| F2 | K-Q02-10 | CK-1 | |
| E2 | K-Q02-11 | CK-1 | |
| B6 | Ä-Q02-01 | CK-2 | Hollow-Tür `RequiredStageMax` |
| B7 | Ä-Q02-02 | CK-2 | Leiche `RequiredStage/TargetStage` |
| B8 | Ä-Q02-03 | CK-2 | Sings: **nur noch Initially Disabled** (Persistent gestrichen) |
| B9 | entfällt als CK-Änderung | CK-1 K-Q02-07 | Haldor braucht keinen Persistent-Haken, es gibt ihn nicht; stattdessen Alias prüfen |
| C2 | Ä-Q02-04 | CK-2 | Kontor/Hollow bereinigen |
| E1 | Ä-Q02-05 | CK-2 | Properties füllen (nach CK-3) |
| G1 | Ä-Q02-06 | CK-2 | Quelle Typ N; hier Ä, weil `AF10`/`AF11` existieren |
| H1 | Ä-Q02-07 | CK-2 | Quelle Typ N; hier Ä, weil `AF31–AF33` existieren |
| C1 | N-Q02-01 | CK-3 | Tidehouse-Zelle und Türen |
| D3 | N-Q02-02 | CK-3 | Tidehouse-Inhalt |
| F1 | N-Q02-03 | CK-3 | Tidehouse-Navmesh |
| D1 | N-Q02-04 | CK-3 | Salzplatz-Marker |
| D2 | N-Q02-05 | CK-3 | Salzplatz-Enforcer, Beweisstücke |
| D4 | N-Q02-06 | CK-3 | Kurier |
| D5 | N-Q02-07 | CK-3 | Chiffre-Buch |
| D6 | N-Q02-08 | CK-3 | Drei Q02-Betten |
| D7 | N-Q02-09 | CK-3 | Idle-Möbel |
| D8 | N-Q02-10 | CK-3 | Haldor-Rückkehr-Marker |

---

## Übergreifend

### K-ALL-01: ESP-Stand und Voraussetzungen (alt A1, P1, Phase 0)

**Wo:** Repo und Dev-Kopie, nicht das CK.
**Was:**
1. Claude meldet: „ToPlugin gelaufen, ESP per ToDev -IncludeEsp in der Dev-Kopie, Hash identisch.“ Erst dann weiter.
2. Das Spiel ist **geschlossen** (die ESP-Datei ist sonst gesperrt).
3. Backup: `NightsHarvest.esp` aus der Dev-Kopie als `NightsHarvest.esp.bak-2026-10-02` daneben kopieren. **Vor jedem Navmesh-Abschnitt (CK-3 N-Q02-03) ein weiteres Backup mit Datum.**
4. In `Data\Source\Scripts` der Dev-Kopie liegen `NHV_Q02Script.psc`, `NHV_Q02_StageActivatorScript.psc` (Property `RequiredStageMax`), `NHV_MapTableScript.psc`; die kompilierten `.pex` in `Data\Scripts`. Ohne sie fehlen im CK die Script-Properties (z. B. `RequiredStageMax`, `TidehouseEnforcerRefs`).
**Ergebnis/Prüfung:** Backup vorhanden; Claude hat den Sync bestätigt.

### K-ALL-02: CK-Compiler: SKSE-Quellen bereitstellen (neu, P1, Phase 0, vor dem Fragment-Compile)

**Anlass:** Der CK-Fragment-Compile von `QF_NHV_Q02_ColdWaters_02004100` bricht ab mit `NHV_CoreScript.psc(2168,18)` und `(2231,14)`: „SetDisplayName is not a function or does not exist“.
**Ursache (nur lesend geprüft, nichts verändert):**
- `NHV_CoreScript.psc` ruft in Zeile 2168 und 2231 `LucienRef.SetDisplayName("Lucien Lachance", True)` auf (Lucien-Ref, `ObjectReference`).
- `SetDisplayName` ist eine **SKSE-Funktion** von `ObjectReference`; die Vanilla-Klasse kennt sie nicht.
- Der CK-Compiler sucht Quellen **nur** in `<Dev>\Data\Source\Scripts` (siehe `docs/ENVIRONMENT.md`, Abschnitt „CK-Compiler und SKSE-Scripts (25.09.2026)“). Dort liegt `ObjectReference.psc` als **Vanilla-Fassung** (771 Zeilen, 32.691 Bytes, Stand 27.03.2023, ohne `SetDisplayName`).
- Die **SKSE-Fassung** liegt nur in `<Dev>\Data\Scripts\Source\ObjectReference.psc` (840 Zeilen, 35.113 Bytes, Stand 17.01.2024; `bool Function SetDisplayName(string name, bool force = false) native` in Zeile 805). Pyro sucht auch dort, deshalb baut der Pyro-Build fehlerfrei, der CK nicht.
- Bei `SKSE.psc`, `ModEvent.psc` und `Cell.psc` wurde das am 25.09.2026 schon so gelöst; `ObjectReference.psc` fehlte in dieser Liste. Die SKSE-Fassung benutzt nur Vanilla-Typen (`Enchantment`, `MagicEffect`, `Potion`, `ReferenceAlias`, `FormList`); das Risiko wie bei `Form.psc` (kaputte Fragmente durch weitere SKSE-Verweise) ist daher gering, aber nicht ausgeschlossen.
**Lösung (Kopierbefehl, **von dir** auszuführen; Claude ändert die Dev-Kopie nicht), PowerShell:**
```powershell
$dev = 'C:\Dev\brotherhood-devenv\SkyrimSE-Dev\Data'
# 1. Vanilla-Fassung sichern (wie bei Cell.psc)
Copy-Item "$dev\Source\Scripts\ObjectReference.psc" "$dev\Source\Scripts\ObjectReference.psc.vanilla-backup"
# 2. SKSE-Fassung an die Stelle legen, die der CK-Compiler liest
Copy-Item "$dev\Scripts\Source\ObjectReference.psc" "$dev\Source\Scripts\ObjectReference.psc" -Force
# 3. Kontrolle: muss eine Trefferzeile liefern
Select-String -Path "$dev\Source\Scripts\ObjectReference.psc" -Pattern 'SetDisplayName'
```
**Danach:** CK neu starten (falls es lief), Fragment `QF_NHV_Q02_ColdWaters_02004100` erneut kompilieren (Quest 004100, Reiter **Scripts**, Fragment-Fenster, **Compile**). Erfolg: keine Meldung (der CK meldet bei Erfolg nichts). Tritt danach ein **anderer** „is not a function“-Fehler auf: Name der Klasse/Funktion melden; Lösung ist dasselbe Verfahren (SKSE-Fassung dieser Klasse aus `Data\Scripts\Source` kopieren, Vanilla-Backup daneben). **Nicht** kopieren: `Form.psc` (siehe ENVIRONMENT, Korrektur: bricht alle Fragmente).
**Bei Neuaufbau der Dev-Kopie wiederholen** (Liste: `SKSE.psc`, `ModEvent.psc`, `Cell.psc`, jetzt `ObjectReference.psc`). Claude trägt die Ergänzung in `docs/ENVIRONMENT.md` nach.
**Ergebnis:** Fragment kompiliert; Rückmeldung „K-ALL-02: ok“ oder der neue Fehlertext.

### K-ALL-03: CK starten und Ladewarnungen notieren (alt A2, P1, Phase 0)

**Wo:** CK, **File, Data**: aktive Datei `NightsHarvest.esp` (Set as Active File), Master `Skyrim.esm`, `Update.esm` (laut E05).
**Was:** Laden. Jede Meldung (fehlende Master, „form not found“, Script-Warnungen) abschreiben, nicht speichern, nicht wegklicken ohne Notiz.
**Ergebnis:** Eine Liste der Ladewarnungen für die Rückmeldung. Erwartet: keine fehlenden Master. Vanilla-Altlasten (K-ALL-04) können Warnungen erzeugen.

### K-ALL-04: Vanilla-Altlasten nur melden (alt A3, Q00/Q02, P3)

**Wo:** Cell View.
**Was (laut Export und PROGRESS 30.09.): nichts löschen, nur ansehen und melden, ob der Befund noch stimmt.** Die Entscheidung trifft der Entwickler (Fragen 7 und 12, siehe README).
| Fund | Zelle |
|---|---|
| Vanilla-Zelle `DeepSanctuaryNEW` (016204), 181 platzierte Refs im Export, kein NHV-Eintrag. Regel 1 verbietet Änderungen an Vanilla-Records. | Interiors |
| Vanilla-Reste in den duplizierten Zellen: `TGCrown09Go001`, `TGCrownGemAct010`, `WindhelmPalaceUp1PatrolB004`, `WindhelmWuunferthLabMarker001` im Kontor (0057DC); `LargashburBasementToExterior001` und weitere Vanilla-Objekte in der Hollow (0051AB). Bereinigung der Zellen selbst: CK-2 Ä-Q02-04 | Interiors |
| `ChillfurrowFarmDUPLICATE001` (004FD8), 419 Refs, keine NHV-Records | Interiors |
**Ergebnis:** Im Rückmeldeformat „K-ALL-04: unverändert“ oder die Abweichung.

### K-ALL-05: FaceGen-Bestand kontrollieren (alt G2, alle, P2)

**Befund laut Dateien:** FaceGen-Dateien (`.NIF` und FaceTint `.dds/.tga`) existieren für `00000817` (Veyra), `00004006` bis `00004008` (Hakan, Hrefna, Quintus), `00004107` bis `0000410C` (Q02-NPCs), `00004400` (Lucien), `00005957`, `00005958` (Q02, 5958 = Leiche), `00007F20`, `00007F21` (Scavenger, Scout). **Auffällig:** `0004DDA0.NIF` hat eine FormID, die in `plugin-text/Npcs` nicht existiert (vermutlich ein Vanilla-NPC-Override; PROGRESS 25.09. erwähnt einen „unerwünschten Vanilla-Nazir-Override mit FaceGen“). Fehlend: `00AF10`, `00AF11` (entstehen in CK-2 Ä-Q02-06); Soldaten-Template `0089F2` braucht keine eigene FaceGen-Datei (Template 01FC5B), ob die Soldaten ein Gesicht haben, im Test sehen; Nachtmutter-Sprecher `004990` unsichtbar.
**Was:** Ob `0004DDA0` im ESP noch einen Vanilla-NPC-Override erzeugt: im CK **Object Window, Actors**, Filter nach „Nazir“ und die FormID 04DDA0 suchen; **nicht löschen**, melden (Frage 7).
**Ergebnis:** Meldung „K-ALL-05: 0004DDA0 gefunden/nicht gefunden“. Nach Ä-Q02-06 zusätzlich prüfen, dass `00AF10.NIF` und `00AF11.NIF` existieren.

### K-ALL-06: Bücher und Items: Platzierungs-Kontrolle (alt H2, Q01/Q02, P2, Phase 3)

**Laut Export bereits platziert:**
| Item | FormID | Ort |
|---|---|---|
| `NHV_Book_Q01_PatrolSlip` | 007F15 | `NHV_StormhollowFarmCell` |
| `NHV_Book_Q01_EirikLedger` | 007F11 | `NHV_StormhollowFarmCell` |
| `NHV_Book_Q01_BurnedNote` | 007F12 | `NHV_StormhollowFarmCell` |
| `NHV_Book_Q01_OculatusFieldNote` | 007F13 | Tamriel, Wachposten (Außenzelle -7/18) |
| `NHV_Book_Q01_MoorsideRegister` | 007F14 | `MorthalMoorsideInn` |
| `NHV_Book_QuintusPrivateLetter` | 007F10 | `MorthalMoorsideInn` |
| `NHV_Note_Dispatch02` | 00411D | Kontor (über `NHV_Q02_DispatchDeskRef`) |
**Noch nicht platziert (entstehen durch CK-3):** `NHV_Book_Q02_TidehouseLedger` AF30 (N-Q02-02), `NHV_MISC_Q02_HaldorKnife` AF31 und `SluiceToken` AF32 (N-Q02-05), `ImperialSeal` AF33 (N-Q02-06; im Inventar von AF11), `NHV_Book_Q02_CipherKey` AF34 (N-Q02-07).
**Was:** Nach der Platzierung der neuen Items prüfen: jedes Item ist erreichbar (Navmesh, nicht im Wasser/in der Wand), Fundstellen stimmen mit den Dialogbedingungen (`ledger` = Item im Inventar). `NHV_Item_Q01_RedFerryMarker` (007F24) wird nicht platziert (Hakan trägt es).
**Ergebnis:** Abgleich.

### K-ALL-07: Speichern und Abschluss (alt I1, P1, am Ende)

Erst **nach** CK-2 und CK-3 (Reihenfolge: README).
1. **Strg+S**, im CK Meldungen beachten (Warnungen lesen und notieren).
2. CK schließen.
3. Backup der gespeicherten `NightsHarvest.esp` mit Datum daneben legen.
**Danach (macht Claude):** `sync_dev.ps1 -Direction FromDev` (Dev-Kopie nach Repo), dann `plugin_text.ps1 -Direction ToText` (Spriggit-Export). **Du gibst das Spiel und das CK vor dem Sync frei.** Der **Commit** erfolgt durch dich (Claude schlägt die Nachricht vor); kein Push, kein Tag.

---

## Q00

### K-Q00-01: Q00: Quest, Aliase, Lucien (alt B12, P2)

**Wo:** Quest `NHV_Q00_ShadowAtTheDoor` (000815), Quest `NHV_Sys_Sanctuary` (000809), NPC `NHV_LucienSpirit` (004400).
**Was (laut Export vorhanden):**
1. Q00-Aliase: Veyra (Packages 000DD7, 003D90, 003D94, 0037EF, 0037DE, 0037DF, 0037E0), Nazir (ForcedReference 01C3AD), Babette (01D4BC), Cicero (09BCB0; zusätzlich Package 006102 `NHV_Pkg_Q00V2_R_cicero_memory_p0`), Alias 4 `NightMotherCoffin` (074766). Stage 12 vorhanden (Objective 12), Objectives 31 und 61.
2. Lucien: Ref `NHV_Ref_Sys_Lucien` (004401, laut Export mit den Flags **Persistent** und **Initially Disabled**, Position -5300 / -1520 / -14), Marker `NHV_Mk_Sys_LucienSpot` (004402), Package `NHV_Pkg_Sys_LucienStand` (004404). FaceGen vorhanden (00004400.NIF). **Hinweis zu Persistent:** Der Entwickler meldet, dass der Haken „Persistent“ bei Charakter-Refs im CK nicht angezeigt wird. Der Export zeigt das Flag an dieser Ref trotzdem. **Nicht** versuchen, es zu ändern; melde nur, ob du im Ref-Dialog von 004401 ein Persistent-Feld siehst (ja/nein). **Initially Disabled** muss gesetzt bleiben.
3. **Nichts ändern, nur abgleichen.** Q00 lief laut PROGRESS (30.09./01.10.) durch; Lucien-Ansprechbarkeit war zuletzt offen (kein Log).
**Ergebnis:** Abgleich in der Rückmeldung; Auffälligkeiten melden.
**Frage zu Q00-NPCs ohne Idle-Package:** Frage 9 (README). Q00-NPCs außerhalb der Szenen sind **nicht beauftragt**, es gibt dafür keine eigene Aufgabe.

### K-Q00-02: Türkette Dawnstar Sanctuary und Deep Sanctuary (alt C4, Q00/Q01, P2)

**Wo:** Cell View, Interiors, `DawnstarSanctuary` (0193EE) und `NHV_DeepSanctuaryCell` (001342).
**Was (laut Export und M1.3-Dokumenten):**
1. Ladetür `NHV_DeepSanctuaryDoorRef` (003D8B, Base `NHV_DeepSanctuaryDoor` 003D8A, Position -5600 / -2816 / 148, Rotation Z 180°) in der Dawnstar-Zelle: Ziel in der Deep Sanctuary; die Zelle `DawnstarSanctuary` ist als E16-Kopie (E25) bekannt. **In der Vanilla-Zelle sonst nichts anfassen** (keine Markierung, kein Navmesh-Klick).
2. **K5 aus der Q01-Package-Anleitung:** Die Tür darf für NPCs **nicht gesperrt oder skriptgesteuert verschlossen** sein; sonst bleibt Veyra beim Fensterwechsel in ihrer Tagesroutine (18:00–02:00 Dawnstar, 02:00–10:00 Deep Sanctuary) hängen. Prüfen: Tür ohne Schloss, Rückkehrtür `NHV_SealedPassageReturnDoor` (000DD6) ersetzt die Markarth-Ausgangstür per Skript.
3. Die Sealed-Passage-Tür `NHV_SealedPassageDoor` (000DD5) entsteht per Skript (kein CK-Platz in der Vanilla-Zelle, E16).
**Ergebnis:** „K-Q00-02: ok“ oder Befund melden (z. B. Tür mit Schloss).

### K-Q00-03: Lucien, Memorial, Plaketten (alt D13, P3)

**Wo:** `NHV_DeepSanctuaryCell`.
**Was (laut Export):** `NHV_Mk_Q00_DeepSanctuaryEntry`, `NHV_Mk_Q00_MemorialVeyra/Nazir/Babette/Cicero`, Plaketten `NHV_Ref_Q00_PlaqueFestus/Gabriella/Arnbjorn/Veezara/Astrid/AstridSmall` stehen; `NHV_Ref_Sys_Lucien` und `NHV_Mk_Sys_LucienSpot` bei -5300 / -1520 / -14. **Prüfen:** Marker stehen auf Navmesh (laut PROGRESS wurden die Memorial-Marker nachträglich auf Navmesh gesetzt), Plaketten lesbar, Lucien-Spot frei begehbar. **Nichts verschieben ohne Befund.**
**Ergebnis:** Abgleich.

### K-Q00-04: Navmesh Deep Sanctuary und Dawnstar-Tür (alt F4, P2)

**Was:** `NHV_DeepSanctuaryCell` hat ein Navmesh (Export); für die fünf Räume (CK-3 N-Q00-01) ist weiteres Navmesh Teil von M1.3. Die Dawnstar-Tür (003D8B) liegt in einer Sackgasse; ein Navmesh-Override der Vanilla-Zelle wurde laut PROGRESS 27.09. **nicht** erreicht (NPCs aus Dawnstar laufen daher nicht automatisch hindurch). **Nichts ändern**, nur beobachten, ob Veyras Tagesroutine (K-Q00-02) die Zelle wechselt.
**Ergebnis:** Beobachtung in der Rückmeldung.

### K-Q00-05: Deep Sanctuary: Encounter Zone und Owner (alt C5, Teile a und f, P3)

**Befund laut Export:** `NHV_DeepSanctuaryCell` (001342, „Deep Sanctuary“) ist ein Duplikat der `MarkarthTreasuryHouse`, 648 platzierte Refs, 19 NHV-Refs, Location `NHV_DeepSanctuaryLocation` (000DD3), Encounter Zone `NHV_DeepSanctuaryZone` (001337), Lighting-Template `0D7B14`, Navmesh vorhanden. **Owner `06566B:Skyrim.esm`** ist gesetzt.
**Wo:** Cell View, Interiors, `NHV_DeepSanctuaryCell`, Zelle bearbeiten (Rechtsklick, **Edit**, im CK prüfen).
**Was:**
- Teil a: Encounter Zone `001337` hat **Never Resets** angehakt; die Zelle zeigt sie.
- Teil f: Owner `06566B` prüfen: Vanilla-Besitzer gewollt? (Frage 15 im README: betrifft Diebstahl-Warnungen und Schlafen.) Nicht ändern, melden.
**Ausbau der Zelle** (Räume, Room Bounds, Enable-Parents, Beleuchtung): CK-3 N-Q00-01 und CK-2 Ä-Q00-01. Q00 läuft laut PROGRESS auch ohne diese Ausbaustufe.
**Ergebnis:** Rückmeldung „K-Q00-05: Never Resets ja/nein, Owner-Befund“.

---

## Q01

### K-Q01-01: Q01 Packages, Aliase und Soldaten (alt B10, P2)

**Wo:** Object Window, **Actors, Actor** (NPCs), **Character, Quest**, **Character, Package**.
**Was (K1 bis K7 der Q01-Package-Anleitung, laut Export alles vorhanden):**
1. Reiter **AI Packages** von `NHV_Hakan` (004006: AD01, AD00 vor 498B), `NHV_Hrefna` (004007: AD0E, AD05, AD03, AD02 vor 498C), `NHV_Quintus` (004008: AD07, AD09, AD08 vor 498D/4989), `NHV_Veyra` (000817: AD10, AD11, AD12): neue Packages oben, alte unten, **nicht umsortieren**.
2. Soldaten `NHV_Q01_WatchpostSoldier` (0089F2): im Reiter AI Packages nur `NHV_Pkg_Q01_SoldierWatch` (AD0A); im Template-Bereich sind **AI Packages** und **Def Pack List** nicht mehr angehakt (Template 01FC5B). Offene Frage 14 (README): Nebenwirkungen des entfernten Template-Flags im Test beobachten.
3. Quest `NHV_Q01_TheUnansweredSacrament` (004000): `VeyraAlias` = 7F30, 4991, AD0B, AD0C; `HrefnaAlias` = AD0F, AD0D, 498E, AD04; Quest `NHV_Sys_Family`, Alias `HrefnaSlot`: AD06, 4992.
4. Global `NHV_Q01_QuintusAtFarm` (00AD20) existiert (GlobalShort).
5. Scout (007F21), Marsh Scavenger (007F20): Basis-Package `0956B8`.
6. `NHV_Pkg_Q01_VeyraTrialHold` (004991) bleibt als ungenutzter Record bestehen (Regel 3); nichts ändern.
**Ergebnis:** Abgleich in der Rückmeldung.
**Hinweis:** Die Sleep-Packages AD01, AD03, AD0E, AD0F, AD06, AD12 werden in CK-2 Ä-Q01-02 auf die Bett-Refs aus CK-3 N-Q01-01 umgestellt; hier nur die Reihenfolge prüfen.

### K-Q01-02: Navmesh an Markern, Betten, Farmtür (alt F3, P2, Phase 3)

**Was (K3 der Q01-Package-Anleitung):** Marker `HakanSpot` (0048A7), `CampMarker` (004980), `QuintusFarmSpot` (0089E6), `HrefnaFarmSpot` (0089E7), `QuintusInnSpot` (0089FD), Veyras Orte (09725F im Dawnstar-Sanctuary-Innenraum laut Package-Anleitung, `NHV_Mk_MapTable_Veyra` 005ECD, `KitchenSpot` 00498A), die Betten B1 bis B5 (CK-3 N-Q01-01) und die Landeplätze der Farmtür (CK-2 Ä-Q01-01) stehen auf Navmesh. Nicht auf Navmesh stehende Marker **versetzen** (kleine Verschiebung; das ist die einzige erlaubte Änderung dieser Aufgabe), Navmesh in Vanilla-Außenzellen **nicht** ändern.
**Ergebnis:** Pro Punkt „ok“ oder versetzt (neue Koordinate melden).

### K-Q01-03: Freies Bett im Moorside Inn (alt D11, Zeile B6, P2)

**Wo:** `MorthalMoorsideInn`, Marker `NHV_Mk_Q01_QuintusInnSpot` (0089FD, Position 1312 / 32 / 0).
**Was:** Quintus nimmt ein **freies Bett** im Radius **1024** um den Marker (Package `NHV_Pkg_Q01_QuintusInnNight` AD09, unverändert). **Nichts platzieren**; nur prüfen, dass im Inn mindestens ein freies, unbesessenes Bett im Radius liegt.
**Hinweis (Nachtrag Koordinator e):** Kein Q02-NPC steht in einem Inn; der Inn gehört zu Q01.
**Ergebnis:** „K-Q01-03: Bett frei ja/nein“.

---

## Q02

### K-Q02-01: Map Table (M2.0) (alt B11, P2)

**Wo:** Cell View, Interiors, `NHV_DeepSanctuaryCell`; Refs `NHV_Ref_MapTable` (005ECC, Base `NHV_Act_MapTable` 005EC5, Position -6304 / -1344 / 224), `NHV_Ref_MapTable_Map` (005ECE, Static `CivilWarMap02` 070BC2 **(geprüft, Model `Clutter\CivilWar\CivilWarMap02.nif`)**, gleiche Position), `NHV_Mk_MapTable_Veyra` (005ECD, XMarker, Position -6144.9 / -1181.0 / -15.5).
**Was:**
1. Script `NHV_MapTableScript` an `NHV_Ref_MapTable`: Properties `Core`, `NHV_Cfg_Debug`, `NHV_Msg_MapTable` (005EC4), `PlayerRef`, `Q01` (004000), `Q02` (004100), `VeyraTableMarker` (005ECD) gesetzt (laut Export vollständig). `Q03`, `Q04`, `Q05` **bleiben leer** (kommen mit M2.3 bis M2.5).
2. **Auffälligkeit:** Der Marker `NHV_Mk_MapTable_Veyra` liegt bei **Z -15,5**, der Tisch bei **Z 224**, rund 240 Einheiten (ca. 3,4 m) höher. Prüfen, ob Veyra am Marker nahe genug am Tisch steht (Raum mit zwei Ebenen?) oder der Marker neben den Tisch gehört. Position nur ändern, wenn es offensichtlich falsch ist, sonst melden (Frage 8, README).
3. Message `NHV_Msg_MapTable` (005EC4): 5 Buttons in der Reihenfolge Windhelm, Winterhold, Riften, The Reach, Step away.
4. Quest Q02: **Start Game Enabled** bleibt aus.
**Ergebnis:** Abgleich plus Antwort zu Punkt 2.

### K-Q02-02: Quest `NHV_Q02_ColdWaters` (004100) kontrollieren (alt B1, P1)

**Wo:** Object Window, **Character, Quest**, `NHV_Q02_ColdWaters`.
**Was (laut Export vorhanden, nur abgleichen):**
| Reiter | Soll |
|---|---|
| Quest Data | **Start Game Enabled** aus; Priorität 90 (laut M2.2) |
| Quest Stages | 10, 15, 20, 30, 40, 45, 50, 55, 60, 70, 100; Stage 100 mit Häkchen **Complete Quest**; jede Stage mit Journal-Text (15, 45, 55 neu) |
| Quest Objectives | Indizes 10, 15, 20, 30, 40, 45, 50, 55, 60, 70, 100 plus 71 und 101 (Index = Stage-Nummer) |
| Quest Aliases | 0 `PlayerRefAlias`, 1 `VeyraAlias`, 2 `SingsAlias`, 3 `TorbjornAlias`, 4 `DrinksAlias`, 5 `HaldorAlias`, 6 `AeliusAlias`, 7 `HjoraldAlias`, 8 `EnforcerAlias`, 9 `CourierAlias`, 10 `BabetteAlias`; alle **Optional**; 3 und 7 zusätzlich **Protected** |
| Scripts | `NHV_Q02Script`: Alias-Properties `EnforcerAlias`, `CourierAlias`, `BabetteAlias` und `TidehouseLedger` (AF30) gebunden; vier Properties sind **noch leer**, siehe CK-2 Ä-Q02-05 |
**Hinweis (K4 der Package-Anleitung):** Der Export zeigt das Flag `Protected` an `TorbjornAlias` und `HjoraldAlias` teils mehrfach. Wenn das CK beim Speichern auf eines reduziert, ist das richtig.
**Ergebnis:** Abgleich in der Rückmeldung. Fehlt ein Alias oder eine Stage: **nicht selbst anlegen**, melden (Regel 3).

### K-Q02-03: Alias-Packages von `SingsAlias` (alt B2, P1)

**Wo:** Quest `NHV_Q02_ColdWaters`, Reiter **Quest Aliases**, Alias 2 `SingsAlias` doppelklicken, Bereich **Alias Package Data**.
**Was (Reihenfolge laut Export):** `NHV_Pkg_Q02_SingsFollow` (AF40), `NHV_Pkg_Q02_SingsFleeHollow` (005960), `NHV_Pkg_Q02_SingsToHollow` (00595F), `NHV_Pkg_Q02_SingsHollow` (AF53), `NHV_Pkg_Q02_SingsHold` (AF54). `VeyraAlias` (1) und `HjoraldAlias` (7) haben **keine** ForceGreet-Packages mehr. Reihenfolge nicht umsortieren. Hinweis: 005960 und 00595F sind CK-eigene Packages aus der Teil-2-Anleitung (Bedingung Stage 40). `FleeHollow` ist praktisch tot, weil der gerettete Pfad nach Stage 45 führt; nicht löschen (Regel 3).
**Ergebnis:** Die fünf Einträge stehen in dieser Reihenfolge.

### K-Q02-04: Fraktion AF14, Package AF40, NPCs AF10/AF11 (alt B3, P2)

**Was:**
1. Object Window, **Character, Faction**, `NHV_Fac_DockEnforcer` (AF14): **keine Crime-Gruppe** (kein Kopfgeld, E54), **keine Relationen** (Feindschaft kommt per `StartCombat` aus dem Skript; wer die Enemy-Relation zur PlayerFaction möchte, ergänzt sie nach dem Test).
2. NPC `NHV_Q02_DockEnforcer` (AF10): Reiter **Factions** enthält AF14; NPC nicht Unique.
3. NPC `NHV_Q02_ImperialCourier` (AF11): keine Fraktion, nicht Unique.
4. Package `NHV_Pkg_Q02_SingsFollow` (AF40): Template Follow (019B2C), Ziel Spieler, Conditions Q02-Stage **>= 55 und < 60**.
**Ergebnis:** Alles wie beschrieben oder Abweichung melden.

### K-Q02-05: Die 20 neuen Packages und die NPC-Package-Listen (alt B4, P1)

**Wo:** Object Window, **Character, Package**, Filter `NHV_Pkg_Q02_`; danach je NPC Doppelklick, Reiter **AI Packages**.
**Was:**
1. Die 20 Packages AF50–AF63 (`SingsHideoutDay`, `SingsHideoutNight`, `SingsLurkWater`, `SingsHollow`, `SingsHold`, `TorbjornWork`, `TorbjornNightSleep`, `TorbjornNightAwake`, `DrinksWork`, `DrinksNightSleep`, `DrinksNightAwake`, `DrinksSaltYard`, `HaldorDocks`, `HjoraldPost`, `HjoraldNight`, `AeliusDay`, `AeliusNightAwake`, `AeliusNightSleep`, `EnforcerPost`, `CourierWait`) öffnen jeweils ohne Warnung. Auffälligkeiten zuerst bei `NearSelf` und der Sleep-Bett-Suche (Search Criteria).
2. Schedule und Conditions laut Tabelle in `docs/plan/Q02-NPC-Packages.md` Abschnitt 3 (Tag 06:00 plus 840 min, Nacht 20:00 plus 600 min; Stage-Bedingungen disjunkt).
3. NPC-Records 004107–00410C, AF10, AF11: Reiter **AI Packages** zeigt die Reihenfolge aus Abschnitt 3 der Package-Anleitung. **Nicht umsortieren.**
4. Sleep-Packages: `Lock Doors` und `Warn before locking` sind aus (laut Export; die Assemblage ist öffentlich).
**Ergebnis:** „K-Q02-05: ok“ oder die Liste auffälliger Packages mit Meldungstext.

### K-Q02-06: Szenen (alt B5, P2)

**Wo:** Quest `NHV_Q02_ColdWaters`, Reiter **Scenes**.
**Was:**
- Szene 004127 (`NHV_Scn_Q02_03AeliusKill`): 4 Phasen, Aliase 6 (Aelius) und 2 (Sings).
- Szene 004125 (`NHV_Scn_Q02_01HaldorDocks`): behält die Package-Aktion `SingsNightHunt` für Sings (Phase 1 bis 2); der Actor-Flag **Combat End** für Sings ist aus, **Death End** bleibt (Teil-2-Anleitung C3).
- Die 13 neuen Szenen (0xA045, 0xA04B, 0xA09A, 0xA0A0, 0xA0BC, 0xA0CB, 0xA0DA, 0xA106, 0xA10C, 0xA113, 0xA120, 0xA123, 0xA126): Aliase 2/4/8/9/10 mit **Optional**-Flag; keine Szene mit leerem Actor- oder Topic-Feld.
**Ergebnis:** Abgleich in der Rückmeldung.

### K-Q02-07: Alias-Typ prüfen, Ersatz für „Persistent“ (neu, aus alt B8/B9, P1)

**Hintergrund:** Der Haken „Persistent“ existiert im CK an Charakter-Refs nicht (Meldung des Entwicklers, 02.10.2026). Er wird **nicht mehr verlangt** (gestrichen bei Sings-Ref 005190 in CK-2 Ä-Q02-03, bei Haldor-Ref 005195 ersatzlos, bei Enforcer- und Kurier-Refs in CK-3). Die Erreichbarkeit der Refs sichert stattdessen die **Quest über Aliase**.
**Befund laut Export (`plugin-text/Quests/NHV_Q02_ColdWaters - 004100`, nachgelesen):**
| Alias | Typ laut Export | Bindung |
|---|---|---|
| 2 `SingsAlias` | **Unique Actor** (`UniqueActor: 004107`), kein Specific-Reference-Alias auf 005190 | NPC `NHV_SingsBeneathIce` hat das Flag **Unique** (laut Export) |
| 5 `HaldorAlias` | **Unique Actor** (`UniqueActor: 00410A`) | NPC `NHV_HaldorFrostKnuckle` hat das Flag **Unique** |
| 8 `EnforcerAlias`, 9 `CourierAlias` | Alias ohne Bindung im Export (Fill zur Laufzeit/Script) | AF10/AF11 sind nicht Unique |
Damit gilt: Die Quest hält Sings und Haldor über den Unique-Actor-Alias (Basis 004107 beziehungsweise 00410A); die platzierten Refs 005190 und 005195 sind die jeweils **einzigen** Refs dieser Unique-Basis. Ein Specific-Reference-Alias auf die Ref ist **nicht** vorhanden und nicht nötig, solange der Unique-Actor-Alias füllt. **Das Füllen eines Unique-Actor-Alias auf eine Initially-Disabled-Ref ist im Projekt ungetestet (im CK nicht prüfbar, nur ingame).**
**Wo:** Quest `NHV_Q02_ColdWaters`, Reiter **Quest Aliases**, Alias 2, 5, 8, 9 doppelklicken.
**Was (nur ansehen):**
1. Alias 2 und 5: Auswahl **Unique Actor** mit `NHV_SingsBeneathIce` beziehungsweise `NHV_HaldorFrostKnuckle`? Flags **Optional** (Alias darf leer bleiben)? Bestätigen oder abweichenden Typ melden.
2. Alias 8 und 9: welcher Typ und welche Fill-Einstellung steht im CK?
3. NPC-Records 004107 und 00410A: Flag **Unique** gesetzt (Reiter Traits).
**Rückfall im Script (laut `NHV_Q02Script.psc`, nachgelesen):** `GetSings()` und `GetHaldor()` rufen `ResolveActor(alias, FormID, abRefill)` auf: (1) `alias.GetActorRef()`; (2) ist das `None`, wird die Ref per **`Game.GetFormFromFile(0x005190 bzw. 0x005195, "NightsHarvest.esp")`** geholt und bei `abRefill` mit `ForceRefTo` in den Alias gelegt (Log: „ResolveActor: an empty alias was filled from the placed ref“; bei Sings nur unter Stage 100). Liefert auch das `None` (die Ref existiert nicht), meldet der Aufrufer es; `GetSings()` loggt „GetSings: SingsAlias property not set in the CK“ nur bei fehlender Property. Hinweis: Das Script enabliert Sings nur, wenn `IsDisabled()` und `SingsMayAppear()` (Stage 40–99 oder Stage 30 im Nachtfenster). **Offene Frage (nicht entschieden):** Ein `Enable()` auf eine Ref in einer ungeladenen Zelle über `GetFormFromFile` ist im Projekt ungetestet; Testkriterium ingame: Log „GetSings: enabling Sings (stage 30)“ **und** Sings sichtbar im Nachtfenster. Ohne Initially Disabled bleibt Variante A (Hollow-Packages `SingsHideoutDay/Night`) als sichtbarer Rückfall.
**Ergebnis:** Rückmeldung „K-Q02-07: Alias 2/5 = Unique Actor ja/nein, Alias 8/9 = <Typ>, Unique-Flag ja/nein“.

### K-Q02-08: Argonian Assemblage: nur ansehen (alt D9, P2)

**Wo:** Cell View, Interiors, **`WindhelmArgonianAssemblage` (016776), Vanilla**. **Nur ansehen, nichts verschieben, nichts speichern, keine Änderung** (Regel 1; nach dem Betrachten ohne Änderungen schließen; Frage 7 bei jeder ungewollten Änderung).
**Was (K5 der Package-Anleitung):** Außentür `0168EE` (in `WindhelmExterior`) ist für Drinks nachts passierbar (nicht abgeschlossen, keine Besitzsperre); Bett `0C92F3` (CommonBed01-Ref) hat **keine Besitzfraktion, die Drinks aussperrt** (Zelle `Owner 045F5C` laut Package-Anleitung). Mögliche Bett-Konkurrenz mit den vier Vanilla-NPCs.
**Ergebnis:** Falls Drinks im Test nicht schläft, melde, ob eines der Betten `0C92F0` bis `0C92F2` frei ist (FormKey ändert Claude in `BEDS`) oder die Bett-Suche besser ist. Das Drinks-Bett ist ein **Vanilla-Bett**, nur referenziert, **nichts platzieren** (siehe CK-3 N-Q02-08).

### K-Q02-09: Marsh Hitch, Aelius nachts, Dispatch-Ownership (alt D10, P2)

**Was:**
1. Marsh Hitch: vorhandenes `NHV_MISC_ReedWalkersKnot` (0057D3) nutzen, **kein neuer Record**; Fundort an der Leiche (005959) prüfen: liegt das Item dort oder wird es per Skript gegeben? (Laut Phase-B-Datei K7: Fundort prüfen.) Export: 0057D3 ist nirgends platziert.
2. Aelius steht nachts in seinem Büro (Zelle 0057DC), sonst hängt die Beobachtung bis zum Timeout: Ref 005953 steht im Kontor; Package `AeliusNightAwake` (AF62, Stage 55–59) greift nur mit Bett oder Raum.
3. `NHV_Q02_DispatchDeskRef` (005954): Ownership am Buch laut PROGRESS offen (30.09.): prüfen, ob ein Besitzer gesetzt ist, der den Spieler zum Dieb macht (Diebstahl-Warnung beim Aufheben).
**Ergebnis:** Antwort pro Punkt in der Rückmeldung.

### K-Q02-10: Q02: Navmesh an den neuen Refs (alt F2, P1, Phase 3)

**Wo:** `WindhelmDocksExterior01`, `NHV_Q02_HarborClerkOfficeCell`, `NHV_Q02_DrownedHollowCell`.
**Was (nur ansehen, nicht ändern; neu gezeichnet wird nur in CK-3 N-Q02-03):**
1. Docks: Tidehouse-Außentür-Landeplatz, `NHV_Q02_SaltYardMarker`, Salzplatz-Enforcer, Haldor-Marker, Torbjorn-Bett auf Navmesh; **Weg `NHV_Mk_Q02_SingsWater` bis Hollow-Tür durchgehend** (Teil-2-Anleitung D3). Windhelm Docks ist laut M2.2-Anleitung bereits vollständig navmesht; bestehendes Navmesh in Vanilla-Zellen **nicht** verändern.
2. Kontor: Kurier, Bett und Pult erreichbar. Die Zelle ist eine Palast-Kopie: das mitkopierte Navmesh passt nicht automatisch zur neuen Raumaufteilung (Export: ein Navmesh-Block). Wenn Aelius oder Kurier stehen bleiben, **Navmesh neu zeichnen und finalisieren** (Backup, K-ALL-01; Vorgehen wie CK-3 N-Q02-03).
3. Hollow: Sings-Bett, Marker `NHV_Mk_Q02_SingsHollow` und `NHV_Mk_Q02_VeyraHollow` (0057D9) auf Navmesh; Lücke an der Ladetür bedeutet: Sings bleibt stehen.
**Ergebnis:** Pro Ort „ok“ oder Lückenmeldung mit Zellenname. Es wird keine KI-/Wegtest-Behauptung abgegeben, bevor der Test lief.

### K-Q02-11: Q02-Bett-FormKeys melden (alt E2, P2)

**Was:** Im CK ist **nichts umzustellen**. Die drei FormKeys aus CK-3 N-Q02-08 gehen mit der Rückmeldung an Claude; er trägt sie in `BEDS` von `tools/build_q02_packages.py` ein (`TorbjornNightSleep`, `SingsHideoutNight`, `AeliusNightSleep`) und lässt das Tool erneut laufen (nicht `--write` des Hauptgenerators; Lehre 1). Danach öffnest du das ESP **einmal** im CK und speicherst (E17; kurzer Zweitdurchgang).
**Ergebnis:** Bis dahin suchen die drei Sleep-Packages ein Bett im Radius; das Drinks-Package nutzt das Vanilla-Bett 0C92F3.

---

## Checkliste (abhaken)

- [ ] K-ALL-01 ESP von Claude geschrieben und synchronisiert, Backup, Skripte in der Dev-Kopie
- [ ] K-ALL-02 SKSE-`ObjectReference.psc` kopiert, Fragment `QF_NHV_Q02_ColdWaters_02004100` kompiliert
- [ ] K-ALL-03 CK geladen, Ladewarnungen notiert
- [ ] K-ALL-04 Vanilla-Altlasten gemeldet
- [ ] K-ALL-05 FaceGen-Bestand, `0004DDA0` gemeldet
- [ ] K-ALL-06 Bücher/Items erreichbar
- [ ] K-ALL-07 Gespeichert, CK geschlossen, Backup
- [ ] K-Q00-01 Q00-Aliase und Lucien abgeglichen
- [ ] K-Q00-02 Dawnstar-Tür: nicht gesperrt
- [ ] K-Q00-03 Q00-Marker kontrolliert
- [ ] K-Q00-04 Q00-Navmesh beobachtet
- [ ] K-Q00-05 Encounter Zone „Never Resets“, Owner gemeldet
- [ ] K-Q01-01 Q01-Packages und Soldaten abgeglichen
- [ ] K-Q01-02 Q01-Navmesh kontrolliert
- [ ] K-Q01-03 Inn-Bett vorhanden
- [ ] K-Q02-01 Map Table abgeglichen (Z-Abstand beurteilt)
- [ ] K-Q02-02 Quest 004100 abgeglichen
- [ ] K-Q02-03 `SingsAlias`-Packages in der richtigen Reihenfolge
- [ ] K-Q02-04 Fraktion AF14, Package AF40, NPCs AF10/AF11
- [ ] K-Q02-05 20 Packages und NPC-Listen ohne Warnung
- [ ] K-Q02-06 Szenen abgeglichen
- [ ] K-Q02-07 Alias-Typen (Sings, Haldor, Enforcer, Kurier) gemeldet
- [ ] K-Q02-08 Assemblage angesehen, nichts gespeichert
- [ ] K-Q02-09 Marsh Hitch, Aelius nachts, Dispatch-Ownership
- [ ] K-Q02-10 Q02-Navmesh kontrolliert
- [ ] K-Q02-11 Bett-FormKeys notiert

## Rückmeldung an Claude (Chat) und Danach

Schick im Chat diese Liste (Unerledigtes mit „offen“ und Grund). FormKeys = die letzten 6 Stellen aus dem CK (die ersten beiden Stellen sind der Load-Order-Index und nicht Teil des FormKeys).

```
CK-1 (Kontrollieren) fertig (Datum, Dauer, CK-Version)
K-ALL-02: SKSE-ObjectReference.psc kopiert, Fragment kompiliert ja/nein (Fehlertext)
Ladewarnungen (K-ALL-03): ...
Erledigt: <Liste der Aufgaben-IDs>   Offen: <IDs + Grund>
Befunde: K-ALL-04, K-ALL-05 (0004DDA0), K-Q00-01 (Persistent-Feld an 004401 sichtbar ja/nein),
         K-Q00-02 (Türsperre), K-Q00-05 (Never Resets, Owner), K-Q01-03, K-Q02-01 (Z-Abstand),
         K-Q02-07 (Alias-Typen), K-Q02-08 (Assemblage-Betten), K-Q02-09 Punkte 1 bis 3,
         K-Q02-10 / K-Q01-02 Navmesh-Lücken (Zellenname)
Bett-FormKeys für BEDS (K-Q02-11, aus CK-3 N-Q02-08):
  NHV_Bed_Q02_Torbjorn / _Sings / _Aelius = ...
Geänderte Zellen (für die E16-Tabelle in ARCHITECTURE.md): <Zelle (FormID): neue Refs / geänderte Felder>
Antworten auf Fragen (README): ...
Sonstiges (Absturz, Warnungen): ...
```

**Nach dem CK (macht Claude):** `sync_dev.ps1 -Direction FromDev`, `plugin_text.ps1 -Direction ToText`, Export prüfen (neue FormKeys, Properties, Betten, Vanilla-Overrides), `tools\build_q02_packages.py` mit den Bett-FormKeys (`BEDS`), E16-Einträge in `docs/ARCHITECTURE.md`, ROADMAP (Status „Test“) und PROGRESS. Setzt Claude danach per Spriggit noch Werte (z. B. Q01-Packages, Farmtür-Teleport), folgt ein **zweiter, kurzer CK-Durchgang** (ESP öffnen, speichern), nie parallel. Commit durch dich, kein Push, kein Tag.
