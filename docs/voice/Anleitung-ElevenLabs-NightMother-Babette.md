# Anleitung: Night Mother und Babette mit ElevenLabs

Für beide gibt es keine xVASynth-Modelle (Stand 27.09.2026). Wir entwerfen deshalb in ElevenLabs je eine
**neue** Stimme über **Voice Design** (Beschreibung per Text), statt eine echte Stimme zu klonen. Das
ist rechtlich sauber (E27). Die Stimme soll an die Figur erinnern, nicht die Originalsprecherin kopieren.

Allgemeiner Ablauf, Import und Fehlerbehebung: `docs/voice/Anleitung-Stimmen-xVASynth-ElevenLabs.md`.

---

## 1. Stimme anlegen (einmal pro Figur)

1. In ElevenLabs: **Voices → Add a new voice → Voice Design**.
2. Beschreibung (unten je Figur) einfügen, einen **Vorschautext** eingeben (am besten eine der Zeilen
   unten) und **Generate** klicken. ElevenLabs liefert mehrere Varianten; anhören und die passendste
   wählen. Nicht zufrieden → Beschreibung leicht ändern und neu generieren.
3. Die gewählte Variante speichern, Name z. B. `NHV Night Mother` bzw. `NHV Babette`.
4. Für die Zeilen im **Text to Speech** diese Stimme wählen. Modell: das Standard-Modell für
   englische Sprache mit der besten Qualität, das dein Abo anbietet.

### Night Mother

**Beschreibung für Voice Design (englisch einfügen):**
> An ancient, disembodied woman speaking from inside a coffin. Very old but not frail. Low, dry, breathy
> voice, a cold intimate whisper that is still clearly understandable. Slow, deliberate pacing with
> long pauses, calm and absolutely certain, faintly maternal and faintly menacing. No accent, no
> emotion spikes. Neutral American English.

**Einstellungen als Startpunkt:** Stability hoch (ca. 70–80 %), Similarity mittel-hoch, Style niedrig
(0–15 %), Speed etwas langsamer als normal (ca. 0,85–0,9).

**Hall nicht in ElevenLabs hinzufügen:** Beim Import legt `tools/voice_import.py` automatisch einen
kurzen dunklen Hall und eine leichte Dämpfung über jede Night-Mother-Zeile, wie aus dem Sarg. Willst du
eine Zeile ohne Effekt, beim Import `--no-fx` angeben.

### Babette

Babette ist ein Vampir, der seit Jahrhunderten wie ein etwa zehnjähriges Mädchen aussieht: helle,
junge Stimme, aber alt, trocken und spöttisch im Ton.

**Beschreibung für Voice Design (englisch einfügen):**
> A small, very young-sounding girl's voice with an unsettlingly adult delivery. Light, clear and high,
> but calm, dry and sardonic, like someone centuries old pretending to be a child. Measured pacing,
> amused and slightly bored, never whiny or giggly. Neutral American English.

**Falls ElevenLabs Kinderstimmen im Voice Design ablehnt** oder nur Erwachsene erzeugt, stattdessen:
> A petite young woman with a light, high, youthful voice. Calm, dry and sardonic, amused and
> slightly bored, measured pacing. Neutral American English.

Danach beim Import nichts weiter tun; eine Tonhöhen-Anhebung per Effekt empfehle ich nicht (klingt
künstlich).

**Einstellungen als Startpunkt:** Stability mittel (ca. 50–60 %), Style leicht (15–30 %), Speed normal.

---

## 2. Zeilen erzeugen

Text **unverändert** übernehmen (Untertitel und Lippensync richten sich danach). Betonung nur über die
Einstellungen oder durch Neu-Generieren ändern. Die Emotion aus dem Plugin ist als Hinweis angegeben.

### Night Mother (8 Zeilen, Voice Type `FemaleUniqueNightMother`)

| LineID | Emotion | Text |
|---|---|---|
| NHV_Q00_020_00 | ruhig | Come to me, my Listener. A stranger stood among my children. She is no stranger to me. |
| NHV_Q00_020_11 | ruhig | Trust is for the living to squabble over. I know only this: her heart beats for Sithis. |
| NHV_Q00_020_12 | ruhig | What she does with it is yours to watch. |
| NHV_Q00_020_21 | ruhig | She served my family without belonging to it. Her path is her own. |
| NHV_Q00_020_31 | ruhig | I speak to one as Listener. It has always been one. |
| NHV_Q00_020_32 | leicht traurig | That is the burden of the Listener, and the wound of all the rest. |
| NHV_Q00_020_36 | ruhig | She is the one who gathers. What else she is, only Sithis knows. |
| NHV_Q00_020_39 | ruhig | Go, then. The Gleaner waits. |

Hinweis: `NHV_Q00_020_00` („Come to me…“) ist der Ruf der Night Mother; er ist derzeit im Spiel
zurückgestellt (Weg 1). Die Aufnahme schadet nicht und liegt dann bereit.

### Babette (4 Zeilen, Voice Type `FemaleChild`)

| LineID | Emotion | Text |
|---|---|---|
| NHV_Q00_010_04 | amüsiert | Oh, he means it. He just hasn't decided where to start. |
| NHV_Q00_050_09 | amüsiert | You already blame me for everything else. Let her have a turn. |
| NHV_Q00_050_14 | leicht amüsiert | How touching. Try not to make a habit of it. |
| NHV_Q00_060_79 | leicht amüsiert | Fill the beds, then. I have had quite enough of empty chairs. |

---

## 3. Speichern und importieren

1. Jede Zeile als MP3 herunterladen.
2. **Dateiname:** entweder die LineID (`NHV_Q00_020_11.mp3`) oder – bequemer – den Namen lassen,
   den ElevenLabs vergibt, solange er mit dem Zeilentext beginnt. Sonst umbenennen.
3. Alle Dateien einer Figur in einen Ordner legen, z. B. `C:\Tools\ElevenLabs\nightmother` und
   `C:\Tools\ElevenLabs\babette`.
4. Import (im Repo-Ordner):
   - Mit LineID-Namen: Dateien nach `voice_in\` kopieren, dann
     ```
     python tools/voice_import.py --check
     python tools/voice_import.py
     ```
   - Mit Text-Namen: erst zuordnen lassen, dann importieren:
     ```
     python tools/voice_import.py --from-text "C:\Tools\ElevenLabs\nightmother" --from-text "C:\Tools\ElevenLabs\babette"
     python tools/voice_import.py
     ```
   Bei der Night Mother zeigt der Import `fx: aecho…` – das ist der automatische Hall.
5. Oder einfach mir Bescheid geben, wo die Dateien liegen; ich importiere und synchronisiere.

## 4. Im Spiel prüfen

- **Night Mother:** Save vor Stage 20, Sarg öffnen, Gespräch führen. Stimme mit Hall, Lippen am
  Sarg-Objekt spielen keine Rolle (sie ist ein Sprech-Aktivator).
- **Babette:** Standoff (010_04), Deep Sanctuary (050_09, 050_14), Gedenkwand (060_79).
- Passt der Hall nicht (zu stark/zu schwach), sag es mir; ich passe den Effekt an und du importierst
  einfach neu.
