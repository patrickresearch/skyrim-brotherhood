# Entwicklungs-Roadmap – Night's Harvest v1.0

Stand: 21.09.2026. Spiegelt den Tab „Entwicklungs-Roadmap“ im Konzept-Doc; bei Abweichungen gilt diese Datei für den Arbeitsstand.

## Pflege dieser Datei (für Claude Code)

- Status-Werte: `Offen` → `In Arbeit` → `Test` → `Fertig`.
- Claude setzt `In Arbeit` beim Start und `Test`, wenn alle Text-Lieferungen stehen und kompilieren.
- `Fertig` setzt nur der Entwickler nach bestandenem Ingame-Test.
- Ist-Stunden trägt der Entwickler ein. Neue Arbeitspakete bekommen die nächste freie ID im Meilenstein.
- Exit-Kriterien werden abgehakt (`- [x]`), sobald sie nachweislich erfüllt sind.

## Planungsannahmen

- ca. 15 Stunden pro Woche, 2-Wochen-Sprints mit je ca. 30 Stunden
- Start Montag, 5. Oktober 2026
- Grundkenntnisse im Creation Kit (sonst +40–60 h in M0/M1)
- Solo-Entwicklung im CK; Claude liefert Scripts, Dialog-CSVs, Tools, Anleitungen, Reviews
- M0/M1 auf Sprint-Ebene geplant, spätere Meilensteine auf Arbeitspaket-Ebene (Sprints werden zu Beginn geschnitten)

## Meilensteine

| Meilenstein | Version | Plan (h) | Ist (h) | Zielende | Ergebnis | Status |
|---|---|---|---|---|---|---|
| M0 Setup & Toolchain | 0.0.1 | 30 | 0 | 18.10.2026 | Leeres Plugin mit Script installiert sich per FOMOD in Vortex | Offen |
| M1 Vertical Slice | 0.1.0 | 120 | 0 | 13.12.2026 | Q00 und Q01 vollständig spielbar | Offen |
| M2 Contracts | 0.2.0 | 195 | 0 | 14.03.2027 | Q02–Q05 spielbar, Follower-System komplett | Offen |
| M3 Finale | 0.3.0 | 75 | 0 | 18.04.2027 | Q06 in allen Varianten abschließbar | Offen |
| M4 Black Ledger | 0.4.0 | 60 | 0 | 16.05.2027 | Freies Rekrutieren mit 12 Slots | Offen |
| M5 Lebendige Sanctuary | 0.5.0 | 60 | 0 | 13.06.2027 | Alle Räume, Banter, Tagesabläufe | Offen |
| M6 Polish, Beta & Release | 0.9.x → 1.0.0 | 90 | 0 | 25.07.2027 | Veröffentlichung auf Nexus Mods | Offen |
| Puffer | – | 60 | 0 | 22.08.2027 | Reserve; spätester Release-Termin | – |

Der Dialog-Track läuft parallel: Claude schreibt die CSVs jeweils einen Meilenstein im Voraus.

---

