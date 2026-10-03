# Entscheidungen – Night's Harvest

Offene Fragen und getroffene Entscheidungen. Claude legt nichts fest, was hier als „Offen“ steht, sondern fragt nach. Getroffene Entscheidungen werden unten als Eintrag dokumentiert und in der Tabelle auf „Entschieden“ gesetzt.

## Übersicht

| Nr. | Frage | Optionen | Empfehlung | Fällig | Status |
|---|---|---|---|---|---|
| E01 | Follower-System | Eigenes System / Vanilla-Slot / Framework-Integration | Eigenes System + MCM-Kompatibilitätsmodus | vor M1 | Offen |
| E02 | Standard-Sterblichkeit der Rekruten | Essential / Protected / Mortal | Protected | vor M1 | Offen |
| E03 | Release-Strategie | Komplette v1.0 / Kapitel-Releases | Komplette v1.0 mit geschlossener Beta | bis Ende M2 | Offen |
| E04 | Plugin-Format | ESP / ESL-geflaggtes ESP | ESP, nach Record-Inventur neu prüfen | Ende M1 | Offen |
| E05 | Master-Dateien | Skyrim.esm + Update.esm / zusätzlich Dawnguard, Dragonborn | Nur Skyrim.esm + Update.esm | in M0 | Entschieden |
| E06 | MCM-Technik | SkyUI direkt / MCM Helper | SkyUI direkt | vor M1 | Entschieden |
| E07 | Einstellungs-Export | Keiner / optional über PapyrusUtil-JSON | Optional, erst in M6 | vor M6 | Offen |
| E08 | Livia-Rekrutierungspfad in v1.0 | Behalten / nach v1.1 | Behalten, erster Scope-Hebel | während M3 | Offen |
| E09 | Pathing Vanilla-Sanctuary | Option B `MoveTo` / Option A Navmesh-Edits | B für v1.0 (bereits so geplant), A für v1.1 prüfen | Ende M1 | Entschieden |
| E10 | Vertonung zum Start | Nur Text / Release erst mit Stimmen | Nur Text, Voice-Pack in v1.1 | vor M6 | Offen |
| E11 | Voice-Pack-Format | BSA mit Dummy-ESL / Loose Files | BSA mit Dummy-ESL | vor v1.1 | Offen |
| E12 | Schreibweise Ingame-Texte | Amerikanisch / britisch | Amerikanisch | vor M1 | Offen |
| E13 | Unique-NPCs im Black Ledger | Erlaubt / verboten | Erlaubt (außer Essential, Blacklist), MCM | vor M4 | Offen |
| E14 | Standard-Wartezeit bis Q00 | 0–7 Tage | 2 Tage | vor M1 | Entschieden |
| E15 | Finaler Mod-Name | „Night's Harvest“ / Alternative | „Night's Harvest“, falls auf Nexus frei | vor M6 | Offen |
| E16 | Zugang Deep Sanctuary | A: Load Door mit Zell-Kopie / B: Script-Tür per `PlaceAtMe` + `MoveTo` | B, wegen `Sanctuary Reborn.esp` in der Load Order | vor M1.3 | Entschieden |
| E17 | ESP-Bearbeitung durch Claude | Nur CK / Claude per MCP oder Spriggit | Claude bearbeitet das ESP, Ein-Schreiber-Regel | vor M0.6 | Entschieden |
| E18 | Status-Wert für getötete Rekruten | 2 (Definition in Konzept Abschnitt 5) / 4 (zwei Stellen im Konzept) | 2 | vor M1.6 | Entschieden |
| E19 | MCM-Texte: Übersetzungsschlüssel in v0.0.1 | Jetzt `$NHV_*`-Keys + Translations-Datei / vorerst Literal-Strings, Umstellung in M6 | Vorerst Literal-Strings | vor M6 | Entschieden |
| E20 | Startbedingung Q00 | Nach „Hail Sithis!“ / nach „The Dark Brotherhood Forever“ (`DBrecurring`) | Nach `DBrecurring`, Wartezeit ab diesem Zeitpunkt | vor M1.9 | Entschieden |
| E21 | Technik für unvertonte Zeilen | Stille Sprachdateien mitliefern / Fuz Ro D-oh voraussetzen | Stille Sprachdateien (`tools/silent_voice.py`) | M1.5 | Entschieden |
| E22 | Ende der Standoff-Befragung | Automatisch nach erster Antwort / nur ausdrückliche Abschlusswahl | Nur ausdrückliche Abschlusswahl | M1.5 | Entschieden |
| E25 | KI-Zugang zur Deep Sanctuary (ändert E09/E16) | Script-Tür ohne Navmesh / echte Ladetür mit Navmesh | Echte Ladetür an einer mod-geprüften Sackgasse | M1.5 | Entschieden |
| E24 | Zugang zur Deep Sanctuary in Q00 | Geröll (Konzept) / magische Verschleierung mit Zwischensequenz | Verschleierung, Zwischensequenz wie der Standoff | M1.5 | Entschieden |
| E23 | Veyras Natur und Bindung an Sithis | Sterbliche Amtserbin / gebundene Nachleserin / wiederkehrende Gestalt / göttliche Verwandtschaft | Tochter Sithis', ungebunden und freiwillig treu; externe Helferin der Night Mother | vor weiterem Mysteriums-Dialogausbau | Entschieden |
| E32 | Q01-Aufbau | Nur CK-Anleitung / komplett per Spriggit | Komplett per Spriggit, nur räumliche Arbeit im CK; einige CSV-Bedingungen technisch ersetzt (Codex-Abgleich offen) | M1.7 | Entschieden |
| E28 | Ermittlung des Oculatus-Zirkels (Hauptbogen) | Heat-Zähler erzählt / sichtbar / ohne Zähler | Verdeckter Heat-Zähler, nur erzählt; im MCM nur als Debug-Wert | M3 | Entschieden |
| E29 | Chiffre der Oculatus-Depeschen | Schlüsselbuch + Veyra-Dialog / Script-Rätsel / nur Flavour | Schlüsselbuch zum Selberlösen, Veyra-Dialog als Fallback | M3 | Entschieden |
| E30 | Interludes für v1.0 | Früh / Spät / Spitzel in Dawnstar / keine | Frühes Interlude („First Blood“), spätes Interlude („Knock at Dawnstar“) und Spitzel-NPC in Dawnstar | M3 | Entschieden |
| E31 | Magischer Faden | Leises Gleaning / + Black-Hand-Relikt / keine Magie | Leises Gleaning (Echos der Toten), innerhalb von E23; kein Relikt in v1.0 | M3 | Entschieden |
| E27 | Quelle der Stimmen | Nur stille Dateien / KI-Stimmen | Vanilla-Figuren über xVASynth, Veyra (und neue Figuren) über ElevenLabs; Import per `tools/voice_import.py` | M1.5 | Entschieden |
| E26 | Charakterprofile und Feuer-Battle-Mage | Nirelda als allgemeine Arkanistin / Feuer-Battle-Mage mit Meistergrad | Fünf Story-Rekruten plus Livia und Missionsfiguren erhalten verbindliche Autorenprofile; Nirelda wird Feuer-Battle-Mage (Destruction Master) | vor Q03-Dialogen | Entschieden |
| E33 | Zusätzliche ungeeignete Rekrutierungen und falscher Kandidat | Nur fünf Kernrekruten / drei optionale Unfit-Ernten / Spion-Twist | Q07–Q09 ergänzen drei optionale Kandidaten; einer ist Oculatus-Spion Lucan Varro unter Edrin Vales Namen; nur Veyra erkennt die Identität zunächst | vor Q07–Q09-Dialogen | Entschieden |
| E34 | Livias Funktion nach geheimer Rekrutierung | Sanctuary-Rekrutin / geheime Oculatus-Schwester | Livia bleibt öffentlich eine angesehene Oculatus-Offizierin und liefert der Brotherhood als `Hidden Sister` verschlüsselte Informationen; kein gewöhnlicher sechster Kernraum | vor Q06-Dialogen | Entschieden |
| E35 | Q00-Zweifel und Luciens Geist | Sofortiger Abschluss / optionaler Zeuge mit späterem Ruf | Stage 80 mit Annahme und zwei Ablehnungen; danach Q01; Lucien bleibt dauerhaft in der Deep Sanctuary | M1.5 | Entschieden |
| E38 | Veyras persönliches Schwert (Unique-Waffe, neues Mesh) | Nur visuell (Veyra trägt es, kein Spieler-Zugriff) / auch später erhältlich | Schwert ist Veyras dauerhafte Standardausrüstung; zusätzlich als lootbares/erhältliches Unique-Item vorgesehen – **Weg der Beschaffung noch offen** (nicht über Veyras Tod, siehe E23/M1.2: ihre Verwundbarkeit durch gewöhnliche Mittel ist unentschieden; eher Fund- oder Belohnungsgegenstand) | vor Einbau in eine Quest | Offen (nur „ob“ entschieden, „wie“ noch nicht) |
| E39 | Haldors Schicksal in Q02 Pfad A (niemand greift ein) | Leiche bleibt auffindbar / verschwindet im Wasser | Leiche bleibt am Pier liegen | M2.2 | Entschieden |
| E40 | Hrefna tötet Quintus (Q01, Stage 50) | Kampf / Attentat | Attentat: ein Dolchstich, Quintus sofort tot; Kill-Move optional | M1.7 | Entschieden |
| E41 | Zeitpunkt von Luciens Beschwörung in Q00 (ersetzt Teile von E35) | Nach dem Contract als Angebot (Stage 80) / Pflicht am Ende des Standoffs | Pflicht am Ende des Standoffs (neue Stage 12), danach Night Mother; Stage 80 entfällt; Lucien verschwindet nicht: Er bleibt von Stage 12 bis 49 sichtbar und ansprechbar in der Vanilla Dawnstar Sanctuary bei den anderen (Änderung 03.10.2026, Entwickler; Package `NHV_Pkg_Sys_LucienSanctuaryIdle`, Radius 600 um `NHV_Mk_Q00_StandoffVeyra`) und zieht ab Stage 50 dauerhaft in die geöffnete Deep Sanctuary | M1.5 | Entschieden (Stage-12-Texte geliefert, CK/Szene/Ingame offen) |
| E42 | Auswahl der Contracts nach Q01 | Feste Reihenfolge (Q02 direkt nach Q01) / Map Table | Map Table in der Sanctuary; zunächst nur Q02, Q03–Q05 werden später ergänzt | M2 | Entschieden; Design 30.09.2026: Aktivator im Ledger Room, Message-Menü (4 Pins + Abbruch), Freigabe Q01 Stage 100, ein Contract zugleich, Briefing per vorhandenem ForceGreet, siehe `docs/ck/M2.0-Map-Table.md` |
| E43 | Mechanik der V2-Dialoge (Q00, Q01, später Q02–Q05) | Quest-Script-Variablen mit `GetVMQuestVariable` / Globals (wie Q02) / handgebaute Topic-Tabellen je Quest | Globals als Zustand: ein Cursor je Gesprächsstrang (Sichtbarkeit der Auswahlzeilen) plus Zustands-Flags; Topics, Szenen und Fragmente erzeugt `tools/flow_compiler.py` aus `flow.json` + CSV; Einstiege als bestehende Szene, `Hello`-Topic, ForceGreet oder Say; Spielerzeilen ohne NPC-Antwort als INFO mit leerem Response-Text | M1.5, M1.7 | Entschieden (Entwickler bestätigte Quest-Variablen-Konzept, Umsetzung als Globals wegen `GetGlobalValue`-Praxis im Projekt); Hello-Topics und stille INFOs ingame zu bestätigen |
| E45 | Q01 Enhanced ersetzt Q01 V2 | V2 behalten / Enhanced-Arc (Reedbed, Farm, Wachposten, Scout, Quintus-Enthüllung, drei Konfrontationswege) einbauen | Enhanced ist der aktive Q01-Arc; die V2-Küchenszene (Home) bleibt; die linearen Enhanced-Austausche werden zu Ketten aus Ein-Wahl-Hubs (Generator `tools/build_q01_enhanced.py`); Veyra begleitet den Spieler in Stage 20–69 (Package); Hrefna folgt ab Stage 48; Kartenmarker, Scavenger, Soldaten, Scout, Quintus-Orte sind CK-Objekte, die über Script-Properties angesprochen werden; Wachposten-Soldaten werden per Script feindlich | M1.7 | Entschieden; Ingame-Test und CK-Durchgang offen |
| E44 | Vereinfachungen der V2-Umsetzung | Erst alles Räumliche/Ereignisgesteuerte bauen / mit Näherungen testen | Näherungen für den Erst-Test: „Tagebuch gelesen“ = Buch im Inventar, „Fragment gefunden“ = Item im Inventar, Route Zimmer/Straße = Hrefna/Quintus ansprechen (keine Ortsprüfung), Silence setzt den Tod sofort, Drei-Tage-Fallback entfällt, `initiates` nie wahr, ein Journal-Log je Stage (Teilphasen als zusätzliche Objectives) | M1.5, M1.7 | Entschieden; nach dem Ingame-Test nachschärfen |
| E45 | Q01 Enhanced: Ermittlungsroute und Hrefnas Familienhintergrund | Kurzer Reise-/Mordauftrag mit lebender Tochter / mehrstufige Ermittlung mit Verlustgeschichte | Der separate Enhanced-Entwurf führt Hakan von einer Vermutung über den roten Fährmarker zur Farm, über einen verpflichtenden Watchpost-Kampf und den überlebenden Scout zu Hrefnas Lager. Quintus wird erst nach Widerspruch als Oculatus-Agent enttarnt; Dokumente, ortsabhängige Konfrontationen und die Wahl zwischen Sichern oder Zurücklassen eines Fragmentes folgen. Hrefnas Ehemann starb durch selbstzerstörerisches Trinken unter Schuldendruck, ihre Tochter nach der Belästigung durch Eiriks Angestellten durch Suizid. Aktive Master/V2 bleiben unverändert, bis der Enhanced-Entwurf ausgewählt wird. | M1.7 | Entschieden (Enhanced-Draft; CK/Vertonung offen) |
| E46 | Q02 Enhanced: Ermittlungsvertiefung | Bestehende V2-Kette / zusätzliche Tidehouse-, Salzplatz-, Aelius- und Kurierphasen | Der separate Q02-Entwurf ergänzt nur kausal begründete Schritte: versiegelte Schichtakte vor der Nachtwache, Salzplatz und Sluice als Spur nach Haldors Angriff, Aelius-Beobachtung vor der Prüfung und ein generischer Oculatus-Kurier nach seinem Tod. Neue Orte, NPCs, Items und Globals bleiben bis zur Auswahl des Entwurfs inaktiv; Livia und eine fertige Verschwörung werden nicht enthüllt. | M2.2 | Entschieden (Enhanced-Draft; CK/Vertonung offen) |
| E47 | Q03 Enhanced: Erkenntnis und Grenze | Bestehende V2-Kette / zusätzliche College-Zeugin, Wegstation, Resonanzkammer, Consent-Ledger und Gegenzeichen | Der separate Q03-Entwurf vertieft Nireldas Prüfung kausal: Selveni ergänzt die widersprüchliche College-Akte, eine Wegstation gibt den Opfern eine konkrete Stimme, die Resonanzkammer macht Nireldas Methode spielbar, und das Consent-Ledger bereitet ihre Fragen vor. Das Gegenzeichen erweitert Fragment 3, ohne L.M. oder Sithis vorzeitig zu erklären. Neue Orte, NPCs, Items und Globals bleiben bis zur Auswahl des Entwurfs inaktiv. | M2.3 | Entschieden (Enhanced-Draft; CK/Vertonung offen) |
| E48 | Reihenfolge Q02/Q03 | Fest Q02→Q03 / frei wählbar | Frei wählbar durch den Spieler (Konzept). Nur im Test gilt eine feste Reihenfolge. Q02/Q03-Texte, Debriefs und Fragmenttexte setzen keine Reihenfolge voraus; der Map Table gibt Winterhold unabhängig vom Q02-Stand frei. Betrifft Q3-15/T-03. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E49 | Q02-Stagefolge | Draft-Rücksprung / lineare Folge | 10 Hafen → 15 Tidehouse → 20 Leiche → 30 Nacht → 40 Beschattung/Spur → 45 Salzplatz/Sluice (nur Pfad „Haldor gerettet“) → 50 Hollow → 55 Aelius beobachten → 60 Prüfung → 70 Urteil → 100. Salzplatz ersetzt die Fallback-Spurensuche; bestehende Stages bleiben gültig. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E50 | Q02-Altdialog | Alt-Topics behalten / ersetzen | Wie Q01 (E45): Enhanced ersetzt die 50 Alt-Topics; Quest, NPCs, Globals, Szenen, Packages bleiben. `build_q02_records.py` wird stillgelegt. Q02-Test-Saves gelten als verbraucht (Regel 3 greift erst ab 0.1.0). | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E51 | Veyras Anwesenheit | Veyra im Hollow / Veyra in der Sanctuary | Ab Q02 bleibt Veyra in der Dawnstar Sanctuary; der Spieler berichtet am Ende nur ihr (Debrief dort). Sie verlässt die Sanctuary nicht für den Hollow; Draft-Antworten von `trial_hub` bei Veyra entfallen oder wechseln den Sprecher. Q03: Veyra begleitet nicht. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E52 | Aelius-Beobachtung | Vor / nach Autorisierung | Vor der Autorisierung (Stage 55), danach `authorize` → Stage 60. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E53 | Pfad „Aelius lebt“ | Eigener Ausgang / nur Aufschub | Nicht in v1.0 als eigener Ausgang; „Vertagen“ ist ein Aufschub mit Hub-Rückkehr. Heat-Effekt für M3 vorgemerkt. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E54 | Kurier und Dock Enforcers | Feindlich / nicht feindlich | Enforcer in eigener feindlicher Fraktion ohne Kopfgeld. Kurier nicht feindlich, flieht nach den Spielerzeilen, wird dann deaktiviert, erscheint nur bei geöffnetem Pult. Mord am Kurier möglich, unbelohnt. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E55 | Fragment 2 und Liste | Zwei Items / ein Item | Ein Item (`NHV_Note_Dispatch02`, Text um 6000/6001 ergänzt). Imperial Seal ist Flavour-Misc. Wer das Pult nicht öffnet, bekommt das Fragment einmalig im Debrief (`GiveFragmentIfMissing`). | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E56 | Chiffre-Schlüsselbuch (E29) | Q02 / Q06 | Bei Aelius im Pult (Q02), optional; Veyra-Fallback bleibt. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E57 | Q03-Prüfungswertung | Gewichtet / zählend | Zählend +1 je tragfähige Antwort, Bestehen ab 2 von 3. Zeile 4010 „Two points“ wird neutral umformuliert (danach lore-editor). | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E58 | Q03-Rätsel und College-Ausgang | Dialogwahl / Activators | Vier Säulen-Activators mit Zustandsarray im Script. Arch-Mage nur lesend über Vanilla-Questzustand, Tolfdir-Freigabe über eigenes Topic an einen Alias. Stab, Abschiedsbrief und Circlet kommen in den Enhanced-Bau. | M2.2/M2.3 | Entschieden 01.10.2026 (Entwickler) |
| E59 | NPC-Alltag Q01/Q02 (Packages) | Stehen bleiben / Tagesroutinen | Alle Q01-/Q02-NPCs bekommen Idle-Packages. Schlafen: festes Bett (CK-Bett-Ref), Inn-NPCs (Quintus) freies Bett im Inn. Q02: Drinks nachts im Argonian Assemblage (Vanilla-Zelle 016776, Bett 0C92F3); Sings vor Stage 30 nicht sichtbar (Ref Initially Disabled + Enable per Script); Aelius schläft im Büro; Haldor ab Stage 45 deaktiviert, ab Stage 100 lebend wieder aktiv und läuft am Hafen, tot bleibt er liegen; Hjorald/Haldor ohne Schlaf-Package. Q01: Veyra hält während der Prüfung nicht am Lager (TrialHold bleibt toter Record); ab Stage 100 läuft Veyra in Dawnstar Sanctuary und Deep Sanctuary; Hrefna wartet in Stage 55–69 auf ihrer Farm (Farmtür-Rückweg im CK korrigieren); `NHV_Q01_QuintusAtFarm` wird beim Quest-Reset zurückgesetzt. Details: `docs/plan/Q01-NPC-Packages.md`, `docs/plan/Q02-NPC-Packages.md`. | M2.2 | Entschieden 02.10.2026 (Entwickler) |

