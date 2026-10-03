# Q03 The Scholar's Sin – CK-Anleitung (Teil A jetzt, Teil B nach Phase C)

Stand: 02.10.2026. Entwurf von Claude, noch von keinem Menschen im CK nachvollzogen. Nichts hier ist ingame getestet.

**Ehrliche Lage:** Q03 ist im Plugin **nicht gebaut**. `plugin-text/` enthält keine Q03-Quest, keine Q03-NPCs, keine Q03-Scripts, keine Q03-Globals (Befund Q3-01). Das Generator-Skript für Q03 (Phase C) steht aus; `tools/build_q03_enhanced.py` erzeugt bisher nur den inaktiven Lese-Draft unter `dialogue/drafts/enhanced/Q03/`. Diese Anleitung ist deshalb in zwei Teile geteilt:

| Teil | Inhalt | Status |
|---|---|---|
| **A** | Räumliche und Record-Arbeit, die nicht vom Generator abhängt (Zellen, Türen, Navmesh, Licht, Marker, Säulen-Activators, Kartenmarker, Möbel, Arcanum-Raum). Du kannst sofort beginnen. | **jetzt machbar** |
| **B** | Records, die der Generator in Phase C anlegt (Quest, Aliase, Properties, Packages, Szenen, NPC-Basen, Items, Globals, FaceGen) und die du danach nur kontrollierst oder ergänzt. Platzhalter: `<FormID folgt nach Phase C>`. | **erst nach Phase C** |

Jeder Abschnitt trägt den Status in der Überschrift. Jede Aufgabe ist markiert als **NEU ERSTELLEN**, **NUR KONTROLLIEREN** oder **ÄNDERN**.

**Voraussetzungen:** `NightsHarvest.esp` im CK (File → Data → Set as Active File), Dev-Kopie (`docs/ENVIRONMENT.md`), Q02-Stand im ESP wie im Repo. Kein Spiel und kein Claude-Eingriff am ESP während der CK-Sitzung (E17, ein Schreiber zur Zeit).
**Dauer (Schätzung):** Teil A mehrere CK-Sitzungen (drei Zellen, Navmesh, Licht). Teil B etwa 1 Stunde Kontrolle.

---

## 0. Wichtige Vorab-Hinweise

### 0.1 Entscheidungen, die diese Anleitung voraussetzt (`docs/DECISIONS.md`)

| ID | Wirkung auf die CK-Arbeit |
|---|---|
| E48 | Reihenfolge Q02/Q03 **frei**. Der Map Table gibt Winterhold unabhängig vom Q02-Stand frei. **Hinweis:** `docs/plan/Q02-Q03-Enhanced-Befunde.md` (Abschnitt 3) schlägt noch „fest Q02 → Q03“ vor; maßgeblich ist der Eintrag in `DECISIONS.md` (Entwickler, 01.10.2026). Räumlich ohne Folge. |
| E51 | **Veyra begleitet in Q03 nicht.** Keine Follow-Packages, keine Veyra-Marker in Winterhold/Spire. Briefing und Debrief in der Sanctuary. |
| E57 | Prüfung zählend (2 von 3). Räumlich: nur die Prüfungs-Spots (siehe A8). |
| E58 | Rätsel mit **vier Säulen-Activators** und Zustandsarray im Script. Stab, Abschiedsbrief und Circlet kommen in den Bau. Tolfdir/Arch-Mage nur über Alias und lesende Vanilla-Abfrage. |
| E16 | Jede neue Ref in einer **Vanilla**-Zelle erzeugt eine Zell-Kopie (Tamriel-Außenzelle, `WinterholdCollegeArcanaeum`, …). Das ist nur mit Eintrag in `docs/ARCHITECTURE.md` erlaubt (siehe Abschnitt 12). |
| E17 | Ein Schreiber am ESP. Nach deiner CK-Sitzung: ESP speichern, CK schließen, Claude macht `sync_dev.ps1 -Direction FromDev` und `plugin_text.ps1 -Direction ToText`. Claude schreibt **nicht** parallel. |

### 0.2 Offene Fragen an dich (vor oder während Teil A beantworten)

| Nr. | Frage | Vorschlag dieser Anleitung |
|---|---|---|
| F1 | Wo liegt der Turm (Tamriel-Außenzelle)? Koordinaten sind **nicht** festgelegt und nirgends dokumentiert. | Du wählst eine Zelle in der Winterhold-Tundra abseits der Straße, Kriterien in A1. Du meldest Zelle und Koordinaten zurück. |
| F2 | Wegstation: Innenzelle (so im Development-Plan: `NHV_Q03_WaystationCell`) oder reine Außenruine? | Innenzelle, wie geplant. Ein Außenzugang mit Ladetür. |
| F3 | Resonanzkammer und Nireldas Labor: eine Zelle oder zwei? Der Plan nennt nur Spire und Resonanzkammer. | **Zwei Zellen:** Spire (Eingang + Four Stillnesses) und Resonanzkammer (Ward-Vorraum + Labor). Siehe A4/A5. |
| F4 | Selveni (Arcanaeum) und Thyra (Winterhold) physisch in einer Vanilla-Zelle platzieren (E16-Zellkopie) oder per Script spawnen (wie die Deep-Sanctuary-Tür)? Wo lebt Thyra? Beides ist nicht festgelegt. | Selveni in `WinterholdCollegeArcanaeum` per Ref (E16-Eintrag). Thyra: Ort von dir zu wählen, Vorschlag `WinterholdTheFrozenHearth` (Gasthaus). Alternative Script-Spawn nur nach Absprache. |
| F5 | Die vier Rätsel-Hinweisnotizen (Frost/Gift/Klinge/Stille) haben **keinen Text**. `Books.csv` führt nur vier andere Bücher. | Platz-Marker jetzt, Texte von Codex (`docs/codex/`), Items nach Phase C. |
| F6 | Falscher Boden (`dead_drop`-Knoten) oder falsche Wand (`Items-and-Evidence.md`)? | Wandnische mit Container hinter einer deaktivierbaren Wand (A8). |
| F7 | College-Übergabe: Wo und wie übergibt der Spieler Nirelda an Tolfdir? Nicht spezifiziert. | Nur Rückfrage, keine CK-Arbeit in Teil A. |
| F8 | Rasse/Aussehen von Selveni, Thyra, Überlebendem, Joric: `Characters.md` legt nur Nirelda (Altmer) fest. | Du entscheidest; Gesichtsskizze vor dem NPC-Bau (A10). |
| F9 | Fallen: `Dungeons`-Fallen aus Vanilla (Namen **nicht** geprüft). Der Draft kennt „Frostrunen, Feuerzeichen“ nur als Dekoration. | Keine Vanilla-Fallen im ersten Durchgang, nur Marker `NHV_Mk_Q03_TrapPoint01–03`; Wirkung per Script/Spell in Phase C. |

### 0.3 Lehren aus Q01/Q02, die hier konkret gelten

| Lehre | Folge für Q03 |
|---|---|
| Rückweg landet auf der falschen Türseite (Q00-Tür, `docs/ck/M1.5-Q00-Fehleranalyse-und-Loesungsplan.md`) | Teleport-Paarung **beider** Türen und Ankunftspunkte nach den Regeln in A2 setzen und **in beide Richtungen** testen. |
| Generator löscht CK-Records im ID-Bereich (Plan Lehre 1; Q2-22) | CK-Records von Teil A (Zellen, Türen, Activators, Marker) nach jedem Generatorlauf prüfen. Vorschlag Claude: Q03-Generatorbereich 0xB000–0xBFFF; dein CK-Zähler liegt weiter unten. Vor Phase C meldet Claude, wohin der CK als Nächstes vergibt. |
| Kein `cqf` | Tests über `coc`, Bewegung, Debug-Topics/MCM in Phase C (Abschnitt 14). |
| Optionale Aliase füllen sich nicht bei nicht geladener Ref | Alle Spot-Marker **persistent** mit EditorID. |
| Ghost-Flag verhindert Gespräche | Kein Ghost/Essential-Trick an Joric und Nirelda. Bleedout und Yield sind Skriptarbeit (Phase C). |

---

## 1. Grundgriffe im CK (Ergänzung zu Abschnitt A der Q01-Anleitung)

Die Grundgriffe (Objekt suchen, platzieren, Ref bearbeiten, Persistent, Duplicate) stehen in `docs/ck/M1.7-Q01-Enhanced-CK-Anleitung.md`, Abschnitt A. Hier nur Ergänzungen. Menü- und Feldnamen des CK 1.7.99 können abweichen; wenn etwas anders heißt, melde, was du siehst.

