# Q01 – NPC-Packages (Aktivitäten statt Herumstehen)

Stand: 02.10.2026 (Runde 2, Entscheidungen des Entwicklers zu F1–F4 und Schlafen eingearbeitet). **Nichts hiervon ist ingame getestet.** Das ESP wurde nicht geschrieben (kein `plugin_text.ps1 ToPlugin`, kein `sync_dev.ps1`), kein Commit, keine Q02-Dateien berührt. Neue FormIDs im Bereich 0xAD00–0xAD20 (gegen alle FormKeys in `plugin-text/` geprüft: frei).

## 1. Befund (Ausgangslage)

| Akteur | Vorher | Problem |
|---|---|---|
| Hakan (004006) | NPC-Liste: `Hakan_Fish` (Travel zu `HakanSpot` 0048A7) | steht nach der Ankunft nur da |
| Hrefna (004007) | NPC-Liste: `CampWait` (Travel zu `CampAmbushSpot` 004982, Stage < 50); Alias: `EscortPlayer` (50 bis < 70); Sys_Family-Alias: `Hrefna_Home` (nur ab Recruit) | steht im Lager; **Lücke Stage 70–99** und nach Freilassung |
| Quintus (004008) | NPC-Liste: `InnRoom` (Travel, ohne Bedingung, **zuerst**), `QuintusInn` (Sandbox) | `InnRoom` ist immer gültig, `QuintusInn` wird nie erreicht; beide Ziele sind `NearEditorLocation` (= Gasthaus-Ref): beim Farm-Pfad (`MoveQuintus` zur Farm) liefe er zurück ins Inn |
| Veyra (Runtime-Actor) | Alias: `VeyraFollow` (20 bis < 70), `VeyraTrialHold` (nur Stage == 50) | keine Aktivität in Stage 10–19, 70–99 und ab 100; `TrialHold` ist **tot**, solange `VeyraFollow` davor steht (Stage 50 erfüllt beide Bedingungen, die erste gültige gewinnt) |
| Scout (007F21), Marsh Scavenger (007F20) | Basis-Package `0956B8` (Vanilla-Sandbox) | reicht, siehe 3.4 |
| Soldaten (Basis 0089F2) | Template `01FC5B` mit Flags AIPackages und DefPackList: Verhalten kommt aus dem Template, ungeprüft | unbekannt |
| Lucien, Nazir | keine Q01-Routine (Nazir: Vanilla-Ref 01C3AD, Vanilla-Packages, tabu) | nichts zu tun |

## 2. Entscheidungen des Entwicklers (02.10.2026) und Umsetzung

| Punkt | Entscheidung | Umsetzung |
|---|---|---|
| Schlafen | festes Bett (Sleep mit Near-Reference auf eine Bett-Ref); Inn-NPCs: freies Bett im Inn | Nachts verwenden alle Schläfer das Vanilla-Template `Sleep` (019717). Die Bett-Refs gibt es noch nicht (CK-Aufgaben B1–B6); bis dahin zeigt die Package-Location auf einen vorhandenen Marker mit großem Radius (sucht das nächste Bett im Radius). Nach dem Anlegen der Bett-Ref in jedem Package **Location auf die Bett-Ref** umstellen (genaue Zielreferenzen: Abschnitt 5). Quintus bleibt bewusst ohne festes Bett (Inn-Marker, Radius 1024). |
| F1 | Veyra hält während der Prüfung **nicht** am Lager | `NHV_Pkg_Q01_VeyraTrialHold` (004991) bleibt als ungenutzter Record **bestehen**: Quest-Alias `VeyraAlias` und die Save-Regel 3 (keine FormIDs aufgeben) verbieten das Löschen. Er ist hinter `VeyraFollow` ohnehin tot. Nichts geändert, nicht aus dem Alias entfernt. |
| F2 | ab Stage 100 läuft Veyra in der Dawnstar Sanctuary **und** der Deep Sanctuary herum, mit Tag/Nacht-Fenstern | drei Packages am NPC-Record `NHV_Veyra` (000817), Bedingung Q01-Stage ≥ 100 (Stage bleibt nach Questende erhalten; nichts hängt am Alias, der mit der Quest endet): `VeyraDawnstarEvening` (AD10, 18:00–02:00), `VeyraDeepLedger` (AD11, 02:00–10:00), `VeyraRest` (AD12, 10:00–18:00, Sleep). „Nachtaktiv“ nach ARCHITECTURE Z. 119; E51 (Veyra bleibt in der Dawnstar Sanctuary) bleibt gewahrt: Dawnstar ist ihr Abendort und der Ort der Debriefs. Q00-Packages (alle am Alias, Q00-Stage < 100, Szenen) werden nicht berührt. |
| F3 | Hrefna wartet in Stage 55–69 auf ihrer Farm | `HrefnaFarmWaitDay/Night` (AD0D/AD0F) im `HrefnaAlias` **vor** `EscortPlayer`, gelten bei Stage 55 bis < 70 **und** Global `NHV_Q01_QuintusAtFarm` = 1. Siehe Abweichung A1. |
| F4 | Global bei Quest-Reset zurücksetzen | `SetQuintusAtFarm(False)` in `OnContractLoadGame` (Stage < 45) und im Reset-Zweig von `VeyraTick` (Stage < 20). Zusätzlich hängt `QuintusFarmHold` an Stage ≥ 45, ein veralteter Wert vor Stage 45 wirkt also nie. |

