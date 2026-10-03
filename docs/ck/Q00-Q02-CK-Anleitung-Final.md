> **Ersetzt durch `CK-1-Nur-Kontrollieren.md`, `CK-2-Nur-Aendern.md`, `CK-3-Nur-Neu.md` (Einstieg: `README-CK-Anleitungen.md`), Stand 02.10.2026.** Diese Datei bleibt nur als Quelle liegen und wird nicht mehr gepflegt. Insbesondere sind hier die Aufgaben mit „Persistent“ (B8, B9, D1 bis D4, D6, D8, D11) **überholt**: Der Haken existiert im CK an Charakter-Refs nicht (siehe CK-1 K-Q02-07), und der Compile-Fehler `SetDisplayName` ist in CK-1 K-ALL-02 gelöst. Zuordnung alte zu neuen IDs: Tabelle in CK-1.

# CK-Anleitung Q00–Q02 (final): alle offenen CK-Punkte in einem Durchgang

Stand: 02.10.2026 (Fassung 1). **Nichts hiervon ist ingame getestet.** Diese Datei fasst zusammen und löst Duplikate auf aus:
`docs/plan/Q02-Phase-B-Ergebnis.md` (Abschnitt 9), `docs/plan/Q02-NPC-Packages.md`, `docs/plan/Q01-NPC-Packages.md`, `docs/ck/M1.7-Q01-Enhanced-CK-Anleitung.md`, `docs/ck/M2.0-Map-Table.md`, `docs/ck/M2.2-Q02-CK-Anleitung*.md`, `docs/ck/M1.3-Deep-Sanctuary-*`, `docs/PROGRESS.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md` und dem Export in `plugin-text/` (Stand 02.10.2026). Bei Widersprüchen gilt die jeweils neueste Fassung; wo ich einen Widerspruch aufgelöst habe, steht es bei der Aufgabe.

**Wie sicher ist was?** Alle Angaben „laut Export“ stammen aus `plugin-text/` (nachgelesen, nicht geraten). Vanilla-Namen mit Model-Pfad sind über `housecarl_records` gegen `Skyrim.esm` geprüft und als **(geprüft)** markiert. Alles, was ich nicht prüfen konnte, steht als **(im CK prüfen)**. CK-Menü- und Feldnamen können in deiner Version leicht abweichen: Zeigt das CK etwas anderes, melde, was du siehst.

## 0. Voraussetzung (E17, Ein-Schreiber-Regel): zuerst lesen

1. **CK und Claude arbeiten nie gleichzeitig am ESP.** Solange das CK offen ist, schreibt Claude weder Spriggit-Text noch das ESP.
2. **Das ESP wird vor dem CK-Start von Claude aus dem Repo-Stand geschrieben** (`tools\plugin_text.ps1 -Direction ToPlugin`) und per `tools\sync_dev.ps1 -Direction ToDev -IncludeEsp` in die Dev-Kopie (`C:\Dev\brotherhood-devenv\SkyrimSE-Dev`) gelegt. **Starte das CK erst, wenn Claude „ESP geschrieben und synchronisiert“ gemeldet hat.** Ohne diesen Schritt fehlen dir Phase-B-Records (Q02 Enhanced, Pakete 0xAF50–0xAF63, Q01-Pakete 0xAD00–0xAD20), und Nachträge gehen verloren.
3. Skripte: die kompilierten `.pex` und die `.psc` (`Data\Source\Scripts`) müssen in der Dev-Kopie liegen, sonst fehlen im CK die Script-Properties (z. B. `RequiredStageMax`, `TidehouseEnforcerRefs`).
4. **Vor jedem Navmesh-Abschnitt (Phase F) ein ESP-Backup** (Kopie von `NightsHarvest.esp` mit Datum).
5. **Keine Vanilla-Records ändern** (Regel 1). Neue Objekte bekommen das Präfix `NHV_`. Vanilla-Basisobjekte nur **duplizieren** (Rechtsklick im Object Window, Duplicate, sofort EditorID ändern). Jede neue Referenz in einer Vanilla-Zelle erzeugt eine Zell-Kopie (E16-Ausnahme, wird von Claude nach deiner Meldung in `docs/ARCHITECTURE.md` nachgetragen; offen ist dort weiterhin `WindhelmDocksExterior01` 00B4B9, Q2-28).
6. **Alle Änderungen in einer Sitzung, am Ende einmal speichern, CK schließen**, dann Meldung (Abschnitt 12). Zwischenspeichern (Strg+S) ist erlaubt und erwünscht.
7. Keine neuen harten Abhängigkeiten. Alles hier benutzt nur `Skyrim.esm`/`Update.esm`.

## 1. Übersichtstabelle aller Aufgaben

Typ: **N** = NEU ERSTELLEN, **Ä** = ÄNDERN, **K** = NUR KONTROLLIEREN. Prio: **P1** blockiert den Test des Quest-Ablaufs, **P2** wichtig, **P3** später/optional. Aufwand: grobe Schätzung.

| Nr. | Quest | Typ | Ort | Prio | Aufwand | Kurzbeschreibung |
|---|---|---|---|---|---|---|
| A1 | alle | K | Repo, Dev-Kopie | P1 | 10 min | ESP-Stand, Skripte, Backup |
| A2 | alle | K | CK | P1 | 10 min | CK starten, Ladewarnungen notieren |
| A3 | Q00/Q02 | K | Zellen (Vanilla-Altlasten) | P3 | 20 min | Nur melden, nichts löschen |
| B1 | Q02 | K | Quest 004100 | P1 | 15 min | Aliase 1–10, Stages, Objectives, Protected |
| B2 | Q02 | K | Quest 004100, Alias `SingsAlias` | P1 | 10 min | Alias-Packages, keine ForceGreet |
| B3 | Q02 | K | Fraktion AF14, Package AF40, NPCs AF10/AF11 | P2 | 15 min | Enforcer-Fraktion, Follow-Package |
| B4 | Q02 | K | 20 Packages AF50–AF63, NPC-Records | P1 | 30 min | Laden ohne Warnung, Reihenfolge |
| B5 | Q02 | K | Szenen 004125/004127 und neue 0xA0xx | P2 | 20 min | Aliase, Phasen, Packages |
| B6 | Q02 | Ä | Hollow-Tür-Ref 0057D4 | P1 | 5 min | `RequiredStageMax = 45` |
| B7 | Q02 | Ä | Leichen-Ref 005959 | P1 | 5 min | `RequiredStage 20`, `TargetStage 0` |
| B8 | Q02 | Ä | Sings-Ref 005190 | P1 | 5 min | Initially Disabled + Persistent |
| B9 | Q02 | Ä | Haldor-Ref 005195 | P1 | 5 min | Persistent (Rückkehr Stage 100) |
| B10 | Q01 | K | Packages, Aliase, Soldaten | P2 | 30 min | K1–K7 aus Q01-NPC-Packages |
| B11 | M2.0 | K | Ledger Room, Map Table | P2 | 15 min | Properties, Z-Abstand Marker/Tisch |
| B12 | Q00 | K | Quest 000815, Lucien, Sys-Quests | P2 | 20 min | Packages, Aliase, Lucien-Records |
| C1 | Q02 | N | Windhelm Docks außen + neue Innenzelle | P1 | 2–3 h | Tidehouse-Zelle mit Türen |
| C2 | Q02 | Ä | Zellen Kontor und Hollow | P2 | 45 min | Name, EditorID, Location, Owner, Vanilla-Reste |
| C3 | Q01 | Ä | Farmtür 00497B/004976 | P2 | 30 min | Teleport-Landung und Blickrichtung |
| C4 | Q00/Q01 | K | Dawnstar Sanctuary ↔ Deep Sanctuary | P2 | 20 min | Ladetür, Veyras Türweg (K5) |
| C5 | Q00 | N/Ä | `NHV_DeepSanctuaryCell` (M1.3) | P3 | mehrere Tage | Fünf Räume, Room Bounds, Portale, Enable-Parents |
| D1 | Q02 | N | Docks außen | P1 | 20 min | Salzplatz-Marker |
| D2 | Q02 | N | Docks außen | P1 | 45 min | 2–3 Enforcer, Messer, Sluice Token |
| D3 | Q02 | N | Tidehouse innen | P1 | 1–2 h | 2 Enforcer, Ledger, Möbel, Licht |
| D4 | Q02 | N | Kontor | P1 | 30 min | Kurier-Ref (disabled), Imperial Seal |
| D5 | Q02 | N | Kontor | P3 | 15 min | Chiffre-Schlüsselbuch |
| D6 | Q02 | N | Docks, Hollow, Kontor | P2 | 45 min | Drei Betten N6 |
| D7 | Q02 | N | Docks, Kontor | P3 | 45 min | Idle-Möbel und Schreibtisch |
| D8 | Q02 | N | Docks außen | P3 | 10 min | Haldor-Rückkehr-Marker (optional) |
| D9 | Q02 | K | Vanilla `WindhelmArgonianAssemblage` | P2 | 20 min | Nur ansehen, nichts speichern |
| D10 | Q02 | K | Docks, Kontor | P2 | 15 min | Marsh Hitch, Aelius nachts |
| D11 | Q01 | N | 5 Orte | P2 | 1–2 h | Betten B1–B5 |
| D12 | Q01 | N | Steg, Lager, Küche, Hof | P3 | 1–2 h | Möbel N1–N4 |
| D13 | Q00 | K | Deep Sanctuary | P3 | 15 min | Lucien, Memorial-Marker, Plaketten |
| E1 | Q02 | Ä | Quest 004100, Script-Properties | P1 | 15 min | 4 neue Properties füllen |
| E2 | Q02 | K | Bett-FormKeys | P2 | 5 min | Nur melden (`BEDS` trägt Claude ein) |
| E3 | Q01 | Ä | 5 Sleep-Packages | P2 | 30 min | Location auf Bett-Refs |
| F1 | Q02 | N | Tidehouse innen | P1 | 1 h | Navmesh zeichnen, finalisieren |
| F2 | Q02 | K | Docks, Hollow, Kontor | P1 | 30 min | Navmesh an neuen Refs |
| F3 | Q01 | K | Marker, Betten, Farmtür | P2 | 30 min | Navmesh-Kontrolle |
| F4 | Q00 | K | Deep Sanctuary, Dawnstar-Tür | P2 | 20 min | Navmesh-Kontrolle |
| G1 | Q02 | N | Enforcer AF10, Kurier AF11 | P1 | 1 h | Gesicht, Outfit, FaceGen |
| G2 | alle | K | FaceGen-Dateien | P2 | 10 min | Fremd-NIF 0004DDA0, Vollständigkeit |
| H1 | Q02 | N | Misc-Items AF31–AF33 | P3 | 15 min | Model und Wert setzen |
| H2 | alle | K | Bücher/Items | P2 | 15 min | Platzierungs-Kontrolle |
| I1 | alle | K | CK | P1 | 10 min | Speichern, schließen |
| I2 | alle | – | Chat | P1 | 15 min | Rückmeldung „Q00–Q02 im CK fertig“ |

Anzahl: Q02 27 Aufgaben, Q01 6, Q00 5, M2.0 1, übergreifend 7 (A1–A3, G2, H2, I1, I2).

**Empfohlene Reihenfolge, wenn die Zeit knapp ist (Q02-Test freischalten):** A1, A2, B6, B7, B8, B9, C1, D1, D2, D3, D4, G1, E1, F1, F2, I1. Alles andere ist für den ersten Q02-Durchlauf verzichtbar (Fallbacks im Script, siehe Hinweise bei den Aufgaben).

## 2. Grundgriffe im CK (einmal lesen)

