# Q02 V2 – Das Lied unter dem Eis

Stand: 29.09.2026. **Inaktive Autorenfassung für den Lesetest.** Die vertonten Master unter `dialogue/Q02.csv`, `dialogue/Journal.csv` und `dialogue/Books.csv` bleiben unverändert. Der Entwurf wird vom Produktionsimport nicht rekursiv eingelesen.

## Ablauf

| Stage | Pflichtinformation und Folge |
|---|---|
| 10 | Veyra erklärt, dass mehrere Tote am Windhelm-Hafen ein Muster bilden. Der Listener befragt Torbjorn und Drinks-the-Brine; Verdacht ersetzt keine Beweise. |
| 20 | Ein Körper, ein Knoten und Schleifspuren führen aus dem Hafen. Die Namen der Toten bleiben für Sings-Beneath-Ice wichtig. |
| 30 | Haldor greift nachts an. Der Listener kann retten, beobachten oder den Angriff unterbrechen; die Wahl verändert den späteren Bericht. |
| 40 | Die Spur führt in den Hollow. Sings gesteht die Morde und erklärt, warum verletzte Namen für sie zu einer Rechnung werden. |
| 50 | Erst nach dem Geständnis tritt Veyra hinzu. Sie schlägt Aelius Varro als Prüfung vor, obwohl der Schreiber freundlich zu Argoniern ist; die Entscheidung liegt ausdrücklich beim Listener. |
| 60 | Sings, der Listener oder ein anderer Ausgang entscheidet über Aelius' Tod. Erst danach werden seine Papiere und die Oculatus-Liste gefunden. Ein Dokument macht aus Verdacht keinen vollständigen Verschwörungsbeweis. |
| 70 | Der Listener entscheidet über Aufnahme, Freilassung, Schweigen oder Übergabe an den Jarl. Die Silence-Variante behandelt Sings als mögliche Gefahr, nicht als bequeme Belohnung. |
| 100 | Veyra bewertet Täter und Urteil getrennt, ordnet Fragment 2 ein und gibt den nächsten Contract frei. |

## Entscheidungen und Ton

Sings ist keine „böse Argonierin“, sondern eine leise, zielgerichtete Täterin, deren Hass aus wiederholter Entmenschlichung gewachsen ist. Ihre Erklärung bleibt verständlich, ohne die Morde zu entschuldigen. Aelius' Hilfsbereitschaft bleibt wahr; seine geheime Tätigkeit wird erst durch die nachträglich gesicherten Papiere sichtbar. Veyra behauptet weder einen Auftrag der Night Mother noch eine fertige Antwort über die Oculatus. Der Listener entscheidet, ob ein nützlicher Zeuge, ein Täter und ein Informant jeweils in die Brotherhood passen.

Die Vorschau simuliert Retten/Beobachten/Unterbrechen, Überredung/ Bestechung beim Zugang, vier Urteile und die tatsächlich verantwortliche Todesfolge. Die simulierten Zustände sind keine CK-Properties.

## Dateien

| Datei | Inhalt |
|---|---|
| `Q02.csv` | 152 neue Dialogzeilen mit eigenen V2-IDs |
| `Journal.csv` | 18 V2-Ziele und Berichtseinträge |
| `Books.csv` | 2 neue Auszüge; der aktive Dispatch `NHV_SYS_BOOK_82` bleibt Referenzquelle |
| `flow.json` | 75 Gesprächs- und Weltknoten, Zustände und Urteile |
| `Lesefassung.md`, `Lesetest.html` | automatisch erzeugte Lesefassung und Offline-Vorschau |
| `build_preview.py` | Lint, Hashvergleich, Pfad- und Ausgangsprüfung |

`baseline.json` und die `*.snapshot`-Dateien sichern die unveränderten Master. Vor einer Aktivierung müssen Topics, Packages, Szenen, echte Speech-/Combat-Checks, Alias-Zustände und die Stage-70-Todeslogik im CK abgeglichen werden. Diese Dateien bestätigen weder Plugin-Einbau noch Ingame-Verhalten.

Reproduktion: `python dialogue/drafts/Q02-v2/build_preview.py`.
