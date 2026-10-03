# Q02/Q03 Enhanced – Befunde Phase A (Bestandsaufnahme und Design-Review)

Stand: 01.10.2026, Kontroll-Review (Opus) nach `docs/plan/Q02-Q03-Enhanced-Plan.md` Abschnitt 3, Phase A. Es wurde kein Code geändert. Pfade sind relativ zum Repo-Root (Hauptcheckout, Branch `dev`). Schwere: **H** = blockiert den Bau oder führt zu Softlock/falschem Ausgang, **M** = falsches Verhalten oder Nacharbeit im CK, **N** = Doku/Kosmetik.

Kurzfazit: Der Q02-Grundausbau (M2.2) steht im ESP, ist aber vom Enhanced-Draft in Stage-Logik, Veyras Anwesenheit und Fragment-Mechanik so weit entfernt, dass Phase B kein reines „Aufsetzen“ ist. Für Q03 existiert **nichts** im Plugin: keine Quest, keine NPCs, keine Scripts. `tools/build_q03_enhanced.py` erzeugt nur den Lese-Draft, keine Records. In beiden Drafts fehlen mehrere Zustandssetzer und Bedingungen, ohne die einzelne Ausgänge unerreichbar oder frei wählbar sind.

---

## 0. Ausgangslage (geprüft, nicht angenommen)

| Punkt | Befund |
|---|---|
| Q02 im ESP | Quest `NHV_Q02_ColdWaters` 004100: Stages 10/20/30/40/50/60/70/100, 8 Aliase (Player, Veyra ohne Fill, Sings, Torbjorn, Drinks, Haldor, Aelius, Hjorald), 6 NPCs/VoiceTypes (004101–00410C), 16 Globals, 3 Szenen (004125–004127), 23 Branches/50 Topics, 4 Spuren-Activators, 3 Messages, Dispatch-Brief 00411D (= Fragment 2). CK-eigene Records außerhalb 0041xx: Packages 00595E–005960, Leiche 005958, Zellen 0051AB/0057DC, Türen 00519C/0051A9/0057D6/0057DB, Wraps 0057D1, Marker 0057D8/0057D9/005954/005956/005961. |
| Q02-Startauslöser | **Gelöst durch M2.0:** Map Table (Ref 005ECC, `NHV_MapTableScript`) hat `Q02` = 004100 gesetzt, Q01 hat `OpenMapTable()` und die Rückfallzeile `NHV_Q01_100_2811` → `StartQ02FromTable()`. Der Vermerk „Q02-Startauslöser fehlt“ in `docs/PROGRESS.md:65` ist veraltet. |
| Q03 im ESP | Nichts vorhanden (keine Quest, kein NPC, kein Global, kein Script). Property `Q03` am Map Table ist leer (`plugin-text/Cells/0/3/NHV_DeepSanctuaryCell…/RecordData.yaml:6572 ff.`). |
| Q03-Generator | `tools/build_q03_enhanced.py` erzeugt nur `dialogue/drafts/enhanced/Q03/` aus Q03-V2 (LineID +3000). Kein Record-Builder. Für Q02 gibt es keinen entsprechenden Draft-Generator im Repo. |
| Entscheidungsnummern | **E46 und E47 sind bereits vergeben** (Q02-/Q03-Enhanced-Draft, `docs/DECISIONS.md:53-54`). Neue Entscheidungen daher ab **E48**. Außerdem doppelt vergeben: E38 (Tabelle: Veyras Schwert, `:44`; Eintrag `:78`: Q02/Q03-V2) und E45 (`:50` und `:52`). |
| Save-Regel 3 | Gilt ab 0.1.0, das noch nicht getaggt ist (`docs/ROADMAP.md:26`). Q02 ist trotzdem im ESP, und es gibt Test-Saves. Siehe E50. |

---

## 1. Lückenliste

### 1.1 Q02 Cold Waters

**Flow, Zustand und Bedingungen**

