# Q01 V2 – getrennte Autorenfassung zum Lesetest

> **Aktiviert am 30.09.2026 (E43):** Diese Fassung ist jetzt der aktive Master (`dialogue/Q01.csv`, `Journal.csv`, `Books.csv`) und wird per `tools/build_q01_v2.py` in Plugin-Records übersetzt. `flow.json` bleibt die Quelle für Ablauf und Zustände. `build_preview.py` vergleicht noch mit den Baselines der Vor-Aktivierung und meldet deshalb Abweichungen zum aktiven Master; das ist erwartet.


Stand: 29.09.2026. **Inaktiv, nicht im Plugin und nicht ingame geprüft.** Die bereits vertonten Q01-Zeilen werden durch diesen Auftrag nicht überschrieben. Diese Fassung setzt die verständliche Rekrutierungseinführung von Q00 V2 fort: Der Listener untersucht eine Kandidatin und entscheidet erst nach ihrer Geschichte und Prüfung über ihre Aufnahme.

## Lesen und ausprobieren

1. `Lesefassung.md` enthält alle Gespräche, Nachfragen, Varianten und die verwendeten Fundstücke in Ablaufreihenfolge. Die Auswahltexte verlinken jeweils zum Folgegespräch.
2. `Lesetest.html` lokal im Browser öffnen. Sie braucht weder Server noch Netzwerk. Nach Änderungen eine bereits geöffnete Seite neu laden.
3. „Überreden gelingt“ und „Einschüchtern gelingt“ einstellen, dann neu beginnen. Das sind simulierte Testergebnisse, keine Aussagen über reale Spielwerte.
4. Zuerst ohne Tagebuch und ohne freiwillige Vertiefungen durchspielen. Anliegen, Geständnis, Gefahr und Entscheidung müssen dennoch verständlich sein.
5. Mit dem Zurück-Knopf alternative Antworten vergleichen. Er stellt auch den Vorschauzustand wieder her; er ist kein vorgesehenes Spielsystem.

## Der neue rote Faden

| Stage | Pflichtinformation oder Ereignis | Sinn der folgenden Entscheidung |
|---|---|---|
| 10 | Q00 ist abgeschlossen; Hakan beschreibt Fund, Pfändung, Hof, Lager und Quintus' Fragen | Verdacht untersuchen, statt Hrefnas Schuld vorwegzunehmen; Veyra-Rückblick und frühes Quintus-Gespräch optional |
| 20 | Leerer Hof, Ritualreste und Unterlagen | Die Absicht wird sichtbar; Hrefna spricht hier noch nicht; Tagebuchlektüre ist optional |
| 30 | Hrefna hat den Keller beobachtet und stellt den Fremden | Identität klären; nur nach Lektüre darf der Spieler das Tagebuch zitieren |
| 40 | Sechs Wochen, Eiriks Tod und eigenes Geständnis | Erklärung ist keine Entschuldigung; das Sakrament bedeutet keine automatische Mitgliedschaft |
| 40 → 50 | Hrefna erklärt Quintus' Interesse an Besuchern; Veyra kommt hinzu und erhält den Bericht | Die Gefahr wird konkret, bevor eine Tötung vorgeschlagen wird |
| 50 | Veyra schlägt die Prüfung vor, benennt ihren Zweck und lässt den Listener autorisieren | Keine erfundene Anordnung der Night Mother; Hrefna stimmt zunächst der Begleitung zu |
| 50 | Zimmer nachts oder Straße morgens; Hrefna erfährt nachvollziehbar von Quintus' Tochter | Überreden, einschüchtern, selbst übernehmen oder vorerst zurückziehen |
| 60 | Tatsächlicher Tod und Täter werden ausgewertet; Papiere können gesichert werden | Erst die Dokumente bestätigen die Oculatus-Zugehörigkeit; Übernahme lässt die Prüfung offen |
| 70 | Hrefna fragt nach ihrer Zukunft | Aufnahme mit ihrer Zustimmung, Freilassung oder gewaltsames Verstummen sind verschiedene Entscheidungen |
| 100 | Bericht passend zu Entscheidung, Täter und vorausgegangener Drohung | Veyra benennt Unterschiede und verschweigt die Verantwortung des Listeners nicht |
| 100 | Oculatus-Fragment und Grenzen seiner Aussage | Größerer Bogen wird vorbereitet; weder Livia noch Spion-Twist oder Drahtzieher werden enthüllt |
| Nachklang | Küche nur bei Aufnahme; Brief nur bei Freilassung | Wärme und Konsequenzen entstehen aus dem gewählten Ausgang |

Die vier verbleibenden Kern-Contracts werden nach dem Debrief am Map Table wählbar. Diese Fassung startet nicht zwangsläufig Q02 als einzige nächste Quest.

## Bewusste Korrekturen gegenüber den bisherigen Texten

