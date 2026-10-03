# Q01 – Feedback aus dem Ingame-Test: Hakan, Scavenger, Watchpost, Fallbacks

Stand: 03.10.2026. **Nichts hiervon ist ingame getestet.** Es wurde nur `plugin-text/`, `dialogue/Books.csv`, `Data/Source/Scripts/` geändert. Das echte ESP, die Dev-Kopie, `sync` und Git blieben unberührt (kein Commit). Kein Generator-Lauf, kein `--write`.

Prüfungen: Pyro kompiliert (`.tools\pyro\pyro.exe -g sse --game-path C:\Dev\brotherhood-devenv\SkyrimSE-Dev NightsHarvest.ppj`, direkt, `build.ps1` wegen Execution Policy nicht gestartet): `NHV_Q01Script` und `NHV_Q01_ReedbedSackScript` ok, 0 Fehler. Spriggit `convert-to-plugin plugin-text` in ein Temp-ESP lief ohne Fehler (Temp-Datei gelöscht), die neuen EditorIDs sind enthalten. `dialogue_lint.py`: 0 Fehler (6 alte Warnungen), `silent_voice.py`: 0 Probleme.

## 1. Ursache: Hakan steht herum (Punkt 3)

Befund aus `plugin-text/` (der CK-Export):

| Prüfpunkt | Ergebnis |
|---|---|
| Package-Reihenfolge am NPC | richtig: `AD01` (Nacht), `AD00` (Tag), `498B` (Rückfall) |
| Bedingungen / Stage-Grenzen | keine; Tag 06:00 + 960 min, Nacht 22:00 + 480 min: lückenlos |
| Template-Flags, Initially Disabled, Szenen, ForceGreet, Alias-Packages | nichts gefunden: `NHV_Hakan` hat kein Template, `HakanAlias` hat keine `PackageData`, keine Szene nutzt ihn, die Ref `NHV_HakanRef` (0048A6) ist aktiv und hat Abstand ~100 Units zu `HakanSpot` |
| `AD00` (Tag) | **Ursache 1:** Sandbox-Template mit `Allow Wandering = False` (Key 7) und Radius 384. Im Radius liegt kein Möbel/Idle-Marker aus unseren Records, also hat der Sandbox nichts zu tun und er steht. Ein Vanilla-Sandbox wandert nur mit Häkchen „Allow Wandering“. |
| `AD01` (Nacht) | **Ursache 2:** Sleep sucht ein Bett im Radius um `HakanSpot` (Platzhalter). Das Bett `NHV_Ref_Q01_HakanBed` (00B4C5, Heuhaufen `BedrollHay01`) steht inzwischen im CK, liegt aber ~1900 Units entfernt: kein Bett im Radius, er steht. |

Dasselbe Wandering-Problem hat `NHV_Pkg_Q01_SoldierWatch` (AD0A). Die Vorarbeit-Packages greifen also (Reihenfolge stimmt), sie tun nur nichts Sichtbares. Eine Ursache, die ich nicht ausschließen kann: die Dev-Kopie des ESP hat die Packages `AD00/AD01` nie bekommen (ESP-Sync). Prüfen: im CK `NHV_Hakan` öffnen, Reiter AI Packages.

## 2. Änderungen

### Packages (plugin-text/Packages, alle Sandbox-Template 01C254 bzw. Sleep 019717)

| FormID | EditorID | Änderung |
|---|---|---|
| 00AD00 | `NHV_Pkg_Q01_HakanDockDay` | geändert: Wandering an, Radius 384 auf 640 (um `HakanSpot`) |
| 00AD01 | `NHV_Pkg_Q01_HakanDockNight` | geändert: Location jetzt Bett-Ref `00B4C5`, Radius 256 |
| 00AD30 | `NHV_Pkg_Q01_HakanDockEvening` | **neu**: 18:00 bis 22:00, Sandbox um das Bett (00B4C5), Radius 640, Wandering an |
| 00AD0A | `NHV_Pkg_Q01_SoldierWatch` | geändert: Wandering und Conversation an, Radius 600 auf 700 (Near Editor Location = dort, wo jeder Soldat platziert ist) |
| 00AD31 | `NHV_Pkg_Q01_ScavengerCamp` | **neu**: Sandbox, Near Editor Location, Radius 450, Wandering an, ohne Zeitfenster, ohne Stage-Bedingung |
| 00AD32 | `NHV_Pkg_Q01_ScoutPost` | **neu**: wie oben, Radius 500, für den Scout |