| Aufgabe | Wo / Wie |
|---|---|
| Zelle öffnen | Menü **World, Cell View**. Oben **World Space** wählen: `Tamriel` für Außenzellen, `Interiors` für Innenräume. Außenzelle: Spalten X/Y oder Suchfeld; Doppelklick in der linken Liste lädt die Zelle ins **Render Window**. Windhelm Docks: `WindhelmDocksExterior01` (00B4B9), Tamriel, Gitter 34/8 laut Export. |
| Objekt suchen | **Object Window** (links), Baum links, Feld **Filter** oben (filtert EditorID und Name). |
| Objekt platzieren | Eintrag im Object Window anklicken und **ins Render Window ziehen**. Taste **F** setzt es auf den Boden/die Oberfläche darunter. |
| Referenz bearbeiten | **Doppelklick auf das Objekt im Render Window** öffnet den Dialog „Reference“: **EditorID** (oben), Haken **Persistent**, **Initially Disabled**, Reiter **3D Data** (Position, Rotation), Reiter **Scripts**, Feld **Enable Parent**. Reiternamen im CK prüfen. |
| Position ablesen/setzen | Ref-Dialog, Reiter **3D Data**, Werte X/Y/Z und Rotation. Ca. 70 Einheiten entsprechen 1 m. |
| Navmesh sichtbar | Render Window: Taste **M** (Navmesh-Anzeige), Navmesh-Bearbeitung über Menü **World, Navmesh** bzw. die Navmesh-Werkzeugleiste (im CK prüfen). |
| FaceGen | NPC im Object Window markieren, **Strg+F4** (oder im Preview-Fenster des NPC). |
| Duplicate | Object Window: Rechtsklick auf den Eintrag, **Duplicate**; im sich öffnenden Dialog **sofort EditorID ändern**, OK. Nie das Original speichern. |
| Quest-Script-Properties | Object Window, **Character, Quest**, Quest doppelklicken, Reiter **Scripts**, Script markieren, **Properties**, Zeile markieren, **Edit Value** (Arrays: im Dialog Einträge hinzufügen, im CK prüfen). |
| Package öffnen | Object Window, **Character, Package**, Doppelklick, Reiter **Package Data** (Ort), **Conditions**, **Schedule**. |
| FormID/FormKey ablesen | Ref-Dialog oder Object-Window-Spalte „FormID“. Die ersten beiden Stellen sind der Load-Order-Index im CK und **nicht** Teil des FormKeys. Melde die letzten 6 Stellen. |

---

## Phase A: Vorbereitung und ESP-Stand

### A1: ESP-Stand und Voraussetzungen (K, alle, P1)

**Wo:** Repo und Dev-Kopie, nicht das CK.
**Was:**
1. Claude meldet: „ToPlugin gelaufen, ESP per ToDev -IncludeEsp in der Dev-Kopie, Hash identisch.“ Erst dann weiter.
2. Das Spiel ist **geschlossen** (die ESP-Datei ist sonst gesperrt).
3. Backup: `NightsHarvest.esp` aus der Dev-Kopie als `NightsHarvest.esp.bak-2026-10-02` daneben kopieren.
4. In `Data\Source\Scripts` der Dev-Kopie liegen `NHV_Q02Script.psc`, `NHV_Q02_StageActivatorScript.psc` (Property `RequiredStageMax`), `NHV_MapTableScript.psc`.
**Ergebnis/Prüfung:** Backup vorhanden; Claude hat den Sync bestätigt.

### A2: CK starten und Ladewarnungen notieren (K, alle, P1)

**Wo:** CK, **File, Data**: aktive Datei `NightsHarvest.esp` (Set as Active File), Master `Skyrim.esm`, `Update.esm` (laut E05).
**Was:** Laden. Jede Meldung (fehlende Master, „form not found“, Script-Warnungen) abschreiben, nicht speichern, nicht wegklicken ohne Notiz.
**Ergebnis:** Eine Liste der Ladewarnungen für die Rückmeldung. Erwartet: keine fehlenden Master. Vanilla-Altlasten in A3 können Warnungen erzeugen.

### A3: Vanilla-Altlasten nur melden (K, Q00/Q02, P3)

**Wo:** Cell View.
**Was (laut Export und PROGRESS 30.09.): nichts löschen, nur ansehen und melden, ob der Befund noch stimmt.** Die Entscheidung trifft der Entwickler (Fragen 7 und 12).
| Fund | Zelle |
|---|---|
| Vanilla-Zelle `DeepSanctuaryNEW` (016204), 181 platzierte Refs im Export, kein NHV-Eintrag. Regel 1 verbietet Änderungen an Vanilla-Records. | Interiors |
| Vanilla-Reste in den duplizierten Zellen: `TGCrown09Go001`, `TGCrownGemAct010`, `WindhelmPalaceUp1PatrolB004`, `WindhelmWuunferthLabMarker001` im Kontor (0057DC); `LargashburBasementToExterior001` und weitere Vanilla-Objekte in der Hollow (0051AB) | Interiors |
| `ChillfurrowFarmDUPLICATE001` (004FD8), 419 Refs, keine NHV-Records | Interiors |
**Ergebnis:** Im Rückmeldeformat „A3: unverändert“ oder die Abweichung.

---

## Phase B: Kontrolle und Korrektur bestehender Records

### B1: Quest `NHV_Q02_ColdWaters` (004100) kontrollieren (K, Q02, P1)

**Wo:** Object Window, **Character, Quest**, `NHV_Q02_ColdWaters`.
**Was (laut Export vorhanden, nur abgleichen):**
| Reiter | Soll |
|---|---|
| Quest Data | **Start Game Enabled** aus; Priorität 90 (laut M2.2) |
| Quest Stages | 10, 15, 20, 30, 40, 45, 50, 55, 60, 70, 100; Stage 100 mit Häkchen **Complete Quest**; jede Stage mit Journal-Text (15, 45, 55 neu) |
| Quest Objectives | Indizes 10, 15, 20, 30, 40, 45, 50, 55, 60, 70, 100 plus 71 und 101 (Index = Stage-Nummer) |
| Quest Aliases | 0 `PlayerRefAlias`, 1 `VeyraAlias`, 2 `SingsAlias`, 3 `TorbjornAlias`, 4 `DrinksAlias`, 5 `HaldorAlias`, 6 `AeliusAlias`, 7 `HjoraldAlias`, 8 `EnforcerAlias`, 9 `CourierAlias`, 10 `BabetteAlias`; alle **Optional**; 3 und 7 zusätzlich **Protected** |
| Scripts | `NHV_Q02Script`: Alias-Properties `EnforcerAlias`, `CourierAlias`, `BabetteAlias` und `TidehouseLedger` (AF30) gebunden; vier Properties sind **noch leer**, siehe E1 |
**Hinweis (K4 der Package-Anleitung):** Der Export zeigt das Flag `Protected` an `TorbjornAlias` und `HjoraldAlias` teils mehrfach. Wenn das CK beim Speichern auf eines reduziert, ist das richtig.
**Ergebnis:** Abgleich in der Rückmeldung. Fehlt ein Alias oder eine Stage: **nicht selbst anlegen**, melden (Regel 3).

### B2: Alias-Packages von `SingsAlias` (K, Q02, P1)

**Wo:** Quest `NHV_Q02_ColdWaters`, Reiter **Quest Aliases**, Alias 2 `SingsAlias` doppelklicken, Bereich **Alias Package Data**.
**Was (Reihenfolge laut Export):** `NHV_Pkg_Q02_SingsFollow` (AF40), `NHV_Pkg_Q02_SingsFleeHollow` (005960), `NHV_Pkg_Q02_SingsToHollow` (00595F), `NHV_Pkg_Q02_SingsHollow` (AF53), `NHV_Pkg_Q02_SingsHold` (AF54). `VeyraAlias` (1) und `HjoraldAlias` (7) haben **keine** ForceGreet-Packages mehr. Reihenfolge nicht umsortieren. Hinweis: 005960 und 00595F sind CK-eigene Packages aus der Teil-2-Anleitung (Bedingung Stage 40). `FleeHollow` ist praktisch tot, weil der gerettete Pfad nach Stage 45 führt; nicht löschen (Regel 3).
**Ergebnis:** Die fünf Einträge stehen in dieser Reihenfolge.

### B3: Fraktion AF14, Package AF40, NPCs AF10/AF11 (K, Q02, P2)

**Was:**
1. Object Window, **Character, Faction**, `NHV_Fac_DockEnforcer` (AF14): **keine Crime-Gruppe** (kein Kopfgeld, E54), **keine Relationen** (Feindschaft kommt per `StartCombat` aus dem Skript; wer die Enemy-Relation zur PlayerFaction möchte, ergänzt sie nach dem Test).
2. NPC `NHV_Q02_DockEnforcer` (AF10): Reiter **Factions** enthält AF14; NPC nicht Unique.
3. NPC `NHV_Q02_ImperialCourier` (AF11): keine Fraktion, nicht Unique.
4. Package `NHV_Pkg_Q02_SingsFollow` (AF40): Template Follow (019B2C), Ziel Spieler, Conditions Q02-Stage **>= 55 und < 60**.
**Ergebnis:** Alles wie beschrieben oder Abweichung melden.

### B4: Die 20 neuen Packages und die NPC-Package-Listen (K, Q02, P1)

**Wo:** Object Window, **Character, Package**, Filter `NHV_Pkg_Q02_`; danach je NPC Doppelklick, Reiter **AI Packages**.
**Was:**
1. Die 20 Packages AF50–AF63 (`SingsHideoutDay`, `SingsHideoutNight`, `SingsLurkWater`, `SingsHollow`, `SingsHold`, `TorbjornWork`, `TorbjornNightSleep`, `TorbjornNightAwake`, `DrinksWork`, `DrinksNightSleep`, `DrinksNightAwake`, `DrinksSaltYard`, `HaldorDocks`, `HjoraldPost`, `HjoraldNight`, `AeliusDay`, `AeliusNightAwake`, `AeliusNightSleep`, `EnforcerPost`, `CourierWait`) öffnen jeweils ohne Warnung. Auffälligkeiten zuerst bei `NearSelf` und der Sleep-Bett-Suche (Search Criteria).
2. Schedule und Conditions laut Tabelle in `docs/plan/Q02-NPC-Packages.md` Abschnitt 3 (Tag 06:00 plus 840 min, Nacht 20:00 plus 600 min; Stage-Bedingungen disjunkt).
3. NPC-Records 004107–00410C, AF10, AF11: Reiter **AI Packages** zeigt die Reihenfolge aus Abschnitt 3 der Package-Anleitung. **Nicht umsortieren.**
4. Sleep-Packages: `Lock Doors` und `Warn before locking` sind aus (laut Export; die Assemblage ist öffentlich).
**Ergebnis:** „B4: ok“ oder die Liste auffälliger Packages mit Meldungstext.

### B5: Szenen (K, Q02, P2)

**Wo:** Quest `NHV_Q02_ColdWaters`, Reiter **Scenes**.
**Was:**
- Szene 004127 (`NHV_Scn_Q02_03AeliusKill`): 4 Phasen, Aliase 6 (Aelius) und 2 (Sings).
- Szene 004125 (`NHV_Scn_Q02_01HaldorDocks`): behält die Package-Aktion `SingsNightHunt` für Sings (Phase 1 bis 2); der Actor-Flag **Combat End** für Sings ist aus, **Death End** bleibt (Teil-2-Anleitung C3).
- Die 13 neuen Szenen (0xA045, 0xA04B, 0xA09A, 0xA0A0, 0xA0BC, 0xA0CB, 0xA0DA, 0xA106, 0xA10C, 0xA113, 0xA120, 0xA123, 0xA126): Aliase 2/4/8/9/10 mit **Optional**-Flag; keine Szene mit leerem Actor- oder Topic-Feld.
**Ergebnis:** Abgleich in der Rückmeldung.

### B6: Hollow-Tür-Ref 0057D4: `RequiredStageMax` setzen (Ä, Q02, P1) (Ä1 der Phase-B-Datei)

**Wo:** Cell View, World Space `Tamriel`, Zelle `WindhelmDocksExterior01`; Hollow-Außentür (Base `NHV_Q02_DrownedHollowDoorExt` 00519C) im Render Window anklicken, bei Position 143424 / 37408 / -13824 laut Export. Alternativ Object Window, **World Objects, Door**, Ref über **Cell View, Reiter References** (FormID 0057D4 suchen). Doppelklick, Reiter **Scripts**, Script `NHV_Q02_StageActivatorScript`, **Properties**.
**Was:** Neue Property `RequiredStageMax` (Int) = **45**. `RequiredStage` bleibt **40**, `TargetStage` bleibt **50** (laut Export aktuell 40/50, `RequiredStageMax` fehlt noch). Teleport-Ziel unverändert (Tür 0057D7 in der Hollow, Landung 1568 / 1920 / 32).
**Ergebnis:** Ohne diesen Wert führt der Salzplatz-Pfad (Stage 45) nicht in den Hollow, falls der Laufzeit-Patch `PatchStageActivators()` ausfällt.

### B7: Leichen-Ref 005959: `RequiredStage` und `TargetStage` (Ä, Q02, P1) (Ä2)

