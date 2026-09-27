# Auftrag: Hrefna-Release-Letter

**Wofür:** Quest Q01 „The Unanswered Sacrament", Judgement-Ausgang „Release" (Stage 70, Option 2 „Go
back to your life. We're square."). Laut `docs/concept/konzept.md` Abschnitt 7 schickt Hrefna dem
Spieler nach sieben Ingame-Tagen einen Brief mit dem Kurzzitat „Thank you for coming. Even late." Der
vollständige Brieftext fehlt noch komplett – aktuell gibt es nur dieses eine Kurzzitat, kein Book-Record.

**Was schreiben:** Ein kurzer, in sich geschlossener Brief (ca. 4–8 Sätze, eine Buchseite reicht) in
Hrefnas Stimme: wortkarg, warmherzig auf raue Art, kümmert sich durch Alltägliches/Essen, hat Angst
davor, dass ihr das Töten leichtfällt (Charakterprofil in `docs/concept/Neue-Charakterprofile.md`,
Abschnitt „Hrefna Stormhollow"). Der Brief ist ihre Reaktion auf die Freilassung: dankbar, aber nicht
unterwürfig; sie hat sich mit dem Hof/Hjaalmarch nicht wieder versöhnt, das Zitat „Even late" soll den
Vorwurf aus Stage 40 („Where were you when he took the farm…") noch leise nachklingen lassen, ohne neue
Bitterkeit aufzumachen. Kein Bezug auf Details, die der Spieler zu diesem Zeitpunkt nicht wissen kann
(z. B. nichts über andere Rekruten). Amerikanische Schreibweise.

**Speichern:** `dialogue/Books.csv`, neue LineIDs ab `NHV_SYS_BOOK_85` (nächste freie Nummer, Stand
27.09.2026 – vor dem Einfügen den aktuellen Stand von `dialogue/Books.csv` prüfen, falls zwischenzeitlich
weitere Bücher dazugekommen sind). Spalten wie in `docs/DIALOGUE.md`: Quest `Q01`, Stage `100` (Brief
kommt nach dem Debrief), Itemtitel `HrefnaReleaseLetter`, Typ `Book`, Speaker `-`, Seitenumbrüche mit
`\n\n` wie bei den anderen Hrefna-Dokumenten in `docs/ck/M1.6-Q01-Hrefna-Dokumente.md`.

**Grenzen:** Maximal zwei Buchseiten. Kein neuer Lore-Fakt über die Night Mother oder das Black
Sacrament (das ist in den bereits bestehenden Dokumenten `NHV_SYS_BOOK_46`–`49` abschließend behandelt).
Keine Anrede, die eine bestimmte Spielerklasse/-geschlecht voraussetzt (Listener bleibt geschlechtsneutral
ansprechbar, wie überall im Mod).

**Technik:** Der Brief wird von `NHV_Q01Script.DeliverReleaseLetter()` sieben Ingame-Tage nach der
„Release"-Entscheidung automatisch ins Spielerinventar gelegt (Script bereits fertig,
`Data/Source/Scripts/NHV_Q01Script.psc`, Property `HrefnaReleaseLetter`). Sobald der Text steht, legt der
Entwickler im CK einen Book-Record `NHV_Book_HrefnaReleaseLetter` an und füllt die Script-Property.
