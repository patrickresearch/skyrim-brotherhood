---
name: papyrus-script
description: Papyrus-Scripts für Night's Harvest schreiben, erweitern, kompilieren und prüfen – Quest-, Alias-, Magic-Effect- und MCM-Scripts sowie Fragment-Code für Stages, Dialoge und Szenen. Immer verwenden, wenn .psc-Dateien entstehen oder geändert werden, Script-Logik für Quests, Rekruten, Follower, Finale oder Black Ledger geplant wird oder ein Papyrus-Log ausgewertet werden soll, auch bei kleinen Fixes.
---

# Papyrus für Night's Harvest

Papyrus läuft in Skyrim in einer geteilten, zeitgesteuerten VM. Jedes überflüssige Update, jede persistente Referenz und jede umbenannte Property landet dauerhaft in den Spielständen der Nutzer. Deshalb gilt: wenig Script, viel Record-Logik, nichts Unumkehrbares.

## Vor dem Schreiben

1. `docs/ARCHITECTURE.md` → Script-Tabelle: Gibt es das Script schon? Welche Basisklasse, welche Quest?
2. `docs/CONVENTIONS.md` → Stil und die zehn Papyrus-Regeln.
3. Konzept-Abschnitt der Quest bzw. des Systems lesen (Stages, Globals, Entscheidungstabelle).
4. Prüfen, ob eine Condition am Record die Aufgabe ohne Script löst. Wenn ja: Condition vorschlagen (Skill `ck-guide`) statt Script.
5. Ist ein Script schon in einem Build ≥ 0.1.0 enthalten, gilt Save-Kompatibilität: nur additiv ändern.

## Beim Schreiben

- Vorlagen in [templates.md](templates.md) verwenden (Core, Player-Alias, Util, Contract-Basis, Magic Effect, MCM, Fragmente).
- Kopfkommentar: Zweck, Record, Konzept-Abschnitt.
- Jede Alias-Referenz vor Gebrauch auf `None` prüfen; bei `None` loggen und sauber abbrechen.
- Keine `OnUpdate`-Schleifen. Timer über `RegisterForSingleUpdateGameTime()` oder Spielzeit-Globals.
- Stage-Fragmente rufen nur Funktionen des Quest-Scripts auf. Fragment-Dateien (`QF_`, `TIF_`, `SF_`) nicht selbst anlegen; das CK erzeugt sie. Du lieferst den Fragment-Text zum Einfügen.
- Logging: `NHV_Util.Log(NHV_Cfg_Debug, "…")`.
- SKSE-Funktionen sind erlaubt; neue harte Abhängigkeiten (PapyrusUtil, po3 u. a.) nicht.

## Nach dem Schreiben

1. Kompilieren mit dem Befehl aus `docs/ENVIRONMENT.md`; Fehler beheben, bis der Build sauber ist.
2. Subagent `papyrus-reviewer` auf die geänderten Dateien ansetzen und Befunde einarbeiten.
3. Lieferung im folgenden Format zusammenfassen.

## Lieferformat

```markdown
### <Scriptname>.psc
Zweck: …  |  Basis: …  |  Hängt an: <Record/Alias>
**Im CK zu füllende Properties**
| Property | Typ | Wert/Record |
**Fragmente zum Einfügen** (Stage/INFO/Szene → Text)
**Kompiliert:** ja/nein  |  **Save-relevant:** ja/nein (Grund)
**Test:** Kurzanleitung oder Verweis auf die Testanleitung
```

## Häufige Fehler

| Symptom | Ursache | Lösung |
|---|---|---|
| `Cannot call X() on a None object` | Property im CK nicht gefüllt oder Alias leer | Property-Liste prüfen, None-Check ergänzen |
| `Unable to bind script … to …` | `.pex` fehlt oder Scriptname ≠ Dateiname | Build prüfen, Namen angleichen |
| Quest startet nicht, kein Fehler | Nicht-optionaler Alias findet keine Referenz | Vanilla-Aliase auf Optional setzen |
| Logik läuft doppelt | `OnInit()` mehrfach, Event ohne State-Schutz | Idempotent schreiben, `GotoState("Busy")` |
| Script-Lag, Stack-Dumps im Log | Polling, große Schleifen, viele parallele Updates | Auf Events umstellen, Arbeit verteilen |
| Änderung wirkt im alten Save nicht | Wert steckt im Save (Variable, Alias) | Migration in `Maintenance()`, ggf. Quest-Neustart |
| Neuer Alias bleibt leer | Aliase laufender Quests füllen sich nicht nach | Reserve-Alias nutzen oder `ForceRefTo()` |

Papyrus-Arrays sind auf 128 Elemente pro Literal-Deklaration begrenzt; für mehr FormLists verwenden. String-Vergleiche sind nicht case-sensitive.

## Papyrus-Log auswerten

1. Nur Blöcke mit `[NHV]` oder mit Scriptnamen `NHV_` betrachten; Fremdmod-Fehler nennen, aber nicht beheben.
2. Pro Fehler: Script, Funktion, Zeile (wenn `bLoadDebugInformation=1`), wahrscheinliche Ursache, konkreter Fix.
3. Stack-Dumps mit `NHV_`-Beteiligung sind Blocker.
4. Ergebnis als Tabelle: Schwere | Script:Zeile | Meldung | Ursache | Fix.