| Aufgabe | Wo / Wie |
|---|---|
| Neue Innenzelle | Cell View (World → Cell View), linker Bereich **World Space: (none)** bzw. Interiors, Rechtsklick in die Zellliste → **New**. Dialog „Cell“: **EditorID**, **Name**, Haken **Interior** (bei Neuanlage meist schon gesetzt, prüfen). Bei der Deep Sanctuary wurde ein vorhandener Raum dupliziert (M1.3); für Q03 reicht eine leere neue Zelle, wenn du aus Kits baust. |
| Layer anlegen | Fenster **Layers** (Menü **View → Layers**, Name im CK prüfen). Dort **New Layer**. Ein Objekt wechselt die Layer im Ref-Dialog (Feld **Layer**). Layer sind reine Editor-Hilfen und ändern nichts am Spiel. |
| Ladetür paaren | Ref-Dialog der Tür, Reiter **Teleport** (Name prüfen): Feld **Linked Ref/Door** und **Teleport Destination** (Position X/Y/Z, Rotation). Siehe A2. |
| Navmesh | Render Window: **Menü Navmesh bzw. Taste N / Navmesh-Toolbar** (Namen im CK prüfen). Zeichnen, **Finalize**, danach **Cell Finalize** (Namen im CK prüfen). Vorher ESP-Backup. |
| Room Bounds / Portale | Im Object Window **WorldObjects → Static → `RoomMarker`** (Name und Model **nicht geprüft**, im CK über Filter `Room` suchen) und `PortalMarker`; Anleitung der Vorgehensweise siehe M1.3 (`docs/ck/M1.3-Deep-Sanctuary-Stufe1.md`, Raumgrenzen). |
| Map Marker | Object Window **WorldObjects → Static → `MapMarker`** (geprüft, FormID `000010`, Model `Marker_Map.NIF`) ins Render Window. Details Q01-Anleitung Abschnitt 3 Schritt 2. |
| EditorID an Ref | Doppelklick auf die Ref → Feld **EditorID**. Ohne EditorID erscheint die Ref nicht in der Property-Auswahl. |

---

## 2. Record-Inventar (Teil A und B)

### 2.1 Teil A: im CK anlegen, jetzt machbar

| EditorID | Typ | Zweck | Status |
|---|---|---|---|
| `NHV_Q03_HollowfrostSpireCell` | Cell (Interior) | Eingangshalle, Four-Stillnesses-Saal | **NEU ERSTELLEN** (Name neu vorgeschlagen) |
| `NHV_Q03_ResonanceChamber` | Cell (Interior) | Ward-Vorraum, Resonanzraum, Nireldas Labor, Wandnische | **NEU ERSTELLEN** (Name laut Development-Plan) |
| `NHV_Q03_WaystationCell` | Cell (Interior) | verlassene Wegstation | **NEU ERSTELLEN** (Name laut Development-Plan) |
| `NHV_Q03_SpireDoorExt` / `…SpireDoorInt` | Door (Base) | Ladetür Tundra ↔ Spire | **NEU ERSTELLEN** |
| `NHV_Q03_ResonanceDoorOut` / `…ResonanceDoorIn` | Door (Base) | Ladetür Spire-Zelle ↔ Resonanzkammer | **NEU ERSTELLEN** |
| `NHV_Q03_WaystationDoorExt` / `…WaystationDoorInt` | Door (Base) | Ladetür Straße ↔ Wegstation | **NEU ERSTELLEN** |
| `NHV_Act_Q03_PillarFrost`, `…PillarPoison`, `…PillarBlade`, `…PillarSilence` | Activator (Base) | Vier Säulen (E58) | **NEU ERSTELLEN** |
| `NHV_Act_Q03_FrostfireWard` | Activator (Base) | Ward am Eingang der Resonanzkammer | **NEU ERSTELLEN** |
| `NHV_Cont_Q03_DeadDrop` | Container (Base) | Wandnische mit Gegenzeichen und Whisperbane-Auftrag | **NEU ERSTELLEN** |
| `NHV_Q03_SpireEZ` | Encounter Zone | Never Resets, Spire und Resonanzkammer | **NEU ERSTELLEN** |
| `NHV_Q03_HollowfrostSpireLocation`, `NHV_Q03_WaystationLocation` | Location | optional, kosmetisch | **NEU ERSTELLEN** (optional) |
| `NHV_MapMk_Q03_Spire`, `NHV_MapMk_Q03_Waystation` | Ref (MapMarker) | Kartenmarker, Initially Disabled | **NEU ERSTELLEN** |
| `NHV_Mk_Q03_*` (Liste in A9) | Ref (XMarkerHeading) | Spots, Szenen-Ziele | **NEU ERSTELLEN** |
| Arcanum-Raum in `NHV_DeepSanctuaryCell` | Ref-Gruppe | Studierecke, Bücherregale, Arcane Enchanter | **NEU ERSTELLEN** (A11) |

### 2.2 Teil B: Generator, danach kontrollieren

| Record | FormID | Status |
|---|---|---|
| Quest `NHV_Q03_TheScholarsSin` | `<FormID folgt nach Phase C>` | erst nach Phase C |
| NPC-Basen Nirelda, Selveni, Thyra, Überlebender (`NHV_Q03_RoadSurvivor`), Joric | `<FormID folgt nach Phase C>` | erst nach Phase C |
| VoiceTypes (5) | `<FormID folgt nach Phase C>` | erst nach Phase C |
| Globals `NHV_Q03_CollegeWitness`, `NHV_Q03_RoadEvidence`, `NHV_Q03_Resonance`, `NHV_Q03_LedgerRead`, `NHV_Q03_CountermarkKept` (plus Cursor, Result) | `<FormID folgt nach Phase C>` | erst nach Phase C |
| Items (siehe B5) | `<FormID folgt nach Phase C>` | erst nach Phase C |
| Script `NHV_Q03Script` (Quest) | `<Script-Name und Property-Namen folgen nach Phase C>` | erst nach Phase C |
| Szenen, Packages, Dialog-Topics | `<FormID folgt nach Phase C>` | erst nach Phase C |

---

# TEIL A – jetzt machbar

## A0. Vorbereitung und Reihenfolge – Status: jetzt machbar

Reihenfolge der Abhängigkeiten (Zellen vor Türen vor Navmesh, Navmesh zuletzt, weil spätere Verschiebungen es zerstören):

1. A1 Standort wählen (Tamriel-Außenzelle) und Layer anlegen.
2. A2 Tür-Basen und Teleport-Regeln.
3. A3 Wegstation (Innenzelle) samt Außentür.
4. A4 Spire außen und Spire-Innenzelle.
5. A5 Four-Stillnesses-Saal mit den Säulen.
6. A6 Resonanzkammer-Zelle (Ward, Vorraum).
7. A7 Nireldas Labor (in der Resonanzkammer-Zelle) und Wandnische.
8. A8 Marker für Szenen und Prüfung.
9. A9 Kartenmarker.
10. A10 Beleuchtung, Encounter Zone, Location, Room Bounds.
11. A11 Navmesh (zuletzt).
12. A12 Arcanum-Grundausbau in der Deep Sanctuary.
13. Faces (A13) erst wenn die NPC-Basen existieren.

**Vorher:** ESP-Backup (Kopie von `Data\NightsHarvest.esp` in der Dev-Kopie, Datum im Namen). Nach jedem größeren Abschnitt mit Strg+S zwischenspeichern.

**Layer anlegen (NEU ERSTELLEN)**
- **Wo:** Fenster Layers (View → Layers, Name prüfen) → New Layer.
- **Was:** fünf Layer: `NHV_Q03_Structure` (Kits, Wände, Böden), `NHV_Q03_Dressing` (Dekor, Möbel), `NHV_Q03_Puzzle` (Säulen, Ward, Wandnische), `NHV_Q03_Markers` (alle XMarker, MapMarker), `NHV_Q03_Lights` (Lichter, Room Bounds).
- **Ergebnis:** Du kannst im Render Window Gruppen ausblenden und Navmesh ohne Dekor zeichnen. Jede neue Ref sofort der passenden Layer zuweisen (Ref-Dialog, Feld Layer).

## A1. Standort Hollowfrost Spire (Tamriel) – Status: jetzt machbar – NEU ERSTELLEN

Konzept: „Kleiner Turm aus Vanilla-Kits an einer Tundrastelle, an der nur der Spieler die Tür erreichen muss.“ Koordinaten sind nicht festgelegt (F1).

**Kriterien für die Zelle:**
- Winterhold-Region (Hold), Tundra/Schnee, abseits der Straße nach Winterhold, damit niemand zufällig hineinläuft und Wegstation und Turm getrennt wirken.
- Flaches Gelände unter der Tür (Neigung gering), vorhandenes Vanilla-Navmesh unter dem Türvorplatz. Du sollst **kein Vanilla-Navmesh schneiden müssen** (ein Navmesh-Override wäre eine Vanilla-Änderung und eine neue E16-Ausnahme; gilt nur, wenn es nicht anders geht, dann **vorher melden**).
- Zelle enthält möglichst wenig Vanilla-Inhalt (Bäume, Steine sind in Ordnung). Keine Wegmarker, Lager oder Schreine in der Zelle.
- Zelle (Tamriel) wird im Cell View geladen; dort steht die Zellkoordinate X/Y. Notiere sie. Sie kommt in die Rückmeldung (Abschnitt 13).

**Was NICHT tun:** Landscape bearbeiten, Vanilla-Refs verschieben, Vanilla-Navmesh verändern, Wasser/Eis-Statics mit Vanilla-Scripts platzieren.

