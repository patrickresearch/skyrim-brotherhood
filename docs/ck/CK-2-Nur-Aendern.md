# CK-2: Nur Ändern (Q00, Q01, Q02)

Stand: 02.10.2026 (Fassung 2, Aufteilung der Datei `Q00-Q02-CK-Anleitung-Final.md`). **Nichts hiervon ist ingame getestet.** Diese Anleitung enthält nur Aufgaben vom Typ **Ä = ÄNDERN**: Ein Wert ist falsch oder fehlt, du passt einen **vorhandenen** Record an. Neue Records und Refs: `CK-3-Nur-Neu.md`. Kontrollen: `CK-1-Nur-Kontrollieren.md`. Einstieg, Reihenfolge, Grundgriffe im CK, Fragen: `README-CK-Anleitungen.md`.

**Wie sicher ist was?** „Laut Export“ = aus `plugin-text/` nachgelesen. **(geprüft)** = gegen `Skyrim.esm` geprüft. **(im CK prüfen)** = nicht prüfbar. Zeigt dein CK etwas anderes, melde, was du siehst.

## Einstieg und Voraussetzung (E17, Ein-Schreiber-Regel)

1. Das ESP wurde von Claude aus dem Repo-Stand geschrieben (`tools\plugin_text.ps1 -Direction ToPlugin`) und per `tools\sync_dev.ps1 -Direction ToDev -IncludeEsp` in die Dev-Kopie gelegt. Das CK läuft aus `C:\Dev\brotherhood-devenv\SkyrimSE-Dev`. Starte es erst nach Claudes Meldung „ESP geschrieben und synchronisiert“ (CK-1 K-ALL-01 bis K-ALL-03 zuerst, inklusive **K-ALL-02**, sonst scheitert der Fragment-Compile).
2. **Ein Schreiber am ESP (E17):** CK und Claude nie gleichzeitig.
3. **Keine Vanilla-Records ändern** (Regel 1). Geändert werden nur NHV-Records, Refs in den NHV-Zellen und die im Text genannten Refs in der Vanilla-Zelle `WindhelmDocksExterior01` (E16-Zell-Kopie; Meldung an Claude für die E16-Tabelle).
4. **Persistent:** Der Haken „Persistent“ existiert im CK an Charakter-Refs nicht. Er ist in dieser Anleitung überall gestrichen. Bleibt er an einer Nicht-Charakter-Ref (Marker, Bett, Item) im Dialog sichtbar, gilt: wo CK-3 ihn verlangt, setzen; fehlt er, melden.
5. Zwischenspeichern (Strg+S) ist erwünscht; am Ende nach **K-ALL-07** (CK-1) einmal speichern, CK schließen, Meldung.

## Übersichtstabelle

Phase 1 = unabhängig, zuerst (vor CK-3). Phase 3 = erst **nach** CK-3, weil die Aufgabe dessen Ergebnis (Refs, Betten) braucht.

| Neue ID | Quest | Ort | Prio | Aufwand | Wann | Kurzbeschreibung |
|---|---|---|---|---|---|---|
| Ä-Q00-01 | Q00 | `NHV_DeepSanctuaryCell` | P3 | mehrere Stunden | Phase 1 | Beleuchtung dunkel mit roten Akzenten (Teil e von C5) |
| Ä-Q01-01 | Q01 | Farmtür 00497B/004976 | P2 | 30 min | Phase 1 | Teleport-Landung und Blickrichtung |
| Ä-Q01-02 | Q01 | 5 Sleep-Packages | P2 | 30 min | Phase 3 | Location auf Bett-Refs (nach CK-3 N-Q01-01) |
| Ä-Q02-01 | Q02 | Hollow-Tür-Ref 0057D4 | P1 | 5 min | Phase 1 | `RequiredStageMax = 45` |
| Ä-Q02-02 | Q02 | Leichen-Ref 005959 | P1 | 5 min | Phase 1 | `RequiredStage 20`, `TargetStage 0` |
| Ä-Q02-03 | Q02 | Sings-Ref 005190 | P1 | 5 min | Phase 1 | **Nur** Initially Disabled (Persistent gestrichen) |
| Ä-Q02-04 | Q02 | Zellen Kontor und Hollow | P2 | 45 min | Phase 1 | Name, EditorID, Location, Owner, Vanilla-Reste |
| Ä-Q02-05 | Q02 | Quest 004100, Script-Properties | P1 | 15 min | Phase 3 | 4 neue Properties füllen (nach CK-3) |
| Ä-Q02-06 | Q02 | Enforcer AF10, Kurier AF11 | P1 | 1 h | Phase 1 | Gesicht, Outfit, FaceGen (Quelle Typ N, Records existieren) |
| Ä-Q02-07 | Q02 | Misc-Items AF31–AF33 | P3 | 15 min | Phase 1 | Model und Wert setzen (Quelle Typ N, Records existieren) |