**Abweichung A1 (Hrefna Farm-Wartepfad):** Der Farm-Pfad gilt nur, wenn Quintus auf dem Hof ist (Global = 1: Capture- und Player-Kill-Ende, Stage-45-Lüge). Im Inn-Ende (Hrefna tötet Quintus im Gasthaus, Global = 0) steht die Papers-Szene im Inn; ließe man sie dort ebenfalls zur Farm laufen, verschwindet sie aus dem Gespräch, und das Journal („Secure Quintus's dispatch fragment“) schickt den Spieler nicht dorthin. Wenn sie in **allen** Enden zur Farm soll: Bedingung `NHV_Q01_QuintusAtFarm = 1` aus AD0D/AD0F entfernen **und** den Journaltext der Stage 55/60 anpassen (Entscheidung nötig, siehe F6).

## 3. Tabelle Akteur × Stage × Aktivität × Package

Stages: 10, 12, 20, 25, 30, 40, 42, 45, 48, 50, 55, 60, 70, 100. Priorität: Szenen > Quest-Alias-Packages (in Alias-Reihenfolge) > NPC-Liste (von oben nach unten). Zeiten: Tag = 06:00–22:00, Nacht = 22:00–06:00 (Schedule-Start plus Dauer 960 bzw. 480 Minuten, lückenlos). Sandbox erlaubt Gespräche.

| Akteur | Stage-Bereich | Aktivität | Package (FormID) | Liste | Ort |
|---|---|---|---|---|---|
| Hakan | alle, Tag | Sandbox am Steg | `NHV_Pkg_Q01_HakanDockDay` (AD00) | NPC | `HakanSpot` 0048A7, r 384 |
| Hakan | alle, Nacht | **Sleep** (festes Bett, B1) | `NHV_Pkg_Q01_HakanDockNight` (AD01) | NPC | `HakanSpot`, r 500 (Platzhalter) |
| Hakan | Rückfall | Travel (alt, unverändert) | `NHV_Pkg_Hakan_Fish` (498B) | NPC | unten |
| Hrefna | < 50, Tag | Sandbox am Lagerfeuer | `NHV_Pkg_Q01_HrefnaCampDay` (AD02) | NPC | `CampMarker` 004980, r 450 |
| Hrefna | < 50, Nacht | **Sleep** (Bettrolle, B2) | `NHV_Pkg_Q01_HrefnaCampNight` (AD03) | NPC | `CampMarker`, r 500 (Platzhalter) |
| Hrefna | < 50 (Rückfall) | Travel (alt) | `NHV_Pkg_Hrefna_CampWait` (498C) | NPC | unten |
| Hrefna | 50 (bis < 55; bis < 70 ohne Farm-Global) | folgt dem Spieler | `NHV_Pkg_Hrefna_EscortPlayer` (498E, unverändert) | Alias 3 | Spieler |
| Hrefna | 55 bis < 70, Global AtFarm = 1, Tag | wartet auf dem Hof | `NHV_Pkg_Q01_HrefnaFarmWaitDay` (AD0D) | Alias 3, vor 498E | `HrefnaFarmSpot` 0089E7, r 500 |
| Hrefna | 55 bis < 70, AtFarm = 1, Nacht | **Sleep** im Farmhaus (Bett B3) | `NHV_Pkg_Q01_HrefnaFarmWaitNight` (AD0F) | Alias 3, vor 498E | Farm-Innentür 004976, r 1500 (Platzhalter) |
| Hrefna | 70 bis < 100 | folgt bis zum Urteil | `NHV_Pkg_Q01_HrefnaJudgeFollow` (AD04) | Alias 3 | Spieler |
| Hrefna | ≥ 100, Status Released (3), Tag | Sandbox am Hof | `NHV_Pkg_Q01_HrefnaFarmHome` (AD05) | NPC | `HrefnaFarmSpot`, r 500 |
| Hrefna | ≥ 100, Released, Nacht | **Sleep** im Farmhaus (Bett B3) | `NHV_Pkg_Q01_HrefnaFarmNight` (AD0E) | NPC | Farm-Innentür 004976, r 1500 (Platzhalter) |
| Hrefna | ≥ 100, Recruited, Tag | Küche | `NHV_Pkg_Hrefna_Home` (4992, unverändert) | Sys_Family-Alias | `KitchenMarker` 00498A, r 600 |
| Hrefna | ≥ 100, Recruited, Nacht | **Sleep** (Bett B4) | `NHV_Pkg_Q01_HrefnaHomeNight` (AD06) | Sys_Family-Alias, vor 4992 | `KitchenMarker`, r 1500 (Platzhalter) |
| Quintus | Global = 1 und Stage ≥ 45 (Farm-Pfad) | wartet am Hof | `NHV_Pkg_Q01_QuintusFarmHold` (AD07) | NPC | `QuintusFarmSpot` 0089E6, r 256 |
| Quintus | sonst, Nacht | **Sleep** (freies Bett im Inn) | `NHV_Pkg_Q01_QuintusInnNight` (AD09) | NPC | `QuintusInnSpot` 0089FD, r 1024 |
| Quintus | sonst, Tag | Sandbox in der Gaststube | `NHV_Pkg_Q01_QuintusInnDay` (AD08) | NPC | `QuintusInnSpot`, r 384 |
| Quintus | Rückfall | alt (`InnRoom` 498D, `QuintusInn` 4989) | unverändert | NPC | unten |
| Veyra | 10 bis < 20 | Sandbox beim Anker (Vanilla-Ref 09725F im Dawnstar-Sanctuary-Innenraum) | `NHV_Pkg_Q01_VeyraBriefIdle` (AD0B) | Alias 1 | 09725F, r 300 |
| Veyra | 20 bis < 70 | folgt | `NHV_Pkg_Q01_VeyraFollow` (7F30, Generator) | Alias 1 | Spieler |
| Veyra | 50, Trial | `VeyraTrialHold` (4991) | **ungenutzt, bleibt** (F1) | Alias 1 | – |
| Veyra | 70 bis < 100 | folgt bis zum Urteil | `NHV_Pkg_Q01_VeyraJudgeFollow` (AD0C) | Alias 1 | Spieler |
| Veyra | ≥ 100, 18:00–02:00 | Dawnstar Sanctuary: Sandbox (herumlaufen, essen, sitzen) | `NHV_Pkg_Q01_VeyraDawnstarEvening` (AD10) | NPC (000817) | 09725F, r 1200 |
| Veyra | ≥ 100, 02:00–10:00 | Deep Sanctuary, Ledger Room: Sandbox | `NHV_Pkg_Q01_VeyraDeepLedger` (AD11) | NPC (000817) | `NHV_Mk_MapTable_Veyra` 005ECD, r 900 |
| Veyra | ≥ 100, 10:00–18:00 | **Sleep** (festes Bett B5, Deep Sanctuary) | `NHV_Pkg_Q01_VeyraRest` (AD12) | NPC (000817) | 005ECD, r 2500 (Platzhalter) |
| Scout | alle | Vanilla-Sandbox (Basis) | `0956B8` | NPC (Generator-Klon) | Wachposten |
| Scavenger ×3 | alle | Vanilla-Sandbox am Lager | `0956B8` | NPC | Reedbed |
| Soldaten ×4 | alle | Wache: Sandbox am eigenen Platz, kein Schlaf | `NHV_Pkg_Q01_SoldierWatch` (AD0A) | NPC (Basis 0089F2) | `NearEditorLocation`, r 600 |

Lückenprüfung (Lehre 7):

- Hrefna Alias 3: [50, 100) lückenlos (498E bis < 70; AD0D/AD0F davor im Farm-Fall für [55, 70); AD04 ab ≥ 70). NPC-Liste: [0, 50) Lager; ≥ 100 Released Tag/Nacht (AD05/AD0E), Recruited über Sys_Family (Tag Home, Nacht AD06). Stage 100 Killed: Kampf. Übergang `JudgeRecruit` (Stage 100, danach `MoveTo`): kurz ohne Package, dann `Hrefna_Home`.
- Veyra: [10, 20) AD0B, [20, 70) VeyraFollow, [70, 100) AD0C, ab 100 NPC-Liste mit 18–02 / 02–10 / 10–18 (24 h lückenlos).
- Quintus: Tag/Nacht (22:00 + 480, 06:00 + 960) decken 24 h ab; der Farm-Fall steht oben.
- Follow-Packages beginnen erst mit der Stage, die das Gespräch setzt (Lehre 8): Escort 50, JudgeFollow 70, VeyraFollow 20.
- Kein Schlafpackage ohne Alternative: findet `Sleep` kein Bett (B1–B6 fehlen), fällt die Liste auf das nächste Package (Sandbox/Travel unten) zurück.

## 4. Geänderte Dateien

4.1 Neu: `plugin-text/Packages/NHV_Pkg_Q01_*` (19 Packages AD00–AD12; Sandbox 01C254, Follow 019B2C, Sleep 019717 aus Skyrim.esm) und `plugin-text/Globals/NHV_Q01_QuintusAtFarm - 00AD20_NightsHarvest.esp.yaml` (GlobalShort, 0 = im Inn, 1 = auf dem Hof).

4.2 Additiv ergänzt (nichts gelöscht): NPC-Listen `NHV_Hakan` (AD01, AD00 vor 498B), `NHV_Hrefna` (AD0E, AD05, AD03, AD02 vor 498C), `NHV_Quintus` (AD07, AD09, AD08 vor 498D/4989), `NHV_Veyra` (neue Liste AD10, AD11, AD12; Record hatte vorher keine); Quest `NHV_Q01_TheUnansweredSacrament`: `VeyraAlias` um AD0B, AD0C (nach 7F30, 4991), `HrefnaAlias` AD0F, AD0D vor 498E und AD04 danach; Quest `NHV_Sys_Family`: Alias 2 (`HrefnaSlot`) bekommt AD06 vor 4992.

4.3 Geändert: `NHV_Q01_WatchpostSoldier` (0089F2): Template-Flags `AIPackages` und `DefPackList` entfernt, Package AD0A eingetragen (Rückweg: die zwei Flags wieder eintragen).

4.4 Scout/Scavenger: unverändert. `tools/build_q01_enhanced.py`, `make_npcs.clone()`: setzt die Package-Liste der Klone fest auf `0956B8` (sonst erbten sie Hakans Liste). Kein Generatorlauf, nie `--write`.

4.5 `Data/Source/Scripts/NHV_Q01Script.psc` (additiv, kompiliert, 413 .pex, 0 Fehler): neue Funktion `SetQuintusAtFarm(Bool)` (Global 0xAD20 per `Game.GetFormFromFile`, Log bei fehlendem Global); aufgerufen in `QuintusToInn`/`QuintusToFarm` (vor `MoveQuintus`, also auch bei totem oder fehlendem Quintus), im Reset-Zweig von `VeyraTick`, in `OnContractLoadGame` (Stage < 45); `CaptureOutcome` ruft nach `QuintusToFarm()` `kHrefna.EvaluatePackage()`, damit der Farm-Wartepfad (hängt am Global) sofort greift.

Lehre 1: alle neuen Records liegen außerhalb 0x7000–0x7FFF (`clean_range` berührt sie nicht); `patch_quest` schreibt nur Stages/Objectives/Fragmente und erhält die neuen Alias-Einträge.

## 5. CK-Aufgaben

Reihenfolge: ESP einmal im CK öffnen und speichern (E17), danach.

### NEU ERSTELLEN: feste Betten (Referenz jeweils persistent mit EditorID, danach im Package umstellen)

Je Bett: Vanilla-Bett (z. B. `BedrollHay01` für Lager/Steg, `BedSingle` oder `BedDouble` für Häuser) platzieren, Ref **Persistent**, EditorID wie unten, Ownership leer oder der NPC. Dann CK → Gameplay → Packages → Package öffnen → Reiter **Package Data** → **Sleep Location**: Typ **Near reference**, Ref = die Bett-Ref, Radius 64–100.

| # | Bett-Ref (EditorID) | Wo | Package, dessen Location umzustellen ist (aktuell Platzhalter) |
|---|---|---|---|
| B1 | `NHV_Ref_Q01_HakanBed` | Steg bei `NHV_Mk_Q01_HakanSpot` (0048A7), Tamriel, Zelle `MorthalExterior03`; Schlafrolle oder Hütte mit Bett | `NHV_Pkg_Q01_HakanDockNight` (AD01) |
| B2 | `NHV_Ref_Q01_HrefnaBedroll` | Lager bei `NHV_Mk_Q01_CampMarker` (004980), 100–300 Einheiten vom Feuer | `NHV_Pkg_Q01_HrefnaCampNight` (AD03) |
| B3 | `NHV_Ref_Q01_HrefnaFarmBed` | Innenzelle `NHV_StormhollowFarmCell` (0048A8), Schlafzimmer des Hauses | `NHV_Pkg_Q01_HrefnaFarmWaitNight` (AD0F) und `NHV_Pkg_Q01_HrefnaFarmNight` (AD0E) |
| B4 | `NHV_Ref_Q01_HrefnaHomeBed` | Deep Sanctuary, Wohnbereich nahe `NHV_Mk_Q01_KitchenSpot` (00498A) | `NHV_Pkg_Q01_HrefnaHomeNight` (AD06) |
| B5 | `NHV_Ref_Sys_VeyraBed` | Deep Sanctuary, Veyras Quartier (eigener Raum nahe Ledger Room, `NHV_Mk_MapTable_Veyra` 005ECD) | `NHV_Pkg_Q01_VeyraRest` (AD12) |
| B6 | kein festes Bett | Moorside Inn: Quintus nimmt ein freies Bett im Radius 1024 um `NHV_Mk_Q01_QuintusInnSpot` (0089FD) | `NHV_Pkg_Q01_QuintusInnNight` (AD09) unverändert |

Weitere neue Aufgaben (Möbel für die Tag-Sandboxen): Sitzgelegenheit am Steg (N1), Lagerfeuer und Sitzplätze am Lager (N2, Radius 450 um 004980), Kochstelle/Tisch/Stuhl in der Küche der Deep Sanctuary bei 00498A (N3), optional Bank am Hof bei `NHV_Mk_Q01_HrefnaFarmSpot` 0089E7 (N4).

### KONTROLLIEREN

| # | Prüfpunkt |
|---|---|
| K1 | Reihenfolge in den AI-Packages-Reitern von `NHV_Hakan`, `NHV_Hrefna`, `NHV_Quintus`, `NHV_Veyra`: neue Packages oben, alte unten (nicht umsortieren). |
| K2 | Soldaten (0089F2): im Reiter AI Packages nur `NHV_Pkg_Q01_SoldierWatch`; AI Packages/Def Pack List im Template-Fenster nicht mehr angehakt. |
| K3 | Marker `HakanSpot`, `CampMarker`, `QuintusFarmSpot`, `HrefnaFarmSpot`, `QuintusInnSpot` und Veyras Orte auf Navmesh. |
| K4 | Quest-Aliase: `VeyraAlias` = 7F30, 4991, AD0B, AD0C; `HrefnaAlias` = AD0F, AD0D, 498E, AD04; `NHV_Sys_Family` `HrefnaSlot` = AD06, 4992. |
| K5 | **Türweg Dawnstar Sanctuary ↔ Deep Sanctuary für Veyras Tagesablauf:** Die Ladetür (`NHV_DeepSanctuaryDoor` 003D8A beziehungsweise Sealed-Passage-Türen 000DD5/000DD6) darf für NPCs nicht gesperrt oder skriptgesteuert verschlossen sein, sonst bleibt Veyra beim Fensterwechsel in einer Zelle hängen (Package-Ziel in der anderen Zelle). Im Test beobachten. |
| K6 | Veyra und Q00/E51: `NHV_Pkg_Q00_*` laufen am Alias (Q00-Stage), Veyras NPC-Pakete gelten erst bei Q01 Stage ≥ 100; kein Konflikt erwartet, Q00-Nachspiel (MCM-Reset) prüfen. |
| K7 | Scavenger (7F20) und Scout (7F21): Basis-Package `0956B8`, Bettrollen (besitzlos) und Feuerstelle aus der CK-Anleitung Abschnitt 4 vorhanden. |

### Farmtür: Spieler landet beim Zurückgehen von innen nach außen auf der falschen Türseite

Befund aus `plugin-text/` (Cell `NHV_StormhollowFarmCell` 0048A8; Tamriel-Außenzelle, `MorthalExterior08`):

| Ref | Rolle | Position (x, y, z) | Rotation z | Teleport-Ziel (`XTEL`) |
|---|---|---|---|---|
| `00497B` | Außentür (Basis `012EB1`) | -25376, 70592, -13216 | 0 (nicht gesetzt) | Tür 004976, Landung innen bei (-128, -320, 64), Blick 1,5708 rad (90°) |
| `004976` | Innentür (Basis `004975` `NHV_Door_StormhollowFarmEntry`) | -128, -352, 160 | 1,5708 (90°) | Tür 00497B, Landung außen bei **(-25376, 70560, -13216)**, Rotation **nicht gesetzt (0)** |

Auswertung: Die Landung außen liegt 32 Einheiten **südlich** (y kleiner) der Außentür und der Spieler blickt nach Norden (Rotation 0), also **auf die Tür zu**. Alle Hof-Marker liegen südlich der Tür (`QuintusFarmSpot` y 70432, `HrefnaFarmSpot` y 70378, Karte y 70240): die Vorderseite der Tür zeigt also nach Süden und die Landeseite stimmt. Im Vanilla-Muster (Basis `012EB1`, geprüft an Vanilla-Paaren, zum Beispiel Innentür 016FC2 mit Außentür 015B6A) landet der Spieler auf der Vorderseite, rund 35–70 Einheiten von der Tür entfernt, **mit dem Rücken zur Tür** (Blickrichtung weg von der Tür). Hier ist die Blickrichtung um 180° falsch und der Abstand mit 32 Einheiten sehr knapp; beides lässt den Spieler wie „auf der falschen Türseite“ stehen, mit Blick zur Tür.

Vorschlag (Textänderung nur nach Prüfung im CK, deshalb nicht angewendet):

1. **CK-Prüfung:** Zelle `MorthalExterior08` (Tamriel), Ref `00497B` doppelklicken. Prüfen, ob die Tür-Vorderseite (Klinke/Türrahmen) nach Süden zeigt (Hof). Falls sie nach Norden zeigt (zur Rückseite des Hauses), ist die Landung auf der falschen Seite, dann Schritt 2b.
2. **Korrektur in der Innentür `004976`** (Zelle `NHV_StormhollowFarmCell`): Doppelklick auf die Innentür → Reiter **Teleport** (oder Door Teleport Marker im Render Window, orange Marker in der Außenzelle):
   - a) Tür-Vorderseite zeigt nach Süden: im Teleport-Dialog Position y von 70560 auf **70528** (64 Einheiten vor der Tür) und **Rotation Z = 180°** (3,1415927) setzen, so dass der Spieler vom Haus weg nach Süden zum Hof blickt.
   - b) Tür-Vorderseite zeigt nach Norden: Position y auf **70656**, Rotation Z = **0**.
   - Text-Äquivalent im Spriggit-Text von `004976` (`TeleportDestination`): `Position: -25376, 70528, -13216` und `Rotation: 0, 0, 3.1415927` (Fall a). Ich setze es erst nach deiner Rückmeldung.