## A2. Ladetüren: Basen und Teleport-Regeln – Status: jetzt machbar

### Tür-Basen (NEU ERSTELLEN)
- **Wo:** Object Window → **WorldObjects → Door** → Rechtsklick → **Duplicate** (Vorlage unten) → im Dialog sofort **ID** und **Name** ändern → OK. Nie das Original speichern.
- **Vorlagen:**
  - Spire (außen und innen): `ImpDoorSingleLoad01MinUse` (Vanilla, `0EF53A`, Model `Dungeons\Imperial\Door\ImpWoodDoorSingleLoad01.nif`, geprüft) oder die Imperial-Tür, die zum Tower-Kit passt. Alternativ das vorhandene `NHV_DeepSanctuaryDoor` (Nordic, `Dungeons\Nordic\Doors\Animated\SmDoor01\NorDoorSmLoad01.nif`) duplizieren, wenn du einen Nordic-Look willst. Das Duplikat ist unser eigener Record.
  - Wegstation: `NHV_Door_StormhollowFarmEntry` (Model `Architecture\WhiteRun\WRShackDoor01.nif`) duplizieren; passt zu einer Holzhütte.
  - Resonanztür: dieselbe Imperial-Tür oder Nordic-Tür; eine **kleine Steintür** wirkt als Übergang zur Kammer besser (Wahl liegt bei dir).
  - Kein Script im Reiter Scripts mitnehmen (falls das Duplikat eines hat: entfernen).
- **Namen (Vorschläge, Ingame-Text, danach lore-editor):**

| EditorID | Name |
|---|---|
| `NHV_Q03_SpireDoorExt` | `Hollowfrost Spire` |
| `NHV_Q03_SpireDoorInt` | `Winterhold Tundra` |
| `NHV_Q03_ResonanceDoorOut` | `Resonance Chamber` |
| `NHV_Q03_ResonanceDoorIn` | `Hollowfrost Spire` |
| `NHV_Q03_WaystationDoorExt` | `Abandoned Waystation` |
| `NHV_Q03_WaystationDoorInt` | `Winterhold Road` |

### Teleport-Paarung (Lehre: Rückweg auf falscher Türseite)
Für **jedes** der drei Türpaare gilt:

1. Beide Türen als Refs platzieren (jede Tür in der jeweils eigenen Zelle). **EditorIDs der Refs:** Basis-Name plus `Ref`, z. B. `NHV_Q03_SpireDoorExtRef`, `NHV_Q03_SpireDoorIntRef`, `NHV_Q03_ResonanceDoorOutRef`, `NHV_Q03_ResonanceDoorInRef`, `NHV_Q03_WaystationDoorExtRef`, `NHV_Q03_WaystationDoorIntRef`. **Persistent** nicht nötig, wenn kein Script sie anspricht (der Ward in A6 spricht die Resonanztür an, dann **Persistent** an `…ResonanceDoorOutRef`).
2. Ref-Dialog der Tür A → Reiter **Teleport** → Feld **Linked/Destination Door** → Tür B wählen. Dasselbe in Tür B → Tür A.
3. **Ankunftspunkt je Tür:** Jede Tür trägt in ihren Teleport-Daten die Position **in der Zielzelle**, an der der Spieler ankommt. Gesetzt wird sie in der Tür, die der Spieler benutzt (also Tür A speichert, wo er in Zelle B landet). Regeln:
   - Ankunftspunkt **100–150 Einheiten** vor der Gegentür auf der **begehbaren** Seite (Seite mit Navmesh), nicht in der Wand, nicht hinter der Tür.
   - Z-Höhe auf dem Boden (Spieler fällt sonst oder steckt fest).
   - **Z-Rotation** so, dass der Spieler **von der Tür weg** und in den Raum schaut (Tür-Rotation Z ± 180°).
4. **Test in beide Richtungen** (Abschnitt 14): Hinweg und Rückweg. In der Q00-Tür landete der Rückweg zuerst auf der falschen Wandseite, weil nur ein Punkt korrigiert wurde. Nach **jedem Verschieben einer Tür** beide Ankunftspunkte neu prüfen.
5. **Nicht** mit Script-Teleport (`MoveTo`) arbeiten. Das E16-Muster der Deep Sanctuary (Script-Tür) gilt nur dort. Q03-Türen sind echte Ladetüren, damit NPCs durchgehen können (Nirelda beim Einzug, E25-Prinzip).

**Ergebnis:** drei Türpaare, jedes mit korrekt ausgerichtetem Ankunftspunkt in beiden Richtungen.

## A3. Wegstation (Innenzelle) – Status: jetzt machbar – NEU ERSTELLEN

**Zweck:** Überlebender, verbrannter Rucksack, Traveler's Token, drei klare Interaktionspunkte in einem kurzen, navmeshten Bereich (Development-Plan, Schritt 2). Alle drei Routen (Hilfe, Pack, Spuren) führen zur selben Evidenz (`roadEvidence`).

### Außentür
- **Wo:** eigene Tamriel-Außenzelle an der Straße nach Winterhold (zweite, von der Spire getrennte Zelle). Dort die Tür `NHV_Q03_WaystationDoorExtRef` an einer kleinen Ruine setzen.
- **Was:** ein Imperial-Wachposten-Stil wie im Q01-Wachposten, Bausteine aus B.3 der Q01-Anleitung (verifiziert: `ImpExtBlocks01` Model `Dungeons\Imperial\Exterior\ImpExtBlocks01.nif`, `ImpExtTowerShort01` und `ImpExtTower03`, Namen aus der Load Order geprüft; Varianten ohne `Snow` im Namen nehmen oder mit `Snow`, weil es Winterhold-Gebiet ist: **deine Wahl**). Hütte oder Torbogen mit einer klar erkennbaren Tür. Layer `NHV_Q03_Structure`.
- **Kartenmarker:** siehe A9.

### Innenzelle `NHV_Q03_WaystationCell`
- **Wo:** Cell View, Rechtsklick Interiors → New, **EditorID** `NHV_Q03_WaystationCell`, **Name** `Abandoned Waystation`.
- **Größe:** klein, ein Raum, etwa 6 × 8 m, Tür an einer Schmalseite. Kein zweiter Ausgang.
- **Aufbau:** Kit deiner Wahl (verifizierte Bausteine für Winterhold-Look: `WinterholdTowerIntFloor01` (`102079`), `WinterholdTowerIntWall06–10`; für eine Hütte stattdessen den Kit der Q01-Farm). **Ungeprüft:** ob ein Winterhold-Tower-Kit als Hütte wirkt; Schnitt und Look entscheidest du.
- **Dressing (alles Layer `NHV_Q03_Dressing`):** Bettrolle `BedrollHay01STATIC` (Model `Furniture\Bedroll\BedrollHay01.nif`, geprüft) 1–2, umgekippte Kiste, kalte Feuerstelle (`Campfire01LandBurningDirt01` laut Q01-Anleitung, in dieser Sitzung nicht neu geprüft; Filter im Object Window suchen) **ohne** Feuer, Rucksackplatz (der Rucksack selbst ist ein Misc-Item aus Phase C; hier nur die Position über den Marker).
- **Nur Platzhalter jetzt:** Marker `NHV_Mk_Q03_WaystationSurvivorSpot` (Überlebender sitzt/steht), `NHV_Mk_Q03_WaystationPackSpot` (verbrannter Rucksack), `NHV_Mk_Q03_WaystationTokenSpot` (Token). Mindestens 200 Einheiten Abstand zwischen den drei Spots, damit die Interaktionspunkte nicht verschmelzen. Alle **Persistent**, Layer `NHV_Q03_Markers`.
- **Innentür:** `NHV_Q03_WaystationDoorIntRef` an einer Schmalseite, Paarung nach A2.
- **Navmesh:** A11.
- **Licht:** schwaches, kaltes Licht. Siehe A10.

**Ergebnis:** begehbare Mini-Zelle, drei Spots, ein Türpaar. Die eigentlichen Items (Rucksack, Token) stehen nach Phase C auf den Spots (B5).

## A4. Hollowfrost Spire – Außen und Innenzelle – Status: jetzt machbar – NEU ERSTELLEN

### A4.1 Außenhülle (Tamriel-Zelle aus A1)
- **Wo:** Cell View → Tamriel → deine Zelle → Doppelklick. Object Window → **WorldObjects → Static**, Filter siehe Tabelle.
- **Bausteine (alle gegen die Load Order geprüft, Skyrim.esm):**

| Zweck | EditorID | Model |
|---|---|---|
| Hauptturm, hoch | `ImpExtTower01` (`03F1F9`) oder `ImpExtTower03` (`04CECA`) | `Dungeons\Imperial\Exterior\ImpExtTower01.nif` / `…ImpExtTower03.nif` |
| Turm klein | `ImpExtTowerShort01` (`06F729`) | `…\ImpExtTowerShort01.nif` |
| Turmschale (Ruinen-Look) | `ImpExtTowerShellBase01` (`040B30`), `…ShellWall01–04` (`040B34`, `040B35`, `040B32`, `040B33`; Zuordnung: Wall01 `040B34`, Wall02 `040B35`, Wall03 `040B32`, Wall04 `040B33`), `…ShellStairs01` (`040B36`), `…ShellTop01` (`040B37`), `…ShellFloor2nd01` (`047A4A`), `…ShellDoor01–04` (`040B31`, `040B38`, `040B2E`, `040B2F`) | `Dungeons\Imperial\Exterior\ImpExtTowerShell*.nif` |
| Trümmer | `ImpExtBlocks01` (`03F988`) und `…Blocks02–05` | `…\ImpExtBlocks01.nif` |