Anzahl: 10 Aufgaben (Q00 1, Q01 2, Q02 7). Zuordnung alt zu neu: Tabelle in `CK-1-Nur-Kontrollieren.md`. Die frühere Aufgabe B9 (Haldor-Ref 005195 „Persistent“) **entfällt**: es gibt den Haken nicht; Haldor hält die Quest über seinen Unique-Actor-Alias (CK-1 K-Q02-07).

---

## Q00

### Ä-Q00-01: Deep Sanctuary: Beleuchtung (alt C5, Teil e, P3, Phase 1)

**Befund laut Export:** `NHV_DeepSanctuaryCell` (001342) ist ein Duplikat der `MarkarthTreasuryHouse`, Lighting-Template `0D7B14`, Location `NHV_DeepSanctuaryLocation` (000DD3), Navmesh vorhanden. Q00 läuft laut PROGRESS auch ohne diese Ausbaustufe; Beleuchtung gehört zur Ausbaustufe M1.3 (nicht Voraussetzung für Q00 bis Q02).
**Wo:** Cell View, Interiors, `NHV_DeepSanctuaryCell`, Zelle bearbeiten (Rechtsklick, **Edit**, Reiter **Lighting**, im CK prüfen).
**Was:** Beleuchtung **dunkel mit roten Akzenten**: das Vanilla-Template `0D7B14` als Basis lassen (Template nicht ändern, Regel 1), Werte in der Zelle überschreiben (Ambient, Directional, Fog; Werte im CK festlegen) und rote Akzentlichter bei Schrein/Memorial. Vollständige Schritte und Objektlisten: `docs/ck/M1.3-Deep-Sanctuary-Stufe1.md` (Schritte 1–7) und `docs/ck/M1.3-Deep-Sanctuary-Asset-Inventar.md`; **nicht neu schreiben, dort nacharbeiten**.
**Ergebnis:** Rückmeldung „Ä-Q00-01: nicht begonnen / fertig“. Ausbau der Räume und Room Bounds: CK-3 N-Q00-01.

---

## Q01

### Ä-Q01-01: Farmtür: Landung und Blickrichtung (alt C3, P2, Phase 1)

**Befund laut Q01-NPC-Packages (nach Export nachgelesen, Werte stimmen mit dem Export überein):** Innentür `004976` (Zelle `NHV_StormhollowFarmCell` 0048A8) landet außen bei (-25376, 70560, -13216) mit Rotation 0 (Blick nach Norden, also auf die Tür zu). Außentür `00497B` (Tamriel, Zelle `MorthalExterior08`) landet innen bei (-128, -320, 64), Blick 1,5708 rad (90°).

**Schritt 1: Türseite klären (CK-Prüfung, Entwickler).**
**Wo:** Cell View, Tamriel, `MorthalExterior08`, Ref `00497B` doppelklicken, im Render Window betrachten.
**Was:** Prüfen, ob die **Türvorderseite (Klinke, Türrahmen) nach Süden zum Hof** zeigt (Hof-Marker liegen südlich: `QuintusFarmSpot` y 70432, `HrefnaFarmSpot` y 70378, Kartenmarker y 70240). (Frage 6, README.)

**Schritt 2: Korrektur der Innentür 004976.**
**Wo:** Zelle `NHV_StormhollowFarmCell`, Ref `004976` doppelklicken, Reiter **Teleport**.
| Befund Schritt 1 | Position y | Rotation Z |
|---|---|---|
| Vorderseite zeigt nach **Süden** (erwartet) | von 70560 auf **70528** (64 Einheiten vor der Tür) | **180°** (3,1415927), Spieler blickt vom Haus weg zum Hof |
| Vorderseite zeigt nach **Norden** | auf **70656** | **0** |

