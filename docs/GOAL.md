# Ziel & Scope – Night's Harvest v1.0

Stand: 21.09.2026. Details zu allen Punkten stehen im Konzept unter `docs/concept/`.

## Vision

Nach „Hail Sithis!“ ist die Dark Brotherhood fast ausgelöscht. Night's Harvest erzählt ihren Wiederaufbau: Eine alte Recruiterin aus Cheydinhal taucht in der Dawnstar Sanctuary auf, öffnet einen versiegelten Flügel und schickt den Spieler los, neue Mitglieder zu finden. Jede Rekrutierung ist eine eigene Geschichte mit Entscheidungen und Folgen. Am Ende steht eine lebendige Familie und die Freiheit, selbst weiter zu rekrutieren.

- **Arbeitstitel:** Night's Harvest (Namenskollision auf Nexus vor Release prüfen, E15)
- **Plugin:** `NightsHarvest.esp`, EditorID-Präfix `NHV_`
- **Plattform:** Skyrim SE 1.5.97 und AE 1.6.x (Steam, GOG sofern SKSE verfügbar), nur PC
- **Installation:** FOMOD über Vortex (auch MO2)
- **Abhängigkeiten:** SKSE64, SkyUI

## Design-Pfeiler

1. **Lore first:** Alles fügt sich in die TES-Lore und die Vanilla-Questline ein (Lucien Lachance, Cheydinhal, Shadowscales, Black Sacrament, Familie Maro).
2. **Entscheidungen mit Konsequenzen:** Jeder Contract hat mehrere Ausgänge, die spätere Dialoge und das Finale beeinflussen.
3. **Lebendige Sanctuary:** Mitglieder haben Tagesabläufe, Aufgaben und reden miteinander.
4. **Keine Vanilla-Record-Edits:** maximale Kompatibilität, Vanilla-NPCs nur über Aliase.
5. **Voice-ready:** Alle Zeilen so geschrieben und strukturiert, dass eine spätere Vertonung ohne Umbau möglich ist.

## Startbedingungen

- „Hail Sithis!“ abgeschlossen (Quest-EditorID `DB11`, am 22.09.2026 über `houseCARL` gegen `Skyrim.esm` verifiziert: `Name = "Hail Sithis!"`), nicht auf dem Destroy-Pfad.
- Auslöser: Betreten der Dawnstar Sanctuary nach einer Wartezeit von 0–7 Tagen (MCM, Standard 2).
- Sonderfälle laut Konzept Abschnitt 2: Cicero lebt oder ist tot, Spieler ist Arch-Mage, Gildenleitung, Vampir oder Werwolf, Installation mitten im Spiel.

## Figuren

| Figur | Rasse | Rolle | Service | Quest |
|---|---|---|---|---|
| Veyra Othren („the Gleaner“) | Dunmer | Recruiterin, Questgeberin | Trainerin Illusion (Expert) | alle |
| Hrefna Stormhollow | Nord | Köchin | Trainerin Archery | Q01 |
| Sings-Beneath-Ice | Argonier | Schleicher | Trainer Sneak | Q02 |
| Nirelda Aurantil | Altmer | Magierin | Trainerin Destruction | Q03 |
| Corisande Marchand | Bretonin | Hehlerin | Fence (2.000 Gold), Trainerin Speech | Q04 |
| Kharzog gro-Ulgar | Ork | Schmied | Trainer Smithing | Q05 |
| Livia Maro | Kaiserliche | Antagonistin, optional rekrutierbar | Trainerin Block | Q06 |

Vanilla-Figuren mit neuen Zeilen: Nazir, Babette, Cicero, Night Mother, Delvin Mallory.

## Quests

| Quest | Titel | Schauplatz | Kern |
|---|---|---|---|
| Q00 | A Shadow at the Door | Dawnstar Sanctuary | Veyras Ankunft, versiegelter Flügel, Memorial Wall, erster Contract |
| Q01 | The Unanswered Sacrament | Morthal | Hrefna, Agent Quintus Aufidius, Fragment 1 |
| Q02 | Cold Waters | Windhelm | Sings-Beneath-Ice, Clerk Aelius, Fragment 2 |
| Q03 | The Scholar's Sin | Winterhold | Nirelda, Dungeon Hollowfrost Spire, Rätsel „The Four Stillnesses“, Fragment 3 |
| Q04 | Till Death Do Us Part | Riften | Corisande, Dinner im Bee and Barb, Aurelian Cato, Fragment 4 |
| Q05 | Blood of the Stronghold | The Reach | Kharzog, Arena „The Red Pit“, Buchmacher Varus, Fragment 5 |
| Q06 | Blood Harvest | Sanctuary / Frostmere Watch | Finale gegen Livia Maro, Ansatz „Strike First“ oder „Hold the Door“ |
| – | The Black Ledger | ganz Skyrim | Freies Rekrutieren nach dem Finale |

Jeder Contract folgt dem Schema Whisper → Hunt → Observation → Trial → Judgement → Homecoming. Es ist immer nur ein Contract aktiv. Die fünf Oculatus-Dispatch-Fragmente bilden den roten Faden zum Finale und blockieren nie den Fortschritt.

## Scope v1.0

- 1 Recruiterin, 5 Story-Rekruten, 1 Antagonistin (optional rekrutierbar), ca. 15 Neben-NPCs
- 7 Quests plus Black Ledger
- ca. 2.100–2.300 eindeutige Dialogzeilen, Englisch, zunächst unvertont
- eigener Flügel „Deep Sanctuary“ mit 11 Räumen
- 8–12 Stunden Spielzeit
- nur Vanilla-Assets

## Nicht-Ziele für v1.0

- Inhalte für den Destroy-Pfad (Mod bleibt dort passiv)
- eigene Meshes, Texturen oder Animationen
- Konsolen und Bethesda.net Creations (SKSE-Abhängigkeit)
- Vertonung (folgt als v1.1) und weitere Sprachen
- eigene SKSE-DLL
- Phase-2-Inhalte: persönliche Rekruten-Quests, Dispatch-System, Wanderers, Maulwurf (v1.2)

## Erfolgskriterien v1.0

- Alle Quests erfüllen die Definition of Done aus `docs/TESTING.md` auf AE und SE 1.5.97.
- Keine Vanilla-Overrides außer dokumentierten Zell-Kopien, 0 ITM/UDR.
- Installation per FOMOD in Vortex und MO2 ohne Warnungen.
- Keine offenen Bugs der Stufen „kritisch“ oder „hoch“ zum Release.
