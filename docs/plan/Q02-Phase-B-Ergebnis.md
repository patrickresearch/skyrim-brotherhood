# Q02 Cold Waters Enhanced – Phase B: Ergebnis (Sonnet-Lauf, Stand 01.10.2026)

Auftrag: `docs/plan/Q02-Q03-Enhanced-Plan.md` Phase B, Entscheidungen E46, E48–E58 (`docs/DECISIONS.md`), Befunde `docs/plan/Q02-Q03-Enhanced-Befunde.md`.
**Nichts hiervon ist ingame getestet.** Das ESP wurde nicht geschrieben (kein `plugin_text.ps1 ToPlugin`, kein `sync_dev.ps1`), es gab keinen Commit. Kontrollen ohne ESP: Abschnitt 8.

## 1. Was gebaut wurde

| Baustein | Stand |
|---|---|
| `tools/build_q02_enhanced.py` | Neuer Generator nach dem Q01-Muster. Aufrufe: `--activate` (CSV-Master, idempotent, frischt eigene Zeilen auf), ohne Argument (nur kompilieren und berichten), `--write` (Records, Fragmente, Quest-Patch, Script-Konstanten, einmalige Entfernung der Alt-Topics). Eigene Unterklasse `Flow` mit **sicherem `clean_range`** (löscht nur Dateien, deren FormID in `tools/flow_ids_Q02.json` steht; Lehre 1). |
| `tools/build_q02_records.py` | **Stillgelegt** (Hinweis im Kopf plus Abbruch beim Start, E50). |
| Dialog | 96 Topics, 75 Branches, 103 INFOs, 13 neue Szenen plus regenerierte Kill-Szene 004127, 98 TIF-/SF-Skripte, 39 Hubs, 2 Greeting-Entries (`tide_enf`, `home`). Alle Texte aus `dialogue/Q02.csv` (Regel 4). |
| Quest 004100 | Stages 10/15/20/30/40/45/50/55/60/70/100 (15/45/55 neu), Objectives mit Index = Stage-Nummer (10…100) plus Event-Objectives 71 (Kurier) und 101 (Fragment vergleichen), Aliase 8 `EnforcerAlias`, 9 `CourierAlias`, 10 `BabetteAlias` (unique), Aliase 3 und 7 (Torbjorn, Hjorald) zusätzlich **Protected**, neue Script-Properties, neu erzeugte QF-Fragmente. |
| `NHV_Q02Script.psc` | Nur additiv (Abschnitt 5). Kompiliert fehlerfrei (`tools/build.ps1`, 100 Skripte, 0 Fehler). |
| `NHV_Q02_StageActivatorScript.psc` | Neue Property `RequiredStageMax` (0 = altes Verhalten). |
| Records | NPCs, VoiceTypes, Fraktion, Bücher, Misc-Items, Follow-Package (Abschnitt 3). |
| CSV | `dialogue/Q02.csv` (189 Enhanced-Zeilen plus 10 Legacy-Zeilen für die tote Szene 004126), `Journal.csv` (alte V1-Zeilen `_90/_98` entfernt), `Books.csv`. `dialogue_lint.py`: 0 Fehler, 6 Warnungen (3× doppelte Urteilstexte aus dem Draft, 2× Journal-Dubletten aus Q00/Q01, 1× Rechtschreibprüfung übersprungen). `silent_voice.py`: 592 Dateien erwartet, 0 Probleme. |
| Archiv | `dialogue/drafts/Q02-v1-archiv/Q02-V1-Texte.csv`: Rekonstruktion der alten 50 Topics aus den Spriggit-Records (der V1-Master `dialogue/Q02.csv` war nicht versioniert und wurde durch die Enhanced-Zeilen ersetzt). |

## 2. Ablauf (E48–E56 umgesetzt)