### E35 – Q00-Nachgespräch und Lucien

- **Datum:** Entwicklerwunsch 28.09.2026; Dialoglieferung 29.09.2026.
- **Entscheidung:** Nach dem Contract bietet Veyra auf Stage 80 Lucien als Zeugen an. Annahme und beide Ablehnungen beenden Q00 und starten Q01. Nach Ablehnung bleibt der Ruf bei Veyra nachholbar. Lucien wird dauerhafter Bewohner; seine Gespräche liegen auf `NHV_Sys_Sanctuary`.
- **Lore:** Die Bekanntschaft in Cheydinhal ist autorisierte Mod-Fiktion. Lucien bürgt nur für ihre freiwillige Treue zu Sithis; E23 bleibt verborgen. Keine frühere Beschwörung vorausgesetzt.
- **Stand:** CSV-Texte geliefert und gelintet; vorhandener v35-/Record-Vorbau wird weiterverwendet. Dialogeinbau und Ingame-Test offen. Übergabe: `docs/dialogue/Q00-Zweifel-Lucien-2026-09-29.md`.

### Hintergrund E16

Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin. Die Kopie ändert nichts, kann aber Änderungen anderer Mods an derselben Zelle (z. B. Beleuchtung) überdecken, wenn Night's Harvest später lädt. Das betrifft auch Quest-Referenzen in Städten (Q01–Q05). Grundregel unabhängig von E16: Schlüsselszenen in eigenen Innenzellen, berührte Vanilla-Zellen minimieren und in `docs/ARCHITECTURE.md` listen.