- **Vorschlag:** Ein einzelner Turm (`ImpExtTower01` oder `…03`), daneben ein kleiner Außenhof aus 3–4 Trümmern. Optisch „Turm an einer Tundrastelle“, nicht „Burg“. Eine Frostrunen-Dekoration mit Statics aus dem Eisset (`ImpPillar01ice` `0CE2CA`, `CaveIRPillar01_NoSnow`) ist optional.
- **Feuerzeichen / Beobachtungspunkte:** nur Dekoration (Static-Bausteine, keine Vanilla-Fallen, F9). Marker für spätere Fallen: `NHV_Mk_Q03_TrapPoint01–03` (A8).
- **Tür:** `NHV_Q03_SpireDoorExtRef` am Turmeingang, Tür-Z-Rotation nach außen auf den Spielerweg zeigend, Vorplatz auf Vanilla-Navmesh (A1).
- **Alle Statics:** Layer `NHV_Q03_Structure`.
- **E16:** Die Tamriel-Zelle wird als Kopie ins Plugin gezogen. Eintrag in A12/Abschnitt 12.

### A4.2 Innenzelle `NHV_Q03_HollowfrostSpireCell`
- **Wo:** Cell View → Interiors → New, **EditorID** `NHV_Q03_HollowfrostSpireCell`, **Name** `Hollowfrost Spire`.
- **Räume (Vorschlag, ein Durchgang):** (1) Eingangshalle mit Tür-Innenseite und Treppe; (2) Four-Stillnesses-Saal (A5); (3) Gang zur Resonanztür `NHV_Q03_ResonanceDoorOutRef`.
- **Kit:** Winterhold-Turm-Kit (verifiziert, Skyrim.esm): `WinterholdTowerIntFloor01` (`102079`), `WinterholdTowerIntFloor02` (`1096C3`), `WinterholdTowerIntWall06–10` (`077606`, `07767A`, `07767B`, `077EE9`, `10967E`), `WinterholdTowerWell01` (`10207C`), `WinterholdTowerWell02` (`10327C`), `WinterholdSBTowerIntStairs01` (`083196`), `WinterholdSBTowerIntWall01/02` (`08317B`, `08317C`). **Ungeprüft:** ob diese Teile für einen kompletten begehbaren Innenraum ausreichen und wie sie zusammenpassen; das entscheidest du beim Bauen. Alternativ baust du die Innenzelle aus einem anderen Vanilla-Kit nach deiner Wahl.
- **Layer:** Wände `NHV_Q03_Structure`, Möbel `NHV_Q03_Dressing`.
- **Dressing:** Schreibtisch mit Büchern, Notizzettel, Reagenzien (leere Tränke), Regale, Frostfeuer-Schalen als Statics. **Keine Vanilla-Items mit Scripts** platzieren.

**Ergebnis:** Zelle mit Eingangshalle und Gang, Tür zur Resonanzkammer.

## A5. Four Stillnesses: Säulen-Rätsel – Status: jetzt machbar – NEU ERSTELLEN (E58)

**Mechanik laut Konzept:** Vier drehbare Säulen mit den Symbolen Frost, Gift, Klinge und Stille. Richtige Reihenfolge **Frost, Gift, Klinge, Stille**, zusammensetzbar aus Nireldas Notizen. Zustandsarray im Script (Phase C). CK-seitig liefert diese Anleitung Activators, Platzierung und Kollision.

### Activator-Basen (NEU ERSTELLEN)
- **Wo:** Object Window → **WorldObjects → Activator** → Rechtsklick → **Duplicate** einer **Vorlage ohne Script**. Vorlage laut Load Order: `RuinsPuzzlePillar01` (Skyrim.esm `01717B`, Model `Clutter\Ruins\Pillar\RuinsPuzzlePillar01.nif`, Activator). **Achtung:** Dieser Vanilla-Activator und seine Verwandten (`NorDefaultPuzzlePillar01`, `dunSkluldafnPuzzlePillar01` …) tragen Vanilla-Puzzle-Scripts. Nach dem Duplizieren **alle Scripts im Reiter Scripts entfernen** (nur auf dem Duplikat; Original unangetastet, Regel 1). Alternativ eine eigene Modell-Wahl, wenn der Model-Dialog funktioniert (in der Map-Table-Anleitung ging er nicht).
- **IDs und Namen:**

| EditorID | Name (Ingame) |
|---|---|
| `NHV_Act_Q03_PillarFrost` | `Frost Pillar` |
| `NHV_Act_Q03_PillarPoison` | `Poison Pillar` |
| `NHV_Act_Q03_PillarBlade` | `Blade Pillar` |
| `NHV_Act_Q03_PillarSilence` | `Silence Pillar` |

- **Hinweis:** Das Modell zeigt keine vier unterschiedlichen Symbole. Vier Basen mit **eigenem Namen** reichen für die Unterscheidbarkeit (Zielhinweis beim Anvisieren). Echte Symbole bräuchten Texturen (nicht Teil des Pakets; keine neue Asset-Abhängigkeit). Ob und wie sich das Modell im Spiel drehen lässt (Animation), ist **ungeprüft**; die Logik arbeitet mit dem Aktivierungsereignis, nicht mit dem Drehen.
- **Activation-Text:** Feld **Activate Text Override** (Name im CK prüfen): `Touch` oder `Turn`.

### Platzierung
- **Wo:** Zelle `NHV_Q03_HollowfrostSpireCell`, Saal des Rätsels (A4.2, Raum 2).
- **Anordnung:** Ring oder Reihe, **nicht** in Lösungsreihenfolge. Vorschlag im Uhrzeigersinn: Blade, Frost, Silence, Poison. So verrät die Anordnung die Lösung nicht.
- **Abstände:** mindestens **250 Einheiten** zwischen den Säulenmitten, damit das Fadenkreuz eindeutig eine Säule trifft. Höhe Fußpunkt auf Bodenniveau (Taste F).
- **Kollision:** Die Basismodelle haben Kollision (Pillar-Mesh). **Prüfen:** im Spiel gegen alle vier Seiten laufen; kein Durchlaufen. Der Spieler soll nicht zwischen Säule und Wand eingeklemmt werden: **≥ 100 Einheiten Wandabstand**.
- **Refs:** Doppelklick → **EditorID** `NHV_Ref_Q03_PillarFrost`, `…PillarPoison`, `…PillarBlade`, `…PillarSilence`. **Persistent Reference** an (Script-Properties). Layer `NHV_Q03_Puzzle`. **Initially Disabled aus.**
- **Aktivator-Reihenfolge der vier Säulen** (für Script-Property `PillarRefs`, Namen **folgen nach Phase C**): Array-Index 0 Frost, 1 Poison, 2 Blade, 3 Silence. Wichtig: Die Reihenfolge der **Property-Einträge** ist die **Lösungsreihenfolge**, nicht die Platzierung.
- **Notiz-Spots:** Marker `NHV_Mk_Q03_NoteSpotFrost`, `…NoteSpotPoison`, `…NoteSpotBlade`, `…NoteSpotSilence` (vier `XMarkerHeading`, **Persistent**, Layer `NHV_Q03_Markers`), verteilt im Turm: ein Marker je Opfer-Notiz, nicht alle im selben Raum (Konzept: „verstreut“, „jede Stille ist ein Opfer“). Die Notiztexte schreibt Codex (F5); Items nach Phase C.

**Ergebnis:** vier Säulen im Saal, vier Notizplätze, EditorIDs für das Script.

## A6. Resonanzkammer-Zelle: Ward und Vorraum – Status: jetzt machbar – NEU ERSTELLEN