| Stage | Inhalt | Technik |
|---|---|---|
| 10 | Veyra-Briefing als Hub (Spieleröffner 4090), Torbjorn-Hub (Opener 4003), Drinks-Hub (Opener 4009; Q2-05: die Frage „Who else knows the night shifts?“ geht an Drinks). Persuade = Speech ≥ 30, Bestechung = echte 25 Gold (`PayBribe()`, einmal). | Hubs, Lanes Main/Torb/Drinks |
| 15 (neu) | Torbjorn schickt zur Tidehouse (neue Brückenzeile 4091), Hjorald-Hub (Opener 4093), Dock Enforcers sprechen zuerst (Hello, `tide_enf`) und greifen dann an (`TidehouseHostile()`), Hjorald-Hub „I have the log“ nur mit Ledger im Inventar → Stage 20. | Lanes Hj/Enf, Welt-Bedingung `ledger` |
| 20 | Torbjorn am Körper (Opener 4095), danach Stage 30. | Lane Torb |
| 30 | Nachtszene 004125 unverändert (behält ihre CK-Package-Aktion); nur die Texte der Szenen-Topics 004149/00414B sind ersetzt. | Patch der INFO-Texte |
| 40 / 45 | **Gerettet → Stage 45** (E49), sonst Stage 40 (Beschattung wie gehabt). Stage 45: Salzplatz mit Drinks und Enforcern; „Gewalt“ (spricht man mit dem Enforcer) oder „Schleichen“ (spricht man mit Drinks); die Hollow-Tür akzeptiert 40–45. | Lanes Salt/Enf, Szenen mit Alias 8/4 |
| 50 | Sings allein mit dem Spieler (Opener 4096), Geständnis, Hub; **der Spieler benennt den Aelius-Test** (4602/4604) statt Veyra (E51, Abschnitt 6). | Lane Sings |
| 55 (neu) | Beobachtung **vor** der Autorisierung (E52): Sings folgt (Package, nur Stage 55–59), Szene Aelius/Sings, danach Hub; „authorize“ nur mit `aeliusObserved`. „Vertagen“ = Hub-Rückkehr (E53). | Watch + Szene, Package 0xAF40 |
| 60 | Kill-Szene 004127 (Aelius, Sings); Warten ist erlaubt (kein Tick-Fallback mehr). | `UpdateKillWatch` geändert |
| 70 | Sings am Pult, Desk-Szene je nach Täter (Sings/Spieler/anderer), Kurier nur bei geöffnetem Pult (E54), Listen-Gespräch, Urteil (3 Hub-Varianten je Täter). Der Urteils-Hub ist ab Stage-Beginn bewaffnet. | Szenen per Skript |
| 100 | Debrief bei Veyra in der Sanctuary (E51), Wahlen mit `requires` auf das Ergebnis (Q2-03), Fragment 2 einmalig via `GiveFragmentIfMissing` (E55), Ende → `OpenMapTable()` mit verzögertem Cursor, Fallback „Show me the table.“ (öffnet das Tischmenü, keine Pin-Reihenfolge, E48). | Lane Main |

Entfallen: Draft-Zeilen `050_4023/4024/4025/4026/4028/4029/4030/4032/4044` (Veyra im Hollow, E51). Nicht gebaut: Pfad „Aelius lebt“ (E53).

## 3. Neue und geänderte Records

**Generatorbereich 0xA000–0xAEFF** (belegt 0xA000–0xA12A; Kollisionsprüfung gegen alle FormKeys in `plugin-text/` bestanden; höchste vorherige ID 0x89F2):

| Bereich | Inhalt |
|---|---|
| 0xA000–0xA008, 0xA00A, 0xA00B | Globals: 9 Cursor (`NHV_Q02E_Cursor{Cour,Drinks,Enf,Hj,Home,Main,Salt,Sings,Torb}`), Flags `aeliusObserved` (0xA00A), `courierInterrupted` (0xA00B). Die Draft-Namen `NHV_Q02_TidehouseRead`/`SluiceFound`/… entfallen (siehe Abschnitt 6, Punkt 5). |
| 0xA00C–0xA12A | Branches, Topics, INFOs, 13 Szenen (0xA045/0xA04B Salzplatz, 0xA09A Kurier-Antwort, 0xA0A0 Liste, 0xA0BC/0xA0CB/0xA0DA Übergabe an Hjorald, 0xA106 Babette, 0xA10C Kurier, 0xA113 Beobachtung, 0xA120/0xA123/0xA126 Schreibtisch) |

**Feste Records 0xAF10–0xAF40** (vom Generator geschrieben, nie aufgeräumt):

