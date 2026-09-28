# Hauptbogen: Der Oculatus-Zirkel gegen die Familie

Plan für einen sichtbaren, eskalierenden Antagonisten-Bogen über Q00–Q06, mit Zwischenepisoden, Rätseln und
einem magischen Faden. Jeder Abschnitt trennt **[Konzept]** (bereits entschieden, siehe Quellen) von
**[Vorschlag]** (neue Idee dieses Plans, noch nicht beschlossen). Vorschläge sind durchnummeriert (V1, V2, …)
und am Ende als Entscheidungsliste zusammengefasst – **keine E-Nummern**, die vergibt nur der Entwickler in
`docs/DECISIONS.md`.

Quellen: `docs/concept/konzept.md`, `docs/GOAL.md`, `docs/DECISIONS.md` (E08, E23, E26), `docs/concept/
Veyra-Autorenprofil.md`, `docs/concept/Neue-Charakterprofile.md`, `docs/plan/Q01-*.md`, `docs/plan/Q02-*.md`,
`dialogue/NightsHarvest-dialoge-und-lore/dialogue/books/B03_…` und `B06_…`, `.../script/Q06_Blood_Harvest.md`.

## 1. Der Bogen in fünf Zeilen

**[Konzept]** Ein letzter Penitus-Oculatus-Zirkel unter Livia Maro (Schwester des in „Breaching Security“
verratenen Gaius Maro) jagt Überlebende der Dark-Brotherhood-Hauptquest und plant ein zweites Falkreath. Jede
Rekrutierungsmission versteckt ein verschlüsseltes Depeschen-Fragment bei einem Oculatus-Agenten; die fünf
Ränder ergeben zusammengesetzt „LI·VI·A·MA·RO“ – Livia Maro. Fünf Fragmente plus fünf abgeschlossene Contracts
lösen Q06 „Blood Harvest“ aus: Kriegsrat, Wahl zwischen „Strike First“ (Frostmere Watch) oder „Hold the Door“
(Verteidigung der Sanctuary), Showdown mit Livia, optionale Rekrutierung, Zeremonie vor der Night Mother.
**[Vorschlag]** Dieser Plan macht daraus einen durchgehend spürbaren Gegner statt eines nur am Questende
sichtbaren Ziels: eine Investigations-/Heat-Mechanik mit Stufen, ein Spitzel in Dawnstar, ein echtes lösbares
Chiffre-Rätsel aus den Dispatches, vier bis fünf kurze Zwischenepisoden zwischen den Contracts, und einen
magischen Faden über Veyras „Gleaning“, der zu E23 passt, ohne den Night-Mother/Listener-Kanon zu berühren.

## 2. Die Ermittlung des Gegners als sichtbarer Faden

### 2.1 Ist-Zustand [Konzept]