- **Zelle:** `NHV_Q03_ResonanceChamber`, Name `Resonance Chamber`, Interior.
- **Tür:** `NHV_Q03_ResonanceDoorInRef` (Gegentür zu `NHV_Q03_ResonanceDoorOutRef` in der Spire-Zelle); Paarung nach A2.
- **Aufbau:** Vorraum mit **Frostfire Ward** (ein Aktivator vor dem Durchgang zum Labor), dahinter der Resonanzraum, dahinter Labor (A7). Eine Zelle, drei Bereiche; Room Bounds (A10).
- **Ward-Activator `NHV_Act_Q03_FrostfireWard`:** NEU ERSTELLEN wie die Säulen (Duplicate eines skriptfreien Activators; Vorschlag: dasselbe Pillar-Duplikat, andere ID und Name `Frostfire Ward`). Platzieren als Ref `NHV_Ref_Q03_FrostfireWard`, **Persistent**, direkt vor dem Durchgang (Kollision: der Durchgang bleibt für den Spieler gesperrt, bis das Script ihn frei gibt; **Variante:** das Script deaktiviert die Ref, Initially Disabled **aus**).
- **Drei Routen, ein Übergang** (Development-Plan Schritt 5): Fragment, Gewalt, Geduld erfüllen dieselbe Abschlussvariable `NHV_Q03_Resonance` (Phase C). Räumlich nur: der Ward steht an **einer** Stelle, hinter ihm **ein** Durchgang. Marker `NHV_Mk_Q03_WardWaitSpot` (2–3 m vor dem Ward, für die Geduld-Route), Marker `NHV_Mk_Q03_WardFocusSpot` (neben dem Ward, Ablage des Fokusfragments).
- **Dressing:** Eis-/Frostfeuer-Dekor, Schalen, ein Sockel (Static) für das Fokusfragment. Ob der Sockel selbst ein Activator sein soll, hängt vom Phase-C-Entwurf ab (**offen**).

## A7. Nireldas Labor und Wandnische – Status: jetzt machbar – NEU ERSTELLEN

**Ort:** hinterer Bereich der Zelle `NHV_Q03_ResonanceChamber`. Dort spielen Joric-Beobachtung (Stage 40), Consent-Ledger (45), Prüfung (50), Korrespondenz (60), Wandnische (65).

- **Größe und Kampf:** Nireldas Prüfung kann in einen **Kampf** übergehen (Feuer-Battle-Mage, Feuerstrahlen, Wände, Explosionen; „enge Räume und Nähe von Verbündeten zwingen sie, ihre Meisterschaft nicht blind einzusetzen“). Deshalb: Labor etwa **10 × 12 m**, nicht größer, mit **mindestens zwei Deckungen** (Tisch, Regal, Säule) und freier Laufbahn um den Tisch. Ausweichrichtung für den Spieler. **Kein** Raum, in dem sie ihn aus 20 m verbrennt.
- **Möbel/Dressing:** Schreibtisch (Platz für Ledger und Whisperbane-Auftrag), Regale, ein Bett/Lager oder Bodenfläche für Joric (A8, Marker), Kerzen/Lichtquellen. Alles in Layer `NHV_Q03_Dressing`. Für Joric liegt **Bettrolle** `BedrollHay01STATIC` als reine Optik; ob ein Furniture-Bett für das „sterbende Liegen“ nötig ist, entscheidet Phase C. **Namen von Furniture-Betten nicht geprüft.**
- **Wandnische mit Container `NHV_Cont_Q03_DeadDrop` (F6):**
  - **Base NEU ERSTELLEN:** Object Window → **WorldObjects → Container** → Duplicate einer kleinen Kiste/eines Fasses (z. B. die Q01-Vorlage `MiscSackLargeFlat01_NoRespawn`, Model `Clutter\Containers\MiscSackLargeFlat01.nif`) → ID `NHV_Cont_Q03_DeadDrop`, Name `Hollow Panel` (Vorschlag; Respawn **aus**). **Inhalt leer lassen**: Gegenzeichen und Whisperbane-Auftrag legt Phase C per Script oder Generator hinein.
  - **Wand davor:** ein Wand-Static (gleiches Kit) als eigene Ref `NHV_Ref_Q03_FalseWall`, **Persistent**, **Initially Disabled aus**; das Script deaktiviert sie, wenn der Spieler die Wand findet. Dahinter ist die Nische (etwa 150 × 150 × 200 Einheiten) mit dem Container `NHV_Ref_Q03_DeadDrop` (**Persistent**).
  - Der Container ist ohne Script **erreichbar, wenn die Wand fehlt**. Es gibt keine Möglichkeit, ihn vorher zu sehen: Die Nische darf durch die Wandkollision nicht sichtbar sein (Wand blickdicht).
- **Ledger- und Auftragsspot:** `NHV_Mk_Q03_LedgerSpot` (Pult), `NHV_Mk_Q03_DeskSpot` (Korrespondenz). Beide **Persistent**.

## A8. Marker für Szenen und Prüfung – Status: jetzt machbar – NEU ERSTELLEN

Alle als **XMarkerHeading** (Object Window → WorldObjects → Static → `XMarkerHeading`, FormID `000034`, Model `MarkerXHeading.nif`, geprüft), **EditorID** wie unten, **Persistent Reference**, Layer `NHV_Q03_Markers`, **Z-Rotation** = Blickrichtung (Nase des Markers zeigt, wohin die Figur schaut). Höhe auf dem Boden (Taste F). Mit Navmesh unter dem Marker.

| EditorID | Zelle | Zweck | Position/Abstand |
|---|---|---|---|
| `NHV_Mk_Q03_ObserverPerch` | Spire | Nireldas Fernkommentar (Stage 30/35, Q3-04): Position, von der sie die Säulen sieht (Fenster, Balkon, Vorsprung) | mit Sicht auf die Säulen, aber nicht erreichbar (Höhe oder Geländer); **Ungeprüft:** ob sie dort physisch steht oder nur als Stimme gesprochen wird (Phase C) |
| `NHV_Mk_Q03_TrapPoint01` … `03` | Spire | spätere Fallenwirkung | 3 Stück entlang des Weges, ≥ 300 Einheiten Abstand |
| `NHV_Mk_Q03_JoricSpot` | Labor | Joric liegt | 150 Einheiten vom Pult; freie Kreisfläche r ≥ 100 |
| `NHV_Mk_Q03_NireldaObserveSpot` | Labor | Nirelda sitzt neben Joric | 100–150 Einheiten von `JoricSpot`, Blick auf Joric |
| `NHV_Mk_Q03_PlayerObserveSpot` | Labor | Spielerplatz bei der Beobachtung | 300–400 Einheiten von `JoricSpot`, mit Sicht auf beide |
| `NHV_Mk_Q03_ExamNireldaSpot` | Labor | Nireldas Platz in der Prüfung | 250–300 Einheiten gegenüber `ExamPlayerSpot` |
| `NHV_Mk_Q03_ExamPlayerSpot` | Labor | Spielerplatz in der Prüfung | frei, Rückzugsweg zur Tür |
| `NHV_Mk_Q03_YieldSpot` | Labor | Nirelda, wenn sie sich bei 25 % ergibt (E-Prüfung, Q3-10) | freie Fläche, kein Möbelstück darunter |
| `NHV_Mk_Q03_LedgerSpot` | Labor | Consent-Ledger (Pult) | s. A7 |
| `NHV_Mk_Q03_DeskSpot` | Labor | Korrespondenz, Whisperbane-Auftrag | s. A7 |
| `NHV_Mk_Q03_DeadDropSpot` | Labor | Wandnische | in der Nische |
| `NHV_Mk_Q03_ResonanceExitSpot` | Resonanzkammer | Ankunft hinter dem Ward | nach Durchgang |
| `NHV_Mk_Q03_WardWaitSpot`, `NHV_Mk_Q03_WardFocusSpot` | Resonanzkammer | Ward-Routen | A6 |
| `NHV_Mk_Q03_WaystationSurvivorSpot`, `…PackSpot`, `…TokenSpot` | Wegstation | A3 | je 200 Einheiten Abstand |
| `NHV_Mk_Q03_NoteSpotFrost` … `Silence` | Spire | Notiz-Spots | A5 |
| `NHV_Mk_Q03_SelveniSpot` | `WinterholdCollegeArcanaeum` (Vanilla, `013810`, E16-Kopie) | Selveni | siehe A13/F4 |
| `NHV_Mk_Q03_ThyraSpot` | Ort offen (F4) | Thyra | siehe A13/F4 |
| `NHV_Mk_Q03_ArcanumNireldaSpot` | `NHV_DeepSanctuaryCell` | Nirelda sandboxt (Studierecke) | A12 |

**Hinweis:** Lehre 11 (kein `cqf`): Alle Szenenziele sind per Marker gelöst, nicht per Konsole. Lehre 7: Alle Marker prüfen, dass sie auf realem Boden stehen (Fehleranalyse Q00: Memorial-Marker auf Z −236 lag unter dem Navmesh).

## A9. Kartenmarker – Status: jetzt machbar – NEU ERSTELLEN

**Winterhold selbst:** der Vanilla-Kartenmarker bleibt unangetastet. **NUR KONTROLLIEREN:** Map-Table-Menü (Button „Winterhold“, Index 1) braucht keine neue Ref. Die Property `Q03` des Map-Table-Scripts wird erst in Teil B gesetzt.

**Marker für Spire und Wegstation** (Muster wie `NHV_MapMk_Q01_Watchpost`, Q01-Anleitung Abschnitt 4 Schritt 6):
- **Wo:** Außenzelle des Turms (A1), Object Window → WorldObjects → Static → `MapMarker` → ins Render Window am Turm.
- **Ref-Dialog:** EditorID `NHV_MapMk_Q03_Spire`; **Persistent Reference** an; **Initially Disabled** an; **Name** `Hollowfrost Spire`; **Type** `Ruin` (oder `Fort`/`Camp`, Auswahl im CK prüfen); **Visible** an; **Can Travel To** aus (kein Schnellreise-Ziel).
- Zweiter Marker an der Wegstation (Außenzelle A3): `NHV_MapMk_Q03_Waystation`, Name `Abandoned Waystation`, Type `Camp`/`Ruin`, gleiche Flags.
- Beide bleiben bis zum Script-Aufruf unsichtbar (Stage 20: Spire, Stage 25: Wegstation, laut Draft-Knoten `tower`, `road`). Die Zuordnung der Properties folgt nach Phase C (`<Property-Name folgt nach Phase C>`).

