# CK-3: Nur Neu erstellen (Q00, Q01, Q02)

Stand: 02.10.2026 (Fassung 2, Aufteilung der Datei `Q00-Q02-CK-Anleitung-Final.md`). **Nichts hiervon ist ingame getestet.** Diese Anleitung enthält nur Aufgaben vom Typ **N = NEU ERSTELLEN**: Der Record oder die Ref fehlt im ESP. Werte an vorhandenen Records: `CK-2-Nur-Aendern.md`. Kontrollen: `CK-1-Nur-Kontrollieren.md`. Einstieg, Reihenfolge, Grundgriffe im CK, Fragen: `README-CK-Anleitungen.md`.

**Wie sicher ist was?** „Laut Export“ = aus `plugin-text/` nachgelesen. **(geprüft)** = über `housecarl_records` gegen `Skyrim.esm` geprüft. **(im CK prüfen)** = nicht prüfbar. Zeigt dein CK etwas anderes, melde, was du siehst.

## Einstieg und Voraussetzung (E17, Ein-Schreiber-Regel)

1. Das ESP wurde von Claude aus dem Repo-Stand geschrieben (`tools\plugin_text.ps1 -Direction ToPlugin`) und per `tools\sync_dev.ps1 -Direction ToDev -IncludeEsp` in die Dev-Kopie gelegt. Das CK läuft aus `C:\Dev\brotherhood-devenv\SkyrimSE-Dev`. Starte es erst nach Claudes Meldung „ESP geschrieben und synchronisiert“ (CK-1 K-ALL-01 bis K-ALL-03). Ohne den Sync fehlen dir die Phase-B-Records (Q02 Enhanced, Pakete 0xAF50–0xAF63, Q01-Pakete 0xAD00–0xAD20), und Nachträge gehen verloren.
2. **Ein Schreiber am ESP (E17):** CK und Claude nie gleichzeitig.
3. **Vor dem Navmesh-Abschnitt (N-Q02-03) ein ESP-Backup** (Kopie von `NightsHarvest.esp` mit Datum).
4. **Keine Vanilla-Records ändern** (Regel 1). Neue Objekte bekommen das Präfix `NHV_`. Vanilla-Basisobjekte nur **duplizieren** (Rechtsklick im Object Window, Duplicate, sofort EditorID ändern; nie das Original speichern). Jede neue Referenz in einer Vanilla-Zelle erzeugt eine Zell-Kopie (E16-Ausnahme; Claude trägt sie nach deiner Meldung in `docs/ARCHITECTURE.md` nach; offen ist dort weiterhin `WindhelmDocksExterior01` 00B4B9, Q2-28).
5. Keine neuen harten Abhängigkeiten. Alles hier benutzt nur `Skyrim.esm`/`Update.esm`.
6. **Persistent (korrigiert 02.10.2026):** Den Haken „Persistent“ gibt es im CK an **Charakter-Refs nicht**. Er ist bei allen **Enforcer- und Kurier-Refs gestrichen**. Bei **Nicht-Charakter-Refs** (Marker, Betten, Items, Türen) steht er in dieser Anleitung weiterhin dabei, mit dem Zusatz: Ist der Haken im Ref-Dialog nicht vorhanden, weglassen und melden. Wo ein Skript eine Charakter-Ref braucht, hängt die Erreichbarkeit an Property und Alias (siehe CK-1 K-Q02-07, CK-2 Ä-Q02-05).
7. Zwischenspeichern (Strg+S) erwünscht; Abschluss nach CK-2 in `CK-1` **K-ALL-07**.

## Übersichtstabelle

Koordinaten der vorhandenen Q02-Refs siehe Abschnitt „Orientierung“ unter Q02.