**Wo:** Zelle `WindhelmDocksExterior01`, Ref `NHV_Q02_VictimCorpseRef` (005959, Position 142235 / 36068 / -13946 laut Export), Doppelklick, Reiter **Scripts**, `NHV_Q02_StageActivatorScript`, **Properties**.
**Was:** `RequiredStage` von 10 auf **20**; `TargetStage` von 20 auf **0**. `OwningQuest` und `NHV_Cfg_Debug` bleiben. (Laut Export aktuell 10/20.) Der Aktivator 00411E ist nirgends platziert: nicht platzieren.
**Ergebnis:** Das Untersuchen der Leiche springt nicht bei Stage 10 auf Stage 20 und überspringt damit die Tidehouse nicht.

### B8: Sings-Ref 005190: Initially Disabled und Persistent (Ä, Q02, P1) (Nachtrag Koordinator a)

**Wo:** Zelle `WindhelmDocksExterior01`, Ref `NHV_SingsBeneathIceRef` (005190, Position 139744 / 34304 / -13952 laut Export; laut Export derzeit **nicht** Persistent und **nicht** disabled).
**Was:** Im Ref-Dialog **Initially Disabled** anhaken **und Persistent** anhaken. Der Grund für Persistent: Das Skript muss die Ref aus einer anderen Zelle aktivieren können (ein `Enable()` auf eine nicht geladene, nicht persistente Ref ist unzuverlässig, im CK nicht prüfbar, deshalb sicherheitshalber).
**Abhängigkeit (Stand `docs/plan/Q02-NPC-Packages.md`, Aufgabe Ä4):** Das Skript enabliert Sings ab Stage 30 im Nachtfenster (Skript-Seite nach Angabe jener Datei umgesetzt, hier nicht geprüft). Ohne die Haken bleibt Variante A (Hollow-Packages `SingsHideoutDay/Night`, AF50/AF51) als Rückfall aktiv: Sings ist dann am Hafen sichtbar, bis er in die Hollow geht. Vor Stage 30 ist Sings mit den Haken in Windhelm **nicht sichtbar** (gewollt).
**Ergebnis:** Beide Haken gesetzt. Rückmeldung „B8 gesetzt“.

### B9: Haldor-Ref 005195: Persistent (Ä, Q02, P1) (Nachtrag Koordinator b)

**Wo:** Zelle `WindhelmDocksExterior01`, Ref `NHV_HaldorFrostKnuckleRef` (005195, Position 142048 / 36000 / -13920 laut Export; derzeit nicht Persistent).
**Was:** Haken **Persistent** setzen. **Nicht** Initially Disabled. Haldor wird laut `Q02-NPC-Packages.md` ab Stage 45 per Skript deaktiviert (`HideHaldor()`) und ab Stage 100 wieder aktiviert (`ShowHaldor()`; lebend: läuft am Kai herum; tot: bleibt als Leiche liegen). **Hinweis:** Persistent verlangt jene Datei nicht ausdrücklich; es ist **mein Vorschlag**, damit `Enable()` aus einer anderen Zelle zuverlässig greift (analog Sings, Ä4). Frage 11.
**Ergebnis:** Haken gesetzt. Rückkehr-Platz: siehe D8 (optional).

### B10: Q01 Packages, Aliase und Soldaten (K, Q01, P2)

**Wo:** Object Window, **Actors, Actor** (NPCs), **Character, Quest**, **Character, Package**.
**Was (K1 bis K7 der Q01-Package-Anleitung, laut Export alles vorhanden):**
1. Reiter **AI Packages** von `NHV_Hakan` (004006: AD01, AD00 vor 498B), `NHV_Hrefna` (004007: AD0E, AD05, AD03, AD02 vor 498C), `NHV_Quintus` (004008: AD07, AD09, AD08 vor 498D/4989), `NHV_Veyra` (000817: AD10, AD11, AD12): neue Packages oben, alte unten, **nicht umsortieren**.
2. Soldaten `NHV_Q01_WatchpostSoldier` (0089F2): im Reiter AI Packages nur `NHV_Pkg_Q01_SoldierWatch` (AD0A); im Template-Bereich sind **AI Packages** und **Def Pack List** nicht mehr angehakt (Template 01FC5B). Offene Frage F9: Nebenwirkungen des entfernten Template-Flags im Test beobachten.
3. Quest `NHV_Q01_TheUnansweredSacrament` (004000): `VeyraAlias` = 7F30, 4991, AD0B, AD0C; `HrefnaAlias` = AD0F, AD0D, 498E, AD04; Quest `NHV_Sys_Family`, Alias `HrefnaSlot`: AD06, 4992.
4. Global `NHV_Q01_QuintusAtFarm` (00AD20) existiert (GlobalShort).
5. Scout (007F21), Marsh Scavenger (007F20): Basis-Package `0956B8`.
6. `NHV_Pkg_Q01_VeyraTrialHold` (004991) bleibt als ungenutzter Record bestehen (Regel 3); nichts ändern.
**Ergebnis:** Abgleich in der Rückmeldung.

### B11: Map Table (M2.0) (K, M2.0, P2)

**Wo:** Cell View, Interiors, `NHV_DeepSanctuaryCell`; Refs `NHV_Ref_MapTable` (005ECC, Base `NHV_Act_MapTable` 005EC5, Position -6304 / -1344 / 224), `NHV_Ref_MapTable_Map` (005ECE, Static `CivilWarMap02` 070BC2 **(geprüft, Model `Clutter\CivilWar\CivilWarMap02.nif`)**, gleiche Position), `NHV_Mk_MapTable_Veyra` (005ECD, XMarker, Position -6144.9 / -1181.0 / -15.5).
**Was:**
1. Script `NHV_MapTableScript` an `NHV_Ref_MapTable`: Properties `Core`, `NHV_Cfg_Debug`, `NHV_Msg_MapTable` (005EC4), `PlayerRef`, `Q01` (004000), `Q02` (004100), `VeyraTableMarker` (005ECD) gesetzt (laut Export vollständig). `Q03`, `Q04`, `Q05` **bleiben leer** (kommen mit M2.3 bis M2.5).
2. **Auffälligkeit:** Der Marker `NHV_Mk_MapTable_Veyra` liegt bei **Z -15,5**, der Tisch bei **Z 224**, rund 240 Einheiten (ca. 3,4 m) höher. Prüfen, ob Veyra am Marker nahe genug am Tisch steht (Raum mit zwei Ebenen?) oder der Marker neben den Tisch gehört. Position nur ändern, wenn es offensichtlich falsch ist, sonst melden (Frage 8).
3. Message `NHV_Msg_MapTable` (005EC4): 5 Buttons in der Reihenfolge Windhelm, Winterhold, Riften, The Reach, Step away.
4. Quest Q02: **Start Game Enabled** bleibt aus.
**Ergebnis:** Abgleich plus Antwort zu Punkt 2.

### B12: Q00: Quest, Aliase, Lucien (K, Q00, P2)

**Wo:** Quest `NHV_Q00_ShadowAtTheDoor` (000815), Quest `NHV_Sys_Sanctuary` (000809), NPC `NHV_LucienSpirit` (004400).
**Was (laut Export vorhanden):**
1. Q00-Aliase: Veyra (Packages 000DD7, 003D90, 003D94, 0037EF, 0037DE, 0037DF, 0037E0), Nazir (ForcedReference 01C3AD), Babette (01D4BC), Cicero (09BCB0; zusätzlich Package 006102 `NHV_Pkg_Q00V2_R_cicero_memory_p0`), Alias 4 `NightMotherCoffin` (074766). Stage 12 vorhanden (Objective 12), Objectives 31 und 61.
2. Lucien: Ref `NHV_Ref_Sys_Lucien` (004401, Persistent und **Initially Disabled**, Position -5300 / -1520 / -14), Marker `NHV_Mk_Sys_LucienSpot` (004402), Package `NHV_Pkg_Sys_LucienStand` (004404). FaceGen vorhanden (00004400.NIF).
3. **Nichts ändern, nur abgleichen.** Q00 lief laut PROGRESS (30.09./01.10.) durch; Lucien-Ansprechbarkeit war zuletzt offen (kein Log).
**Ergebnis:** Abgleich in der Rückmeldung; Auffälligkeiten melden.
**Frage zu Q00-NPCs ohne Idle-Package:** siehe Fragen am Ende (Frage 9): Q00-NPCs außerhalb der Szenen sind **nicht beauftragt**, es gibt dafür keine eigene Aufgabe in dieser Anleitung.

---

## Phase C: Zellen und Türen

### C1: Tidehouse-Innenzelle mit Türen (N, Q02, P1) (N1)

**Ziel:** Der Spieler betritt in Stage 15 die versiegelte Tidehouse, Dock Enforcer sprechen zuerst und greifen dann an (Skript `TidehouseHostile()`), das Ledger (AF30) liegt auf einem Tisch.
**Ohne diese Aufgabe:** Stage 15 funktioniert über den Rettungsweg (`OnTidehouseBriefed()` übergibt das Ledger selbst, Log „TidehouseEnforcerRefs not set“). Der Ablauf bleibt spielbar, aber ohne Raum.

**Schritt 1: Türen-Basisobjekte (zwei Duplicates).**
**Wo:** Object Window, **World Objects, Door**. Filter `NHV_Q02_HarborClerkDoor`.
**Was:** `NHV_Q02_HarborClerkDoorExter` (0051A9) per Rechtsklick **Duplicate**, EditorID `NHV_Q02_TidehouseDoorExter`. `NHV_Q02_HarborClerkDoorInterior` (0057DB) duplizieren, EditorID `NHV_Q02_TidehouseDoorInterior`. (Wir duplizieren die bereits vorhandenen NHV-Türen und nicht Vanilla; das passt zum Muster `…DoorExter`/`…DoorInterior`.) Name beider Türen laut Konzept: „Tidehouse“ (Name unbestätigt, Frage 2).
**Ergebnis:** Zwei neue Door-Records.

**Schritt 2: Zelle anlegen.**
**Wo:** Cell View, World Space **Interiors**, linke Liste, Rechtsklick, **New**.
**Was:**
| Feld | Wert |
|---|---|
| EditorID | `NHV_Q02_TidehouseCell` |
| Name | `Tidehouse` (unbestätigt, Frage 2) |
| Interior | an (automatisch) |
| Public Area | an (wie Kontor und Hollow) |
| Lighting | Template aus einem vorhandenen Windhelm-Innenraum (im CK prüfen); Kontor nutzt `0C0C76`, Hollow `0345A4` laut Export |
| Location | leer lassen (siehe Frage 3) |
| Owner | **leer** (kein Vanilla-Besitzer) |
| Encounter Zone | keine |
**Hinweis:** Fast alle Q02-Innenzellen entstanden bisher als Kopien von Vanilla-Zellen (siehe C2). Für die Tidehouse **keine Vanilla-Zelle kopieren**: eine neue Zelle ist sauberer (kein Vanilla-Inhalt, keine Vanilla-Location).
**Ergebnis:** Zelle erscheint in der Liste; sie ist leer.

**Schritt 3: Raum bauen.**
**Wo:** Render Window der neuen Zelle. Kit: ein passender Nord-/Windhelm-Innenraum-Kit (Bauteile über Object Window, **World Objects, Static**, Filter nach Kit-Präfix, **im CK prüfen**; ich habe keinen exakten Kit-Namen geprüft).
**Was:** Ein Raum (ca. 6 mal 8 m, also rund 420 mal 560 Einheiten) mit einer Eingangstür, einem Tisch (Ledger), Platz für zwei Enforcer vor dem Tisch (Abstand untereinander 120–200 Einheiten), Licht (mindestens 2 Lichtquellen, **Light**-Records aus dem Object Window, **World Objects, Light**, im CK prüfen), Vorhandenes „versiegeltes Lager“ als Dekor (Kisten, Regale, Akten). Die Tür nach außen ist die **Innentür** (`NHV_Q02_TidehouseDoorInterior`).
**Ergebnis:** Ein begehbarer Raum, kein Loch im Boden, keine Kollisionslücken.

