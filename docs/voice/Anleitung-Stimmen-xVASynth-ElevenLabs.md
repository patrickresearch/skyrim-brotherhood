# Anleitung: Voice Lines mit xVASynth (Vanilla-Figuren) und ElevenLabs (Veyra)

**Ziel:** Echte Sprachausgabe mit Lippenbewegung statt stiller Dateien. Grundlage ist Entscheidung E27.
Du erzeugst nur die Audiodateien; alles Weitere (Umwandlung, Lippensync, Dateinamen) macht
`tools/voice_import.py`.

**Wer bekommt welche Stimme**

| Figur | Voice Type (Ordner im Spiel) | Quelle | Zeilen (Stand 27.09.2026) |
|---|---|---|---|
| Veyra | `NHV_VoiceVeyra` | ElevenLabs | 75 |
| Nazir | `MaleUniqueNazir` | xVASynth, Modell „Nazir“ | 14 |
| Cicero | `MaleUniqueCicero` | xVASynth, Modell „Cicero“ | 6 |
| Night Mother | `FemaleUniqueNightMother` | xVASynth, Modell „Night Mother“ | 8 |
| Babette | `FemaleChild` | xVASynth, Modell „Female Child“ (Babette nutzt im Spiel die allgemeine Kinderstimme) | 4 |

Die Modellnamen in xVASynth können je nach Modellpaket leicht anders heißen. Nimm das Modell, dessen
Name zur Figur bzw. zum Voice Type passt.

---

## Teil A – Einmalig vorbereiten

1. **xVASynth entpacken und starten.** Das Programm in einen eigenen Ordner außerhalb des Skyrim- und
   Dev-Ordners legen (z. B. `C:\Tools\xVASynth`), dann `xVASynth.exe` starten.
