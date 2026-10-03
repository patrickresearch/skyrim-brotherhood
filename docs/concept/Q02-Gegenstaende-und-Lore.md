# Q02 – Gegenstände und vertiefende Lore

Stand: 27.09.2026. Dieses Dokument ergänzt *Cold Waters* um Gegenstände, die Sings’ Geschichte, die alte Shadowscale-Tradition und den Oculatus-Handlungsfaden sichtbar machen. Die Texte sind Autorenmaterial; englische Ingame-Texte stehen im CSV-Master.

## 1. Shadowscale Wraps

**EditorID:** `NHV_Armor_ShadowscaleWraps`

**Anzeigename:** *Shadowscale Wraps*

**Typ:** leichte Handschuhe / einzigartige Q02-Belohnung

**Vanilla-Basis:** bestehendes leichtes Handschuh-Mesh, dunkel und unauffällig; kein neues Mesh erforderlich.

**Effekt:** Waterbreathing und Fortify Sneak 15 %. Der Effekt ist statisch, ohne Aktivierungs-Power und ohne tägliches Limit.

**Narrative Funktion:** Die Wraps behaupten nicht, Sings nachträglich zu einem Shadowscale zu machen. Sie sind ein Arbeitsstück: feuchtes Leder, innen mit schmalen Bleistreifen beschwert, damit die Hände unter Wasser ruhig bleiben. Sings kennt die Technik aus Fragmenten von Erzählungen, nicht aus einer vollständigen Ausbildung. Veyra übergibt sie erst nach dem Urteil, weil eine Belohnung vor der Prüfung die Prüfung in eine Bezahlung verwandeln würde.

**Rekrutierungsvariante:** Bei `NHV_Q02_Result == 1` erhält der Spieler die Wraps im Debrief oder Sings legt sie in den Drowned Pool. Bei Release oder Silence bleibt nur der Pool als unzugängliches Autorenmotiv; es wird kein Belohnungsitem erzeugt. So bleibt der Gegenstand an die Entscheidung gebunden.

**Lore-Grenze:** Die Wraps sind kein Beweis, dass Sings ein echter Shadowscale war. Sie respektieren die historische Verbindung zwischen Veezara und der Brotherhood, ohne eine Ausbildung zu erfinden, die Sings nie erhalten hat.

## 2. Oculatus Dispatch Fragment 2

**EditorID:** `NHV_Note_Dispatch02`

**Anzeigename:** *Oculatus Dispatch Fragment II*

**Typ:** Note oder Book-Item; einmalig bei Aelius’ Pult in Stage 70

**Textquelle:** `dialogue/Books.csv`, `NHV_SYS_BOOK_82`

**Platzierung:** Das Fragment liegt in Aelius’ verschlossenem Pult. Es wird nach dem Tod Aelius’ zugänglich und darf nicht bereits bei Stage 60 auf dem Actor liegen. Der Spieler kann es vor dem Urteil lesen; ein CK-Fragment setzt danach `NHV_Q02_FragmentFound = 1`. Die Folgezeilen prüfen diese GlobalVariable, nicht den Besitz des Gegenstands.

**Inhaltliche Aufgabe:** Der Text bestätigt Aelius’ Informantennetz, ohne zu behaupten, dass seine Freundlichkeit vollständig gespielt war. Die Namen werden als Arbeitskürzel und Hafendaten geführt; Sings erkennt darin die Namen der Argonier. Das Fragment verweist auf eine größere Oculatus-Struktur, nennt aber weder Livia noch den späteren Angriff beim Namen.

**Wichtige Grenze:** Das Fragment macht Aelius nicht nachträglich zum reinen Bösewicht. Die Prüfung bleibt bestehen: Sings hat einen Menschen getötet, den er vor der Enthüllung als fair erlebt hat. Die neue Information verändert sein Urteil über Aelius, nicht die Verantwortung für die Tat.

## 3. Reed-Walker’s Knot