Zeitfenster Hakan lückenlos: 22:00–06:00 Nacht (AD01), 06:00–18:00 Tag (AD00), 18:00–22:00 Abend (AD30, vor AD00 in der Liste), 498B als Rückfall. Kein Package hat eine Stage-Bedingung (Lehre 7).

NPC-Listen (additiv, nichts entfernt): `NHV_Hakan`: AD01, **AD30**, AD00, 498B. `NHV_Q01_MarshScavenger` (007F20): **AD31**, 0956B8. `NHV_Q01_OculatusScout` (007F21): **AD32**, 0956B8. Soldat (0089F2): unverändert (nur AD0A).

Wachposten: Es gibt keinen `NHV_Mk_Q01_*`-Marker im Watchpost (nur den deaktivierten Kartenmarker 0089F8). Ich habe nichts geraten, sondern `Near Editor Location` genommen: jeder Soldat und der Scout bleibt um seinen platzierten Standort, also im Radius des Watchposts.

### Fallback-Notizen (plugin-text/Books, `dialogue/Books.csv`)

| FormID | EditorID | im Inventar von |
|---|---|---|
| 00AD40 | `NHV_Note_Fallback_Hakan` | `NHV_Hakan` (Base) |
| 00AD41 | `NHV_Note_Fallback_Hrefna` | `NHV_Hrefna` (Base) |
| 00AD42 | `NHV_Note_Fallback_Scout` | `NHV_Q01_OculatusScout` (Base) |
| 00AD43 | `NHV_Note_Fallback_Scavenger` | `NHV_Q01_MarshScavenger` (Base, alle drei Scavenger) |

Books.csv: `NHV_Q01_010_9201`, `NHV_Q01_030_9202`, `NHV_Q01_025_9203`, `NHV_Q01_012_9204`. Für bereits gespawnte Akteure in alten Saves legt das Script die Notiz beim Tod nach (`EnsureNote`, nie doppelt).

Nicht angelegt: Quintus (Essential bis Stage 50, danach ist sein Tod gewollt und `StockQuintusBody()` legt Feldnotiz und Fragment auf die Leiche), Veyra (Essential und Invulnerable), Soldaten (haben keinen Dialog; ihr Tod ist der Weg zum Scout), Nazir/Vanilla.

### Dialog Scavenger (Punkt 4b)

Die Gesprächskette existierte schon: Hello (Cursor 1009) → Spielerzeile „Drop the ledger…“ → Scavenger → „Who hired you?“ → Scavenger → `ReedbedHostile()`. Problem: die erste Spielerzeile (`NHV_Q01V2_reed_1_INFO01`, 007140) war nur bei Cursor 40 sichtbar, und der kommt nur aus dem Hello. Geändert: Bedingung **Cursor == 40 ODER Cursor == 1009** (OR-Flag). Damit ist das Pflichtgespräch ein Hub mit Spielerzeile, auch wenn das Hello nie gelaufen ist (Lehre 3). Sprecherbedingung bleibt `GetIsID 007F20` (gilt für alle drei Klone). **Keine neuen Dialogzeilen**, kein neues Voice, keine neuen LineIDs im Dialog (vorhandene 2021–2025: 2 Spielerzeilen, 3 Scavenger-Zeilen, alle innerhalb der Längenregeln).

### Script `NHV_Q01Script.psc` (nur additiv)

