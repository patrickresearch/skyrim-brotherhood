# Auftrag: Interlude-Texte „First Blood“ und „Knock at Dawnstar“

**Wofür:** Zwei Zwischenepisoden zwischen den Rekrutierungs-Contracts, Vorschläge V4 und V6 in `docs/plan/
Hauptbogen-Oculatus.md` (Abschnitt 3.1 und 3.3). Zeigen den Penitus-Oculatus-Zirkel als aktiv reagierenden
Gegner vor dem Finale Q06. Beide sind optionale Zufallsbegegnungen, kein Pflichtinhalt.

**Was schreiben:**

*Teil 1 – „First Blood“ (nach Q01, Heat ≥ 1):*
- 1 kurzer Flavour-Brief (30–50 Wörter), den ein besiegter Oculatus-Söldner bei sich trägt. Ton: beiläufig,
  leicht besorgt, kein direkter Bezug zu Livia Maro namentlich (sie soll erst über die Dispatches enthüllt
  werden, nicht hier vorweggenommen). Beispielrichtung (nicht wörtlich übernehmen): eine knappe Anweisung,
  „Aufmerksamkeit zu zeigen“, weil „die Gleaner's Ledger wieder Namen sammelt“.
- Optional 2–3 Kampfzeilen für die Söldner-Templates (generisch, austauschbar, kein Eigenname nötig).

*Teil 2 – „Knock at Dawnstar“ (nach Q03/Q04, Heat ≥ 3):*
- 1 kurze Verhör-Dialogszene (Spieler + 1 gefangener Oculatus-Agent), 6–10 Repliken. Der Agent weiß wenig
  Konkretes über Livias Pläne (kein Spoiler für Q06), aber genug, um Anspannung zu zeigen: der Zirkel ist
  kleiner, als er tut, und unter Druck. Zwei Gesprächsausgänge: Agent redet (Speech-Erfolg) oder schweigt
  (Speech-Misserfolg, führt zu Kampf). Ton: nervös, aber diszipliniert, kein Karikatur-Bösewicht.
- Falls der Spitzel aus Vorschlag V2 mit eingebaut wird: 1 kurze Fundtext-Notiz (20–30 Wörter) bei ihm, die
  seine Beobachtungsrolle in Dawnstar andeutet, ohne ihn zu benennen, falls er noch nicht als eigener NPC
  existiert (Entwickler entscheidet, siehe Plan-Dokument Entscheidung 6).

**Speichern:** `dialogue/Q_Interludes.csv` (neue Datei, Format wie in `docs/DIALOGUE.md` beschrieben:
Spalten für LineID, Speaker, Emotion, Text, Topic, Conditions). LineID-Schema: `NHV_ItlFB_<Nr>` für „First
Blood“, `NHV_ItlKD_<Nr>` für „Knock at Dawnstar“. Bei späterer Umbenennung: alte IDs nicht wiederverwenden,
als `DEPRECATED` markieren.

**Grenzen:** Amerikanisches Englisch. Kein Namensfall für Livia Maro in „First Blood“. Keine Vorwegnahme des
Q06-Finaltwists (Livias Gnadenpfad, Infiltration/Verteidigung-Entscheidung). Kurz halten – jede Zeile
höchstens 1–2 Sätze, Ton bleibt militärisch-knapp (siehe Livias eigene Stimme in `docs/concept/
Neue-Charakterprofile.md`: „Militärisch, knapp, bitter“ – gilt sinngemäß auch für ihre Agenten, nur weniger
gebrochen).

**Technik:** Claude baut daraus 1 Flavour-Item (Brief), 1 kleine Dialog-Szene mit Speech-Check-Verzweigung und
optional 1 Fundtext-Notiz. Jede Spieler-Option braucht mindestens eine nicht-leere NPC-Antwort (Standardregel).