**Schritt 3: Außentür 00497B (Eingang)**, falls der Eingang sich schief anfühlt: Teleport-Rotation Z auf **0** (die Tür liegt in der Südwand, der Spieler soll nach Norden blicken). Innen-Landung (-128, -320, 64) liegt 32 Einheiten vor der Innentür; bei Bedarf auf 64 erhöhen.
**Ergebnis:** Haus betreten, umdrehen, Tür aktivieren: Landung vor der Tür, Blick vom Haus weg, Hof liegt vor dem Spieler. (Ingame-Test später; Navmesh der Landeplätze: CK-1 K-Q01-02.)
**Hinweis:** Die Textänderung (`TeleportDestination`) wäre die Alternative per Spriggit; sie erfolgt nur nach deiner Rückmeldung zur Türseite, **nie** parallel zum CK. Zelle `MorthalExterior08` ist Vanilla (E16): Meldung an Claude für die E16-Tabelle.

### Ä-Q01-02: Sleep-Packages auf die Bett-Refs umstellen (alt E3, P2, Phase 3)

**Voraussetzung:** Die Bett-Refs existieren (CK-3 N-Q01-01) und haben EditorIDs, sonst erscheinen sie nicht in der Auswahl.
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
| `NHV_Pkg_Q01_QuintusInnNight` | AD09 | **unverändert** (freies Bett im Inn, Marker 0089FD, Radius 1024; CK-1 K-Q01-03) |
Schedule und Conditions **nicht ändern**.
**Alternative (Frage 5, README):** Weg wie bei Q02 (FormKeys melden, Claude setzt per Spriggit). Entscheidung vor dem Start; mit dem CK-Weg ist es in einem Durchgang erledigt.
**Ergebnis:** Fünf Packages zeigen auf die Bett-Refs. Ohne diese Umstellung suchen sie ein Bett im Radius des Platzhalter-Markers.

---

## Q02

### Ä-Q02-01: Hollow-Tür-Ref 0057D4: `RequiredStageMax` setzen (alt B6, P1, Phase 1) (Ä1 der Phase-B-Datei)

**Wo:** Cell View, World Space `Tamriel`, Zelle `WindhelmDocksExterior01`; Hollow-Außentür (Base `NHV_Q02_DrownedHollowDoorExt` 00519C) im Render Window anklicken, bei Position 143424 / 37408 / -13824 laut Export. Alternativ Object Window, **World Objects, Door**, Ref über **Cell View, Reiter References** (FormID 0057D4 suchen). Doppelklick, Reiter **Scripts**, Script `NHV_Q02_StageActivatorScript`, **Properties**.
**Was:** Neue Property `RequiredStageMax` (Int) = **45**. `RequiredStage` bleibt **40**, `TargetStage` bleibt **50** (laut Export aktuell 40/50, `RequiredStageMax` fehlt noch). Teleport-Ziel unverändert (Tür 0057D7 in der Hollow, Landung 1568 / 1920 / 32). Die Property erscheint nur, wenn die aktuelle `NHV_Q02_StageActivatorScript.psc` (und `.pex`) in der Dev-Kopie liegt (CK-1 K-ALL-01 Punkt 4).
**Ergebnis:** Ohne diesen Wert führt der Salzplatz-Pfad (Stage 45) nicht in den Hollow, falls der Laufzeit-Patch `PatchStageActivators()` ausfällt.

### Ä-Q02-02: Leichen-Ref 005959: `RequiredStage` und `TargetStage` (alt B7, P1, Phase 1) (Ä2)

**Wo:** Zelle `WindhelmDocksExterior01`, Ref `NHV_Q02_VictimCorpseRef` (005959, Position 142235 / 36068 / -13946 laut Export), Doppelklick, Reiter **Scripts**, `NHV_Q02_StageActivatorScript`, **Properties**.
**Was:** `RequiredStage` von 10 auf **20**; `TargetStage` von 20 auf **0**. `OwningQuest` und `NHV_Cfg_Debug` bleiben. (Laut Export aktuell 10/20.) Der Aktivator 00411E ist nirgends platziert: nicht platzieren.
**Ergebnis:** Das Untersuchen der Leiche springt nicht bei Stage 10 auf Stage 20 und überspringt damit die Tidehouse nicht.

### Ä-Q02-03: Sings-Ref 005190: Initially Disabled (alt B8, P1, Phase 1) (Nachtrag Koordinator a; **korrigiert 02.10.2026**)