## M0 – Setup & Toolchain

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M0.1 | Spielumgebung sichern | Steam-Updates auf „nur beim Spielstart“, Start über SKSE-Loader, Backup des Spielordners, Clean-Profil in Vortex (SKSE, SkyUI, USSEP) | Entwickler | 3 | Offen |
| M0.2 | Creation Kit | CK über Steam, CKPE einrichten, `Scripts.zip` nach `Data/Source/Scripts` entpacken, `CreationKitCustom.ini` anlegen | Entwickler, Claude (Anleitung) | 4 | Offen |
| M0.3 | Papyrus-Toolchain | VS Code mit Papyrus-Extension, Pyro, `NightsHarvest.ppj` mit Imports (Vanilla, SKSE, SkyUI SDK) | Claude (ppj), Entwickler (Setup) | 4 | Test |
| M0.4 | Repository & Board | Privates GitHub-Repo mit Struktur aus `docs/ARCHITECTURE.md`, `.gitignore`, README, Board mit Labels | Claude (Vorlagen), Entwickler | 3 | In Arbeit |
| M0.5 | Spriggit, xEdit, LOOT | Spriggit installieren, Round-Trip testen, xEdit und LOOT einrichten | Entwickler | 3 | Offen |
| M0.6 | Smoke-Test | `NHV_Sys_Core` (Start Game Enabled) mit `NHV_CoreScript` und Versionsmeldung, Pyro-Build inkl. BSA, Minimal-FOMOD, Installation in Vortex, Ingame-Test | Claude (Script, ESP, FOMOD), Entwickler (CK-Prüfung, Test) | 6 | Test |
| M0.7 | Record-Inventar M1 | Tabelle aller EditorIDs für M1 mit Typ, Zweck, Quest | Claude | 2 | Test |
| M0.8 | Entscheidungen | E05 treffen; E01, E02, E06, E12, E14, E16 bis Start M1 vorbereiten | Entwickler | 1 | Offen |

Reihenfolge: M0.1 → M0.2 → M0.3 → M0.6; M0.4, M0.5, M0.7 parallel.

**Exit-Kriterien**

- [ ] Smoke-Test-Paket installiert sich in Vortex ohne Warnung und zeigt ingame „Night's Harvest 0.0.1 loaded“.
- [ ] Pyro erzeugt Scripts, BSA und Release-Archiv mit einem Befehl.
- [ ] Spriggit-Round-Trip ohne Unterschiede.
- [ ] Repository und Board stehen, erster Commit getaggt (`v0.0.1`).
- [ ] E05 entschieden.

---

## M1 – Vertical Slice

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M1.1 | Core-System | `NHV_CoreScript` (Version, `Maintenance()`, SKSE-Check, Startbedingung, Wartezeit), `NHV_PlayerAliasScript`, `NHV_Cfg_*`-Globals, MCM-Seiten Status und General | Claude (Scripts), Entwickler (CK) | 14 | Offen |
| M1.2 | Veyra | NPC-Record, FaceGen-Export (Strg+F4), Outfit, Trainer, `NHV_VoiceVeyra`, nachtaktive Alias-Packages | Entwickler, Claude (Werte, Packages) | 12 | Offen |
| M1.3 | Deep Sanctuary Stufe 1 | Hall of Whispers, Ledger Room, Memorial Wall, Initiates' Dormitory, versiegelte Passage für Q00 Szene 4, gesperrte Übergänge, Navmesh, Room Bounds, Beleuchtung, Zugang nach E16 | Entwickler, Claude (Raumliste, Anleitung) | 22 | Offen |
| M1.4 | Sanctuary-Aliase | `NHV_Sys_Sanctuary` mit optionalen Aliasen für Nazir, Babette, Cicero, Night Mother; Testfall „Cicero tot“ | Claude, Entwickler | 6 | Offen |
| M1.5 | Q00 A Shadow at the Door | Stages 10–100, Szenen 1–6, Draugr-Passage, Memorial Wall, Journal, Dialoge aus CSV | Claude (CSV, Fragmente), Entwickler (CK) | 30 | Offen |
| M1.6 | Family-Grundgerüst | `NHV_Sys_Family`, Story-Rekruten-Aliase, Status-Globals, `NHV_RecruitAliasScript`, ein Follower-Slot | Claude, Entwickler | 10 | Offen |
| M1.7 | Q01 + Contract-Basis | `NHV_ContractBaseScript` mit Q01 als erster Anwendung; Hrefna, Agent Quintus, Morthal, Fragment 1, Bogwife's Knife, Grundausbau Kitchen | Claude, Entwickler | 20 | Offen |
| M1.8 | Dialog-Pipeline | Lint-Tool v1 (`tools/dialogue_lint.py`), CSV-Eingabe ins CK festlegen, Test mit Fuz Ro D-oh | Claude (Tool), Entwickler (Test) | 4 | Offen |
| M1.9 | Test & 0.1.0 | DoD für Q00/Q01, Saves T02/T03, BT01–BT05, Record-Inventur für E04, interner Build | Entwickler, Claude (Protokolle) | 8 | Offen |