2. **Skyrim-Stimmmodelle installieren.** Die Modelle gibt es separat (Nexus-Seite von xVASynth,
   Bereich „Skyrim“). Mindestens die vier aus der Tabelle oben herunterladen und nach Anleitung des
   Pakets in den Modellordner von xVASynth entpacken (üblich: `resources\app\models\skyrim\`).
   xVASynth neu starten; oben links das Spiel **Skyrim** wählen. Die Stimmen erscheinen dann in der
   Liste links.
3. **Zeilenlisten erzeugen.** Im Repo-Ordner eine Konsole öffnen und ausführen:
   ```
   python tools/voice_import.py --export voice_lists
   ```
   Das legt im Repo den Ordner `voice_lists\` an, mit einer CSV pro Stimme (z. B.
   `MaleUniqueNazir.csv`). Spalten: `LineID`, `Text`, `Missing` („yes“ = noch keine echte Aufnahme).
   Die Dateien kannst du in Excel oder einem Editor öffnen. Der Ordner ist nur ein Hilfsmittel und
   muss nicht committet werden.

## Teil B – Eine Zeile mit xVASynth erzeugen

1. Links die Stimme wählen (z. B. Nazir).
2. Aus `voice_lists\MaleUniqueNazir.csv` den **Text** einer Zeile kopieren und in das Textfeld
   einfügen. Den Text **nicht** umformulieren: Untertitel und Lippensync richten sich nach dem Text im
   Plugin.
3. **Generieren** und anhören.
4. Feinschliff, falls nötig:
   - **Tempo:** Regler „Pacing“/Geschwindigkeit. Nazir eher zügig, die Night Mother langsam.
   - **Betonung:** Satzzeichen wirken stark. Ein Komma erzeugt eine Pause, ein Gedankenstrich eine
     längere. Das darfst du nur in xVASynth ändern, nicht im Text der CSV.
   - **Tonhöhe/Energie:** Im Editor lassen sich einzelne Laute anheben oder absenken, wenn ein Wort
     falsch betont klingt.
   - Klingt es falsch, einfach neu generieren; jeder Durchlauf fällt etwas anders aus.
5. **Speichern als WAV.** Dateiname = **LineID**, z. B. `NHV_Q00_010_02.wav`. Zielordner: `voice_in\`
   im Repo. Zusätze im Namen sind erlaubt (`Nazir NHV_Q00_010_02 take2.wav`), solange die LineID
   genau einmal darin steht. Abtastrate und Format sind egal, das Tool rechnet um.
6. Nächste Zeile. Tipp: erst alle Zeilen einer Figur, dann die nächste Figur – die Einstellungen
   bleiben so gleich.

**Optional – Stapelbetrieb:** xVASynth kann viele Zeilen auf einmal erzeugen (Bereich „Batch“). Er
erwartet eine CSV mit Spiel, Stimme, Text und Ausgabepfad. Die genauen Spaltennamen zeigt das
Programm selbst (Beispiel-CSV im Batch-Bereich). Die Texte und LineIDs nimmst du aus
`voice_lists\`; als Ausgabepfad `voice_in\<LineID>.wav`. Sag mir die Spaltennamen deiner Version,
dann erweitere ich den Export so, dass er die Batch-CSV direkt schreibt.

## Teil C – Veyra mit ElevenLabs

Genauso wie Teil B, nur mit ElevenLabs:
1. Texte aus `voice_lists\NHV_VoiceVeyra.csv` nehmen.
2. MP3 herunterladen und mit der LineID benennen, z. B. `NHV_Q00_010_92.mp3`.
3. In `voice_in\` legen.
Tipp: Die Emotion der Zeile steht im Plugin (z. B. „Sad 30“); zeige ich dir auf Wunsch als zusätzliche
Spalte im Export.

## Teil D – Importieren

1. Zuerst prüfen, ohne etwas zu schreiben:
   ```
   python tools/voice_import.py --check
   ```
   Jede Datei sollte mit `CHECK` und dem Zeilentext erscheinen. `SKIP` bedeutet: keine LineID im
   Namen oder die LineID gibt es im Plugin nicht (Tippfehler?).
2. Import:
   ```
   python tools/voice_import.py
   ```
   Pro Datei: Umwandlung, Lippensync (CK-LipGenerator), fertige `.fuz` im richtigen Ordner. Eine
   Warnung „no .lip generated“ heißt: die Zeile spielt, der Mund bewegt sich aber nicht – melde mir
   dann die Datei.
3. In die Dev-Kopie bringen (Spiel und CK geschlossen):
   ```
   powershell -File tools\sync_dev.ps1 -Direction ToDev
   ```
4. **Im Spiel prüfen:** Die Zeile anspielen (Save vor der Szene). Erwartung: Stimme hörbar, Untertitel
   bleibt so lange stehen, wie die Aufnahme dauert, die Lippen bewegen sich.

Danach steht in `voice_lists\…csv` bei einem neuen Export in der Spalte `Missing` „no“ für jede
importierte Zeile.

## Gut zu wissen

- **Nichts geht verloren:** `tools/silent_voice.py` überschreibt importierte Aufnahmen nie. Alle noch
  nicht vertonten Zeilen behalten ihre stille Datei.
- **Aufnahme ersetzen:** neue Datei mit derselben LineID in `voice_in\` legen (die alte löschen oder
  überschreiben) und den Import erneut starten.
- **Zurück zur stillen Datei:** Aufnahme aus `voice_in\` löschen, die `.fuz` unter
  `Data\Sound\Voice\NightsHarvest.esp\<VoiceType>\` löschen und `python tools/silent_voice.py`
  ausführen.
- **Text geändert** (Codex überarbeitet eine Zeile): Die Aufnahme passt dann nicht mehr und muss neu
  erzeugt werden. Ich weise darauf hin, wenn das passiert.
- **Versionierung:** `voice_in\` (deine Aufnahmen) kommt ins Git, die erzeugten `.fuz` nicht.
- **Rechtlicher Hinweis (E27):** KI-Stimmen von Vanilla-Sprechern sind auf Nexus umstritten. Für die
  Entwicklung unkritisch; vor einem Release entscheiden wir das noch einmal (E10/E11).