**Korrektur:** Der Haken **Persistent** ist hier **gestrichen**: Er existiert im CK an Charakter-Refs nicht. Es bleibt **nur Initially Disabled**.
**Wo:** Zelle `WindhelmDocksExterior01`, Ref `NHV_SingsBeneathIceRef` (005190, Position 139744 / 34304 / -13952 laut Export; laut Export derzeit **nicht** disabled).
**Was:** Im Ref-Dialog **Initially Disabled** anhaken. Sonst nichts.
**Warum das trotzdem erreichbar bleibt (nachgelesen, ungetestet):** `SingsAlias` ist laut Export ein **Unique-Actor-Alias** (Basis 004107, NPC mit Flag Unique), kein Specific-Reference-Alias auf 005190; die Quest hält Sings damit, ein Persistent-Haken ist nicht nötig. Details, Alias-Kontrolle und das Script-Rückfallverhalten (`NHV_Q02Script.GetSings` über `ResolveActor` und `Game.GetFormFromFile(0x005190, …)`): `CK-1-Nur-Kontrollieren.md`, **K-Q02-07**.
**Abhängigkeit (Stand `docs/plan/Q02-NPC-Packages.md`, Ä4):** Das Skript enabliert Sings ab Stage 30 im Nachtfenster (`GetSings`: Enable bei `IsDisabled()` und `SingsMayAppear()`). Ohne den Haken bleibt Variante A (Hollow-Packages `SingsHideoutDay/Night`, AF50/AF51) als Rückfall aktiv: Sings ist dann am Hafen sichtbar, bis er in die Hollow geht. Vor Stage 30 ist Sings mit dem Haken in Windhelm **nicht sichtbar** (gewollt).
**Offen (ungetestet):** Ob ein `Enable()` aus einer anderen Zelle zuverlässig greift, zeigt erst der Test (Log „GetSings: enabling Sings (stage 30)“ und Sings sichtbar im Nachtfenster). Greift es nicht: melden; dann entscheidet der Entwickler zwischen Skript-Anpassung (z. B. `MoveTo` aus dem Alias) und Rückfall Variante A.
**Ergebnis:** Haken gesetzt. Rückmeldung „Ä-Q02-03 gesetzt“. E16: Zelle `WindhelmDocksExterior01` ist bereits eine Kopie.

### Ä-Q02-04: Kontor- und Hollow-Zelle bereinigen (alt C2, P2, Phase 1)

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

### Ä-Q02-05: Q02-Quest-Properties füllen (alt E1, P1, Phase 3)

**Voraussetzung:** Die Refs aus CK-3 existieren (N-Q02-02 Tidehouse-Enforcer, N-Q02-04 Salzplatz-Marker, N-Q02-05 Salzplatz-Enforcer, N-Q02-06 Kurier) und haben **gesetzte EditorIDs**, sonst erscheinen sie nicht in der Auswahl; die aktuelle `NHV_Q02Script.psc/.pex` liegt in der Dev-Kopie (CK-1 K-ALL-01 Punkt 4).
**Wo:** Object Window, **Character, Quest**, `NHV_Q02_ColdWaters`, Reiter **Scripts**, `NHV_Q02Script`, **Properties**.
**Was (laut Export im Quest-Record noch nicht vorhanden):**
| Property | Typ | Wert |
|---|---|---|
| `TidehouseEnforcerRefs` | ObjectReference[] | `NHV_Ref_Q02_TideEnforcer01`, `NHV_Ref_Q02_TideEnforcer02` |
| `SaltYardEnforcerRefs` | ObjectReference[] | `NHV_Ref_Q02_SaltEnforcer01` bis `03` |
| `SaltYardMarker` | ObjectReference | `NHV_Q02_SaltYardMarker` |
| `CourierRef` | ObjectReference | `NHV_Ref_Q02_ImperialCourier` |
Alle bereits gesetzten Properties **nicht anfassen** (u. a. `DispatchDeskRef` 005954, `DockWatchMarker` 005961, `SingsHollowMarker` 0057D8, `VeyraHollowMarker` 0057D9, `SingsHomeMarker` 005956, `ShadowscaleWraps` 0057D1, `TidehouseLedger` AF30). Alle neuen Properties sind **optional**; das Skript loggt bei fehlender Property und weicht aus.
**Zu „Persistent“ (korrigiert):** Die Enforcer- und Kurier-Refs sind **nicht** persistent (Haken existiert bei Charakteren nicht). Das ist unkritisch, weil das Skript sie nur anspricht, solange der Spieler **in derselben Zelle** ist (Tidehouse-Innenzelle, Salzplatz in den Docks, Kontor bei geöffnetem Pult). Eine Property auf eine solche Ref ist trotzdem ein gültiger Verweis. **Offen:** Ob eine Ref-Property auf eine nicht persistente Ref in einer gerade nicht geladenen Zelle `None` liefert (Engine-Verhalten), ist im Projekt ungetestet; Rückfall im Script: die Property-Prüfung loggt „… not set“ und weicht aus. Eine Alias-Bindung (`EnforcerAlias` 8, `CourierAlias` 9, per `ForceRefTo` im Skript) wäre die Alternative; sie ist **Skript-Sache** (Claude), nicht CK-Sache. Entscheidung offen, Ergebnis des ersten Tests abwarten.
**Hinweis Array-Eingabe:** Property markieren, **Edit Value**, Einträge hinzufügen (Bezeichnung im CK prüfen). Jeder Eintrag aus der Liste der Refs (Suchfeld, EditorID).
**Ergebnis:** Alle vier Properties gesetzt. Prüfung nach dem Speichern (ingame/Log): im Papyrus-Log darf **nicht** stehen „TidehouseEnforcerRefs not set“, „SaltYardMarker missing“.

