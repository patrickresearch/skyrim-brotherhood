# Q02 Cold Waters: NPC-Packages (Tagesabläufe und Haltung je Stage)

Stand 02.10.2026 (Fassung 3, mit den Entscheidungen des Entwicklers, Runde 2 in Abschnitt 0b). **Nichts ist ingame getestet.** Das ESP wurde nicht geschrieben (E17), es gab keinen Commit. Quellen: Auftrag des Entwicklers ("Q02-NPCs stehen nur herum"), Lehren 1, 5, 7, 8, 11 in `docs/plan/Q02-Q03-Enhanced-Plan.md` Abschnitt 6, Package-Tabelle in `docs/plan/Q02-Q03-Enhanced-Befunde.md`, `docs/plan/Q02-Phase-B-Ergebnis.md`.

## 0. Entscheidungen des Entwicklers (eingearbeitet)

| # | Entscheidung | Umsetzung |
|---|---|---|
| 1 | Schlafen: festes Bett (Sleep-Package, Bett-Ref als Ziel, Bett-Refs als CK-Aufgabe N6). Ausnahme: NPCs im Inn schlafen in einem freien Bett | Echte **Sleep-Packages** (Template `019717`) für Torbjorn, Drinks, Sings (Versteck), Aelius. Das feste Bett steht in der Tabelle `BEDS` von `tools/build_q02_packages.py`. Solange eine Bett-Ref noch fehlt, sucht das Package ein Bett im Radius (Vanilla-Muster `DefaultSleepEditorLoc`). Die FormKeys der CK-Betten eintragen, Tool erneut laufen lassen. **Inn-Ausnahme:** Kein Q02-NPC steht derzeit in einem Inn, es gibt daher kein Inn-Package (Frage 1) |
| 2 | Drinks nachts im Argonian Assemblage, falls vorhanden | **Vorhanden.** Vanilla-Zelle `WindhelmArgonianAssemblage` (016776) mit vier Betten `CommonBed01` (Refs 0C92F0, 0C92F1, 0C92F2, 0C92F3), per Vanilla-Export geprüft. Drinks schläft in 0C92F3 (nur referenziert, nichts editiert) |
| 3 | Sings vor Stage 30 nicht sichtbar im Hafen | Versteck in der Drowned Hollow (Marker 0057D8) tags und nachts bis Stage 30 (Variante A, Package). Variante B (Alternative) siehe 4 |
| 4 | Aelius schläft nachts im Büro | Sleep-Package im Büro (Bett per CK N6); nur nachts und nicht in Stage 55-59 (Beobachtung braucht ihn wach) |
| 5 | Haldor ab Stage 45 verstecken | **Variante B (umgesetzt):** `NHV_Q02Script.HideHaldor()` mit `Disable(True)`, aufgerufen in `BeginSaltYard()` (Stage 45) und nach dem Laden bei Stage 45-99. Kein SetGhost, keine neue Variable. Ein toter Haldor (Stage-40-Pfad) bleibt als Leiche liegen. Alternative Variante A (Package an einen entfernten Ort) verworfen: es gibt keinen geeigneten Ort ohne neue Zelle |

## 0b. Entscheidungen Runde 2 (eingearbeitet)

