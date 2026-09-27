# Questplan Q01 – The Unanswered Sacrament

Vorbereitung für Arbeitspaket M1.7 (`docs/ROADMAP.md`). Quelle der Wahrheit: `docs/concept/konzept.md`
Abschnitt 5 (Recruitment-Contract-Schema) und Abschnitt 7 (Q01), ergänzt um
`dialogue/NightsHarvest-dialoge-und-lore/dialogue/script/Q01_The_Unanswered_Sacrament.md` (Dialogskript,
noch nicht in `dialogue/Q01.csv` übertragen – siehe Abschnitt „Dialogstatus“) und
`docs/ck/M1.6-Q01-Hrefna-Dokumente.md` (Bücher). Folgt dem Muster aus Q00 (`NHV_CoreScript`,
`QF_NHV_Q00_*`, `SF_NHV_Scn_Q00_*`, `TIF__*`, `docs/ARCHITECTURE.md` E24-Muster).

**Wichtig:** Dieser Plan berührt nicht `Data/NightsHarvest.esp`, `plugin-text/`, `dialogue/*.csv` oder
bestehende `.psc`-Dateien (ein anderer Agent schreibt das ESP; Ingame-Texte kommen von Codex). Alle
Records unten sind Vorschläge für den Entwickler im CK.

## 1. Stages, Journal, Ablauf

| Stage | Journal-ID (`dialogue/Journal.csv`, bereits vorhanden) | Phase (Schema Abschnitt 5) | Inhalt |
|---|---|---|---|
| 10 | `NHV_Q01_010_01` | Whisper | Veyra-Brief (`Veyra_Q01_Brief`, frei ansprechbar), Hakan Reed-Walker am Steg (`Hakan_Rumors`) |
| 20 | `NHV_Q01_020_01` | Hunt | Verfallener Hof (Stormhollow Farm), Wurzelkeller: Ledger, Forderungsschreiben, unversandter Brief |
| 30 | `NHV_Q01_030_01` | Hunt → Observation | Ambush: Hrefna stellt den Spieler nachts am Jagdlager (`SCN_HrefnaCamp`) |
| 40 | `NHV_Q01_040_05` | Observation | Hrefnas Geschichte, drei Dialogpfade laufen auf denselben Ausgang zusammen |
| 50 | `NHV_Q01_050_07` | Trial | Veyra erscheint (`SCN_VeyraCamp`), Prüfung: Hrefna soll Quintus töten; Variante A (Zimmer, nachts) oder B (Straße, Morgen); Persuade/Intimidate/Selbst-Töten (`SCN_Quintus`) |
| 60 | `NHV_Q01_060_01` | – (Beweis) | Quintus' Sachen durchsuchen: Oculatus-Fragment 1, `QuintusFieldNote` |
| 70 | `NHV_Q01_070_01` | Judgement | `Hrefna_Judgement`: Recruit / Release / Silence |
| 100 | `NHV_Q01_100_01` | Homecoming | Debrief bei Veyra (`Veyra_Q01_Debrief`), Map Table öffnet Q02–Q05, Hrefna zieht in die Kitchen ein |

Start: Q00 endet auf Stage 100 mit Journal-Text `NHV_Q00_100_01`, der bereits organisch zu
`NHV_Q01_010_01` führt (siehe Kommentar in `dialogue/Journal.csv` Zeile 9). Q01 muss also **automatisch**
starten, sobald Q00 Stage 100 erreicht – siehe Abschnitt 8 (Hook für `NHV_CoreScript`).

Es ist laut Schema immer nur ein Contract aktiv; Q01 ist der erste und einzige feste (danach freie
Reihenfolge Q02–Q05), daher keine Konkurrenzprüfung mit anderen Contracts nötig.

## 2. Aliase (Quest `NHV_Q01_TheUnansweredSacrament`)

| # | Alias | Fill-Type | Referenz | Optional? | Zweck |
|---|---|---|---|---|---|
| 0 | `HakanAlias` | Specific Reference | `NHV_HakanRef` (neuer, unique, persistenter Minor-NPC) | Nein | Gerüchte Stage 10 |
| 1 | `HrefnaAlias` | Specific Reference | `NHV_HrefnaRef` (neuer, unique, persistenter Story-Rekrut) | Nein | Kandidatin, wird ab Stage 100 an `NHV_Sys_Family` „übergeben“ |
| 2 | `QuintusAlias` | Specific Reference | `NHV_QuintusRef` (neuer, unique, persistenter NPC) | Nein | Opfer/Prüfziel |
| 3 | `VeyraAlias` | **leer** (kein Fill-Type) | – | **Ja** (Optional) | Trial-Szene am Lager; wird zur Laufzeit per `ForceRefTo()` gefüllt (siehe Korrektur unten) |
| 4 | `PlayerRefAlias` | PlayerRef | – | Nein | Cutscene-Lock-Wiederherstellung nach dem Laden (Abschnitt 8b) und Szenen-Kompatibilität |