| # | Befund | Stelle | Schwere |
|---|---|---|---|
| Q2-01 | **Stage-Rücksprung:** `body`/`watch_plan` (Stage 20) → `tidehouse_intro` (Stage 15) → `night` (30). README und Story-Arc legen Tidehouse **vor** die Leiche. Das Journal (Stage 15 nach 20) und die Objectives werden in falscher Reihenfolge angezeigt. | `Q02/flow.json:179`, `:1127`; `Q02/README.md:12-13`; `Q02/Story-Arc.md:10-11, 28-29` | H |
| Q2-02 | **Salzplatz (35) zwischen Nachtszene (30) und Beschattung (40)** kollidiert mit dem Bau: `EndHaldorDocksScene()` setzt direkt Stage 40 und startet `BeginTailWatch()`; `UpdateTailWatch()` läuft nur bei Stage 40, die Pakete `SingsToHollow`/`SingsFleeHollow` gelten nur bei `GetStage == 40`. Erzählerisch ist eine „unbemerkte Beschattung“ nach dem Umweg über den Salzplatz unlogisch, weil Sings dann längst weg ist. | `flow.json:1159` (salt_yard → tail), `:237`; `Data/Source/Scripts/NHV_Q02Script.psc:336-348, 232-248` | H |
| Q2-03 | **Debrief-Wahl ohne Bedingung:** Die fünf Berichtszeilen (`report_recruit` … `report_surrender`) haben kein `requires` auf `outcome`. Der Spieler kann einen falschen Ausgang berichten. In Q03 ist das richtig gelöst. | `flow.json:899` | H |
| Q2-04 | **Veyras Anwesenheit Stage 50:** Im Draft bleibt Veyra im Hollow bis `authorize` (Zeile 4044 „I will return to Dawnstar“). Der Bau schickt sie nach dem Hollow-Szenenende zurück (`EndVeyraHollowScene` → `CompleteVeyraReturnToSanctuary`). Dadurch sind die Veyra-Antworten von `trial_hub` (`hate`, `trial_wait`, `authorize`) tot. | `flow.json:464, 523`; `Q02.csv:77`; `NHV_Q02Script.psc:424-432` | H |
| Q2-05 | **Sprecherwechsel ohne Szene:** Die Torbjorn-Wahl 4009 („Who else knows the night shifts?“) führt zu einer Antwort von Drinks (4013); danach geht es mit Torbjorns Leichen-Lines weiter. Als Topic-Kette spricht Torbjorn Drinks' Text, oder die INFO hängt an Drinks und ist bei Torbjorn nicht sichtbar. | `flow.json:51, 84`; `Q02.csv:11, 15` | H |
| Q2-06 | **14 Spielerzeilen stehen als lineare Zeilen** in `lines`, nicht als Wahl (tidehouse_intro/encounter, salt_yard, aelius_watch, courier, fragment_player). Sie müssen nach dem E45-Muster zu Ein-Wahl-Hubs werden, mit `default_host` je Hub (Lehre 2). Bei `salt_yard` wechseln Player/Drinks/Enforcer/Player/Enforcer/Drinks/Player ab; das geht nur als Szene mit Spielerphasen oder als Kette mehrerer Hubs. | `flow.json:1127, 1141, 1159, 1209, 1227` | H |
| Q2-07 | **Zustandsflags ohne Leser:** `tidehouseRead`, `sluiceFound`, `aeliusObserved`, `courierInterrupted`, `tracked`, `confessed`, `briefed`, `authorized`, `unproven` und `dead` werden gesetzt, aber nirgends geprüft. Laut Development-Plan darf Stage 30 ohne Ledger nicht starten; das ist nicht abgebildet. Die vier neuen Flags fehlen in `initial`. | `flow.json` (initial, Kopf); `Q02/Development-Plan.md:33` | M |
| Q2-08 | **Aelius-Beobachtung vor oder nach der Autorisierung?** Laut README und Story-Arc liegt sie **vor** der Autorisierung, laut flow, Development-Plan und CK-Anleitung **danach** (`authorize` → `aelius_watch`). | `README.md:17`; `Story-Arc.md:15, 37-38`; `flow.json:523`; `Development-Plan.md:26`; `docs/ck/M2.2-Q02-Enhanced.md:28` | M |
| Q2-09 | **`aelius_wait` (Vertagen) gegen gebauten Kill-Watch:** `BeginKillWatch()` startet die Szene automatisch, sobald der Spieler in 1000 Einheiten Nähe ist, und nach 200 Ticks den Fallback auf Stage 70. Eine Spielerentscheidung „noch nicht“ gibt es nicht. Die Zweige Spieler tötet/Sings tötet sind Weltereignisse ohne Setzer im Flow (Bau: `KillAelius()`/`EndAeliusKillScene(abPlayerKilled)`). | `flow.json:565, 589`; `NHV_Q02Script.psc:463-538` | M |
| Q2-10 | **Konzeptpfad „Aelius lebt“ fehlt** (Draft und Bau): Der Spieler kann die Tat verhindern, der Informant berichtet später und Heat steigt (E28). | `docs/concept/Q02-Chronologische-Geschichte.md:47` | M |
| Q2-11 | **Fallback „Aelius bereits tot“ (`killer=other`):** Der Bau setzt nur Stage 70. Sings steht dann noch im Hollow, aber `desk`/`judgment_other` lassen ihn am Pult sprechen. Es fehlt ein MoveTo bzw. Package für Sings an den Schreibtisch. | `flow.json:536`; `NHV_Q02Script.psc:508-518` | M |
| Q2-12 | **Kurier-Ausgang undefiniert:** Ob der Kurier flieht, kämpft oder stirbt, ist nicht festgelegt. Ein getöteter Kurier des Penitus Oculatus in Windhelm ist ein Verbrechen bzw. Heat. Erscheint er nur, wenn der Spieler das Pult öffnet, oder immer nach Aelius' Tod (Development-Plan:27)? | `flow.json:624, 1227`; `Characters.md:23-31` | M |
| Q2-13 | **Kämpfe mit Dock Enforcers** (Tidehouse, Salzplatz) vor Wache bzw. Hjorald: Nötig ist eine feindliche Eigenfraktion ohne Kopfgeld, und Hjorald darf nicht mitkämpfen oder muss es tun. Nicht spezifiziert. | `flow.json:1141, 1159`; `Development-Plan.md:12` | M |
| Q2-14 | **Speech/Bestechung nur simuliert:** `persuade=true`/`bribe=true` stehen in `initial`. Es fehlen die echten Bedingungen (Speech des Spielers, Gold ≥ 25) und das einmalige Abziehen des Golds. | `flow.json:109, 129` | M |
| Q2-15 | **Fragmentvergabe ohne Spieler-Lesen:** `fragment_recovery` setzt nur `listRead`. Der Bau gibt das Fragment über das Pult (`DispatchDeskRef.Enable()`). Wenn der Spieler die Papiere liegen lässt, bekommt er `OculatusFragment2` nicht, und Q03/Q06 verweisen auf „Fragment 2“. Nötig ist eine einmalige Vergabe im Debrief (`GiveFragmentIfMissing`). | `flow.json:998`; `NHV_Q02Script.psc:543-562` | M |
| Q2-16 | Surrender: Hjorald spricht in derselben Kette direkt nach Sings (4034). Im Bau kommt er per MoveTo und ForceGreet (`JudgeSurrender`). Im Flow muss daraus eine Szene oder ein eigener Einstieg werden. | `flow.json:860`; `Q02.csv:119` | N |

