# Record-Inventar Q01 – The Unanswered Sacrament

Vorschlag für neue Records in `NightsHarvest.esp`, FormID-Bereich `0x004000`–`0x0040FF` (reserviert für
M1.7 laut Auftrag; Bereich `0x0041xx` ff. bleibt für spätere Contracts frei). Der Entwickler legt die
Records im CK an; das CK vergibt die tatsächlichen FormIDs – die Werte hier sind ein Vorschlag zur
Orientierung und Kollisionsvermeidung, keine Festlegung. Vor dem Anlegen im CK gegen den aktuellen
Record-Export prüfen (M0.7-Record-Inventar als Vorbild).

**Korrektur nach Team-Lead-Review, Runde 1:** gegen `plugin-text/` verifiziert – `NHV_Status_Hrefna`
(`000811:NightsHarvest.esp`) und `NHV_FamilyFaction` (`000807:NightsHarvest.esp`) **existieren bereits**
und werden nur wiederverwendet, nicht neu angelegt (aus der Tabelle entfernt). Ebenso bereits vorhanden
und wiederzuverwenden: `NHV_Sys_Family` Alias 2 „HrefnaSlot" (`000813`, bereits mit
`NHV_RecruitAliasScript`/`StatusGlobal` verdrahtet), `NHV_Veyra`/`NHV_VoiceVeyra` (`000817`/`000816`).