## A10. Beleuchtung, Encounter Zone, Location, Room Bounds – Status: jetzt machbar – NEU ERSTELLEN

### Beleuchtung
- **Wo:** Zelle öffnen → **Cell → Edit Cell** (Name im CK prüfen; Reiter **Lighting**). Pro Zelle: **Lighting Template** wählen oder neu anlegen (Object Window → **World Data → Lighting Template**, Name prüfen; Template **duplizieren**, Original nicht ändern) und in der Zelle aktivieren; **Inherit**-Haken (Ambient, Directional, Fog) wie nötig.
- **Vorschlag:** `NHV_Q03_LT_Spire` (kühles Blau, wenig Ambient), `NHV_Q03_LT_Lab` (wärmeres Orange von Kerzen, dunklere Ecken für Deckung), `NHV_Q03_LT_Waystation` (fast dunkel, nur Restglut). **Lichtquellen** (Light-Statics/Fackeln) als Refs setzen; kein Vanilla-Script-Licht. Layer `NHV_Q03_Lights`.
- **Occlusion/Lighting-Template-Zusammenhang:** Ein **Lighting Template** ersetzt Einzelwerte (ck-guide); **Room Bounds** begrenzen die Occlusion und das Rendering; ohne sie rendert die Resonanzkammer-Zelle (drei Bereiche) alles gleichzeitig.

### Room Bounds (Spire-Zelle und Resonanzkammer)
- **Wo:** Object Window → WorldObjects → Static/Collection, Filter `Room` (Namen **nicht** geprüft; das CK bietet RoomMarker und PortalMarker). Platzieren, skalieren, umschließen.
- **Was:** Spire: Eingangshalle, Saal, Gang. Resonanzkammer: Vorraum, Resonanzraum, Labor. Portale an den Durchgängen.
- **Hinweis:** Wenn Room Bounds im CK unklar sind, melde den Zustand; für drei kleine Räume ist der Ausfall nicht kritisch, aber Performance und Occlusion fehlen dann.

### Encounter Zone
- **Wo:** Object Window → **World Data → Encounter Zone** → Rechtsklick → New.
- **Was:** EditorID `NHV_Q03_SpireEZ`, Haken **Never Resets** (Muster `NHV_Q01_ReedbedEZ`, `NHV_DeepSanctuaryZone`). Zuordnung im Cell-Dialog (Feld **Encounter Zone**) für Spire-Zelle, Resonanzkammer und Wegstation.
- **Ergebnis:** Zellen respawnen nicht, Inhalte bleiben, wie sie gelassen wurden.

### Location (optional, kosmetisch)
- **Wo:** Object Window → World Data → Location → New. `NHV_Q03_HollowfrostSpireLocation`, Name `Hollowfrost Spire`, Parent: die Winterhold-Hold-Location (Name im CK prüfen, Filter `Winterhold`), Keyword `LocTypeDungeon`/`LocTypeMageTower` (Namen **nicht geprüft**). Zuweisung nur im Cell-Dialog. **Kein Script nutzt sie.** Ebenso `NHV_Q03_WaystationLocation`.

## A11. Navmesh (Abdeckung für Kämpfe) – Status: jetzt machbar – NEU ERSTELLEN

**Wichtig:** Navmesh immer **zuletzt**, nach finaler Möbel- und Türposition. Vor jedem Navmesh-Schritt ESP-Backup. Navmesh ist die Hauptfehlerquelle laut ck-guide.

| Zelle | Abdeckung |
|---|---|
| Spire-Zelle | Eingangshalle, Gang, Saal; **alle** Bereiche um die Säulen (Spieler läuft um jede Säule, NPCs müssen dort durchkommen). Navmesh um die Säulen **mit ≥ 100 Einheiten Abstand** zur Kollision. |
| Resonanzkammer | Vorraum, Durchgang hinter dem Ward, Labor **mit kompletter Bodenfläche** (Kampf Nirelda: sie braucht Wege zu Deckung und Ausweichen). Keine Navmesh-Inseln. |
| Wegstation | gesamter Raum, Spots erreichbar (Überlebender geht aus dem Sitzen auf, Spieler läuft zu den drei Spots). |
| Exterior (Spire/Wegstation) | **nur prüfen**: Das Vanilla-Navmesh reicht bis zur Tür? Wenn nicht, Änderung **vorher melden** (Override eines Vanilla-NAVM ist eine Ausnahme von Regel 1 und wäre ein neuer E16-Eintrag). |

- **Tür-Navmesh:** An jeder Ladetür das Navmesh bis an die Tür ziehen und die Tür-Dreiecke **verlinken** (Navmesh → Door-Link bzw. beim Finalisieren; Namen im CK prüfen). Ladetüren brauchen bei NPC-Durchgang beidseitig verlinkte Dreiecke (E25-Lehre: ein Spielerteleport beweist keinen NPC-Weg).
- **Finalisieren:** Navmesh → Finalize Cell (Namen prüfen). Danach **Cell neu öffnen** und den Zustand ansehen (Navmesh-Ansicht, Dreiecke überall grün/begehbar; kritische Kanten rot). Nach dem Speichern **CK neu öffnen** und prüfen, ob NAVM/NAVI Referenzen für die Türen vorhanden sind (Q00-Lehre: nicht auf bloße Erfolgsmeldung verlassen).
- **Kampfabdeckung:** Labor von Wand zu Wand abdecken; **keine Löcher** hinter Möbeln (Nirelda wirkt sonst feststeckend). Mindestens ein Rückzugsweg zur Tür.

## A12. Arcanum-Grundausbau in der Deep Sanctuary – Status: jetzt machbar – NEU ERSTELLEN

ROADMAP M2.3: „Grundausbau Arcanum“. Konzept: „The Arcanum | Arcane Enchanter, Bücherregale, Nireldas Studierecke“. Nirelda zieht dort bei Recruit ein; der Raum soll erst danach genutzt werden. Details (Flügel, Zugang) sind im Konzept nicht festgelegt; **offen**: Raum in `NHV_DeepSanctuaryCell` an welcher Stelle?

- **Wo:** `NHV_DeepSanctuaryCell` (eigene Zelle, keine Vanilla-Zelle, keine E16-Kopie nötig).
- **Was (NEU ERSTELLEN, alle Layer `NHV_Q03_Dressing`):**
  - **Arcane Enchanter:** Object Window → WorldObjects → **Furniture** → `CraftingEnchantingWorkbench` (`0BAD0D`, Name „Arcane Enchanter“, Model `Furniture\EnchantingWorkbench.nif`, **geprüft**; alternativ `CraftingEnchantingWorkbenchTabletop` `0D5501`). Platzieren, nicht duplizieren. Hinweis: Das Platzieren eines Vanilla-Records in einer **eigenen** Zelle verändert nichts.
  - **Bücherregale und Studierecke:** Regale/Schreibtisch aus dem Deep-Sanctuary-Kit (Markarth, siehe `docs/ck/M1.3-Deep-Sanctuary-Asset-Inventar.md`).
  - Marker `NHV_Mk_Q03_ArcanumNireldaSpot` (Nirelda sandboxt dort).
- **Sperre bis zum Recruit:** Die Objekte als **Initially Disabled**, per Enable-Parent-Marker oder Script in Phase C freischalten. Ohne Phase-C-Entwurf **nur den Raum bauen**; die Sperre kommt später. (Property-Name folgt nach Phase C.)
- **Navmesh/Licht:** wie A10/A11 für den neuen Raum der Deep Sanctuary.

## A13. NPC-Standorte in Vanilla-Zellen (Selveni, Thyra) – Status: jetzt machbar, **erst nach Entscheidung F4**

- **Selveni (Arcanaeum, E16-Kopie):** Vanilla-Zelle `WinterholdCollegeArcanaeum` (`013810`, Name „The Arcanaeum“, geprüft). Marker `NHV_Mk_Q03_SelveniSpot` (Persistent) neben ein Lesepult/Regal, sitz- oder stehtauglich, **nicht** an dem Platz von Urag oder bestehenden Quest-NPCs. **Ändert nichts an Vanilla-Refs**, erzeugt aber eine Zellkopie (E16 → Abschnitt 12). Nach der Aktion Vanilla-Zelle in xEdit auf versehentliche Änderungen prüfen lassen.
- **Thyra (Ort offen, F4):** Vorschlag `WinterholdTheFrozenHearth` (`013814`, Name „The Frozen Hearth“, geprüft) oder eine Außenzelle in Winterhold. Marker `NHV_Mk_Q03_ThyraSpot`. Gleiches E16-Verfahren.
- **Urag und Tolfdir:** **keine Platzierung.** Beide sind Vanilla (`UraggroShub` `01C193`, `Tolfdir` `01C19E`, geprüft); sie kommen über Aliase in der Q03-Quest (Teil B). **Keine Vanilla-NPC-Records ändern.**