- `ReedbedHostile()` (vom Dialogende aufgerufen) setzt nur noch Flag und Timer (1,5 s); der Angriff kommt aus `OnUpdate` → `ReedbedStartFight()`: Aggression 2, Confidence 4, `StartCombat(Spieler)`, `EvaluatePackage()`. Kein `SetGhost`. Die Scavenger kommen aus `ScavengerRefs`, sonst per FormID 0089E3/0089E4/0089E2 (Lehre 6). Keine Fraktionen nötig (die Base-NPCs haben keine).
- Sack: `LockReedbedSack()` (`BlockActivation(True)`), Freigabe `ReleaseReedbedSack()` wenn alle Scavenger tot/deaktiviert sind, oder ca. 2 Minuten lang keiner mehr kämpft (geflohen), oder die Quest Stage ≥ 20 hat. Sack-Ref per Property `ReedbedSack` oder FormID 0089E1. Die Sperre gilt nur bei Stage 10–19 und solange nicht freigegeben (`IsReedbedLootFree()`).
- Neues Script `NHV_Q01_ReedbedSackScript` (am Sack-Ref im CK anhängen, optional, siehe CK-Aufgabe): sperrt beim Laden der Ref. Ohne es sperrt das Quest-Script erst, wenn `OnContractLoadGame` oder `ReedbedHostile` läuft (Lücke: Spieler plündert vor dem Gespräch).
- Alle Watches laufen im bestehenden `OnUpdate` und stehen in `RearmWatches()` (Lehre 9).
- Todes-Handler (Poll alle 5 s, nur Stage 10–69, scharf geschaltet über einen Override von `FillVeyraAlias()`, den das Stage-10-Fragment ohnehin aufruft, plus `OnContractLoadGame`):
  - Hakan tot bei Stage < 20: Notiz auf der Leiche, Sack frei, dann dieselben Aufrufe wie am Ende der hret-Themen (`OnMarkerReturned`, Objective 9003 fertig / 9004 an, Stage 20, Cursor 0x007000 = 0, 0x007001 = 43). Die Quest läuft zur Farm weiter.
  - Hrefna tot bei Stage 20–69: Notiz auf der Leiche, `NHV_Status_Hrefna = KILLED`, `GiveOculatusFragment()`, `SetStage(100)` (Debrief wie bei „Silence“).
  - Scavenger tot: Notiz (aus dem Watch). Scout: Fallback bleibt der vorhandene `ScoutYields()`-Pfad (toter Scout → Sprung zum Camp), die Notiz liegt in seinem Inventar.
- Neue Variablen/Properties/Funktionen, keine Umbenennung oder Löschung. Neue Variablen starten mit `False`/`0`, Reset bei Stage < 10 in `OnContractLoadGame`.

## 3. Dateien

- Geändert: `plugin-text/Packages/NHV_Pkg_Q01_HakanDockDay - 00AD00…`, `…HakanDockNight - 00AD01…`, `…SoldierWatch - 00AD0A…`; `plugin-text/Npcs/NHV_Hakan`, `NHV_Hrefna`, `NHV_Q01_OculatusScout`, `NHV_Q01_MarshScavenger`; `plugin-text/DialogTopics/NHV_Q01V2_reed_1 - 00713E…/Responses/NHV_Q01V2_reed_1_INFO01 - 007140…`; `dialogue/Books.csv` (4 Zeilen); `Data/Source/Scripts/NHV_Q01Script.psc`.
- Neu: `plugin-text/Packages/` AD30, AD31, AD32; `plugin-text/Books/NHV_Note_Fallback_{Hakan,Hrefna,Scout,Scavenger}`; `Data/Source/Scripts/NHV_Q01_ReedbedSackScript.psc`; dieses Dokument.
- FormIDs belegt: 0xAD30–0xAD32 (Packages), 0xAD40–0xAD43 (Notizen). Gegen `plugin-text/` geprüft, keine Kollision.

## 4. CK-Aufgaben

Voraussetzung: ESP aus `plugin-text/` neu bauen (`plugin_text.ps1 ToPlugin`, nur du, bei geschlossenem CK und Spiel), dann `NightsHarvest.esp` im CK öffnen und einmal speichern.