- Hakan liefert Beobachtungen und einen Verdacht, kein Wissen um einen unbeobachteten Mord.
- Hrefna wird erst am Lager gesprochen. Die Hofgespräche mit einer damals noch abwesenden Hrefna entfallen in V2.
- Falkreaths Verlust erklärt die Lage der Bruderschaft, aber nicht sicher die sechs Wochen dieses einzelnen Sakraments. Niemand erfindet dafür einen Entschluss der Night Mother.
- Ein Gebet kauft weder Zugehörigkeit noch einen Anspruch auf Aufnahme. Eiriks Tod macht Hrefnas Schulden nicht magisch ungültig.
- Veyra erfährt das Geständnis aus dem Bericht; sie hatte es nicht schon bei der Auswahl der Kandidatin gewusst.
- Quintus bleibt ein Ermittler mit einer Tochter. Die Brotherhood beseitigt eine Gefahr für sich und prüft Hrefna. Sein privates Leben wird nicht nachträglich als Betrug abgewertet, um die Tat bequem zu machen.
- Bei gescheiterter Einschüchterung und anschließend erfolgreicher Überredung erinnert der Bericht an beide Versuche. Ein Player-Kill bleibt unabhängig von früheren Zusagen `Unproven`.
- Hrefnas tatsächlicher Tod ist Voraussetzung des Todesberichts. Keine tote Hrefna spricht danach; Küche und Freilassungsbrief sind entsprechend gesperrt.

## Quellenabgleich und widersprüchliche Altstände

Grundlage sind `docs/concept/konzept.md`, Abschnitt Q01, Hrefnas Profil in `Neue-Charakterprofile.md`, die Q01-Nebenfigurenprofile, die aktiven Buchtexte und der Anschluss aus Q00 V2. `Q01-Chronologische-Geschichte.md` ist eine nützliche ältere Lesefassung, enthält aber Abweichungen von diesem Kern:

| Abweichung | Umgang in V2 |
|---|---|
| Svala als Tochter Hrefnas; verschiedene Behauptungen über das Ende ihres Mannes | Nicht als neue Gewissheit übernommen. Kernprofil und aktive Fundstücke tragen diese Zusatzbiografie nicht. Hrefna spricht über die belastete Ehe, ohne seinen Tod festzulegen. |
| Quintus endgültig freilassen/festsetzen als eigener Ausgang | Nicht als fertiger Questweg hinzugefügt. Der Kern sieht nach seinem Tod Recruit/Release/Silence für **Hrefna** vor. Ein Rückzug in Stage 50 vertagt die offene Aufgabe. |
| Magisch sichere oder vollständig erklärte Oculatus-Verschwörung | Fragment 1 liefert ein Beobachtungsmuster, keine vollständige Führungskette. |
| Feldbriefe und komplette Familie bereits aus einem einzigen Hinweis bekannt | Pflichtpfad führt jede benötigte Information ein. Tagebuchwissen bleibt an tatsächliche Lektüre gebunden. |

Die aktiven Quellen bleiben als Vergleich erhalten. V2 ist ein redaktioneller Vorschlag; die widersprüchlichen Alttexte werden durch diesen Auftrag nicht global umgeschrieben.

## Dateien und Schutz der vertonten Fassung

| Datei | Aufgabe |
|---|---|
| `Q01.csv` | Neuer Dialogmaster: 218 Zeilen, eigene IDs ab Nummer 1000 pro Stage |
| `Journal.csv` | 28 Objective-/Log-Texte; Bedingungen nennen die erforderliche Teilphase |
| `Books.csv` | Vier neue Absätze für Quintus' privaten Brief und Hrefnas Freilassungsbrief, nur für V2 |
| `flow.json` | 105 Gesprächs-/Weltknoten, Verbindungen und Vorschauzustände |
| `Lesefassung.md`, `Lesetest.html` | Ausschließlich aus CSV, Buchreferenzen und Ablauf abgeleitet |
| `build_preview.py` | Projekt-Lint, Zustandsprüfung und Generierung beider Ansichten |
| `baseline.json`, `*.csv.snapshot` | Hashes und bytegetreue Referenzen von aktivem Q01, Journal, Books, Q00 sowie Q00 V2 |

Bestehende Fundstückauszüge werden unverändert aus `Books-original.csv.snapshot` angezeigt und mit ihren alten IDs bezeichnet. Sie sind keine neuen Dialogzeilen. Die vier neuen Buchabsätze tragen eigene Q01-IDs und überschreiben keine aktiven Books-IDs. Die Nummern werden über Dialog, Journal und neue Bücher gemeinsam vergeben.

Die Produktionswerkzeuge lesen die aktiven Master direkt aus `dialogue/*.csv`; der Entwurf bleibt unter `dialogue/drafts/Q01-v2/`. Diesen Ordner nicht als zusätzliche Produktionsquelle rekursiv importieren. `V2_`-Topics und CSV-Stage-Bedingungen allein bilden die Gespräche nicht ab.