### Ä-Q02-06: Enforcer und Kurier: Gesicht, Outfit, Ausrüstung (alt G1, P1, Phase 1) (N5)

**Typ-Hinweis:** In der Quelle als N geführt; hier unter Ä, weil die Base-Records `AF10` und `AF11` im ESP existieren und nur Werte (Gesicht, Outfit, Race) ergänzt werden. Die FaceGen-Dateien selbst entstehen neu.
**Wo:** Object Window, **Actors, Actor**, `NHV_Q02_DockEnforcer` (AF10) und `NHV_Q02_ImperialCourier` (AF11) doppelklicken.
**Befund laut Export:** Beide sind Klone des Marsh Scavenger: Race `013746` (Nord), Class `01326B`, Outfit `01DC10`, ohne Gesicht (kein `FaceMorph`, kein FaceGen-NIF in `Data\Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp`).
**Was:**
1. Reiter **Traits** / Preview-Fenster: Kopfform, Haare, Hautton festlegen. Enforcer: wirken **hafenrauh**, einheitlich genug, um als Gruppe erkennbar zu sein (dasselbe Outfit; Gesicht pro Base nur eines, also sehen alle Enforcer gleich aus; für Abwechslung kann die Race/das Aussehen eines zweiten Base-Records nötig sein, im CK prüfen).
2. Reiter **Inventory**: Outfit Enforcer = Hafenwachen-/Söldnerrüstung (Outfit im Object Window, **Items, Outfit**, Auswahl im CK prüfen; keine Vanilla-Wachen-Fraktion). Kurier = Imperiales/Reisekleidung. **Keine Waffen beim Kurier** (er flieht; E54). Enforcer bekommen eine einfache Nahkampfwaffe. (Das Imperial Seal AF33 kommt in das Inventar von AF11: CK-3 N-Q02-06.)
3. **Race des Kuriers:** Export sagt Nord (013746); ein „Imperial Courier“ wäre vermutlich Imperial (`013744`). Frage 4 (README): Race ändern ja/nein; **vor** dem FaceGen-Export entscheiden (Race-Wechsel nach FaceGen erfordert neuen Export).
4. Im Preview-Fenster **Strg+F4** (FaceGen exportieren). Prüfen: `00AF10.NIF` und `00AF11.NIF` (und die FaceTint-Dateien) erscheinen in `Data\Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp` und `Data\Textures\Actors\Character\FaceGenData\FaceTint\NightsHarvest.esp`.
5. Prüfen: **kein** Essential/Protected an beiden (Enforcer und Kurier müssen sterben können; der Kurier ist nicht unique, kann also mehrfach gespawnt werden; Mord am Kurier ist möglich und unbelohnt, E54).
**Ergebnis:** FaceGen-Dateien vorhanden, Gesichter nicht dunkel (ingame prüfen).

### Ä-Q02-07: Flavour-Items: Model und Wert (alt H1, P3, Phase 1) (N5, zweiter Teil)