3. Außentür `00497B` (Eingang): bleibt. Die Innen-Landung (-128, -320, 64) liegt 32 Einheiten vor der Innentür, das Blickziel 90° passt nicht zur Wand (Tür in der Südwand: der Spieler sollte nach Norden blicken, Rotation 0). Falls der Eingang sich ebenfalls schief anfühlt: Teleport-Rotation Z auf **0** setzen.
4. Test: Haus betreten, umdrehen, Tür aktivieren: Landung vor der Tür, Blick vom Haus weg, Hof liegt vor dem Spieler.

## 6. Offene Fragen

- **F5:** Veyras Fenster 18–02 Dawnstar / 02–10 Deep / 10–18 Schlaf sind ein Vorschlag. Anders gewünscht (zum Beispiel kürzerer Aufenthalt in der Dawnstar Sanctuary, weil dort die Gespräche stattfinden)?
- **F6:** Soll Hrefna auch im **Inn-Ende** (Quintus lebt nicht auf dem Hof) in Stage 55–69 zur Farm laufen (A1)? Dann Journal 55/60 anpassen.
- **F7:** Der Farm-Weg setzt voraus, dass `NHV_Status_Hrefna` bei Release auf 3 steht (tut `JudgeRelease`).
- **F8:** Die Veyra-Kette Dawnstar ↔ Deep Sanctuary läuft durch eine Ladetür (K5).
- **F9:** Ob das Soldaten-Template (01FC5B) ohne die entfernten Flags Nebenwirkungen hat.