| # | Entscheidung | Umsetzung |
|---|---|---|
| 1 | Haldor: tot bleibt liegen; lebend kehrt er nach Quest-Abschluss zurück | `HideHaldor()` bleibt (Stage 45-99). Neu `ShowHaldor()`: `Enable()` nur wenn `HaldorSaved`, nicht tot und deaktiviert (kein Doppel-Enable). Aufruf am Anfang von `BeginDebriefWatch()` (Fragment Stage 100) und in `RearmAfterLoad()` bei Stage >= 100. Package `HaldorDocks` (AF5C) gilt jetzt für `S < 45 oder S >= 100`, das schließt lückenlos an die Verstecken-Phase 45-99 an (dort ist er deaktiviert). Rückkehrplatz = seine eigene Platzierung (`NearEditorLocation`, Ref 005195, Radius 512) |
| 2 | Sings vor Stage 30: **Variante B** (Initially Disabled plus Enable per Skript) | `GetSings()` enabliert ihn bei Bedarf (`SingsMayAppear()`: Stage 40-99 oder Stage 30 im Nachtfenster 22-04), idempotent; `RearmAfterLoad()` ruft `GetSings()` bei Stage 30-99, daher ladesicher. Rückfall nach Lehre 6: die Ref wird per Alias oder FormID (`REF_SINGS` 0x5190) aufgelöst. Ab Stage 100 kein Re-Enable (Release und Surrender deaktivieren ihn absichtlich). Das Flag selbst setze ich **nicht** im Text (Zelle `WindhelmDocksExterior01` ist CK-Eigentum): CK-Aufgabe Ä4. Die Hollow-Packages `SingsHideoutDay/Night` bleiben als Rückfall (Variante A), solange das Flag noch nicht gesetzt ist |
| 3 | Aelius Stage 60 | unverändert (schläft, Kill-Szene muss ihn holen) |
| 4 | Hjorald und Haldor ohne Schlaf-Package | unverändert |
| 5 | Inn-NPCs | Frage geschlossen: Q02 hat keinen, der Inn war Q01 (Quintus) |

## 1. Ist-Zustand (Befund, unverändert)

| Akteur | Platzierung | Packages vorher |
|---|---|---|
| Sings 4107 | Ref 005190, Docks (139744, 34304) | Alias 2: `SingsFollow` (55 bis <60), `FleeHollow`, `ToHollow` (40), `NightHunt` nur in Szene. Sonst nichts |
| Torbjorn 4108 | Ref 005191 (141598, 36375) | keine |
| Drinks 4109 | Ref 005192, laut Export persistent (141134, 34659) | keine |
| Haldor 410A | Ref 005195 (142048, 36000) | keine (Szene 004125 bringt eigene Packages) |
| Aelius 410B | Ref 005953, Büro 0057DC (-2673, -2662, 760) | keine |
| Hjorald 410C | Ref 005194 (139589, 34509) | keine |
| Dock Enforcer AF10, Imperial Courier AF11 | **keine Ref** (CK N1/N2/N3) | Vanilla `0956B8` |
| Veyra, Babette | nicht Teil des Auftrags | unverändert |

## 2. Konzept

* **Schicht 1, NPC-Record:** Grundablauf, wirkt auch vor Quest-Start und nach Q02. Reihenfolge im Record = Priorität, Bedingungen je Akteur disjunkt (Tabelle 4).
* **Schicht 2, Alias-Package (`SingsAlias`):** nur für Hollow und Halten. Alias schlägt Record. Bestehende Einträge (`SingsFollow` AF40, `FleeHollow` 005960, `ToHollow` 00595F) unverändert, neue dahinter.
* **Szenen haben Vorrang**; Sandbox und Sleep erlauben Gespräche (Interrupt-Flags gesetzt). Follow erst ab der Stage, die das Gespräch setzt (Lehre 8).
* **Zeitplan** über die Schedule-Felder: Tag 06:00-20:00 (Start 6, 840 min), Nacht 20:00-06:00 (Start 20, 600 min). Kein Papyrus-Polling.
* **Schlaf nur außerhalb von Gesprächsfenstern:** Torbjorn schläft nicht in Stage 10-29, Drinks nicht in 10-49, Aelius nicht in 55-59 (Beobachtung), Sings nicht ab 30. Sonst wären Pflichtgespräche nachts blockiert (ein schlafender NPC lässt sich nicht ansprechen).
* **Sleep-Package:** `Lock Doors` und `Warn before locking` sind aus (die Assemblage ist öffentlich und gehört fremden NPCs). Bett-Zielreferenz ist `Data[1]` (SpecificReference) oder, ohne Ref, der Vanilla-Standard "Bett suchen".
* **Keine Koordinaten geraten.** Orte: `NearEditorLocation` (Platzierung der Ref), `NearSelf`, vorhandene Marker (00595D, 0057D8), Vanilla-Zelle 016776.

