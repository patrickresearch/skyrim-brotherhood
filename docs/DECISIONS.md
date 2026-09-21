# Entscheidungen – Night's Harvest

Offene Fragen und getroffene Entscheidungen. Claude legt nichts fest, was hier als „Offen“ steht, sondern fragt nach. Getroffene Entscheidungen werden unten als Eintrag dokumentiert und in der Tabelle auf „Entschieden“ gesetzt.

## Übersicht

| Nr. | Frage | Optionen | Empfehlung | Fällig | Status |
|---|---|---|---|---|---|
| E01 | Follower-System | Eigenes System / Vanilla-Slot / Framework-Integration | Eigenes System + MCM-Kompatibilitätsmodus | vor M1 | Offen |
| E02 | Standard-Sterblichkeit der Rekruten | Essential / Protected / Mortal | Protected | vor M1 | Offen |
| E03 | Release-Strategie | Komplette v1.0 / Kapitel-Releases | Komplette v1.0 mit geschlossener Beta | bis Ende M2 | Offen |
| E04 | Plugin-Format | ESP / ESL-geflaggtes ESP | ESP, nach Record-Inventur neu prüfen | Ende M1 | Offen |
| E05 | Master-Dateien | Skyrim.esm + Update.esm / zusätzlich Dawnguard, Dragonborn | Nur Skyrim.esm + Update.esm | in M0 | Offen |
| E06 | MCM-Technik | SkyUI direkt / MCM Helper | SkyUI direkt | vor M1 | Offen |
| E07 | Einstellungs-Export | Keiner / optional über PapyrusUtil-JSON | Optional, erst in M6 | vor M6 | Offen |
| E08 | Livia-Rekrutierungspfad in v1.0 | Behalten / nach v1.1 | Behalten, erster Scope-Hebel | während M3 | Offen |
| E09 | Pathing Vanilla-Sanctuary | Option B `MoveTo` / Option A Navmesh-Edits | B für v1.0 (bereits so geplant), A für v1.1 prüfen | Ende M1 | Offen |
| E10 | Vertonung zum Start | Nur Text / Release erst mit Stimmen | Nur Text, Voice-Pack in v1.1 | vor M6 | Offen |
| E11 | Voice-Pack-Format | BSA mit Dummy-ESL / Loose Files | BSA mit Dummy-ESL | vor v1.1 | Offen |
| E12 | Schreibweise Ingame-Texte | Amerikanisch / britisch | Amerikanisch | vor M1 | Offen |
| E13 | Unique-NPCs im Black Ledger | Erlaubt / verboten | Erlaubt (außer Essential, Blacklist), MCM | vor M4 | Offen |
| E14 | Standard-Wartezeit bis Q00 | 0–7 Tage | 2 Tage | vor M1 | Offen |
| E15 | Finaler Mod-Name | „Night's Harvest“ / Alternative | „Night's Harvest“, falls auf Nexus frei | vor M6 | Offen |
| E16 | Zugang Deep Sanctuary | A: Load Door mit Zell-Kopie / B: Script-Tür per `PlaceAtMe` + `MoveTo` | offen; A ist einfacher, B vermeidet Zell-Konflikte | vor M1.3 | Offen |

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

(noch keine Einträge)