Der rote Faden existiert bereits als Sammelmechanik: ein Fragment pro Mission, Debrief-Fallback durch Veyra
(„You left this on the body. I didn't.“), niemals blockierend. Die Fragmente sind in
`B03_Builders_Record_and_Oculatus_Dispatches.md` als Fließtext mit `[cipher]`-Platzhaltern für unleserliche
Stellen angelegt, mit Siegelnummer I–V und Randchiffre. Das Ergebnis ist bereits vorbestimmt (der Name „Livia
Maro“); die Dispatches sind aktuell Fund-Objekte, keine Spielmechanik.

### 2.2 V1 – Investigations-/Heat-Anzeige „The Oculatus is watching“ [Vorschlag]

**Zweck:** Der Spieler soll spüren, dass der Zirkel seinerseits ermittelt, nicht nur am Ende überrascht
auftauchen. Gibt dem Hunt-Schritt jedes Contracts eine zweite Ebene: Wie viele Spuren lässt der Spieler zurück?

**Wo es einhakt:** Ein globaler Zähler `NHV_Sys_Oculatus.iHeat` (0–5), der bei bestimmten Spielerentscheidungen
in Q01–Q05 steigt oder sinkt. Jeder Contract meldet sein Ergebnis über eine neue, additive Funktion in
`NHV_ContractBaseScript` (Beschreibung, keine Änderung an bestehenden Funktionen/Properties, siehe Abschnitt 3
der Technik-Datei).

**Spielerwahl je Contract (Beispiel Q01, analog Q02–Q05):**
- Leiche/Beweise am Tatort liegen lassen → Heat +1 (Oculatus-Agent findet mehr).
- Tatort aufräumen / Beweise verbrennen (neue, kleine optionale Handlung, z. B. Aktivator „Burn the ledger
  page“) → Heat +0, aber Fragment ggf. schwerer zu finden (Trade-off).
- Den Oculatus-Agenten selbst ausschalten, bevor er berichten kann (z. B. Quintus Aufidius in Q01 leise statt
  öffentlich beseitigen) → Heat −1.
- Speech-Erfolg bei einer „Cover Story“-Option gegenüber Zeugen → Heat −1.

**Sichtbare Stufen (0–5):**
0–1 „Unbemerkt“ (keine Reaktion), 2–3 „Der Zirkel fragt nach“ (Interlude-Trigger, siehe 3.2), 4 „Der Zirkel
handelt“ (Ambush-Interlude, siehe 3.3), 5 „Vollalarm“ (Q06 startet mit verschärfter Ausgangslage: weniger
Vorbereitungszeit bei „Hold the Door“, zusätzliche Wache bei „Strike First“).

**Anzeige:** Kein eigenes HUD-Widget (kein SKSE-DLL-Bedarf). Veyra kommentiert die Stufe im Debrief-Dialog
(„The Oculatus grows careless. Or we do.“) und ein Eintrag in „The Gleaner's Ledger“ (bereits existierendes
Buch) wird per Text Replacement aktualisiert – gleiche Technik wie die Memorial-Wall-Kerzen.

**Spielerentscheidungen:** siehe oben – jede Wahl ist optional, keine blockiert das Fragment oder den
Contract-Abschluss (konsistent mit dem „nie blockierend“-Prinzip der Dispatches).

**Fehlerfälle:** Wenn ein Spieler alle Contracts blind durchrennt (kein Cover, alles liegen lassen), landet Heat
bei 5 spätestens mit Q04/Q05 – das ist gewollt, kein Bug. Wenn `NHV_Sys_Oculatus` aus irgendeinem Grund nicht
initialisiert ist (Installation mitten im Spiel, alter Save), muss `Maintenance()` iHeat mit 0 nachziehen
(additiv, siehe Save-Sicherheit).

**Technik:** 1 neue System-Quest `NHV_Sys_Oculatus`, 1 Global oder Quest-Variable `iHeat`, 5 neue,
additive Report-Funktionen (eine pro Contract-Script oder eine gemeinsame Funktion mit Parameter in
`NHV_ContractBaseScript`), Dialog-Conditions auf `iHeat`-Schwellen, 1 Text-Replacement im Ledger-Buch.

**Umfang:** M. **Risiken:** Lore keine (rein spielerinterne Konsequenz-Mechanik); Kompatibilität gering
(neue Quest/Global, keine Vanilla-Berührung); Save mittel – Variable muss versioniert und in `Maintenance()`
mit Default abgesichert werden, sonst Fehlerquelle bei Update mitten in Q01–Q05.

### 2.3 V2 – Ein Spitzel in Dawnstar [Vorschlag]

**Zweck:** Macht den Zirkel lokal spürbar, nicht nur abstrakt über einen Zähler. Liefert eine greifbare
Bedrohung für die Sanctuary selbst, bevor Q06 beginnt.

**Wo es einhakt:** Ein neuer, kleiner NPC in Dawnstar (z. B. ein Fischhändler oder Wachmann am Hafen – beides
in Dawnstar bereits als Vanilla-Rollen vorhanden, hier als reiner Alias auf eine bestehende generische
Dawnstar-Referenz oder als neuer eigener NPC ohne Vanilla-Edit), der den Spieler beobachtet, wenn er die
Sanctuary betritt/verlässt. Sichtbar wird das erst rückblickend: In Interlude 3 (siehe 3.3) taucht er tot oder
geflohen auf, mit einem Notizbuch, das seine Berichte an „den Prefect“ zeigt (Bezug zu den Dispatches, die
bereits einen „Prefect“ als Empfänger nennen).