**KONTROLLIEREN (K)**
- K1 `NHV_Hakan` → AI Packages: Reihenfolge von oben `NHV_Pkg_Q01_HakanDockNight`, `…HakanDockEvening`, `…HakanDockDay`, `NHV_Pkg_Hakan_Fish`. Marker `NHV_Mk_Q01_HakanSpot` und Bett `NHV_Ref_Q01_HakanBed` auf Navmesh (Bett nicht im Wasser).
- K2 `NHV_Q01_MarshScavenger` und `NHV_Q01_OculatusScout`: AI Packages zeigen oben unser Package, darunter 0956B8. Scavenger-Aggression bleibt Unaggressive (das Script setzt sie).
- K3 Quest `NHV_Q01_TheUnansweredSacrament` → Scripts → `NHV_Q01Script`: Properties `ScavengerRefs` (3 Einträge) unverändert gefüllt. Die neue Property `ReedbedSack` ist leer (optional).
- K4 Topic `NHV_Q01V2_reed_1`, INFO 007140: Conditions zeigen `GetStage == 12`, `NHV_Q01V2_CursorScav == 40 OR`, `NHV_Q01V2_CursorScav == 1009`, `GetIsID NHV_Q01_MarshScavenger`.

**ÄNDERN (Ä)**
- Ä1 Sack-Script: Cell View → Tamriel, Zelle mit `0089E1` (Ref des Sacks `NHV_Cont_Q01_ReedbedSack`, Koordinate -32768 / 71776 / -13888) → Ref doppelklicken → Reiter Scripts → Add → `NHV_Q01_ReedbedSackScript` → OK. Optional im Quest-Script die Property `ReedbedSack` auf diese Ref setzen (Edit Properties → Auto-Fill ist nicht nötig, FormID-Rückfall greift).
- Ä2 Dem Sack-Ref im Reiter „Reference“ den Haken **Persistent** lassen/nicht setzen (nicht nötig); wichtig ist nur, dass er `Initially Disabled` nicht hat.

**NEU ERSTELLEN (N)** – nur damit die Sandbox-Packages sichtbar etwas tun. Alle Objekte aus dem Object Window → WorldObjects → Furniture bzw. Static (Namen gegen Skyrim.esm geprüft, jeweils als Ref in die Zelle ziehen, nahe am genannten Marker; auf Navmesh-Erreichbarkeit achten, keine Koordinaten von mir):
- N1 **Hakan, Steg** (um `NHV_Mk_Q01_HakanSpot` 0048A7, höchstens 600 Units): 1× Sitzbank `FarmBench01F` (0A4AD6) oder Hocker `WoodenBarStool` (074EC6) zum Sitzen/Essen; 1× `CraftingTanningRackMarker` (0727A1) für „Netze flicken“ (Bastelanimation am Gestell); falls vorhanden eine Lagerfeuer-Kochstelle aus den Vanilla-Statics (Suchbegriff „Campfire“ unter Furniture, Cooking). Für Fischen gibt es in Vanilla keine Animation, ersatzweise ein Sitzmarker am Wasser (`InvisibleChairMarkerF`, 037A1E). Zusätzlich Idle-Marker (World Objects → Idle Marker) für Stehen/Lehnen am Geländer.
- N2 **Hakan, Abend** (um das Bett 00B4C5, ≤ 600 Units): 1× `InvisibleChairMarkerF` (037A1E) oder Hocker, plus die Feuerstelle aus N1, falls sie dort stehen soll.
- N3 **Scavenger** (um `Scav01–03`, Radius 450): 1× Kiste/Fass/Sack als „Plünderziel“ (Container-Refs mit Inhalt), 1× Sitzmarker (`InvisibleChairMarkerF`) und ein Lagerfeuer. Sandbox-NPCs nutzen Möbel und Idle-Marker, an Containern plündern sie nicht von selbst; der Sack 0089E1 liegt im Radius.
- N4 **Watchpost** (um Soldat01–04 und Scout, Radius 700 bzw. 500): 2× Bank `FarmBench01F` oder `NobleBench03Front` (0C2A03) an der Feuerstelle, 1× `InvisibleChairMarkerF` (037A1E) als Wachposten-Sitz, 1× Lehnmarker `CounterBarLeanMarker` (0F507A) oder ein Idle-Marker „Lean“ an der Mauer, 1× Tisch `FarmTableBench01` (0A4ABB) zum Essen. Ein Lagerfeuer in der Mitte.