**Sprints**

| Sprint | Zeitraum | Pakete | Spielbares Ziel |
|---|---|---|---|
| S1 | 19.10.–01.11.2026 | M1.1, M1.2, M1.4 | Veyra in Testzelle, MCM zeigt Status, Q00 startet nach „Hail Sithis!“ |
| S2 | 02.11.–15.11.2026 | M1.3, M1.8, Beginn M1.5 | Deep Sanctuary betretbar, erste Q00-Zeilen im Spiel |
| S3 | 16.11.–29.11.2026 | M1.5, Beginn M1.6 | Q00 Szene 1–6 durchspielbar |
| S4 | 30.11.–13.12.2026 | Rest M1.6, M1.7, M1.9 | Q01 abgeschlossen, Hrefna im Sanctuary, 0.1.0 getaggt |

S4 ist mit ca. 34 h der engste Sprint; rutscht er, wandert M1.9 in die erste Woche von M2.

**Exit-Kriterien**

- [ ] Q00 und Q01 von T02 und T03 aus vollständig spielbar, DoD erfüllt.
- [ ] 0.1.0 per FOMOD in Vortex installiert, Start in bestehendem Spielstand ohne Log-Fehler.
- [ ] Record-Inventur liegt vor, E04 entschieden.
- [ ] E01, E02, E06, E12, E14, E16 entschieden.

---

## M2 – Contracts Q02–Q05

In Story-Reihenfolge bauen (Fragmente, Banter-Voraussetzungen, Veyras Dialoge bauen aufeinander auf). Jeder Contract nutzt `NHV_ContractBaseScript` und bringt den Grundausbau des Raums seines Rekruten mit.

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M2.1 | Follower-System komplett | Zwei Slots, Befehle, Inventar, Catch-up, Grundlage Kompatibilitätsmodus, Rekruten-Zeilen Hrefna | Claude, Entwickler | 20 | Offen |
| M2.2 | Q02 Cold Waters | Windhelm, Sings-Beneath-Ice, Clerk Aelius, Fragment 2, Shadowscale Wraps, Grundausbau Drowned Pool | Claude, Entwickler | 35 | Offen |
| M2.3 | Q03 The Scholar's Sin | Winterhold, Nirelda, Dungeon Hollowfrost Spire, Rätsel, Fragment 3, Circlet of the Last Breath, Grundausbau Arcanum | Claude, Entwickler | 55 | Offen |
| M2.4 | Q04 Till Death Do Us Part | Riften, Corisande, Dinner-Szene (Zell-Regel E16), Aurelian Cato, Fragment 4, Widow's Ring, Fence, Grundausbau Velvet Counter | Claude, Entwickler | 40 | Offen |
| M2.5 | Q05 Blood of the Stronghold | The Reach, Kharzog, Arena „The Red Pit“, Buchmacher Varus, Fragment 5, Oathbreaker, Grundausbau Forge | Claude, Entwickler | 40 | Offen |
| M2.6 | Rekruten-Grundzeilen & Services | Greeting-, Idle-, Kampf-Zeilen der vier neuen Rekruten, Trainer- und Händler-Setup | Claude (CSV), Entwickler (CK) | 10 | Offen |
| M2.7 | Integrationstest & 0.2.0 | Q00–Q05 am Stück, alle Entscheidungstabellen, Update-Test 0.1.0 → 0.2.0, Save-Gesundheit | Entwickler, Claude | 12 | Offen |

**Exit-Kriterien**