**Spielerwahl:** Der Spieler kann ihn früh entdecken (optionale Beobachtungsszene, Perception-artig: NPC
verhält sich verdächtig bei Heat ≥ 2) und ausschalten oder anwerben/ablenken (Speech) → das senkt Heat um 1
und liefert eine zusätzliche, kleine Szene, aber ist nicht verpflichtend.

**Fehlerfälle:** Wird der Spitzel nie entdeckt, bleibt er bis Interlude 3 unsichtbar und die Ambush-Episode
läuft ohne Vorwarnung ab – ebenfalls eine gültige, beabsichtigte Spielweise.

**Technik:** 1 neuer NPC (eigener Alias, kein Vanilla-Edit), 1 kleines Package-Set („Watch the Sanctuary
entrance“), 1 optionale Kurzszene, Verknüpfung mit `iHeat`.

**Umfang:** S–M. **Risiken:** gering; Navmesh-Berührung in Dawnstar vermeiden (Package auf bestehenden Wegen,
keine neuen Navmesh-Kanten, analog zu Pathing-Option B aus Q00).

### 2.4 V3 – Das Chiffre-Rätsel: Dispatches als echtes Puzzle [Vorschlag]

**Zweck:** Erfüllt die Vorgabe „Rätsel/Codes“ konkret und nutzt ein bereits existierendes Textobjekt (die
Dispatches) doppelt: Fund-Item **und** Spielmechanik.

**Ist-Zustand [Konzept]:** Die fünf Fragmente tragen bereits eine Randchiffre (LI/VI/A/MA/RO), die in
Siegelreihenfolge den Namen ergibt. Die `[cipher]`-Stellen im Fließtext sind bislang nur Flavour
(unleserlich, keine Spielmechanik).

**[Vorschlag] Ausbau zu einem lösbaren Rätsel:** Ein Buch/Zettel „A Prefect's Key“ (Fundort: bei Livia Maros
Habseligkeiten in Q06 selbst, ODER optional früher bei Aelius in Q02, da er als „Clerk“ plausibel Zugriff auf
Verwaltungsmaterial hat) zeigt eine einfache Verschiebe-Chiffre (Caesar-Shift oder ein Buchstaben-Ersetzungs-
Raster, textbasiert – keine SKSE-Minigame-DLL nötig). Findet der Spieler den Schlüssel **vor** dem letzten
Fragment, lassen sich die `[cipher]`-Stellen der bereits gesammelten Fragmente nachträglich lesen (ein neues,
zweites Buch pro Fragment mit „decoded“-Text, das erst bei Schlüsselbesitz + Fragmentbesitz im Inventar
erscheint – technisch: `AddItem` auf ein `NHV_Note_DispatchXX_Decoded`, ausgelöst durch ein
`OnItemAdded`-Script auf den Schlüssel, prüft welche Fragmente bereits im Inventar/Aliasbesitz sind).

**Spielerwahl:** Optional. Wer den Schlüssel nie findet, bekommt trotzdem Q06 wie geplant (Fragmente reichen
allein zum Questfortschritt – das „nie blockierend“-Prinzip bleibt gültig). Wer den Schlüssel findet, erfährt
zusätzliche Hintergrundinformationen: z. B. dass der Oculatus-Zirkel kleiner ist als er tut, oder dass es
innerhalb des Zirkels Uneinigkeit über Livias Kurs gibt (Future Hook für V5, „Der Zweifler“, siehe 3.4).

**Fehlerfälle:** Schlüssel gefunden, aber kein Fragment im Besitz → nichts passiert, kein Fehlerzustand.
Fragmente in falscher Reihenfolge gesammelt → unproblematisch, da jedes Fragment einzeln decodiert wird, nicht
sequenziell.

**Technik:** 1 neues Buch (Schlüssel-Item + Erklärtext), 5 neue „Decoded“-Bücher (additive Varianten der
bestehenden Dispatches, keine Änderung der Originale), 1 kleines Script (`OnItemAdded`-Check oder einfacher:
ein Aktivator/Dialog „Apply the key“ bei Veyra, die das für den Spieler übersetzt – schlanker, vermeidet
Script-Overhead). **Empfehlung:** die Veyra-Dialog-Variante statt Script-Automatik – passt zu „Conditions vor
Scripts“ und braucht kein `OnItemAdded`.

