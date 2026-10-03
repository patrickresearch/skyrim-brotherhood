# Q00 V2 – inaktiver Dialogentwurf

> **Aktiviert am 30.09.2026 (E43):** Diese Fassung ist jetzt der aktive Master (`dialogue/Q00.csv`, `Journal.csv`, `Books.csv`) und wird per `tools/build_q00_v2.py` in Plugin-Records übersetzt. `flow.json` bleibt die Quelle für Ablauf und Zustände. `build_preview.py` vergleicht noch mit den Baselines der Vor-Aktivierung und meldet deshalb Abweichungen zum aktiven Master; das ist erwartet.


Stand: 30.09.2026. Auftrag: vollständige Autorenredaktion von Q00 und E41-Stage-12-Übernahme, verständliche Reihenfolge, getrennt lesetestbar von der vertonten Fassung. **Status: Stage-12-Text zusätzlich im aktiven CSV vorbereitet, V2 weiterhin nicht als Plugin-Edition aktiviert und nicht ingame getestet.**

## So lässt sich die Fassung prüfen

1. `Lesetest.html` in einem Browser öffnen. Sie funktioniert lokal ohne Netzwerk oder zusätzliche Pakete.
2. Cicero und vorhandene Initiates einstellen, dann „Mit diesen Einstellungen neu beginnen“ wählen.
3. Den kürzesten Weg gehen: keine freiwilligen Nachfragen wählen. Auch so müssen Anliegen, Methode und Entscheidungsbefugnis vor der Zustimmung klar sein.
4. Danach die Nachfragen, Vertagungen und alle drei Memorial-Entscheidungen lesen. Eine Vertagung setzt beim Wiederansprechen am selben Gesprächsabschnitt fort.
5. Jede der drei Abschlusswahlen im Standoff führt durch Stage 12 zu Luciens verpflichtender Bürgschaft. Danach verlässt Veyra die Sanctuary; Stage 15/20 bleiben der Night-Mother-Folge vorbehalten. Nach dem Contract endet Q00 direkt bei Stage 100.

Die vollständige Markdownfassung heißt `Lesefassung.md`. Jede Spielerwahl nennt ihr Folgegespräch. Die IDs können für konkrete Änderungswünsche benutzt werden.

## Dateien und Isolation

| Datei | Aufgabe |
|---|---|
| Q00.csv | Neuer Dialogmaster mit eigenen LineIDs; nur diese Datei enthält die gesprochenen Texte |
| Journal.csv | Getrennte Objective- und Log-Texte für die Testfassung |
| flow.json | Reihenfolge, optionale Zweige, Lesetest-Bedingungen und Fortsetzungen; keine implementierten Spielbedingungen |
| Lesefassung.md / Lesetest.html | Aus CSV und Ablauf erzeugte Ansichten; zum Ändern die CSV bearbeiten und neu erzeugen |
| build_preview.py | Validiert CSV, Verbindungen, Pflichtwissen und Erreichbarkeit; erzeugt beide Ansichten |
| baseline.json | SHA-256 des unveränderten aktiven Q00- und Journal-Masters zu Beginn dieser Redaktion |
| reviewed-baseline.json | Bewusst aktualisierter aktiver Stand nach E41-Stage-12-Übernahme |
| Q00-original.csv.snapshot | Bytegetreue Referenz des vertonten Q00-Masters vom Beginn der Redaktion; kein importierbarer CSV-Master |

Die aktive Pipeline liest `dialogue/*.csv` direkt; dieser Entwurf liegt bewusst darunter in `dialogue/drafts/Q00-v2/`. `csv_to_plugin.py` verwendet einen nicht rekursiven Glob; das bestehende Veyra-Voice-Pack verwendet eine feste Liste aktiver Dateien. Keine der Dateien hier ist damit aktiv. Künftige Tools dürfen diesen Entwurfsordner nicht rekursiv als Produktionsquelle einsammeln.

Alle neuen Q00-LineIDs beginnen je Stage ab Nummer 1000. Die sechs Stage-12-IDs wurden für E41 bewusst in den aktiven Q00-/Journal-Master übernommen; die übrigen V2-IDs bleiben getrennt. `V2_` im Topic bezeichnet die neue Redaktion, keine existierenden CK-Records. Selbst ähnliche oder unveränderte kurze Aussagen haben in dieser Fassung eigene IDs. Bestehende FUZ-Dateien dürfen diesen IDs später nur nach bewusstem Textabgleich zugeordnet werden.

## Dramaturgie

