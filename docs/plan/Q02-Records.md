# Q02 – Record-Inventar

Stand: 27.09.2026. Gehört zu `docs/plan/Q02-Cold-Waters.md`. Alle EditorIDs folgen
`docs/CONVENTIONS.md`. Reserve-Bereich laut Auftrag: `0x004100–0x0041FF` in `NightsHarvest.esp`.

**Wichtiger Hinweis zu den FormIDs:** Es existiert kein zentrales FormID-Ledger im Repository
(`docs/DECISIONS.md`/`docs/ARCHITECTURE.md` enthalten dazu nichts). Die Zahlen unten sind
**Platzhalter-Vorschläge** innerhalb des zugewiesenen Bereichs, keine garantierten Endwerte – das
Creation Kit vergibt die echten FormIDs beim Anlegen. Da parallel an Q01 (und ggf. Q03–Q05)
gearbeitet wird, bitte vor dem Anlegen kurz mit dem Entwickler abgleichen, welcher Teilbereich
tatsächlich schon von Q01 belegt ist, damit keine zwei Agents denselben Platzhalter im Kopf haben.
Das sollte als offene Frage in `docs/DECISIONS.md` landen (siehe Plan Abschnitt 9).

## Quest

| EditorID | FormID (Vorschlag) | Typ | Bemerkung |
|---|---|---|---|
| `NHV_Q02_ColdWaters` | `004100` | Quest | Extends `NHV_ContractBaseScript` über `NHV_Q02Script` |

## Actors (NPCs, neu)

| EditorID | FormID (Vorschlag) | Rolle |
|---|---|---|
| `NHV_SingsBeneathIce` | `004110` | Rekrutierungskandidat |
| `NHV_TorbjornIceVein` | `004111` | Hafenmeister |
| `NHV_DrinksTheBrine` | `004112` | Argonischer Hafenarbeiter |
| `NHV_HaldorFrostKnuckle` | `004113` | Schläger, Nachtszene |
| `NHV_AeliusVarro` | `004114` | Hafenschreiber, Oculatus-Informant |
| `NHV_WatchSergeantHjorald` | `004115` | Wachtsergeant, Ausliefern-Pfad |

## Placed References (ACHR, in `WindhelmDocksExterior01` u. a.)

| EditorID | FormID (Vorschlag) | Bemerkung |
|---|---|---|
| `NHV_SingsBeneathIceRef` | `004120` | Placed in `WindhelmDocksExterior01` |
| `NHV_TorbjornIceVeinRef` | `004121` | Placed in `WindhelmDocksExterior01` |
| `NHV_DrinksTheBrineRef` | `004122` | Placed in `WindhelmDocksExterior01` (Tag), `WindhelmArgonianAssemblage` (Nacht) |
| `NHV_HaldorFrostKnuckleRef` | `004123` | Placed in `WindhelmDocksExterior01`, nur zur Nachtszene aktiv |
| `NHV_AeliusVarroRef` | `004124` | Placed in `NHV_Q02_HarborClerkOfficeCell` |
| `NHV_WatchSergeantHjoraldRef` | `004125` | Placed in `WindhelmDocksExterior01` |

## Zellen (Interiors, neu)

| EditorID | FormID (Vorschlag) | Bemerkung |
|---|---|---|
| `NHV_Q02_DrownedHollowCell` | `004130` | Sings' Versteck, Stage 50 |
| `NHV_Q02_HarborClerkOfficeCell` | `004131` | Aelius' Büro/Schlafplatz, Stage 60 |
| `NHV_Q02_DrownedPoolCell` | `004132` | Rekruten-Zuhause nach Recruit; Zugang aus der Deep Sanctuary |

## Türen und Marker

| EditorID | FormID (Vorschlag) | Bemerkung |
|---|---|---|
| `NHV_Q02_DrownedHollowDoorExt` | `004140` | in `WindhelmDocksExterior01`, führt in `NHV_Q02_DrownedHollowCell` |
| `NHV_Q02_DrownedHollowDoorInt` | `004141` | Gegentür in der neuen Zelle |
| `NHV_Q02_HarborClerkDoorExt` | `004142` | in `WindhelmDocksExterior01`, führt in `NHV_Q02_HarborClerkOfficeCell` |
| `NHV_Q02_HarborClerkDoorInt` | `004143` | Gegentür in der neuen Zelle |
| `NHV_Q02_DrownedPoolDoor` | `004144` | Zugang aus der Deep Sanctuary (genaue Anbindung: CK-Anleitung) |
| `NHV_Mk_Q02_BodyExam` | `004150` | XMarker, neueste Leiche (Stage 10→20) |
| `NHV_Mk_Q02_DockWatch` | `004151` | XMarker, Spieler-Beobachtungspunkt Stage 30 |
| `NHV_Mk_Q02_HaldorSpot` | `004152` | XMarker, Haldors Position in der Nachtszene |
| `NHV_Mk_Q02_TailStart` | `004153` | XMarker, Startpunkt Beschattung Pfad A |
| `NHV_Mk_Q02_TrackingStart` | `004154` | XMarker, Startpunkt Spurensuche Pfad B |
| `NHV_Mk_Q02_AeliusKillSpot` | `004155` | XMarker, Wasser-Kill-Punkt Stage 60 |
| `NHV_Mk_Q02_SingsHomeMarker` | `004156` | Ziel für `CompleteRecruitment()` (Drowned Pool) |
| `NHV_Mk_Q02_HaldorDespawn` | `004157` | Wartezelle/Marker, falls Haldor gerettet wird |