| Neue ID | Quest | Ort | Prio | Aufwand | Kurzbeschreibung |
|---|---|---|---|---|---|
| N-Q00-01 | Q00 | `NHV_DeepSanctuaryCell` | P3 | mehrere Tage | Fünf Räume, Room Bounds, Portale, Enable-Parents (Teile b, c, d von C5) |
| N-Q01-01 | Q01 | 5 Orte | P2 | 1–2 h | Betten B1–B5 |
| N-Q01-02 | Q01 | Steg, Lager, Küche, Hof | P3 | 1–2 h | Möbel N1–N4 |
| N-Q02-01 | Q02 | Windhelm Docks außen + neue Innenzelle | P1 | 2–3 h | Tidehouse-Zelle mit Türen |
| N-Q02-02 | Q02 | Tidehouse innen | P1 | 1–2 h | 2 Enforcer, Ledger, Möbel, Licht |
| N-Q02-03 | Q02 | Tidehouse innen | P1 | 1 h | Navmesh zeichnen, finalisieren |
| N-Q02-04 | Q02 | Docks außen | P1 | 20 min | Salzplatz-Marker |
| N-Q02-05 | Q02 | Docks außen | P1 | 45 min | 2–3 Enforcer, Messer, Sluice Token |
| N-Q02-06 | Q02 | Kontor | P1 | 30 min | Kurier-Ref (disabled), Imperial Seal |
| N-Q02-07 | Q02 | Kontor | P3 | 15 min | Chiffre-Schlüsselbuch |
| N-Q02-08 | Q02 | Docks, Hollow, Kontor | P2 | 45 min | Drei Betten |
| N-Q02-09 | Q02 | Docks, Kontor | P3 | 45 min | Idle-Möbel und Schreibtisch |
| N-Q02-10 | Q02 | Docks außen | P3 | 10 min | Haldor-Rückkehr-Marker (optional) |

Anzahl: 13 Aufgaben (Q00 1, Q01 2, Q02 10). Zuordnung alt zu neu: Tabelle in `CK-1-Nur-Kontrollieren.md`. **Empfohlene Reihenfolge innerhalb Q02 (Test freischalten):** N-Q02-01, N-Q02-02, N-Q02-04, N-Q02-05, N-Q02-06, N-Q02-03; danach CK-2 Ä-Q02-05 (Properties). Alles andere ist für den ersten Q02-Durchlauf verzichtbar (Fallbacks im Script, siehe „Ohne diese Aufgabe“ bei den Aufgaben).

---

## Q00

### N-Q00-01: Deep Sanctuary Stufe 1 (M1.3): Räume, Room Bounds, Enable-Parents (alt C5, Teile b, c, d, P3)

