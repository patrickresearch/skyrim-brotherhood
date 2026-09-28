# Q02 – Cold Waters (Windhelm): Vollständiger Plan

Stand: 27.09.2026. Quelle der Wahrheit: `docs/concept/konzept.md` Abschnitt „Q02 – Cold Waters
(Windhelm)“, `docs/concept/Q02-Nebenfiguren-Autorenprofile.md`, `docs/concept/Neue-Charakterprofile.md`,
`dialogue/Q02.csv` (73 Zeilen, Stages 10–100), `dialogue/Journal.csv` (Zeilen `NHV_Q02_*_90`/`_98`),
`dialogue/NightsHarvest-dialoge-und-lore/dialogue/script/Q02_Cold_Waters.md` und `FAM_Sings.md`,
`dialogue/Books.csv` (`NHV_SYS_BOOK_82`, Oculatus-Fragment 2). Reserve-FormID-Bereich für dieses
Arbeitspaket laut Auftrag: `0x004100–0x0041FF` in `NightsHarvest.esp` (siehe Hinweis in
`docs/plan/Q02-Records.md` zu Kollisionsrisiko, da kein zentrales FormID-Ledger existiert).

Alles, was hier als **[Vorschlag]** markiert ist, steht nicht im Konzept und muss vom Entwickler
bestätigt oder verworfen werden, bevor es gebaut wird. Alles andere ist aus den Quellen oben
übernommen oder unmittelbar daraus abgeleitet.

## 1. Kurzfassung und Einordnung

Windhelms Hafen gibt seit dem Tauwetter Leichen zurück. Sings-Beneath-Ice, ein Argonier unter dem
Shadow-Sternzeichen, ertränkt nachts Nords, die Argonier misshandeln. Veyras Prüfung: kann er auch
ohne Hass töten – nämlich Aelius Varro, den einzigen Hafenangestellten, der die Argonier fair
behandelt hat? Die Wendung: Aelius war freundlich, weil er für den Penitus Oculatus ein
Informantennetz gegen die Argonier aufbaute (Oculatus-Fragment 2, `NHV_SYS_BOOK_82`, bereits
geschrieben). Zweiter Contract nach Q01, Kandidat 2 von 5. Spieldauer laut Konzept ca. 60 Minuten.

Stufe der Erzählung wie Q01: Whisper (Veyra-Briefing) → Hunt (Ermittlung am Hafen) → Observation
(Nachtwache, Beschattung) → Trial (Veyras Prüfung: Sings tötet Aelius) → Judgement (Urteil über
Sings) → Homecoming (Rekrutierung ins Drowned Pool oder eines der drei anderen Enden).

## 2. Stages, Journal-Ziele, Inhalt

Stage-Nummern sind durch `dialogue/Journal.csv` und `dialogue/Q02.csv` bereits festgelegt und dürfen
nicht mehr verändert werden (docs/CONVENTIONS.md, Regel 3 der harten Regeln).

| Stage | Journal (EN, aus Journal.csv) | Inhalt | Trigger zur nächsten Stage |
|---|---|---|---|
| 10 | Investigate the bodies in Windhelm's harbor. | Veyra-Briefing an der Map Table (`Veyra_Q02_Brief`); Gespräche mit Torbjorn Ice-Vein (Hafenmeister) und Drinks-the-Brine (Argonier, Persuade ≥30 oder Bribe ≥25 Gold öffnet den Knoten-Hinweis) | Spieler untersucht die neueste Leiche (Objective „Examine the latest victim“) |
| 20 | Examine the latest victim. | Frische Leiche am Ostpier; Torbjorn erkennt den Knoten als „marsh style fisherman's hitch“ – argonische Technik, Täter arbeitet nachts | Spieler wartet auf die Nachtwache (22:00–04:00) |
| 30 | Watch the docks at night. | Nachtszene `SCN_HaldorDocks`: Haldor Frost-Knuckle schikaniert einen Argonier, Sings zieht ihn ins Wasser. Entscheidung: eingreifen (Haldor gerettet, Sings flieht) oder beobachten | Verzweigt zu Stage 40 (Beschattung ODER Spurensuche) |
| 40 | Follow the killer without being seen. | **Pfad A (nicht eingegriffen):** Stealth-Beschattung mit Distanz-/Sichtprüfung, endet in „Confront the killer“. **Pfad B (Haldor gerettet):** Spurensuche über Fußspuren/Gezeitenlinie (`Q02_Tracking`-Zeilen bereits im CSV) – länger, aber ohne Entdeckungsrisiko | Beide Pfade führen zur Drowned Hollow |
| 50 | Confront the killer. | Interior „The Drowned Hollow“ (neu, Eingang unter den Docks, landseitig erreichbar). Dialog mit Sings, dann Szene `SCN_VeyraHollow`: Veyra erscheint, verkündet die Prüfung (Aelius töten) und reist ab | Sings akzeptiert (dialoggetrieben, keine Ablehnung ohne Kampf vorgesehen) |
| 60 | Help Sings-Beneath-Ice kill Aelius the harbor clerk. | Szene `SCN_Aelius`: Sings holt Aelius nachts aus seinem Büro, führt ihn ans Wasser, tötet ihn. Spieler begleitet/deckt; kein eigener Kill nötig, aber möglich (Fallback, siehe Abschnitt 6) | Aelius tot |
| 70 | Decide Sings-Beneath-Ice's fate. | Sings durchsucht Aelius' verschlossenen Schreibtisch, findet die Namensliste (Oculatus-Fragment 2). Judgement-Menü: Recruit / Release / Silence / An den Jarl ausliefern (Watch-Sergeant Hjorald) | Nach Entscheidung |
| 100 | Return to Veyra. | Debrief in der Sanctuary, Ergebnis- und Fragment-abhängige Zeilen (`NHV_Q02_Result`, `GetItemCount NHV_Note_Dispatch02`) | Quest-Ende |