**Korrektur nach Team-Lead-Review, Runde 1:** `NHV_Sys_Sanctuary` (`000809`, geprüft gegen
`plugin-text/Quests/NHV_Sys_Sanctuary - 000809_NightsHarvest.esp.yaml`) hat **keinen** Veyra-Alias –
nur Nazir, Babette, Cicero, NightMother. Es gibt auch **keinen** festen Record „`NHV_VeyraRef`“.
Veyra existiert laut `NHV_CoreScript.psc` ausschließlich als Laufzeit-Actor: Basis `NHV_Veyra`
(`000817:NightsHarvest.esp`, bestätigt in `plugin-text/Npcs/`), zur Laufzeit einmalig per
`DawnstarAnchorRef.PlaceAtMe(VeyraBase, …)` erzeugt und danach nur in der Script-Variable
`VeyraRef` von `NHV_CoreScript` gehalten (kein Alias, kein fester Platzierungs-Record). Der
öffentliche Getter dafür ist `NHV_CoreScript.GetVeyraActor()` (Zeile ~651). `VeyraAlias` bleibt
deshalb **leer** (kein Fill-Type) und wird von `NHV_ContractBaseScript.FillVeyraAlias()` zur
Laufzeit per `VeyraAlias.ForceRefTo(Core.GetVeyraActor())` befüllt – analog zu dem Muster, mit dem
Q00 seinen Coffin-Alias und die Family-Aliase in `NHV_Sys_Family` per `ForceRefTo()`/`EnsureFamilyAlias()`
statt über feste „Specific Reference“-Einträge füllt. `FillVeyraAlias()` und die `Core`-Property
liegen in `NHV_ContractBaseScript`, weil Veyra in der Trial-Phase jedes Contracts (Q01–Q05)
gebraucht wird.

Wie bei Q00: keine Vanilla-Aliase, keine Vanilla-Zellen-Änderungen außer den unten dokumentierten
Zell-Berührungen. `HrefnaAlias` und `QuintusAlias` bekommen je ein eigenes Alias-Script
(Abschnitt 6), das an die Basisklasse meldet. `PlayerRefAlias` bekommt `NHV_ContractPlayerAliasScript`
(Abschnitt 8b).

**Weitere gegen `plugin-text/` verifizierte Wiederverwendungen (nichts davon neu anlegen):**

| Record | FormID | Fundstelle |
|---|---|---|
| Global `NHV_Status_Hrefna` | `000811:NightsHarvest.esp` | `plugin-text/Globals/NHV_Status_Hrefna - 000811_…yaml` – **existiert bereits**, nicht wie in der ersten Fassung dieses Plans neu vorschlagen |
| Faction `NHV_FamilyFaction` | `000807:NightsHarvest.esp` | `plugin-text/Factions/NHV_FamilyFaction - 000807_…yaml` |
| Quest `NHV_Sys_Family`, Alias 2 „HrefnaSlot" | `000813:NightsHarvest.esp` | `plugin-text/Quests/NHV_Sys_Family - 000813_…yaml` – **bereits mit `NHV_RecruitAliasScript` und `StatusGlobal = NHV_Status_Hrefna` verdrahtet** (M1.6). `NHV_ContractBaseScript.CompleteRecruitment()` befüllt diesen Alias per `ForceRefTo()`, statt Hrefna nur an einen Marker zu `MoveTo`-en |
| NPC `NHV_Veyra` / VoiceType `NHV_VoiceVeyra` | `000817` / `000816` | `plugin-text/Npcs/`, `plugin-text/VoiceTypes/` |
| Global `NHV_Cfg_Debug` | `000800:NightsHarvest.esp` | bestehend, wie überall verwendet |

`NHV_Flag_HrefnaUnproven` bleibt ein **neuer** Global (kein bestehendes Äquivalent gefunden).
`NHV_Hakan`, `NHV_Hrefna`, `NHV_Quintus` (NPCs), alle Q01-Orte/Marker/Packages/Szenen und die
Bücher/Items aus `docs/plan/Q01-Record-Inventar.md` bleiben neu – dort ist nichts kollidiert (höchste
bisher vergebene FormID im Plugin: `003DA0`, unser Vorschlagsbereich beginnt bei `004000`).

## 3. Orte

Recherche mit `mcp__housecarl__housecarl_records` (nur lesend) gegen den aktuellen Load Order.
Der houseCARL-MCP-Server war während der Recherche mehrfach instabil (zwei Abbrüche/Timeouts bei
breiteren `REFR`-Abfragen ohne enges `types=`/`plugins=`-Scope); die unten bestätigten Treffer sind
eng genug gescopt, dass sie zuverlässig zurückkamen. Für die Details, die der Server nicht mehr
lieferte (genaue Bett-Referenz im Zimmer, genauer Steg-Anker), bleibt „im CK mit `getpos`/`getref`
nachsehen" stehen – ehrlicher als eine geratene FormID.

