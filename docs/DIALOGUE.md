# Dialog-Bibel – Night's Harvest

Alle Ingame-Texte leben im CSV-Master-Skript unter `dialogue/`. Es speist die CK-Eingabe, spätere Übersetzungen und die Vertonung. Ausführlich: Konzept Abschnitt 13; Figurenstimmen in den Abschnitten 3, 9 und 11.

## Stilregeln

- **Ton:** düster, poetisch, sardonisch. Kein moderner Slang, keine Anachronismen.
- **Begriffe:** Sithis, Dread Father, the Void, Night Mother, Listener, Sanctuary, Black Sacrament, Penitus Oculatus. Schreibweise wie in Vanilla.
- **NPC-Zeilen:** höchstens ca. 25 Wörter pro Response. Längere Reden auf mehrere Responses einer INFO verteilen.
- **Spielerzeilen:** höchstens 80 Zeichen. Speech-Checks mit Vanilla-Präfix: `(Persuade)`, `(Intimidate)`, `(Bribe)`.
- **Voice-ready:** Jede Zeile muss allein gesprochen funktionieren. Keine Regieanweisungen im Text; die gehören in `Notes`.
- **Figurenstimme vor Information:** Jede Figur klingt unverwechselbar (Sprachmuster laut Konzept). Veyra: alt, gemessen, ironisch, spricht über Tod wie über Handwerk.
- **Keine Spoiler** in Zeilen, die vor dem jeweiligen Stage erreichbar sind.
- **Amerikanische Schreibweise** (bis E12 anders entscheidet).
- Keine wörtlich übernommenen Vanilla-Zeilen; Anspielungen sind erlaubt.

## Emotionen

Werte des CK: `Neutral`, `Anger`, `Disgust`, `Fear`, `Sad`, `Happy`, `Surprise`, `Puzzled`, jeweils mit Stärke 0–100. Standard: `Neutral`, 50.

## CSV-Format

Datei je Quest oder System: `dialogue/Q00.csv`, `dialogue/Q01.csv`, …, `dialogue/Family.csv`, `dialogue/Ledger.csv`, `dialogue/Banter.csv`, `dialogue/Sanctuary.csv`, `dialogue/Journal.csv`.

Spalten (feste Reihenfolge, Kopfzeile Pflicht):

| Spalte | Inhalt |
|---|---|
| `LineID` | Eindeutig und stabil, Schlüssel für CK-Abgleich und Audiodateien. Quest-Zeilen: `NHV_<Quest>_<Stage dreistellig>_<Nr. zweistellig>` (`NHV_Q00_010_01`); System-Zeilen: `NHV_SYS_<Bereich>_<Nr.>` (`NHV_SYS_REC_01`) |
| `Quest` | `Q00` … `Q06`, `Ledger`, `Family`, `Banter`, `Sanctuary` |
| `Stage` | Stage, ab der die Zeile gilt, sonst `-` |
| `Topic` | EditorID des Topics bzw. der Branch |
| `Speaker` | Kurzname wie im Konzept (`Veyra`, `Nazir`, `NightMother`, `Generic`) oder `Player` |
| `VoiceType` | Eigene Figuren `NHV_Voice…`, Vanilla-Figuren `Vanilla`, generische Zeilen `ALL` |
| `Emotion` | siehe oben |
| `Value` | 0–100 |
| `Text` | Die Zeile, Englisch |
| `Conditions` | CK-Conditions, getrennt durch `;` im Format `Funktion Parameter Operator Wert` |
| `Notes` | Regie, Kontext, Szene, Vertonungshinweise (Deutsch erlaubt) |

Die Spalte `Topic` enthält den Kurznamen aus dem Konzept (`SCN_Standoff`); im CK wird daraus die EditorID mit Präfix, z. B. `NHV_Q00_SCN_Standoff`.

Regeln: UTF-8 ohne BOM, Komma als Trenner, Felder mit Komma oder Anführungszeichen in `"…"`, Anführungszeichen im Text verdoppeln. Eine Zeile pro Response. Gelöschte Zeilen werden nicht entfernt, sondern mit `Notes = DEPRECATED` markiert, damit LineIDs nie wiederverwendet werden.

Formatbeispiel (weitere Beispiele in Konzept Abschnitt 13):

```csv
LineID,Quest,Stage,Topic,Speaker,VoiceType,Emotion,Value,Text,Conditions,Notes
NHV_Q00_010_03,Q00,10,SCN_Standoff,Veyra,NHV_VoiceVeyra,Neutral,0,"He's been saying that for an hour. I'm beginning to think he doesn't mean it.",,
NHV_SYS_REC_01,Ledger,-,REC_Ask,Generic,ALL,Puzzled,30,"...Who's asking?",Morality <= 1,shared line
```

## Lint-Regeln (`tools/dialogue_lint.py`)

- Kopfzeile und Spaltenzahl korrekt, `LineID` eindeutig über alle Dateien.
- NPC-Zeilen ≤ 25 Wörter, Spielerzeilen ≤ 80 Zeichen.
- `Emotion` aus der Liste, `Value` 0–100, `VoiceType` passt zum `Speaker`.
- Keine doppelten identischen Texte innerhalb einer Quest.
- Rechtschreibprüfung (en-US) mit Projekt-Wortliste `tools/wordlist.txt` für Tamriel-Begriffe.
- Abgleich mit dem CK-Export („Export Dialogue“): jede aktive `LineID` existiert im CK und umgekehrt.

## Vom CSV ins Spiel

1. Zeilen im CSV schreiben, Lint laufen lassen, `lore-editor` prüfen lassen.
2. Entwickler legt Topics/INFOs im CK an (Anleitung über Skill `ck-guide`).
3. CK-Export mit dem CSV abgleichen.
4. Bis v1.1 unvertont: Fuz Ro D-oh für Untertitel-Dauer empfehlen.

## Vertonung (v1.1, Kurzfassung)

WAV je Zeile → LIP → FUZ nach `Sound/Voice/NightsHarvest.esp/<VoiceType>/`, ausgeliefert als eigener Download. Nur eigene VoiceTypes werden vertont; generische Zeilen für Vanilla-VoiceTypes bleiben stumm. Keine KI-Klone realer Sprecher. Mantella ergänzt freie Gespräche, ersetzt aber keine geskripteten Zeilen; optionale Mantella-Bios enthalten keine Spoiler.