Wenn dir ein Vanilla-Objekt nicht gefällt: der Name ist unerheblich, wichtig sind echte Furniture-Refs und Idle-Marker im Radius.

## 5. Testschritte (ohne cqf, ohne Konsole)

Save: vor Stage 10 (Quest Q01 noch nicht gestartet) oder Stage 10 mit Hakan in Morthal. Papyrus-Log mit `set NHV_Cfg_Debug to 1` (Konsole ohne cqf ist ok).
1. **Hakan Tag/Abend/Nacht:** am Steg 06:00–18:00 laufen und Zeit vergehen lassen (Warten-Menü, 1 h Schritte): er wandert im Radius und nutzt Möbel aus N1. 18:00–22:00 um das Bett, nach 22:00 legt er sich ins Bett `00B4C5`. Steht er trotzdem: Log auf „Package“-Zeilen prüfen und mir melden, ob K1 stimmt.
2. **Scavenger Idle:** Spieler Richtung Reedbed laufen, aus der Entfernung beobachten: sie wandern/sitzen, bis sie angesprochen werden.
3. **Gespräch ohne Hello:** Quest Stage 12 (Hakan-Gespräch beendet), Scavenger direkt ansprechen. Erwartet: Hello-Zeile, dann Spielerzeile „Drop the ledger…“, Antwort, „Who hired you?“, Antwort; eine Sekunde später greifen alle drei an. Log: „Reedbed: the scavengers will attack in a moment“, dann „Reedbed: scavengers turn hostile“.
4. **Sack:** vor und während des Kampfes lässt sich der Sack nicht öffnen (keine Reaktion). Nach dem Tod des letzten Scavengers: Log „Reedbed: the sack can be looted now“, Sack öffnet sich, Marker darin. Variante: Spieler flieht aus dem Kampf, nach ca. 2 Minuten ohne Kampf wird freigegeben.
5. **Variante Kampf ohne Gespräch:** Scavenger direkt angreifen und töten: Sack wird freigegeben (nur wenn Ä1 gemacht wurde oder ein Save geladen wurde, siehe offene Fragen).
6. **Hakan stirbt vor dem Briefing (Stage 10):** Hakan töten (Konsole `kill` ist hier ok oder im Spiel). Erwartet binnen 5 s: Log „Hakan died before his talk was over…“, Kartenmarker Farm sichtbar, Stage 20, Notiz „Hakan's Notes“ auf der Leiche.
7. **Hrefna stirbt (Stage 30–55):** Erwartet: Stage 100, Debrief bei Veyra möglich, Notiz „Hrefna's Last Words“ auf der Leiche, Log „Hrefna died before the judgement…“.
8. **Watchpost:** Soldaten und Scout aus der Ferne beobachten (stehen/sitzen/reden/essen, wandern im Radius). Danach den Kampf wie bisher: nach dem Tod der Soldaten spricht der Scout.

## 6. Neue Texte zur Prüfung durch den lore-editor

Alle in `dialogue/Books.csv`, englisch, US-Schreibweise, jeweils Fallback für den NPC-Tod. Quelle sind die Aussagen der verpassten Dialoge; der Text steht auch in den Book-Records.