**Items, Bücher und Journal**

| # | Befund | Stelle | Schwere |
|---|---|---|---|
| Q2-17 | **Kaputte Referenz:** `desk.bookLines` verweist auf `NHV_Q02_070_3000/3001` (V2-IDs), die Enhanced-`Books.csv` führt sie aber als `070_6000/6001`. | `flow.json:624`; `Q02/Books.csv:2-3` | H |
| Q2-18 | Tidehouse-Ledger (`070_6200`) hat die Bedingung Stage 70, wird aber in Stage 15 gefunden. | `Q02/Books.csv:4` | M |
| Q2-19 | Für Marsh Hitch, Haldor's Knife, Sluice Token und Imperial Seal gibt es keinen Record-Vorschlag, keinen Fundort und keinen Setzer. Nur der Ledger ist im Development-Plan geführt. | `Items-and-Evidence.md:8-13`; `Development-Plan.md:7-18` | M |
| Q2-20 | Die Journal-Notes sagen „no new Stage“, das Journal führt aber die Stages 15/35/55 ein. Stage-60-Objective „Authorize and witness …“ ≠ gebautes „Help Sings-Beneath-Ice kill Aelius …“ (Konzepttext). | `Q02/Journal.csv:2-27`; Quest-YAML `Objectives` Index 60 | N |
| Q2-21 | Chiffre-Schlüsselbuch (E29): Fundort „Aelius in Q02 oder Livia in Q06“ ist offen. Das Pult in Q02 ist der natürliche Ort. | `docs/concept/Q01-Q06-Roter-Storyfaden.md:65` | M (Entscheidung) |

**Records, Scripts, Packages (gebauter Stand gegen Draft)**

| # | Befund | Stelle | Schwere |
|---|---|---|---|
| Q2-22 | **Lehre 1 akut:** `tools/build_q02_records.py` löscht beim Lauf alle 0041xx-Dateien und schreibt die Quest 004100 neu. Die CK-Ergänzungen in diesem Record (Alias-Packages 005960/00595F, Properties 005954/005961/0057D1/0057D8/0057D9/005956) kennt der Generator nicht (grep: 0 Treffer) und würde sie verlieren. **Den Generator nicht mehr laufen lassen.** | `tools/build_q02_records.py:3, 44, 593`; Quest-YAML `:18-22, 87-113, 319-320` | H |
| Q2-23 | Kein Release-Package für Sings, obwohl `JudgeRelease()` sich auf ein CK-Package „leave Windhelm by road“ verlässt. | `NHV_Q02Script.psc:622-625` | M |
| Q2-24 | Die Getter nutzen nur Aliase und haben keinen FormID-Rückfall (Lehre 6, `GetScout`-Muster). | `NHV_Q02Script.psc:103-133` | M |
| Q2-25 | Kein `RearmWatches()`, `OnUpdate` dispatcht über `iWatchMode` (ein Modus). Die neuen Watches (Tidehouse-Kampf, Salzplatz, Kurier) müssen sich dort einreihen (Lehre 9). | `NHV_Q02Script.psc:191-206` | M |
| Q2-26 | Die Pflichtgespräche hängen an ForceGreet-Packages (`BriefGreet`, `SingsHollowGreet`, `SingsJudgeGreet`, `VeyraDebriefGreet`, `HjoraldSurrenderGreet`). Es fehlen Hub-Rückfälle mit Spielerzeile (Lehre 3). | `plugin-text/Packages/NHV_Pkg_Q02_*` | M |
| Q2-27 | Q02 hat kein `OpenMapTable()`-Gegenstück: Nach dem Debrief schickt Veyra den Spieler nicht zum Table (für Q03 nötig, Lehre 4 mit verzögertem Cursor). | `NHV_Q01Script.psc:673-704` als Muster | M |
| Q2-28 | Die Windhelm-Außenzelle `WindhelmDocksExterior01` (00B4B9) ist überschrieben, aber nicht in der E16-Tabelle eingetragen. Salzplatz und Sluice würden weitere Vanilla-Außenzellen berühren. | `plugin-text/Worldspaces/Tamriel…/WindhelmDocksExterior01 - 00B4B9…`; `docs/ARCHITECTURE.md:20-29` | N |
| Q2-29 | Die CK-Anleitung sagt „Globals als Float“, der Generator erzeugt `GlobalShort`. | `docs/ck/M2.2-Q02-Enhanced.md:24`; `tools/flow_compiler.py:751` | N |