**Umfang:** S (mit Veyra-Dialog-Variante) bis M (mit Script-Variante). **Risiken:** Lore keine (reine
Fleisch-Ergänzung zu bereits bestehenden Texten); Kompatibilität keine; Save gering, da rein additive Items/
Dialoge ohne neue Stages.

### 2.5 Status-Tracking [Konzept, bereits vorgesehen]

Das Konzept nennt bereits ein „Status-Tracking“ für die Dispatches (Abschnitt im Konzeptdokument nach dem
Fragment-Prinzip, Details dort nicht vollständig ausgeführt). V1 (Heat) und V3 (Chiffre) sind als konkrete
Ausgestaltung dieses bereits angelegten, aber noch offenen Trackings zu verstehen – kein Widerspruch, sondern
Füllung einer Lücke.

## 3. Zwischenepisoden zwischen den Contracts

**[Konzept]** Zwischen den Contracts ist aktuell nichts vorgesehen außer Banter-Szenen in der Sanctuary
(`NHV_Sys_Banter`, ab Abschluss Q01) und dem passiven Fragment-Sammeln. Es gibt keine aktiven
Oculatus-Auftritte vor Q06.

**[Vorschlag]** Vier kurze, optionale Interludes zwischen den Contracts, die den Zirkel als aktiv Handelnden
zeigen. Jedes Interlude ist eigenständig abschließbar in 5–10 Minuten, keines blockiert den nächsten Contract,
alle sind an `iHeat`-Schwellen gekoppelt (siehe 2.2), damit sie sich an den Spielstil anpassen statt starr
nach Contract-Nummer zu feuern.

### 3.1 V4 – Interlude „First Blood“ (nach Q01, Heat ≥ 1) [Vorschlag]

**Zweck:** Erster, kleiner Nadelstich – zeigt, dass der Zirkel reagiert, ohne die Sanctuary zu gefährden.