| FormID | EditorID | Zweck |
|---|---|---|
| 0xAF10 | `NHV_Q02_DockEnforcer` (NPC) | Klon des Marsh Scavenger, nicht unique, Fraktion 0xAF14, unaggressiv bis `StartCombat` |
| 0xAF11 | `NHV_Q02_ImperialCourier` (NPC) | nicht unique, keine Fraktion |
| 0xAF12 / 0xAF13 | `NHV_VoiceDockEnforcer`, `NHV_VoiceImperialCourier` | VoiceTypes |
| 0xAF14 | `NHV_Fac_DockEnforcer` | **ohne Crime-Gruppe** (kein Kopfgeld, E54), bewusst **ohne** Relations-Eintrag: eine Enemy-Relation zur PlayerFaction hätte die Enforcer vermutlich unansprechbar gemacht; Feindschaft kommt per `StartCombat`. |
| 0xAF30 | `NHV_Book_Q02_TidehouseLedger` | Buch (Text 070_6200) |
| 0xAF31 / 0xAF32 / 0xAF33 | `NHV_MISC_Q02_HaldorKnife`, `…SluiceToken`, `…ImperialSeal` | Flavour-Misc (nur Name, Model/Wert im CK) |
| 0xAF34 | `NHV_Book_Q02_CipherKey` | optionales Chiffre-Schlüsselbuch (E56, Text 070_6300) |
| 0xAF40 | `NHV_Pkg_Q02_SingsFollow` | Follow-Package (Template 019B2C), Stage 55 bis <60, in `SingsAlias` |

Geändert: `NHV_Note_Dispatch02` 0x00411D (Text aus 6000+6001; ein Item, E55), Szene 004127 (neu generiert, gleiche FormID, Skript `SF_NHV_Scn_Q02_03Kill_02004127`), die zwei Szenen-Topics 004149/00414B (nur Response-Texte), Quest 004100.

Entfernt (E50): alle Alt-Topics und -Branches 0x412D–0x41B0 außer den Szenen-Topics, die fünf ForceGreet-Packages 004128–00412C (Lehre 3; sie zeigten auf die entfernten Topics) samt Alias-Einträgen, die zugehörigen TIF-Skripte und 84 veraltete stille Voice-Dateien (`silent_voice.py` räumt sie über sein Manifest). **Bleibt als toter Inhalt:** Szene 004126 mit ihren sieben Topics (Veyra im Hollow, E51) und den 10 Legacy-Zeilen in `Q02.csv`; Property `VeyraHollowScene` und `StartVeyraHollowScene()` bleiben (Regel 3), sind aber nicht mehr angeschlossen. Aufräumkandidat vor 0.1.0.

## 4. Geänderte Dateien (Repo)

`tools/build_q02_enhanced.py` (neu), `tools/flow_ids_Q02.json` (neu), `tools/build_q02_records.py` (stillgelegt), `dialogue/Q02.csv`, `dialogue/Journal.csv`, `dialogue/Books.csv`, `dialogue/drafts/Q02-v1-archiv/Q02-V1-Texte.csv` (neu), `Data/Source/Scripts/NHV_Q02Script.psc`, `NHV_Q02_StageActivatorScript.psc`, `QF_NHV_Q02_ColdWaters_02004100.psc` (neu erzeugt), `SF_NHV_Scn_Q02_03Kill_02004127.psc` (regeneriert), `TIF__0200A*.psc` und `SF_NHV_Q02E_*.psc` (neu; die alten `TIF__0200412F…0200419D` entfernt), `Data/Sound/Voice/NightsHarvest.esp/` (stille Stimmen), `plugin-text/` (Quest 004100, DialogTopics, DialogBranches, Scenes, Globals, Npcs, VoiceTypes, Factions, Books, MiscItems, Packages), diese Datei.

## 5. Script-Änderungen `NHV_Q02Script` (Regel 3 eingehalten)

Nichts umbenannt oder entfernt. Neue Properties: `EnforcerAlias`, `CourierAlias`, `BabetteAlias`, `TidehouseLedger`, `TidehouseEnforcerRefs[]`, `SaltYardEnforcerRefs[]`, `SaltYardMarker`, `CourierRef`, generierte `FLOW_*`-Konstanten (Block `BEGIN/END FLOW CONSTANTS`), `REF_*` (FormID-Rückfälle), `OBS_TICK_CAP`.