| Abschnitt | Pflichtinformation / Handlung | Darauf folgende Freiheit |
|---|---|---|
| Standoff 10 | Sithis' Ruf und Erntemetapher; Nazir verlangt den Namen; auf Nachfrage des Listeners wird die Rekrutierung konkret | Herkunft, Titel, Tür, verspätete Ankunft, Mother; nur ausdrücklicher Abschied beendet die Befragung |
| 15–20 | Veyra wartet im Windpeak; Mother bestätigt ihre bisherige Hilfe und erlaubt ihr Angebot | Weitere Fragen an die Mother; Besuche im Inn vor ihrem Urteil |
| 30, Windpeak | Einladung zur Rückkehr ist noch keine Zustimmung zum Plan | Freundlich, skeptisch oder vertagen |
| 30, Pflichtblock 1 | Ledger enthält mögliche Kandidaten; Ziel ist der Wiederaufbau durch neue Mitglieder | Spieler fordert die Methode an |
| 30, Pflichtblock 2 | Beobachten, prüfen; ein Mord allein qualifiziert niemanden | Spieler fragt nach der Entscheidungsbefugnis |
| 30, Pflichtblock 3 | Listener urteilt; Veyra berät; Nazir hilft; Mitglieder brauchen Aufgaben und Räume | Erst jetzt Nachfragen, bewusste Zusage oder Vertagung |
| 40–50 | Verborgene Tür könnte Platz schaffen; Zustand dahinter unbekannt | Vorbereitung vertagen oder gemeinsamer Eintritt; dann Sicherung und Rundgang |
| 60 | Gefallene erinnern, Astrids Eintrag bestimmen | Drei bleibende Varianten |
| 60, erster Lead | Hrefna, Morthal, Hakan und Eiriks Tod; ermitteln statt Aufnahme versprechen | Zweifel und Nachfragen, dann Auftrag annehmen |
| 12 | Nach Night-Mother-Urteil, Drohung oder Verweisung ruft Veyra verpflichtend einen Zeugen; Lucien erscheint, bürgt für ihre freiwillige Sithis-Treue, Nazir reagiert misstrauisch, Lucien löst sich auf | Keine Ablehnung; Trotz und Einverständnis verändern nur Veyras Übergangszeilen |
| 15–20 | Lucien ist gegangen; Veyra verlässt die Sanctuary und wartet im Windpeak Inn, danach spricht die Night Mother | Die Bürgschaft ersetzt keine Entscheidung über Veyras Arbeit |
| 100 | Nach dem ersten Contract endet Q00 direkt; Ledger erhalten, Q01 beginnt | Lucien steht ab Stage 50 dauerhaft in der Deep Sanctuary und erhält eine einmalige Wiedersehenszeile |

Die zentrale Zustimmung lautet: **“We'll recruit carefully. I'll judge each candidate myself.”** Damit bleibt auch beim schnellen Durchspielen klar, was beschlossen wurde. Die Räume sind anschließend die praktische Voraussetzung für das Vorhaben.

## Was gegenüber dem alten Dialog verbessert ist

- Feinschliff nach Lesetest: Veyra stellt sich nicht sofort selbst vor. Ihre religiöse Metapher löst die Reaktionen aus; Name und Angebot ergeben sich daraus. Beide Spielerhaltungen führen durch die verständliche Erklärung, bevor die freie Befragung beginnt.
- Luciens Identität bleibt in Angebot, Spielerwahlen, Journal und späterem Nachholpfad verborgen. Erst seine Erscheinung und Selbstvorstellung lösen die Überraschung ein. Der Listener darf nach der Macht dahinter fragen und Veyras Ausweichen benennen. Lucien bestätigt seinen freien Willen; eine Unmöglichkeit sterblicher Beschwörung wird nicht behauptet.

- Ein kurzer Pflichtpfad vermittelt den Auftrag vollständig. Die Tiefe steckt in freiwilligen Folgegesprächen, nicht in Voraussetzungen für das Verstehen der Hauptgeschichte.
- Kenntnis der Herkunft bleibt optional und rätselhaft. Veyras Absicht und die Arbeitsteilung sind konkret.
- Die drei Pflichtblöcke des Angebots sind echte Vorgänger der Zusage. Bloße Rückkehr reicht nicht mehr.
- Veyra garantiert keine geeigneten Kandidaten. Damit bereitet Q00 auch die späteren ungeeigneten Ernten vor, ohne Namen oder Spion-Twist zu verraten.
- Die Mother gestattet Veyras Hilfe; daraus entsteht keine automatische Aufnahme Veyras und kein zweiter Listener.
- Vorhandene Initiates werden nicht unbelegt als zufällige oder schlechte Rekruten abgewertet.
- Das Wissen um Hrefnas Tat ist noch ungesichert; Veyra behauptet keine selbst gehörte Botschaft der Mother.
- Ciceros offene Kränkung bleibt bestehen. Der Cheydinhal-Dialog ist nur erreichbar, wenn seine Erinnerung das Thema eingeführt hat.
- Der frühere Stage-80-Zweifelzweig bleibt als `obsolete (E41)` im CSV erhalten, wird aber nicht mehr verkabelt. Dauerhafte zusätzliche Lucien-Lorethemen außerhalb dieses Q00-Auftrags gehören in eine spätere Redaktion.

## Grenzen des Lesetests

Der Test prüft Texte und Reihenfolge. Wegfindung, Szenenphasen, Animationen, Combat, echte Sprecher-Conditions, zeitlicher Voice-Ablauf und Speichern/Laden in Skyrim sind nicht implementiert. Ortswechsel und Kampfende erscheinen als Regie-Schaltflächen. Die UI-Einstellungen gelten erst nach einem Neustart des Lesetests.