**Wo:** Ein optionaler Reisender-Überfall auf dem Weg zwischen zwei Städten (Story-Manager-Trigger analog zu
Vanilla-Zufallsbegegnungen), zwei bis drei Oculatus-Söldner greifen den Spieler an, einer trägt einen kurzen
Brief bei sich („…the Gleaner's pups are getting careless…“) – reiner Flavour-Fund, kein neues Fragment.

**Spielerwahl:** Kampf ist optional vermeidbar (Fliehen/Schleichen), da nur eine Zufallsbegegnung, kein
Quest-Zwang.

**Technik:** 1 Encounter-FormList mit 2–3 Söldner-Templates (bereits laut Scope „Söldner-Templates“ als
Neben-NPC-Kategorie vorgesehen), Story-Manager-Quest mit Bedingung auf `iHeat`, 1 Flavour-Item.

**Umfang:** S. **Risiken:** minimal.

### 3.2 V5 – Interlude „The Doubter“ (nach Q02 oder Q03, Heat ≥ 2) [Vorschlag]

**Zweck:** Führt eine zweite Stimme im Oculatus-Zirkel ein – nicht alle folgen Livia bedingungslos. Sät einen
moralischen Zweifel, der zu Livias eigenem Charakterbogen passt („Antrieb: sie prüft den Unterschied zwischen
Gerechtigkeit und Rache“) und in Q06 zurückkehren kann (z. B. als Info, die den versteckten Gnadenpfad mit
Livia erleichtert).

**Wo:** Ein Bote/Ex-Oculatus-Kontakt sucht den Spieler in einer Taverne auf (kein neuer NPC-Import nötig,
über Radiant-ähnliche Story-Manager-Szene mit einem neuen kleinen Charakter „Aelius' Cousin“ o. Ä. – oder
Wiederverwendung eines bereits vorgesehenen Nebenfigur-Templates), bietet Informationen gegen Bezahlung oder
im Austausch für Gnade gegenüber einem gefangenen Oculatus-Agenten.

**Spielerwahl:** Informationen annehmen (Speech oder Gold) → kleiner Lore-Zugewinn plus Vorteil in Q06
(z. B. kennt der Spieler Frostmere Watch vorab grob, was „Strike First“ leichter macht). Ablehnen/misstrauen
→ keine Konsequenz, nur verpasster Bonus.

**Fehlerfälle:** Bote kann theoretisch ignoriert werden; Szene läuft dann einfach nie.

**Technik:** 1 neuer kleiner NPC (Alias, temporär), 1 kurze Dialog-Szene, 1 Bonus-Flag für Q06
(`NHV_Q06_FrostmereIntel` o. Ä., additiv).

**Umfang:** S–M. **Risiken:** Lore: Name/Rolle muss mit `lore-editor` abgestimmt werden, bevor Codex Text
schreibt (Gefahr, zu viel über Livia vorwegzunehmen).

### 3.3 V6 – Interlude „Knock at Dawnstar“, Spitzel-Ambush (nach Q03/Q04, Heat ≥ 3) [Vorschlag]

**Zweck:** Der Zirkel greift zum ersten Mal die Sanctuary-Umgebung direkt an – erhöht den Einsatz spürbar vor
Q06, ohne das Finale vorwegzunehmen. Hier taucht optional der Spitzel aus V2 wieder auf (tot aufgefunden oder
in einer kurzen Verhör-/Verfolgungsszene).

**Wo:** Ein kleiner Trupp (3–4 Oculatus-Agenten) versucht, sich Zutritt zur äußeren Vanilla-Sanctuary zu
verschaffen oder observiert sie von außen; der Spieler trifft sie beim Betreten/Verlassen an, **nicht** in der
Deep Sanctuary selbst (keine Navmesh-/Zell-Edits nötig, Begegnung in der bereits per Script erreichbaren
Außenumgebung oder am Eingang, analog zur bestehenden Pathing-Option B ohne Navmesh-Edits).

**Spielerwahl:** Kampf, Verhör eines Gefangenen (Speech, liefert Vorwarnung für Q06 oder eine Heat-Senkung um
1 als Belohnung für „den Zirkel zurückgedrängt“), oder Beobachten und Folgen (führt zu einem kleinen Versteck
mit Loot, keine neue Zelle nötig – ein Zeltlager im Umland reicht).

**Fehlerfälle:** Wird die Begegnung verpasst (Spieler nutzt Schnellreise direkt in die Sanctuary), entfällt sie
einfach; kein Blocker.

**Technik:** 1 Encounter mit 3–4 Agenten-Templates, 1 optionales Verhör-Dialogset, Verknüpfung mit V2.

**Umfang:** M. **Risiken:** Kompatibilität – Encounter-Zone/Platzierung nahe Vanilla-Sanctuary muss die
bestehende „Never Resets“-Zone respektieren und darf keine Vanilla-Zelle direkt referenzieren (sonst neue
Zell-Kopie nach E16). Am saubersten: Encounter im Umland (Wildnis-Zelle), nicht in `DawnstarSanctuary` selbst.

### 3.4 V7 – Interlude „The Empty Chair“ (nach Q04/Q05, Heat ≥ 4) [Vorschlag]

**Zweck:** Letzte Eskalationsstufe vor Q06 – der Zirkel probiert einen direkten Zugriffsversuch auf ein
Familienmitglied außerhalb der Sanctuary (z. B. ein rekrutiertes Mitglied wird auf einem eigenen Weg
abgefangen), scheitert aber knapp. Zeigt handfest, dass Q06 dringend ist, ohne die Sanctuary selbst zu
gefährden (das bleibt Livias großer Zug im Finale).

**Wo:** Kurze, erzwungene Mini-Szene beim Betreten der Sanctuary: ein verletztes Familienmitglied berichtet
von einem Hinterhalt (reine Erzähl-Szene, kein separates Interior nötig).

**Spielerwahl:** Nur Dialogreaktion (trösten, zum Gegenschlag drängen, abwarten) – keine Mechanik-Verzweigung
nötig, dies ist bewusst die leiseste, dialoglastigste Episode vor dem lauten Finale.

**Technik:** 1 kurze Szene, keine neuen NPCs (nutzt bereits rekrutierte Story-Charaktere), 1 Journal-Eintrag.

**Umfang:** S. **Risiken:** minimal; Achtung auf Konsistenz, welches Mitglied betroffen ist (nur wenn
`NHV_Status_<Name>` = 1, sonst Variante mit generischem Familienmitglied oder Veyra selbst).

## 4. Ein Überfall auf die Sanctuary vor dem Finale?

**[Vorschlag] Bewusst NICHT empfohlen für v1.0:** Ein echter Raid-Versuch auf die Deep Sanctuary selbst (mit
Kampf in den eigenen Zellen) wäre der stärkste Move, kollidiert aber mit zwei harten Leitplanken: (1) E16/E09
verbietet Navmesh-Edits und zusätzliche Zell-Kopien der Vanilla-Sanctuary, ein Kampf mit Wellen bräuchte
sauber vorbereitete Encounter-Zonen in der Deep Sanctuary, die aktuell als privater, ruhiger Familienraum
designt ist; (2) Q06 „Hold the Door“ ist bereits exakt dieser Moment – ein Raid vorher würde ihn erzählerisch
vorwegnehmen und abwerten. Interlude V6 („Knock at Dawnstar“) liefert den gewünschten Vorgeschmack, ohne die
Deep Sanctuary selbst zu öffnen. Empfehlung: Raid-Idee bewusst für Q06 reservieren, nicht duplizieren.

## 5. Ein doppelter Agent?

**[Vorschlag]** Statt eines vollen Companion-Verrats (hoher Aufwand, hohes Lore-Risiko bei fünf fest
geschriebenen Rekruten mit eigenem Autorenprofil) schlägt dieser Plan die **kleinere** Variante V2 (Spitzel in
Dawnstar, kein Familienmitglied) vor. Ein Verrat aus den eigenen Reihen würde bedeuten, einem der fünf
Story-Rekruten nachträglich eine Doppelrolle aufzuzwingen, die ihr Autorenprofil (`Neue-Charakterprofile.md`)
nicht vorsieht, und hätte Save-Kompatibilitätsfolgen (neues Status-Flag mitten in bestehenden
`NHV_Status_<Name>`-Werten). **Nicht empfohlen**, außer der Entwickler möchte es explizit als Twist für Q06
selbst (dort risikoärmer, weil ohnehin neuer Inhalt).

## 6. Rätsel und Siegel

**[Konzept]** Bereits vorhanden: „The Four Stillnesses“ in Q03 (vier drehbare Säulen, Reihenfolge aus
Nireldas Notizen) als eigenständiges Fallen-/Zugangsrätsel, unabhängig vom Oculatus-Faden. Kein
Überarbeitungsbedarf durch diesen Plan.

**[Vorschlag]** V3 (Chiffre-Schlüssel, Abschnitt 2.4) ist das zusätzliche Rätsel-Element **des Hauptbogens**
selbst – bewusst textbasiert und optional, damit es sich von „The Four Stillnesses“ (physisches
Zugangsrätsel) unterscheidet und keine zweite Mechanik derselben Art dupliziert.

### V8 – Ein versiegeltes Fach in der Deep Sanctuary [Vorschlag, niedrige Priorität]

**Zweck:** Kleiner Bonus-Moment für Sammler: ein verschlossener Schrank/Tresor im Ledger Room (Veyras
Wohnort), der sich erst öffnen lässt, wenn alle fünf Dispatches **und** der Chiffre-Schlüssel (V3) im Besitz
waren (Nachweis über ein Quest-Flag, nicht über Item-Besitz-Check zur Laufzeit, um Item-Verlust nicht zu
bestrafen). Inhalt: ein optionales Lore-Buch über Veyras Zeit in Cheydinhal oder ein kleines kosmetisches
Extra. **Kein Pflichtinhalt, keine neue Zelle** – ein Möbelstück im bereits geplanten Ledger Room reicht.
**Umfang:** S. **Risiken:** minimal, da rein additiv und optional. Nur sinnvoll, wenn V3 umgesetzt wird.

## 7. Der magische Faden

**[Konzept, harte Grenze aus E23]** Veyra ist laut Autorenprofil *nicht* zwangsläufig unverwundbar (Alter und
gewöhnliche Waffen töten sie nicht, eine außergewöhnliche Ursache ist bewusst offen und darf **nicht** ohne
weitere Entscheidung eingeführt werden – kein Artefakt, kein Ritual, kein göttliches Eingreifen, kein
Rückkehrmechanismus ungefragt). Sie ist keine der fünf Kinder aus „The Night Mother's Truth“ und nicht
automatisch Sithis' „erste Dienerin“. Jede magische Ausgestaltung muss diese Linie respektieren.

### V9 – „Gleaning“ als Ritual, das Echos der Toten zeigt [Vorschlag]

**Zweck:** Erfüllt den Wunsch nach einem magischen Faden, ohne Nacht-Mutter-Kanon oder E23-Grenzen zu berühren:
Veyras Tätigkeit als „the Gleaner“ – sie „sammelt auf, was die Schnitter übrig ließen“ – lässt sich wörtlich
als eine kleine, persönliche Magiebegabung lesen, keine Brotherhood-Zeremonie und kein Night-Mother-Ritual.

**Konkret:** Eine seltene, kurze Fähigkeit Veyras (nicht des Spielers – Spieler-Zugriff nur optional, siehe
unten), an markanten Tatorten „Echos“ zu lesen: flüchtige, stumme Sinneseindrücke des letzten Sterbenden. Sie
nutzt das bereits geplante `NHV_SenseDarknessEffect` / die Lesser Power „Sense the Darkness“ (bereits im
Konzept als Veyras Belohnungs-Gabe an den Listener am Ende von Q06 vorgesehen, Zeile 070_22) als **bestehenden
Hook**: Dieser Plan schlägt vor, „Sense the Darkness“ narrativ als kleine Ausprägung von Veyras eigenem
„Gleaning“ zu erklären, statt eine zusätzliche neue Fähigkeit zu erfinden.

**Wo es einhakt:** In den Hunt-Phasen von Q01–Q05 kommentiert Veyra gelegentlich per Ferngespräch/Notiz, was
sie an einem Tatort „liest“ (rein narrativ, per Dialog/Buch, keine Spielmechanik) – gibt Hinweise, ohne
Systeme zu duplizieren. In Q06 kann eine kurze Szene vor dem Showdown zeigen, wie Veyra an Frostmere Watch
oder in der Sanctuary kurz „liest“, was dort geschah – ein atmosphärischer Moment, kein Gameplay-Rätsel.

**Spielerwahl:** Rein optional/narrativ; keine Konsequenz-Verzweigung nötig. Wer mag, kann dies als
Erklärung für V3 (Chiffre) lesen: Veyra „liest“ den Zusammenhang der Fragmente, statt reinen
Verstandes-Scharfsinns – beides schließt sich nicht aus.

**Grenzen zu E23:** Keine Aussage über Veyras Sterblichkeit, keine Rückkehr-Mechanik, kein neues Artefakt,
kein Bezug zu den fünf Kindern der Gründungslegende. Nur eine narrative Lesart einer bereits vergebenen,
bestehenden Fähigkeit.

**Technik:** Keine neuen Records nötig außer optional 1–2 kurzen Dialogzeilen/Notizen pro Mission (Textarbeit
für Codex, siehe Codex-Briefs). Die Lesser Power selbst ist bereits geplant.

**Umfang:** S (nur Text). **Risiken:** Lore – vor Text-Auftrag zwingend mit `lore-editor` und idealerweise
kurz mit dem Entwickler abstimmen, da es nah an E23 liegt (Grenze: Beobachtung, nicht Herkunftserklärung).

### V10 – Ein altes Black-Hand-Relikt bei Livia [Vorschlag, optional/niedrige Priorität]

**Zweck:** Bietet einen zusätzlichen, handfesteren magischen Moment im Finale, falls gewünscht – **explizit
optional**, da Risiko höher als V9.

**Konkret:** Livia Maro (oder ein toter Oculatus-Vorgänger) besitzt ein kleines, namenloses Relikt unbekannter
Herkunft, das sie nie verstanden hat (Oculatus ist eine weltliche Organisation – das Relikt wäre ein Fund,
kein Besitz-Glaube). Bei ihrem Fall (Showdown, Stage 40) flackert es kurz auf; Veyra erkennt etwas Vertrautes
(„Cheydinhal had one of these. We called it a mistake.“) – reiner Flavour-Moment, **kein neuer Spell, kein
Spieler-Item mit Funktion**, um Scope und Risiko klein zu halten. Nur eine Zeile plus ein Deko-Item.

**Grenzen:** Kein Bezug zu Mephala, keine neue Gottheit, keine erklärte Herkunft – bewusst vage gehalten, um
keine ungeprüfte Lore-Behauptung zu setzen.

**Technik:** 1 Deko-Item, 1–2 Dialogzeilen. **Umfang:** S. **Risiken:** Lore mittel (jedes neue Artefakt mit
Brotherhood-Bezug braucht `lore-editor`-Prüfung, da nah an Black-Hand-Kanon); am besten ganz weglassen, wenn
Zeit/Risiko-Budget knapp ist – V9 allein trägt den „magischen Faden“ bereits ausreichend.

## 8. Priorisierte Empfehlung

**Für v1.0 (kleiner, sicherer Kern):**
1. V1 – Heat-Mechanik (`NHV_Sys_Oculatus`) – trägt den ganzen Bogen, moderat im Aufwand (M).
2. V3 – Chiffre-Schlüssel über Veyra-Dialog-Variante (S) – erfüllt „Rätsel“ explizit, geringes Risiko.
3. V4 und V6 – je ein frühes und ein spätes Interlude (S/M) – reicht für spürbare Eskalation ohne
   Interlude-Inflation.
4. V9 – Gleaning als narrativer Faden (S, reine Textarbeit) – erfüllt „magisch“ ohne E23-Risiko.

**Zurückstellen auf später (v1.1/Phase 2) oder nur bei Kapazität:**
- V2 (Spitzel) und V5 (Zweifler) – schön, aber nicht tragend; erst ergänzen, wenn der Kern steht.
- V7 (Empty Chair) – nett, aber Dialog-Ersatz für V6 möglich, Redundanzgefahr.
- V8 (verschlossenes Fach) – reines Bonus-Feature, jederzeit nachrüstbar.
- V10 (Relikt) – höchstes Lore-Risiko im Verhältnis zum Ertrag, nur mit expliziter Freigabe.

**Explizit nicht für v1.0:** Sanctuary-Raid vor Q06 (Abschnitt 4), doppelter Agent unter den Story-Rekruten
(Abschnitt 5) – beide Ideen kollidieren mit bestehenden Leitplanken oder dupliziert bereits geplante Inhalte.

## 9. Entscheidungen, die der Entwickler treffen muss

1. Soll die Heat-Mechanik (V1) umgesetzt werden, und wenn ja: mit oder ohne UI-sichtbaren Zahlenwert (MCM-Debug
   vs. rein narrativ über Veyras Kommentare)?
2. Soll der Chiffre-Schlüssel (V3) über einen Veyra-Dialog (schlank, empfohlen) oder ein automatisches
   Item-Script (mehr Immersion, mehr Scripting-Aufwand) laufen?
3. Welche und wie viele Interludes (V4–V7) sollen in v1.0? Empfehlung: V4 + V6, Rest zurückstellen.
4. Ist V9 (Gleaning-Faden) als narrative Ausdeutung von „Sense the Darkness“ akzeptabel, oder soll die Lesser
   Power bewusst ohne zusätzliche Deutung bleiben, bis der Entwickler selbst über Veyras Magie entscheidet?
5. Soll V10 (Black-Hand-Relikt) überhaupt verfolgt werden, oder bewusst gestrichen bleiben (Empfehlung:
   streichen für v1.0)?
6. Soll V2 (Spitzel in Dawnstar) als eigenständiger NPC oder rein narrativ (nur in Interlude V6 erwähnt, ohne
   eigenen vorherigen Auftritt) umgesetzt werden – Aufwand vs. Wirkung?
7. Namensfindung für neue Nebenfiguren aus V5/V6 (falls umgesetzt) – an `Neue-Charakterprofile.md`-Konventionen
   anlehnen, vom Entwickler/`lore-editor` gegenprüfen lassen, bevor Codex Text schreibt.