**Package-Stage-Tabelle Q02 (gebaut, mit Lücken)**

| Akteur | Package | Bedingung | Lücke |
|---|---|---|---|
| Veyra | BriefGreet (004128) | Stage == 10, BriefDone == 0 | Alias ohne Fill bis Stage-10-Fragment (`FillVeyraAlias`) – ok; kein Hub-Rückfall |
| Veyra | – | Stage 50 | Draft: bleibt bis `authorize`; Bau: Szene + Rückkehr (Q2-04) |
| Veyra | DebriefGreet (00412C) | Stage ≥ 100, DebriefGreeted == 0 | Konkurriert mit Q03-Briefing, wenn Q03 vor dem Q02-Debrief gewählt wird (Q02 ist ab Stage 100 `IsCompleted`, siehe E48) |
| Sings | NightHunt (00595E) | nur Szenen-Package | Stage 10–29 kein eigenes Verhalten (Vanilla-Default) |
| Sings | FleeHollow (005960) | Stage == 40 & HaldorSaved == 1 | Enhanced 35 (Salzplatz) ohne Package |
| Sings | ToHollow (00595F) | Stage == 40 | – |
| Sings | HollowGreet (004129) | Stage == 50, HollowGreeted == 0 | – |
| Sings | – | Stage 55 (neu) | Follow/Travel zu Aelius fehlt; Follow erst ab der Stage, die das Gespräch setzt (Lehre 8) |
| Sings | – (Script-MoveTo) | Stage 60 | Kill-Watch ok; `killer=other` ohne Bewegung (Q2-11) |
| Sings | JudgeGreet (00412A) | Stage == 70, JudgeGreeted == 0 | – |
| Sings | – | Release | Package fehlt (Q2-23) |
| Hjorald | SurrenderGreet (00412B) | Result == 4 | Stage 15 Tidehouse ohne Package/Platzierung |
| Drinks | – | Stage 35 | Bewegung zum Salzplatz fehlt |
| Enforcer/Kurier | – | 15/35/70 | NPCs, Fraktion, Spawn fehlen |

### 1.2 Q03 The Scholar's Sin