| Thema | Lösung |
|---|---|
| Lehre 6 / Q2-24 | `ResolveActor(alias, FormID, refill)`: Alias oder platzierte Ref (Sings 5190, Torbjorn 5191, Drinks 5192, Hjorald 5194, Haldor 5195, Aelius 5953). Der Sings-Alias wird nur unter Stage 100 neu gefüllt (CompleteRecruitment leert ihn). Neu: `GetTorbjorn`, `GetDrinks`, `GetCourier`. |
| Lehre 9 / Q2-25 | `OnUpdate` → `RunPendingWork()` (Tisch-Cursor, Tischmenü, verzögerte Szene, Sings verstecken, Release, Kurier ausblenden, Custody, Debrief-/Beobachtungs-/Schreibtisch-Watch) → bisheriger `iWatchMode`-Dispatch (unverändert) → `RearmWatches()` (2,5 s; Debrief-Watch nur 10 s). Verzögerungen laufen über **Tick-Zähler** (keine Echtzeit im Save). `RearmAfterLoad()`/`OnContractLoadGame()` nach dem Laden. |
| Lehre 4 / Q2-27 | `OpenMapTable()` setzt nur ein Flag; der Tisch-Hub (`FLOW_HUB_TABLE`) wird nach 2 s vom Timer bewaffnet. `OpenTableMenu()` öffnet das Menü ebenfalls verzögert (modale Message). |
| E49 / Q2-01/-02 | `EndHaldorDocksScene()`: gerettet → `SetStage(45)`, sonst 40 plus Beschattung. |
| Laufzeit-Patch der CK-Refs | `PatchStageActivators()` (Fragmente 10/15/20/30/45 und nach dem Laden): setzt auf der Leichen-Ref 0x005959 `RequiredStage = 20`/`TargetStage = 0` und auf der Hollow-Tür-Ref 0x0057D4 `RequiredStageMax = 45`. **Nur Notlösung:** der Cast auf das an die Ref gebundene Script kann `None` liefern, solange die Zelle nie geladen war (Log „not found“ im Test prüfen). Die CK-Aufgaben Ä1/Ä2 sind Pflicht. |
| Tidehouse / Salzplatz | `BeginTidehouse`, `FillEnforcerAlias` (leert zuerst den Alias), `EnforcersHostile`, `TidehouseHostile`, `BeginSaltYard` (Drinks zum Marker, Sings nach 6 s in den Hollow), `SaltYardHostile`, `SaltYardSlip`, `PayBribe`. Rettungsweg (Lehre 11): ohne gesetzte `TidehouseEnforcerRefs` übergibt `OnTidehouseBriefed()` das Ledger selbst. |
| E52/E53 / Q2-09 | `BeginAeliusObservation`/`ObsTick`/`FinishObservationWithoutScene` (Timeout als Rückfall); `UpdateKillWatch` ohne Tick-Fallback; `StartAeliusKillScene` unterscheidet „Spieler hat Aelius getötet“ (→ `SingsUnproven`) von „unbekannt“ (→ `AeliusFallback`) und weicht bei fehlender Szene auf Stage 70 aus. |
| Sings stirbt | `HandleSingsDead()` (aus den Watches) und Override `RecruitDied(...)`: stirbt Sings zwischen Stage 30 und 100, wird das Ergebnis „killed“ (Result 2) und der Debrief-Zweig „Sings is dead“ ist erreichbar. |
| E54/E55 | `OnStage70`, `MoveSingsToDesk`, `DeskTick`, `GetKillerKind`, `OnDeskOpened` (Kurier nur bei geöffnetem Pult und gesetzter `DispatchDeskRef`), `CourierFlees` (Confidence 0 plus `StartCombat`, nach ca. 7 s deaktiviert, Objective 71), `GiveFragmentDebrief`. |
| Q2-23 | `JudgeRelease`: Sings wird nach ca. 10 s deaktiviert, kein CK-Package nötig. |
| Surrender | `JudgeSurrender()` läuft im Hook **vor** Hjoralds Zeile (Ergebnis steht fest, auch wenn die Szene nicht startet); `FinishSurrender()` nach der Szene oder nach 8 Ticks. |
| Debrief | `BeginDebriefWatch`/`DebriefTick` nach dem Q01-Muster, ohne `SetDontMove`; Veyra tritt einmal vor den Spieler, danach endet der Watch. |
| `StartVeyraHollowScene()` | Kommentar „RETIRED (E51)“, sonst unverändert. |