| Ort | Bevorzugter Kandidat | Alternative | Begründung | E16-Zellkopie? |
|---|---|---|---|---|
| Morthal-Steg (Hakan) | Eine der Vanilla-Außenzellen `MorthalExterior01`…`08` (Skyrim.esm `0093BE`/`00935B`/`0093BC`/`00939C`/`00939D`/`00939E`/`0093BD`/`0093BF`, aktuelle Gewinner `Update.esm`/`HearthFires.esm` je Zelle – bestätigt per `housecarl_records`, Abschnitt „Konsequenz" unten) | Neue, kleine Dock-Erweiterung außerhalb der bebauten Zelle vermeiden – Morthal ist ein beliebtes Overhaul-Ziel | Hakan gehört sichtbar zum bestehenden Steg/Wasser, ein neuer Ort wäre lorewidrig („Moorfischer von Morthal") | Ja, eine der acht Zellen (welche, entscheidet die genaue `getpos`-Position am Wasser) |
| Moorside Inn, Zimmer (Quintus) | Vanilla-Interior `MorthalMoorsideInn` (`0138CE:Skyrim.esm`, bestätigt) | – (es gibt nur dieses eine Gasthaus in Morthal) | Konzept verlangt ausdrücklich „gemietetes Zimmer in der Moorside Inn"; keine sinnvolle Alternative | Ja, `0138CE` (ein Zimmer/eine neue Referenz reicht, keine Vanilla-Möbel anfassen) |
| Stormhollow-Hof + Wurzelkeller | **Neue Interior-Zelle** `NHV_StormhollowFarmCell` (kein Vanilla-Gehöft in Hjaalmarch passend gefunden – die Region hat keine dem Konzept entsprechende „gepfändete Bauernhof"-Location; vorhandene Gehöfte wie Fjori-und-Holgeir-Hütte oder ähnliche Einzelgebäude sind bereits an andere Quests/Figuren gebunden) | Falls der Entwickler im CK doch eine passende, noch unbenutzte Vanilla-Hütte in Hjaalmarch findet: dann als Exterior-Dressing statt eigener Zelle, mit Zellkopie | Eigene Zelle vermeidet jede Kollision mit Stadt-/Landschafts-Overhauls und deckt Hof + Keller in einem Bauschritt ab (Architektur-Leitlinie „Schlüsselszenen in eigenen Innenzellen") | Nein für die Zelle selbst; ja für die eine Außenzelle, in der die Zugangstür steht |
| Hrefnas Jagdlager | Keine der gefundenen vanilla „Camp"-Locations passt (`CWCampsiteHjaalmarchLocation` `067981`, `MilitaryCampHjaalmarchSons/Imperial` `019276`/`019275` sind Bürgerkriegslager mit eigener Fraktionslogik – für ein stilles Jäger-/Beobachtungslager ungeeignet, würde Bürgerkriegsskripte mit hereinziehen) | Unbenannte, unauffällige Vanilla-Exteriorzelle abseits der CW-Lager im Hjaalmarch-Moor, nur mit eigenem Lagerfeuer-Dressing | Eine unbenannte Zelle ohne Eigenlogik ist das geringere Kompatibilitätsrisiko als ein bereits durch Fraktions-/Kriegsskripte belegtes Vanilla-Lager | Ja, eine unauffällige Moor-Exteriorzelle |
| Straßen-Ambush (Variante B) | Unbenanntes Straßensegment auf dem Weg Morthal→Solitude (Tamriel-Worldspace, keine benannte Location nötig) | – | Reines XMarker-Ziel für das Travel-Package, keine Gebäude/Dressing nötig | Ja, eine Straßen-Exteriorzelle |
| Deep Sanctuary „Kitchen" | Vorhandene Deep-Sanctuary-Zelle (`plugin-text/Cells/NHV_DeepSanctuaryCell - 001342_…yaml`, M1.3) | – | Bereits reservierter Raum, kein neuer Zellenzugriff | Nein |

**Konsequenz für `docs/ARCHITECTURE.md`:** Sobald die CK-Arbeit die exakten Zellen für Hakan (eine der
acht `MorthalExteriorXX`), das Jagdlager und den Straßen-Ambush festlegt, müssen sie in die
Zell-Kopien-Tabelle (E16) eingetragen werden. Absichtlich noch nicht vorab eingetragen, weil die
genaue Zelle erst im CK (Ortswahl per `getpos`) feststeht – vier zusätzliche Zeilen (Hakan-Zelle,
Farmtür-Außenzelle, Jagdlager-Zelle, Straßen-Zelle) neben den bestehenden zwei; `0138CE`
(Moorside Inn) kommt als fünfte hinzu, sofern das Gasthaus-Interior bisher noch nicht in der Tabelle
steht (prüfen).

## 4. NPCs

| NPC | Neu/Vanilla | Rasse | Rolle | Besonderheiten |
|---|---|---|---|---|
| Hakan Reed-Walker | neu | Nord | Gerüchte-Geber | Kein Rekrut, keine Fraktion, generischer Voice-Type reicht nicht (eigene LineIDs `NHV_SYS_HAK_*` laut Konzept-Stimmen-Konvention) → eigener `NHV_VoiceHakan` |
| Hrefna Stormhollow | neu | Nord | Story-Rekrut (Archery-Trainerin, Köchin) | Ab Stage 100 Übergabe an `NHV_Sys_Family`; vorher Alias-Script meldet Tod an die Quest selbst (Abschnitt 6) |
| Quintus Aufidius | neu | Kaiserlich | Oculatus-Agent, Ziel | Stirbt zwingend in Stage 50 (durch Hrefna oder den Spieler); kein Rekrut, keine Fraktion nötig außer optional `NHV_OculatusFaction` (feindlich) für Kampf-Verhalten, falls die Tötung eskaliert |

Keine Vanilla-NPC-Änderungen; alle drei sind komplett neue, eigene Actor-Records (Regel 1).

## 5. Packages & Bewegung

Template-FormIDs mit `mcp__housecarl__housecarl_records` gegen `Skyrim.esm` verifiziert (nicht geraten):