## Entscheidungs-Einträge

### E39 – Haldors Leiche in Q02 Pfad A

- **Datum:** 30.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** In der Nachtszene (Stage 30) zieht Sings Haldor ins Wasser, wenn der Spieler nicht eingreift. Bisher tötete kein Script Haldor; er stand nach „Something's got my leg!“ weiter am Pier.
- **Optionen:** A: Haldor stirbt, Leiche bleibt auffindbar. B: Haldor wird deaktiviert („verschwunden“).
- **Entscheidung:** A. Haldor stirbt mit Sings als Täter und bleibt als Leiche am Szenenort liegen.
- **Folgen:** `NHV_Q02Script.KillHaldorInWater()` (neu, additiv), aufgerufen aus `EndHaldorDocksScene()` nur in Pfad A. Pfad B (gerettet) unverändert. CK: keine Änderung nötig; Haldor darf nicht Essential/Protected sein.

### E38 – Q02- und Q03-Dialogrevision als getrennte, inaktive V2

- **Datum:** 29.09.2026
- **Entschieden von:** Entwickler (Folgeauftrag nach Q01 V2)
- **Entscheidung:** Q02 und Q03 erhalten jeweils eigene V2-Ordner unter `dialogue/drafts/`. Die aktiven Q02-Master bleiben unverändert. Für Q03 existiert derzeit kein aktiver `dialogue/Q03.csv`; die neue Datei ist deshalb ein eigenständiger Vorschlag und keine Überschreibung vertonter Zeilen.
- **Folgen:** Lesefassungen und Offline-Vorschauen werden aus den Entwürfen erzeugt. Vor einer Aktivierung braucht jeder Contract einen separaten CK-Abgleich für Topics, Aliase, Szenen, Conditions, Packages und echte Stage-/Papyrus-Logik. Die V2-JSON-Zustände sind keine Produktionsvariablen.