**Befund laut Export:** `NHV_DeepSanctuaryCell` (001342, „Deep Sanctuary“) ist ein Duplikat der `MarkarthTreasuryHouse`, 648 platzierte Refs, 19 NHV-Refs (Eingangs-/Memorial-Marker, Plaketten, Lucien, Map Table, Kitchen-Spot, Sings-Home-Marker), Location `NHV_DeepSanctuaryLocation` (000DD3), Lighting-Template `0D7B14`, Navmesh vorhanden. **Nicht im Export:** Room Bounds, Portale, Enable-Parent-Marker (`NHV_Mk_<Raum>_Ruined/_Furnished`). Q00 selbst läuft laut PROGRESS auch ohne diese Ausbaustufe.
**Wo und Was:** vollständig in `docs/ck/M1.3-Deep-Sanctuary-Stufe1.md` (Schritte 1–7) und `docs/ck/M1.3-Deep-Sanctuary-Asset-Inventar.md` (Objektlisten; exakte Vanilla-EditorIDs und Meshpfade in `docs/ck/M1.3-Deep-Sanctuary-Asset-Records.csv`, am 02.10. read-only aus `Skyrim.esm` ausgewertet). **Nicht neu schreiben, dort nacharbeiten.** Kurzfassung der Teilaufgaben:
| Teil | Typ | Inhalt |
|---|---|---|
| b | N | Fünf Räume: Hall of Whispers, Ledger Room, Shrine of the Void, Memorial Wall, Training Hall (laut Stufe1-Anleitung; **Initiates' Dormitory ist Finale-Scope**) |
| c | N | **Room Bounds** je Raum (fünf), Portale bei mehrräumigen Abschnitten |
| d | N | Enable-Parent-Marker je Raum (`…_Ruined`, `…_Furnished`), Zuordnung der Dekoration |
Beleuchtung (Teil e): `CK-2` Ä-Q00-01. Encounter Zone und Owner (Teile a, f): `CK-1` K-Q00-05.
**Hinweis Reihenfolge:** Teil b bis d sind mehrtägig und **nicht** Voraussetzung für Q00 bis Q02. Zuletzt einplanen (P3).
**Ergebnis:** Rückmeldung „N-Q00-01: nicht begonnen / Teil x fertig“.

---

## Q01

### N-Q01-01: Q01: Betten B1 bis B5 (alt D11, P2)

**Wo und Was (Basis laut Q01-NPC-Packages; Furniture **(geprüft)**: `BedrollHay01` 01899D, `Bedroll01` 036ED3, `CommonBed01` 030091; Hausbetten `CommonBedDouble01L` 0F5101 u. a. existieren ebenfalls):**
| Nr. | EditorID der Ref | Zelle und Ort | Basisobjekt (Vorschlag) | Danach in Package (CK-2 Ä-Q01-02) |
|---|---|---|---|---|
| B1 | `NHV_Ref_Q01_HakanBed` | Tamriel, Zelle `MorthalExterior03` (00939C), am Steg bei `NHV_Mk_Q01_HakanSpot` (0048A7, -35840 / 66432 / -13920); Schlafrolle oder Bett in einer Hütte | `BedrollHay01` | `HakanDockNight` (AD01) |
| B2 | `NHV_Ref_Q01_HrefnaBedroll` | Tamriel, Lager bei `NHV_Mk_Q01_CampMarker` (004980, -16384 / 62848 / -10816), **100–300 Einheiten** vom Feuer | `BedrollHay01` | `HrefnaCampNight` (AD03) |
| B3 | `NHV_Ref_Q01_HrefnaFarmBed` | Innenzelle `NHV_StormhollowFarmCell` (0048A8), Schlafzimmer des Hauses | `CommonBed01` | `HrefnaFarmWaitNight` (AD0F) und `HrefnaFarmNight` (AD0E) |
| B4 | `NHV_Ref_Q01_HrefnaHomeBed` | Deep Sanctuary, Wohnbereich nahe `NHV_Mk_Q01_KitchenSpot` (00498A, -5969 / 428 / 144) | `CommonBed01` | `HrefnaHomeNight` (AD06) |
| B5 | `NHV_Ref_Sys_VeyraBed` | Deep Sanctuary, Veyras Quartier (eigener Raum nahe Ledger Room, `NHV_Mk_MapTable_Veyra` 005ECD) | `CommonBed01` | `VeyraRest` (AD12) |
(B6, Moorside Inn: Quintus nimmt ein freies Bett im Radius; **nichts platzieren**, nur prüfen: `CK-1` K-Q01-03.)
**Wichtig:** Furniture (nicht Static), Ref **Persistent** (nur wenn der Haken im Ref-Dialog vorhanden ist; sonst weglassen und melden; Betten sind keine Charaktere), **Ownership leer**, EditorID setzen. B1/B2 liegen in Vanilla-Außenzellen (E16-Kopien sind laut ARCHITECTURE bereits vermerkt, neue Platzierungen melden). Die Betten B3 bis B5 liegen in NHV-eigenen Zellen. Taste **F**, im Navmesh erreichbar (Kontrolle: `CK-1` K-Q01-02).
**Ergebnis:** Fünf Bett-Refs; **FormKeys notiert** (für CK-2 Ä-Q01-02).

### N-Q01-02: Q01: Möbel für die Tag-Sandboxen (alt D12, P3)

**Wo und Was (Q01-NPC-Packages, N1 bis N4):**
1. **N1 Steg:** Sitzgelegenheit am Steg bei `HakanSpot` (Radius 384).
2. **N2 Lager:** Lagerfeuer und Sitzplätze, Radius 450 um `CampMarker` 004980. Vanilla-Feuer laut Q01-Enhanced-Anleitung: `Campfire01LandBurningDirt01` (Model `Clutter\WoodFires\Campfire01LandBurning.nif`, in jener Anleitung gegen die Load Order geprüft, hier übernommen).
3. **N3 Küche Deep Sanctuary:** Kochstelle, Tisch, Stuhl bei `KitchenSpot` 00498A (Radius 600); Objektauswahl aus dem M1.3-Asset-Inventar (Abschnitt Kitchen) und der CSV.
4. **N4 Hof (optional):** Bank bei `HrefnaFarmSpot` 0089E7.
**Hinweis:** Sandbox nutzt nur vorhandene Möbel (`CommonChair01` ist **(geprüft)**); ohne Möbel stehen die NPCs.
**Ergebnis:** Optional; keine Pflicht.

---

## Q02

### Orientierung: Koordinaten der vorhandenen Q02-Refs in `WindhelmDocksExterior01` laut Export

Sings 005190 (139744, 34304, -13952); Torbjorn 005191 (141599, 36375, -13700); Drinks 005192 (141135, 34660, -13947, in Tamriel); Hjorald 005194 (139589, 34509, -13950); Haldor 005195 (142048, 36000, -13920); Leiche 005959 (142235, 36068, -13946); TrackClue1 00595A (140928, 35040, -13920); TrackClue2 00595B (141856, 36032, -13888); TrackClue3 00595C (142848, 36640, -13920); Clerk-Außentür 0051AA (141184, 35680, -13952); `NHV_Mk_Q02_DockWatch` 005961 (141204, 35511, -13946); `NHV_Mk_Q02_SingsWater` 00595D (142112, 35616, -14016); `NHV_Mk_Q02_HollowExit` 005962 (142432, 36025, -13879); Hollow-Außentür 0057D4 (143424, 37408, -13824).

### N-Q02-01: Tidehouse-Innenzelle mit Türen (alt C1, P1) (N1)

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
**Hinweis:** Fast alle Q02-Innenzellen entstanden bisher als Kopien von Vanilla-Zellen (siehe CK-2 Ä-Q02-04). Für die Tidehouse **keine Vanilla-Zelle kopieren**: eine neue Zelle ist sauberer (kein Vanilla-Inhalt, keine Vanilla-Location).
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
**Ergebnis:** Betreten und Verlassen funktionieren in beide Richtungen. Landung steht vor der Tür, nicht in der Tür (Vorbild: Farmtür, CK-2 Ä-Q01-01).

**Schritt 5: Hinweis E16.** Die Außentür liegt in einer Vanilla-Außenzelle: Meldung an Claude (Rückmeldeformat), er trägt `WindhelmDocksExterior01` samt Salzplatz, Betten und Tür in die E16-Tabelle ein (Q2-28).

### N-Q02-02: Tidehouse-Inhalt (alt D3, P1) (N1, Teil 2)

**Wo:** Zelle `NHV_Q02_TidehouseCell` (aus N-Q02-01).
**Was:**
1. **Zwei Enforcer** `NHV_Q02_DockEnforcer` (AF10): bei der Akte/dem Tisch, EditorID `NHV_Ref_Q02_TideEnforcer01`, `NHV_Ref_Q02_TideEnforcer02`, **nicht Initially Disabled**. (Der Haken Persistent entfällt: er existiert bei Charakter-Refs nicht; das Skript erreicht die Refs über die Property `TidehouseEnforcerRefs`, solange der Spieler in der Zelle ist, siehe CK-2 Ä-Q02-05.) Abstand zueinander 120–200 Einheiten, beide Richtung Tür blickend (sie sprechen den Spieler als Erste an: Hello-Topic `tide_enf`).
2. **Ledger-Buch** `NHV_Book_Q02_TidehouseLedger` (AF30): Object Window, **Items, Book**, Filter `TidehouseLedger`; **offen auf dem Tisch**, erreichbar. Wichtig: Es muss **eine** Ref sein; Hjorald-Gespräch „I have the log“ fordert das Ledger im Inventar (Weltbedingung `ledger`).
3. Möbel/Dekor: Tisch, zwei Stühle oder Hocker, Aktenregal (Auswahl im CK: Object Window, Filter `Table`, `Shelf`, `Chair`; verifiziert ist nur `CommonChair01` 02EC1C mit `Furniture\Common\CommonChair01.nif`).
4. Licht: zwei Lichtquellen; **kein** versteckter Dunkelraum.
5. Keine Quest-Refs in Vanilla-Zellen.
**Ergebnis:** Zwei Enforcer-Refs, ein Buch-Ref; **FormKeys notiert** (für CK-2 Ä-Q02-05: `TidehouseEnforcerRefs`; CK-1 K-ALL-06).

### N-Q02-03: Tidehouse: Navmesh zeichnen (alt F1, P1)

**Regeln (Navmesh allgemein):** Bestehendes Navmesh in Vanilla-Zellen **nicht verändern** (Windhelm Docks ist laut M2.2-Anleitung bereits vollständig navmesht). Nur in eigenen Zellen neu zeichnen. Vor jeder Navmesh-Arbeit **ESP-Backup**. Nach dem Zeichnen **Finalize Cell**: ohne Finalisierung bleiben Türverknüpfungen kaputt. Menüpfad im CK prüfen (Render Window, Menü **World, Navmesh**, bzw. Navmesh-Werkzeugleiste). **Es wird keine KI-/Wegtest-Behauptung abgegeben, bevor der Test lief.**
**Wo:** Zelle `NHV_Q02_TidehouseCell`, Render Window, Navmesh-Modus.
**Was:** Navmesh über den gesamten begehbaren Boden, inklusive der Fläche vor der Tür (Landeplatz) und der Plätze der Enforcer und des Tisches. Kein Loch an der Tür. Dann **Finalize Cell**. Prüfen (Taste M): die Enforcer-Refs stehen **auf** Navmesh; nach dem Finalisieren die Türverknüpfung (Tür-Dreieck) kontrollieren.
**Ergebnis:** Enforcer bewegen sich im Test, der Spieler kommt durch die Tür; sonst Befund melden. (Kontrolle der anderen Q02-Orte: `CK-1` K-Q02-10.)

### N-Q02-04: Salzplatz-Marker (alt D1, P1) (N2, Teil 1)

**Wo:** Zelle `WindhelmDocksExterior01` (Tamriel), Render Window nahe der Hollow-Außentür 0057D4.
**Was:**
1. Object Window, **World Objects, Static**, `XMarkerHeading` (000034 **(geprüft)**) ins Render Window ziehen.
2. Ref-Dialog: EditorID `NHV_Q02_SaltYardMarker`, **Persistent** (nur wenn der Haken im Ref-Dialog vorhanden ist; ein Marker ist kein Charakter; sonst weglassen und melden), nicht Initially Disabled.
3. Position: freie, begehbare Fläche **landseitig vor der Hollow-Tür**, zwischen TrackClue3 (142848 / 36640) und der Tür (143424 / 37408), ca. **400–600 Einheiten (6–8 m)** von der Tür entfernt, **nicht** auf der Hollow-Landefläche, **nicht** im Wasser. Blick (Rotation Z) zur Tür. Auf **Navmesh** (Taste M prüfen).
4. Dort steht Drinks-the-Brine in Stage 45 (`BeginSaltYard()` setzt ihn per `MoveTo` an den Marker; Package `DrinksSaltYard` bleibt am Platz).
**Ergebnis:** Marker steht, FormKey notiert. Ohne den Marker steht Drinks dort, wo er gerade ist (Log „BeginSaltYard: Drinks or SaltYardMarker missing“).
**E16:** Zelle `WindhelmDocksExterior01` ist bereits eine Kopie; Eintrag ergänzt Claude.

### N-Q02-05: Salzplatz-Enforcer und Beweisstücke (alt D2, P1) (N2, Teil 2)

**Wo:** gleiche Zelle, um `NHV_Q02_SaltYardMarker`.
**Was:**
1. Object Window, **Actors, Actor**, Filter `NHV_Q02_DockEnforcer` (AF10). Ins Render Window ziehen, **2 bis 3 Mal**, **Radius 150–250 Einheiten** um den Marker, Blick zum Marker oder zueinander.
2. Je Ref: EditorID `NHV_Ref_Q02_SaltEnforcer01` bis `03`, Haken **Initially Disabled aus**. (Kein Persistent: den Haken gibt es bei Charakter-Refs nicht. Die Refs sind für das Skript über die Property `SaltYardEnforcerRefs` erreichbar, siehe CK-2 Ä-Q02-05; der Salzplatz-Pfad läuft, während der Spieler in den Docks ist.)
3. **Haldors Messer** `NHV_MISC_Q02_HaldorKnife` (AF31): Object Window, **Items, Misc Item**, Filter `HaldorKnife`; auf den Boden zwischen den Enforcern ziehen (Taste F). Bedingung Fundstelle: für den Spieler erreichbar, nicht im Wasser.
4. **Sluice Token** `NHV_MISC_Q02_SluiceToken` (AF32): gleiche Technik, **bei einem Enforcer am Boden**. (Eine Platzierung im NPC-Inventar per Ref geht im CK nicht zuverlässig, deshalb am Boden; als Alternative das Item in das **Inventory** des Base-Records AF10 legen, dann trägt es jeder Enforcer; im CK prüfen. Das ist keine Anforderung.)
5. Enforcer-Packages: `NHV_Pkg_Q02_EnforcerPost` (AF60, `NearEditorLocation` Radius 384) liest die Platzierung: die Enforcer stehen also dort, wo du sie hinstellst.
**Ergebnis:** 2–3 Enforcer-Refs plus Messer und Token; **FormKeys notiert** (für CK-2 Ä-Q02-05: `SaltYardEnforcerRefs`).
**Hinweis:** Der Rückfall ohne die Refs: `EnforcersHostile` hat keine Ziele, der Salzplatz-Pfad bleibt im Dialog trotzdem spielbar (Drinks-Zeilen).

### N-Q02-06: Kurier in das Kontor (alt D4, P1) (N3)

**Wo:** Zelle `NHV_Q02_HarborClerkOfficeCell` (0057DC), neben dem Schreibtisch mit der Dispatch-Ref `NHV_Q02_DispatchDeskRef` (005954, Initially Disabled).
**Was:**
1. Object Window, **Actors, Actor**, Filter `NHV_Q02_ImperialCourier` (AF11). Ins Render Window neben das Pult ziehen, **100–150 Einheiten** vom Pult entfernt, Blick zum Pult. Auf Navmesh.
2. Ref-Dialog: EditorID `NHV_Ref_Q02_ImperialCourier`, **Initially Disabled** (Skript `CourierFlees` und `OnDeskOpened` aktivieren ihn nur bei geöffnetem Pult, E54). Kein Persistent (den Haken gibt es bei Charakter-Refs nicht; der Kurier wird nur bei geöffnetem Pult im Kontor aktiviert, der Spieler ist dann in der Zelle; Property `CourierRef`, CK-2 Ä-Q02-05).
3. **Imperial Seal** `NHV_MISC_Q02_ImperialSeal` (AF33) in sein Inventar: im **Base-Record** `NHV_Q02_ImperialCourier` (AF11, Reiter **Inventory**) hinzufügen (eine Ref-Inventar-Bearbeitung ist im CK nicht üblich; im CK prüfen). AF11 ist eigener Record, kein Vanilla-Eingriff.
4. Package `NHV_Pkg_Q02_CourierWait` (AF61, `NearEditorLocation` Radius 128) liest die Platzierung.
**Ergebnis:** Kurier-Ref steht disabled; FormKey notiert (für CK-2 Ä-Q02-05: `CourierRef`). Ohne `DispatchDeskRef` (existiert) gibt es keinen Kurier.

### N-Q02-07: Chiffre-Schlüsselbuch (alt D5, P3) (N4, E56, optional)

**Wo:** Kontor-Zelle am Pult (Dispatch-Ref 005954).
**Was:** Object Window, **Items, Book**, `NHV_Book_Q02_CipherKey` (AF34), neben den Dispatch ziehen. **Vorschlag (Frage 10, README):** Initially Disabled mit **Enable Parent** = `NHV_Q02_DispatchDeskRef` (Feld **Enable Parent** im Ref-Dialog), damit es mit dem Dispatch erscheint, wenn das Skript das Pult freischaltet (Engine-seitig, kein Skript). Ohne Enable-Parent liegt es von Beginn an offen im Raum.
**Ergebnis:** Optional; Veyra-Fallback ist im Dialog vorhanden. Dispatch-Ref selbst **nicht ändern**.

### N-Q02-08: Drei Betten für das Q02-Schlafen (alt D6, P2) (N6)

**Wo und Was:**
| Bett | Zelle | Basisobjekt | Wo | EditorID |
|---|---|---|---|---|
| Torbjorn | `WindhelmDocksExterior01` | `BedrollHay01` (FURN 01899D, `Furniture\Bedroll\BedrollHay01.nif`) **(geprüft)** | im Radius **2000 Einheiten** um seine Ref 005191 (141599 / 36375), möglichst unter Dach oder in Windschatten am Hafenmeisterposten | `NHV_Bed_Q02_Torbjorn` |
| Sings | `NHV_Q02_DrownedHollowCell` (0051AB; EditorID laut Export noch `NHV_Q02_DrownedHollowDoorInt`, Umbenennung in CK-2 Ä-Q02-04) | `Bedroll01` (FURN 036ED3, `Furniture\Bedroll\Bedroll01.nif`) **(geprüft)** | nahe Marker `NHV_Mk_Q02_SingsHollow` (0057D8, Position 1361 / 1880 / 100), Radius 1024 laut Package `SingsHideoutNight` | `NHV_Bed_Q02_Sings` |
| Aelius | `NHV_Q02_HarborClerkOfficeCell` (0057DC) | `CommonBed01` (FURN 030091, `Furniture\Common\CommonBed01.nif`) **(geprüft)** | im Radius **2000** um seine Ref 005953 (-2673 / -2663 / 760) | `NHV_Bed_Q02_Aelius` |
**Wichtig:** Es muss ein **Furniture** (FURN) sein, **nicht** `BedrollHay01STATIC` (101A36, nur Static, nicht benutzbar). Ref-Dialog: EditorID setzen, **Persistent** (nur wenn der Haken im Ref-Dialog vorhanden ist; ein Bett ist kein Charakter; sonst weglassen und melden), **Ownership leer** (kein Owner, sonst Konflikte beim Schlafen). Bett auf den Boden (Taste F), im Navmesh erreichbar. Beim Torbjorn-Bett am Hafen bevorzugt eine Stelle mit Navmesh in unmittelbarer Nähe.
**Abgrenzung:** Das Drinks-Bett ist ein **Vanilla-Bett** (0C92F3 in `WindhelmArgonianAssemblage`), nur referenziert, **nichts platzieren** (CK-1 K-Q02-08).
**Ergebnis:** Drei Bett-Refs; **FormKeys notiert** (an Claude für `BEDS`, siehe CK-1 K-Q02-11). Solange sie fehlen, suchen die Packages ein Bett im Radius (Vanilla-Muster).

### N-Q02-09: Idle-Möbel um die Q02-NPCs (alt D7, P3) (N7)

**Wo:** Docks außen (um Drinks 005192, Torbjorn 005191), Kontor (Aelius 005953).
**Was:** Sandbox-Packages nutzen vorhandene Möbel; ohne Möbel stehen die NPCs. Platzieren (jeweils ohne Persistent-Haken nötig): Sitzgelegenheit und Arbeitstisch am Hafenmeisterposten, Kisten/Fässer als Lastenarbeit bei Drinks, Schreibtisch und Stuhl im Kontor bei Aelius (Hinweis: das Kontor ist eine Palast-Zellenkopie, der Schreibtisch ist ggf. vorhanden; vor dem Neuplatzieren die Zelle ansehen). Verifiziert ist nur `CommonChair01` (02EC1C); alles andere im Object Window per Filter (`Barrel`, `Crate`, `Desk`, `Table`) **im CK prüfen**.
**Ergebnis:** Optional; keine Pflicht für den Ablauf.

### N-Q02-10: Haldor-Rückkehr-Marker (alt D8, P3, optional) (Nachtrag Koordinator b, K6 der Package-Anleitung)

**Wo:** Zelle `WindhelmDocksExterior01`, an Haldors Ursprungsplatz (142048 / 36000 / -13920).
**Was:** `XMarkerHeading` (000034) platzieren, EditorID `NHV_Mk_Q02_HaldorReturn`, **Persistent** (nur wenn der Haken im Ref-Dialog vorhanden ist; Marker, kein Charakter; sonst weglassen und melden), Position identisch zu Haldors Ref 005195 oder 100 Einheiten daneben, auf Navmesh. Das Package `HaldorDocks` (AF5C, Bedingung S < 45 oder S >= 100, `NearEditorLocation` Radius 512 um Ref 005195) liest Haldors Ref-Platz: **ohne Marker läuft er nach Stage 100 an seinem Ursprungsplatz umher** (laut `Q02-NPC-Packages.md` so umgesetzt). Der Marker ist nur nötig, wenn Haldor an einem anderen Ort zurückkehren soll; dann Package-Ort auf den Marker umstellen (Claude lässt das Tool anpassen, Frage 11, README). Vorher prüfen: sein Platz ist im Radius 512 begehbar (Navmesh am Kai).
**Haldor selbst:** An der Ref 005195 ist **nichts** zu ändern (früher B9 „Persistent“, entfallen). Haldor wird ab Stage 45 per Skript deaktiviert (`HideHaldor()`) und ab Stage 100 wieder aktiviert (`ShowHaldor()`; lebend: läuft am Kai herum; tot: bleibt als Leiche liegen); das Skript erreicht ihn über den Unique-Actor-Alias `HaldorAlias` (CK-1 K-Q02-07).
**Ergebnis:** Optional; bei Anlage FormKey notiert.

---

## Checkliste (abhaken)

- [ ] N-Q00-01 Deep Sanctuary (M1.3): Stand gemeldet
- [ ] N-Q01-01 Q01-Betten B1–B5 (Furniture, ohne Owner)
- [ ] N-Q01-02 Q01-Möbel (optional)
- [ ] N-Q02-01 Tidehouse: Zelle, zwei Türen, Teleport, nicht abgeschlossen
- [ ] N-Q02-02 Tidehouse: 2 Enforcer, Ledger, Möbel, Licht
- [ ] N-Q02-03 Tidehouse-Navmesh gezeichnet und finalisiert (Backup vorher)
- [ ] N-Q02-04 Salzplatz-Marker
- [ ] N-Q02-05 Salzplatz: 2–3 Enforcer, Messer, Sluice Token
- [ ] N-Q02-06 Kurier (disabled) im Kontor, Imperial Seal im Inventar von AF11
- [ ] N-Q02-07 Chiffre-Buch (optional)
- [ ] N-Q02-08 Drei Q02-Betten (Furniture, ohne Owner)
- [ ] N-Q02-09 Idle-Möbel (optional)
- [ ] N-Q02-10 Haldor-Rückkehr-Marker (optional)

Danach: **CK-2 Ä-Q02-05 und Ä-Q01-02** (brauchen diese Refs), dann Kontrolle in CK-1, Abschluss **K-ALL-07**.

## Rückmeldung an Claude (Chat)

FormKeys = die letzten 6 Stellen aus dem CK (ohne die ersten beiden Stellen, den Load-Order-Index).

```
CK-3 (Neu) fertig (Datum, Dauer, CK-Version)
Erledigt: <Liste der Aufgaben-IDs>   Offen: <IDs + Grund>

FormKeys der neuen Refs (EditorID = FormKey):
  NHV_Q02_TidehouseDoorExtRef / NHV_Q02_TidehouseDoorIntRef = ...
  NHV_Ref_Q02_TideEnforcer01/02 = ...
  NHV_Q02_SaltYardMarker = ...
  NHV_Ref_Q02_SaltEnforcer01..03 = ...
  NHV_Ref_Q02_ImperialCourier = ...
  NHV_Mk_Q02_HaldorReturn = ...
  Ref des Tidehouse-Ledger-Buchs (AF30), Messer (AF31), Token (AF32), Chiffre-Buch (AF34) = ...
Betten (für BEDS in tools/build_q02_packages.py und Q01-Packages):
  NHV_Bed_Q02_Torbjorn / _Sings / _Aelius = ...
  NHV_Ref_Q01_HakanBed / _HrefnaBedroll / _HrefnaFarmBed / _HrefnaHomeBed = ...
  NHV_Ref_Sys_VeyraBed = ...
Persistent-Haken an Nicht-Charakter-Refs (Marker/Betten) vorhanden ja/nein: ...
Geänderte Zellen (für die E16-Tabelle in ARCHITECTURE.md):
  WindhelmDocksExterior01 (00B4B9): Tidehouse-Außentür, Salzplatz-Marker/Enforcer, Torbjorn-Bett, Haldor-Marker
  MorthalExterior03 (00939C): Hakan-Bett;  Tamriel Lager (Außenzelle): Hrefna-Bettrolle   (laut Zellenname im CK)
  <weitere Zelle (FormID): neue Refs>
Befunde: Tidehouse-Fassade/Anzeigename (Frage 2), Kit-Name, Outfit/Möbel-Auswahl, Navmesh-Lücken
Antworten auf Fragen (README): ...
Sonstiges (Absturz, Warnungen): ...
```

Danach (macht Claude): `sync_dev.ps1 -Direction FromDev`, `plugin_text.ps1 -Direction ToText`, Export prüfen (neue FormKeys, Betten, Vanilla-Overrides), `tools\build_q02_packages.py` mit den Bett-FormKeys (`BEDS`, nicht `--write` des Hauptgenerators), E16-Tabelle, ROADMAP/PROGRESS. Folgt ein Spriggit-Eingriff, gibt es einen **zweiten, kurzen CK-Durchgang** (ESP öffnen, speichern), nie parallel. Commit durch dich, kein Push, kein Tag.
