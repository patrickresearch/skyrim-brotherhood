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
| E06 | MCM-Technik | SkyUI direkt / MCM Helper | SkyUI direkt | vor M1 | Offen |
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

### Hintergrund E16

Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin. Die Kopie ändert nichts, kann aber Änderungen anderer Mods an derselben Zelle (z. B. Beleuchtung) überdecken, wenn Night's Harvest später lädt. Das betrifft auch Quest-Referenzen in Städten (Q01–Q05). Grundregel unabhängig von E16: Schlüsselszenen in eigenen Innenzellen, berührte Vanilla-Zellen minimieren und in `docs/ARCHITECTURE.md` listen.

## Entscheidungs-Einträge

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