## 6. Abweichungen vom Draft (mit Begründung)

1. **Aelius-Test statt von Veyra vom Spieler benannt (E51).** Veyra bleibt in der Sanctuary; ihre neun Hollow-Zeilen sind nicht gebaut. Ersatz: neue Zeilen 4601–4604 (Sings fragt, Spieler benennt Aelius), 4036/4037/4038 sprechen jetzt Sings, 4027/4031/4033/4034 nach dem Lektorat gekürzt. Eine größere Neufassung der Passage gehört an Codex (offene Frage 1).
2. **Stage 15 vor 20 (E49):** neue Brückenzeile 4091 (Torbjorn), Opener 4093/4094/4095; Draft-Zeilen 4200–4215 unverändert. Das Flag `tidehouseRead` entfällt: Stage 20 wird nur über das Ledger-Gespräch erreicht, und eine anders erreichte Stage 20 darf das Körpergespräch nicht sperren.
3. **Spieleröffner statt Hello/ForceGreet (Lehre 3):** neue Opener 4090, 4096, 4092; die fünf ForceGreet-Packages sind entfernt. Hello bleibt nur in `tide_enf` (Enforcer vor dem Angriff) und `home` (Sings im Drowned Pool, verzichtbar).
4. **Journal:** Objective-Index = Stage-Nummer (statt Zeilennummern), damit alte Saves ihre Objective-Zustände behalten; Texte aus den Draft-Journalzeilen, 5009/5010/5011 wegen E51/E52 angepasst; Draft-Stage 35 (Salzplatz) → Stage 45. Die Stage-Logs 15/20 lesen sich wie Ergebnisse (Draft-Texte).
5. **Flags ohne Leser entfernt (Q2-07):** `briefed`, `confessed`, `tracked`, `authorized`, `sluiceFound`, `tidehouseRead`, `dead`, `unproven`, `outcome` werden nicht gebaut. Ergebnis, Täter, Rettung und Fragmentstand kommen aus den vorhandenen Q02-Globals (`Result`, `SingsUnproven`, `AeliusFallback`, `HaldorSaved`, `FragmentFound`) als Welt-Bedingungen.
6. **`flow.json` des Drafts bleibt unverändert;** der Ablauf ist im Generator als Kopie gebaut (die Draft-Datei ist ein Lesetest mit Regieknöpfen).
7. **Release ohne CK-Package** (Disable nach Zähler), **Kurier flieht per Confidence 0**, nicht per CK-Package.
8. **Salzplatz-Wahl über den Gesprächspartner:** Gewalt = mit dem Enforcer sprechen (4306), Schleichen = mit Drinks sprechen (4311). Beide Optionen hängen am jeweils antwortenden NPC (Lehre 2); ein Wahlmenü bei nur einem NPC würde zusätzliche Zeilen brauchen.
9. **Q03-Anschluss (E48):** Der Debrief nimmt keine Reihenfolge an. Nach Q02 Stage 100 gilt der Contract für den Table als beendet; Q03 kann also schon vor dem Q02-Debrief gewählt werden (offene Frage 3).

## 7. Reviews (Phase-D-Vorarbeit)

