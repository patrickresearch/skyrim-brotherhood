# Q03 V2 – Die Gelehrte im Hollowfrost Spire

Stand: 29.09.2026. **Inaktive Autorenfassung für den Lesetest.** Im aktiven Ordner existiert derzeit keine `dialogue/Q03.csv`; damit wird kein vertonter Q03-Master überschrieben. Die vorhandenen aktiven Journal-/Buchmaster werden per Hash gesichert und nicht verändert.

## Ablauf

| Stage | Pflichtinformation und Folge |
|---|---|
| 10 | Veyra führt Nirelda Aurantil als mögliche Rekrutin ein. Urag schützt die alten College-Akten; der Listener kann überreden, bestechen, sich auf den Arch-Mage berufen oder ohne Einblick weitergehen. |
| 20 | Die Witwe und Nireldas Brief machen den alten Unfall greifbar, ohne ihre Verbannung als vollständige Entschuldigung zu verkaufen. |
| 30 | Im Hollowfrost Spire werden die Four Stillnesses gelesen. Der Listener entscheidet, ob Joric geheilt, sterben gelassen oder die Prüfung unterbrochen wird. |
| 40 | Nirelda erkennt den Listener als unberechenbare Variable und beginnt ihre Prüfung. Sie ist eine Feuer-Battle-Mage auf Meisterstufe; ihre Destruction dient der Figur, nicht einer Lore-Erklärung über Sithis. |
| 50 | Drei Fragen prüfen Dienst, Zustimmung und Verantwortung. Zwei tragfähige Antworten reichen für eine freiwillige Unterordnung; bei Scheitern folgt ein kontrollierter Kampf, in dem Nirelda nachgibt und nicht zwingend stirbt. |
| 60 | Whisperbane-Bestellungen belegen, dass Nirelda alte Zielpersonen beobachtete. Die Signatur „L.M.“ bleibt ein Fragment und enthüllt weder Livia Maro noch eine fertige Oculatus-Kette. |
| 70 | Der Listener wählt Aufnahme, Übergabe an das College, Freilassung oder Schweigen. Der College-Weg ist mit Arch-Mage-Zugang oder Tolfdirs ausdrücklicher Unterstützung verfügbar. |
| 100 | Veyra bewertet Ergebnis und Methode, ordnet Fragment 3 ein und öffnet den nächsten Contract. |

## Prüfungslogik

Die Vorschau zählt zwei zulässige Antworten: ehrliche Begrenzung oder Dienstbereitschaft in Frage eins und Zustimmung zu Grenzen in Frage zwei. Die dritte Frage vertieft Nireldas Menschenbild, entscheidet aber allein nicht über den Ausgang. Das hält die Prüfung nachvollziehbar und verhindert, dass eine einzelne rätselhafte Antwort den gesamten Contract kippt.

## Dateien

| Datei | Inhalt |
|---|---|
| `Q03.csv` | 126 neue Dialogzeilen mit V2-IDs |
| `Journal.csv` | 16 V2-Ziele und Berichtseinträge |
| `Books.csv` | 1 neuer Whisperbane-Auszug |
| `flow.json` | 60 Gesprächs- und Weltknoten, Prüfungs- und Urteilspfade |
| `Lesefassung.md`, `Lesetest.html` | automatisch erzeugte Lesefassung und Offline-Vorschau |
| `build_preview.py` | Lint, Hashvergleich, Pfad- und Ausgangsprüfung |

Alle V2-Dateien liegen ausschließlich unter `dialogue/drafts/Q03-v2/`. Vor einer Aktivierung braucht es einen gesonderten CK-Abgleich für neue Topics, die Nirelda-Aliase, die Spire-Szene, die echte Prüfung, Arch-Mage-Bedingung, Kampfresultat und die Whisperbane-Bergung. Vorschauzustände sind keine Papyrus-Variablen und bestätigen kein Ingame-Verhalten.

Reproduktion: `python dialogue/drafts/Q03-v2/build_preview.py`.