**EditorID:** `NHV_MISC_ReedWalkersKnot`

**Anzeigename:** *Reed-Walker’s Knot*

**Typ:** Misc Item, nicht verkäuflich; optionales Ausstellungsstück im Drowned Pool

**Darstellung:** Ein kurzes, graugrünes Stück Tau mit einem flachen Marschknoten. Es verwendet ein vorhandenes Seil- oder Kleinteil-Mesh, ohne neue Modellressource.

**Erwerb:** Wenn der Spieler Hakan Reed-Walker in Stage 10 nach der Leiche fragt, kann Hakan den Knoten als Beweisstück übergeben. Alternativ bleibt er am Körper und wird nur untersucht; beide Wege führen zum gleichen Questfortschritt. Das Item ist daher rein narrativ und darf den Questfortschritt nicht allein steuern.

**Bedeutung:** Der Knoten verbindet Moor, Hafen und Sings’ Handwerk. Er ist kein exklusives Argonier-Symbol: Hakan erkennt nur die Variante wieder, die er im Moor gelernt hat. Diese Einschränkung verhindert, dass die Spur automatisch alle Argonier im Hafen zu Verdächtigen macht.

**Sanctuary-Nutzung:** Nach erfolgreicher Rekrutierung kann der Knoten auf einem kleinen Pfosten im Drowned Pool platziert werden. Das ist ein sichtbares Zeichen, dass Sings seine Vergangenheit nicht abstreift, sondern in eine kontrollierte Praxis überführt.

## 4. Drowned Pool – Raum-Lore

Der Pool ist kein zweiter Schrein Sithis’ und keine geheime Argonier-Kultstätte. Er ist ein Trainingsraum: Wasser, Dunkelheit, Atemkontrolle und ein Ort, an dem Namen ausgesprochen werden können, ohne dass der Hafen sie hört.

Sings richtet drei einfache Dinge ein:

1. einen niedrigen Steg für lautloses Ein- und Aussteigen,
2. drei Trainingspfähle mit unterschiedlichen Wasserständen,
3. eine flache Steinschale, in der er die Namen der Toten mit nassem Ruß schreibt.

Die Schale wird nicht als magischer Aktivator behandelt. Sie ist ein Requisit und kann über einen eigenen Activator-Record sichtbar gemacht werden, ohne Script. Die Namen verschwinden, sobald das Wasser steigt. Damit bleibt das Motiv der Erinnerung vergänglich und passt zu Sings’ Entwicklung: Er bewahrt, ohne zu besitzen.

## 5. Lore-Anker: Shadowscales

Veezara war ein Shadowscale und später Mitglied der Brotherhood. Sings ist kein verlorener offizieller Schüler Veezaras. Sein Bezug entsteht aus Sternzeichen, argonischer Schatten-Tradition und der Geschichte eines Namens, den er nur von der Memorial Wall kennt.

Veyra darf die Verbindung anerkennen, aber nicht als Beweis für eine ununterbrochene Institution darstellen. Eine passende interne Lesart lautet: Die Brotherhood bewahrt Namen länger als Schulen ihre Lehrpläne. Sings erhält deshalb keine „Rückkehr“ zu einer bestehenden Shadowscale-Ordnung, sondern eine eigene Form von Schattenarbeit.

## 6. Lore-Anker: Sithis und die Prüfung

Die Q02-Prüfung ist keine Lehre, dass Sithis Freundlichkeit verachtet. Sie prüft, ob Sings zwischen Hass, Pflicht und Entscheidung unterscheiden kann. Veyra beobachtet, ob er den Auftrag ausführt, obwohl Aelius ihm geholfen hat, und ob er nach der Tat Verantwortung übernimmt.

Sithis bleibt dabei der theologische Horizont der Brotherhood, nicht eine sprechende Questmechanik. Kein Gegenstand in Q02 behauptet, dass Sithis Aelius’ Schuld gewogen oder Sings’ Entscheidung direkt befohlen habe.