## 3. Package-Tabelle

Alle FormIDs 0xAF50-0xAF63 (reserviert war bis 0xAF40; 0xAF41-0xAF4F frei). EditorID `NHV_Pkg_Q02_<Name>`. Sa = Sandbox (`01C254`), Sl = Sleep (`019717`). S = Stage von `NHV_Q02_ColdWaters`.

| FormID | Name | Akteur, Schicht | Typ | Bedingung (S) | Zeit | Ort (Radius) | Aktivität |
|---|---|---|---|---|---|---|---|
| AF50 | `SingsHideoutDay` | Sings, Record | Sa | S < 40 | 06-20 | Marker 0057D8 Hollow (384) | bleibt im Versteck, nicht im Hafen |
| AF51 | `SingsHideoutNight` | Sings, Record | Sl | S < 30 | 20-06 | Marker 0057D8 (1024) | schläft im Versteck (Bett N6 `NHV_Bed_Q02_Sings`) |
| AF52 | `SingsLurkWater` | Sings, Record | Sa | S == 30 | 20-06 | Marker 00595D (256) | geht zum Wasser, wo die Nachtszene beginnt |
| AF53 | `SingsHollow` | Sings, **Alias 2** | Sa | 45 <= S < 55 | immer | Marker 0057D8 (256) | Hollow (Salzplatz-Pfad, Konfrontation) |
| AF54 | `SingsHold` | Sings, **Alias 2** | Sa | 60 <= S < 100 | immer | NearSelf (128) | bleibt, wo Skript/Szenen ihn hinstellen |
| AF55 | `TorbjornWork` | Torbjorn, Record | Sa | immer | 06-20 | Editor-Ort (512) | Hafenmeister am Posten |
| AF56 | `TorbjornNightSleep` | Torbjorn, Record | Sl | S < 10 oder S >= 30 | 20-06 | Editor-Ort (2000), Bett N6 `NHV_Bed_Q02_Torbjorn` | schläft |
| AF57 | `TorbjornNightAwake` | Torbjorn, Record | Sa | 10 <= S < 30 | 20-06 | Editor-Ort (256) | wach, ansprechbar |
| AF58 | `DrinksWork` | Drinks, Record | Sa | S < 45 oder S >= 50 | 06-20 | Editor-Ort (768) | Lastenarbeit am Kai |
| AF59 | `DrinksNightSleep` | Drinks, Record | Sl | S < 10 oder S >= 50 | 20-06 | Zelle 016776, **Bett 0C92F3** (Vanilla-Ref) | schläft im Argonian Assemblage |
| AF5A | `DrinksNightAwake` | Drinks, Record | Sa | 10 <= S < 45 | 20-06 | Editor-Ort (384) | wach am Kai (Hub Stage 10) |
| AF5B | `DrinksSaltYard` | Drinks, Record | Sa | 45 <= S < 50 | immer | NearSelf (256) | steht am Salzplatz (Skript stellt ihn an `SaltYardMarker`) |
| AF5C | `HaldorDocks` | Haldor, Record | Sa | S < 45 oder S >= 100 | immer | Editor-Ort (512), Ref 005195 | lungert am Kai (Szene 004125 in Stage 30 hat Vorrang); 45-99 versteckt (`HideHaldor()`), ab 100 `ShowHaldor()` und wieder am Kai |
| AF5D | `HjoraldPost` | Hjorald, Record | Sa | immer | 06-20 | Editor-Ort (512) | Wachposten |
| AF5E | `HjoraldNight` | Hjorald, Record | Sa | immer | 20-06 | Editor-Ort (192) | Nachtwache, schläft nie |
| AF5F | `AeliusDay` | Aelius, Record | Sa | immer | 06-20 | Editor-Ort Büro (256) | Schreibarbeit am Pult |
| AF62 | `AeliusNightAwake` | Aelius, Record | Sa | 55 <= S < 60 | 20-06 | Editor-Ort Büro (256) | wach (Beobachtung) |
| AF63 | `AeliusNightSleep` | Aelius, Record | Sl | S < 55 oder S >= 60 | 20-06 | Editor-Ort Büro (2000), Bett N6 `NHV_Bed_Q02_Aelius` | schläft im Büro |
| AF60 | `EnforcerPost` | Enforcer AF10, Record (vor `0956B8`) | Sa | immer | immer | Editor-Ort (384) | bewacht Tidehouse (15) und Salzplatz (45) je nach Ref-Platzierung |
| AF61 | `CourierWait` | Courier AF11, Record | Sa | immer | immer | Editor-Ort (128) | steht am Pult; Flucht per Skript |