| # | Befund | Stelle | Schwere |
|---|---|---|---|
| Q3-01 | **Nichts gebaut:** Quest, Aliase, 5 NPCs (Nirelda, Selveni, Thyra, Straßenüberlebender, Joric), VoiceTypes, Globals, Szenen, Packages, Zellen (Hollowfrost Spire, Wegstation, Resonanzkammer), `NHV_Q03Script`, Map-Table-Property `Q03`. | `plugin-text/` (0 Treffer) | H (Umfang) |
| Q3-02 | **College-Ausgang unerreichbar:** `archmage` und `tolfdir` werden nie gesetzt (`archmage_record` setzt nur `record`), die Judgment-Optionen 4003/4020 verlangen sie aber. Nötig: Bedingung „Spieler ist Arch-Mage“ (Vanilla-Questzustand, nur lesend) und ein Tolfdir-Gesprächssetzer. | `Q03/flow.json:620, 121`; `Q03.csv:95-96` | H |
| Q3-03 | **Prüfungswertung falsch:** Die Effekte setzen `examScore` absolut (q1 = 1, q2_consent = 2, q3 = nichts). Bestehen (`examScore == 2`) hängt damit allein an Q2-„consent“. Konzept und Story-Arc verlangen dagegen „zwei von drei lore-kundigen Antworten“, und die Texte sprechen von Punkten („One point“, „Two points“, 4017 „A useful answer“). Nötig sind zählende Effekte (+1) mit Schwelle ≥ 2. | `flow.json:387, 445, 497, 524`; `Q03.csv:63, 70, 77`; `docs/concept/konzept.md` Q03 „Die Prüfung“ | H |
| Q3-04 | **Abwesender Sprecher Stage 30/35:** In `defenses` und `resonance` spricht Nirelda und bietet Wahlen an. Laut Konzept kommentiert sie „aus der Distanz“, denn sie sitzt erst in Stage 40 bei Joric. Als Hub bei Nirelda sind die Wahlen nicht anwählbar. Nötig: Activator- oder Message-Wahl plus Fern-Szene (Talking Activator) oder Nirelda-Projektion. | `flow.json:226, 1067`; `Q03.csv:35, 153` | H |
| Q3-05 | **Stage-Rücksprünge:** `road` (25) → `tower` (20) und `consent_ledger` (45) → `question_intro` (40). Die Quest existiert noch nicht, darum ist das jetzt kostenlos zu korrigieren. | `flow.json:1055→209`, `:1131→351` | M |
| Q3-06 | **Veyra unterwegs:** Veyra spricht in Winterhold/Tundra (`tower` 4006, `road_resolved` 4261). Begleitet sie den Spieler (Package wie Q01 Stage 20–69) oder nicht? Weder Draft noch Konzept legen das fest. | `Q03.csv:34, 152` | M |
| Q3-07 | Die Debrief-Wahl 4000 („yielded after the fight“) und 4001 („after the examination“) prüft nur `outcome=recruited`, nicht `combatYield`/`examPassed`. Die Flags sind gesetzt, werden aber nie gelesen. | `flow.json:738`; `Q03.csv:106-107` | M |
| Q3-08 | Die Fokusfragment-Route (4351) ist ohne `collegeWitness` bzw. Item wählbar, auch wenn Selvenis Kopie liegen blieb. Ist das Fragment ein eigenes Item oder Teil der Kopie? | `flow.json:1067`; `Items-and-Evidence.md:5-6` | M |
| Q3-09 | **Rätsel „Four Stillnesses“** (Konzept: 4 drehbare Säulen, Reihenfolge Frost/Gift/Klinge/Stille, Script mit Zustandsarray) ist im Draft nur eine Dialogwahl (notes/force/careful). Activators und Script fehlen im Development-Plan. | `flow.json:226`; `konzept.md` Q03 „Das Rätsel“ | M |
| Q3-10 | Ergeben bei 25 % (Bleedout-Handling, „kein Tod möglich“) ist ein Weltereignis ohne Spezifikation. Kein `SetGhost`/Essential-Trick auf Gesprächspartner (Lehre 5). | `flow.json:548, 564` | M |
| Q3-11 | Konzept-Ausgänge mit Gegenständen fehlen im Draft: College-Übergabe → Stab + `VeyraDisapproval`, Release → Abschiedsbrief mit Forschungsnotiz, Recruit → Circlet of the Last Breath (`konzept.md:982`, ROADMAP M2.3). Für Disziplinarakte und Consent Ledger gibt es keinen Buchtext. | `Q03/Books.csv`; `Development-Plan.md:15` | M |
| Q3-12 | `debrief_fragment` hat `when correspondence` ohne `otherwise` und ist nur dank `judgment.requires` sicher; fragil. | `flow.json:824` | N |
| Q3-13 | Konzept-Journaltexte weichen ab: Stage 30 „Get through the Spire's defenses.“ ↔ „Pass the Four Stillnesses.“; Stage 50 „…, or defeat her.“ ↔ „…, or survive it.“ | `Q03/Journal.csv:6, 10`; `konzept.md` Q03-Tabelle | N |
| Q3-14 | Die Arch-Mage-Reaktion Nireldas aus dem Konzept fehlt (nur Urag reagiert). | `konzept.md` Q03 „Schlüsseldialoge“ | N |
| Q3-15 | Ein Doppelpaket Q02-Debrief/Q03-Briefing ist möglich, weil der Map Table Q03 nur an Q01 Stage 100 knüpft (siehe E48). | `NHV_MapTableScript.psc:41, 70-80` | M |

**Package-Stage-Tabelle Q03 (Soll aus dem Draft, alles fehlt)**

| Akteur | Stage | Bedarf |
|---|---|---|
| Veyra | 10 | Briefing am Table (ForceGreet + Hub-Rückfall) |
| Veyra | 20–25 | Begleiten oder Abwesenheit (E51) |
| Urag/Selveni/Thyra | 10–20 | Sandbox an Ort, Dialog über Alias (keine Vanilla-Änderung) |
| Straßenüberlebender | 25 | Wegstation-Sandbox, nach Auflösung Weggehen/Disable |
| Nirelda | 30–35 | Fernkommentar (Q3-04) |
| Nirelda + Joric | 40 | Beobachtung (Szene), Joric sterbend ohne Ghost |
| Nirelda | 50 | Kampf/Yield; danach Gesprächsbereitschaft |
| Nirelda | 70+ | Recruit → Homecoming Arcanum; College → Reise/Disable; Release → Abreise; Silence → tot |
| Veyra | 100 | Debrief-Greet + Hub, danach Map Table (Lehre 4) |

### 1.3 Übergänge