## A14. Gesichtsentwurf und FaceGen (vorbereitend) – Status: Entwurf jetzt, Bau **erst nach Phase C**

NPC-Basen entstehen im Generator (Phase C). FaceGen braucht die fertige NPC-Basis (Voice, Race, Outfit). **Jetzt machbar:** Gesichtsentwürfe festlegen (Rasse, Haar, Augen, Alter, Narben) für:

| Figur | Rasse | Hinweise (laut `Characters.md`) |
|---|---|---|
| Nirelda Aurantil | **Altmer** (Konzept) | brillant, arrogant, sachlich; Altmer-Gesicht; Feuer-Battle-Mage-Look |
| Selveni | offen (F8) | College-Lehrling von damals, vorsichtig, angespannt |
| Thyra | offen (F8) | Witwe, trauernd |
| Straßenüberlebender | offen (F8) | namenlos, erschöpft, ängstlich |
| Joric | offen (F8) | sterbender Reisender |

**Weg 1 (empfohlen): Warten.** Der Generator legt die NPC-Basen an; du bearbeitest sie danach (Teil B, B2). Kein Konfliktrisiko mit dem Generator.
**Weg 2 (nur nach Absprache mit Claude):** Du legst die Basen im CK selbst an; Claude übernimmt sie per FormID im Generator, statt sie zu löschen (Lehre 1). Erst melden, dann bauen.

---

# TEIL B – erst nach Phase C

Die folgenden Schritte laufen, wenn der Generator die Q03-Records ins ESP geschrieben hat und Claude meldet: „Phase C fertig, ESP bereit.“ Sie sind vorläufig. Namen und Werte stehen erst nach Phase C fest.

## B1. Quest und Aliase kontrollieren – Status: erst nach Phase C – NUR KONTROLLIEREN

- **Wo:** Object Window → Character → Quest (Kategorie „Quest“) → `NHV_Q03_TheScholarsSin` (`<FormID folgt nach Phase C>`) → Doppelklick → Reiter **Quest Aliases**.
- **Prüfen:**
  - Aliase für Nirelda, Selveni, Thyra, Überlebender, Joric, Urag, Tolfdir (Vanilla: nur Alias, kein Record-Eingriff). Vanilla-Aliase **Optional**, Fill-Type **Specific Reference** (`UraggroShub` `01C193`, `Tolfdir` `01C19E`).
  - Aliase auf eigene NPCs: **Unique Actor** bzw. Ref, je nach Generator-Vorgabe.
  - **Start Game Enabled aus.**
  - **Veyra-Alias ohne Follow-Package** (E51: sie begleitet nicht).
  - Package-Reihenfolge in den Aliasen: Briefing/Home-Packages oben; Grenzen als Tabelle prüfen (Lehre 7).
- **Ergebnis:** Alle Aliase vorhanden; keine Vanilla-Records geändert.

## B2. NPC-Basen, VoiceTypes, FaceGen – Status: erst nach Phase C – NUR KONTROLLIEREN / ÄNDERN (Gesicht)

- **Wo:** Object Window → Actors → Actor (Character → NPC, Filter `NHV_Q03_`), Doppelklick auf jeden NPC `<FormID folgt nach Phase C>`.
- **Je NPC kontrollieren:** Race (nach A14), **Voice Type** (eigene `NHV_Voice…`, nicht Vanilla; siehe `docs/CONVENTIONS.md`), Essential/Protected laut E02 und Lehre 5 (**nie Ghost**), Level/Class (Nirelda: Destruction-Magier, **ändern**), Outfit (**ändern** nach Entwurf).
- **Gesicht ändern:** Reiter **Face** bzw. Traits (Namen im CK prüfen). Dann **FaceGen exportieren**: NPC im Object Window markieren, **Strg+F4** (CK-Standard). Ohne FaceGen erscheint das Gesicht dunkel.
- **Joric:** **keine** Essential-/Ghost-Tricks; er ist sterbend (Bleedout-Zustand per Script/Package, nicht per Flag).
- **Nirelda im Kampf:** Kampfstil, Magicka, Spells (Feuerstrahl, Feuerwand, Explosion), Yield bei 25 %: im Script (Phase C), im CK nur Spell-Liste prüfen.

## B3. Quest-Script und Properties – Status: erst nach Phase C – NUR KONTROLLIEREN

- **Wo:** Quest → Reiter **Scripts** → `NHV_Q03Script` → **Properties**. Jede Property → Edit Value.
- **Tabelle:** Property-Namen stehen erst nach Phase C fest. Zielwerte aus Teil A:

| Property (Name folgt) | Typ | Zielwert |
|---|---|---|
| Säulen-Array (Lösungsreihenfolge) | ObjectReference-Array | `NHV_Ref_Q03_PillarFrost`, `…PillarPoison`, `…PillarBlade`, `…PillarSilence` (in dieser Reihenfolge) |
| Ward | ObjectReference | `NHV_Ref_Q03_FrostfireWard` |
| Resonanztür | ObjectReference | `NHV_Q03_ResonanceDoorOutRef` |
| Spire-Kartenmarker | ObjectReference | `NHV_MapMk_Q03_Spire` |
| Wegstation-Kartenmarker | ObjectReference | `NHV_MapMk_Q03_Waystation` |
| Joric-/Nirelda-/Prüfungs-Spots | ObjectReference | Marker aus A8 |
| Wandnische | ObjectReference | `NHV_Ref_Q03_FalseWall`, `NHV_Ref_Q03_DeadDrop` |
| Globals (alle `NHV_Q03_…`) | GlobalVariable | gleichnamiger Global |

- **Map Table:** Object Window → Activator → `NHV_Act_MapTable` (`005EC5`) bzw. die platzierte Ref (Weg B der Map-Table-Anleitung) → Script `NHV_MapTableScript` → Property **`Q03`** → `NHV_Q03_TheScholarsSin` setzen. **ÄNDERN** (bisher leer). `Q04`/`Q05` leer lassen.
- **Ergebnis:** Alle Properties gefüllt; keine leere Property (häufigste Fehlerquelle).

## B4. Szenen, Packages, Dialog – Status: erst nach Phase C – NUR KONTROLLIEREN

- **Szenen:** Beobachtung (Stage 40), Fernkommentar (30/35), Yield, Home (Arcanum). Beteiligte Actors vor Szenenstart per Script auf Marker (A8) bewegen; „Interruptible“ bewusst; Fallback-Stage angeben.
- **Packages:** Alias-Packages, nicht am Vanilla-NPC. Prüfen: Stage-Grenzen (Lehre 7, Tabelle), keine Follow-Packages für Veyra (E51), Follow-Package erst nach dem Gespräch (Lehre 8).
- **Dialog:** Topics aus `Q03.csv`; Speaker-Conditions (`GetIsID`, `GetIsVoiceType`); Pflichtgespräche haben Hub-Rückfall (Lehre 3).

## B5. Items, Bücher, Platzierung – Status: erst nach Phase C – ÄNDERN (Platzierung)

Die Item-Records stehen erst nach Phase C im ESP. **Dann** in den Zellen **auf die Marker** aus A8 setzen:

| Item (Name folgt nach Phase C) | Quelle | Ort |
|---|---|---|
| College Margin Copy (`NHV_Q03_015_6150`) | `Books.csv`, Stage 15 | im Besitz von Selveni (Dialog), **nicht** platziert (Spieler wählt „nehmen“) |
| Burned Travel Pack, Traveler's Token | `Items-and-Evidence.md` | `NHV_Mk_Q03_WaystationPackSpot`, `…TokenSpot` |
| Vier Rätselnotizen (Texte offen, F5) | Codex | `NHV_Mk_Q03_NoteSpot…` |
| Frostfire Ward Note (`NHV_Q03_035_6350`) | `Books.csv` | unter/neben dem Ward-Sockel, `NHV_Mk_Q03_WardFocusSpot` |
| Broken Focus Fragment | Draft | Besitz aus Selvenis Kopie bzw. Sockel; Q3-08 offen |
| Consent Ledger | Draft | `NHV_Mk_Q03_LedgerSpot` |
| Whisperbane-Auftrag (`NHV_Q03_060_6000`), Countermark Seal (`NHV_Q03_065_6650`) | `Books.csv` | **Initially Disabled**, auf `NHV_Mk_Q03_DeskSpot` bzw. in `NHV_Ref_Q03_DeadDrop`; Aktivierung nach der Prüfung (Development-Plan Schritt 7) |
| Abschiedsbrief (Release), Stab (College-Übergabe), Circlet of the Last Breath (Recruit) | Konzept (`konzept.md:982`) | **nicht platziert**, per Script/Dialog vergeben (Phase C) |