### 4. Lückenlosigkeit (Lehre 7)

| Akteur | S 0-9 | S 10-29 | S 30 | S 40 | S 45-49 | S 50-54 | S 55-59 | S 60-99 | S 100 |
|---|---|---|---|---|---|---|---|---|---|
| Sings Tag | HideoutDay | HideoutDay | HideoutDay | ToHollow / FleeHollow (CK) | Hollow | Hollow | Follow | Hold | keiner (Rekrut/Release) |
| Sings Nacht | HideoutNight (Sleep) | HideoutNight | LurkWater (Szene darüber) | ToHollow / FleeHollow | Hollow | Hollow | Follow | Hold | keiner |
| Torbjorn Tag | Work | Work | Work | Work | Work | Work | Work | Work | Work |
| Torbjorn Nacht | Sleep | Awake | Sleep | Sleep | Sleep | Sleep | Sleep | Sleep | Sleep |
| Drinks Tag | Work | Work | Work | Work | SaltYard | Work | Work | Work | Work |
| Drinks Nacht | Sleep (Assemblage) | Awake | Awake | Awake | SaltYard | Sleep | Sleep | Sleep | Sleep |
| Haldor | Docks | Docks | Szene | Docks (tot: Leiche) | **versteckt** (Disable) | versteckt | versteckt | versteckt | `ShowHaldor()` plus Docks (nur lebend) |
| Aelius Tag | Day | Day | Day | Day | Day | Day | Day | Day | (tot) |
| Aelius Nacht | Sleep | Sleep | Sleep | Sleep | Sleep | Sleep | **Awake** | Sleep | (tot) |
| Hjorald, Enforcer, Courier | je 1 Package (Hjorald Tag/Nacht), keine Stage-Bedingung |  |  |  |  |  |  |  |  |

Disjunktheit: Zeit trennt Tag und Nacht. Torbjorn Nacht (S<10 oder S>=30) gegen (10<=S<30). Drinks Nacht (S<10 oder S>=50) gegen (10<=S<45) gegen SaltYard (45-49); Tag (S<45 oder S>=50) gegen SaltYard. Aelius Nacht (S<55 oder S>=60) gegen (55<=S<60). Sings Nacht: S<30 gegen S==30. Sings Alias: 45-54, 55-59 (`Follow`), 60-99. Einzige Überlappung: die CK-eigenen `FleeHollow` und `ToHollow` bei Stage 40 und `HaldorSaved == 1` (gleiches Ziel, praktisch tot).

## 5. Geänderte Dateien