| Package | Vanilla-Vorlage (verifiziert) | Zeitsteuerung | Bedingung |
|---|---|---|---|
| `NHV_Pkg_Hakan_Fish` | `DefaultSandboxCurrentLocation1024` (`0BFB6B:Skyrim.esm`, Typ Sandbox, Radius 1024) als Vorbild für Flags/Aufbau; im CK als „From Scratch"-Sandbox-Package mit demselben Verhalten (Radius kleiner, ca. 256–512, da nur der Steg) | 08:00–20:00 Uhr, Rest des Tages Schlafen/Idle im Haus (falls eines gebaut wird) oder durchgehend, falls Hakan nur als Tag-Fixpunkt existiert | immer aktiv, Alias-Package hat Vorrang |
| `NHV_Pkg_Hrefna_CampWait` | kein Vanilla-Vorbild nötig – `Initially Disabled`, kein Package vor der Aktivierung | – | – |
| `NHV_Pkg_Hrefna_EscortPlayer` | Travel-Package-Typ verifiziert an `016FAA:Skyrim.esm` (Typ „Travel", generische Engine-Vorlage ohne EditorID); Ziel = `PlayerRefAlias` statt eines festen Punkts, „Continue if PC Near" aktiv, kein Eintrag in `CurrentFollowerFaction` | durchgehend, solange Bedingung erfüllt | `GetStageDone Q01 40 == 1 AND GetStage Q01 < 70` |
| `NHV_Pkg_Quintus_InnRoom` | `DefaultSandboxCurrentLocation256` (`0956B8:Skyrim.esm`) als Vorbild, im gemieteten Zimmer, mit Schlafen-Idle nachts | 22:00–06:00 Uhr schlafen, tagsüber Sandbox im Gasthaus (Bar, Tisch) | `GetStage Q01 >= 10` (er zieht ein, sobald Hakan über ihn spricht) |
| `NHV_Pkg_Quintus_RoadTravel` | Travel-Package wie `016FAA`, Ziel „Solitude" über die Straße, mit Lese-Idle (`IdleRead`/vanilla „Book"-Furniture-Idle unterwegs, falls im CK verfügbar, sonst normales Gehen) | ab 07:00 Uhr, nur an dem Morgen, an dem Variante B ausgelöst wird | nur aktiv, wenn Variante B (Straßen-Hinterhalt statt Zimmer) gewählt/ausgelöst wurde |

- **Hrefna vor Stage 30:** unsichtbar/deaktiviert im Wurzelkeller-Bereich (kein Package nötig – Referenz
  bleibt `Initially Disabled`, wird erst von `NHV_Q01Script` vor der Ambush-Szene aktiviert und via
  `MoveTo` an den Lagerplatz gesetzt, analog zu `PrepareStandoff()` in `NHV_CoreScript`).
- **Hrefna Stage 30–50 (Begleiterin):** `SetPlayerTeammate(True, False)` + `NHV_Pkg_Hrefna_EscortPlayer`
  (Tabelle oben). Kein Eintrag in `CurrentFollowerFaction` (bleibt außerhalb des Vanilla-Follower-Slots,
  wie im Architekturdokument für das spätere Follower-System gefordert; hier nur eine **temporäre**
  Eskorte während des Contracts, noch nicht das M2.1-Follower-System).
- **Priorität:** Alias-Packages schlagen Sandbox, wie überall im Mod (Architekturvorgabe).

**Zeitsteuerung Variante A vs. B (Stage 50):** Welche der beiden Quintus-Szenen läuft, entscheidet die
Tageszeit, zu der der Spieler mit Hrefna am Gasthaus bzw. auf der Straße ankommt, kombiniert mit einer
Dialogentscheidung, die die CK-Bedingung setzt (kein Zufall): Nach der Trial-Szene bekommt der Spieler
zwei Dialogoptionen bei Hrefna („Tonight, in his room" / „On the road at dawn" – Zeile 050_22), die
jeweils `NHV_Pkg_Quintus_InnRoom` aktiv lassen oder auf `NHV_Pkg_Quintus_RoadTravel` umschalten
(Conditions am Package, nicht am NPC-Verhalten zufällig). Die Szene selbst (`SCN_Quintus`, Variante A
oder B) startet dann über eine Näherungsprüfung wie beim Jagdlager (Abschnitt 6b), nicht über eine
feste Uhrzeit-Bedingung, damit der Spieler nicht warten muss, falls er später ankommt als geplant.

## 6. Scripts (siehe Abschnitt „Gelieferte Scripts“)

- `NHV_ContractBaseScript` (neu, Quest-Basisklasse für Q01–Q05): Judgement-Grundfunktionen
  (`CompleteRecruitment`, `RecruitDied`, `GiveFragmentIfMissing`), lokales Cutscene-Lock (unabhängig von
  `NHV_CoreScript`s Q00-Lock, siehe Abschnitt 8).
- `NHV_Q01Script` (neu, extends `NHV_ContractBaseScript`): Stage-Logik, Ambush-Poll, Szenen-Start/-Ende,
  Quintus-Tod-Auswertung, Judgement, Belohnung.
- `NHV_ContractRecruitAliasScript` (neu, `ReferenceAlias`, wiederverwendbar für Q02–Q05): meldet den Tod
  der Kandidatin **während** des Contracts an die Quest (Gegenstück zu `NHV_RecruitAliasScript`, das laut
  Kommentar in dessen Kopf ausdrücklich nur Tode **nach** der Homecoming behandelt).
- `NHV_Q01_QuintusAliasScript` (neu, `ReferenceAlias`, Q01-spezifisch): meldet Quintus' Tod, unabhängig
  davon wer ihn tötet.