| FormID (Vorschlag) | EditorID | Record-Typ | Zweck |
|---|---|---|---|
| 0x004000 | `NHV_Q01_TheUnansweredSacrament` | Quest | Hauptquest Q01 |
| 0x004002 | `NHV_Flag_HrefnaUnproven` | Global (Bool/Int) | Flag „Unproven“ für Q06 und Alltags-Dialoge (`FAM_Hrefna.md` HRE_009/091/153); neu, keine bestehende Entsprechung gefunden |
| 0x004010 | `NHV_Hakan` | NPC_ | Hakan Reed-Walker, Basis |
| 0x004011 | `NHV_HakanRef` | REFR (Actor) | Platzierte, persistente Referenz am Steg Morthal |
| 0x004012 | `NHV_Hrefna` | NPC_ | Hrefna Stormhollow, Basis |
| 0x004013 | `NHV_HrefnaRef` | REFR (Actor) | Platzierte, persistente Referenz, initial deaktiviert im Wurzelkeller-Bereich |
| 0x004014 | `NHV_Quintus` | NPC_ | Quintus Aufidius, Basis |
| 0x004015 | `NHV_QuintusRef` | REFR (Actor) | Platzierte, persistente Referenz im Moorside-Inn-Zimmer |
| 0x004020 | `NHV_VoiceHakan` | VoiceType | Eigener VoiceType für Hakan |
| 0x004021 | `NHV_VoiceHrefna` | VoiceType | Bereits in `FAM_Hrefna.md` referenziert; hier nur formal gelistet |
| 0x004022 | `NHV_VoiceQuintus` | VoiceType | Eigener VoiceType für Quintus |
| 0x004030 | `NHV_StormhollowFarmCell` | Cell (Interior) | Hof + Wurzelkeller als eine Zelle |
| 0x004031 | `NHV_Door_StormhollowFarmEntry` | DOOR (Basisobjekt) | Load Door von Hjaalmarch-Exterior in `NHV_StormhollowFarmCell` |
| 0x004040 | `NHV_Mk_Q01_HakanSpot` | REFR (XMarkerHeading) | Standort Hakan am Steg |
| 0x004041 | `NHV_Mk_Q01_FarmEntryExterior` | REFR (XMarkerHeading) | Außenpunkt der Load Door in Hjaalmarch |
| 0x004042 | `NHV_Mk_Q01_CellarInterior` | REFR (XMarkerHeading) | Zielmarker innerhalb der Zelle |
| 0x004043 | `NHV_Mk_Q01_CampMarker` | REFR (XMarkerHeading) | Zentrum des Jagdlagers, Poll-Referenzpunkt (`CampMarker`-Property) |
| 0x004044 | `NHV_Mk_Q01_CampAmbushSpot` | REFR (XMarkerHeading) | Position, an der Hrefna aus dem Nebel tritt |
| 0x004045 | `NHV_Mk_Q01_VeyraAppearSpot` | REFR (XMarkerHeading) | Position, an der Veyra sichtbar wird (Trial-Szene) |
| 0x004046 | `NHV_Mk_Q01_RoadAmbushSpot` | REFR (XMarkerHeading) | Hinterhalt-Punkt Straße nach Solitude (Variante B) |
| 0x004047 | `NHV_Mk_Q01_KitchenSpot` | REFR (XMarkerHeading) | Zielmarker Kitchen-Raum, Deep Sanctuary (Homecoming) |
| 0x004050 | `NHV_Pkg_Hakan_Fish` | Package | Sandbox am Steg |
| 0x004051 | `NHV_Pkg_Hrefna_CampWait` | Package | Warten am Lager, Stage 20–30 |
| 0x004052 | `NHV_Pkg_Hrefna_EscortPlayer` | Package | Temporäre Eskorte, Stage 40–60 (Travel zu `PlayerRefAlias`) |
| 0x004053 | `NHV_Pkg_Quintus_InnRoom` | Package | Sandbox/Schlaf im Zimmer, Variante A |
| 0x004054 | `NHV_Pkg_Quintus_RoadTravel` | Package | Travel Moorside Inn → Solitude, Variante B |
| 0x004060 | `NHV_Scn_Q01_01CampAmbush` | Scene | Hrefna stellt den Spieler (Stage 30) |
| 0x004061 | `NHV_Scn_Q01_02VeyraTrial` | Scene | Veyras Erscheinung und Prüfung (Stage 50) |
| 0x004062 | `NHV_Scn_Q01_03QuintusRoom` | Scene | Tötung, Variante A (Zimmer) |
| 0x004063 | `NHV_Scn_Q01_03QuintusRoad` | Scene | Tötung, Variante B (Straße) |
| 0x004070–0x004076 | `NHV_Q01_Veyra_Brief`, `NHV_Q01_Hakan_Rumors`, `NHV_Q01_Hrefna_Camp`, `NHV_Q01_Veyra_Camp`, `NHV_Q01_Quintus_Scene`, `NHV_Q01_Hrefna_Judgement`, `NHV_Q01_Veyra_Debrief` | Dialog-Branch (TOPC) | Sieben Topics, siehe `docs/CONVENTIONS.md`-Namensschema `NHV_<Quest>_<Sprecher>_<Thema>` |
| 0x004080 | `NHV_Item_OculatusFragment1` | MISC (Quest Item) | Erstes von fünf Oculatus-Dispatch-Fragmenten |
| 0x004081 | `NHV_Weap_BogwifesKnife` | WEAP | Belohnungswaffe (laut `docs/ROADMAP.md` M1.7), Hrefnas Messer |
| 0x004090 | `NHV_Book_HrefnaFarmLedger` | BOOK | `NHV_SYS_BOOK_42`–`45` |
| 0x004091 | `NHV_Book_HrefnaUnsentLetter` | BOOK | `NHV_SYS_BOOK_46`–`49` |
| 0x004092 | `NHV_Book_HrefnaMoorJournal` | BOOK | `NHV_SYS_BOOK_50`–`54` |
| 0x004093 | `NHV_Book_EirikDemandNotice` | BOOK | `NHV_SYS_BOOK_55`–`58` |
| 0x004094 | `NHV_Book_QuintusFieldNote` | BOOK | `NHV_SYS_BOOK_59`–`62` |
| 0x004095 | `NHV_Book_HrefnaReleaseLetter` | BOOK | Neu, Text fehlt noch (Codex-Auftrag), vorgeschlagene LineID `NHV_SYS_BOOK_85` (nächste freie Nummer in `dialogue/Books.csv`, aktuell bis 84 vergeben) |

**Nicht neu anzulegen (Wiederverwendung bestehender Records):** `NHV_FamilyFaction`,
`NHV_CandidateFaction`, `NHV_InitiateFaction`, `NHV_VeyraRef`, die Deep-Sanctuary-Zelle selbst, der
Kitchen-Raum als Zelle (nur der Marker darin ist neu).

**Spriggit-YAML-Entwurf unter `staging/Q01/`:** bewusst nicht angelegt. Q01 enthält Szenen, Dialog-Branches
und mehrere neue Zellen – von Hand geschriebenes Spriggit-YAML dafür ist fehleranfällig (Szenen-Phasen,
INFO-Verknüpfungen, Zell-Kinder) und würde der ESP-schreibende Agent ohnehin gegen den CK-Export prüfen
müssen. Die Tabelle oben plus die CK-Anleitung (`docs/ck/M1.7-Q01-CK-Anleitung.md`) sind der sicherere Weg
für „ein Schreiber zur Zeit“ (Regel 7). Falls der Entwickler trotzdem YAML-Entwürfe wünscht, bitte für
einzelne, einfache Record-Typen (Global, Faction-Zugehörigkeit) gezielt nachfragen statt für die ganze
Quest.