## 3. Orte (alle Schauplätze)

Alle Cell-EditorIDs unten wurden per houseCARL gegen `Skyrim.esm` (Live-Load-Order, Epoch
`e2-aac19ab082648e28`) verifiziert – keine Annahmen aus dem Gedächtnis.

| Ort | Typ | EditorID / FormID | Verwendung in Q02 | Vanilla-Berührung |
|---|---|---|---|---|
| Windhelm-Hafen, Außenbereich | Vanilla-Exterior | `WindhelmDocksExterior01` (`00B4B9:Skyrim.esm`) | Hauptschauplatz Stage 10–40; Leichenfundort, Torbjorns Posten, Nachtszene mit Haldor/Sings, neuer Ladetür-Eingang zur Drowned Hollow | Ja – **Risiko hoch**: `override_depth=4` (Update, Dragonborn, HearthFires, Dawnguard berühren die Zelle bereits); stark modifizierte Zelle bei Stadt-Overhauls (z. B. JK's Windhelm, Cutting Room Floor, Windhelm-Docks-Erweiterungen). Nur additive Referenzen (Leichen-Alias, Torbjorn/Drinks-Alias, neue Ladetür), keine Bearbeitung bestehender Referenzen oder Navmesh |
| East Empire Company (Windhelm) | Vanilla-Interior | `WindhelmEastEmpireCompany` (`016777:Skyrim.esm`) | **Nicht** für Aelius' Büro verwendet (siehe unten) – nur erwähnt, weil dort bereits Diebesgilde-NPCs (`OrthusEndarioREF`, `AdelaisaREF`) sitzen; Kollisionsrisiko mit Diebesgilden-Questlogik, deshalb bewusst gemieden | Nein, wird nicht berührt |
| Windhelm-Lagerhaus | Vanilla-Interior | `WindhelmWarehouse` (`0965B3:Skyrim.esm`) | [Vorschlag] optionaler Fundort für einen der drei „Torbjorn's Ledger“-Zettel (Nebenaufgabe A) | Ja, minimal (ein Alias-Item auf vorhandenem Regal, kein neuer Static) |
| Windhelm Bloodworks | Vanilla-Interior | `WindhelmBloodworks` (`01677A:Skyrim.esm`) | [Vorschlag] zweiter Fundort für Nebenaufgabe A (Leichenhalle passt thematisch zu den vier Ertrunkenen) | Ja, minimal (Alias-Item) |
| Windhelm Argonian Assemblage | Vanilla-Interior | `WindhelmArgonianAssemblage` (`016776:Skyrim.esm`) | Wohnort von Drinks-the-Brine (Alias auf neuem Actor, der dort schläft/arbeitet) und Schauplatz von [Vorschlag] Nebenaufgabe B; vorhandene Vanilla-NPCs dort: `ShahveeREF`, `StandsInShallowsREF`, `ScoutsManyMarshesREF`, `NeetrenazaREF` | Ja – neue Aliase auf vorhandene Argonier-NPCs (Fill-Type „Specific Reference“, Optional, wie Q00/Q01 bei Vanilla-NPCs) |
| The Drowned Hollow | **Neues Interior** | `NHV_Q02_DrownedHollowCell` (neu) | Sings' Versteck, Stage 50; Eingang über eine neue Ladetür unter/neben den Docks in `WindhelmDocksExterior01`, landseitig erreichbar (kein Unterwasser-Navmesh nötig, wie im Konzept gefordert) | Nein (eigene Zelle); nur die neue Tür-Referenz in der Vanilla-Exteriorzelle |
| Aelius' Hafenkontor | **Neues Interior (klein)** | `NHV_Q02_HarborClerkOfficeCell` (neu) | Aelius' Büro/Schlafplatz, Stage 60-Auftakt; eigene Mini-Zelle statt Erweiterung der East Empire Company, um Diebesgilden-Konflikte zu vermeiden; Tür in `WindhelmDocksExterior01` | Nein (eigene Zelle); nur die neue Tür-Referenz |
| The Drowned Pool | **Neues Interior** | `NHV_Q02_DrownedPoolCell` (neu) | Rekruten-Zuhause nach erfolgreichem Judgement „Recruit“: unterirdisches Trainingsbecken mit Pfählen (Sneak-Training laut `FAM_Sings.md`); Zugang aus der Deep Sanctuary (Tür/Gang, analog Q01 „The Velvet Counter“ etc.) | Nein |

**Entscheidung für den Entwickler:** Aelius' Büro bewusst als eigene Mini-Zelle statt als Erweiterung
von `WindhelmEastEmpireCompany` geplant, um Kollisionen mit der Diebesgilden-Hauptquest
(Adelaisa/Orthus) zu vermeiden. Falls du stattdessen eine bestehende Nische in
`WindhelmDocksExterior01` (z. B. ein Lagerschuppen-Static) als Bühne ohne eigene Zelle bevorzugst,
sag Bescheid – das spart eine Zelle, verändert aber die Kameraführung der Szene.

## 4. NPCs

| Name | Rolle | Typ | Alias in `NHV_Q02` | Schedule/Packages |
|---|---|---|---|---|
| Sings-Beneath-Ice | Rekrutierungskandidat, Argonier | Neuer Actor | `SingsAlias` (ReferenceAlias, Quest-Objekt) | Vor Stage 50: Sandbox/Arbeit am Hafen tagsüber, nachts Jagd (`NHV_Pkg_Sings_NightHunt`, Bedingung Stage==30, Zeitfenster 22–04, Quest-Priorität analog Q00-Standoff-Packages); ab Stage 50 in der Drowned Hollow gehalten (DoNothing-Template wie Q00, **nicht** `EnableAI(False)`, siehe ARCHITECTURE-Hinweis vom 25.09.); nach Recruit dauerhaft `NHV_RecruitAliasScript` in `NHV_Sys_Family` (System-Quest, nicht hier) |
| Torbjorn Ice-Vein | Hafenmeister | Neuer Actor | `TorbjornAlias` | Tagsüber Sandbox am Ostpier (`NHV_Pkg_Torbjorn_DockWork`), vorhandene Möbel/Kisten nutzen, keine neuen Furniture-Statics nötig |
| Drinks-the-Brine | Argonischer Hafenarbeiter | Neuer Actor | `DrinksAlias` | Tagsüber Lastenarbeit am Kai, nachts `WindhelmArgonianAssemblage` (Schlafpackage); [Vorschlag Nebenaufgabe B] optionaler Dialogzweig dort |
| Haldor Frost-Knuckle | Schläger, Opfer der Nachtszene | Neuer Actor | `HaldorAlias` | Nur zur Nachtszene (Stage 30) an den Docks aktiv; danach falls gerettet: verschwindet aus der Zelle (`Disable()`+`MoveToMyEditorLocation()` in eine Warteszelle, oder `NHV_Cfg_Debug`-loggbares Despawn nach 3 Tagen), falls nicht gerettet: tot, Leiche bleibt bis zur nächsten Zellen-Reset |
| Aelius Varro | Hafenschreiber, Oculatus-Informant | Neuer Actor | `AeliusAlias` | Tagsüber Schreibarbeit in seinem Kontor (`NHV_Q02_HarborClerkOfficeCell`), abends „arbeitet spät“ (Voraussetzung für die nächtliche Abholung durch Sings in Stage 60) |
| Watch-Sergeant Hjorald | Wachtsergeant, Zeuge/Vollstrecker bei „Ausliefern“ | Neuer Actor | `HjoraldAlias` | Reguläre Wachpackages am Hafen (Vanilla-Wach-Template als Basis, kein Vanilla-Record-Edit: eigener NPC-Record mit `WindhelmGuardFaction`, keine Umwidmung eines echten Vanilla-Wächters) |
| ScoutsManyMarshesREF u. a. (Argonian Assemblage) | Vanilla-Statisten | Vanilla, unverändert | [Vorschlag] `AssemblageWitnessAlias` (Optional, Specific Reference) | Nur für 1–2 Ambient-/Bestätigungszeilen in Nebenaufgabe B, keine Packages, keine Fraktionsänderung |

Kein einziger Vanilla-NPC wird verändert; die einzige Berührung ist ein optionaler Alias auf
`ScoutsManyMarshesREF` für eine Ambient-Zeile in der [Vorschlag]-Nebenaufgabe – exakt das Muster aus
`docs/ARCHITECTURE.md` („Aliase auf Vanilla-Referenzen sind immer Optional, Fill-Type Specific
Reference“).

## 5. Aliase in `NHV_Q02` (Quest-Objekt)

| Alias | Typ | Fill-Type | Scripts |
|---|---|---|---|
| `PlayerRefAlias` | ReferenceAlias | Player | `NHV_PlayerAliasScript` (bestehend, System) |
| `VeyraAlias` | ReferenceAlias | Specific Reference, **Optional** | keins; zeigt auf dieselbe Referenz wie `NHV_CoreScript.VeyraRef` (privat, kein Property – Zugriff nur über Alias, exakt das Muster aus `NHV_Q01Script.VeyraAlias`). Fällt Veyra weg (E16-Fall), läuft Stage 50 laut CK-Anleitung mit einem dialoggetriebenen Fallback ohne Szene weiter |
| `SingsAlias` | ReferenceAlias | Specific Reference (Quest-Objekt-Referenz) | `NHV_ContractRecruitAliasScript` (bestehend, laut Kopfkommentar „reusable as-is for Q02–Q05“) + `NHV_Q02_SingsAliasScript` (neu, Q02-spezifisches Verhalten: Nachtjagd starten/stoppen, Fluchtreaktion bei Entdeckung) |
| `TorbjornAlias` | ReferenceAlias | Specific Reference | keins (rein dialoggetrieben) |
| `DrinksAlias` | ReferenceAlias | Specific Reference | keins (rein dialoggetrieben), optional Nebenaufgaben-Flag |
| `HaldorAlias` | ReferenceAlias | Specific Reference | `NHV_Q02_HaldorAliasScript` (neu: Ertrinken/Rettung) |
| `AeliusAlias` | ReferenceAlias | Specific Reference | keins nötig (Tod läuft über die Szene selbst; `OnDeath` wird nicht gebraucht, da Aelius kein Rekrut ist) |
| `HjoraldAlias` | ReferenceAlias | Specific Reference | keins (dialoggetrieben) |
| `AssemblageWitnessAlias` [Vorschlag] | ReferenceAlias | Specific Reference, **Optional** | keins |

## 6. Ablauf im Detail

### Stage 10–20: Ermittlung
- Veyra-Briefing an der Map Table (`Veyra_Q02_Brief`, bereits vertont/geschrieben).
- Torbjorn zählt die vier bisherigen Toten nüchtern auf; Fünfter kommt am Ostpier hoch.
- Drinks-the-Brine reagiert misstrauisch; Persuade ≥30 oder Bribe ≥25 Gold öffnen den Knoten-Hinweis
  (beides im CSV bereits als Dialogzweig vorhanden – **kein** Codex-Auftrag nötig).
- Untersuchung der Leiche (Activator/Item „Examine“) setzt Stage 20; Torbjorn erkennt die
  argonische Knotentechnik → Stage 30.

### Stage 30: Nachtwache und Entscheidung
- Zeitfenster 22:00–04:00, Ort `WindhelmDocksExterior01`. Umsetzung wie im Autorenprofil gefordert:
  **kein Dauer-Polling**, sondern ein watchdog-artiger `RegisterForSingleUpdate`-Zyklus, der nur
  während Stage 30 läuft und sich selbst abmeldet, sobald die Stage wechselt (Muster aus
  `NHV_Q01Script.BeginCampWatch()`/`OnUpdate()`).
- Sobald Spielzeit im Fenster liegt UND Spieler in Reichweite des Docks-Markers ist, startet die
  Szene `NHV_Scn_Q02_01HaldorDocks` (Haldor schikaniert einen Argonier-Statisten, Sings zieht ihn
  ins Wasser).
- **Entscheidung „Eingreifen“:** Aktiviert der Spieler Haldor/greift ein, bevor die Szene das Ziehen
  abschließt, rettet `NHV_Q02_HaldorAliasScript` ihn (Global `NHV_Q02_HaldorSaved = 1`, CSV-Bedingung
  bereits vorhanden), Sings flieht sofort (`EvaluatePackage()` auf Fluchtpackage), die Beschattung
  entfällt zugunsten der Spurensuche (Pfad B, Stage 40 andere Dialogzeilen `Q02_Tracking`, bereits im
  CSV). **Nicht eingreifen:** Szene läuft zu Ende, Haldor "ertrinkt" (in Wahrheit: wird unsichtbar
  gemacht/an einen Warteort verschoben, kein grafischer Tod nötig, da die Konzept-Zeilen ihn nur
  rufen und untertauchen lassen – CK-Anleitung klärt die genaue Inszenierung), `NHV_Q02_HaldorSaved = 0`.

### Stage 40: Beschattung oder Spurensuche
- **Pfad A (Beschattung):** Sings bewegt sich auf einer Package-Route zur Drowned Hollow. Ein
  Quest-Script-Timer (`RegisterForSingleUpdate`, 1–2 s) prüft Sichtlinie/Distanz zwischen Spieler und
  Sings sowie `Actor.IsDetectedBy(PlayerRef)`; bei Entdeckung `Sings.StartCombat()`-Vermeidung durch
  sofortigen Fluchtsprint zur Hollow (kein Kampf vorgesehen) **und** Fallback auf Pfad B
  (Spurensuche), damit die Quest nie blockiert.
- **Pfad B (Spurensuche, nach Rettung):** rein dialog-/itembasiert, nutzt die bereits vorhandenen
  `Q02_Tracking`-Zeilen; keine zusätzliche Scriptlogik außer `SetStage(50)` am Ende.

### Stage 50: Confront the killer (Drowned Hollow)
- Dialog mit Sings, dann Szene `NHV_Scn_Q02_02VeyraHollow` (Veyra erscheint). Cutscene-Lock analog
  Q01 (`NHV_ContractBaseScript.LockCutscene()`), Watchdog über `OnUpdateGameTime()` wie in
  `NHV_Q01Script`, falls die Szene hängen bleibt.
- Am Ende: `SetStage(60)`.

### Stage 60: Die Prüfung
- Szene `NHV_Scn_Q02_03AeliusKill`: Sings holt Aelius ab, führt ihn ans Wasser, tötet ihn
  (Sings tötet – nicht der Spieler; die Prüfung ist explizit Sings' Tat). Fallback laut Konzept-
  Symmetrie zu Q01 (Hrefna-Prüfung „Spieler tötet selbst = nicht bestanden“): **[Vorschlag]**
  Greift der Spieler in die Szene ein und tötet Aelius selbst, gilt die Prüfung analog Q01 als
  „nicht bestanden im eigentlichen Sinn“ – Sings zieht dennoch ein, aber mit Flag
  `NHV_Q02_Flag_SingsUnproven` (Parallelmuster zu `NHV_Flag_HrefnaUnproven`), der ihn im Finale (Q06)
  erneut prüfbar macht. Das steht nicht explizit im Konzept, folgt aber demselben Muster wie Q01 und
  sollte vor dem Bau bestätigt werden.
- `SetStage(70)`.

### Stage 70: Judgement
- Sings findet die Namensliste in Aelius' verschlossenem Pult (`GiveFragmentIfMissing()` aus der
  Basisklasse, Item `NHV_Note_Dispatch02` = `OculatusDispatch02` aus `Books.csv`).
- Vier Ausgänge (alle bereits im CSV/Journal vorgesehen):
  1. **Recruit** – `CompleteRecruitment()`, Ziel „The Drowned Pool“ (`NHV_Q02_DrownedPoolCell`).
  2. **Release** – Sings verlässt Windhelm über die Straße; Leichenfunde enden (kein weiterer
     Scripted-Effekt nötig, rein narrativ).
  3. **Silence** – `RecruitDied()`-Pfad über Kampf (analog `JudgeSilence()` in Q01).
  4. **An den Jarl ausliefern** – Hjorald übernimmt Sings; `STATUS_SPECIAL` (Sonderfall, siehe
     `docs/ARCHITECTURE.md` Zeile 95), 500 Gold Kopfgeld an den Spieler, dauerhaftes Flag
     `NHV_Q02_Flag_VeyraDisapproval` (quest-lokal geplant, siehe Abschnitt 9 zu offenen Fragen).
- `SetStage(100)`.

### Stage 100: Debrief
- Veyra kommentiert ergebnisabhängig (`NHV_Q02_Result`, bereits im CSV verdrahtet) und – falls das
  Fragment abgegeben wurde – den Oculatus-Faden.

## 7. Nebenaufgaben (Side Quests)

**Wichtiger Befund:** Das Konzept sieht für Q02 – anders als Q01 mit Hrefna/Quintus-Epilog –
**keine** zusätzliche Nebenquest-Kette vor. Die einzigen „Nebenpfade“ im Konzept sind die bereits
oben behandelten Entscheidungsverzweigungen (Eingreifen bei Haldor, vier Judgement-Ausgänge,
Persuade/Bribe bei Drinks-the-Brine). Diese sind vollständig in `dialogue/Q02.csv` abgedeckt und
brauchen keinen zusätzlichen Codex-Auftrag.

Die folgenden zwei Nebenaufgaben sind **[Vorschlag], nicht im Konzept**, bewusst klein und additiv
gehalten (kein neuer Quest-Record, keine neue Zelle, kein Eingriff in die Hauptstages), damit sie
ohne Risiko für den Rekrutierungspfad übersprungen werden können:

### [Vorschlag] Nebenaufgabe A – „Torbjorn's Ledger“
- **Idee:** Drei kurze Hafenlogs/Notizzettel, verteilt in `WindhelmWarehouse` und `WindhelmBloodworks`
  (beide bereits vanilla, minimaler Alias-Eingriff), dokumentieren die vier früheren Opfer aus
  Torbjorns Sicht. Sammelt der Spieler alle drei, erhält er bei Torbjorn eine zusätzliche
  Debrief-Zeile und 50 Gold „für die Mühe“, keine Auswirkung auf Sings' Schicksal.
- **Umsetzung:** rein itembasiert (3 `MiscItem`-Bücher als lesbare Notizen), ein optionales
  Objective (z. B. Objective-Index 15, angezeigt ab Stage 10, ohne Stage-Nummer zu belegen), ein
  `GetItemCount`-Check bei Torbjorn. Kein neues Script nötig, nur CK-Bedingungen.
- **Braucht Codex:** drei kurze Notiztexte + eine Torbjorn-Zeile (`docs/codex/2026-09-27-Q02-Torbjorns-Ledger.md`).

### [Vorschlag] Nebenaufgabe B – „The Assemblage's Due“
- **Idee:** Drinks-the-Brine erzählt (nach erfolgreichem Persuade/Bribe in Stage 10), dass Haldors
  Schuldeneintreiber der Argonierin Scouts-Many-Marshes (vanilla, `ScoutsManyMarshesREF`) ein
  Erbstück abgenommen hat. Der Spieler kann es zurückholen (Haldor durchsuchen, sobald er nach
  Stage 30 – falls gerettet – kurz erreichbar ist, oder bei einem generischen „Schuldeneintreiber“-
  Container). Rückgabe an Scouts-Many-Marshes über den optionalen `AssemblageWitnessAlias` schaltet
  eine zusätzliche, warmherzige Ambient-Zeile im Argonian-Assemblage-Viertel frei und erhöht
  spürbar (aber ohne Statuswert) die Sympathie der Szene – rein atmosphärisch, kein Gameplay-Effekt
  auf Sings.
- **Umsetzung:** ein Fetch-Item (`NHV_Item_Q02_FamilyLocket`, MiscItem), ein optionales Objective,
  keine neue Zelle, kein neuer Vanilla-NPC. Nutzt nur die bereits im Assemblage vorhandenen
  Vanilla-Actors über einen optionalen Alias.
- **Braucht Codex:** zwei bis drei Zeilen (Drinks-the-Brine erzählt vom Erbstück, Scouts-Many-
  Marshes bedankt sich) – `docs/codex/2026-09-27-Q02-Assemblage-Erbstueck.md`.
- **Risiko:** Diese Nebenaufgabe berührt den Argonian-Assemblage-NPC über einen optionalen Alias.
  Sollte ein Kompatibilitäts-Mod diese vier NPCs stark verändern (z. B. Ortstausch), bleibt der
  Alias durch „Optional“ wirkungslos statt die Quest zu blockieren.

Beide Vorschläge sind bewusst **nicht** in den unten gelieferten Scripts fest verdrahtet – sie sind
als CK-Anleitung mit Bedingungen vorbereitet (Abschnitt „Optional, Entwickler-Entscheidung“ in
`docs/ck/M2.2-Q02-CK-Anleitung.md`), damit der Entwickler sie unabhängig bauen oder weglassen kann.

## 8. Items und Dokumente

| Item | Typ | Verwendung |
|---|---|---|
| `NHV_Note_Dispatch02` (Book, `OculatusDispatch02`) | bereits in `Books.csv` (`NHV_SYS_BOOK_82`) | Oculatus-Fragment 2, in Aelius' Pult, Stage 70 |
| `NHV_Item_Q02_FamilyLocket` [Vorschlag] | MiscItem, neu | Fetch-Item Nebenaufgabe B |
| drei Notizbücher „Harbor Log“ [Vorschlag] | Book, neu | Nebenaufgabe A |
| Rekruten-Bonus (analog `BogwifesKnife` bei Q01) | **offen** | Konzept nennt für Q02 keinen Judgement-Gegenstand; siehe offene Frage Abschnitt 9 |

## 9. Fehlerfälle, Randbedingungen, offene Fragen

- **Sings stirbt versehentlich vor Stage 70:** `NHV_ContractRecruitAliasScript.OnDeath()` (bestehend,
  reusable) meldet `RecruitDied()` an `NHV_Q02Script` → `STATUS_KILLED`, Cutscene-Lock wird als
  Sicherheitsnetz aufgehoben, Quest kann nicht weiterlaufen (analog Q01, dokumentiert in Q00-Watchdog-
  Mustern).
- **Haldor stirbt versehentlich (Spieler tötet ihn z. B. aus Versehen in der Nachtszene):** Zählt wie
  „nicht gerettet“ (`NHV_Q02_HaldorSaved = 0`), Sings-Pfad bleibt Beschattung.
- **Aelius wird vom Spieler vor Stage 60 getötet (z. B. Zufallsbegegnung):** Bricht die Prüfung; ohne
  Aelius kann Stage 60 nicht wie geplant ablaufen. **[Vorschlag]** Fallback-Fragment prüft
  `AeliusAlias.GetActorRef().IsDead()` beim Betreten von Stage 60 und leitet auf eine vereinfachte
  Textvariante um („Someone already took him. Sithis moves faster than I do.“) – braucht eine
  Codex-Zeile, ist aber nötig, damit die Quest nicht softlockt.
- **Spieler tötet Sings während der Beschattung (Stage 40) statt ihn zu stellen:** identisch zum
  ersten Fall (`RecruitDied()`), Ergebnis wie „Silence ohne Judgement-Dialog“ – Debrief-Zeile
  `NHV_Q02_100_03` passt inhaltlich, sollte aber nicht Bedingung `NHV_Q02_Result == 2` voraussetzen,
  wenn `NHV_Q02_Result` in diesem Fall nie gesetzt wurde. **Offene Frage an den Entwickler:** Soll
  `RecruitDied()` künftig auch `NHV_Q02_Result` setzen (Erweiterung der Basisklasse wäre nötig, aber
  diese darf laut Auftrag nicht verändert werden, da sie von Q01–Q05 gemeinsam genutzt wird) – bitte
  in `docs/DECISIONS.md` klären, ob `NHV_ContractBaseScript` dafür freigegeben wird oder jede
  Story-Quest ihr Result-Global selbst im Fragment nachzieht.
- **Rekruten-Belohnungsgegenstand:** bereits an anderer Stelle entschieden und gefunden:
  `docs/concept/Q02-Gegenstaende-und-Lore.md` und `docs/ck/M2.1-Q02-Gegenstaende-und-Drowned-Pool.md`
  (beide während dieser Session bereits im Repository vorgefunden, nicht von diesem Arbeitspaket
  verfasst) legen `NHV_Armor_ShadowscaleWraps` fest (Waterbreathing + Fortify Sneak 15 %, Übergabe
  im Debrief, nur beim Recruit-Ausgang). `NHV_Q02Script.GiveRecruitReward()` wurde entsprechend
  ergänzt (Aufruf aus dem Stage-100-Debrief-Fragment, siehe CK-Anleitung Abschnitt 7).
  **Abzugleichender Widerspruch:** `M2.1-Q02-Gegenstaende-und-Drowned-Pool.md` geht davon aus, dass
  die Q02-Dialogzeilen `NHV_Q02_070_02/03/05` und `100_10/11` ein Global `NHV_Q02_FragmentFound`
  prüfen. Das tatsächliche, bereits vorliegende `dialogue/Q02.csv` prüft dort aber
  `GetItemCount NHV_Note_Dispatch02 >= 1` (Item-Besitz), kein solches Global. Dieser Plan folgt der
  CSV (Quelle der Wahrheit für Dialog) und liefert die Übergabe über die bestehende, für Q01-Q05
  gemeinsame Funktion `NHV_ContractBaseScript.GiveFragmentIfMissing()`. Der Entwickler sollte
  `M2.1-Q02-Gegenstaende-und-Drowned-Pool.md` daraufhin prüfen und `NHV_Q02_FragmentFound`
  entweder verwerfen oder die CSV-Bedingungen entsprechend anpassen (nicht Teil dieses
  Arbeitspakets, da CSV-Änderungen tabu sind).
- **`NHV_Q02_Flag_VeyraDisapproval`:** Das Konzept verwendet „VeyraDisapproval“ als wiederkehrenden
  Begriff über mehrere Quests (Q02 Ausliefern, Q03 Übergabe ans College, Q04 Greedy). Es ist unklar,
  ob das ein einziges globales Flag/Counter-System sein soll oder pro Quest getrennte Flags. **Offene
  Frage für `docs/DECISIONS.md`**, da eine gemeinsame Lösung `NHV_CoreScript` oder ein neues
  System-Quest beträfe – außerhalb dieses Arbeitspakets. Bis dahin: quest-lokales
  `NHV_Q02_Flag_VeyraDisapproval`.
- **Zeitfenster-Bug-Falle:** Laut `docs/CONVENTIONS.md` produziert der deutschsprachige
  Papyrus-Compiler bei konstanten Float-Multiplikationen (z. B. `450.0 * 450.0`) Fehlwerte. Alle
  Distanzprüfungen in den neuen Scripts verwenden `GetDistance()` direkt (kein Quadrat), analog
  `NHV_Q01Script.CampAmbushRadius`.

## 10. Kompatibilitätsrisiken

| Risiko | Einschätzung | Gegenmaßnahme |
|---|---|---|
| Windhelm-Stadt-Overhauls (JK's Windhelm, Cutting Room Floor, Windhelm-Erweiterungen) | **hoch** – `WindhelmDocksExterior01` hat bereits `override_depth=4` in der Basis-Load-Order | Nur additive Referenzen, keine Bearbeitung bestehender Statics/Licht/Navmesh; neue Ladetür an einer Stelle platzieren, die in gängigen Hafen-Overhauls typischerweise frei bleibt (Entwickler prüft im CK gegen sein eigenes Modliste) |
| Diebesgilden-Hauptquest (East Empire Company) | mittel, falls Aelius dort untergebracht würde | Bewusst vermieden: eigene Mini-Zelle statt Erweiterung von `WindhelmEastEmpireCompany` |
| Argonian-Assemblage-Mods (z. B. „Argonian Overhauls“, Rasse/Look-Mods) | niedrig–mittel | Nur optionale Aliase auf vorhandene NPCs, keine Fraktions-/Package-Änderung an ihnen |
| AI-Overhauls (Nachtpackages) | niedrig | Alias-Packages haben laut `docs/ARCHITECTURE.md` Vorrang vor NPC-Sandbox-Packages |
| Wache-/Crime-Overhauls (bei „Ausliefern“-Pfad) | mittel | Eigener NPC `Hjorald` statt Umwidmung eines echten Wächters; Bounty-Gold direkt per Script statt über das Crime-System |

## 11. CSV-Abdeckung vs. fehlende Zeilen

`dialogue/Q02.csv` deckt den kompletten Hauptpfad (Stages 10–100, beide Stage-30-Verzweigungen, alle
vier Judgement-Ausgänge) bereits vollständig ab; ebenso `dialogue/Journal.csv` für alle acht
Journal-Einträge und `dialogue/Books.csv` für Oculatus-Fragment 2. **Kein Codex-Auftrag für den
Hauptpfad nötig.**

Fehlend (nur für die optionalen Erweiterungen in diesem Plan):

| Text | Für | Codex-Auftrag |
|---|---|---|
| Fallback-Zeile „Aelius bereits tot“ (Stage 60) | Robustheit gegen Zufallstod | `docs/codex/2026-09-27-Q02-Aelius-Fallback.md` |
| Drei Hafenlog-Notizen + eine Torbjorn-Debriefzeile | [Vorschlag] Nebenaufgabe A | `docs/codex/2026-09-27-Q02-Torbjorns-Ledger.md` |
| Zwei bis drei Zeilen (Erbstück-Nebenaufgabe) | [Vorschlag] Nebenaufgabe B | `docs/codex/2026-09-27-Q02-Assemblage-Erbstueck.md` |

## 12. Claude liefert / Entwickler im CK

**Claude liefert:** diesen Plan, `docs/plan/Q02-Records.md` (Record-Inventar), Spriggit-YAML-Entwürfe
unter `staging/Q02/` (nicht `plugin-text/`), die Papyrus-Scripts `Data/Source/Scripts/NHV_Q02*.psc`,
die CK-Anleitung `docs/ck/M2.2-Q02-CK-Anleitung.md`, die Codex-Aufträge oben.

**Entwickler im CK:** Quest `NHV_Q02` samt Stages/Objectives anlegen, alle in Abschnitt 3–5 genannten
Records (Actors, Zellen, Türen, Marker, Szenen, Packages) anlegen, Eigenschaften der gelieferten
Scripts im CK verbinden, Navmesh für die beiden neuen Interiors bauen, Dialog-Topics aus
`dialogue/Q02.csv` verdrahten (per bestehendem CSV-Import-Workflow), einmal öffnen/speichern nach
jedem Claude-Eingriff an der ESP (Regel 7).
