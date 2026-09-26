# Aufträge an Codex (Autor für Dialoge, Bücher, Scrolls)

Seit 27.09.2026 schreibt Codex alle Ingame-Texte. Claude schreibt dafür nur kurze Aufträge in diesem Ordner;
der Entwickler gibt sie an Codex weiter. Claude baut danach die Records aus der CSV
(`tools/csv_to_plugin.py`, `tools/silent_voice.py`) und lässt `lore-editor` prüfen.

- Autorenprofil und Figurenstimmen: `docs/concept/Veyra-Autorenprofil.md`, `docs/DIALOGUE.md`, Konzept `docs/concept/`.
- Dateiname: `YYYY-MM-DD-<Kurzname>.md`, ein Auftrag pro Datei.

## Vorlage

```markdown
# Auftrag: <Kurzname>

**Wofür:** Quest/Stage, Szene oder Record, in dem der Text erscheint, und was er dort leisten muss.
**Was schreiben:** Umfang (Zeilen/Seiten), Sprecher, Situation, gewünschter Ton.
**Speichern:** Datei und Format (z. B. `dialogue/Q00.csv`, Spalten wie in DIALOGUE.md; LineIDs `NHV_Q00_060_9x`;
Topic-Name; Conditions-Spalte). Bestehende LineIDs nicht umnummerieren, Ersetztes als `DEPRECATED` markieren.
**Grenzen:** harte Vorgaben (max. Wörter, keine Spoiler auf …, Entscheidungen E…, amerikanische Schreibweise).
**Technik:** was Claude danach daraus baut (z. B. Szene mit Phasen, Spieler-Option mit Antwort – jede
Spieler-Option braucht mindestens eine nicht-leere NPC-Antwort).
```