## Szenen

| EditorID | FormID (Vorschlag) | Bemerkung |
|---|---|---|
| `NHV_Scn_Q02_01HaldorDocks` | `004160` | Stage 30 Nachtszene |
| `NHV_Scn_Q02_02VeyraHollow` | `004161` | Stage 50, Veyras Prüfungsverkündung |
| `NHV_Scn_Q02_03AeliusKill` | `004162` | Stage 60, Sings tötet Aelius |

## Packages

| EditorID | FormID (Vorschlag) | Bemerkung |
|---|---|---|
| `NHV_Pkg_Sings_DockWork` | `004170` | Tag, vor Stage 30 |
| `NHV_Pkg_Sings_NightHunt` | `004171` | Nacht, Stage 30, Bedingung Zeitfenster + Stage |
| `NHV_Pkg_Sings_HollowHold` | `004172` | Ab Stage 50, DoNothing-Template wie Q00 (kein `EnableAI(False)`) |
| `NHV_Pkg_Torbjorn_DockWork` | `004173` | Sandbox am Ostpier |
| `NHV_Pkg_Drinks_DockWork` | `004174` | Tag |
| `NHV_Pkg_Drinks_AssemblageSleep` | `004175` | Nacht |
| `NHV_Pkg_Aelius_OfficeWork` | `004176` | Tag/Abend im Büro |
| `NHV_Pkg_Hjorald_DockPatrol` | `004177` | Standard-Wachroute |

## Globals

| EditorID | FormID (Vorschlag) | Typ | Bemerkung |
|---|---|---|---|
| `NHV_Status_Sings` | `004180` | Short | Standard-Statusmuster (0–4), `docs/ARCHITECTURE.md` Zeile 95 |
| `NHV_Q02_Result` | `004181` | Short | Quest-lokal, 1=Recruit/2=Silence/3=Release/4=Ausliefern, exakt wie in `dialogue/Q02.csv` referenziert |
| `NHV_Q02_HaldorSaved` | `004182` | Short | 0/1, bereits in `dialogue/Q02.csv` als Bedingung referenziert |
| `NHV_Q02_Flag_SingsUnproven` | `004183` | Short | [Vorschlag], analog `NHV_Flag_HrefnaUnproven` |
| `NHV_Q02_Flag_VeyraDisapproval` | `004184` | Short | quest-lokal, siehe offene Frage im Plan |
| `NHV_Q02_Flag_SideA_Done` | `004185` | Short | [Vorschlag] Nebenaufgabe A abgeschlossen |
| `NHV_Q02_Flag_SideB_Done` | `004186` | Short | [Vorschlag] Nebenaufgabe B abgeschlossen |
| `NHV_Q02_Flag_AeliusFallback` | `004187` | Short | [Vorschlag] gesetzt, wenn Aelius bei Stage-60-Eintritt bereits tot ist (Robustheit gegen Zufallstod, siehe Plan Abschnitt 9) |
| `NHV_Q02_Flag_RewardGiven` | `004188` | Short | verhindert doppelte Übergabe von `NHV_Armor_ShadowscaleWraps` bei wiederholtem Debrief |

## Items

| EditorID | FormID (Vorschlag) | Typ | Bemerkung |
|---|---|---|---|
| `NHV_Note_Dispatch02` | – (bereits in `Books.csv`, `NHV_SYS_BOOK_82`) | Book | **nicht neu anlegen**, nur referenzieren |
| `NHV_Armor_ShadowscaleWraps` | `004194` | Armor | Recruit-Belohnung, bereits spezifiziert in `docs/concept/Q02-Gegenstaende-und-Lore.md` / `docs/ck/M2.1-Q02-Gegenstaende-und-Drowned-Pool.md` (vorgefunden, nicht neu erfunden); Übergabe über `NHV_Q02Script.GiveRecruitReward()` |
| `NHV_Item_Q02_FamilyLocket` | `004190` | MiscItem | [Vorschlag] Nebenaufgabe B |
| `NHV_Book_Q02_HarborLog01` | `004191` | Book | [Vorschlag] Nebenaufgabe A |
| `NHV_Book_Q02_HarborLog02` | `004192` | Book | [Vorschlag] Nebenaufgabe A |
| `NHV_Book_Q02_HarborLog03` | `004193` | Book | [Vorschlag] Nebenaufgabe A |

## Faction-Mitgliedschaft

Kein neuer Faction-Record nötig: Sings tritt bei Recruit `NHV_FamilyFaction` bei (bestehend, über
`NHV_ContractBaseScript.CompleteRecruitment()`). Hjorald erhält einen eigenen, neuen
`NHV_WindhelmGuardLikeFaction`-Eintrag **nur falls** der Entwickler ihn wie einen Wächter aussehen
lassen will, ohne einen echten Vanilla-Wächter zu verändern (Regel 1). Ansonsten reicht ein Actor
ohne besondere Fraktion.

## Spriggit-Entwürfe

Unter `staging/Q02/` liegen grobe YAML-Entwürfe (`quest.yml`, `npcs.yml`) als Diskussionsgrundlage
für den Spriggit-Export – **kein** Ersatz für `plugin-text/`, nicht zum direkten Import gedacht,
sondern zur Absprache der Feldstruktur, bevor die eigentlichen Records im CK oder per Spriggit
angelegt werden.