## 7. Prüfung

- Spriggit-Probelauf (Kopie von `plugin-text/` im Scratchpad, `convert-to-plugin` in ein Temp-ESP, `convert-from-plugin` zurück): erfolgreich; Zeitfenster, Bedingungen, Sleep-Template, Alias- und NPC-Listen überleben. 3075 FormKeys, 3075 referenzierte, **0 offene Links**.
- `Data/NightsHarvest.esp` wurde nicht beschrieben. `tools/build.ps1`: fehlerfrei.
- `papyrus-reviewer` Runde 1: freigegeben mit Hinweisen (Log bei fehlendem Global eingearbeitet; `GetFormFromFile` statt Property bewusst, wie `TakeLetter()`); Runde 2: freigegeben mit Hinweisen. Eingearbeitet: Global wird in `QuintusToInn`/`QuintusToFarm` gesetzt (nicht mehr in `MoveQuintus`). Bewusst offen: nach Stage 100 wird der Global nicht zurückgesetzt, Quintus bleibt bei Farm-Ende als Gefangener am Hof (`QuintusFarmHold` hat nur eine Untergrenze Stage ≥ 45); Hrefnas Farm-Wartepaket endet an Stage < 70.

## 8. Testschritte (ohne `cqf`; Konsolenhilfen nur per FormID)