1. **Hakan's Notes** (9201): „Found Eirik face down in the reeds. Purse still tied, boots dry inside. / The bog did not take him. Someone left him where the water would take the blame. / An Imperial who calls himself a trader asked about the cellar, not the debt. / Men with hooks and empty sacks work the reedbed, and they took my red ferry marker. / Hrefna Stormhollow had reason, means, and mud on her boots. Her farm lies east of the reed road.“
2. **Hrefna's Last Words** (9202): „Six weeks of candles, empty cupboards, and a door that stayed shut. / Eirik took the farm on paper, so I took his breath in the water. / I hid the ritual remains because I could bear an empty answer, but not a town laughing at the question. / The debts broke my husband, and Eirik's hired man broke my daughter. After that, waiting stopped being a virtue.“ (Hinweis: der Suizid der Tochter ist bewusst nur angedeutet; bitte auf Ton und Sensibilität prüfen.)
3. **Scout's Report** (9203): „To the Penitus Oculatus, Hjaalmarch post. / Eirik Ashmark drowned near Morthal, and the cellar of his debtor's farm holds a ritual petition. / The witness, a woman who prayed, was last seen at a camp beyond the drowned shrine. / Four men hold the old watchpost and report to me, not to the garrison. / Find her alive. A dead witness answers nothing.“
4. **Debt Paper** (9204): „Debt of Eirik Ashmark, sold on to the bearer. / A seal on the page, no name beneath it. / Take what the dead man's sacks hold, and the red ferry marker with it. / Hungry men need no other order.“

Die LineIDs der Books.csv-Zeilen tragen den Hinweis „FALLBACK-NOTE (Claude, 03.10.2026)“; Codex darf umschreiben.

## 7. Offene Fragen

1. **Hrefna-Tod → Stage 100:** Ist „Hrefna früh tot = Outcome killed, Debrief ohne Urteil“ konzeptkonform? Alternative: Quest abbrechen/Fail. Quintus bleibt in diesem Fall am Leben und ungelöst.
2. **Hakan-Tod überspringt die Reedbed-Aufgabe** (Marker/Scavenger werden optional). Gewollt?
3. **Hello-Zeile der Scavenger** (2021) bleibt als Einleitung, wenn die Spieler ansprechen; sie ist nicht mehr Voraussetzung. Soll sie ganz entfallen (Umbau in einen reinen Hub)?
4. **Fischen/Netze:** Vanilla hat keine Fisch-Animation. Brauchen wir ein Animations-Mod (harte Abhängigkeit, Regel 5), oder reicht Sitzen/Netze-Gestell?
5. **Scout-Notiz:** der Scout ist ab Stage 25 Essential, die Notiz ist nur ein Backup für Stage 20–24. Behalten oder streichen?
6. **ESP-Sync:** Wurde `AD00/AD01` bereits ins Dev-ESP übernommen? Wenn nicht, erklärt das allein, dass Hakan weiter nur steht.
7. **Sack-Sperre ohne Ä1:** der Sack ist dann bis zum ersten `ReedbedHostile`/Laden unversperrt. Ä1 ist empfohlen.
8. Wenn Hrefna später als Familie stirbt, trägt sie `NHV_Note_Fallback_Hrefna` (Base-Inventar); Text bleibt stimmig, ist aber dann lootbar.

## 8. Nachtrag 03.10.2026: Entscheidungen des Entwicklers

