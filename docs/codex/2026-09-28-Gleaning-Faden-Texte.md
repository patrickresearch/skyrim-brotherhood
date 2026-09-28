# Auftrag: Gleaning-Faden – Veyras Echo-Kommentare

**Wofür:** Magischer Faden, Vorschlag V9 in `docs/plan/Hauptbogen-Oculatus.md` (Abschnitt 7). Veyras Titel
„the Gleaner“ wird narrativ als eine kleine, persönliche Fähigkeit gelesen: An markanten Tatorten liest sie
flüchtige „Echos“ des zuletzt Sterbenden. Keine neue Spielmechanik, keine neue Fähigkeit für den Spieler –
reine Kommentar-Texte, die die bereits geplante Lesser Power „Sense the Darkness“ (vergeben am Ende von Q06,
Zeile 070_22 in `Q06_Blood_Harvest.md`) narrativ vorbereiten.

**Was schreiben:** Bis zu 5 kurze Veyra-Kommentare (1–2 Sätze je Zeile), einer pro Contract (Q01–Q05), die sie
im Debrief oder als kurze Notiz äußert, nachdem der Spieler vom Tatort zurückkehrt. Inhalt: eine knappe,
sinnliche Andeutung dessen, was sie „gelesen“ hat – nie eine vollständige Erklärung ihrer Fähigkeit, nie eine
Aussage über ihre eigene Natur oder Herkunft. Beispielrichtung (nicht wörtlich übernehmen): „I felt him leave.
Fear, then nothing. The nothing took longer than it should have.“ Ton: leise, präzise, trockener Humor bleibt
möglich, aber selten hier (siehe Veyras Stimme: „Spricht leise und präzise, wird nie laut“).

**Speichern:** In die jeweiligen Quest-CSVs einfügen, wo bereits Debrief-Zeilen existieren: `dialogue/Q01.csv`
bis perspektivisch `Q05.csv` (Q02 bereits vorhanden, Q03–Q05 evtl. noch nicht angelegt – falls eine CSV noch
fehlt, Text trotzdem liefern, Claude legt die Zeile an, sobald die Datei existiert). LineID-Schema:
`NHV_Q0<N>_VeyraGleaning_01`. Bestehende Debrief-LineIDs nicht verändern, dies sind zusätzliche, neue Zeilen.

**Grenzen:** Amerikanisches Englisch. **Harte Grenze:** keine Aussage über Veyras Sterblichkeit, Herkunft,
Verwundbarkeit oder Bezug zu den „fünf Kindern“ aus der Gründungslegende (E23-Lore-Grenze, siehe
`docs/concept/Veyra-Autorenprofil.md`, Abschnitt „Lore-Grenze“ und „Existenz und mögliche Vernichtung“). Keine
Behauptung, dies sei ein Ritual, eine Zeremonie oder eine Night-Mother-nahe Praxis – rein persönliche,
wortkarge Beobachtung, kein Zauber-Showmoment. Maximal 2 Sätze pro Zeile, keine Wiederholung derselben Formel
in allen fünf Zeilen (Variation im Bild, nicht in der Grundaussage).

**Technik:** Claude fügt die Zeilen als zusätzliche, additive Debrief-Repliken in die bestehenden
Quest-CSV-Strukturen ein (Condition: Debrief-Stage erreicht). Kein neues Script, keine neue Fähigkeit, keine
Änderung an „Sense the Darkness“ selbst.