- `NHV_ContractPlayerAliasScript` (neu, `ReferenceAlias`, wiederverwendbar für Q02–Q05): hängt an
  `PlayerRefAlias`, gibt ein nach dem Laden noch gesperrtes Cutscene-Lock frei (`OnPlayerLoadGame()` →
  `NHV_ContractBaseScript.RecoverCutsceneOnLoad()`), analog zu `NHV_PlayerAliasScript.OnPlayerLoadGame()`
  → `Maintenance()` auf `NHV_Sys_Core`.

**Cutscene-Lock, Runde-1-Korrektur:** `NHV_ContractBaseScript` trägt jetzt ein vollständiges,
generalisiertes Lock/Watchdog-Paar (`LockCutscene(Scene)`, `UnlockCutscene()`, `IsCutsceneLocked()`,
`RecoverActiveCutscene()`), das dem `ActiveCutscene`/`RecoverActiveCutscene()`-Muster aus
`NHV_CoreScript` entspricht: ein 2-Sekunden-Watchdog (`OnUpdate`, Cap 60 Ticks ≈ 120 s, wie beim Q00-
Standoff) erzwingt die Freigabe, falls eine Szene hängt, abbricht oder durch Kampf unterbrochen wird,
und `RecoverCutsceneOnLoad()` fängt den Sonderfall „mitten in der Szene gespeichert" ab. `NHV_Q01Script`
überschreibt `OnUpdate()` für die eigene Ambush-Distanzprüfung (Stage 20) und ruft danach immer
`Parent.OnUpdate()`, damit der geerbte Watchdog weiterläuft – Papyrus vererbt Properties und Funktionen,
aber **keine** einfachen Script-Variablen (das erste Build schlug genau daran fehl: „variable
ActiveCutscene is undefined" in der abgeleiteten Klasse; behoben, indem `NHV_Q01Script` nur noch die
öffentliche Funktion `IsCutsceneLocked()` abfragt statt die Basisklassen-Variable direkt zu lesen).

## 6b. Szenen im Detail (Phasen, Actions, Aliase)

**`NHV_Scn_Q01_01CampAmbush`** – Aliase: `HrefnaAlias`, `PlayerRefAlias`. Auslöser: `AmbushDistanceCheck()`
in `NHV_Q01Script` (Näherung an `CampMarker`, kein Trigger-Volume, kein Navmesh-Edit).

| Phase | Actor | Action | Dialog |
|---|---|---|---|
| 1 „Enter" | Hrefna | tritt mit gespanntem Bogen aus dem Nebel/Gebüsch an `NHV_Mk_Q01_CampAmbushSpot`, zielt auf den Spieler (Idle „Aim"/Combat-Idle ohne echten Kampf, oder `PlayIdle` Bogen-Halte-Idle) | 030_01, 030_02 |
| 2 „Dialog" | Hrefna, Spieler | keine Bewegung, Dialog-Branch mit drei Spieler-Optionen (alle drei führen zu 030_11/040_01, siehe Dialogplan) | 030_10…030_32, 040_01…040_61 |
| 3 „Resolve" | Hrefna | senkt den Bogen (Idle „LowerBow" oder Waffe wegstecken) | letzte Zeile 040_61 |

Ende: Szenen-Endfragment ruft `(GetOwningQuest() as NHV_Q01Script).EndCampAmbush()`.

**`NHV_Scn_Q01_02VeyraTrial`** – Aliase: `VeyraAlias` (zur Laufzeit per `FillVeyraAlias()` gefüllt),
`HrefnaAlias`, `PlayerRefAlias`. Auslöser: `StartVeyraTrial()`, aufgerufen aus dem Stage-40→50-Fragment
(letzte Dialogzeile 040_61).

| Phase | Actor | Action | Dialog |
|---|---|---|---|
| 1 „Erscheinen" | Veyra | wird an `NHV_Mk_Q01_VeyraAppearSpot` sichtbar (gleiches Unsichtbarkeits-/Fade-Muster wie beim Q00-Standoff prüfen und wiederverwenden, falls dort ein Shader/State existiert; sonst einfaches `Enable`+`PlayIdle`) | 050_01 |
| 2 „Schreck" | Hrefna | Schreckreaktion (Idle „Flinch"/„Startled") | 050_02 |
| 3 „Ansage" | Veyra | wendet sich an Spieler und Hrefna abwechselnd | 050_03…050_08 |
| 4 „Abgang" | Veyra | geht Richtung Dunkelheit/Nebel, `Disable` am Szenenende (kein `MoveTo` nötig, sie bleibt für Stage 100 über `GetVeyraActor()` erreichbar) | 050_08 „Fade" |
| 5 „Reaktion" | Hrefna, Spieler | Dialog mit Speech-Check-Option (050_20, Persuade) | 050_10…050_22 |

Ende: Szenen-Endfragment ruft `(GetOwningQuest() as NHV_Q01Script).EndVeyraTrial()`.

**`NHV_Scn_Q01_03QuintusRoom`** (Variante A) – Aliase: `HrefnaAlias`, `QuintusAlias`, `PlayerRefAlias`.
Auslöser: Näherung an Quintus' Bett im Moorside-Inn-Zimmer, nachts (22:00–06:00, siehe Package-Tabelle
Abschnitt 5), analog zur Ambush-Näherungsprüfung.