**Schritt 4: Außen- und Innentür platzieren und verknüpfen.**
**Wo:** Außentür in `WindhelmDocksExterior01` (Tamriel), Innentür in `NHV_Q02_TidehouseCell`.
**Was:**
1. Außentür `NHV_Q02_TidehouseDoorExter` an eine geeignete Hafengebäude-Fassade ziehen. Orientierung: Hjoralds Posten (139589 / 34509), Kontor-Außentür (141184 / 35680), Torbjorn (141599 / 36375). Die Fassade ist **Entwicklerentscheidung** (Frage 2). Tür **ausrichten** (Rotation Z so, dass die Türfläche zum Weg zeigt), Taste **F**.
2. Innentür `NHV_Q02_TidehouseDoorInterior` in der Tidehouse an die Wand setzen.
3. Verknüpfen: Außentür-Ref doppelklicken, Reiter **Teleport** (oder „Teleport Destination“, im CK prüfen), **Door** = die Innentür-Ref, Position/Rotation = Landeplatz vor der Innentür (Spieler blickt vom Eingang in den Raum). Dann die Innentür-Ref: **Door** = die Außentür-Ref, Landeplatz **ca. 64 Einheiten vor der Außentür auf der Wegseite**, Blick **weg von der Tür**.
4. **Tür nicht abschließen** (kein Schloss, kein Lock Level): der Schlüssel kommt nur als Dialog, nicht als Item.
5. EditorIDs der beiden Refs: `NHV_Q02_TidehouseDoorExtRef`, `NHV_Q02_TidehouseDoorIntRef`.
**Ergebnis:** Betreten und Verlassen funktionieren in beide Richtungen. Landung steht vor der Tür, nicht in der Tür (Vorbild: Farmtür, C3).

**Schritt 5: Hinweis E16.** Die Außentür liegt in einer Vanilla-Außenzelle: Meldung an Claude (Rückmeldeformat), er trägt `WindhelmDocksExterior01` samt Salzplatz, Betten und Tür in die E16-Tabelle ein (Q2-28).

### C2: Kontor- und Hollow-Zelle bereinigen (Ä, Q02, P2)

**Befund laut Export (nicht aus den älteren Anleitungen):** Beide Zellen sind Kopien von Vanilla-Zellen und tragen noch deren Eigenschaften.
| Zelle | EditorID laut Export | Name laut Export | Location | Owner | Vanilla-Reste |
|---|---|---|---|---|---|
| 0057DC (Kontor) | `NHV_Q02_HarborClerkOfficeCell` | „Palace of the Kings Upstairs“ | `0209F2:Skyrim.esm` (Windhelm Palace of the Kings) | `0FF0AB:Skyrim.esm` | `WindhelmWuunferthLabMarker001`, `TGCrown09Go001`, `TGCrownGemAct010`, `WindhelmPalaceUp1PatrolB004` |
| 0051AB (Hollow) | **`NHV_Q02_DrownedHollowDoorInt`** (geplant war `NHV_Q02_DrownedHollowCell`) | „Largashbur Cellar“ | `03BC2B:Skyrim.esm` (Largashbur Longhouse) | `02C005:Skyrim.esm` | `LargashburBasementToExterior001`, weitere Vanilla-Objekte |
**Wo:** Cell View, Interiors, Zelle doppelklicken (Zelle-Dialog: Rechtsklick auf die Zelle, **Edit**, im CK prüfen).
**Was (Ä):**
1. **Name** der Zelle ändern (so erscheint es in der Ladeanzeige und im Journal): Kontor `Harbor Clerk's Office`, Hollow `The Drowned Hollow` (laut M2.2-Anleitung; Schreibweise Apostroph im CK prüfen).
2. **EditorID der Hollow-Zelle** von `NHV_Q02_DrownedHollowDoorInt` auf `NHV_Q02_DrownedHollowCell` umbenennen. FormID 0051AB bleibt, die EditorID ist kein Script-Bezug (Properties laufen über FormID); vor dem Umbenennen Claude kurz fragen (Regel 3 betrifft EditorIDs nicht ausdrücklich, aber Skripte und Tools könnten per Name suchen).
3. **Owner** (Feld im Zelle-Dialog) **leeren**: Vanilla-Faktionen als Besitzer machen Möbel und Betten zu „fremdem Besitz“ (Diebstahl bei Spieler-Zugriff, evtl. Probleme beim Schlafen der NPCs).
4. **Location**: leeren, **oder** Entscheidung Frage 3 (eigene Location). Die Vanilla-Locations ziehen automatische `LocationRefTypeReferencesAdded`-Overrides nach sich (ARCHITECTURE.md Zeile 29).
5. Vanilla-Reste **nur nach Entscheidung des Entwicklers** (Frage 12) löschen. Diese Aufgabe löscht nichts ohne Freigabe.
**Ergebnis:** Name, EditorID, Owner und Location sind eigenständig; gemeldet.

### C3: Farmtür: Landung und Blickrichtung (Ä, Q01, P2)

**Befund laut Q01-NPC-Packages (nach Export nachgelesen, Werte stimmen mit dem Export überein):** Innentür `004976` (Zelle `NHV_StormhollowFarmCell` 0048A8) landet außen bei (-25376, 70560, -13216) mit Rotation 0 (Blick nach Norden, also auf die Tür zu). Außentür `00497B` (Tamriel, Zelle `MorthalExterior08`) landet innen bei (-128, -320, 64), Blick 1,5708 rad (90°).
**Schritt 1: Türseite klären (CK-Prüfung, Entwickler).**
**Wo:** Cell View, Tamriel, `MorthalExterior08`, Ref `00497B` doppelklicken, im Render Window betrachten.
**Was:** Prüfen, ob die **Türvorderseite (Klinke, Türrahmen) nach Süden zum Hof** zeigt (Hof-Marker liegen südlich: `QuintusFarmSpot` y 70432, `HrefnaFarmSpot` y 70378, Kartenmarker y 70240).
**Schritt 2: Korrektur der Innentür 004976.**
**Wo:** Zelle `NHV_StormhollowFarmCell`, Ref `004976` doppelklicken, Reiter **Teleport**.
| Befund Schritt 1 | Position y | Rotation Z |
|---|---|---|
| Vorderseite zeigt nach **Süden** (erwartet) | von 70560 auf **70528** (64 Einheiten vor der Tür) | **180°** (3,1415927), Spieler blickt vom Haus weg zum Hof |
| Vorderseite zeigt nach **Norden** | auf **70656** | **0** |
**Schritt 3: Außentür 00497B (Eingang)**, falls der Eingang sich schief anfühlt: Teleport-Rotation Z auf **0** (die Tür liegt in der Südwand, der Spieler soll nach Norden blicken). Innen-Landung (-128, -320, 64) liegt 32 Einheiten vor der Innentür; bei Bedarf auf 64 erhöhen.
**Ergebnis:** Haus betreten, umdrehen, Tür aktivieren: Landung vor der Tür, Blick vom Haus weg, Hof liegt vor dem Spieler. (Ingame-Test später, F3.)
**Hinweis:** Die Textänderung (`TeleportDestination`) wäre die Alternative per Spriggit; sie erfolgt nur nach deiner Rückmeldung zur Türseite, **nie** parallel zum CK.

### C4: Türkette Dawnstar Sanctuary und Deep Sanctuary (K, Q00/Q01, P2)

**Wo:** Cell View, Interiors, `DawnstarSanctuary` (0193EE) und `NHV_DeepSanctuaryCell` (001342).
**Was (laut Export und M1.3-Dokumenten):**
1. Ladetür `NHV_DeepSanctuaryDoorRef` (003D8B, Base `NHV_DeepSanctuaryDoor` 003D8A, Position -5600 / -2816 / 148, Rotation Z 180°) in der Dawnstar-Zelle: Ziel in der Deep Sanctuary; die Zelle `DawnstarSanctuary` ist als E16-Kopie (E25) bekannt. **In der Vanilla-Zelle sonst nichts anfassen** (keine Markierung, kein Navmesh-Klick).
2. **K5 aus der Q01-Package-Anleitung:** Die Tür darf für NPCs **nicht gesperrt oder skriptgesteuert verschlossen** sein; sonst bleibt Veyra beim Fensterwechsel in ihrer Tagesroutine (18:00–02:00 Dawnstar, 02:00–10:00 Deep Sanctuary) hängen. Prüfen: Tür ohne Schloss, Rückkehrtür `NHV_SealedPassageReturnDoor` (000DD6) ersetzt die Markarth-Ausgangstür per Skript.
3. Die Sealed-Passage-Tür `NHV_SealedPassageDoor` (000DD5) entsteht per Skript (kein CK-Platz in der Vanilla-Zelle, E16).
**Ergebnis:** „C4: ok“ oder Befund melden (z. B. Tür mit Schloss).

### C5: Deep Sanctuary Stufe 1 (M1.3) fertigstellen (N/Ä, Q00, P3)

