# Auftrag: Der Spitzel von Dawnstar (neuer NPC)

**Wofür:** Neuer, eigener NPC `NHV_Informant` (Vorschlag V2, jetzt Teil von v1.0 laut E30,
`docs/DECISIONS.md`). Beobachtet tagsüber getarnt am Dawnstar-Hafen, nachts den Sanctuary-Zugang für
den Penitus-Oculatus-Zirkel. Kann vom Spieler entlarvt und dann getötet, umgedreht (Doppelagent) oder
laufen gelassen werden – Details und Heat-Effekte in `docs/plan/Hauptbogen-Oculatus.md` Abschnitt 2.3
und `docs/plan/Hauptbogen-Technik.md` Abschnitt 4.

**Zuerst nötig – Namensfindung:** Bitte einen Namen und eine sehr kurze biografische Verankerung
vorschlagen (Nord oder Imperialer, passt zu einem Hafenarbeiter/Fischer in Dawnstar; keine Overlap mit
bereits vergebenen Namen aus `docs/concept/Neue-Charakterprofile.md`). **Vor Verwendung im Spiel muss
der Name/die Kurzbiografie vom `lore-editor`-Subagenten gegengeprüft werden** (Namenskollisionen,
Lore-Plausibilität) – dieser Auftrag liefert nur einen Vorschlag, keine Freigabe.

**Was schreiben:**
1. Ein kurzes Kurzprofil (60–100 Wörter, wie in `Neue-Charakterprofile.md`: Rolle, Hintergrund, Antrieb,
   Charakter, Schwäche, Stimme). Er ist **kein** Fanatiker – eher ein kleiner, verängstigter Mitläufer,
   der für Geld oder aus Druck berichtet, kein ideologischer Overzeugungstäter (Kontrast zu Livia Maro
   und Quintus Aufidius, die beide klarer motiviert sind). Das macht die drei Ausgänge (töten/
   umdrehen/laufen lassen) glaubwürdig unterschiedlich schwer.
2. Tagsüber-Dialogzeilen (Hafenarbeiter-Rolle, 3–5 generische Zeilen, Grüße/Feilschen-Ton, austauschbar
   mit anderen Dawnstar-NPCs).
3. Die Konfrontationsszene (Entlarvung), 8–14 Repliken: Spieler stellt ihn, er leugnet zunächst, dann
   drei klare Ausgangs-Optionen für den Spieler (töten, umdrehen, laufen lassen) mit je einer kurzen
   Reaktionszeile von ihm. Ton: nervös, kleinlaut, keine große Rede – er ist kein Redner.
4. Falls er „umgedreht“ wird: 1–2 kurze Zeilen, die andeuten, dass er ab jetzt für die Familie
   berichtet (rein narrativ, keine Spielmechanik in v1.0).

**Speichern:** `dialogue/Q_Interludes.csv` (dieselbe Datei wie der Auftrag
`2026-09-28-Interludes-FirstBlood-KnockAtDawnstar.md`, falls diese bereits angelegt ist – sonst neu
anlegen), Format wie in `docs/DIALOGUE.md`. LineID-Schema: `NHV_Informant_<Nr>` für generische Zeilen,
`NHV_InformantExpose_<Nr>` für die Konfrontationsszene.

**Grenzen:** Amerikanisches Englisch. Er kennt Livia Maro nicht persönlich (nur einen Mittelsmann/eine
Mittelsfrau) – kein direkter Draht zur Antagonistin, sonst wird er zu wichtig für seine kleine Rolle.
Keine Vorwegnahme von Q06. Kurz halten, jede Zeile höchstens 1–2 Sätze.

**Technik:** Claude legt daraus 1 NPC-Record (`NHV_Informant`), 1 platzierte Referenz, Tag-/Nacht-
Packages und die Dialog-Szene an (siehe `docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md` Schritt 7–8).
Jede Spieler-Option braucht mindestens eine nicht-leere NPC-Antwort (Standardregel).