## Vor einer späteren Aktivierung abzugleichen

Dies ist noch keine CK-Einbauanleitung. Nach Auswahl der Fassung braucht ein gesonderter Teststand einen vollständigen Record-/Szenenabgleich, ohne alte FormIDs, Stages oder Sprachdateien aufzugeben.

- **Veyras Ankunft und Mehrsprecherszenen:** Ihr Bericht darf erst nach dem Geständnis beginnen. Sichtbare Ankunft, Listener-Bericht, Trial und Küche benötigen echte Sprecheraktionen; ein `MoveTo` oder einzelne `Say`-Aufrufe allein gewährleisten den Ablauf nicht.
- **Wissensbedingungen:** Tagebuchlektüre, Prüfungsbriefing, Autorisierung und Rückkehr müssen über tatsächlich abgeschlossene Aktionen geprüft werden. Alle JSON-Werte sind ausschließlich Vorschauzustände, keine vorhandenen Globals oder Papyrus-Variablen.
- **Zwei Orte:** E32 vereinfachte Zimmer und Straße bislang zu einer ortsneutralen Szene. V2 zeigt beide ursprünglichen Konzeptwege; ihre tatsächlichen Packages, Briefplatzierung, Szenen und Bedingungen sind noch nicht umgesetzt.
- **Speech und Kampf:** Die bestehende Überredungsschwelle ist Speech 30. Einschüchterung braucht den realen Engine-Check, keinen `Intimidation`-ActorValue. Erfolgs-/Fehlschlagszweige und zurückliegende Drohungen müssen erhalten bleiben. Tötungsdialoge reagieren auf den tatsächlichen Täter; Fremdkiller, Follower und vorzeitige Tode gesondert behandeln.
- **Silence:** Der aktuelle `JudgeSilence()` setzt den Todesstatus bereits vor dem Kampf. V2 behauptet den Tod erst nach dessen Bestätigung. Vor Einbau diesen bekannten Unterschied lösen; hier wurde kein Script geändert.
- **Fragment:** Der aktive Stand vergibt das Fragment teilweise über Stage-/Inventarlogik. Die V2-Bergung durch Veyra und gelesen/gefunden/untersucht sind vor Einbau sauber zuzuordnen. Keine fehlenden Globals aus alten CSV-Conditions übernehmen, keine doppelte Vergabe.
- **Nachklang:** Aufnahme schaltet Küche und einmalige Messerbelohnung frei. Freilassung startet den bestehenden Sieben-Tage-Brief; kein `Stop()` vor seiner Zustellung. Weder Tod noch Freilassung dürfen das Küchenbegrüßungsgespräch auslösen.
- **Rückzug:** Vertagung setzt keine neue Zustimmung und wiederholt keine fehlgeschlagenen Checks. Der Lesetest garantiert keine räumliche Erreichbarkeit im Spiel.

## Prüfergebnis und gezielte Lesetests

CSV-Längen, Formate, Sprecher und IDs geprüft. Vier Kombinationen aus erfolgreichen/fehlgeschlagenen Speech-Checks werden mit beiden Begegnungsorten, Tagebuch gelesen/ungelesen, Fragment gefunden/übersehen und allen Urteilen durchlaufen. Geprüft werden insbesondere Pflichtwissen, Täter, Unproven, berichtete Drohung, Tod, erlaubte Nachwirkungen und ein erreichbares Ende.

Ergebnis: 8776 Zustände und 48 Endvarianten erfolgreich geprüft; Original-Hashes unverändert. JavaScript-Syntaxprüfung bestanden. Eine Browser-Stichprobe war mit dem Browser-Werkzeug wegen dessen gesperrtem `file:`-Protokoll nicht möglich; lokale Darstellung und Bedienung sind daher noch manuell zu prüfen.

Lore-Editor-Lektorat abgeschlossen: drei Befunde zu Vorwissen und Entscheidungsfolgen sowie eine Präzisierung von Hakans Aussage eingearbeitet. Keine offenen externen Lorebehauptungen. Optionaler en-US-Spellchecker ist nicht installiert.

Für den manuellen Lesetest besonders vergleichen: Straße/Überreden/Recruit; Zimmer/Spieler übernimmt/Recruit; Einschüchterung scheitert und Überreden gelingt; beide Checks scheitern und Spieler übernimmt; Release mit Brief; Silence mit zunächst entkommener Hrefna; übersehene Papiere mit nachvollziehbarer Bergung.

Reproduktion: `python dialogue/drafts/Q01-v2/build_preview.py`. Bei späteren unabhängigen Änderungen eines referenzierten Masters stoppt der Hashvergleich: Unterschiede bewusst abgleichen, nicht die Referenz unbesehen ersetzen. Erfolgreiche Textprüfung bestätigt weder Plugin-Einbau noch Ingame-Verhalten.