### E37 – Q01-Dialogrevision als getrennte, inaktive V2

- **Datum:** 29.09.2026
- **Entschieden von:** Entwickler (ausdrücklicher Folgeauftrag nach Q00 V2)
- **Entscheidung:** Q01 dramaturgisch und sprachlich überarbeiten, an Q00 anschließen und in `dialogue/drafts/Q01-v2/` separat zum Lesetest bereitstellen. Aktive vertonte Dialoge erhalten; Aktivierung und neue Stimmen erst nach Auswahl der Fassung.
- **Redaktioneller Kern:** Ermittlung vor Geständnis, Geständnis vor Prüfungsangebot, verständliche Gefahr durch Quintus vor Freigabe. Ein Black Sacrament ist keine Aufnahme. Der Listener entscheidet; Veyra schlägt vor und erhält ihr Wissen aus den Berichten. Nacht-/Straßenweg, übernommene Tötung, Unproven, Recruit/Release/Silence und ihre Nachwirkungen bleiben unterscheidbar.
- **Quellenabgleich:** Keine neue Tochter Hrefnas oder endgültige Freilassung Quintus' aus widersprüchlichen Nebenfassungen als bestehende Kernhandlung übernehmen. Konkrete Abweichungen und Unterschiede zum aktiven technischen Stand stehen in der V2-README.
- **Folgen:** Eigene CSV-IDs, getrennte Journal-/Buchtexte, generierte Markdown-/HTML-Lesefassung und geprüftes Ablaufmodell. Keine Änderung aktiver CSV-Master, Scripts, Records, Quest-Stages oder Stimmen. M1.7-Plugin-Arbeit und Ingame-Test bleiben offen.

### E36 – Q00-Dialogrevision als getrennte, inaktive V2

- **Präzisierung nach Lesetest, 29.09.2026:** Auf Entwicklerwunsch beginnt Veyra mit Sithis' Ruf und der Ernte; Name und greifbares Rekrutierungsangebot folgen aus den Reaktionen. Der angebotene Zeuge bleibt bis zum angenommenen Ruf namenlos; erst bei der Erscheinung stellt sich Lucien vor. Nachfrage und Nachhaken zur Macht Veyras erweitern das Mysterium, ohne ihre Herkunft zu erklären. Diese Änderungen gelten ausschließlich für V2, nicht automatisch für die aktive E35-Redaktion.

- **Datum:** 29.09.2026
- **Entschieden von:** Entwickler (ausdrücklicher Auftrag)
- **Kontext:** Die bestehende Fassung ist bereits vertont; ihre Reihenfolge erklärt Veyras Rekrutierungsangebot vor der Zustimmung nicht ausreichend.
- **Entscheidung:** Eine zweite Fassung unter `dialogue/drafts/Q00-v2/` ausarbeiten und separat lesbar/testbar machen. Die aktiven CSV-Master und ihre Sprachdateien bleiben erhalten. Veyras Ziel, Vorgehen und die Entscheidungshoheit des Listeners müssen vor der Zusage verständlich sein; ihre Herkunft bleibt gemäß E23 geheim.
- **Folgen:** Eigene LineIDs und generierte Leseansichten; keine automatische Aufnahme in Plugin-/Voice-Pipelines. Der HTML-Lesetest prüft Gesprächsfolge und Entscheidungen, nicht Skyrim-Verhalten. Auswahl, Aktivierung in einem späteren Test-Build und neue Vertonung stehen noch aus. Betrifft M1.5; bestehende Quest-Stages und Save-Daten werden nicht geändert.


### E28–E31 – Hauptbogen Oculatus

- **Datum:** 28.09.2026, Entwickler (Grundlage: `docs/plan/Hauptbogen-Oculatus.md`, `docs/plan/Hauptbogen-Technik.md`).
- **E28:** Der Oculatus-Zirkel (Livia Maro) ermittelt über die ganze Kampagne mit. Entscheidungen in Q01–Q05 (Beweise liegen lassen, Agenten ausschalten) ändern einen verdeckten Heat-Wert in der System-Quest `NHV_Sys_Oculatus`. Der Wert wird nur erzählt (Veyra, Briefe, Zwischenfälle); im MCM erscheint er nur als Debug-Anzeige.
- **E29:** Die verschlüsselten Depeschen werden zum optionalen Rätsel: ein Schlüsselbuch zum Selberlösen, Entschlüsselung bei Veyra im Dialog als Fallback. Kein Script-Rätsel, das Finale bleibt nie blockiert.
- **E30:** v1.0 bekommt das frühe Interlude „First Blood“, das späte Interlude „Knock at Dawnstar“ und einen Spitzel-NPC in Dawnstar, der die Sanctuary beobachtet und entlarvt werden kann (abweichend von der Planempfehlung, die den Spitzel zurückstellen wollte).
- **E31:** Magie nur als leises Gleaning: Veyra nimmt Echos der Toten wahr (kurze Kommentare, eine Ritual-Szene). Keine Aussage über ihre Herkunft (E23). Kein Black-Hand-Relikt in v1.0.