`heardPlan`, `heardMethod`, `heardAuthority`, `returned` und die anderen Werte in flow.json sind ausschließlich Zustände der Vorschau. Sie sind keine neuen Papyrus-Variablen, Globals oder Save-Daten. Die CSV-Conditions nennen nur die Stage-Grundbedingung; **direkter CSV-Import allein stellt den Ablauf nicht her.** Zusätzliche Bedingungen stehen im Ablauf und müssen vor einer Aktivierung in echte Records übersetzt werden.

## Spätere Aktivierung – nach dem Lesetest

Die Edition bleibt bis zur Auswahl durch den Entwickler inaktiv. Für einen späteren Spieltest ist ein separates Test-Build oder eine vor Q00 festgelegte Dialogedition vorzubereiten. Das ist kein Hot-Swap in einem laufenden Gespräch.

1. Neue INFOs/Topics und Szenen anhand der `V2_`-Blöcke anlegen; bestehende IDs und vertonte Inhalte erhalten. Nie gleichzeitig beide Editionen auslösen.
2. Pflichtfortschritt der drei Angebotsblöcke speichern. Erst nach der letzten Response von `proposal_authority` darf die neue Zustimmung erscheinen. Abbruch während eines Blocks muss dessen Wiederaufnahme zulassen und darf keine Zusage auslösen.
3. Mehrsprecher-Blöcke als Szenen mit getrennten Sprecheraktionen umsetzen. Die automatische Lesetest-Schaltfläche ist kein Player-Topic. Jede sichtbare Spielerwahl stammt aus einer CSV-Zeile.
4. Vorhandene Übergänge 15 → 20 → 30 und Rückkehr nach Dawnstar beibehalten. Das `returned`-Vorschauereignis darf im Spiel erst nach der tatsächlichen Rückkehr gelten.
5. An Stage 30 die Objectives „Veyra zurückholen“ / „Plan hören“ und an Stage 60 „Memorial“ / „ersten Lead hören“ nach Teilphase schalten. Die gleichen Stage-Nummern allein reichen nicht.
6. Stage 12 als verpflichtende Szene bauen: alle drei Standoff-Abschlüsse führen in denselben Ruf-/Ankunfts-/Bürgschaftsblock. Danach deaktiviert die Szene Lucien; Stage 15/20 bleiben unverändert. Stage 80, `SYS_LUC_01` und der Drei-Tage-Fallback werden additiv stillgelegt, ohne alte IDs zu löschen.
7. Cheydinhal-Wissen aus tatsächlich abgeschlossener Cicero-Erinnerung ableiten. Eine reine `GetDead`-Bedingung reicht bei späterer Unterbrechung der Szene nicht. Leere/tote optionale Aliase überspringen.
8. Die einzige gegenwärtige Logikänderung ist im Lesetest. CK-Integration, passende stille Teststimmen, Abgleich mit aktiven Scenes und danach neue Sprachaufnahmen sind ein späterer Arbeitsschritt. Keine Vertonung anhand alter Q00-Audionamen überschreiben.

## Prüfergebnis der Redaktion

236 Dialogzeilen und 22 Journaltexte; 78 aktive Ablaufknoten plus als `obsolete (E41)` markierte Alt-Knoten. Projektregeln zu Länge, VoiceType, CSV und IDs bestanden. Der separate Validator prüft alle vier Kombinationen aus lebendem/totem Cicero und vorhandenen/fehlenden Initiates, alle drei Memorial-Werte sowie alle drei Stage-12-Abschlüsse. Er weist nach, dass jeder Abschluss Luciens Bürgschaft vor Stage 15 erreicht und kein Stage-80-Nachholpfad aktiv bleibt.

Zusätzliches Lektorat des Lesetest-Feinschliffs abgeschlossen: ein Kontinuitätsbefund zur später wiederholbaren Machtfrage korrigiert und eine Titelwiederholung gestrafft. Keine offenen Lore-Befunde.

Lore-Editor-Review der ersten Fassung abgeschlossen: fünf Befunde zu vorausgesetztem Wissen und zeitabhängiger Abschiedsformulierung eingearbeitet. Keine neuen Herkunftsfakten über Veyra eingeführt. E41 ergänzt Stage 12 in V2 und im aktiven Q00-/Journal-Master, aktualisiert `SYS_LUC_02–13`, markiert Stage 80 und `SYS_LUC_01` als `obsolete (E41)` und ergänzt Luciens Wiedersehenszeile in `dialogue/Lucien.csv`. Der ursprüngliche Snapshot und `baseline.json` bleiben als Vor-E41-Referenz bestehen; `reviewed-baseline.json` beschreibt den absichtlich übernommenen Stand.

Reproduktion mit Python: `python dialogue/drafts/Q00-v2/build_preview.py`. Der Baseline-Check stoppt, falls der aktive Master nach dem dokumentierten Abgleich erneut geändert wird; dann Unterschiede und Übernahmekonzept bewusst prüfen. Optionale en-US-Rechtschreibprüfung des Projekt-Linters ist auf dieser Umgebung nicht installiert.