| # | Befund | Schwere |
|---|---|---|
| T-01 | Q01 → Map Table → Q02 ist gebaut (Script, Ref, Property, Rückfallzeile). Ingame-Test von M2.0 offen. | – |
| T-02 | Q02 → Q03: Es fehlen `Q03`-Property, Q02-Debrief → `OpenMapTable`-Muster und die Rückfallzeile für Winterhold (die Q01-Zeile 2811 startet fest Q02). | M |
| T-03 | Laut Konzept (`konzept.md` Abschnitt 5) sind Q02–Q05 frei wählbar. Q03-Ausgangslage, die Draft-Mermaid („Q02 abgeschlossen“) und die Fragmentnummern 2/3 setzen aber Q02 vor Q03 voraus. Q02-Start sagt dagegen „kein anderer Kernrekrut vorausgesetzt“. | H (Entscheidung E48) |
| T-04 | Die Rückfallzeile im Q01-Debrief kennt nur Windhelm. Bei freier Reihenfolge braucht sie einen generischen Weg („Show me the table again“). | N |

---

## 2. Abweichungen Draft ↔ Konzept ↔ Bau (als Fragen)

1. **Q02-Phasenreihenfolge:** Tidehouse vor oder nach der Leiche (README vs. flow)? Ist der Salzplatz *Ersatz* für die Beschattung (Stage 40) oder ein zusätzlicher Schritt *nach* der Spurensuche? (Q2-01, Q2-02)
2. **Aelius-Beobachtung:** Kommt sie vor der Autorisierung (README/Story-Arc), sodass die Freundlichkeit die Entscheidung belastet, oder danach (flow/Development-Plan/CK-Doku)? (Q2-08)
3. **Veyra in Stage 50:** Bleibt sie bis zur Autorisierung im Hollow (Draft), oder geht sie nach ihrer Szene (Bau)? (Q2-04)
4. **„Aelius lebt“ (Konzept)**: Kommt der Pfad in v1.0, oder bleibt „vertagen“ nur ein Aufschub ohne Ausgang? (Q2-10)
5. **Fragment 2 = Liste = Dispatch 00411D?** Der Draft trennt „Aelius' List“ und „Imperial Seal“, der Bau hat ein einziges Dispatch-Buch. Bleibt es bei einem Item? (Q2-15, Q2-17)
6. **Pult und Schlüsselbuch (E29):** Liegt das Chiffre-Schlüsselbuch bei Aelius? (Q2-21)
7. **Q03-Prüfung:** Zählt „zwei von drei“ (Konzept) oder die gewichtete Wertung des Drafts („Two points“ für consent)? (Q3-03)
8. **Q03-Rätsel:** Kommen echte Säulen-Activators (Konzept), oder reicht die Dialogwahl des Drafts? (Q3-09)
9. **Q03 College-Ausgang:** Wie wird „Arch-Mage“ geprüft, und wie wird „mit Tolfdir“ freigeschaltet (eigenes Tolfdir-Gespräch über Alias)? (Q3-02)
10. **Q03 Belohnungen:** Kommen Stab, Abschiedsbrief und Circlet in den Enhanced-Bau? (Q3-11)
11. **Q03 Veyra-Begleitung:** Begleitet Veyra in Q03 oder nicht? (Q3-06)
12. **Konzept-Journaltexte gegen Draft-Texte** (Q2-20, Q3-13): Welche Fassung gilt?

---

## 3. Entscheidungsliste (E48 ff., Vorschläge; E05/E16/E17 unberührt)