| Review | Ergebnis und Nacharbeit |
|---|---|
| `lore-editor` (Texte) | Eingearbeitet: 050_4027/4031/4033/4034/4038/4604, Journal 5009–5011, 010_4090, 050_4096, Buch 070_6300 (neuer Text), 6200 (Gedankenstrich), Notes von 6000/6001. **Nicht übernommen:** „ledger“ statt „log“ in 4091/4094/4095 (Hjoralds Draft-Zeilen sagen „watch log“) und „contract“ statt „pin“ in 100_4098 (Veyra benutzt „pin“ am Table). Offene LORE-CHECKs: Pier-Zählregel in 070_6300 passt zu keinem Layout, bis die Zellen stehen; Torbjorn Ice-Vein gegen Vanillas Torbjorn Shatter-Shield (Namensähnlichkeit, aus dem V1-Entwurf übernommen); ob das Schlüsselbuch Dispatch-Fragmente oder nur Aelius' Ostbücher betrifft (E29). |
| `papyrus-reviewer`, Runde 1 | H1 (Echtzeit-Timer im Save) → Tick-Zähler; H2 (Debrief-Dauerpoll) → 10-s-Poll plus Ende nach dem ersten Auftritt; M: Beobachtungs-Watch nur nach Anforderung (`bObsRequested`), `JudgeRecruit` ohne Sings bricht ab statt das Ergebnis zu setzen, Kill-Watch/Beobachtung/Schreibtisch mit totem Sings, Desk-Reihenfolge ohne `DispatchDeskRef`. Alle eingearbeitet. |
| Opus-Kontrollreview (Phase-D-Checkliste) | H1 Stage-15-Sprung über den Leichen-Aktivator → Laufzeit-Patch (`PatchStageActivators`) plus CK-Aufgabe Ä2, `tidehouseRead` entfernt; H2 Sings stirbt → `RecruitDied`-Override; M: Surrender-Hook, Enforcer-Fraktion ohne Relation, `EnforcerAlias.Clear()`, Ledger-Rückfall, `RequiredStageMax` zur Laufzeit, Torbjorn/Hjorald Protected. **Bewusst nicht geändert:** Salzplatz-Wahl am NPC (Abschnitt 6 Nr. 8), toter Code im CK-Package `SingsFleeHollow` 005960 (CK-eigen, bleibt), `CompleteQuest` an Stage 100 vor dem Debrief (gleich wie Q01), `BabetteAlias` ohne Ref-Rückfall (nur optionale Zeile), die fremden Löschungen im Arbeitsbaum (Q00/Q01-Altrecords, nicht aus diesem Lauf: getrennt committen). |
| `papyrus-reviewer`, Delta-Runde | Freigegeben mit Hinweisen, kein H. Eingearbeitet: `RecoverActiveCutscene()` vor `SetStage(100)` in `HandleSingsDead`, Debrief-Poll nur ohne aktives Cutscene-Lock, `FillEnforcerAlias` ohne unnötiges `Clear()`, einmaliger Ledger-Rückfall (`bLedgerGiven`, mit Item-Meldung), `IsDisabled()`-Rückfall beim Kill-Watch, `HasPendingWork()` entfernt, Surrender mit Fade, `PatchStageActivators()` zusätzlich in den Fragmenten 15/20/30/45. Offen gelassen (N): Doppelstart der Kurier-Szene, wenn das Pult während der Desk-Intro-Szene geöffnet wird; `HandleSingsDead` prüft `IsDead()` erneut. |

## 8. Kontrollen ohne ESP

- `tools/build.ps1`: fehlerfrei. `dialogue_lint.py`: 0 Fehler. `silent_voice.py`: 0 Probleme.
- Spriggit-Probelauf **in ein temporäres ESP** im Session-Temp (`convert-to-plugin` mit Ziel im Scratchpad, nicht `Data/NightsHarvest.esp`): erfolgreich; danach `convert-from-plugin` und Vergleich: nur Formatunterschiede (Quoting, Property-Reihenfolge, `MutagenObjectType`-Zeile), keine verlorenen Felder an Q02-Records; die neuen Alias-Flags `Protected` überleben die Rundreise.
- Kopfzeile des Probe-ESP: `NextObjectID = 0xAF41` (Mutagen berechnet sie aus der höchsten FormID). Das jetzige `Data/NightsHarvest.esp` steht auf 0x8F62; Vergleich der Records des jetzigen ESP mit `plugin-text/` vor Phase B: identisch (keine CK-Änderungen, die ein späteres `ToPlugin` verlieren würde), Unterschiede nur die Phase-B-Änderungen.
- Referenzprüfung: alle `XXXXXX:NightsHarvest.esp`-Links in `plugin-text/` zeigen auf vorhandene FormKeys (0 offen).
- Cursor-Prüfung: alle 41 Hub-/Entry-Ordinale werden von einem Fragment, Skript oder einer Szene bewaffnet.

## 9. CK-Aufgaben

Reihenfolge: ESP einmal im CK öffnen und speichern (E17), dann die Aufgaben. **Properties am Quest-Script** (CK: Quest `NHV_Q02_ColdWaters` → Scripts → `NHV_Q02Script` → Properties) bei neuen Refs setzen; alle sind optional, das Script loggt bei fehlender Property und weicht aus.