### E32 – Q01 komplett per Spriggit statt nur CK-Anleitung

- **Datum:** 28.09.2026
- **Entschieden von:** Team-Lead (Auftrag), Claude (Umsetzung)
- **Kontext:** `docs/plan/Q01-Record-Inventar.md` hatte empfohlen, Q01s Dialog/Szenen/NPCs nicht per Hand-YAML anzulegen (fehleranfällig bei Szenen-Phasen, INFO-Verknüpfungen), sondern nur eine CK-Anleitung zu liefern. Der Team-Lead hat diese Vorsichtsnotiz ausdrücklich aufgehoben und verwiesen auf Q00, das genau diesen Weg (Topics/Branches/INFOs/Scenes/Bücher/NPC per Spriggit) bereits erfolgreich und ingame bestätigt gegangen ist.
- **Entscheidung:** Q01 wurde vollständig per Spriggit gebaut (Quest, Global, VoiceTypes, NPCs, Bücher, Waffe, 3 Szenen, 7 Dialog-Branch-Gruppen für alle 101 `dialogue/Q01.csv`-Zeilen). Nur echte räumliche Arbeit (Zellen, Navmesh, FaceGen, Marker-/NPC-Platzierung, das Stage-100-„Complete Quest"-Häkchen) bleibt CK-Arbeit.
- **Zusätzliche Entscheidungen unterwegs** (`dialogue/Q01.csv` ist an ein paar Stellen unvollständig/mehrdeutig gegenüber dem in `docs/plan/Q01-The-Unanswered-Sacrament.md` beschriebenen Ablauf):
  - Stage-70-Bedingungen `GetGlobalValue NHV_Q01_Result == 0` in der CSV verweisen auf einen Global, der nirgends existiert oder gesetzt wird → durch direkte `GetStage`-Bedingungen ersetzt (Stage wechselt beim Auslösen ohnehin auf 100, sperrt die drei Urteils-Topics also zuverlässig).
  - Stage-100-Bedingung `GetGlobalValue NHV_Q01_FragmentFound == ` (Wert fehlte in der CSV) → durch einen echten `GetItemCount`-Check auf `NHV_Item_OculatusFragment1` im Spielerinventar ersetzt.
  - Stage-20-Zeilen mit Hrefna als Sprecherin (`Q01_Farm`-Topic) ergeben vor der ersten Begegnung mit ihr keinen Sinn → als optionaler Zusatz-Branch erst ab Stage 30 verdrahtet, nicht als eigene Stage-20-Zeilen.
  - Mehrere „NPC spricht unaufgefordert zuerst"-Momente (z. B. Hrefnas Stage-40-Eröffnung, Veyras Einwurf mitten im Trial) ohne vorangehende Spielerzeile in der CSV → über `Actor.Say()` aus kleinen neuen `TIF__`-Fragmentskripten erzwungen, statt für jeden dieser Momente eine eigene Szene anzulegen.
  - Quintus' zwei geplante Tötungsvarianten (Zimmer nachts / Straße morgens, laut Konzept) wurden zu einer gemeinsamen, ortsneutralen Szene `NHV_Scn_Q01_03QuintusApproach` zusammengefasst, um den Umfang in dieser Runde handhabbar zu halten.
- **Folgen:** Diese Vereinfachungen sind ein erster, ungetesteter Entwurf (kein Ingame-Test bisher). Vor „Fertig" muss der Entwickler die Trial-/Judgement-Verzweigung und die Say()-Momente im Spiel prüfen; `docs/ck/M1.7-Q01-CK-Anleitung.md` ist entsprechend auf die verbleibende räumliche Arbeit gekürzt.

### E27 – Quelle der Stimmen

- **Datum:** 27.09.2026
- **Entscheidung (Entwickler):** Vanilla-Figuren (Nazir, Babette, Cicero, Night Mother …) werden mit xVASynth vertont, Veyra mit ElevenLabs. Neue Figuren voraussichtlich ebenfalls über ElevenLabs (eigene, nicht geklonte Stimmen).
- **Technik:** Audio mit LineID im Dateinamen nach `voice_in/`, `python tools/voice_import.py` erzeugt `.fuz` (ffmpeg → WAV 44,1 kHz mono → CK-LipGenerator → xWMAEncode). Stille Dateien (E21) bleiben für alle noch nicht vertonten Zeilen.
- **Offen bleiben:** E10 (Release mit oder ohne Stimmen) und E11 (Format des Voice-Packs). Risiko: Stimmen von Vanilla-Sprechern per KI sind auf Nexus umstritten; Inhalte können auf Beschwerde entfernt werden. Vor Release neu bewerten.

### E25 – KI-Zugang zur Deep Sanctuary (ändert E09 und E16)

- **Datum:** 27.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Alle Figuren der Dawnstar Sanctuary sollen die Deep Sanctuary wie einen weiteren Raum betreten können. Mit der Script-Tür (E16, `PlaceAtMe` + `MoveTo`) und ohne Navmesh-Verbindung (E09) geht das nicht; KI braucht eine echte Ladetür mit Navmesh-Anschluss.
- **Optionen:** A Script-Tür beibehalten, B echte Ladetür in der Vanilla-Zelle `DawnstarSanctuary`.
- **Entscheidung:** B, an einer neuen Stelle: eine Sackgasse (Wand bei X 3305.92 / Y 3363.79 / Z 5668.72, Winkel 271.19), die der Entwickler mit allen bekannten Dawnstar-Sanctuary-Mods (Visuals u. a.) geprüft hat – dort steht nichts außer einer Fackel (bleibt). Die Tür `NHV_DeepSanctuaryDoorRef` (003D8B) steht bei X 3296 / Y 3392 / Z 5664, Rotation 91.19° (Türblatt zum Raum bei +X; die genannten Koordinaten sind der Punkt davor, Blick zur Wand 271.19°); sie ist im CK platziert, anfangs deaktiviert und wird am Ende der Stage-40-Zwischensequenz (E24) per Script aktiviert. Gegenstück ist die Ausgangstür der Deep Sanctuary; Navmesh beider Zellen finalisiert.
- **Folgen:** Bewusster, dokumentierter Override der Vanilla-Zelle `DawnstarSanctuary` (eine Tür-Referenz, Navmesh-Finalisierung) – Ausnahme zu Regel 1 laut E16, in `ARCHITECTURE.md` zu listen. Script-Tür (`NHV_SealedPassageDoor`), Script-Rücktür und Geröll-Position wandern bzw. entfallen; Migration für Dev-Saves. Stage 40-Szene und Aufstellung der Familie ziehen an die neue Wand. CK-Anleitung: `docs/ck/M1.5-Q00-Ladetuer-DeepSanctuary.md`.

### E24 – Zugang zur Deep Sanctuary in Q00

- **Datum:** 26.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Das Konzept (Abschnitt 4 und 6, Szene 4) sieht eine eingestürzte Passage hinter Geröll vor, die der Spieler aktiviert. Beim Test bis Stage 50 wünschte sich der Entwickler an dieser Stelle eine feste Zwischensequenz mit allen Figuren.
- **Optionen:** A Geröll wie im Konzept, B durch Magie verborgene Passage, die Veyra (Illusion-Expertin, Abschnitt 3) enthüllt.
- **Entscheidung:** B. Nach „Agreed. We rebuild.“ (Stage 40) stehen Veyra, Nazir, Babette und ggf. Cicero an der Wand. Betritt der Spieler den Raum, läuft wie beim Standoff eine Zwischensequenz mit Steuerungssperre: Szene A `NHV_Scn_Q00_02VeiledPassage` (`040_10–12`), danach erscheint die Tür; Szene B `NHV_Scn_Q00_03EnterDeep` (`050_01`, `050_08–16` ohne Spielerzeile); danach werden alle in die Deep Sanctuary versetzt, Stage 50. Der Urheber des Schleiers bleibt bewusst offen (lore-editor). Nicht „Dispel“ nennen – Skyrim hat keinen Dispel-Effekt, sie durchschaut und löst die Illusion.
- **Folgen:** `040_01, 040_03–05` DEPRECATED; `030_72` und Journal-Notizen `040_02`/`050_07` ohne Geröll; Konzept Abschnitt 6 (Stage-Tabelle, Szene 4) angepasst. Das Geröll bleibt vorerst als sichtbarer Platzhalter bis zum Szenenende. Exakte Positionen folgen im CK.

### E26 – Charakterprofile und Nirelda als Feuer-Battle-Mage

- **Datum:** 27.09.2026
- **Entschieden von:** Entwickler, im Auftrag zur Ausarbeitung der neuen Questfiguren.
- **Entscheidung:** Die fünf Story-Rekruten, Livia Maro und die wichtigen Missionsfiguren erhalten verbindliche Autorenprofile in `docs/concept/Neue-Charakterprofile.md`. Nirelda Aurantil wird als Feuer-Battle-Mage mit Meistergrad in Destruction geführt. Ihre Stärke bleibt durch Magicka, Kollateralschaden, Distanz und ihre charakterliche Fixierung auf Beobachtung begrenzt.
- **Folgen:** `docs/GOAL.md`, Konzept Abschnitt 9 und Q03-Profil aktualisiert. Neue Q03-Dialoge, NPC-Records, Perks und Zauberwerte sind noch nicht erstellt. Das Profil ist Autorenwahrheit; es bestätigt keine neuen TES-Kanonfakten.

### E33 – Drei ungeeignete Ernten und ein Oculatus-Spion

- **Datum:** 28.09.2026
- **Entscheidung:** Die fünf bestehenden Story-Rekruten bleiben der kanonische Kern der Kampagne. Drei zusätzliche optionale Rekrutierungs-Contracts (Q07–Q09) führen Kandidaten ein, die zwar töten können, aber zu stark von Hass, Vergeltung oder persönlichem Nutzen getrieben sind. Sie werden bei Aufnahme als `Unfit` markiert und ersetzen keinen der fünf Kernrekruten.
- **Spion-Twist:** In Q09 ist der scheinbare Kandidat nicht der echte Rekrut. Edrin Vale wurde vom Oculatus gefangen genommen; Lucan Varro trägt seine Identität und spielt den Contract für den Spieler glaubwürdig durch. Nur Veyra erkennt zunächst, dass Name und inneres Echo nicht zusammenpassen. Eine scheinbare Aufnahme erhält den Status `False Harvest` und darf keinen Kernraum übernehmen.
- **Livia-Pfad:** Werden alle drei ungeeigneten Ernten abgelehnt, getötet oder freigegeben und bleibt kein `False Harvest` in der Familie, wird die geheime Livia-Rekrutierung erleichtert. Als Arbeitsregel sinkt der Speech-Schwellenwert von 75 auf 50. Die endgültige CK-Bedingung und die genaue Behandlung eines geretteten Edrin bleiben für die Q07–Q09-Verkabelung offen.
- **Folgen:** Autorenprofile und roter Storyfaden stehen in `docs/concept/Q07-Q09-Nichtgeeignete-Rekrutierungen.md`, `docs/concept/Neue-Charakterprofile.md`, `docs/concept/Q01-Q06-Roter-Storyfaden.md` und `docs/concept/Q06-Chronologische-Geschichte.md`. CSVs, Stages, Globals und Records sind noch nicht erstellt.

### E34 – Livia als geheime Schwester im Oculatus

- **Datum:** 28.09.2026
- **Entscheidung:** Eine erfolgreich rekrutierte Livia zieht nicht dauerhaft als gewöhnliche Sanctuary-Rekrutin ein. Sie behält öffentlich ihren angesehenen Rang im Oculatus und arbeitet innerhalb dieser Organisation als geheime Schwester der Brotherhood.
- **Nutzen:** Livia liefert verschlüsselte Informationen über Truppenbewegungen, Ermittlungen, Haftbefehle, Versorgungslinien und interne Machtkämpfe. Ihr Rang und Zugang sind der eigentliche Lohn des geheimen Pfades.
- **Grenze:** Livia erhält keinen sechsten Kernraum und wird nicht automatisch als normaler Follower behandelt. Briefe, geheime Übergaben und kurze Treffen tragen ihre Informationen; ein späterer Verrat oder Tod benötigt einen eigenen Storyzustand.
- **Folgen:** `docs/concept/Neue-Charakterprofile.md`, `docs/concept/Q06-Chronologische-Geschichte.md`, `docs/concept/Q01-Q06-Roter-Storyfaden.md` und `docs/GOAL.md` führen Livia nun als `Hidden Sister`. Dialoge, verschlüsselte Briefe und Records sind noch offen.

### E23 – Veyra als ungebundene Tochter Sithis'

- **Datum:** 26.09.2026; Grundrichtung durch den Entwickler nach der Lore-Analyse gewählt.
- **Entscheidung:** Veyra ist innerhalb unserer Mod eine Tochter von Sithis. Sie dient ihrem Vater freiwillig, ohne Fraktionsbindung, Zwangspakt oder abzutragende Schuld. Sein Dienst ist ihr einziges übergeordnetes Ziel. Sie ist kein Mitglied der Dark Brotherhood, sondern bietet der Night Mother ihre Hilfe zur Erhaltung und Erneuerung der Bruderschaft an.
- **Natur:** Endgültiger Tod theoretisch möglich, jedoch nicht durch Alter oder gewöhnliche Waffen. Konkrete außergewöhnliche Todesursachen und Verwundbarkeit sind noch offen. Die alte 230-jährige Biografie gilt nicht länger als objektive Autorenwahrheit.
- **Autorität:** Sie respektiert Night Mother und Listener. Ihre über Fraktionen hinausreichende Treue verleiht ihr keinen Rang innerhalb der Brotherhood; die angebotene Zusammenarbeit lässt die Aufnahmeentscheidungen beim Listener.
- **Mögliche Vergangenheit, nicht beschlossen:** Frühere Hilfe für die Morag Tong und ein Treffen mit der lebenden späteren Night Mother. Keine Behauptung, sie sei Sithis' allererste Dienerin oder eines der fünf Kinder aus der Gründungslegende.
- **Kanon/Enthüllung:** Göttliche Herkunft ist unsere Mod-Ergänzung, keine belegte TES-Tatsache. Was Spieler und Figuren davon erfahren, bleibt offen. Entstehungsweise und Mutter ebenfalls offen.
- **Verbindliches Autorenprofil:** `docs/concept/Veyra-Autorenprofil.md`; Hauptkonzept Abschnitt 3 angepasst. Frühere Empfehlung einer gebundenen Nachleserin in `docs/lore/Veyra-Sithis-Chronologie.md` ist als Entwurf vor dieser Entscheidung überholt.
- **Umsetzungsstand:** Konzeptentscheidung dokumentiert; betroffene Dialog-/Buchstellen im Autorenprofil aufgelistet. CSV, ESP, Schutzflags und Scripts noch nicht angepasst. Vor Plugin-Übernahme des Dialogausbaus gegen E23 abgleichen. E02 für die übrigen Rekruten bleibt offen.

### E22 – Standoff: Nachfragen vor der Entscheidung

- **Datum:** 26.09.2026
- **Entschieden von:** Entwickler, ausdrücklich auf die Rückfrage zum Dialogausbau.
- **Entscheidung:** Informationsfragen und Nachfragen dürfen nacheinander gestellt werden. Erst eine ausdrückliche Abschlusswahl beendet die Befragung. Auch das Senken von Nazirs Klinge lässt die Befragung offen.
- **Abschlusswege:** Night Mother befragen (`010_127` → `010_70–73`), vorhandene Drohung (`010_50–52` → `010_70–73`) oder Verweisung (`010_60–62`). Alle führen weiterhin über Stage 15 zum vorhandenen Windpeak-/Night-Mother-Ablauf.
- **Folgen:** `dialogue/Q00.csv` um sechs vertiefende Gesprächsketten ergänzt; automatische Verbindungen von Informationsfragen zur Abschlusskette beim Plugin-Einbau entfernen. Keine neuen Quest-Stages, keine neue Angriffs- oder Überredungsmechanik. Gespräch abbrechen verändert Stage 10 nicht.
- **Umsetzungsstand:** Text und Einbauplan vorhanden; ESP, Fragmente und stille Sprachdateien noch nicht angepasst. Zusätzliche allgemeine Gespräche stehen in `dialogue/Sanctuary.csv`, ab Q00 Stage 100.


### E21 – Technik für unvertonte Zeilen

- **Datum:** 25.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Ohne Sprachdatei zeigt Skyrim eine Antwort nur für einen Sekundenbruchteil, und Szenen-Zeilen werden gar nicht abgespielt (Standoff-Szene lief „leer“, Test 25.09.2026). Fuz Ro D-oh löst das zur Laufzeit, wäre aber eine neue harte Abhängigkeit (Regel 5).
- **Optionen:** A stille Sprachdateien je Zeile mitliefern, B Fuz Ro D-oh voraussetzen.
- **Entscheidung:** A. `tools/silent_voice.py` erzeugt aus `plugin-text/` je NPC-Antwort eine stille `.fuz` (xWMA, ohne Lip-Daten; Dauer = Wörter / 2,5 + 1 s, mindestens 2 s) unter `Data/Sound/Voice/NightsHarvest.esp/<VoiceType>/`. Dateiname nach Engine-Schema `<Quest>_<Topic>_<00+INFO-ID>_<Antwortnummer>`, Quest- und Topic-EditorID zusammen auf 25 Zeichen gekürzt (ohne Topic-EditorID behält die Quest bis zu 25, sonst Quest 10 + Topic 15; aus allen Namen in `Skyrim - Voices_en0.bsa` abgeleitet, 25.09.2026 – die verbreitete „10 + 15“-Regel und houseCARLs Prüfung liegen bei Szenen-Zeilen falsch). Die Dateien sind Build-Artefakte (nicht im Git), `sync_dev.ps1` kopiert sie in die Dev-Kopie, `package.ps1` packt sie unkomprimiert ins BSA.
- **Folgen:** Jede INFO mit NPC-Text braucht einen eindeutigen Sprecher (Speaker oder `GetIsID`) und Antwortnummern ab 1, sonst meldet das Tool einen Fehler. Echte Aufnahmen (E10/E11, Voice-Pack) ersetzen die Dateien später; das Tool überschreibt nur Dateien aus seinem eigenen Manifest. E10 (Vertonung zum Release) bleibt davon unberührt offen.

### E19 – MCM-Texte: Übersetzungsschlüssel in v0.0.1

- **Datum:** 22.09.2026
- **Entschieden von:** Claude (Umsetzungsdetail, keine Design-Abweichung – zur Nachvollziehbarkeit dokumentiert)
- **Kontext:** Konzept Abschnitt 16 sieht `$NHV_*`-Übersetzungsschlüssel für alle MCM-Texte vor (`Interface/Translations/NightsHarvest_ENGLISH.txt`, UTF-16 LE mit BOM), damit das MCM übersetzbar ist. Beim Bau von `NHV_MCMScript` (M1.1, Seiten Status/General) fiel im `papyrus-reviewer` auf, dass die Texte als englische Literal-Strings stehen, nicht als Keys.
- **Optionen:** A: Jetzt auf `$NHV_MCM_*`-Keys umstellen und die Translations-Datei parallel anlegen. B: Für v0.0.1/M1.1 bei Literal-Strings bleiben, Umstellung erst mit dem restlichen Lokalisierungs-Fahrplan in M6 (Polish).
- **Entscheidung:** B – vorerst Literal-Strings. Lokalisierung ist laut Roadmap ohnehin erst ab M6 vorgesehen (Voice-Pack v1.1), eine halbfertige Key-Infrastruktur jetzt wäre ungetestet und zusätzlicher Pflegeaufwand pro neuer MCM-Seite (M1.6+) ohne aktuellen Nutzen.
- **Folgen:** Alle MCM-Texte bleiben bis M6 englische Literale. Vor M6: `Interface/Translations/NightsHarvest_ENGLISH.txt` anlegen und alle `AddXOption*`/`SetInfoText`/`SetTitleText`-Aufrufe in `NHV_MCMScript.psc` (und späteren MCM-Erweiterungen) auf `$NHV_MCM_*`-Keys umstellen. Betrifft M1.1 (jetzt), M1.6/M2/M3/M4 (weitere MCM-Seiten), M6.1 (MCM komplett).

### E06 – MCM-Technik (Bestätigung aus Konzept Abschnitt 16)

- **Datum:** 22.09.2026
- **Entschieden von:** Konzept (Abschnitt 16, bereits vor dieser Session festgelegt), hier nur in die Entscheidungs-Tabelle nachgetragen
- **Kontext:** Tabellen-Zeile stand auf „Offen", obwohl Konzept Abschnitt 16 bereits eindeutig sagt: „Das MCM basiert direkt auf SkyUI (`SKI_ConfigBase`), ohne zusätzliche Abhängigkeit wie MCM Helper." `NHV_MCMScript` (M1.1) ist entsprechend gebaut.
- **Optionen:** A: SkyUI direkt (`SKI_ConfigBase`). B: MCM Helper (zusätzliche Abhängigkeit).
- **Entscheidung:** A, SkyUI direkt – keine neue harte Abhängigkeit über SkyUI hinaus (Regel 5).
- **Folgen:** Keine; nur Status-Korrektur, Umsetzung war bereits konzeptkonform.

Neue Einträge oben anfügen, mit folgender Vorlage:

```markdown
### E<Nr> – <Titel>

- **Datum:** TT.MM.JJJJ
- **Entschieden von:** Entwickler
- **Kontext:** Warum die Frage aufkam (1–3 Sätze)
- **Optionen:** A …, B …
- **Entscheidung:** …
- **Folgen:** Was sich in Code, Records, Doku ändert; betroffene Arbeitspakete
```

### E16 – Zugang Deep Sanctuary

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin, die Änderungen anderer Mods an derselben Zelle überdecken kann. `docs/TOOLING.md` (Abschnitt 6) listet `Sanctuary Reborn.esp` als aktives Mod mit hohem Konfliktrisiko für genau diese Zelle.
- **Optionen:** A Load Door mit Zell-Kopie (einfacher im CK), B Script-Tür per `PlaceAtMe` + `MoveTo` (kein Zell-Override).
- **Entscheidung:** B. Vor Q00 ist an der Wandstelle nur ein Geröll-Activator sichtbar; in Q00 Szene 4 tauscht ein Enable-Parent den Activator gegen eine per Script platzierte Tür, die per `MoveTo` in die Deep Sanctuary führt. Keine Referenz wird in der Vanilla-Sanctuary-Zelle neu angelegt.
- **Folgen:** `docs/ARCHITECTURE.md` (Zell-Kopien-Tabelle bleibt leer), CK-Anleitung für M1.3 muss die Script-Tür statt einer normalen Load Door beschreiben. Betrifft M1.3 (Deep Sanctuary Stufe 1) und M1.5 (Q00 Szene 4).

### E09 – Pathing Vanilla-Sanctuary

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Folgt aus E16 (Script-Tür statt Load Door): Ohne echte Türverbindung gibt es auch keine Navmesh-Kante zwischen den Zellen.
- **Optionen:** A Navmesh-Verknüpfung (echtes Gehen durch die Tür), B `MoveTo` ohne Navmesh-Edit.
- **Entscheidung:** B für v1.0, wie im Konzept vorgesehen. Follower folgen dem Spieler wie gewohnt über die Script-Tür (Catch-up-Teleport des Follower-Systems, M1.6/M2.1), NPC-Packages bleiben im jeweils eigenen Flügel. Option A für v1.1 offen zu prüfen, falls echtes Pendeln gewünscht wird.
- **Folgen:** Keine Navmesh-Änderungen an der Vanilla-Sanctuary-Zelle. Betrifft M1.3 und das Follower-System (M1.6).

### E14 – Standard-Wartezeit bis Q00

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** `NHV_Cfg_StartDelay` braucht einen Startwert zwischen 0 und 7 Tagen nach „Hail Sithis!“.
- **Optionen:** 0–7 Tage, Konzept-Empfehlung 2 Tage.
- **Entscheidung:** 2 Tage, per MCM änderbar.
- **Folgen:** `NHV_Cfg_StartDelay` wird mit Standardwert 2.0 angelegt (M1.1).

### E18 – Status getöteter Rekruten

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Konzept Abschnitt 5 definiert die Werte 0 = unbekannt, 1 = rekrutiert, 2 = getötet, 3 = freigelassen, 4 = Sonderfall (ausgeliefert, verhaftet). Zwei Stellen (Script-Tabelle, Break-Test BT07) nannten für den Tod Status 4.
- **Optionen:** A Status 2 für den Tod, B Status 4.
- **Entscheidung:** A. Tod = 2, Verhaftung und Auslieferung (Q04) = 4.
- **Folgen:** `docs/concept/konzept.md` an den zwei Stellen korrigiert (Export). Das Claude Doc muss der Entwickler ebenfalls anpassen, sonst überschreibt ein neuer Export die Korrektur. Betrifft `NHV_RecruitAliasScript`, `NHV_ContractBaseScript` (M1.6, M1.7) und BT07.

### E17 – ESP-Bearbeitung durch Claude

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Ohne eigene Bearbeitung des ESP wäre der Entwickler der Engpass für Globals, Fraktionen, Quests, Aliase, Packages und Dialog-INFOs. Es gibt MCP-Server und Spriggit (Text → ESP), mit denen Claude Plugins ohne Creation Kit lesen und schreiben kann (`docs/TOOLING.md`, Abschnitt 4).
- **Optionen:** A nur CK, B Claude bearbeitet das ESP (MCP oder Spriggit), Entwickler übernimmt nur den räumlichen Teil im CK.
- **Entscheidung:** B, mit Ein-Schreiber-Regel: CK und Claude bearbeiten das ESP nie gleichzeitig. Nach jedem Eingriff von Claude öffnet der Entwickler das ESP einmal im CK und speichert es, bevor er weiterarbeitet. Zellbau, Platzierung, Navmesh, Beleuchtung, Room Bounds, FaceGen, Lip-Sync und der Ingame-Test bleiben beim Entwickler. Regel 6 (nichts als ingame funktionierend melden) gilt unverändert.
- **Umsetzung:** Zuerst Spriggit (`convert-to-plugin`, Mutagen-Projekt). Ein MCP-Server wird erst nach Prüfung des Quelltexts und ausdrücklicher Freigabe installiert, weil er fremden Code mit Dateizugriff ausführt.
- **Folgen:** `CLAUDE.md` (Regel 7), `docs/ENVIRONMENT.md`, `docs/TOOLING.md`, `README.md` und die Skill `ck-guide` angepasst. Betrifft alle Pakete mit Records ab M0.6; die Spalte „Wer“ in `docs/ROADMAP.md` gilt weiter als Richtwert.

### E05 – Master-Dateien

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Jeder zusätzliche Master (Dawnguard, Dragonborn) macht den Mod von dem DLC abhängig und lässt sich nicht mehr entfernen.
- **Optionen:** A nur `Skyrim.esm` und `Update.esm`, B zusätzlich Dawnguard und Dragonborn.
- **Entscheidung:** A. DLC-Inhalte nur weich über `Game.GetFormFromFile()`.
- **Folgen:** `NightsHarvest.esp` hat genau die Master `Skyrim.esm` und `Update.esm`. Betrifft M0.6 und alle Records, die DLC-Formen brauchen (z. B. Vampire-Lord-Erkennung).

### E20 – Startbedingung Q00

- **Datum:** 25.09.2026
- **Entschieden von:** Entwickler (Vorschlag), Claude (Umsetzung)
- **Kontext:** Ein Sprung mit `setstage DB11 200` überspringt den Umzug nach Dawnstar und alle Weltzustände (Falkreath-Sanctuary bleibt bestehen, Astrid lebt, Nazir/Babette/Cicero fehlen in Dawnstar, Black Door fragt das Passwort). Auch im regulären Spiel beginnt die Sanctuary-Nutzung erst mit `DBrecurring` „The Dark Brotherhood Forever“.
- **Optionen:** A nach „Hail Sithis!“ (bisher), B nach Start von `DBrecurring`.
- **Entscheidung:** B. `NHV_CoreScript.CanStartQ00()` verlangt zusätzlich, dass `DBrecurring` läuft, abgeschlossen ist oder Stage > 0 hat. Die Wartezeit (E14) zählt ab diesem Zeitpunkt; Q00 startet beim nächsten Betreten der Dawnstar Sanctuary.
- **Folgen:** Konzept Abschnitt 2 (Startbedingungen) ist anzupassen. Zum Testen entweder DB regulär spielen (Save nach `DBrecurring` aufheben) oder Q00 per `cqf NHV_Sys_Core StartQ00` aus der Sanctuary heraus starten.