| Nr. | Frage | Empfehlung | Begründung |
|---|---|---|---|
| **E48** | Reihenfolge Q02/Q03: frei (Konzept) oder fest (Draft) | **Fest Q02 → Q03 für v1.0**: Map Table gibt Winterhold erst nach Q02 Stage 100 **und** nach dem Q02-Debrief frei (Flag). Q04/Q05 bleiben später frei. | Fragmentnummern, Q03-Ausgangslage und Debrief-Texte setzen Q02 voraus. Verhindert auch die Debrief/Briefing-Kollision (Q3-15). Freie Reihenfolge würde dynamische Fragmenttexte erfordern. |
| **E49** | Q02-Stagefolge | Reihenfolge **10 Hafen → 15 Tidehouse → 20 Leiche → 30 Nacht → 40 Beschattung/Spur → 45 Salzplatz/Sluice (nur Pfad B „gerettet/entdeckt“) → 50 Hollow → 55 Aelius beobachten → 60 Prüfung → 70 Urteil → 100**. Der Salzplatz ersetzt die Fallback-Spurensuche. | Bestehende Stages, `EndHaldorDocksScene()` und die Stage-40-Packages bleiben gültig (additiv). Der Salzplatz wird kausal („Haldor gerettet → seine Leute suchen das Messer“). Die Beschattung bleibt unmittelbar. |
| **E50** | Q02-Altdialog (50 Topics, 0041xx) beim Enhanced-Bau | **Wie Q01 (E45): Enhanced ersetzt die Alt-Topics**, Quest/NPCs/Globals/Szenen/Packages bleiben. Alte Topics werden entfernt (vor 0.1.0 erlaubt), `build_q02_records.py` wird stillgelegt. Q02-Test-Saves gelten als verbraucht. | Doppelte Dialogsysteme an denselben NPCs erzeugen Konflikte. Regel 3 greift erst ab 0.1.0. |
| **E51** | Veyras Anwesenheit (Q02 Stage 50, Q03 Reise) | Q02: Veyra **bleibt bis `authorize`**, dann Rückkehr (Script-Änderung additiv). Q03: Veyra **begleitet nicht**. Ihre zwei Unterwegs-Zeilen werden zu Briefing- bzw. Debrief-Zeilen oder zum Journal. | Q01 war die Begleitmission. Q03 als Solo-Dungeon entspricht dem Konzept („Dungeon, Magie, Rätsel, Duell“) und spart Follower-Pathing im Turm. |
| **E52** | Aelius-Beobachtung vor oder nach Autorisierung | **Vor** der Autorisierung (Stage 55 zwischen Geständnis und Prüfungsauftrag). Danach `authorize` → Stage 60. | Story-Arc-Leitfrage („Ist Freundlichkeit echt?“) und Konzept („töte einen Mann, der gut zu Argoniern war“) verlangen das Wissen vor der Entscheidung. |
| **E53** | Pfad „Aelius lebt“ | **Nicht in v1.0 als eigener Ausgang**. „Vertagen“ bleibt ein reiner Aufschub mit Hub-Rückkehr. Der Heat-Effekt ist für M3 vorgemerkt. | Fünf Urteilsvarianten plus Heat-Informant würden Q02 deutlich vergrößern. Der Hauptbogen (E28) ist M3. |
| **E54** | Imperial Courier und Dock Enforcers | Enforcer in eigener feindlicher Fraktion (kein Kopfgeld). Der Kurier ist **nicht feindlich**, flieht nach den Spielerzeilen und wird dann deaktiviert. Ein Mord am Kurier ist möglich, wird aber nicht belohnt. Der Kurier erscheint nur, wenn das Pult geöffnet wird. | Kein Kopfgeld-Chaos in Windhelm. Der Kurier bleibt Andeutung (Lore-Grenze), und es entsteht kein Pflichtkampf gegen Penitus Oculatus. |
| **E55** | Fragment 2 und Liste | **Ein Item** (bestehendes `NHV_Note_Dispatch02`, Text um 6000/6001 ergänzen). Das Imperial Seal ist reines Flavour-Misc. Wer das Pult nicht öffnet, bekommt das Fragment einmalig im Debrief (`GiveFragmentIfMissing`). | Hält Q03/Q06-Verweise stabil, keine neue FormID für dieselbe Funktion. |
| **E56** | Chiffre-Schlüsselbuch (E29) | **Bei Aelius im Pult (Q02)**, optional. | Konzept-Option. Q02 ist der erste „Listen“-Fund. Das Buch ermöglicht früh das Selberlösen, der Veyra-Fallback bleibt. |
| **E57** | Q03-Prüfungswertung | **Zählend +1 je tragfähige Antwort, Bestehen ab 2** (je Frage mindestens eine tragfähige Option). „Two points“ in 4010 wird zu einer neutralen Zeile umformuliert (kleine Textarbeit, danach lore-editor). | Konzept und Story-Arc sind eindeutig. Die aktuelle Logik macht zwei Fragen bedeutungslos. |
| **E58** | Q03-Rätsel und College-Ausgang | Vier Säulen-Activators mit Zustandsarray im Script (Konzept). Arch-Mage-Prüfung über den **lesenden** Zustand der Vanilla-College-Questline (keine Vanilla-Änderung). Tolfdir-Freigabe über ein eigenes Q03-Topic an einen Tolfdir-Alias. Stab, Abschiedsbrief und Circlet kommen in den Enhanced-Bau. | Konzept ist Quelle der Wahrheit. Alle drei Punkte sind M2.3-Lieferumfang. |

---

## 4. Lehren aus Plan-Abschnitt 6, die hier konkret einschlagen