- [ ] Q02–Q05 mit allen Pfaden abschließbar.
- [ ] Fünf Story-Rekruten im Sanctuary, Services funktionieren.
- [ ] Zwei Familien-Follower gleichzeitig, Vanilla-Follower-Slot bleibt frei.
- [ ] Update 0.1.0 → 0.2.0 im laufenden Spielstand ohne Fehler.
- [ ] E03 entschieden.

---

## M3 – Finale Q06 Blood Harvest

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M3.1 | Livia & Oculatus | Livia Maro, `NHV_OculatusFaction`, Leveled Lists der Agenten (4 Stufen), Ausrüstung | Claude, Entwickler | 10 | Offen |
| M3.2 | Ansatz A „Strike First“ | Frostmere Watch (neue Innenzelle, Außenzugang), zwei Begleiter mit eigenen Wegen, Bosskampf | Claude, Entwickler | 22 | Offen |
| M3.3 | Ansatz B „Hold the Door“ | Fünf Vorbereitungen (drei wählbar), `NHV_FinaleWaveScript`, drei Wellen per `PlaceAtMe` an der Black Door | Claude, Entwickler | 18 | Offen |
| M3.4 | Livia-Pfad | Speech 75 oder ≥4 Rekruten, Dialog, Übernahme als Rekrutin (erster Scope-Hebel) | Claude, Entwickler | 8 | Offen |
| M3.5 | Zeremonie & Belohnungen | Szene, Black Ledger (Item), Lesser Power „Sense the Darkness“ (Vergabe), 2.000 Gold, MCM-Seite Finale | Claude, Entwickler | 9 | Offen |
| M3.6 | Test & 0.3.0 | Alle Varianten, „Family can die“ an/aus, BT08, BT14 | Entwickler, Claude | 8 | Offen |

Frostmere-Zugang berührt eine Tamriel-Außenzelle: Stelle vorher im Heavy-Profil prüfen.

**Exit-Kriterien**

- [ ] Beide Ansätze mit allen Ausgängen abschließbar, auch ohne überlebende Rekruten.
- [ ] Wellen überstehen Speichern, Laden, Verlassen des Sanctuary.
- [ ] Frostmere-Zugang im Heavy-Profil ohne Überschneidungen.
- [ ] E08 entschieden.

---

## M4 – Black Ledger

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M4.1 | Ledger-Quest | `NHV_Sys_Ledger`, 12 Slot-Aliase, Alias-Script für generische Rekruten, Fraktionen | Claude, Entwickler | 10 | Offen |
| M4.2 | Eignungsprüfung | `CanRecruit()`, `NHV_RecruitBlacklist`, Fraktions-Blacklist, Morality-Schwelle, Unique-Option | Claude, Entwickler | 8 | Offen |
| M4.3 | Sense the Darkness | Cloak-Magic-Effect mit Conditions, Shader, `NHV_CandidateFaction`, Radius aus MCM | Claude, Entwickler | 8 | Offen |
| M4.4 | Generischer Rekrutierungsdialog | 12 Zeilen, Conditions, Speech-Checks, alle Vanilla-VoiceTypes (Liste per xEdit) | Claude, Entwickler | 12 | Offen |
| M4.5 | Initiation & Verwaltung | Drei-Tage-Timer (Spielzeit-Global), `MoveTo` ins Dormitory, Verwaltung über Veyra, Entlassen, MCM-Seite | Claude, Entwickler | 14 | Offen |
| M4.6 | Test & 0.4.0 | BT11, BT12, Stresstest 12 Rekruten, Save-Gesundheit | Entwickler, Claude | 8 | Offen |

**Exit-Kriterien**

- [ ] 12 Slots belegbar, der 13. Versuch wird sauber abgelehnt.
- [ ] Essential- und Blacklist-NPCs nie wählbar.
- [ ] Entlassene Rekruten kehren zurück und verlieren alle NHV-Fraktionen.
- [ ] Kein spürbarer Script-Lag mit „Sense the Darkness“ in Solitude oder Whiterun.
- [ ] E13 entschieden.

---