1. **Hrefna darf nicht sterben:** `NHV_Hrefna` (004007) ist jetzt **Essential** (Flag im NPC-Record in `plugin-text`, additiv). Weitere Hrefna-Records oder Templates gibt es nicht (Familien-Slot ist nur ein Alias auf denselben Actor). Befund zu absichtlichen Toden: nur das Urteil „Silence“ (`JudgeSilence()`, Stage 70, Konzept `docs/concept/Q01-Chronologische-Geschichte.md` Abschnitt „Stage 70“: „Bei Freilassung oder ihrem Tod wird der Fall als gescheiterte Ernte abgeschlossen“). Dort setzt das Script jetzt unmittelbar vor `StartCombat` `SetEssential(False)` und `SetProtected(False)`, damit der Kampf sie töten kann. Alle anderen Pfade (Prüfung an Quintus, `Protected` bei `HrefnaKillsQuintus`) bleiben unverändert. Frage an dich: ist „Silence = Hrefna stirbt“ weiter gewollt? Das Konzept sieht es vor, ich habe es nicht verändert.
2. **Hrefna-Todes-Handler** (`HandleHrefnaDeath`, Stage 100) bleibt als reines Sicherheitsnetz im Script (Essential verhindert den Tod vor Stage 70 praktisch, ab Stage 70 ist er abgeschaltet). Notiz `NHV_Note_Fallback_Hrefna` (AD41) bleibt als unbenutzter Record erhalten (Save-Regel 3). Der Abschnitt „Hrefna stirbt“ in Testschritt 7 entfällt; stattdessen testen: Hrefna im Kampf (Stage 50) und im Camp nicht tötbar (Bleedout statt Tod), Urteil „Silence“ tötet sie.
3. **Hakan-Tod überspringt die Reedbed-Aufgabe:** ok (Entscheidung), Farm bleibt über Kartenmarker auffindbar.
4. **Fischen:** Sitzen und Netzgestell reichen, keine Animations-Abhängigkeit.

Prüfung nach dem Nachtrag: `NHV_Q01Script` kompiliert (Pyro direkt), Spriggit `convert-to-plugin` in Temp-ESP ohne Fehler (gelöscht). Geändert: `plugin-text/Npcs/NHV_Hrefna - 004007…`, `NHV_Q01Script.psc` (JudgeSilence).

## 9. Nachtrag: Review-Befunde (papyrus-reviewer), eingearbeitet

1. **`HandleHrefnaDeath`:** wertet nur noch Stage 46–69 und räumt vor `SetStage(100)` auf: `UnlockCutscene`, `ReleaseVeyraFromTrial`, laufende Trial- und Approach-Szene stoppen, `SetQuintusAtFarm(False)`, `bHrefnaWillKill = False`, alle angezeigten Objectives 9001–9019 schließen. Mit Essential-Flag praktisch toter Pfad (Sicherheitsnetz).
2. **Timer:** neue Hilfsfunktion `RequestUpdate(Float)` ersetzt meine `RegisterForSingleUpdate`-Aufrufe (Reedbed, Death-Watch, Kampfstart, Kill-Pending): sie verschiebt nie einen näheren Timer nach hinten. Abweichung vom Vorschlag „genau ein `RearmWatches()` am Ende von `OnUpdate`“: das hätte die vielen frühen `Return`-Zweige und deren eigene Timer umgebaut (Regressionsrisiko für Q01-Stages 20–100); fremde Zweige registrieren weiter selbst, mein Teil läuft bei jedem `OnUpdate` zuerst. Das Reedbed-Timeout misst jetzt Spielzeit (`fReedbedIdleSince`, 0.05 Tage ≈ 1,2 Spielstunden ohne Kampf), nicht mehr Ticks.
3. **`Utility.Wait(1.5)`** in `HrefnaAssassinatesQuintus` ersetzt: Flag `bKillPending` + `RequestUpdate(1.5)`, der Tod folgt in `FinishAssassination()` aus `OnUpdate` (auch in `RearmWatches` nach einem Load).
4. Scavenger-Notiz nur beim ersten Todesfall (`bScavNoteGiven`).
5. Aggression/Confidence der Scavenger werden vor dem Kampf gemerkt und bei `ReleaseReedbedSack()` für Überlebende wiederhergestellt (`RestoreScavengers()`).
6. `NHV_Q01_ReedbedSackScript`: `BlockActivation(True, True)` kompiliert in dieser SKSE/Vanilla-Fassung nicht (1 Parameter); stattdessen `OnActivate` mit `Debug.Notification`. **Neuer Text zur Prüfung (lore-editor):** „The scavengers still guard the sack.“

Alles additiv (neue Variablen/Funktionen, nichts umbenannt oder entfernt). Kompiliert (Pyro direkt, beide Scripts), Spriggit-Probelauf ohne Fehler.