Voraussetzung: ESP einmal im CK gespeichert, Betten (B1–B5) gesetzt, Spiel mit neuem ESP, Papyrus-Logging an.

1. **Hakan:** am Steg: tagsüber sitzt/idlet er; nachts legt er sich in sein Bett (B1); ohne Bett steht er.
2. **Hrefna im Lager** (Stage 25–48): tagsüber am Feuer, nachts in der Bettrolle (B2); Ambush-Szene läuft normal; sie verlässt das Lager nicht.
3. **Hrefna Stage 50–100:** Trial: sie folgt (Escort). Capture- oder Player-Kill-Ende (Quintus auf dem Hof, Log „SetQuintusAtFarm: 1“): ab Stage 55 steht sie auf dem Hof, nachts schläft sie im Haus (B3); kein Follow. Inn-Ende: sie folgt weiter. `setstage NHV_Q01_TheUnansweredSacrament 70`: sie folgt. Release (Status 3): Hof bzw. Farmhaus; Recruit: Küche, nachts Bett B4.
4. **Quintus:** im Inn tagsüber am Tisch; nachts in einem freien Bett; Farm-Pfad: bleibt am Hof, geht nicht ins Inn zurück; nach Quest-Reset (Stage < 45, Save laden): Log „SetQuintusAtFarm: 0“, Quintus wieder im Inn.
5. **Veyra:** Stage 10: bleibt beim Anker; 20–69 folgt; 70: bleibt beim Spieler; ab Stage 100 über mehrere Spieltage (`wait`): Abend Dawnstar Sanctuary, Nacht Ledger Room, Tag schlafend (B5), mit Zellwechsel durch die Ladetür (K5).
6. **Soldaten und Scout:** Wachposten anschleichen: Soldaten verteilt, Kampf wie vorher.
7. **Farmtür** nach der CK-Korrektur: Haus betreten und verlassen, Landung vor der Tür mit Blick zum Hof.
8. **Log:** `Papyrus.0.log` mit aktuellem Zeitstempel ins Repo-Root.

## 9. Vorschlag Commit

`[Q01] NPC-Packages: Tag/Nacht-Routinen (Sleep-Template), Hrefna wartet auf der Farm, Veyra-Tagesablauf ab Stage 100, Quintus-Global mit Reset`