## M5 – Lebendige Sanctuary

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M5.1 | Räume fertigstellen | Shrine of the Void, Training Hall; alle Räume mit Enable-Parent-Stufen, Dekoration, finale Room Bounds | Entwickler, Claude | 20 | Offen |
| M5.2 | Banter-System | `NHV_BanterControllerScript`, Szenen B01–B12, Frequenz aus MCM | Claude, Entwickler | 14 | Offen |
| M5.3 | Vanilla-Figuren | Zeilen für Nazir, Babette, Cicero, Night Mother, Delvin; Szene „The Keeper and the Gleaner“ | Claude, Entwickler | 12 | Offen |
| M5.4 | Tagesabläufe | Packages, Idle-Marker, Furniture, Schlafplätze | Claude, Entwickler | 8 | Offen |
| M5.5 | Spielerzustände | Kommentare zu Vampir, Werwolf, Arch-Mage, Gildenleitungen | Claude, Entwickler | 4 | Offen |
| M5.6 | Performance & 0.5.0 | Framerate, Papyrus-Log, Save-Gesundheit nach 20 h | Entwickler | 4 | Offen |

**Exit-Kriterien**

- [ ] Alle elf Räume begehbar und in beiden Zuständen korrekt.
- [ ] Banter in eingestellter Frequenz, nie zwei Szenen gleichzeitig.
- [ ] Keine Package-Konflikte.
- [ ] Framerate im Rahmen vergleichbarer Vanilla-Innenräume.

---

## M6 – Polish, Beta & Release

Ab Beta-Beginn Feature-Freeze: nur Fixes.

| ID | Arbeitspaket | Aufgaben | Wer | h | Status |
|---|---|---|---|---|---|
| M6.1 | MCM komplett | Seiten Family, Finale & Difficulty, Compatibility, Maintenance & Debug, Hilfetexte, „Prepare for Uninstall“ | Claude, Entwickler | 14 | Offen |
| M6.2 | Kompatibilität | Heavy-Profil, Patches, Follower-Kompatibilitätsmodus | Entwickler, Claude | 18 | Offen |
| M6.3 | Beta | 0.9.0 an 5–15 Tester, zwei Runden à zwei Wochen, Triage, Fixes | Entwickler, Claude | 20 | Offen |
| M6.4 | Legacy-Test | Kompletter Durchlauf auf SE 1.5.97 | Entwickler | 6 | Offen |
| M6.5 | Release-Paket | FOMOD final, Nexus-Seite, README, Changelog | Claude, Entwickler | 14 | Offen |
| M6.6 | Release | E15, Upload 1.0.0, LOOT-Metadaten, Support erste Woche | Entwickler | 10 | Offen |

Release-Checkliste: siehe Skill `/release-build`.

---

## Nach v1.0

| Version | Inhalt | Aufwand grob (h) |
|---|---|---|
| 1.0.x | Bugfixes | laufend |
| 1.1 Voices | Vertonung ca. 2.200 Zeilen, Voice-Pack als eigener Download | 40–120 |
| 1.2 Phase 2 | Persönliche Rekruten-Quests, Dispatch-System, 20 Wanderers, Maulwurf | 150–250 |
| begleitend | Mantella-Bios, Community-Übersetzungen | 5–10 |

## Re-Planung

1. Nach jedem Meilenstein Ist gegen Plan vergleichen, Folgetermine anpassen.
2. Mehr als 25 % über Plan: Scope-Hebel der Reihe nach prüfen – Livia-Pfad nach v1.1 (15–25 h), Deep Sanctuary auf 6 Räume (25–40 h), nur Finale-Ansatz B (25–35 h), Banter halbieren (10–15 h), Q05 nach Release (40–60 h).
3. Zwei Sprints ohne spielbaren Fortschritt: Blocker analysieren, Arbeitspaket teilen.
4. Termine verschieben statt Qualität senken: Die Definition of Done bleibt.
