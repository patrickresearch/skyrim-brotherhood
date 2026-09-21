# Test & QA – Night's Harvest

Claude kann das Spiel nicht starten. Tests führt der Entwickler aus; Claude schreibt Testanleitungen, wertet Papyrus-Logs aus und pflegt Protokolle unter `docs/tests/`. Ausführlich: Konzept Abschnitt 17.

## Testumgebungen

| Profil | Inhalt | Zweck |
|---|---|---|
| Clean | Spiel + SKSE + SkyUI + USSEP | Grundfunktion |
| Heavy | ca. 200–300 Mods: Follower-Framework, Stadt-Overhauls, AI Overhaul, Beleuchtung, Sanctuary-Mods | Realistische Load Order |
| Legacy | SE 1.5.97 + passendes SKSE | Zweite Engine-Version |
| Voice | Clean + Fuz Ro D-oh + Mantella | Untertitel, Parallelbetrieb |

Während der Tests in `Skyrim.ini`, Abschnitt `[Papyrus]`: `bEnableLogging=1`, `bEnableTrace=1`, `bLoadDebugInformation=1`. Log-Pfad in `docs/ENVIRONMENT.md`.

## Test-Spielstände

| Save | Zustand | Erwartung |
|---|---|---|
| T01 | Kurz vor Ende von „Hail Sithis!“ | Mod passiv, startet nach Abschluss und Wartezeit |
| T02 | Direkt nach „Hail Sithis!“, Cicero lebt | Vollständige Q00 inkl. Cicero-Zeilen |
| T03 | Wie T02, Cicero tot | Q00 ohne Cicero, keine hängenden Aliase |
| T04 | Dark Brotherhood zerstört | Mod dauerhaft passiv, keine Fehler |
| T05 | Spieler Vampir bzw. Werwolf | Sonderdialoge greifen, keine Blockaden |
| T06 | Level 15 und Level 60+ | Balancing |
| T07 | 200-Stunden-Spielstand, Mod nachträglich installiert | Sauberer Start |
| T08 | Je ein Save pro Contract-Phase Q01–Q06 | Einstieg für gezielte Tests |

## Nützliche Konsolenbefehle

`coc <Zelle>`, `sqv <Quest>`, `getstage <Quest>`, `setstage <Quest> <Stage>`, `startquest <Quest>`, `stopquest <Quest>`, `prid <RefID>`, `kill`, `resurrect`, `disable`/`enable`, `set <Global> to <Wert>`, `tim`, `tgm`.

## Break-Tests

| ID | Szenario | Erwartung |
|---|---|---|
| BT01 | Quest-NPC vor seiner Szene töten | Fallback-Stage, Quest abschließbar |
| BT02 | Zelle während Szene verlassen / schnellreisen | Szene pausiert oder setzt sauber zurück |
| BT03 | Speichern und Laden in jeder Stage | Zustand identisch, Timer korrekt |
| BT04 | Verhaftung während eines Contracts | Contract läuft weiter |
| BT05 | Verwandlung (Vampire Lord, Werwolf) im Dialog | Dialog bricht sauber ab, erneut startbar |
| BT06 | 30 Tage warten im Contract | Zeitphasen reagieren wie spezifiziert |
| BT07 | Rekrut stirbt vor „Homecoming“ | Status 2 (getötet), Memorial, Tod-Variante |
| BT08 | Alle Story-Rekruten tot vor Q06 | Finale abschließbar |
| BT09 | Fremder Follower begleitet den Spieler | Keine Konflikte |
| BT10 | Nazir oder Babette deaktiviert | Optionale Aliase leer, keine Fehler |
| BT11 | Black-Ledger-Slots voll | Klare Meldung |
| BT12 | Kandidat ist Quest-NPC eines anderen Mods | Blacklist/Essential greift |
| BT13 | MCM-Werte während Szene ändern | Keine Fehler |
| BT14 | Spieler verlässt das Sanctuary während der Finale-Wellen | Pause, Fortsetzung bei Rückkehr |
| BT15 | SKSE fehlt: Spiel ohne SKSE-Loader starten, über den MO2-Eintrag „Skyrim Special Edition“ (nie `SkyrimSE.exe` direkt) | Warnung oder sauberes Ausbleiben, keine Blockade, Fehler im Log nur einmal |

## Definition of Done (je Arbeitspaket mit Spielinhalt)

- [ ] Alle Pfade der Entscheidungstabelle im Clean-Profil durchgespielt.
- [ ] Relevante Break-Tests bestanden (für Quests mindestens BT01–BT05).
- [ ] 0 Papyrus-Fehler mit `[NHV]`-Bezug im Log.
- [ ] Dialog-Lint grün, `lore-editor` ohne offene Punkte, Journaltexte gegengelesen.
- [ ] Durchlauf auf AE und SE 1.5.97 (spätestens zum Meilenstein-Ende).
- [ ] xEdit: keine unbeabsichtigten Vanilla-Overrides, 0 ITM/UDR.
- [ ] Testprotokoll in `docs/tests/<Paket-ID>.md`.

## Testanleitung (Format für Claude)

```markdown
## Test <Paket-ID>: <Titel>
**Profil / Save:** Clean, T02
**Vorbereitung:** z. B. `coc DawnstarSanctuary`
**Schritte:**
1. …
**Erwartet:** …
**Bitte zurückmelden:** Papyrus-Log-Zeilen mit `[NHV]`, Screenshot von …, `getstage …`
```

## Bug-Report (Pflichtfelder)

Spielversion, SKSE-Version, Mod-Version, Load Order (LOOT-Export), Papyrus-Log, Ausgabe der MCM-Funktion „Write status to log“, Schritte zum Nachstellen.