* **Neu:** `tools/build_q02_packages.py` (idempotent, `--check`, räumt umbenannte Package-Dateien gleicher FormID selbst auf, schreibt nie das ESP).
* **Neu:** `plugin-text/Packages/NHV_Pkg_Q02_<Name> - 00AF5x/6x_NightsHarvest.esp.yaml` (20 Dateien).
* **Geändert:** `plugin-text/Npcs/` 004107-00410C, 00AF10, 00AF11 (Eintrag `Packages`); `plugin-text/Quests/NHV_Q02_ColdWaters - 004100_...yaml` (SingsAlias `PackageData` additiv AF53, AF54).
* **Geändert:** `tools/build_q02_enhanced.py` (am Ende des `--write`-Pfads wird `build_q02_packages.apply()` aufgerufen, weil `make_npcs()` AF10/AF11 neu schreibt). Package-IDs liegen außerhalb des idmap-Bereichs 0xA000-0xAEFF, `clean_range` löscht sie nicht. Nur als Trockenlauf geprüft. **Nie `--write` über CK-Änderungen (Lehre 1).**
* **Geändert (Skript, additiv, Regel 3 eingehalten):** `Data/Source/Scripts/NHV_Q02Script.psc`: neue Funktionen `HideHaldor()` (in `BeginSaltYard()` und `RearmAfterLoad()` bei 45-99), `ShowHaldor()` (in `BeginDebriefWatch()` und `RearmAfterLoad()` bei >= 100), `SingsMayAppear()`; `GetSings()` enabliert Sings bei Bedarf. Kompiliert fehlerfrei mit `tools/build.ps1` (über `powershell -ExecutionPolicy Bypass -File tools\build.ps1`, 413 .pex). `papyrus-reviewer` (beide Runden): freigegeben mit Hinweisen, kein Blocker; Runde 2: `UpdateNightWatch()` ruft `GetSings()` schon beim Betreten des Nachtfensters auf (kein Pop-in vor dem Spieler). Beobachtung für den Test: ein bereits rekrutierter Sings in einem Stage-100-Save muss sichtbar bleiben; ein von außen deaktivierter lebender Haldor würde ab Stage 100 bei jedem Laden wieder enabliert (Flag erst bei Bedarf). Eingearbeitet: der latente `Disable(True)` steht jetzt am Ende von `BeginSaltYard()`. Offener Hinweis: Haldor bleibt nach Q02 dauerhaft deaktiviert (kein `Enable()`); Absicht bitte in `docs/DECISIONS.md` festhalten, falls gewollt.

## 6. Prüfung (ohne ESP zu schreiben)

* Spriggit-Probelauf `convert-to-plugin` von `plugin-text/` in ein Temp-ESP im Scratchpad: erfolgreich, danach `convert-from-plugin`: alle 20 Packages vorhanden, Schedule, `LocationCell`, `PackageTargetSpecificReference`, `PackageTargetObjectType`, `NearSelf`, OR-Bedingung und Flags überstehen die Rundreise.
* Referenzprüfung: alle 3077 `XXXXXX:NightsHarvest.esp`-Links in `plugin-text/` zeigen auf vorhandene FormKeys, **0 offene Links**. Vanilla-Referenzen (Bett 0C92F3, Zelle 016776) wurden gegen den Vanilla-Spriggit-Export von `Skyrim.esm` geprüft (nur lesend).
* Keine FormID-Kollision in 0xAF50-0xAF63 (0xAD00/0xAD01 gehören Q01).

## 7. CK-Aufgaben

Reihenfolge: ESP einmal im CK öffnen und speichern (E17), danach:

### KONTROLLIEREN