| Phase | Actor | Action | Dialog |
|---|---|---|---|
| 1 „Bereit" | Hrefna | steht am Bett, Waffe gezogen, Quintus schläft (Sandbox-Idle „Sleep") | 050_30 |
| 2 „Brief" | Hrefna | entdeckt den Brief an die Tochter auf dem Nachttisch (Idle „Read"/Item-Look) | 050_40 |
| 3 „Entscheidung" | Spieler | Persuade/Intimidate/„Step aside" (Speech-Checks als Dialog-Bedingungen) | 050_50…050_71 |
| 4a „Hrefna tötet" | Hrefna | Kill-Move oder Sneak-Attack auf den schlafenden Quintus | 050_80 |
| 4b „Spieler tötet" | Spieler | übernimmt die Tötung (kein Szenen-Actor-Wechsel nötig, `OnQuintusKilled` erkennt den Killer selbst) | 050_71 |

**`NHV_Scn_Q01_03QuintusRoad`** (Variante B) – Aliase: `HrefnaAlias`, `QuintusAlias`, `PlayerRefAlias`.
Auslöser: Näherung an `NHV_Mk_Q01_RoadAmbushSpot`, morgens (ab 07:00, Quintus auf `NHV_Pkg_Quintus_RoadTravel`).

| Phase | Actor | Action | Dialog |
|---|---|---|---|
| 1 „Begegnung" | Quintus | geht lesend (Idle „ReadWhileWalking", falls vorhanden, sonst normales Gehen + `PlayIdle` Buch) auf dem Weg, bemerkt Spieler+Hrefna | 050_31, 050_32 |
| 2 „Brief" | Hrefna | wie Variante A, aber im Gehen/Stehen am Wegrand | 050_40 |
| 3 „Entscheidung" | Spieler | wie Variante A | 050_50…050_71 |
| 4 „Tat" | Hrefna/Spieler | wie Variante A, im Freien statt am Bett | 050_80 |

Beide Quintus-Szenen brauchen **kein** eigenes Start-/End-Fragment auf `NHV_Q01Script` – der Tod selbst
löst über `NHV_Q01_QuintusAliasScript.OnDeath()` automatisch `OnQuintusKilled()` aus (Abschnitt 6). Die
Szenen selbst laufen komplett dialog-/package-gesteuert aus dem CK; kein Cutscene-Lock nötig, da der
Spieler hier aktiv Regie führt (Persuade/Intimidate-Wahl, ggf. eigener Angriff) statt nur zuzusehen.

## 7. Bedingungen, Entscheidungen, Ausgänge

| Ausgang | Auslöser | Wirkung |
|---|---|---|
| Recruit (bestanden) | Stage 50 Persuade/Intimidate erfolgreich, Hrefna tötet Quintus selbst | `NHV_Status_Hrefna = 1`, Homecoming, kein `Unproven`-Flag |
| Recruit (`Unproven`) | Spieler tötet Quintus selbst (Option 3 „Step aside“) oder Persuade/Intimidate misslingt und Spieler übernimmt | `NHV_Status_Hrefna = 1`, `NHV_Flag_HrefnaUnproven = 1`; Flag wird laut `FAM_Hrefna.md` erst in Q06 aufgehoben |
| Release | Judgement Option 2 | `NHV_Status_Hrefna = 3`, Hrefna bleibt in Hjaalmarch, Brief nach 7 Tagen (Abschnitt 9, Codex-Auftrag nötig) |
| Silence | Judgement Option 3 | `NHV_Status_Hrefna = 2` (per `RecruitDied`, ausgelöst durch echten Kampf, nicht direkt gesetzt – siehe Skript) |

Wichtig laut Entscheidungsnotiz (`docs/DECISIONS.md`, Status-Werte 0–4 „nicht selbst festlegen“): Die
Werte 0–4 sind bereits im Konzept fixiert (Abschnitt 5, „Status-Tracking“) und werden hier nur
**verwendet**, nicht neu definiert – 2 = getötet, 3 = freigelassen. Keine Abweichung nötig.

## 8. Hooks in `NHV_CoreScript` (Stand Runde 2 – vom Team-Lead nachgerüstet, v32)

`NHV_CoreScript.psc` wird von dieser Aufgabe weiterhin nicht selbst bearbeitet; die beiden unten
genannten Hooks kamen zwischenzeitlich vom Team-Lead in v32 dazu und werden hier nur noch
dokumentiert/verwendet:

1. **Q01-Start:** `NHV_CoreScript` hat jetzt `Quest Property Q01` und `Function StartQ01()`, aufgerufen
   am Ende von Q00. CK-Schritt: die Property `Q01` an `NHV_Sys_Core` auf
   `NHV_Q01_TheUnansweredSacrament` setzen (siehe `docs/ck/M1.6-Q01-CK-Anleitung.md` Abschnitt 1b).
2. **Gegenseitiger Ausschluss der beiden Cutscene-Locks:** `NHV_CoreScript` hat jetzt
   `Bool Function IsCutsceneLocked()`. `NHV_ContractBaseScript.LockCutscene()` fragt das über die
   `Core`-Property ab und verzichtet auf das eigene Sperren, solange Q00 noch die Kontrolle hält
   (`docs/plan/…` Abschnitt 6). Das Restrisiko aus Runde 1 (Debug-Sprung mitten in einer Q00-Szene)
   ist damit sauber abgefangen, nicht mehr nur über Timing.
3. Kein weiterer Hook nötig: `NHV_Sys_Family`/`NHV_FamilyManagerScript` reagiert bereits generisch auf
   `NHV_RecruitJoined` (ModEvent), Q01 muss dafür nichts an `NHV_CoreScript` oder
   `NHV_FamilyManagerScript` ändern.

## 8b. NHV_ContractBaseScript-API (Stand Runde 2, für Q02–Q05 verbindlich)

