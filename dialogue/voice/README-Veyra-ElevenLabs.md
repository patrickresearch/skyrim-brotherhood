# Veyra – ElevenLabs-Aufnahmepaket

Die Datei `Veyra-ElevenLabs.csv` enthält alle 144 aktuellen Veyra-Zeilen aus `Q00.csv`, `Q01.csv`, `Q02.csv` und `Sanctuary.csv`.

## Arbeitsweise

1. Für alle Zeilen dieselbe ElevenLabs-Stimme verwenden. Keine wechselnden Voice-Modelle innerhalb eines Quests.
2. Den Text aus der Spalte `Text` unverändert einfügen. Bedingungen und Notes werden nicht mitgesprochen.
3. `Direction` als kurze Produktionsanweisung verwenden; sie gehört nicht in den gesprochenen Text.
4. Jede Audiodatei exakt nach `Filename` benennen, zum Beispiel `NHV_Q00_010_11.wav`.
5. WAV-Dateien nach dem Export auf deutliche Konsonanten, Pausen und gleichmäßige Lautstärke prüfen. Danach LIP/FUZ erzeugen.

## Stimmprofil

Veyra klingt alt, kontrolliert und körperlich unangestrengt. Sie spricht nicht wie eine geschwächte alte Frau. Ihre Ruhe kommt aus langer Gewohnheit, nicht aus Gleichgültigkeit. Ironie bleibt trocken; Drohungen werden selten lauter. Bei Sithis, der Night Mother und dem Dread Father liegt die Betonung auf Respekt und Vertrautheit, nie auf Predigt.

## Produktionshinweise

- Keine zusätzlichen Anführungszeichen, Regieanweisungen oder Namen vor der Zeile aufnehmen.
- Zeilen mit Auslassungspunkten behalten die Pause; nicht zusammenziehen.
- Memorial-Zeilen mit einem kurzen Atemraum vor Eigennamen sprechen.
- Standoff- und Q02-Hollow-Zeilen eng und leise halten; die Bedrohung entsteht aus Kontrolle.
- Vor der CK-Übernahme prüfen, dass jede `LineID` genau eine Audiodatei besitzt und keine Datei auf eine veraltete CSV-Zeile verweist.

Das Paket enthält keine Vanilla-Audioaufnahmen und ersetzt keine Bethesda-Sprachdateien.