| # | Prüfpunkt |
|---|---|
| K1 | Die 20 Packages `NHV_Pkg_Q02_*` laden ohne Warnung; Schedule und Bedingungen stimmen. Auffälligkeiten zuerst bei `NearSelf` und der Sleep-Bett-Suche (`Search Criteria`). |
| K2 | NPC-Records 4107-410C, AF10, AF11: Tab "AI Packages" zeigt die Reihenfolge aus Abschnitt 3. |
| K3 | `SingsAlias`: `SingsFollow`, `FleeHollow`, `ToHollow`, `SingsHollow`, `SingsHold`. |
| K4 | Aliase `TorbjornAlias`, `HjoraldAlias`: Flag `Protected` ist im Export dreifach (nicht von mir). Beim CK-Speichern auf eines reduzieren. |
| K6 | Haldor-Rückkehr: Sein Platz (Ref 005195, 142048/36000/-13920) im Radius 512 ist begehbar (Navmesh am Kai); bei Bedarf Idle-Marker oder einen XMarker `NHV_Mk_Q02_HaldorReturn` setzen und im Package `HaldorDocks` als Ort eintragen (dann Claude bitten, das Tool anzupassen). Nach Stage 100 mit lebendem Haldor testen: erscheint er, läuft er am Kai umher? |
| K5 | **Argonian Assemblage (Vanilla, nur Referenz):** Tür 0168EE (Windhelm-Außenzelle) ist für Drinks nachts passierbar (nicht abgeschlossen, kein Besitzer-Sperre) und das Bett 0C92F3 hat keine Besitzfraktion, die Drinks aussperrt (Zelle `Owner 045F5C`). Wenn Drinks nicht schläft, Bett 0C92F0-0C92F2 testen (FormKey in `BEDS` ändern) oder in `sl`-Package die Bett-Suche verwenden (Eintrag in `BEDS` löschen). Mögliche Bett-Konkurrenz mit den vier Vanilla-NPCs (Shahvee, Neetrenza und andere): bei Beobachtung eines "besetzten" Betts ein anderes wählen. |

### ÄNDERN

| # | Aufgabe |
|---|---|
| Ä4 | **Sings-Ref `NHV_SingsBeneathIceRef` (FormID 005190, base 004107, Zelle `WindhelmDocksExterior01`, Position 139744, 34304, -13952):** Flag **Initially Disabled** setzen (FormID bleibt gleich). **Korrektur 02.10.2026:** Der Haken „Persistent“ existiert im CK an Charakter-Refs nicht und entfällt; die Quest hält Sings über den Unique-Actor-Alias `SingsAlias` (Basis 004107), Rückfall im Script `GetSings`/`ResolveActor` über `Game.GetFormFromFile` (ungetestet, siehe `docs/ck/CK-1-Nur-Kontrollieren.md` K-Q02-07). Das Skript enabliert ihn ab Stage 30 im Nachtfenster. Ohne dieses Flag bleibt Variante A (Hollow-Packages) als Rückfall aktiv: er ist dann am Hafen sichtbar, bis er in die Hollow geht |

### NEU ERSTELLEN

| # | Aufgabe | Zielreferenz |
|---|---|---|
| N6 | **Drei Bett-Refs** (Persistent nur falls der Haken bei Nicht-Charakter-Refs vorhanden ist, Vanilla-Bettbasis, Ownership leer): | |
|  | Torbjorn: im Radius 2000 um seine Ref 005191, in `WindhelmDocksExterior01` (z. B. am Hafenmeisterposten) | EditorID `NHV_Bed_Q02_Torbjorn` |
|  | Sings: in der Drowned Hollow (`NHV_Q02_DrownedHollowCell`, 0051AB), nahe Marker 0057D8 | EditorID `NHV_Bed_Q02_Sings` |
|  | Aelius: im Büro `NHV_Q02_HarborClerkOfficeCell` (0057DC), im Radius 2000 um 005953 | EditorID `NHV_Bed_Q02_Aelius` |
|  | Danach die drei FormKeys an Claude melden. Claude trägt sie in `BEDS` (`tools/build_q02_packages.py`) ein und läuft das Tool erneut (kein `--write` des Hauptgenerators). Ohne Eintrag suchen die Packages ein Bett im Radius | |
| N7 | Idle-Marker/Arbeitsmöbel um Drinks (005192) und Torbjorn (005191); Stuhl/Schreibtisch im Büro von Aelius | Sandbox nutzt Vorhandenes, sonst stehen sie |
| N8 | Enforcer-Refs (N1/N2) und Courier-Ref (N3) **so platzieren, wie sie stehen sollen**; Courier neben dem Pult (005954) | `NearEditorLocation` liest die Platzierung |
| N9 | E16-Eintrag `WindhelmDocksExterior01` (mit N2 und N6) in `docs/ARCHITECTURE.md` | Q2-28 |