- **Wo:** Object Window → Items → Book/Misc/Weapon/Armor → Filter nach EditorID → ins Render Window auf den Marker ziehen.
- **Ref-Flags:** **Persistent** nur, wenn ein Script-Property sie braucht. **Initially Disabled** laut Tabelle.

## B6. Aktivierungsreihenfolge und Collision der Säulen im Spiel – Status: erst nach Phase C – NUR KONTROLLIEREN

Prüfen, sobald das Script existiert:
- Richtige Reihenfolge (Frost, Poison, Blade, Silence) schaltet den Gang frei; jede andere Reihenfolge setzt das Zustandsarray zurück.
- Aktivierung einer Säule zweimal hintereinander: kein Doppelzählen.
- Beenden der Zelle mitten im Rätsel (Speichern/Laden): Zustand bleibt konsistent oder wird sauber zurückgesetzt.

---

## 12. E16-Einträge für `docs/ARCHITECTURE.md` (Vorlage für Claude)

Nach deiner Rückmeldung trägt Claude diese Zeilen in die Tabelle „Zell-Kopien (E16)“ ein. Du füllst die Spalte „deine Angabe“.

| Vanilla-Zelle | Grund | deine Angabe |
|---|---|---|
| Tamriel-Außenzelle (X/Y) Spire | Q03: Spire-Außenhülle, Ladetür `NHV_Q03_SpireDoorExtRef`, Kartenmarker `NHV_MapMk_Q03_Spire`, Trümmer | Zelle: ____ |
| Tamriel-Außenzelle (X/Y) Wegstation | Q03: Außentür `NHV_Q03_WaystationDoorExtRef`, Kartenmarker `NHV_MapMk_Q03_Waystation` | Zelle: ____ |
| `WinterholdCollegeArcanaeum` (`013810`) | Q03: `NHV_Mk_Q03_SelveniSpot` (nach F4) | ja / nein |
| Winterhold-Zelle Thyra (nach F4) | Q03: `NHV_Mk_Q03_ThyraSpot` | Zelle: ____ |
| Vanilla-NAVM (nur falls nötig, A11) | Navmesh-Override am Türvorplatz | ja / nein, Begründung |
| Vom CK automatisch angelegte `LocationRefTypeReferencesAdded`-Einträge | wie bei Q01 | prüfen und melden |

---

## 13. Speichern und Rückmeldeformat

1. **File → Save**, CK schließen. Kein Spielstart, bevor das ESP gesichert ist.
2. Claude macht: `tools\sync_dev.ps1 -Direction FromDev`, danach **`powershell -File tools\plugin_text.ps1 -Direction ToText`** (Befehl aus `docs/ENVIRONMENT.md`).
3. **Rückmeldung an Claude** (copy-paste):

```
Q03 im CK fertig (Teil A / Teil B)
Zellen:
- Spire Außen: Tamriel (X/Y) = ____, Tür-Ref ____ (FormID ____)
- Wegstation Außen: Tamriel (X/Y) = ____, Tür-Ref ____
- NHV_Q03_HollowfrostSpireCell, NHV_Q03_ResonanceChamber, NHV_Q03_WaystationCell: angelegt ja/nein
- Vanilla-Zellen mit neuen Refs (E16): ____
Türen: beide Richtungen getestet (Hinweg/Rückweg) ja/nein; Auffälligkeiten ____
Navmesh: finalisiert in allen drei Zellen ja/nein; Löcher/Inseln ____
Säulen: Refs ____ / Kollision geprüft ja/nein
Kartenmarker: ja/nein
Offene Punkte / Abweichungen ____
```

---

## 14. Test-Hinweise (ohne `cqf`)

Alle Tests mit Dev-Kopie und frischem Save (nicht vom Q02-Fortschritt abhängig). Teil A kann **ohne Quest** getestet werden:

| Nr. | Aktion | Erwartung |
|---|---|---|
| T1 | `coc NHV_Q03_WaystationCell` (EditorID der Innenzelle, geprüft nach Anlage) | Spieler landet in der Zelle; kein Absturz; Raum komplett ausgeleuchtet |
| T2 | Durch `NHV_Q03_WaystationDoorIntRef` hinaus, danach wieder hinein (mit `coc` ggf. von außen: Außenzelle per `player.moveto <FormID der Außentür-Ref>`; FormID nach Anlage aus dem Ref-Dialog; Slot im Spiel prüfen, bei den früheren Tests Slot 06) | Rückweg landet **vor** der Tür auf der begehbaren Seite, nicht in der Wand oder auf der falschen Seite |
| T3 | Dasselbe für Spire-Tür und Resonanztür (Hinweg und Rückweg) | wie T2 |
| T4 | In der Spire-Zelle um alle vier Säulen laufen, jede Aktivierung ansehen (Name, Hinweis „Touch/Turn“) | Name erscheint, kein Durchlaufen, keine Zielverwechslung |
| T5 | Labor und Vorraum abgehen; Nische erreichbar? (ohne Script ist die Wand sichtbar) | Navmesh-Wege lückenlos; Wand blickdicht |
| T6 | Vanilla-NPC testweise in die Resonanzkammer setzen (`player.placeatme <FormID>`; Veyra `000817` laut M1.2) und beobachten, ob sie sich durch das Labor bewegt | keine Inseln; **ungeprüft**, ob sie dort ohne Package läuft |
| T7 | Kartenmarker: ohne Script-Freigabe auf der Karte **nicht** sichtbar | Initially Disabled wirkt |
| T8 | Nach dem Speichern: ESP in xEdit auf Vanilla-Overrides prüfen (Claude/Entwickler) | nur erwartete E16-Zellkopien |

**Nach Phase C zusätzlich:** Debug-Topics oder MCM-Einträge (kein `cqf`, Lehre 11) für: Q03 starten, Stages 15/25/35/45 setzen, Säulen-Zustand zurücksetzen, Yield auslösen. Konsole nur `setstage NHV_Q03_TheScholarsSin <n>` und `getstage`/`sqv`, wenn der Entwickler sie verwenden kann (`prid 06xxxxxx` für Refs).

Papyrus-Log: nach Phase C Zeilen mit `[NHV]`; zurückmelden: `Q03: …`-Fehlerzeilen, ungesetzte Properties.

**Nichts in dieser Datei ist ingame bestätigt.** Der Eintrag in `docs/ROADMAP.md` bleibt „Test“ bzw. „offen“, bis du nach dem Ingame-Test „fertig“ setzt.

---

## 15. Checkliste vor dem Speichern

**Teil A**
- [ ] ESP-Backup vor Navmesh gemacht
- [ ] Layer angelegt, Objekte zugewiesen
- [ ] Tamriel-Zelle für Spire gewählt (Koordinate notiert); Wegstation-Außenzelle gewählt
- [ ] Drei Innenzellen angelegt (`NHV_Q03_HollowfrostSpireCell`, `NHV_Q03_ResonanceChamber`, `NHV_Q03_WaystationCell`)
- [ ] Sechs Tür-Basen und sechs Tür-Refs, **jeder** Teleport-Ankunftspunkt gesetzt (A2)
- [ ] Vier Säulen-Activators (ohne Script) und vier Refs mit EditorID **und Persistent**, Abstand ≥ 250
- [ ] Ward-Activator, Wandnische, `NHV_Cont_Q03_DeadDrop` (Respawn aus)
- [ ] Alle `NHV_Mk_Q03_*`-Marker (A8) mit EditorID, Persistent, auf realem Boden
- [ ] Kartenmarker Spire/Wegstation: Initially Disabled, Visible, Can Travel To aus
- [ ] Beleuchtung je Zelle, Room Bounds, Encounter Zone (Never Resets)
- [ ] Navmesh in allen drei Zellen finalisiert, Tür-Dreiecke verlinkt
- [ ] Arcanum-Raum gebaut (A12)
- [ ] Keine Vanilla-Records verändert (Duplikate statt Originale)

**Teil B** (nach Phase C)
- [ ] Alle Aliase, Properties und Map-Table-Property `Q03` gesetzt (B3)
- [ ] NPCs: Voice, FaceGen, Race (B2)
- [ ] Items auf Marker, Whisperbane/Countermark Initially Disabled (B5)
- [ ] Szenen/Packages geprüft (B4)

## 16. Bekannte Einschränkungen und Ungeprüftes

- **Alle Koordinaten** der Zellen sind offen; Ortswahl liegt bei dir.
- **Ungeprüft:** Namen im CK-Menü (Layers, Navmesh, Room Bounds, Lighting Template, Teleport-Reiter).
- **Ungeprüft:** Drehbarkeit der Pillar-Meshes (Animation); Support für Frostrunen als Vanilla-Trap (F9).
- **Ungeprüft:** Eignung der Winterhold-Tower-Kitteile (`WinterholdTowerInt*`) für einen kompletten Innenraum.
- **Noch offen im Entwurf:** College-Übergabe (F7), Pfad „falscher Boden/Wand“ (F6), Stage-Nummern ohne Rücksprung (Q3-05, Phase C), Arch-Mage-Abfrage (Q3-02, Phase C).
- Ingame-Verhalten kennt Claude nicht; Beobachtungen aus dem Papyrus-Log und deiner Beschreibung.