| Lehre | Konkrete Stelle |
|---|---|
| 1 Generator löscht CK-Records | `tools/build_q02_records.py` würde CK-Anpassungen an Quest 004100 löschen (Q2-22). Für Phase B/C sollte `clean_range` nur Dateien löschen, deren FormID im eigenen idmap steht, nicht den ganzen Bereich. Der CK-Zähler steht bereits bei ~0x89F2 (Q01-Soldat). Neue Generator-Bereiche (Vorschlag Q02 0xA000–0xAFFF, Q03 0xB000–0xBFFF) bekommen feste Records an einer Stelle, die der Generator nie aufräumt. Vor dem Bau prüfen, wohin das CK als Nächstes vergibt. |
| 2 Stille Zeilen / `default_host` | Q02: 14 lineare Spielerzeilen, 11 Mehrsprecher-Knoten (salt_yard, courier, aelius_watch, tidehouse_encounter …). Q03: 8 Spielerzeilen, davon `road`/`dead_drop`/`consent_ledger` mit wechselnden Gesprächspartnern. Standard-Host wäre sonst Veyra. |
| 3 Kein Hello für Pflichtgespräche | Fünf Q02-ForceGreets ohne Hub-Rückfall (Q2-26), Q03-Briefing/Debrief, Nireldas Fernkommentar (Q3-04). |
| 4 Kettenende überschreibt Cursor | Q02-Debrief → Map Table (T-02), `authorize` → Stage 55/60, Q03 `exam_result`-Verzweigung. |
| 5 Ghost-Flag | Joric (sterbend) und Nirelda (Yield bei 25 %): Bleedout/Essential-Handling ohne `SetGhost`. |
| 6 Optionale Aliase | Q02-Getter ohne Ref-Rückfall (Q2-24). Alle Q03-Aliase neu, mit `Get…()`-Muster von Anfang an. |
| 7 Package-Stage-Lücken | Tabellen in 1.1/1.2: Sings 10–29/35/55/Release, Drinks 35, Hjorald 15, Veyra 50. |
| 8 Follow erst nach Gespräch | Sings → Aelius (Stage 55) erst mit der Stage, die das Gespräch setzt. Ein Q03-Veyra-Follow entfällt bei E51. |
| 9 Ein Timer | `NHV_Q02Script.OnUpdate` mit `iWatchMode`: Neue Watches einhängen und `RearmWatches()` nachrüsten (Q2-25). Q03 von Beginn an mit einem Dispatcher. |
| 10 silent_voice/lint | Q02 hat zusätzlich doppelte Urteiltexte (Lint-Hinweis). Q02-Draft-IDs 070_3000/3001 sind kaputt (Q2-17). |
| 11 kein `cqf` | Testwege für Q02-Stages 15/35/55 und Q03-Säulen/Yield als Debug-Topics oder MCM, nicht per Konsole. |
| 12 Map Table | Property `Q03` im CK setzen, Winterhold-Freigabe nach E48. |
| 15 Konzept zuerst | Q3-02/03/09/11, Q2-10 sind Konzeptpunkte, die der Draft verloren hat. |

---

## 5. Bauumfang-Schätzung

| | Phase B – Q02 Enhanced | Phase C – Q03 Enhanced |
|---|---|---|
| Ablaufknoten (Draft) | 82, davon 50 Wahlzeilen, 20 Weltwahlen, 14 Ein-Wahl-Hubs aus Spielerzeilen | 82, davon 57 Wahlzeilen, 9 Weltwahlen, 8 Ein-Wahl-Hubs |
| Topics/INFOs (Generator) | ca. 80–95 Topics / ~190 INFOs (Q01-Referenz: 30 Draft-Knoten → 86 Topics) | ca. 70–85 Topics / ~175 INFOs |
| Szenen | ca. 9–11 (3 bestehende weiterverwenden: Docks, Hollow, Kill) | ca. 4–6 (Beobachtung, Fernkommentar, Yield, Home) |
| Stages | +3 (15, 45 bzw. 35, 55), Objectives +4 | 8 + 5 Unterphasen (Nummern ohne Rücksprung, Q3-05) |
| NPCs/VoiceTypes | +2/+2 (Dock Enforcer, Imperial Courier), Fraktion +1 | +5/+5 (Nirelda, Selveni, Thyra, Überlebender, Joric), Aliase ~10 (inkl. Urag/Tolfdir) |
| Items/Bücher | Bücher +1–2 (Tidehouse-Ledger, ggf. Schlüsselbuch), Misc +3–4 (Knife, Token, Seal, Hitch) | Bücher +6 (Akte, Margin, Frostfire, Consent, Whisperbane/Fragment 3, Countermark, Abschiedsbrief), Misc +2–3, Armor +1 (Circlet), Weapon +1 (Stab) |
| Zellen/Orte | Tidehouse-Innenraum +1, Salzplatz/Sluice in Vanilla-Außenzelle (E16-Liste) | Spire außen/innen +1–2, Wegstation +1, Map-Marker +2, Navmesh |
| Globals | ~6 Flags + ~5 Cursor | ~12 Flags + ~6 Cursor |
| Packages | +6 (Hjorald 15, Drinks 45, Sings Follow 55, Sings Release, Kurier, Veyra-Halt 50) | +8–10 |
| Scripts | `NHV_Q02Script` additiv ~8–10 Funktionen (Tidehouse-Kampf, Salzplatz, Beobachtung, Kurier, Debrief→Table, RearmWatches, Getter-Fallback), QF-Ergänzung, ~50 TIF/SF generiert, neuer `tools/build_q02_enhanced.py` (~500 Zeilen) | Neu: `NHV_Q03Script` (Säulen-Zustand, Yield, Joric, Prüfungszähler, Urteile, Homecoming), Alias-Scripts Nirelda/Joric, QF, ~50 TIF/SF, `tools/build_q03_records.py`/`build_q03_enhanced.py` (Records), Map-Table-Freigabe |
| CK-Anteil | mittel (Platzierungen Windhelm, Tidehouse-Zelle, Gesichter) | hoch (Dungeon, Navmesh, Rätsel-Activators, 5 Gesichter) |

Reihenfolge laut Plan: Entscheidungen E48–E58 abnehmen → Phase B (Q02) → Ingame-Test → Phase C (Q03).