**Befund laut Export:** `NHV_DeepSanctuaryCell` (001342, „Deep Sanctuary“) ist ein Duplikat der `MarkarthTreasuryHouse`, 648 platzierte Refs, 19 NHV-Refs (Eingangs-/Memorial-Marker, Plaketten, Lucien, Map Table, Kitchen-Spot, Sings-Home-Marker), Location `NHV_DeepSanctuaryLocation` (000DD3), Encounter Zone `NHV_DeepSanctuaryZone` (001337, im CK auf **Never Resets** prüfen), Lighting-Template `0D7B14`, Navmesh vorhanden. **Nicht im Export:** Room Bounds, Portale, Enable-Parent-Marker (`NHV_Mk_<Raum>_Ruined/_Furnished`). **Owner `06566B:Skyrim.esm`** ist gesetzt (Vanilla-Besitzer prüfen, Frage 15). Q00 selbst läuft laut PROGRESS auch ohne diese Ausbaustufe.
**Wo und Was:** vollständig in `docs/ck/M1.3-Deep-Sanctuary-Stufe1.md` (Schritte 1–7) und `docs/ck/M1.3-Deep-Sanctuary-Asset-Inventar.md` (Objektlisten; exakte Vanilla-EditorIDs und Meshpfade in `docs/ck/M1.3-Deep-Sanctuary-Asset-Records.csv`, am 02.10. read-only aus `Skyrim.esm` ausgewertet). **Nicht neu schreiben, dort nacharbeiten.** Kurzfassung der Teilaufgaben:
| Teil | Typ | Inhalt |
|---|---|---|
| a | K | Encounter Zone `001337`: „Never Resets“ angehakt; Zelle zeigt sie |
| b | N | Fünf Räume: Hall of Whispers, Ledger Room, Shrine of the Void, Memorial Wall, Training Hall (laut Stufe1-Anleitung; **Initiates' Dormitory ist Finale-Scope**) |
| c | N | **Room Bounds** je Raum (fünf), Portale bei mehrräumigen Abschnitten |
| d | N | Enable-Parent-Marker je Raum (`…_Ruined`, `…_Furnished`), Zuordnung der Dekoration |
| e | Ä | Beleuchtung: dunkel, rote Akzente (Vanilla-Template als Basis, Werte im CK) |
| f | K | Owner prüfen (Frage 15) |
**Hinweis Reihenfolge:** Teil b bis d sind mehrtägig und **nicht** Voraussetzung für Q00 bis Q02. Sie hier zuletzt einplanen (Prio P3).
**Ergebnis:** Rückmeldung „C5: nicht begonnen / Teil x fertig“.

---

## Phase D: Platzierungen

**Koordinaten der vorhandenen Q02-Refs in `WindhelmDocksExterior01` laut Export (zur Orientierung):** Sings 005190 (139744, 34304, -13952); Torbjorn 005191 (141599, 36375, -13700); Drinks 005192 (141135, 34660, -13947, persistent, in Tamriel); Hjorald 005194 (139589, 34509, -13950); Haldor 005195 (142048, 36000, -13920); Leiche 005959 (142235, 36068, -13946); TrackClue1 00595A (140928, 35040, -13920); TrackClue2 00595B (141856, 36032, -13888); TrackClue3 00595C (142848, 36640, -13920); Clerk-Außentür 0051AA (141184, 35680, -13952); `NHV_Mk_Q02_DockWatch` 005961 (141204, 35511, -13946); `NHV_Mk_Q02_SingsWater` 00595D (142112, 35616, -14016); `NHV_Mk_Q02_HollowExit` 005962 (142432, 36025, -13879); Hollow-Außentür 0057D4 (143424, 37408, -13824).

### D1: Salzplatz-Marker (N, Q02, P1) (N2, Teil 1)

**Wo:** Zelle `WindhelmDocksExterior01` (Tamriel), Render Window nahe der Hollow-Außentür 0057D4.
**Was:**
1. Object Window, **World Objects, Static**, `XMarkerHeading` (000034 **(geprüft)**) ins Render Window ziehen.
2. Ref-Dialog: EditorID `NHV_Q02_SaltYardMarker`, **Persistent**, nicht Initially Disabled.
3. Position: freie, begehbare Fläche **landseitig vor der Hollow-Tür**, zwischen TrackClue3 (142848 / 36640) und der Tür (143424 / 37408), ca. **400–600 Einheiten (6–8 m)** von der Tür entfernt, **nicht** auf der Hollow-Landefläche, **nicht** im Wasser. Blick (Rotation Z) zur Tür. Auf **Navmesh** (Taste M prüfen).
4. Dort steht Drinks-the-Brine in Stage 45 (`BeginSaltYard()` setzt ihn per `MoveTo` an den Marker; Package `DrinksSaltYard` bleibt am Platz).
**Ergebnis:** Marker steht, FormKey notiert. Ohne den Marker steht Drinks dort, wo er gerade ist (Log „BeginSaltYard: Drinks or SaltYardMarker missing“).
**E16:** Zelle `WindhelmDocksExterior01` ist bereits eine Kopie; Eintrag ergänzt Claude.

### D2: Salzplatz-Enforcer und Beweisstücke (N, Q02, P1) (N2, Teil 2)

**Wo:** gleiche Zelle, um `NHV_Q02_SaltYardMarker`.
**Was:**
1. Object Window, **Actors, Actor**, Filter `NHV_Q02_DockEnforcer` (AF10). Ins Render Window ziehen, **2 bis 3 Mal**, **Radius 150–250 Einheiten** um den Marker, Blick zum Marker oder zueinander.
2. Je Ref: EditorID `NHV_Ref_Q02_SaltEnforcer01` bis `03`, **Persistent**, Haken **Initially Disabled aus**. (Die Refs müssen vom Skript per Property erreichbar sein.)
3. **Haldors Messer** `NHV_MISC_Q02_HaldorKnife` (AF31): Object Window, **Items, Misc Item**, Filter `HaldorKnife`; auf den Boden zwischen den Enforcern ziehen (Taste F). Bedingung Fundstelle: für den Spieler erreichbar, nicht im Wasser.
4. **Sluice Token** `NHV_MISC_Q02_SluiceToken` (AF32): gleiche Technik, **bei einem Enforcer am Boden**. (Eine Platzierung im NPC-Inventar per Ref geht im CK nicht zuverlässig, deshalb am Boden; als Alternative das Item in das **Inventory** des Base-Records AF10 legen, dann trägt es jeder Enforcer; im CK prüfen. Das ist keine Anforderung.)
5. Enforcer-Packages: `NHV_Pkg_Q02_EnforcerPost` (AF60, `NearEditorLocation` Radius 384) liest die Platzierung: die Enforcer stehen also dort, wo du sie hinstellst.
**Ergebnis:** 2–3 Enforcer-Refs plus Messer und Token; **FormKeys notiert** (für E1: `SaltYardEnforcerRefs`).
**Hinweis:** Der Rückfall ohne die Refs: `EnforcersHostile` hat keine Ziele, der Salzplatz-Pfad bleibt im Dialog trotzdem spielbar (Drinks-Zeilen).

### D3: Tidehouse-Inhalt (N, Q02, P1) (N1, Teil 2)

**Wo:** Zelle `NHV_Q02_TidehouseCell` (aus C1).
**Was:**
1. **Zwei Enforcer** `NHV_Q02_DockEnforcer` (AF10): bei der Akte/dem Tisch, EditorID `NHV_Ref_Q02_TideEnforcer01`, `NHV_Ref_Q02_TideEnforcer02`, **Persistent**, nicht disabled. Abstand zueinander 120–200 Einheiten, beide Richtung Tür blickend (sie sprechen den Spieler als Erste an: Hello-Topic `tide_enf`).
2. **Ledger-Buch** `NHV_Book_Q02_TidehouseLedger` (AF30): Object Window, **Items, Book**, Filter `TidehouseLedger`; **offen auf dem Tisch**, erreichbar. Wichtig: Es muss **eine** Ref sein; Hjorald-Gespräch „I have the log“ fordert das Ledger im Inventar (Weltbedingung `ledger`).
3. Möbel/Dekor: Tisch, zwei Stühle oder Hocker, Aktenregal (Auswahl im CK: Object Window, Filter `Table`, `Shelf`, `Chair`; verifiziert ist nur `CommonChair01` 02EC1C mit `Furniture\Common\CommonChair01.nif`).
4. Licht: zwei Lichtquellen; **kein** versteckter Dunkelraum.
5. Keine Quest-Refs in Vanilla-Zellen.
**Ergebnis:** Zwei Enforcer-Refs, ein Buch-Ref; **FormKeys notiert** (E1: `TidehouseEnforcerRefs`, H2).

### D4: Kurier in das Kontor (N, Q02, P1) (N3)

**Wo:** Zelle `NHV_Q02_HarborClerkOfficeCell` (0057DC), neben dem Schreibtisch mit der Dispatch-Ref `NHV_Q02_DispatchDeskRef` (005954, Initially Disabled).
**Was:**
1. Object Window, **Actors, Actor**, Filter `NHV_Q02_ImperialCourier` (AF11). Ins Render Window neben das Pult ziehen, **100–150 Einheiten** vom Pult entfernt, Blick zum Pult. Auf Navmesh.
2. Ref-Dialog: EditorID `NHV_Ref_Q02_ImperialCourier`, **Persistent**, **Initially Disabled** (Skript `CourierFlees` und `OnDeskOpened` aktivieren ihn nur bei geöffnetem Pult, E54).
3. **Imperial Seal** `NHV_MISC_Q02_ImperialSeal` (AF33) in sein Inventar: im **Base-Record** `NHV_Q02_ImperialCourier` (AF11, Reiter **Inventory**) hinzufügen (eine Ref-Inventar-Bearbeitung ist im CK nicht üblich; im CK prüfen). AF11 ist eigener Record, kein Vanilla-Eingriff.
4. Package `NHV_Pkg_Q02_CourierWait` (AF61, `NearEditorLocation` Radius 128) liest die Platzierung.
**Ergebnis:** Kurier-Ref steht disabled; FormKey notiert (E1: `CourierRef`). Ohne `DispatchDeskRef` (existiert) gibt es keinen Kurier.

### D5: Chiffre-Schlüsselbuch (N, Q02, P3) (N4, E56, optional)

**Wo:** Kontor-Zelle am Pult (Dispatch-Ref 005954).
**Was:** Object Window, **Items, Book**, `NHV_Book_Q02_CipherKey` (AF34), neben den Dispatch ziehen. **Vorschlag (Frage 10):** Initially Disabled mit **Enable Parent** = `NHV_Q02_DispatchDeskRef` (Feld **Enable Parent** im Ref-Dialog), damit es mit dem Dispatch erscheint, wenn das Skript das Pult freischaltet (Engine-seitig, kein Skript). Ohne Enable-Parent liegt es von Beginn an offen im Raum.
**Ergebnis:** Optional; Veyra-Fallback ist im Dialog vorhanden. Dispatch-Ref selbst **nicht ändern**.

### D6: Drei Betten für das Q02-Schlafen (N, Q02, P2) (N6)

**Wo und Was:**
| Bett | Zelle | Basisobjekt | Wo | EditorID |
|---|---|---|---|---|
| Torbjorn | `WindhelmDocksExterior01` | `BedrollHay01` (FURN 01899D, `Furniture\Bedroll\BedrollHay01.nif`) **(geprüft)** | im Radius **2000 Einheiten** um seine Ref 005191 (141599 / 36375), möglichst unter Dach oder in Windschatten am Hafenmeisterposten | `NHV_Bed_Q02_Torbjorn` |
| Sings | `NHV_Q02_DrownedHollowCell` (0051AB) | `Bedroll01` (FURN 036ED3, `Furniture\Bedroll\Bedroll01.nif`) **(geprüft)** | nahe Marker `NHV_Mk_Q02_SingsHollow` (0057D8, Position 1361 / 1880 / 100), Radius 1024 laut Package `SingsHideoutNight` | `NHV_Bed_Q02_Sings` |
| Aelius | `NHV_Q02_HarborClerkOfficeCell` (0057DC) | `CommonBed01` (FURN 030091, `Furniture\Common\CommonBed01.nif`) **(geprüft)** | im Radius **2000** um seine Ref 005953 (-2673 / -2663 / 760) | `NHV_Bed_Q02_Aelius` |
**Wichtig:** Es muss ein **Furniture** (FURN) sein, **nicht** `BedrollHay01STATIC` (101A36, nur Static, nicht benutzbar). Ref-Dialog: EditorID setzen, **Persistent**, **Ownership leer** (kein Owner, sonst Konflikte beim Schlafen). Bett auf den Boden (Taste F), im Navmesh erreichbar. Beim Torbjorn-Bett am Hafen bevorzugt eine Stelle mit Navmesh in unmittelbarer Nähe.
**Abgrenzung:** Das Drinks-Bett ist ein **Vanilla-Bett** (0C92F3 in `WindhelmArgonianAssemblage`), nur referenziert, **nichts platzieren** (D9).
**Ergebnis:** Drei Bett-Refs; **FormKeys notiert** (E2). Solange sie fehlen, suchen die Packages ein Bett im Radius (Vanilla-Muster).

### D7: Idle-Möbel um die Q02-NPCs (N, Q02, P3) (N7)

**Wo:** Docks außen (um Drinks 005192, Torbjorn 005191), Kontor (Aelius 005953).
**Was:** Sandbox-Packages nutzen vorhandene Möbel; ohne Möbel stehen die NPCs. Platzieren (jeweils persistent nicht nötig): Sitzgelegenheit und Arbeitstisch am Hafenmeisterposten, Kisten/Fässer als Lastenarbeit bei Drinks, Schreibtisch und Stuhl im Kontor bei Aelius (Hinweis: das Kontor ist eine Palast-Zellenkopie, der Schreibtisch ist ggf. vorhanden; vor dem Neuplatzieren die Zelle ansehen). Verifiziert ist nur `CommonChair01` (02EC1C); alles andere im Object Window per Filter (`Barrel`, `Crate`, `Desk`, `Table`) **im CK prüfen**.
**Ergebnis:** Optional; keine Pflicht für den Ablauf.

### D8: Haldor-Rückkehr-Marker (N, Q02, P3, optional) (Nachtrag Koordinator b, K6 der Package-Anleitung)

**Wo:** Zelle `WindhelmDocksExterior01`, an Haldors Ursprungsplatz (142048 / 36000 / -13920).
**Was:** `XMarkerHeading` (000034) platzieren, EditorID `NHV_Mk_Q02_HaldorReturn`, **Persistent**, Position identisch zu Haldors Ref 005195 oder 100 Einheiten daneben, auf Navmesh. Das Package `HaldorDocks` (AF5C, Bedingung S < 45 oder S >= 100, `NearEditorLocation` Radius 512 um Ref 005195) liest Haldors Ref-Platz: **ohne Marker läuft er nach Stage 100 an seinem Ursprungsplatz umher** (laut `Q02-NPC-Packages.md` so umgesetzt). Der Marker ist nur nötig, wenn Haldor an einem anderen Ort zurückkehren soll; dann Package-Ort auf den Marker umstellen (Claude lässt das Tool anpassen, Frage 11). Vorher prüfen: sein Platz ist im Radius 512 begehbar (Navmesh am Kai).
**Ergebnis:** Optional; bei Anlage FormKey notiert.

### D9: Argonian Assemblage: nur ansehen (K, Q02, P2)

**Wo:** Cell View, Interiors, **`WindhelmArgonianAssemblage` (016776), Vanilla**. **Nur ansehen, nichts verschieben, nichts speichern, keine Änderung** (Regel 1; nach dem Betrachten ohne Änderungen schließen; Frage 7 bei jeder ungewollten Änderung).
**Was (K5 der Package-Anleitung):** Außentür `0168EE` (in `WindhelmExterior`) ist für Drinks nachts passierbar (nicht abgeschlossen, keine Besitzsperre); Bett `0C92F3` (CommonBed01-Ref) hat **keine Besitzfraktion, die Drinks aussperrt** (Zelle `Owner 045F5C` laut Package-Anleitung). Mögliche Bett-Konkurrenz mit den vier Vanilla-NPCs.
**Ergebnis:** Falls Drinks im Test nicht schläft, melde, ob eines der Betten `0C92F0` bis `0C92F2` frei ist (FormKey ändert Claude in `BEDS`) oder die Bett-Suche besser ist.

### D10: Marsh Hitch, Aelius nachts (K, Q02, P2) (K7, K8)

**Was:**
1. Marsh Hitch: vorhandenes `NHV_MISC_ReedWalkersKnot` (0057D3) nutzen, **kein neuer Record**; Fundort an der Leiche (005959) prüfen: liegt das Item dort oder wird es per Skript gegeben? (Laut Phase-B-Datei K7: Fundort prüfen.) Export: 0057D3 ist nirgends platziert.
2. Aelius steht nachts in seinem Büro (Zelle 0057DC), sonst hängt die Beobachtung bis zum Timeout: Ref 005953 steht im Kontor; Package `AeliusNightAwake` (AF62, Stage 55–59) greift nur mit Bett oder Raum.
3. `NHV_Q02_DispatchDeskRef` (005954): Ownership am Buch laut PROGRESS offen (30.09.): prüfen, ob ein Besitzer gesetzt ist, der den Spieler zum Dieb macht (Diebstahl-Warnung beim Aufheben).
**Ergebnis:** Antwort pro Punkt in der Rückmeldung.

### D11: Q01: Betten B1 bis B5 (N, Q01, P2)

**Wo und Was (Basis laut Q01-NPC-Packages; Furniture **(geprüft)**: `BedrollHay01` 01899D, `Bedroll01` 036ED3, `CommonBed01` 030091; Hausbetten `CommonBedDouble01L` 0F5101 u. a. existieren ebenfalls):**
| Nr. | EditorID der Ref | Zelle und Ort | Basisobjekt (Vorschlag) | Danach in Package (E3) |
|---|---|---|---|---|
| B1 | `NHV_Ref_Q01_HakanBed` | Tamriel, Zelle `MorthalExterior03` (00939C), am Steg bei `NHV_Mk_Q01_HakanSpot` (0048A7, -35840 / 66432 / -13920); Schlafrolle oder Bett in einer Hütte | `BedrollHay01` | `HakanDockNight` (AD01) |
| B2 | `NHV_Ref_Q01_HrefnaBedroll` | Tamriel, Lager bei `NHV_Mk_Q01_CampMarker` (004980, -16384 / 62848 / -10816), **100–300 Einheiten** vom Feuer | `BedrollHay01` | `HrefnaCampNight` (AD03) |
| B3 | `NHV_Ref_Q01_HrefnaFarmBed` | Innenzelle `NHV_StormhollowFarmCell` (0048A8), Schlafzimmer des Hauses | `CommonBed01` | `HrefnaFarmWaitNight` (AD0F) und `HrefnaFarmNight` (AD0E) |
| B4 | `NHV_Ref_Q01_HrefnaHomeBed` | Deep Sanctuary, Wohnbereich nahe `NHV_Mk_Q01_KitchenSpot` (00498A, -5969 / 428 / 144) | `CommonBed01` | `HrefnaHomeNight` (AD06) |
| B5 | `NHV_Ref_Sys_VeyraBed` | Deep Sanctuary, Veyras Quartier (eigener Raum nahe Ledger Room, `NHV_Mk_MapTable_Veyra` 005ECD) | `CommonBed01` | `VeyraRest` (AD12) |
| B6 | kein festes Bett | Moorside Inn: Quintus nimmt ein **freies Bett** im Radius **1024** um `NHV_Mk_Q01_QuintusInnSpot` (0089FD, in `MorthalMoorsideInn` 1312 / 32 / 0). **Nichts platzieren**; nur prüfen, dass im Inn mindestens ein freies, unbesessenes Bett im Radius liegt | `AD09` unverändert | – |
**Wichtig:** Furniture (nicht Static), Ref **Persistent**, **Ownership leer**, EditorID setzen. B1/B2 liegen in Vanilla-Außenzellen (E16-Kopien sind laut ARCHITECTURE bereits vermerkt, neue Platzierungen melden). Die Betten B3 bis B5 liegen in NHV-eigenen Zellen.
**Ergebnis:** Fünf Bett-Refs; **FormKeys notiert** (E3).
**Hinweis Inn (Nachtrag Koordinator e):** Kein Q02-NPC steht in einem Inn; der Inn gehört zu Q01 (Quintus: freies Bett im Radius).

### D12: Q01: Möbel für die Tag-Sandboxen (N, Q01, P3)

**Wo und Was (Q01-NPC-Packages, N1 bis N4):**
1. **N1 Steg:** Sitzgelegenheit am Steg bei `HakanSpot` (Radius 384).
2. **N2 Lager:** Lagerfeuer und Sitzplätze, Radius 450 um `CampMarker` 004980. Vanilla-Feuer laut Q01-Enhanced-Anleitung: `Campfire01LandBurningDirt01` (Model `Clutter\WoodFires\Campfire01LandBurning.nif`, in jener Anleitung gegen die Load Order geprüft, hier übernommen).
3. **N3 Küche Deep Sanctuary:** Kochstelle, Tisch, Stuhl bei `KitchenSpot` 00498A (Radius 600); Objektauswahl aus dem M1.3-Asset-Inventar (Abschnitt Kitchen) und der CSV.
4. **N4 Hof (optional):** Bank bei `HrefnaFarmSpot` 0089E7.
**Hinweis:** Sandbox nutzt nur vorhandene Möbel (`CommonChair01` ist **(geprüft)**); ohne Möbel stehen die NPCs.
**Ergebnis:** Optional; keine Pflicht.

### D13: Q00: Lucien, Memorial, Plaketten (K, Q00, P3)

**Wo:** `NHV_DeepSanctuaryCell`.
**Was (laut Export):** `NHV_Mk_Q00_DeepSanctuaryEntry`, `NHV_Mk_Q00_MemorialVeyra/Nazir/Babette/Cicero`, Plaketten `NHV_Ref_Q00_PlaqueFestus/Gabriella/Arnbjorn/Veezara/Astrid/AstridSmall` stehen; `NHV_Ref_Sys_Lucien` und `NHV_Mk_Sys_LucienSpot` bei -5300 / -1520 / -14. **Prüfen:** Marker stehen auf Navmesh (laut PROGRESS wurden die Memorial-Marker nachträglich auf Navmesh gesetzt), Plaketten lesbar, Lucien-Spot frei begehbar. **Nichts verschieben ohne Befund.**
**Ergebnis:** Abgleich.

---

## Phase E: Properties und Packages auf Bett-Refs umstellen

### E1: Q02-Quest-Properties füllen (Ä, Q02, P1)

**Wo:** Object Window, **Character, Quest**, `NHV_Q02_ColdWaters`, Reiter **Scripts**, `NHV_Q02Script`, **Properties**. (Voraussetzung: A1 Punkt 4, die Refs aus C1, D1 bis D4 existieren; Ref-EditorIDs müssen gesetzt sein, sonst erscheinen sie nicht in der Auswahl.)
**Was (laut Export im Quest-Record noch nicht vorhanden):**
| Property | Typ | Wert |
|---|---|---|
| `TidehouseEnforcerRefs` | ObjectReference[] | `NHV_Ref_Q02_TideEnforcer01`, `NHV_Ref_Q02_TideEnforcer02` (beide persistent) |
| `SaltYardEnforcerRefs` | ObjectReference[] | `NHV_Ref_Q02_SaltEnforcer01` bis `03` |
| `SaltYardMarker` | ObjectReference | `NHV_Q02_SaltYardMarker` |
| `CourierRef` | ObjectReference | `NHV_Ref_Q02_ImperialCourier` |
Alle bereits gesetzten Properties **nicht anfassen** (u. a. `DispatchDeskRef` 005954, `DockWatchMarker` 005961, `SingsHollowMarker` 0057D8, `VeyraHollowMarker` 0057D9, `SingsHomeMarker` 005956, `ShadowscaleWraps` 0057D1, `TidehouseLedger` AF30). Alle neuen Properties sind **optional**; das Skript loggt bei fehlender Property und weicht aus.
**Hinweis Array-Eingabe:** Property markieren, **Edit Value**, Einträge hinzufügen (Bezeichnung im CK prüfen). Jeder Eintrag aus der Liste der persistenten Refs (Suchfeld, EditorID).
**Ergebnis:** Alle vier Properties gesetzt. Prüfung nach dem Speichern: im Papyrus-Log darf **nicht** stehen „TidehouseEnforcerRefs not set“, „SaltYardMarker missing“.

### E2: Q02-Bett-FormKeys melden (K, Q02, P2)

**Was:** Im CK ist **nichts umzustellen**. Die drei FormKeys aus D6 gehen mit der Rückmeldung an Claude; er trägt sie in `BEDS` von `tools/build_q02_packages.py` ein (`TorbjornNightSleep`, `SingsHideoutNight`, `AeliusNightSleep`) und lässt das Tool erneut laufen (nicht `--write` des Hauptgenerators; Lehre 1). Danach öffnest du das ESP **einmal** im CK und speicherst (E17; kurzer Zweitdurchgang).
**Ergebnis:** Bis dahin suchen die drei Sleep-Packages ein Bett im Radius; das Drinks-Package nutzt das Vanilla-Bett 0C92F3.

### E3: Q01: Sleep-Packages auf die Bett-Refs umstellen (Ä, Q01, P2)

**Wo:** Object Window, **Character, Package**, Package doppelklicken, Reiter **Package Data**, Bereich **Sleep Location**.
**Was:** Typ **Near reference**, Referenz = Bett-Ref, **Radius 64–100**. Für jedes Package:
| Package | FormID | Ref |
|---|---|---|
| `NHV_Pkg_Q01_HakanDockNight` | AD01 | `NHV_Ref_Q01_HakanBed` |
| `NHV_Pkg_Q01_HrefnaCampNight` | AD03 | `NHV_Ref_Q01_HrefnaBedroll` |
| `NHV_Pkg_Q01_HrefnaFarmWaitNight` | AD0F | `NHV_Ref_Q01_HrefnaFarmBed` |
| `NHV_Pkg_Q01_HrefnaFarmNight` | AD0E | `NHV_Ref_Q01_HrefnaFarmBed` |
| `NHV_Pkg_Q01_HrefnaHomeNight` | AD06 | `NHV_Ref_Q01_HrefnaHomeBed` |
| `NHV_Pkg_Q01_VeyraRest` | AD12 | `NHV_Ref_Sys_VeyraBed` |
| `NHV_Pkg_Q01_QuintusInnNight` | AD09 | **unverändert** (freies Bett im Inn, Marker 0089FD, Radius 1024) |
Schedule und Conditions **nicht ändern**.
**Alternative (Frage 5):** Weg wie bei Q02 (FormKeys melden, Claude setzt per Spriggit). Entscheidung vor dem Start; mit dem CK-Weg ist es in einem Durchgang erledigt.
**Ergebnis:** Fünf Packages zeigen auf die Bett-Refs. Ohne diese Umstellung suchen sie ein Bett im Radius des Platzhalter-Markers.

---

## Phase F: Navmesh

**Regeln:** Bestehendes Navmesh in Vanilla-Zellen **nicht verändern** (Windhelm Docks ist laut M2.2-Anleitung bereits vollständig navmesht). Nur in eigenen Zellen neu zeichnen. Vor jeder Navmesh-Arbeit **ESP-Backup**. Nach dem Zeichnen **Finalize Cell**: ohne Finalisierung bleiben Türverknüpfungen kaputt. Menüpfad im CK prüfen (Render Window, Menü **World, Navmesh**, bzw. Navmesh-Werkzeugleiste). **Es wird keine KI-/Wegtest-Behauptung abgegeben, bevor der Test lief.**

### F1: Tidehouse: Navmesh zeichnen (N, Q02, P1)

**Wo:** Zelle `NHV_Q02_TidehouseCell`, Render Window, Navmesh-Modus.
**Was:** Navmesh über den gesamten begehbaren Boden, inklusive der Fläche vor der Tür (Landeplatz) und der Plätze der Enforcer und des Tisches. Kein Loch an der Tür. Dann **Finalize Cell**. Prüfen (Taste M): die Enforcer-Refs stehen **auf** Navmesh; nach dem Finalisieren die Türverknüpfung (Tür-Dreieck) kontrollieren.
**Ergebnis:** Enforcer bewegen sich im Test, der Spieler kommt durch die Tür; sonst Befund melden.

### F2: Q02: Navmesh an den neuen Refs (K, Q02, P1)

**Wo:** `WindhelmDocksExterior01`, `NHV_Q02_HarborClerkOfficeCell`, `NHV_Q02_DrownedHollowCell`.
**Was (nur ansehen, nicht ändern):**
1. Docks: Tidehouse-Außentür-Landeplatz, `NHV_Q02_SaltYardMarker`, Salzplatz-Enforcer, Haldor-Marker, Torbjorn-Bett auf Navmesh; **Weg `NHV_Mk_Q02_SingsWater` bis Hollow-Tür durchgehend** (Teil-2-Anleitung D3).
2. Kontor: Kurier, Bett und Pult erreichbar. Die Zelle ist eine Palast-Kopie: das mitkopierte Navmesh passt nicht automatisch zur neuen Raumaufteilung (Export: ein Navmesh-Block). Wenn Aelius oder Kurier stehen bleiben, **Navmesh neu zeichnen und finalisieren** (Backup).
3. Hollow: Sings-Bett, Marker `NHV_Mk_Q02_SingsHollow` und `NHV_Mk_Q02_VeyraHollow` (0057D9) auf Navmesh; Lücke an der Ladetür bedeutet: Sings bleibt stehen.
**Ergebnis:** Pro Ort „ok“ oder Lückenmeldung mit Zellenname.

### F3: Q01: Navmesh an Markern, Betten, Farmtür (K, Q01, P2)

**Was (K3 der Q01-Package-Anleitung):** Marker `HakanSpot` (0048A7), `CampMarker` (004980), `QuintusFarmSpot` (0089E6), `HrefnaFarmSpot` (0089E7), `QuintusInnSpot` (0089FD), Veyras Orte (09725F im Dawnstar-Sanctuary-Innenraum laut Package-Anleitung, `NHV_Mk_MapTable_Veyra` 005ECD, `KitchenSpot` 00498A), die Betten B1 bis B5 und die Landeplätze der Farmtür (C3) stehen auf Navmesh. Nicht auf Navmesh stehende Marker **versetzen** (kleine Verschiebung), Navmesh in Vanilla-Außenzellen **nicht** ändern.
**Ergebnis:** Pro Punkt „ok“ oder versetzt (neue Koordinate melden).

### F4: Q00: Navmesh Deep Sanctuary und Dawnstar-Tür (K, Q00, P2)

**Was:** `NHV_DeepSanctuaryCell` hat ein Navmesh (Export); für die fünf Räume (C5) ist weiteres Navmesh Teil von M1.3. Die Dawnstar-Tür (003D8B) liegt in einer Sackgasse; ein Navmesh-Override der Vanilla-Zelle wurde laut PROGRESS 27.09. **nicht** erreicht (NPCs aus Dawnstar laufen daher nicht automatisch hindurch). **Nichts ändern**, nur beobachten, ob Veyras Tagesroutine (C4) die Zelle wechselt.
**Ergebnis:** Beobachtung in der Rückmeldung.

---

## Phase G: Gesichter, FaceGen, Outfits

### G1: Enforcer und Kurier: Gesicht, Outfit, Ausrüstung (N, Q02, P1) (N5)

**Wo:** Object Window, **Actors, Actor**, `NHV_Q02_DockEnforcer` (AF10) und `NHV_Q02_ImperialCourier` (AF11) doppelklicken.
**Befund laut Export:** Beide sind Klone des Marsh Scavenger: Race `013746` (Nord), Class `01326B`, Outfit `01DC10`, ohne Gesicht (kein `FaceMorph`, kein FaceGen-NIF in `Data\Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp`).
**Was:**
1. Reiter **Traits** / Preview-Fenster: Kopfform, Haare, Hautton festlegen. Enforcer: wirken **hafenrauh**, einheitlich genug, um als Gruppe erkennbar zu sein (dasselbe Outfit; Gesicht pro Base nur eines, also sehen alle Enforcer gleich aus; für Abwechslung kann die Race/das Aussehen eines zweiten Base-Records nötig sein, im CK prüfen).
2. Reiter **Inventory**: Outfit Enforcer = Hafenwachen-/Söldnerrüstung (Outfit im Object Window, **Items, Outfit**, Auswahl im CK prüfen; keine Vanilla-Wachen-Fraktion). Kurier = Imperiales/Reisekleidung. **Keine Waffen beim Kurier** (er flieht; E54). Enforcer bekommen eine einfache Nahkampfwaffe.
3. **Race des Kuriers:** Export sagt Nord (013746); ein „Imperial Courier“ wäre vermutlich Imperial (`013744`). Frage 4: Race ändern ja/nein; **vor** dem FaceGen-Export entscheiden (Race-Wechsel nach FaceGen erfordert neuen Export).
4. Im Preview-Fenster **Strg+F4** (FaceGen exportieren). Prüfen: `00AF10.NIF` und `00AF11.NIF` (und die FaceTint-Dateien) erscheinen in `Data\Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp` und `Data\Textures\Actors\Character\FaceGenData\FaceTint\NightsHarvest.esp`.
5. Prüfen: **kein** Essential/Protected an beiden (Enforcer und Kurier müssen sterben können; der Kurier ist nicht unique, kann also mehrfach gespawnt werden; Mord am Kurier ist möglich und unbelohnt, E54).
**Ergebnis:** FaceGen-Dateien vorhanden, Gesichter nicht dunkel (ingame prüfen).

### G2: FaceGen-Bestand kontrollieren (K, alle, P2)

**Befund laut Dateien:** FaceGen-Dateien (`.NIF` und FaceTint `.dds/.tga`) existieren für `00000817` (Veyra), `00004006` bis `00004008` (Hakan, Hrefna, Quintus), `00004107` bis `0000410C` (Q02-NPCs), `00004400` (Lucien), `00005957`, `00005958` (Q02, 5958 = Leiche), `00007F20`, `00007F21` (Scavenger, Scout). **Auffällig:** `0004DDA0.NIF` hat eine FormID, die in `plugin-text/Npcs` nicht existiert (vermutlich ein Vanilla-NPC-Override; PROGRESS 25.09. erwähnt einen „unerwünschten Vanilla-Nazir-Override mit FaceGen“). Fehlend: `00AF10`, `00AF11` (G1); Soldaten-Template `0089F2` braucht keine eigene FaceGen-Datei (Template 01FC5B), ob die Soldaten ein Gesicht haben, im Test sehen; Nachtmutter-Sprecher `004990` unsichtbar.
**Was:** Ob `0004DDA0` im ESP noch einen Vanilla-NPC-Override erzeugt: im CK **Object Window, Actors**, Filter nach „Nazir“ und die FormID 04DDA0 suchen; **nicht löschen**, melden (Frage 7).
**Ergebnis:** Meldung „G2: 0004DDA0 gefunden/nicht gefunden“.

---

## Phase H: Items und Bücher

### H1: Flavour-Items Model und Wert (N, Q02, P3) (N5, zweiter Teil)

**Wo:** Object Window, **Items, Misc Item**, Filter `NHV_MISC_Q02_`.
**Was (Export: nur Name vorhanden, kein Model, kein Wert):**
| Item | FormID | Model | Wert |
|---|---|---|---|
| `NHV_MISC_Q02_HaldorKnife` | AF31 | Messer-Optik: ein Misc-Item mit Dolch-Optik per Duplicate-Vorbild suchen (Filter `Dagger`, `Knife`, Model-Pfad kopieren; im CK prüfen) | 0–10 |
| `NHV_MISC_Q02_SluiceToken` | AF32 | Token/Münze/Siegel (Filter `Token`, `Coin`, `Seal`) | 0–5 |
| `NHV_MISC_Q02_ImperialSeal` | AF33 | Siegel/Brief-Siegel (Filter `Seal`, `Signet`) | 0–10 |
Modell wählen, das **Kollision** hat (sonst nicht anzielbar); der Model-Auswahldialog bietet keine BSA-Meshes an (PROGRESS 30.09.: CK-Dateidialog zeigt keine BSA-Meshes). Wenn die Model-Auswahl nicht greift: **Duplicate eines passenden vorhandenen Misc-Items** und dessen Model übernehmen (Duplicate-Methode, Weg A der Map-Table-Anleitung); Claude kann den Pfad per Spriggit setzen (E17), wenn du einen Pfad meldest (z. B. `Architecture\Docks\DockRopeStr02.nif` **(geprüft)**, nur als Beispiel für den Pfadstil).
**Ergebnis:** Items sind ansehnlich anzielbar.

### H2: Bücher und Items: Platzierungs-Kontrolle (K, alle, P2)

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
**Noch nicht platziert (durch Aufgaben oben):** `NHV_Book_Q02_TidehouseLedger` AF30 (D3), `NHV_MISC_Q02_HaldorKnife` AF31 und `SluiceToken` AF32 (D2), `ImperialSeal` AF33 (D4), `NHV_Book_Q02_CipherKey` AF34 (D5).
**Was:** Nach der Platzierung der neuen Items prüfen: jedes Item ist erreichbar (Navmesh, nicht im Wasser/in der Wand), Fundstellen stimmen mit den Dialogbedingungen (`ledger` = Item im Inventar). `NHV_Item_Q01_RedFerryMarker` (007F24) wird nicht platziert (Hakan trägt es).
**Ergebnis:** Abgleich.

---

## Phase I: Speichern, ToText, Rückmeldung

### I1: Speichern (K, alle, P1)

1. **Strg+S**, dann im CK Meldungen beachten (Warnungen lesen und notieren).
2. CK schließen.
3. Backup der gespeicherten `NightsHarvest.esp` mit Datum daneben legen.
**Danach (macht Claude):** `sync_dev.ps1 -Direction FromDev` (Dev-Kopie nach Repo), dann `plugin_text.ps1 -Direction ToText` (Spriggit-Export). **Du gibst das Spiel und das CK vor dem Sync frei.** Der **Commit** erfolgt durch dich (Claude schlägt die Nachricht vor); kein Push, kein Tag.

### I2: Rückmeldung (Chat)

Siehe Abschnitt 12.

---

## 11. Checkliste (abhaken)

- [ ] A1 ESP von Claude geschrieben und synchronisiert, Backup, Skripte in der Dev-Kopie
- [ ] A2 CK geladen, Ladewarnungen notiert
- [ ] A3 Vanilla-Altlasten gemeldet
- [ ] B1 Quest 004100 abgeglichen
- [ ] B2 `SingsAlias`-Packages in der richtigen Reihenfolge
- [ ] B3 Fraktion AF14, Package AF40, NPCs AF10/AF11
- [ ] B4 20 Packages und NPC-Listen ohne Warnung
- [ ] B5 Szenen abgeglichen
- [ ] **B6** Hollow-Tür 0057D4: `RequiredStageMax = 45`
- [ ] **B7** Leiche 005959: `RequiredStage 20`, `TargetStage 0`
- [ ] **B8** Sings 005190: Initially Disabled und Persistent
- [ ] **B9** Haldor 005195: Persistent
- [ ] B10 Q01-Packages und Soldaten abgeglichen
- [ ] B11 Map Table abgeglichen (Z-Abstand beurteilt)
- [ ] B12 Q00-Aliase und Lucien abgeglichen
- [ ] C1 Tidehouse: Zelle, zwei Türen, Teleport, nicht abgeschlossen
- [ ] C2 Kontor/Hollow: Name, EditorID Hollow, Owner, Location
- [ ] C3 Farmtür: Türseite geprüft, Landung korrigiert
- [ ] C4 Dawnstar-Tür: nicht gesperrt
- [ ] C5 Deep Sanctuary (M1.3): Stand gemeldet
- [ ] D1 Salzplatz-Marker
- [ ] D2 Salzplatz: 2–3 Enforcer, Messer, Sluice Token
- [ ] D3 Tidehouse: 2 Enforcer, Ledger, Möbel, Licht
- [ ] D4 Kurier (disabled) im Kontor
- [ ] D5 Chiffre-Buch (optional)
- [ ] D6 Drei Q02-Betten (Furniture, persistent, ohne Owner)
- [ ] D7 Idle-Möbel (optional)
- [ ] D8 Haldor-Rückkehr-Marker
- [ ] D9 Assemblage angesehen, nichts gespeichert
- [ ] D10 Marsh Hitch, Aelius nachts, Dispatch-Ownership
- [ ] D11 Q01-Betten B1–B5, Inn-Bett vorhanden
- [ ] D12 Q01-Möbel (optional)
- [ ] D13 Q00-Marker kontrolliert
- [ ] E1 Vier Q02-Properties gefüllt
- [ ] E2 Bett-FormKeys notiert
- [ ] E3 Q01-Sleep-Packages umgestellt
- [ ] F1 Tidehouse-Navmesh gezeichnet und finalisiert
- [ ] F2 Q02-Navmesh kontrolliert
- [ ] F3 Q01-Navmesh kontrolliert
- [ ] F4 Q00-Navmesh beobachtet
- [ ] G1 Enforcer/Kurier: Gesicht, Outfit, FaceGen
- [ ] G2 FaceGen-Bestand, `0004DDA0` gemeldet
- [ ] H1 Misc-Items Model/Wert
- [ ] H2 Bücher/Items erreichbar
- [ ] I1 Gespeichert, CK geschlossen, Backup

## 12. Rückmeldeformat („Q00–Q02 im CK fertig“)

Schick im Chat diese Liste (Unerledigtes mit „offen“ und Grund). FormKeys = die letzten 6 Stellen aus dem CK.

```
Q00–Q02 im CK fertig (Datum, Dauer, CK-Version)
Ladewarnungen (A2): ...
Erledigt: <Liste der Aufgaben-Nummern>   Offen: <Nummern + Grund>

FormKeys der neuen Refs (EditorID = FormKey):
  NHV_Q02_TidehouseDoorExtRef / NHV_Q02_TidehouseDoorIntRef = ...
  NHV_Ref_Q02_TideEnforcer01/02 = ...
  NHV_Q02_SaltYardMarker = ...
  NHV_Ref_Q02_SaltEnforcer01..03 = ...
  NHV_Ref_Q02_ImperialCourier = ...
  NHV_Mk_Q02_HaldorReturn = ...
  Ref des Tidehouse-Ledger-Buchs (AF30), Messer (AF31), Token (AF32), Chiffre-Buch (AF34) = ...
Betten (für BEDS und Q01-Packages):
  NHV_Bed_Q02_Torbjorn / _Sings / _Aelius = ...
  NHV_Ref_Q01_HakanBed / _HrefnaBedroll / _HrefnaFarmBed / _HrefnaHomeBed = ...
  NHV_Ref_Sys_VeyraBed = ...
Q01-Packages auf Bett-Refs umgestellt (E3): ja/nein
Properties E1 gesetzt: ja/nein (welche)
Geänderte Zellen (für die E16-Tabelle in ARCHITECTURE.md):
  <Zelle (FormID): neue Refs / geänderte Felder>
Befunde: B11 Z-Abstand, C3 Türseite (Nord/Süd), C4 Türsperre, D9 Assemblage-Betten, D10 Punkte 1 bis 3, F2/F3 Lücken, G2 0004DDA0
Antworten auf die Fragen 1 bis 15: ...
Sonstiges (Absturz, Warnungen): ...
```

## 13. Nach dem CK

1. CK **geschlossen**, Backup gemacht (I1).
2. Claude: `sync_dev.ps1 -Direction FromDev`, `plugin_text.ps1 -Direction ToText`, prüft den Export (neue FormKeys, Properties, Beds, Vanilla-Overrides), `tools\build_q02_packages.py` mit den Bett-FormKeys (`BEDS`), trägt E16-Einträge ein, aktualisiert ROADMAP (Status „Test“) und PROGRESS. Falls Claude per Spriggit noch Werte setzt (z. B. Q01-Packages, Farmtür-Teleport), folgt ein **zweiter, kurzer CK-Durchgang** (ESP öffnen, speichern), nie parallel.
3. **Commit durch den Entwickler** (Claude schlägt die Nachricht vor, kein Push, kein Tag). Q02-Dateien und die vielen fremden Löschungen im Arbeitsbaum (Q00/Q01-Altrecords) **getrennt committen** (Phase-B-Datei Frage 10).
4. Spiel: ESP-Sync nur bei geschlossenem Spiel (Dev-Kopie, Lehre 14); `.psc` und `.pex` können auch bei laufendem Spiel kopiert werden, wirken aber erst nach dem Laden eines Saves.

## 14. Ingame-Testhinweise (ohne `cqf`)

Vorbereitung: Papyrus-Logging an, Konsole `set NHV_Cfg_Debug to 1`. Refs sind in der Konsole **nur per FormID** ansprechbar (`prid 06xxxxxx`, Slot 06 wie in den bisherigen Tests; nach Hinzufügen neuer Plugins prüfen, ob der Index noch stimmt). `cqf` wird nicht benutzt; Rettungswege liegen im Skript.
**Konsolenhilfen:** `getstage NHV_Q02_ColdWaters`, `setstage NHV_Q02_ColdWaters <n>` (führt das Fragment aus und bewaffnet den passenden Hub), `coc <Zell-EditorID>` (z. B. `coc NHV_Q02_TidehouseCell`, Tidehouse sichtbar), `player.moveto 06<FormKey>` zum Springen, `prid 06005190` Sings, `…5191` Torbjorn, `…5192` Drinks, `…5195` Haldor, `…5194` Hjorald, `…5953` Aelius, `wait 24` / `set gamehour to 21.9` für Nachtszenen. Papyrus-Log mit **aktuellem Zeitstempel** zurückgeben (`Papyrus.0.log`, ins Repo-Root; ein altes Log ist wertlos, Lehre 13).

| Test | Erwartet (nichts davon ist getestet) |
|---|---|
| Save vor Q02, Map Table | Menü mit 5 Buttons; „Windhelm“ startet Q02 Stage 10; Veyra am Marker (B11, Z-Abstand beachten) |
| Stage 10 | Torbjorn, Drinks, Veyra sprechen die Hubs an (kein Hello nötig) |
| **Stage 15** | Tidehouse betreten (C1); Enforcer sprechen zuerst, greifen dann an; Ledger aufheben; Hjorald „I have the log“ setzt Stage 20; Log ohne „TidehouseEnforcerRefs not set“ |
| **Stage 20** | Leiche untersuchen setzt **nicht** Stage 20 bei Stage 10 (B7) |
| Stage 30 nachts | Sings erscheint (B8: nur mit Enable-Skript), Nachtszene startet |
| Stage 40/45 | Gerettet führt zu 45; Haldor verschwindet (Log `HideHaldor`); Salzplatz mit Drinks und Enforcern; Hollow-Tür akzeptiert 40–45 (B6) |
| Stage 50 bis 100 | wie `Q02-Phase-B-Ergebnis.md` Abschnitt 10; Kurier erscheint nur bei geöffnetem Pult; nach Stage 100 Haldor wieder aktiv (Skript-Teil folgt) |
| Nacht, Wartezeit | Torbjorn, Drinks (Assemblage), Aelius schlafen in ihren Betten (D6, D9); Stage 10–29 Torbjorn und Drinks wach |
| Q01 | Hakan/Hrefna/Quintus Tag/Nacht (E3); Farmtür Landung (C3); Veyra ab Stage 100 über mehrere Tage (C4) |
| Fehlerbild | Reglos oder weggelaufen: Name, `getstage`, Spielstunde und Papyrus-Log melden |

## 15. Fragen (nicht geklärt, nicht als Fakt behandelt)

1. **Sings Variante B (Initially Disabled)** ist entschieden (Nachtrag a, `Q02-NPC-Packages.md` Ä4). Offen nur: Bleibt Sings nach Release/Surrender bewusst deaktiviert (laut jener Datei kein Re-Enable)?
2. **Tidehouse-Tür:** an welche Hafengebäude-Fassade (Vorschlag: zwischen Hjoralds Posten und der Kontor-Tür) und welcher Anzeigename („Tidehouse“ ist ein Platzhalter)?
3. **Cell-Location** für Kontor, Hollow und Tidehouse: leer lassen, oder soll Claude eigene Locations anlegen (Vanilla-Locations erzeugen automatische Overrides)?
4. **Kurier-Race:** Nord (Export) oder Imperial (`013744`)? Entscheidung vor dem FaceGen-Export.
5. **Q01-Bett-Umstellung (E3):** im CK (Weg A, ein Durchgang) oder per FormKey-Meldung und Spriggit (Weg B, wie Q02, zweiter CK-Durchgang)?
6. **Farmtür:** Welche Seite zeigt die Türvorderseite? (C3 Schritt 1; Vorschlag nimmt Süden an.)
7. **Vanilla-Altlasten (A3):** Soll `DeepSanctuaryNEW` (016204), die Fremd-FaceGen `0004DDA0` und `ChillfurrowFarmDUPLICATE001` bereinigt werden? Nie ohne Entscheidung löschen.
8. **Map-Table-Marker Z:** Marker -15,5 gegen Tisch 224 laut Export: gewollt (zwei Ebenen) oder Marker versetzen?
9. **Q00-NPCs ohne Idle-Package (nicht beauftragt):** Laut Export hat `NHV_Veyra` (000817) im NPC-Record nur AD10–AD12 (Bedingung Q01-Stage >= 100) und zusätzlich Q00-Alias-Packages (Q00-Stage < 100 bzw. Szenen) und Q01-Alias-Packages (Stage 10 bis < 100). Es gibt also **keine** Idle-Routine zwischen Q00-Ende und Q01-Start (Dauer ungeprüft) und ab Q00-Ende bis Q01-Briefing. Lucien hat nur `NHV_Pkg_Sys_LucienStand` (004404). Nazir, Babette und Cicero nutzen Vanilla-Routinen (Q00 hält sie nur bis Stage 15 fest). Soll ein Package-Bau für Q00 beauftragt werden? Dann wäre er eine eigene Aufgabe (Veyra Q00-Ende, Lucien).
10. **Chiffre-Schlüsselbuch:** Enable-Parent am Dispatch (Vorschlag in D5) ja/nein?
11. **Haldor (B9, D8):** Soll Haldor nach Stage 100 an seinem Ursprungsplatz bleiben (laut Package-Datei so umgesetzt) oder an einem eigenen Marker (`NHV_Mk_Q02_HaldorReturn`)? Ist mein Vorschlag „Persistent“ an Ref 005195 gewünscht? Die Entscheidung gehört auch in `docs/DECISIONS.md` (Haldor versteckt 45–99, zurück ab 100, tot bleibt liegen).
12. **Vanilla-Reste in Kontor und Hollow** (`TGCrown09Go001`, `TGCrownGemAct010`, `WindhelmPalaceUp1PatrolB004`, `WindhelmWuunferthLabMarker001`, `LargashburBasementToExterior001`): vor Release entfernen? Jetzt oder später?
13. **Schreibtisch im Kontor (D7/D10):** Soll das Buch auf Aelius' Schreibtisch (PROGRESS 30.09.: „nicht entschieden“) bleiben oder entfallen?
14. **Q01-Soldaten-Template (F9):** Nebenwirkungen des entfernten Template-Flags? Im Test beobachten (Wachposten anschleichen).
15. **Owner der Deep Sanctuary** (`06566B:Skyrim.esm` laut Export): Vanilla-Besitzer gewollt? Betrifft Diebstahl-Warnungen und Schlafen.
16. **Hrefna im Inn-Ende (F6 der Q01-Package-Anleitung):** Farm-Wartepfad auch dort? (Skript-/Journal-Entscheidung, nicht CK; hier nur der Vollständigkeit halber.)

## 16. Nicht geprüft / Hinweise zur Verlässlichkeit

- **Nicht geprüft** (CK-Verhalten, nicht lesbar aus dem Export): Menüpfade und exakte Feldnamen im CK; ob ein Enable auf eine persistente, deaktivierte Ref aus anderer Zelle in Skyrim SE sicher funktioniert (Praxiswissen, aber ungetestet in diesem Projekt); Art der Item-Platzierung im NPC-Inventar per Ref; Kit-Namen für den Tidehouse-Innenraum; Outfit-Auswahl der Enforcer.
- **Nicht ingame getestet:** alles. Insbesondere der Rückfall-Pfad ohne neue Refs, die Package-Übergänge (Schlaf, Sandbox), der Kurier (Confidence 0 plus `StartCombat`), Veyras Tagesroutine über die Ladetür.
- **Datenquellen:** Alle Vanilla-Namen und -Modelle aus `housecarl_records` (`Skyrim.esm`): `BedrollHay01` (FURN 01899D), `Bedroll01` (036ED3), `CommonBed01` (030091), `CommonChair01` (02EC1C), `BedrollHay01STATIC` (STAT 101A36), `CivilWarMap02` (STAT 070BC2), `DockRopeStr02` (STAT 0BEC5E), `XMarker` (00003B), `XMarkerHeading` (000034), `MapMarker` (000010). Alle anderen Objektnamen stammen aus den älteren Anleitungen oder sind mit „im CK prüfen“ markiert.