- `LockCutscene(Scene akScene)` / `UnlockCutscene()` / `Bool Function IsCutsceneLocked()` –
  prüft `Core.IsCutsceneLocked()` vor dem eigenen Sperren; Watchdog (`OnUpdate`, 2 s, Cap 60) mit
  Anlauf-Toleranz (`CUTSCENE_STARTUP_GRACE_TICKS = 3`), damit `Scene.IsPlaying()` kurz nach
  `Scene.Start()` nicht fälschlich als „hängt" gewertet wird.
- `RecoverActiveCutscene()` / `RecoverCutsceneOnLoad()` – Sicherheitsnetz nach Kampf-Interrupt bzw.
  nach dem Laden, aufgerufen über `NHV_ContractPlayerAliasScript`.
- `Function OnContractLoadGame()` – leerer Hook in der Basisklasse, von `NHV_Q01Script` überschrieben
  (Freilassungsbrief-Timer nach dem Laden nachholen). Funktioniert dank virtueller Dispatch über
  Funktionsnamen auch, wenn über eine Property vom Basistyp aufgerufen – anders als einfache
  Script-Variablen, die Papyrus **nicht** an Subklassen vererbt (Lehre aus Runde 1, Abschnitt 6).
- `RecruitDied(Actor, GlobalVariable)` – bricht jetzt sofort ab, wenn der Status-Global bereits
  RECRUITED/RELEASED/SPECIAL ist (verhindert, dass ein spätes/doppeltes `OnDeath` ein bereits
  entschiedenes Ergebnis überschreibt).
- `CompleteRecruitment(Actor akRecruit, GlobalVariable akStatusGlobal, ReferenceAlias akFamilySlotAlias, ReferenceAlias akContractAlias, ObjectReference akHomeMarker)`
  – **feste, fünf-parametrige Signatur**, verbindlich für Q01–Q05. Leert jetzt zusätzlich
  `akContractAlias` (die eigene Kandidaten-Alias der Contract-Quest), damit
  `NHV_ContractRecruitAliasScript` nach der Homecoming nicht mehr feuert.

## 9. Dialogstatus (was existiert, was fehlt)

- **Fertig ausformuliert, aber noch nicht im CSV-Master:** Das komplette Dialogskript für Q01 liegt in
  `dialogue/NightsHarvest-dialoge-und-lore/dialogue/script/Q01_The_Unanswered_Sacrament.md` und
  `FAM_Hrefna.md` vor (Whisper, Hunt, Observation, Trial, Judgement, Homecoming, Alltag/Follower/Kampf).
  **`dialogue/Q01.csv` existiert aber noch nicht** – die Zeilen müssen erst im CSV-Master-Format
  (`docs/DIALOGUE.md`) angelegt werden, inklusive Topic-Namen, Speaker, Emotion, Bedingungen. Das ist
  Codex' nächster Schritt für Q01 (siehe Codex-Auftrag unten); Claude baut danach die Records
  (`tools/csv_to_plugin.py`) und lässt `lore-editor` prüfen.
- **Journal-Texte:** bereits vollständig in `dialogue/Journal.csv` vorhanden (Stages 10–100).
- **Bücher:** vollständig spezifiziert in `dialogue/Books.csv` (`NHV_SYS_BOOK_42`–`62`) und
  `docs/ck/M1.6-Q01-Hrefna-Dokumente.md`.
- **Fehlt komplett:** der Brief, den Hrefna bei „Release“ nach 7 Tagen schickt („Thank you for coming.
  Even late.“ ist nur als Kurzzitat im Konzept vorhanden, kein vollständiger Brieftext). → Codex-Auftrag
  `docs/codex/2026-09-27-Hrefna-Release-Letter.md`.
- **Fehlt:** die Übertragung des kompletten Q01-Dialogskripts in `dialogue/Q01.csv`. → Codex-Auftrag
  `docs/codex/2026-09-27-Q01-CSV-Uebertragung.md`.

## 10. Fehlschläge & Randfälle