### NEU ERSTELLEN

| # | Aufgabe | Details |
|---|---|---|
| N1 | **Tidehouse-Innenzelle** `NHV_Q02_TidehouseCell` (Interior) mit Tür von den Windhelm-Docks | Zwei Enforcer-Refs (0xAF10) bei der Akte, Buch-Ref `NHV_Book_Q02_TidehouseLedger` (0xAF30) auf einem Tisch, Licht, Navmesh. Tür **nicht** abschließen (der Schlüssel kommt nur als Dialog). Property `TidehouseEnforcerRefs` (beide Refs, persistent). Solange sie fehlt, übergibt das Script das Ledger selbst. |
| N2 | **Salzplatz** in `WindhelmDocksExterior01` (00B4B9) | XMarker `NHV_Q02_SaltYardMarker` nahe der Hollow-Tür (0057D4), 2–3 Enforcer-Refs (0xAF10), Haldors Messer (0xAF31) am Boden, Sluice Token (0xAF32) bei einem Enforcer oder am Boden. Properties `SaltYardMarker`, `SaltYardEnforcerRefs`. **E16-Eintrag** für die Außenzelle in `docs/ARCHITECTURE.md` nachtragen (Q2-28). |
| N3 | **Kurier** `NHV_Q02_ImperialCourier` (0xAF11) als persistente, **Initially Disabled** Ref neben Aelius' Pult (`NHV_Q02_HarborClerkOfficeCell` 0057DC); Imperial Seal (0xAF33) in sein Inventar | Property `CourierRef`. Ohne `DispatchDeskRef` (existiert: 005954) gibt es keinen Kurier. |
| N4 | **Chiffre-Schlüsselbuch** `NHV_Book_Q02_CipherKey` (0xAF34) im Pult neben dem Dispatch (005954) | optional, E56. |
| N5 | **Gesichter, Outfit, Ausrüstung** für DockEnforcer und ImperialCourier | Beide sind Klone des Marsh Scavenger (Platzhalter). FaceGen exportieren. Model/Wert der Misc-Items 0xAF31–0xAF33 setzen. |

### ÄNDERN (Pflicht; dauerhafte Fassung des Laufzeit-Patches `PatchStageActivators()`)

| # | Aufgabe | Details |
|---|---|---|
| Ä1 | **Hollow-Tür-Ref 0057D4** (Tamriel, persistent): Script-Property `RequiredStageMax = 45` | `RequiredStage` 40 und `TargetStage` 50 bleiben. Ohne den Wert führt der Salzplatz-Pfad (Stage 45) nicht in den Hollow, falls der Laufzeit-Patch ausfällt. |
| Ä2 | **Leichen-Ref 005959** (`NHV_Q02_VictimCorpseRef`): `RequiredStage` 10 → **20**, `TargetStage` 20 → **0** | Sonst würde das Untersuchen bei Stage 10 auf Stage 20 springen und die Tidehouse überspringen. Gleiches gilt für den Aktivator 00411E, falls er platziert wird. |

### KONTROLLIEREN

| # | Prüfpunkt |
|---|---|
| K1 | Quest 004100: Aliase 8/9/10 vorhanden; Properties `EnforcerAlias`, `CourierAlias`, `BabetteAlias`, `TidehouseLedger` gebunden; Stages 15/45/55 mit Journaltext; Objectives 10–101 (Index = Stage); `CompleteQuest` an Stage 100; Aliase 3 und 7 mit Flag Protected. |
| K2 | `SingsAlias` (2): Packages `NHV_Pkg_Q02_SingsFollow` (0xAF40), `…FleeHollow` (005960, jetzt toter Code: Bedingung Stage 40 plus gerettet, der gerettete Pfad geht nach 45), `…ToHollow` (00595F). `VeyraAlias` und `HjoraldAlias` haben **keine** ForceGreet-Packages mehr. |
| K3 | Package 0xAF40: Follow-Template, Ziel Spieler, Bedingungen Q02-Stage ≥ 55 und < 60. |
| K4 | Szene 004127: 4 Phasen, Aliase 6 (Aelius) und 2 (Sings); neue Szenen 0xA045… mit den Aliasen 2/4/8/9/10 (Optional-Flag). |
| K5 | `NHV_Fac_DockEnforcer` (0xAF14) hat keine Crime-Gruppe und keine Relationen; DockEnforcer-NPC trägt die Fraktion. Wer die Enemy-Relation zur PlayerFaction möchte: nach dem Test ergänzen. |
| K6 | Szene 004125 behält ihre Package-Aktion `SingsNightHunt` (nur die Texte der Topics 004149/00414B wurden getauscht). |
| K7 | Marsh Hitch: vorhandenes `NHV_MISC_ReedWalkersKnot` (0057D3) nutzen, kein neuer Record; Fundort an der Leiche prüfen. |
| K8 | Aelius steht nachts in seinem Büro (Zelle 0057DC), sonst hängt die Beobachtung bis zum Timeout. |

