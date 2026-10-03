# Q01 Enhanced – The Unanswered Sacrament

Stand: 30.09.2026. **Eigenständiger, inaktiver Redaktionsentwurf.** Dieser Ordner überschreibt weder `dialogue/Q01.csv` noch `dialogue/drafts/Q01-v2/`. Die neuen LineIDs liegen bewusst im reservierten Bereich ab `2000` (Dialog), `9000` (Journal) und `9100` (Bücher).

## Ziel

Q01 wird vom kurzen Reise-und-Mord-Auftrag zu einem vollständigen Rekrutierungs-Arc. Hrefnas erste Tat bleibt der Ausgangspunkt. Die eigentliche Prüfung besteht aus Recherche, einer zweiten Begegnung mit der Außenwelt, Hrefnas eigener Entscheidung und einem Urteil mit Folgen.

Der Entwurf hat elf klar getrennte Phasen. Die Rückholung des roten Fährmarkers ist Pflicht; die konkrete Lösung des Reedbed-Zwischenfalls bleibt offen:

1. **Morthal:** Hakan liefert überprüfbare Beobachtungen, aber zunächst keinen Täter.
2. **Roter Fährmarker:** Nach der Rückgabe nennt Hakan Hrefna als Verdächtige; der Farmmarker erscheint.
3. **Stormhollow:** Der Spieler untersucht Ritual, Schulden und imperiale Fußspuren; der Wachpostenmarker erscheint.
4. **Alter Wachposten:** Soldaten und Scout werden überwunden. Der Scout überlebt und verrät nach dem Kampf Hrefnas Lager.
5. **Hrefnas Lager:** Hrefna erzählt von Farm, Ehemann, Tochter und dem unbeantworteten Sakrament. Danach wartet sie auf die Rückkehr des Listeners.
6. **Quintus:** In Morthal wird seine Händlergeschichte durch Widersprüche aufgebrochen; erst dann gesteht er seine Oculatus-Zugehörigkeit.
7. **Dokumente:** Der Listener findet den Brief an Quintus’ Tochter und die übrigen Einsatzunterlagen.
8. **Vorbereitung:** Quintus bleibt im Gasthof oder wird mit der Lüge fortgeschickt, Hrefna kehre zur Farm zurück.
9. **Konfrontation:** Hrefna liest die Dokumente in der Herberge und entscheidet zwischen Töten, Festnahme oder Übergabe an den Listener.
10. **Fragment:** Die Oculatus-Unterlagen verbinden mehrere unbeantwortete Sakramente, ohne Livia oder die spätere Verschwörung zu enthüllen.
11. **Urteil:** Der Listener entscheidet über Hrefnas Aufnahme, Freilassung oder Schweigen.

## Neue Nebenfiguren im Entwurf

- **Marsh Scavenger:** kein neuer Hauptantagonist; ein hungriger Schuldensammler, der Eiriks Papiere als Beute betrachtet. Er zeigt die weltlichen Nachwirkungen des Geldverleihs.
- **Oculatus Scout:** ein kleiner Feldagent, der Quintus sucht. Er kennt nur einen Ausschnitt des Musters und nennt weder Livia noch eine große Verschwörung.

Beide sind Autorenprofile für diesen Draft. Vor einer Aktivierung brauchen sie eigene NPC-/VoiceType-/Package-Records. Die beiden Sprecher sind bereits in `tools/dialogue_lint.py` als neue eigene VoiceTypes registriert; das ersetzt keine CK-Records.

## Dateien

| Datei | Inhalt |
|---|---|
| `Q01.csv` | 149 neue englische Dialogzeilen |
| `Journal.csv` | 21 neue Objectives und Log-Einträge |
| `Books.csv` | 6 neue Fundstücke und private Notizen |
| `flow.json` | 30 Ablaufknoten für den Lesetest und spätere CK-Planung |
| `Lesefassung.md` | Gesprächslesefassung in Stage-Reihenfolge |
| `Story-Text.md` | Zusammenhängende Prosafassung ohne Dialogzeilen |
| `Story-Arc.md` | Arc-Bibel mit Mermaid-Visualisierung |
| `Items-and-Evidence.md` | Rechercheobjekte, Begegnungen und Konsequenzen |
| `Characters.md` | Autorenprofile für Marsh Scavenger und Oculatus Scout |
| `Lore-Foundations.md` | Lore-Leitplanken und Unsicherheiten |

## Lore- und Tonregeln

- Ein Schwarzes Sakrament ist ein Ruf und keine automatische Aufnahmegarantie. Hrefna kann korrekt handeln, ohne dass die Night Mother sichtbar antwortet.
- Die Entstehung der Dark Brotherhood aus der Morag Tong und die genaue Identität der Night Mother werden als widersprüchlich überlieferte Geschichte behandelt. Q01 löst diese Fragen nicht auf.
- Sithis bleibt im Sprachgebrauch der Brotherhood der Dread Father beziehungsweise die Leere; die Quest behauptet keine neue objektive Kosmologie.
- Der Penitus Oculatus arbeitet als kaiserliche Ermittlungsinstanz. Quintus und sein Scout sind deshalb konkrete Gegenspieler, aber keine Kultisten und keine Vorboten des Finales.
- Veyra deutet Muster und prüft Entscheidungen. Sie ersetzt weder Recherche noch die Zuständigkeit des Listeners.

## Technischer Status

Der Entwurf ist nur Text- und Ablaufmaterial. `flow.json` ist keine CK- oder Papyrus-Implementierung. Die neuen Bedingungen, Globals, NPCs, Packages, Szenen und Encounter müssen nach Auswahl der Fassung in einem eigenen CK-Arbeitspaket geplant werden.