| Fall | Verhalten |
|---|---|
| Spieler tötet Hrefna vor Stage 100 (Kampf, Unfall, Diebstahl-Eskalation) | `NHV_ContractRecruitAliasScript.OnDeath` → `RecruitDied()` → `NHV_Status_Hrefna = 2`, Cutscene-Lock wird sicherheitshalber freigegeben, Quest bleibt auf aktueller Stage stehen (kein Soft-Lock, aber auch kein Auto-Fail-Stage – Entwickler-Entscheidung: optional eine Stage 90 „Failed“ ergänzen, siehe Risiken) |
| Spieler tötet Quintus vor Stage 50 (z. B. beim Erkunden von Morthal) | `NHV_Q01_QuintusAliasScript.OnDeath` feuert unabhängig von der Trial-Szene; `OnQuintusKilled()` prüft `GetStage() < 50`, ignoriert also einen zu frühen Tod – **muss im CK zusätzlich per Faction/AI so abgesichert werden, dass Quintus vor Stage 50 nicht feindselig oder leicht angreifbar ist** (z. B. `EssentialFlag` bis Stage 40, dann `SetEssential(False)`), sonst bricht der Kern der Prüfung weg |
| Spieler überspringt die Ambush-Szene (z. B. schnellreist weg, sobald er in Reichweite kommt) | Poll (`OnUpdate`, 2 s) registriert sich neu, solange Stage 20 aktiv ist; kein Soft-Lock, die Szene startet erst bei tatsächlicher Nähe |
| Kampf während einer gesperrten Szene (z. B. Wildtier greift an) | Wie Q00: Watchdog (`WatchCampAmbush`/`WatchVeyraTrial`, 2 s, Cap ~120 s) gibt die Steuerung frei, falls die Szene nicht mehr läuft |
| Speichern/Laden mitten in einer Szene | `NHV_PlayerAliasScript.OnPlayerLoadGame()` ruft weiterhin `Maintenance()`; zusätzlich prüft jede Szene beim Start `IsDead()`/`IsDisabled()` der Beteiligten (Architekturvorgabe) und springt sonst auf die letzte stabile Stage zurück, statt hängen zu bleiben |
| Hakan stirbt (Zufallskampf, Drachenangriff auf Morthal) | Kein Blocker: Gerüchte sind reine Fluff-Dialoge, Stage 20 ist über den Fund am Hof selbst erreichbar (Ledger/Brief nennen den Namen „Eirik Ashmark“ nicht redundant zu Hakan – **zu prüfen:** Journal-Text auf Stage 10/20 stellt sicher, dass der Hof auch ohne Hakans Hinweis auffindbar ist, z. B. über eine zusätzliche Quest-Marker-Bedingung) |
| Veyra ist zur Trial-Zeit nicht erreichbar/tot (theoretisch unmöglich laut Lore, aber Mod-Kompatibilität) | `VeyraAlias` ist **Optional** (Abschnitt 2); ohne sie startet `SCN_VeyraCamp` nicht automatisch – Fallback: Stage 50 kann auch ohne Szene per Dialog-Topic-Bedingung weiterlaufen (CK-Anleitung Abschnitt „Fallback ohne Veyra“) |

## 11. Kompatibilitätsrisiken

1. **E16-Zellkopien:** Q01 berührt voraussichtlich vier bis fünf zusätzliche Vanilla-Exteriorzellen
   (Morthal-Steg, Moorside-Inn-Zimmer, Jagdlager, Straßen-Ambush). Jede davon ist ein potenzieller
   Konfliktpunkt mit Beleuchtungs-/Landschafts-Mods, wie in `docs/ARCHITECTURE.md` beschrieben. Minimieren:
   möglichst wenige, möglichst unauffällige Punkte wählen, keine Landschaftsänderungen.
2. **Stadt-Overhauls (Morthal-Erweiterungen):** Mods, die Morthal umbauen (z. B. neue Gebäude am Steg),
   können mit Hakans Platzierung kollidieren. Gegenmaßnahme laut Architekturvorgabe: `MoveTo` auf einen
   XMarker statt harter Fixkoordinaten, damit ein Patch nur den Marker verschieben muss.
3. **Essential-Flag auf Quintus:** Ohne ihn stirbt er ggf. zu früh durch generische Skyrim-Gefahren
   (Wache, Bandit, Fauna) und die Prüfung wird unlösbar. Muss im CK sauber staged werden
   (`Essential` bis Stage 40/50, dann `Protected` oder `Normal`, damit die Trial-Tötung überhaupt wirkt).
4. **Follower-Frameworks:** Die temporäre Hrefna-Eskorte (Abschnitt 5) nutzt bewusst kein
   `CurrentFollowerFaction`, genau wie das geplante M2.1-System – reduziert Reibung mit AFT/EFF & Co.,
   muss aber sauber wieder `SetPlayerTeammate(False)` setzen, falls der Spieler Hrefna vor Stage 60 verliert
   (Randfall-Tabelle).
5. **Zwei Cutscene-Locks nebeneinander (Q00 in `NHV_CoreScript`, Q01 in `NHV_ContractBaseScript`):** beide
   sperren global über `Game.DisablePlayerControls`, teilen sich aber keinen Zustand. Ein Edge-Case (Q00-
   Szene und Q01-Szene könnten theoretisch nie gleichzeitig laufen, da Q01 erst nach Q00-Stage-100 startet)
   – geringes Risiko, aber im Playtest gezielt gegenprüfen (Save mitten in Q00 laden, danach Q01 antesten).
6. **Kein Rückfall-Stage bei Kandidatentod:** Aktuell gibt es keine explizite „Contract failed“-Stage,
   falls Hrefna vor Stage 100 stirbt. Das ist eine Design-Entscheidung, keine Bug – Entwickler sollte
   festlegen, ob Q01 in diesem Fall auf einer Stage „hängen bleiben“ darf (Quest bleibt einfach unvollendet,
   Q02–Q05 werden ja erst nach Q01-Abschluss über die Map Table freigeschaltet, siehe `docs/DECISIONS.md`
   für die offene Frage, ob ein Soft-Fail-Pfad zu M1.9 gehört).

## 12. Was noch offen ist (Entscheidungen für den Entwickler)

- Exakte Zellen/Koordinaten für Hakan, Quintus' Zimmer, Jagdlager, Straßen-Ambush (nur im CK bestimmbar).
- Jagdlager als Vanilla-Exterior-Fleck vs. eigene kleine Interior-Zelle (Abschnitt 3) – Kompatibilität
  vs. Aufwand.
- Ob ein „Contract failed“-Soft-Pfad für M1.9 nötig ist (Abschnitt 11, Punkt 6).
- Reihenfolge/Timing des `NHV_CoreScript`-Hooks für den Q01-Autostart (Abschnitt 8) – wird nicht von
  Claude umgesetzt, sondern für eine eigene Änderung an `NHV_CoreScript.psc` vorgemerkt.
