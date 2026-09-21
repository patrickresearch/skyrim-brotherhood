---
name: work-package
description: Ein Arbeitspaket aus docs/ROADMAP.md starten, durchführen und übergeben (z. B. /work-package M1.5).
argument-hint: "[Arbeitspaket-ID, z. B. M1.5]"
disable-model-invocation: true
---

# Arbeitspaket $ARGUMENTS

## 1. Einordnen

1. Eintrag `$ARGUMENTS` in `docs/ROADMAP.md` suchen. Fehlt er: nachfragen, nicht improvisieren.
2. Die im Paket genannten Konzept-Abschnitte unter `docs/concept/` lesen, dazu `docs/ARCHITECTURE.md` und `docs/CONVENTIONS.md`.
3. `docs/DECISIONS.md`: Hängt das Paket an einer offenen Entscheidung? Dann die Frage mit Optionen und Empfehlung stellen und erst danach weitermachen.
4. Abhängigkeiten prüfen: Sind vorausgehende Pakete mindestens im Status „Test“?

## 2. Definition of Ready

- [ ] Spezifikation im Konzept vorhanden und eindeutig
- [ ] EditorIDs vergeben oder in diesem Paket vergebbar
- [ ] Dialog-CSV vorhanden, falls das Paket Dialog enthält (sonst zuerst Skill `dialogue-csv`)
- [ ] Keine blockierende offene Entscheidung

Fehlt etwas: Liste der Lücken ausgeben und stoppen.

## 3. Plan

Kurzer Plan in 3–7 Schritten, getrennt in zwei Spalten:

| Claude liefert | Entwickler im CK / Spiel |
|---|---|

Danach den Status in `docs/ROADMAP.md` auf `In Arbeit` setzen.

## 4. Umsetzen

- Scripts: Skill `papyrus-script`, kompilieren, Subagent `papyrus-reviewer`.
- Dialoge: Skill `dialogue-csv`, Lint, Subagent `lore-editor`.
- Records: Skill `ck-guide`, Anleitung unter `docs/ck/$ARGUMENTS.md`.
- Tools: Python 3, nur Standardbibliothek, wenn möglich; unter `tools/`.

## 5. Übergabe

1. Zusammenfassung: was entstanden ist (Dateien), was der Entwickler im CK tun muss (Verweis auf die Anleitung).
2. Testanleitung im Format aus `docs/TESTING.md`.
3. Status in `docs/ROADMAP.md` auf `Test` setzen. `Fertig` setzt der Entwickler.
4. Commit-Nachricht vorschlagen, z. B. `[Q00] Szene 1: Marker und Packages`. Nicht selbst committen, außer der Entwickler bittet darum.
5. Neue Erkenntnisse, die das Konzept betreffen, als Vorschlag formulieren (nicht still ändern); Entscheidungen in `docs/DECISIONS.md` eintragen.

## Briefing (falls der Entwickler Kontext mitgibt)

```markdown
**Arbeitspaket:** M1.5 Q00 – Szene 1 Standoff
**Ziel:** Was soll am Ende spielbar sein?
**Stand:** Welche Records, EditorIDs und Scripts existieren schon?
**Konzeptbezug:** z. B. Konzept-Abschnitt 6, Szene 1
**Gewünschte Lieferung:** Script / Dialog-CSV / CK-Anleitung / Review
**Probleme:** Papyrus-Log-Auszug, Screenshots, beobachtetes Verhalten
**Fertig, wenn:** konkrete Kriterien aus der Definition of Done
```