**Typ-Hinweis:** In der Quelle als N geführt; hier unter Ä, weil die Records AF31–AF33 existieren und nur Model und Wert fehlen.
**Wo:** Object Window, **Items, Misc Item**, Filter `NHV_MISC_Q02_`.
**Was (Export: nur Name vorhanden, kein Model, kein Wert):**
| Item | FormID | Model | Wert |
|---|---|---|---|
| `NHV_MISC_Q02_HaldorKnife` | AF31 | Messer-Optik: ein Misc-Item mit Dolch-Optik per Duplicate-Vorbild suchen (Filter `Dagger`, `Knife`, Model-Pfad kopieren; im CK prüfen) | 0–10 |
| `NHV_MISC_Q02_SluiceToken` | AF32 | Token/Münze/Siegel (Filter `Token`, `Coin`, `Seal`) | 0–5 |
| `NHV_MISC_Q02_ImperialSeal` | AF33 | Siegel/Brief-Siegel (Filter `Seal`, `Signet`) | 0–10 |
Modell wählen, das **Kollision** hat (sonst nicht anzielbar); der Model-Auswahldialog bietet keine BSA-Meshes an (PROGRESS 30.09.: CK-Dateidialog zeigt keine BSA-Meshes). Wenn die Model-Auswahl nicht greift: **Duplicate eines passenden vorhandenen Misc-Items** und dessen Model übernehmen (Duplicate-Methode, Weg A der Map-Table-Anleitung); Claude kann den Pfad per Spriggit setzen (E17), wenn du einen Pfad meldest (z. B. `Architecture\Docks\DockRopeStr02.nif` **(geprüft)**, nur als Beispiel für den Pfadstil).
**Ergebnis:** Items sind ansehnlich anzielbar.

---

## Checkliste (abhaken)

- [ ] Ä-Q00-01 Deep Sanctuary: Beleuchtung (oder „nicht begonnen“ gemeldet)
- [ ] Ä-Q01-01 Farmtür: Türseite geprüft, Landung korrigiert
- [ ] Ä-Q01-02 Q01-Sleep-Packages umgestellt (nach CK-3)
- [ ] Ä-Q02-01 Hollow-Tür 0057D4: `RequiredStageMax = 45`
- [ ] Ä-Q02-02 Leiche 005959: `RequiredStage 20`, `TargetStage 0`
- [ ] Ä-Q02-03 Sings 005190: Initially Disabled (kein Persistent)
- [ ] Ä-Q02-04 Kontor/Hollow: Name, EditorID Hollow, Owner, Location
- [ ] Ä-Q02-05 Vier Q02-Properties gefüllt (nach CK-3)
- [ ] Ä-Q02-06 Enforcer/Kurier: Gesicht, Outfit, FaceGen
- [ ] Ä-Q02-07 Misc-Items Model/Wert

Danach: Strg+S zwischendurch; Abschluss (Speichern, schließen, Backup) in `CK-1-Nur-Kontrollieren.md` **K-ALL-07**.

## Rückmeldung an Claude (Chat)

```
CK-2 (Ändern) fertig (Datum, Dauer, CK-Version)
Erledigt: <Liste der Aufgaben-IDs>   Offen: <IDs + Grund>
Geänderte Zellen (für die E16-Tabelle in ARCHITECTURE.md):
  WindhelmDocksExterior01 (00B4B9): Ä-Q02-01 (Ref 0057D4), Ä-Q02-02 (Ref 005959), Ä-Q02-03 (Ref 005190)
  NHV_Q02_HarborClerkOfficeCell (0057DC) / NHV_Q02_DrownedHollowCell (0051AB): Ä-Q02-04 <Name, EditorID, Owner, Location>
  MorthalExterior08 (Vanilla): Ä-Q01-01 <Teleport an 00497B geändert ja/nein>
  NHV_StormhollowFarmCell (0048A8): Ä-Q01-01 (Ref 004976)
Ä-Q01-01: Türvorderseite Nord/Süd; neue Werte (y, Rotation Z)
Ä-Q01-02: Q01-Packages auf Bett-Refs umgestellt: ja/nein
Ä-Q02-05: Properties gesetzt: ja/nein (welche)
Ä-Q02-06: Race des Kuriers (Nord/Imperial), FaceGen-Dateien 00AF10/00AF11 vorhanden ja/nein
Ä-Q02-07: Model-Pfade, falls per Duplicate (für Spriggit)
Antworten auf Fragen (README): ...
Sonstiges (Absturz, Warnungen): ...
```

Danach (macht Claude): `sync_dev.ps1 -Direction FromDev`, `plugin_text.ps1 -Direction ToText`, Export prüfen, E16-Tabelle, ROADMAP/PROGRESS. Commit durch dich, kein Push, kein Tag.