## 10. Testhinweise (Vorschlag, nichts getestet)

Test ohne `cqf`: `setstage 004100 <n>` führt das QF-Fragment der Stage aus und bewaffnet den passenden Hub (jedes Fragment setzt seinen Cursor). Debug-Log: `set NHV_Cfg_Debug to 1`; erwartete Zeilen u. a. `EnforcersHostile`, `ResolveActor: an empty alias was filled`, `Debrief watch started`, `OpenMapTable: the table hub is armed`, `PatchStageActivators` nur bei fehlenden Refs. Reihenfolge: 10 (Veyra am Table, Torbjorn „harbor records“) → 15 (Hjorald, Enforcer) → 20 → 30 nachts → 40 oder 45 → 50 → 55 → 60 → 70 (Schreibtisch, Kurier, Urteil) → 100. Ein vollständiger Testplan gehört nach `docs/tests/` (Phase E).

## 11. Offene Fragen und nicht Lösbares

1. **Veyras Rolle beim Aelius-Test (E51).** Konzept und Draft lassen Veyra den Test vorschlagen; jetzt benennt ihn der Spieler. Soll die Autorität stattdessen schon im Stage-10-Briefing oder über einen Zettel am Hollow kommen? Die Zeilen 4601–4604 sind Platzhaltertexte für Codex/Lore-Review.
2. **Wer „autorisiert“ (050_4035/4041)?** Der Spieler ist der Listener; die Zeilen sagen „authorize“. So belassen, bis Frage 1 geklärt ist.
3. **Q02-Debrief und Table (E48):** Nach Stage 100 ist Q02 „completed“; der Table lässt Q03 zu, auch wenn der Q02-Debrief offen ist. Phase C muss das Q03-Briefing so bauen, dass es nicht mit dem offenen Q02-Veyra-Hub kollidiert (verschiedene Quests und Cursor, Veyras Hello-Priorität ungetestet).
4. **Kurier-Flucht:** `Confidence 0` plus `StartCombat` ist ungetestet; greift er an, im CK ein Flee-Package ergänzen. Tötet ihn der Spieler, gibt es weder Kopfgeld noch Belohnung (E54).
5. **Sluice-Marker ohne eigenen Record:** die Hollow-Tür selbst ist der Sluice-Zugang (Draft: „beide Salzplatzwege am selben Übergang“).
6. **`dialogue/voice/Veyra-ElevenLabs.csv`** enthält noch Alt-LineIDs von Q02; Stimmenpakete aus `dialogue/Q02.csv` neu erzeugen.
7. **E16/ARCHITECTURE:** `WindhelmDocksExterior01` (00B4B9) fehlt weiterhin in der E16-Tabelle (Q2-28); Salzplatz und Tidehouse-Tür erweitern den Eingriff.
8. **Stale `.pex`:** `Data/Scripts/` enthält noch Skripte der entfernten Alt-TIFs (nicht versioniert, harmlos; `tools/build.ps1 -Clean` räumt auf).
9. **Journal-Logtexte** der Stages 15/20 lesen sich wie Ergebnisse (aus dem Draft); Codex könnte sie als „Auftrag“-Texte neu fassen.
10. **Nicht aus diesem Lauf, aber im Arbeitsbaum:** viele gelöschte Q00/Q01-Records und -Skripte (361 DialogTopics, 80 Branches, …); getrennt von Q02 committen und vorher bewusst prüfen.