## 8. Offene Fragen

Alle früheren Fragen sind beantwortet (Inn: Q02 hat keinen; Aelius Stage 60 bleibt; Hjorald und Haldor ohne Schlaf; Sings Variante B). Neu offen:

1. **Haldors Rückkehr:** Soll er nach Q02 dauerhaft am Kai bleiben (so umgesetzt) oder gibt es einen eigenen Rückkehrplatz (Marker)? Dann bitte den Marker in K6 anlegen.
2. **`docs/DECISIONS.md`:** Die Haldor-Regel (versteckt 45-99, zurück ab 100, tot bleibt liegen) und Variante B für Sings sollten dort als Entscheidung stehen (Eintrag macht der Entwickler oder auf Zuruf Claude).

## 9. Testschritte (ohne `cqf`)

Vorbereitung: ESP-Sync nur bei geschlossenem Spiel (Lehre 14); Save vor Q02. Konsole: `prid 06005190` (Sings), `...5191` (Torbjorn), `...5192` (Drinks), `...5195` (Haldor), `...5194` (Hjorald), `...5953` (Aelius), mit `getstage NHV_Q02_ColdWaters`; `setstage` nur zum Springen. Papyrus-Log mit aktuellem Zeitstempel zurückgeben (Lehre 13).

1. **Vor Q02, Tag:** Hafen: Torbjorn, Drinks, Haldor, Hjorald bewegen sich in ihrem Radius, Aelius im Büro. **Sings ist gar nicht da** (Ref Initially Disabled, Ä4).
2. **Vor Q02, Nacht:** Torbjorn schläft (nur mit Bett N6), Drinks geht ins Assemblage und schläft (Bett 0C92F3), Aelius schläft im Büro (Bett N6), Hjorald hält Nachtwache.
3. **Stage 10-29 nachts:** Torbjorn und Drinks wach und ansprechbar. Aelius schläft.
4. **Stage 30:** tagsüber ist Sings noch nicht da; ab 22 Uhr (Nachtfenster) erscheint er (Log `GetSings: enabling Sings (stage 30)`) und die Nachtszene startet (Szene hat Vorrang). Nach Speichern und Laden mitten in Stage 30 oder 40: Sings ist da (Log wie oben).
5. **Stage 45 (gerettet):** Haldor verschwindet (Disable, Log `HideHaldor: Haldor leaves the docks`), Drinks am Salzplatz, Sings in die Hollow. Nach Speichern und Laden bleibt Haldor verborgen.
6. **Stage 55 nachts:** Aelius wach (`AeliusNightAwake`); Beobachtung läuft. **Stage 60 nachts:** Aelius schläft wieder, die Kill-Szene muss ihn holen (Frage 3).
7. **Stage 100 / danach:** Sings (Rekrut) kehrt nicht ins Versteck oder zum Kai zurück, bei Release/Surrender bleibt er deaktiviert (kein Re-Enable). **Haldor (nur lebend, gerettet):** erscheint am Kai (Log `ShowHaldor: Haldor returns to the docks (enabled)`), läuft umher; nach Speichern und Laden kein zweites Enable und keine Verdopplung. Auf dem Stage-40-Pfad (Haldor tot) bleibt die Leiche liegen. Torbjorn und Drinks schlafen nachts.
8. **Fehlerbild:** reglos oder weggelaufen: Name, `getstage`, Spielstunde und Papyrus-Log melden.
