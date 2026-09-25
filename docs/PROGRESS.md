# Fortschritt – Night's Harvest

Einstiegspunkt für eine **neue Chat-Session ohne Vorgeschichte**. Diese Datei zuerst lesen,
danach nur den `docs/ROADMAP.md`-Eintrag des laufenden Pakets und die dafür nötigen
Konzept-/Doku-Abschnitte – nicht das ganze Repo und nicht den alten Gesprächsverlauf.

## Benutzung

1. Neue Session mit `/work-package <ID>` starten (ID: siehe „Nächster Schritt" unten).
2. Diese Datei + die passende ROADMAP-Zeile lesen. Reicht das nicht, gezielt nachschlagen
   (Grep auf den relevanten Abschnitt, nicht die ganze Datei/das ganze Konzept einlesen).
3. Nach jedem abgeschlossenen Schritt einen kurzen Eintrag unter „Log" anhängen (neuestes
   Datum oben).
4. Vor Session-Ende oder absehbarem Kontext-Limit: „Aktueller Stand" und „Nächster Schritt"
   aktualisieren, dann committen. Siehe auch `CLAUDE.md` Abschnitt „Token sparen".

## Aktueller Stand (Kurzfassung)

**25.09.2026 (spät): Q00 Szene 1 im CK gebaut und übernommen.** `NHV_Scn_Q00_01Standoff` (Phasen 1–4, Aktionen `010_01`, `010_03`–`010_06`; `010_02` ist zweite Response von `010_01`), Phase-4-Bedingung `GetDead` auf Alias Cicero, End-Fragment `RefreezeStandoff()`, `StandoffScene` am `NHV_Sys_Core` gefüllt. Round-Trip Text→ESP funktioniert. Diesmal trat der CK-Save-Schaden **nicht** auf. CK-Compiler: `Cell.psc` (SKSE) nötig, SKSE-`Form.psc` darf **nicht** in `Data\Source\Scripts` liegen (siehe ENVIRONMENT.md). **Nicht getestet:** Ablauf Standoff-Szene ingame (Start bei <800 Units, Reihenfolge, Einfrieren danach). **Offen:** Veyra sitzend (echte Stuhl-Referenz nötig, houseCARL-Abfrage hing), Szenen 2–6, Bücher, Veyra-Rest.


**25.09.2026 (Nacht): Q00 Szene 1 im CK gebaut und repariert übernommen.** `NHV_Scn_Q00_01Standoff`
ist im ESP, `NHV_CoreScript.StandoffScene` zeigt auf die Szene, und die sechs Standoff-Zeilen
liegen als Scene-Topics/INFOs mit Quest-Bindung, Text, ScriptNotes und Response-Emotionen vor.
Beim CK-Save trat der bekannte Schaden wieder auf (alte Q00-Dialogtopics ohne Quest-Feld,
`NewBranch0`, außerdem ein unerwünschter Vanilla-Nazir-Override mit FaceGen); der Textstand
wurde bereinigt und daraus eine reparierte ESP gebaut. **Nicht ingame getestet:** ob die Szene
bei Annäherung unter 800 Units startet, alle Untertitel in Reihenfolge laufen und
`RefreezeStandoff()` am Szenenende greift.

**25.09.2026 (Abend): Rückweg, Q00-Aliase, Start-Logik.** Stage 40 erzeugt die Passage-Tür ingame, der Eintritt setzt Stage 50, die Tür bleibt bestehen, und der Rückweg aus `NHV_DeepSanctuaryCell` in die Dawnstar Sanctuary funktioniert. Mit einem fortgeschrittenen Bruderschafts-Save stehen die Überlebenden sauber in der neuen Dawnstar Sanctuary; das ist der bevorzugte Testeinstieg statt einer reinen `setstage`-Kette. Der MCM-Debugstart startet Q00 und Veyra spawnt, aktuell noch an falscher Position bzw. stehend über dem Stuhl. **Wichtiger Fund:** Bei allen Quests mit Aliasen (Q00, Family, Sanctuary) hatten die Aliase im ESP dieselbe ID 0, weil Spriggit die ID nur schreibt, wenn `ID: n` im YAML steht – jetzt explizit gesetzt und per houseCARL geprüft (wirkt auch auf M1.4/M1.6, dort noch ingame ungetestet). Q00-Aliase: 0 Veyra, 1 Nazir, 2 Babette, 3 Cicero. Start-Logik umgebaut (`NHV_CoreScript` v6): Verzögerung (E14, 2 Tage) zählt ab „Hail Sithis!“-Abschluss; Q00 startet beim Betreten der Dawnstar Sanctuary, Veyra wird per Script am Stuhl erzeugt, Nazir gestellt, Akteure per `EnableAI(False)` bis Szenenstart eingefroren (`ReleaseStandoff()`, Sicherheitsnetz an Stage 15/20). **Offen:** Veyras genaue Position/Sitzen (Package/Möbel im CK), Szenen 1–6 (CK), Familien-/Recruit-Aliase M1.4/M1.6 im späteren Verlauf separat testen.


**25.09.2026 (später): Q00-Stages im CK erledigt und übernommen.** Journal-Texte aller acht Stages und das Stage-40-Fragment (`QF_NHV_Q00_ShadowAtTheDoor_02000815`, ruft `NHV_CoreScript.OpenSealedPassage()`) sind im ESP (per houseCARL-Read bestätigt). CK-Save-Schaden trat wieder auf (26 Dialog-Topics ohne Quest-Feld, Family-Aliase, Geister-Branch `NewBranch0`) und wurde repariert; Ursache weiter ungeklärt. CK-Compiler brauchte `SKSE.psc`/`ModEvent.psc` in `Data\Source\Scripts` (siehe ENVIRONMENT.md). Der damals noch offene Ingame-Ablauf Stage 40 → Tür → Stage 50 ist inzwischen bestätigt, siehe aktuellen Stand oben. **Danach Claude:** Aliase und Szenen 1–6 der Q00.


**25.09.2026: Sealed Passage ingame bestätigt (Geröll erscheint, `coc NHV_DeepSanctuaryCell`
funktioniert), Stage-Kette 40→50 vorbereitet.** Geröll = `NorRubblePile06` mit Scale 0.3
(Platzhalter, später Hebel/Fackel o. ä.), `SetPosition` braucht `Utility.Wait(0.1)` nach
`PlaceAtMe`. Wandposition noch nicht final (aktuell Stuhl-Kollision bei X 2648.75 / Y 4930.81 /
Z 5649.73; Entwickler sucht freie Wandstelle, Vanilla-Möbel bleiben unangetastet).
`NHV_SealedPassageDoorScript` setzt jetzt Q00 Stage 50 beim ersten Betreten (Property `Q00`).
Neue CK-Anleitung `docs/ck/M1.5-Q00-Stages.md` (Journal-Texte + Stage-40-Fragment
`OpenSealedPassage()`). **Nächster Schritt Entwickler:** diese Anleitung abarbeiten, danach
CK speichern → mir Bescheid geben (Diff-Prüfung wegen CK-Save-Bug). **Danach Claude:** Aliase
und Szenen 1–6 der Q00 (eigene Anleitung), Bücher, Veyra-Rest (Klasse/Outfit/Packages).

**23.09.2026: M1.3/M1.5-Vorarbeit – Sealed Passage verkabelt, reproduzierbarer CK-Save-Bug
gefunden.** `NHV_DeepSanctuaryCell` (Duplikat von `MarkarthTreasuryHouse`), `NHV_SealedPassageDoor`
(eigener Tür-Record + `NHV_SealedPassageDoorScript`), `NHV_CoreScript` v3 mit
Geröll/Tür-Spawn-Logik (`SpawnPassageRubble`/`SpawnPassageDoor`/`OpenSealedPassage`) stehen,
alle Properties am `NHV_Sys_Core` gefüllt. **Wichtiger, noch ungeklärter Befund:** Bei jedem
CK-Save dieser Session (dreimal in Folge, auch ohne erkennbare inhaltliche Änderung an den
betroffenen Records) hat das CK das `Quest`-Feld aller 24 Q00-Dialog-Topics geleert, die
Family-Quest-Alias-Bindung dupliziert/falsch geschrieben und einen leeren Geister-DialogBranch
erzeugt – reproduzierbar, nicht nur beim ersten (houseCARL-verursachten) Vorfall. Verdacht:
CK liest diese per Spriggit geschriebenen Felder beim Laden nicht korrekt ein und schreibt bei
jedem Save seine eigene falsche Version zurück. **Noch offen:** Ursache verifizieren (nächster
Test: CK öffnen, sofort ohne Änderung speichern, prüfen ob der Schaden trotzdem auftritt) und
eine dauerhafte Lösung finden (z. B. Family-Alias-Bindung und Dialog-Quest-Feld einmal direkt
im CK statt per Spriggit setzen, damit das CK sie als „eigene" Daten erkennt). Bis dahin: nach
jeder CK-Session `sync_dev.ps1 FromDev` → `plugin_text.ps1 ToText` → `git diff` prüfen, bevor
weitergearbeitet wird.

**23.09.2026: M1.3 gestartet, erster Zwischenfall behoben.** Beim Versuch, `NHV_DeepSanctuaryLocation`
per houseCARL direkt ins ESP zu schreiben, hat der Full-Plugin-Reserialize mehrere bestehende
Records beschädigt (Family-Quest-Aliase dupliziert, Quest-Feld aller Q00-Dialog-Topics
verloren, `Update.esm`-Master weg, Veyras `Voice`-Feld gelöscht). Per Git auf den letzten
sauberen Commit zurückgesetzt und den Location-Record + Veyras CK-Aussehendaten (Class,
Haar, Hautton, Tints, Morphs, FaceGen) sauber über die getestete Spriggit-Pipeline
(`plugin_text.ps1 -Direction ToPlugin`) neu aufgebaut, per houseCARL-Read verifiziert.
**Lehre: houseCARL `in_place`-Writes auf `NightsHarvest.esp` künftig vermeiden, nur noch
über `plugin-text/`-YAML + `plugin_text.ps1` schreiben.** CK-Anleitung `docs/ck/M1.3-Deep-Sanctuary-Stufe1.md`
geschrieben (fünf Q00-Räume: Hall of Whispers, Ledger Room, Shrine of the Void, Memorial
Wall, Training Hall – Initiates' Dormitory bewusst nicht, das ist Finale-Scope laut Konzept).
`ARCHITECTURE.md`-Widerspruch zu E16 korrigiert (Sealed-Passage-Activator/Tür entstehen per
Script/`PlaceAtMe`, nicht CK-Platzierung in der Vanilla-Zelle). Als Nächstes: Entwickler
arbeitet die M1.3-Anleitung ab.

**23.09.2026: M1.2 Veyra-Aussehen ingame bestätigt.** FaceGen-Export erfolgreich (kein
schwarzes Gesicht), `player.placeatme 06000817` zeigt sie korrekt im Spiel. Offen bei M1.2:
Kampfstil/Klasse, Outfit, nachtaktive Alias-Packages, Platzierung im Ledger Room. Als
Nächstes: Klasse für Veyra festlegen (passende Vanilla-Klasse recherchieren, s. u.), dann
Outfit/Packages.

**23.09.2026: Cheydinhal-Frage nachgetragen (fehlte in den 24 zuvor gebauten Q00-Topics),
`NHV_Q00_AskedLeave`-Global angelegt, `GetDeadConditionData`-Schema per Rundlauf bestätigt
(`RunOnType`+`Reference`, nicht `Object`) – siehe Log unten. CK-Anleitung für die sechs
offenen Dialog-Fragmente (Memorial/Gleaner/Standoff) fertig:
`docs/ck/M1.5-Q00-Dialog-Fragmente.md`. Als Nächstes: Scene-Anleitung für Q00 schreiben
(siehe „Nächster Schritt").**

**23.09.2026: M1.1 vollständig und fehlerfrei ingame bestätigt (durch den Entwickler getestet).**
`sqv NHV_Sys_Core` zeigt korrekten Zustand, MCM zeigt „Night's Harvest" mit funktionierenden
Seiten „Status" (Version, Mod-Status, None-sichere Platzhalter für Q00/FamilyManager) und
„General" (alle 5 Optionen mit korrekten Standardwerten, Hilfetexte funktionieren). Voraus
ging ein längerer Debugging-Marathon mit vier echten, gefundenen und behobenen Ursachen für
das MO2-Startproblem (Details: `docs/tests/M0.6.md`, Abschnitt „Auflösung Spielstartproblem"):
1. Fehlende Creation-Club-Master für USSEP (im Dev-Profil deaktiviert).
2. Alte portable MO2-Instanz war fehlerhaft (Ursache nicht weiter untersucht, lohnt sich
   nicht) – neue, funktionierende Instanz `MO2-clean-test`.
3. SKSE-Papyrus-Dateien fast komplett gefehlt (nur `skse.pex` vorhanden, ~60 weitere
   SKSE-erweiterte Kern-Scripts wie `Actor`, `Quest`, `UI`, `Utility` fehlten) – vollständig
   aus dem offiziellen SKSE64-Archiv nachinstalliert.
4. SkyUI registriert neue MCM-Menüs auf ganz frischen Spielständen manchmal erst nach
   Speichern+Neuladen oder Spielneustart (kein Bug, nur Timing).

**Offenes Housekeeping (nicht dringend):** `MO2-clean-test` → `MO2` umbenennen, alte kaputte
Instanz archivieren, sobald Spiel/MO2 geschlossen sind (Prozesse blockieren den Ordner).
`docs/ENVIRONMENT.md` muss danach entsprechend aktualisiert werden.


- Repo, Dev-Umgebung, Tooling (Spriggit, houseCARL, Pyro, portable MO2-Dev-Instanz) stehen
  und funktionieren. Live-Spiel nachweislich unangetastet bis auf zwei harmlose, bereits
  erklärte Nebeneffekte (siehe „Bekannte Umgebungs-Falle" unten).
- E05, E09, E14, E16, E17, E18 entschieden – Details in `docs/DECISIONS.md`.
- M0.6 (Smoke-Test) und M0.7 (Record-Inventar) inhaltlich fertig, Status „Test" – warten auf
  Ingame-Test durch den Entwickler (MO2-Startproblem siehe `docs/tests/M0.6.md`, live-Test
  auf Entwicklerwunsch vertagt).
- **23.09.2026, Dialog-Pause aufgehoben:** Externes Skript für alle Quests/Familie/Banter/
  Black Ledger/Bücher liegt jetzt vor (`dialogue/NightsHarvest-claude-code/dialogue/`,
  Quelle, noch nicht committet – enthält u. a. eine veraltete Vor-E17-CLAUDE.md, deren
  Regeln nicht gelten). Ziel laut Entwickler: Mod mit allen Dialogen/Quests lauffähig,
  **ohne Vertonung**; Anpassungen später, Vertonung erst wenn final. Übertragung ins
  CSV-Master-Format läuft **schrittweise**, quest-für-quest parallel zum jeweiligen
  Arbeitspaket (nicht alles auf einmal). `Q00.csv` + `Journal.csv` (Q00-Teil) sind fertig
  übertragen, gelintet, lore-editor-geprüft. Q01–Q06, Family, Banter, Black Ledger, Bücher
  stehen noch aus – Reihenfolge orientiert sich an der ROADMAP (als Nächstes Q01 bei M1.7).
- M1.1 (Core-System) und M1.6 (Family-Grundgerüst): 6 Scripts stehen, kompilieren sauber
  (6/6 .pex), eine papyrus-reviewer-Runde erledigt und alle Befunde eingearbeitet.
- **ESP enthält jetzt 8 eigene Records** (`Data/NightsHarvest.esp`, 1117 Bytes, per
  `tools/plugin_text.ps1 -Direction ToPlugin` gebacken, zum Dev-Copy synct, Build grün):
  6 Globals (`NHV_Cfg_Debug/Enabled/StartDelay/Notify/Markers/Delivery`), `NHV_FamilyFaction`
  (nach Vorbild `DB10SanctuaryFamilyFaction`), `NHV_Sys_Core` erweitert um Player-Alias
  (ForcedReference auf PlayerRef) und alle neuen Script-Properties inkl. verifizierter
  vanilla-FormIDs für `HailSithisQuest` (DB11, `01EA59:Skyrim.esm`) und `DestroyQuest`
  (DBDestroy, `0934FB:Skyrim.esm`).
- **M1.1 komplett, Status „Test":** `NHV_PlayerAliasScript` hängt am Player-Alias, Property
  `Core` gesetzt und verifiziert. MCM-Grundgerüst gebaut: `NHV_Sys_MCM` (Start Game
  Enabled) mit `NHV_MCMScript` (`SKI_ConfigBase`), Seiten „Status" (read-only: Version,
  aktuelle Quest, Familienstärke – alle None-sicher, zeigen „not available yet" bis M1.5/
  M1.6 existieren) und „General" (5 Optionen, State-API, alle an die bestehenden
  `NHV_Cfg_*`-Globals angebunden). SkyUI-SDK-Quellen (`SKI_ConfigBase.psc`,
  `SKI_QuestBase.psc`) von github.com/schlangster/skyui nach `.tools/skyui-sdk/` geholt,
  `NightsHarvest.ppj` entsprechend erweitert. papyrus-reviewer-Runde erledigt, alle Funde
  eingearbeitet (Pages/`OnVersionUpdate()` für künftige Seiten, `OnOptionHighlight`,
  `OnDefaultST` je Option, CRLF, Core-Referenz für den Versionstext). E19 (MCM-Texte
  vorerst Literal statt Übersetzungsschlüssel) und E06 (SkyUI direkt, war schon im Konzept
  festgelegt) in `docs/DECISIONS.md` nachgetragen.

## Gelöste Schema-Frage: Script an einer Quest-Alias anhängen (YAML)

Aus einem echten CK-Speicherstand gelernt (nicht mehr raten nötig für M1.4/M1.6):

```yaml
VirtualMachineAdapter:
  Scripts: [...]        # Quest-eigene Scripts wie gehabt
  Aliases:
  - Property:
      Name: ''
      Object: <FormKey der Quest selbst>
      Alias: <AliasID, 0-basiert>
    Scripts:
    - Name: <AliasScriptName>
      Properties:        # wie bei Quest-Scripts, MutagenObjectType: ScriptObjectProperty
      - MutagenObjectType: ScriptObjectProperty
        Name: <PropertyName>
        Object: <FormKey>
```
Mein ursprünglicher Versuch (`MutagenObjectType: ScriptObjectProperty` explizit im
`Property`-Block) hat Spriggit still verworfen; ohne dieses Feld (nur `Name`/`Object`/
`Alias`) funktioniert es. Nicht mehr experimentieren, dieses Muster einfach wiederverwenden.

**Ergänzung (23.09., bei M1.6 bestätigt):** Eine normale Script-Property, die statt auf ein
Form auf einen **Alias derselben Quest** zeigen soll (z. B. `NHV_FamilyManagerScript`s
`FollowerSlot1`-Property vom Typ `NHV_FollowerAliasScript`), nutzt exakt dasselbe Muster
innerhalb der ganz normalen `Properties:`-Liste:
```yaml
- MutagenObjectType: ScriptObjectProperty
  Name: <PropertyName>
  Object: <FormKey der eigenen Quest>
  Alias: <AliasID>
```
Per Rundlauf bestätigt (nicht geraten).

## Schema-Notizen DialogTopic/DialogResponses (per Rundlauf bestätigt, 23.09.2026)

Erste komplette Dialog-INFO gebaut und getestet (`NHV_Q00_Veyra_Memorial01`, Memorial-Wall-
Option 1) – Schema jetzt gesichert, nicht mehr raten nötig:

- **Ein `DialogTopic` ist ein ORDNER, keine flache Datei** – anders als alle bisherigen
  Record-Typen. Ordnername: `<EditorID> - <FormID>_NightsHarvest.esp` unter
  `plugin-text/DialogTopics/`. Darin:
  - `RecordData.yaml`: die Topic-Felder selbst (`FormKey`, `EditorID`, `Quest`,
    `Priority`, `SubtypeName: CUST` für eigene Quest-Dialoge – `Category`/`Subtype`
    default auf `Topic`/`Custom`, weglassen). **Kein** `Responses`-Feld hier – die
    Zuordnung läuft rein über den Ordner.
  - `Responses/<EditorID> - <FormID>_NightsHarvest.esp.yaml`: je eine Datei pro INFO
    (`DialogResponses`-Record) in diesem Unterordner.
- **`DialogResponses`** (die INFO): `Prompt` und jedes `Responses[].Text` sind
  **Übersetzungsstrukturen** wie bei Npc-`Name` (`TargetLanguage`/`Values`), kein
  einfacher String. `Flags: {}` explizit mitschreiben (leeres Dict), auch wenn leer –
  beim echten Vanilla-Beispiel stand es auch explizit da. `Conditions` als Liste von
  `ConditionFloat` mit `Data.MutagenObjectType` als Diskriminator (bestätigt:
  `GetStageConditionData` mit `Quest`-Feld, `GetIsIDConditionData` mit `Object`-Feld,
  `GetVMQuestVariableConditionData` mit `Quest`+`VariableName`). `CompareOperator`
  z. B. `GreaterThanOrEqualTo`/`EqualTo`, `ComparisonValue` Standard 0 wenn `EqualTo 1`
  gemeint ist, sonst explizit setzen. `LinkTo` (Liste FormLinks zu Folge-Topics) für
  Verzweigungen – noch nicht getestet.
- **Geklärt:** Q00-Dialoge gehören zu `NHV_Q00_ShadowAtTheDoor` selbst (`Quest`-Feld),
  mit `GetStageConditionData` statt Alias-Bindung – passt zu Veyra (kein Alias) und
  Nazir/Babette/Cicero (über echte FormIDs ansprechbar, keine Alias-Referenz nötig für
  reine Sprecher-Bedingungen).
- **Muster für weitere INFOs:** siehe
  `plugin-text/DialogTopics/NHV_Q00_Veyra_Memorial01 - 000818_NightsHarvest.esp/` als
  fertiges, getestetes Beispiel zum Kopieren.

## Nächster Schritt

**M1.5 (Q00-Questhülle) ist zum Teil erledigt – der Rest braucht CK-Arbeit oder eine
neue Schema-Erkundung. Details siehe Log 23.09. „M1.5 Q00-Questhülle".**

**Für den Entwickler, zwei kurze CK-Schritte:**
1. Fragmente an sechs bestehenden Q00-INFOs ergänzen (Memorial x3, Gleaner02/05,
   Standoff06) – vollständige Anleitung mit Fragment-Code zum Copy-Paste:
   `docs/ck/M1.5-Q00-Dialog-Fragmente.md`.
2. `NHV_Q00_ShadowAtTheDoor` im CK öffnen → Quest Stages-Tab → für jede der 8 Stages
   (10/15/20/30/40/50/60/100) den Journal-Text aus `dialogue/Journal.csv` eintragen
   (Grund: Spriggit-Bug, siehe `docs/ENVIRONMENT.md` „Bekannte Spriggit-Limitation").
3. Nach beiden Schritten einmal `tools/plugin_text.ps1 -Direction ToText`, damit
   `plugin-text/` wieder synchron ist (Ein-Schreiber-Regel, E17).

**Für Claude, als Nächstes:**
1. `ck-guide`-Anleitung für die Scene-Arbeit schreiben: `NHV_Scn_Q00_01Standoff` (Actors,
   Kamera, Nazir-Zwischenrufe/-Verdacht), `NHV_Scn_Q00_02SealedPassage`,
   `NHV_Scn_Q00_03MemorialWall`, plus Force-Greet-Verkabelung für Cicero.
2. M1.2 weiterführen, sobald CK-Zeit da ist: FaceGen, Kampfstil/Klasse, Packages
   (Schlaf/Ledger/Essen/Map-Table/Training laut Konzept Abschnitt 3), platzierte Referenz
   im Ledger Room.
3. Bücher `NHV_Book_BuildersRecord` und `NHV_Book_GleanersLedger` (Text liegt in
   `dialogue/NightsHarvest-claude-code/dialogue/books/` vor, noch nicht übertragen).
4. M2-Story-Rekruten (Sings/Nirelda/Corisande/Kharzog): Reserve-Aliase in `NHV_Sys_Family`
   existieren schon, Scripts/Properties erst anhängen, wenn die jeweilige NPC- und
   Status-Global-Arbeit dran ist (M2.2–M2.5).
5. Nach jedem ESP-Write: `tools/sync_dev.ps1 -Direction ToDev -IncludeEsp`, Build,
   `tools/verify_live_untouched.ps1`.

**Für den Entwickler, sobald Zeit ist:** M1.1, M1.4 und M1.6 sind bereit für einen
Ingame-Test – `sqv NHV_Sys_Sanctuary` bzw. `sqv NHV_Sys_Family` in der Konsole zeigt den
Alias-Zustand. M1.4/M1.6 starten aber erst automatisch, sobald Q00 die jeweilige Stage
erreicht (Q00 selbst startet jetzt korrekt bei Stage 10, aber ohne Dialog-Branches passiert
noch nichts Sichtbares) – bis dahin lassen sie sich nur mit `StartQuest`/`SetStage` von
Hand anstoßen.

## Offene Rückfragen an den Entwickler

- **Night Mother**: exakte platzierte Referenz-FormID muss im CK nachgesehen werden
  (bewusst nicht geraten, siehe `docs/ck/M0.7-Record-Inventar-M1.md` Punkt 6).
- **RecruitDied() vs. OnDeath()**: Überschneidung zwischen Contract-Phase
  (`NHV_ContractBaseScript.RecruitDied()`, kommt in M1.7) und Post-Homecoming-Phase
  (`NHV_RecruitAliasScript.OnDeath()`, M1.6) – Klärung vor M1.7 nötig.

## Log (neueste zuerst)

### 2026-09-23 (Fortsetzung 7, M1.3 gestartet + houseCARL-Zwischenfall)
- Entwickler wollte Q00 initiieren/testen; da M1.3 (Deep Sanctuary) und die Q00-Szenen noch
  fehlen, gemeinsam entschieden: erst M1.3 angehen. E16-Widerspruch in `ARCHITECTURE.md`
  gefunden und mit dem Entwickler geklärt (Sealed-Passage-Activator/Tür per Script statt
  CK-Platzierung, sonst Zell-Kopie entgegen E16) – korrigiert.
- `NHV_DeepSanctuaryLocation` (Parent: `DawnstarSanctuaryLocation`) per houseCARL **direkt
  in-place** ins ESP geschrieben – dabei hat der vom Tool selbst angekündigte
  Full-Plugin-Reserialize mehrere unbeteiligte Records beschädigt: `NHV_Sys_Family` bekam
  6 identische, falsche Alias-Script-Einträge (`NHV_FollowerAliasScript`, Alias 0) statt des
  einen echten (`NHV_RecruitAliasScript`, Alias 2, `StatusGlobal`-Property), alle ~24
  Q00-Dialog-Topics verloren ihr `Quest`-Rückverknüpfungsfeld, der Plugin-Master `Update.esm`
  verschwand aus dem Header, `NHV_Veyra` verlor ihr `Voice`-Feld. Ein zusätzlicher
  Geister-Record (`NHV_Q00_ShadowAtTheDoorNewBranch0`, DialogBranch) tauchte im Text auf.
- **Behoben:** `plugin-text/` und `Data/NightsHarvest.esp` per Git auf den letzten sauberen
  Commit zurückgesetzt (Nutzerbestätigung eingeholt, da destruktive Aktion), Location-Record
  und Veyras echte CK-Aussehendaten (Class `TrainerSneakMaster`, Haar/Haut/Tints/Morphs,
  FaceGen) manuell sauber in die YAML gemerged (inkl. wiederhergestelltem `Voice`-Feld),
  ESP über `plugin_text.ps1 -Direction ToPlugin` (Spriggit, die bisher fehlerfrei genutzte
  Pipeline) neu gebaut. Familie-Quest, alle Dialog-Topics und `Update.esm`-Master wieder
  sauber – per `git diff` (keine Abweichung zu HEAD außer den gewollten Feldern) und
  houseCARL-Read (`Voice`/`Class` korrekt) verifiziert. Repariertes ESP + FaceGen-Assets
  per `sync_dev.ps1 -Direction ToDev -IncludeEsp` in die Dev-Kopie zurückgespielt.
- **Lehre für künftige Sessions:** houseCARL `in_place`-Writes auf `NightsHarvest.esp`
  vermeiden (Tool warnt selbst: „trusts Mutagen for the rest“ bei unbeteiligten Records).
  Neue Text-repräsentierbare Records künftig als YAML unter `plugin-text/` anlegen und über
  `plugin_text.ps1 -Direction ToPlugin` einspielen – das ist die getestete, bisher nie
  fehlerhafte Pipeline für alle ~70 bisherigen Records.
- CK-Anleitung `docs/ck/M1.3-Deep-Sanctuary-Stufe1.md` geschrieben: fünf Q00-Räume (Hall of
  Whispers, Ledger Room, Shrine of the Void, Memorial Wall, Training Hall), Cell/Location/
  Encounter-Zone/Beleuchtung/Room-Bounds/Enable-Parent-System/Navmesh, Standoff-Marker.
  Initiates' Dormitory bewusst ausgeklammert (Finale-Scope laut Konzept Abschnitt 4, nicht
  Q00 – Diskrepanz zur ROADMAP-Zeile M1.3 aufgelöst zugunsten des Konzepts).

### 2026-09-23 (Fortsetzung 6, M1.2 Veyra-Aussehen ingame bestätigt)
- CK-Anleitung `docs/ck/M1.2-Veyra-Aussehen.md` vom Entwickler abgearbeitet: Head Parts
  (Haar, Augen, Narbe-Versuch), Hautton/Tints, Gesichtsmorphs gesetzt, FaceGen exportiert
  (Strg+F4, nach kurzem Zwischenfall – Record im Object Window kurz nicht mehr sichtbar,
  ließ sich durch CK-Neustart ohne Speichern beheben, kein Datenverlust).
- **Ingame bestätigt (Entwickler, Screenshot):** `player.placeatme 06000817` (Laufzeit-
  FormID, `000817` allein reicht der Konsole nicht) zeigt Veyra korrekt – kein schwarzes/
  fehlendes Gesicht, Grundaussehen passt. Dialog-Prompt „Talk – Veyra Othren" erscheint
  (erwartungsgemäß ohne aktive Zeilen, da Q00 auf diesem Testcharakter nicht läuft).
  Kleidung ist noch Standard-Unterwäsche (kein Outfit zugewiesen) – bewusst offen, wird
  später mit Kampfstil/Klasse/Outfit nachgezogen.
- **Offen für M1.2:** Kampfstil/Klasse (Speed-Multiplier-Warnung beim Schließen des
  NPC-Fensters kommt, solange `Class` auf NONE steht – Stats-Tab, nicht Traits-Tab),
  Outfit (Shrouded Robes + Hood), `NHV_VoiceVeyra`-Zuweisung war schon vorher gesetzt,
  nachtaktive Alias-Packages, Platzierung im Ledger Room.

### 2026-09-23 (Fortsetzung 5, Cheydinhal-Frage nachgetragen)
- Beim Sichten der 24 gebauten Topics aufgefallen: die „Why did you leave Cheydinhal?"-
  Frage (NHV_Q00_030_45-48) war in `dialogue/Q00.csv` vorhanden, aber nie als Record
  gebaut worden – und das Global `NHV_Q00_AskedLeave`, auf das eine spätere Bedingung
  verweist, existierte ebenfalls noch nicht. Beides nachgetragen: `NHV_Q00_AskedLeave`
  (000866, GlobalShort), `NHV_Q00_Veyra_Proposal04` (000867/000868, Frage + zwei
  Response-Zeilen), `NHV_Q00_Veyra_Proposal04b` (000869/000870, Folgezeile über
  `PreviousDialog`).
- Eigenen Fehler vor dem Testen abgefangen: erster Versuch nutzte
  `GetVMQuestVariableConditionData` für das AskedLeave-Global – das ist für
  Quest-Script-Papyrus-Variablen (z. B. `::pEmperorTalked_var`), nicht für echte
  Global-Records. Per houseCARL ein echtes `GetGlobalValue`-Beispiel geholt, korrigiert
  auf `GetGlobalValueConditionData{Global: <FormID>}`.
- **Neues, per Rundlauf bestätigtes Schema:** `GetDeadConditionData` (für die
  „Cicero lebt"-Bedingung in Proposal04b) nutzt **nicht** das `Object`-Feld wie
  `GetIsIDConditionData`, sondern `RunOnType: Reference` + `Reference: <FormID>`. Vorab
  per houseCARL verifiziert, nicht geraten; Rundlauf bestätigt exakten Erhalt beider
  Felder. Für künftige Death-Bedingungen einfach dieses Muster wiederverwenden.
- Build, ESP gebaut (14923 Bytes), Sync + Live-Verifikation grün, committet.
- `docs/ck/M1.5-Q00-Dialog-Fragmente.md` geschrieben: Fragment-Code zum Copy-Paste für die
  sechs INFOs, die bisher nur Text ohne Spielwirkung haben (Memorial01/02/03 →
  `NHV_AstridMemorial` 1/2/3, Gleaner02 → `NHV_Q00_AskedLeave` 1, Gleaner05 → Stage 30,
  Standoff06 → Stage 15). Technischer Hintergrund dokumentiert: `TIF_`-Fragmente erben von
  der Quest selbst (kein eigenes Q00-Quest-Script vorhanden), `SetStage()` wirkt darum
  direkt; Globals sind in Papyrus immer per EditorID ansprechbar, keine Property nötig.

### 2026-09-23 (Fortsetzung 4, Q00-Dialog-Branches komplett)
- Alle Player-Choice-Dialoge aus `dialogue/Q00.csv` als echte `DialogTopic`/
  `DialogResponses`-Records gebaut: Memorial (3 Optionen), Night Mother `NM_Gleaner`
  (5 Optionen), Cicero `CIC_Remembers` (3 Optionen), Windpeak Inn (2 Optionen),
  Proposal-Abschluss (3 Optionen), FirstContract-Zusatzfrage (1), Standoff (6
  Hauptoptionen + 1 Folgefrage) – macht **24 Topics / 24 INFOs**, alle einzeln oder in
  kleinen Batches per Rundlauf getestet.
- **Korrektheits-Fund:** Standoff-Option 4 wird von Nazir beantwortet, nicht Veyra –
  explizite `GetIsID`-Sprecherbedingung ergänzt (sonst hätte die Engine die Zeile
  standardmäßig Veyra zugeschrieben). Alle Veyra-Zeilen bekamen zur Sicherheit ebenfalls
  `GetIsID(Veyra)`, obwohl bei Einzelgesprächen mit ihr wahrscheinlich unnötig.
- **Bewusst nicht gebaut** (an CK-Scene-Arbeit übergeben, Text liegt vollständig in
  `dialogue/Q00.csv` bereit): Nazirs Zwischenrufe während Veyras Standoff-Antworten
  (010_22/23) und seine Verdachtszeilen nach den Optionen 1–5 (010_70–72, bräuchten
  ODER-Logik über 5 Vorgänger-Topics). Das ist Mehrsprecher-Choreographie innerhalb
  einer laufenden Szene – dafür ist CKs Scene-Editor da, nicht per YAML zu raten.
- **Noch fehlend, bevor Q00 wirklich durchspielbar ist:** Script-Fragmente an den
  Stage-Übergangs-INFOs (z. B. Standoff-Option 6 → `SetStage(15)`, Proposal → Stage 40,
  Gleaner-Option 5 → Stage 30, Memorial-Optionen → `NHV_AstridMemorial` setzen,
  Gleaner-Option 2 → `NHV_Q00_AskedLeave` setzen). Fragment-Text kann geliefert werden,
  sobald der Entwickler die INFOs einmal im CK geöffnet hat (CK generiert dann die
  TIF_-Fragment-Scripts, in die der Text kommt) – reine Schema-Frage für Fragmente war
  noch nicht Teil dieser Session.
- `PreviousDialog`-Feld (Themen-Verkettung für Folgefragen) erstmals getestet, funktioniert.
- Build, ESP gebaut (13817 Bytes, 39 Records), Sync + Live-Verifikation grün durchgehend.

### 2026-09-23 (Fortsetzung 3, M1.2 Veyra-Grundrecord)
- **Reihenfolge-Fund:** Beim Versuch, Q00s Dialog-Branches (DIAL/INFO-Records) zu bauen,
  festgestellt, dass fast jede Zeile Veyra als Sprecherin hat und ihre FormID für
  Sprecher-Bedingungen (`GetIsID`) braucht – Veyra existierte aber noch nicht (M1.2 offen).
  Mit dem Entwickler geklärt: M1.2 zuerst.
- `NHV_VoiceVeyra` (000816, VoiceType) und `NHV_Veyra` (000817, Npc) angelegt – Basisdaten
  (Name, Rasse Dunmer, `NHV_FamilyFaction`-Mitgliedschaft, Level 1.0/20–60 als
  `PcLevelMult`, Essential+Unique, AIData) nach Vorbild des echten Vanilla-NPCs
  `DrevisNeloren` (Illusions-Lehrer, ebenfalls Dunmer). FaceGen, Kampfstil/Klasse,
  Packages und die platzierte Referenz im Ledger Room bleiben CK-Arbeit (M1.2/M1.3).
- Drei echte Spriggit-Fehler beim Npc-Record gefunden und behoben (alle mit klarer
  Fehlermeldung, kein stilles Verwerfen): `Name` braucht die Übersetzungsstruktur wie bei
  Fraktionen, nicht nur einen String; `Configuration.Level` (PcLevelMult vs. fixe Stufe)
  braucht `MutagenObjectType: PcLevelMult` als Diskriminator; `AIData.Assistance:
  HelpsFriends` ist kein gültiger Enum-Wert (echten Vanilla-Wert `HelpsNobody` verwendet).
- Build, ESP gebaut (3495 Bytes, 20 Records), Sync + Live-Verifikation grün.
- **Noch nicht begonnen:** Dialog-Branches für Q00 (jetzt entsperrt durch Veyras FormID,
  aber eigene, komplexere Schema-Erkundung nötig – DIAL/INFO ist der komplexeste
  Record-Typ überhaupt, siehe Log-Eintrag unten zu den bereits bekannten Feldern).

### 2026-09-23 (Fortsetzung 2, M1.5 Q00-Questhülle + Dialog-Integration)
- **Dialog-Integration Q00:** Externes Skript (`dialogue/NightsHarvest-claude-code/dialogue/script/Q00_A_Shadow_at_the_Door.md`,
  Version 1 vom Entwickler) komplett nach `dialogue/Q00.csv` (141 Zeilen) und
  `dialogue/Journal.csv` (Q00-Teil, 8 Zeilen) übertragen – ersetzt den alten
  Platzhalter-Entwurf. Deutlich reicher: neue Windpeak-Inn-Szene, Cicero-Intercept jetzt
  sauber auf Stage 30 (löst alte Timing-Unklarheit), Nazir-Kommentar zur
  Memorial-Wall-Entscheidung. `tools/dialogue_lint.py` grün, `lore-editor`-Runde
  gemacht: Zeitangabe „Dritte Ära" entfernt (hätte Veyras bewusst ungeklärtes Alter
  verraten – harte Projektregel), zwei Emotion-/Condition-Korrekturen. Nazirs
  „Scimitar" per houseCARL verifiziert (echtes Vanilla-Item), kein Lore-Fehler.
  **Ziel laut Entwickler:** Mod mit allen Dialogen/Quests lauffähig, noch ohne
  Vertonung; Vertonung erst wenn inhaltlich final. Übertragung der restlichen
  Quests/Familie/Banter/Black Ledger/Bücher läuft schrittweise mit den jeweiligen
  Arbeitspaketen, nicht alles auf einmal.
- **M1.5 Q00-Questhülle:** `NHV_Q00_ShadowAtTheDoor` (000815) mit 8 Stages
  (10/15/20/30/40/50/60/100, Stage 100 = `ShutDownStage`) angelegt, `NHV_AstridMemorial`
  (000814, Global) angelegt. `NHV_CoreScript.StartQ00()` ruft jetzt `Q00.SetStage(10)`
  nach `Start()`. `Q00`-Property in `NHV_Sys_Core` und `NHV_Sys_MCM` gefüllt,
  `NHV_FamilyStrength`-Property in `NHV_Sys_MCM` ergänzt (existierte seit M1.6, war
  aber in der MCM-Quest noch nicht verkabelt) – die MCM-Status-Seite zeigt damit bald
  echte Werte statt „not available yet", sobald M1.6/Family tatsächlich läuft.
  papyrus-reviewer-Runde: Timing-Hinweis zu `Start()`/`SetStage()`/`OnInit()` in
  `docs/ARCHITECTURE.md` dokumentiert (künftige CK-Fragmente).
- **Echter Spriggit-Bug gefunden (0.41.0, aktuell):** `QuestLogEntry.Entry` (Journal-Text
  pro Stage) lässt sich nicht per YAML deserialisieren, sobald die Liste einen Eintrag
  hat – harter Absturz, kein stilles Verwerfen wie bei früheren Schema-Lücken. Mit
  `Flags: 0` und `Flags: None` gleichermaßen reproduziert (`ArgumentException: Could
  not convert to QuestLogEntry+Flag`); der Enum hat offenbar keinen benannten Nullwert.
  Kein neueres Spriggit-Release verfügbar. **Workaround:** Stages nur mit `Index`
  (+ Stage-`Flags` wie `ShutDownStage`) anlegen, Journal-Text im CK von Hand eintragen
  (Text liegt fertig in `dialogue/Journal.csv`) – siehe `docs/ENVIRONMENT.md` „Bekannte
  Spriggit-Limitation". Dialog-Branches/INFOs (viel komplexeres Feld) sind davon noch
  nicht getestet betroffen – eigene Schema-Erkundung nötig, bevor Q00 wirklich spielbar ist.
- Build (7/7), ESP gebaut (3174 Bytes, 17 Records), Sync + Live-Verifikation grün.
- ROADMAP-Status M1.5 auf „In Arbeit" (Questhülle steht, Dialog-Branches/Szenen/Bücher
  fehlen noch – das ist der Großteil des Arbeitspakets).

### 2026-09-23 (Fortsetzung, M1.4 + M1.6 ESP-Aufbau)
- Housekeeping erledigt: `MO2-clean-test` → `MO2` umbenannt, alte kaputte Instanz liegt
  jetzt unter `MO2-broken-archive`. `tools/sync_dev.ps1`/`verify_live_untouched.ps1`
  unverändert lauffähig (Pfad ist immer `<DevRoot>\MO2`). `docs/ENVIRONMENT.md` aktualisiert.
- `NHV_Sys_Sanctuary` (000809) angelegt: optionale Aliase Nazir/Babette/Cicero mit
  verifizierten platzierten Referenzen (`NazirRef` 01C3AD, `BabetteRef` 01D4BC, `CiceroRef`
  01E64A, alle `:Skyrim.esm`), `NightMother` bewusst leer (siehe „Offene Rückfragen").
- `NHV_Sys_Family` (000813) angelegt, inkl. **Erweiterung über die M0.7-Tabelle hinaus**:
  `docs/ARCHITECTURE.md` verlangt Reserve-Aliase für Quests, die Save-Kompatibilität ab
  0.1.0 unterliegen ("Aliase in laufenden Quests werden bei Updates nicht neu befüllt").
  Deshalb neben `FollowerSlot1` (Skript `NHV_FollowerAliasScript` angehängt) und
  `HrefnaSlot` (Skript `NHV_RecruitAliasScript` angehängt, `StatusGlobal` →
  `NHV_Status_Hrefna`) auch leere Reserve-Aliase für `FollowerSlot2` (M2.1) und
  `SingsSlot`/`NireldaSlot`/`CorisandeSlot`/`KharzogSlot` (M2.2–M2.5) – noch ohne Skript,
  reservieren nur die Alias-ID. Neue Globals `NHV_FamilyStrength` (000810, Float),
  `NHV_Status_Hrefna` (000811), `NHV_Status_Sings` (000812, laut M0.7-Tabelle "optional
  vorziehen").
- Neues, per Rundlauf bestätigtes Schema: eine Script-Property, die auf einen Alias
  derselben Quest zeigt (nicht auf ein Form), nutzt dasselbe `Object`+`Alias`-Muster wie
  das Alias-Script-Binding – siehe „Gelöste Schema-Frage" oben.
- Build (7/7), ESP gebaut (2880 Bytes, 15 Records), Sync + Live-Verifikation grün.
- ROADMAP-Status M1.4 und M1.6 auf „Test" gesetzt.

### 2026-09-23 (M1.1 ingame bestätigt)
- Entwickler hat über die neue MO2-Instanz `MO2-clean-test` getestet: `completequest DB11`
  + `coc DawnstarSanctuary` (Zelle per houseCARL verifiziert, nicht geraten), `sqv
  NHV_Sys_Core` zeigt korrekten Zustand inkl. korrekter None-Sicherheit (`CanStartQ00()`
  verweigert den Timer-Start, weil `Q00` noch None ist – wie designed, kein Bug).
- MCM zeigte zunächst eine leere Modliste, dann „SkyUI Error Code 7" (SKSE64 scripts
  overwritten/not properly loaded). Ursache: Nur `skse.pex`+`SKSE.psc` waren installiert,
  aber SKSE ersetzt ~60 weitere Kern-Scripts (`Actor`, `Quest`, `ObjectReference`, `UI`,
  `Utility`, `Game` u. a.) durch erweiterte Versionen, gegen die SkyUI kompiliert ist.
  Alle 62 Dateipaare aus dem offiziellen SKSE64-2.2.6-Archiv nachinstalliert (überschreiben
  die Vanilla-Versionen in `Data\Scripts`).
- Nach Spielneustart: MCM zeigt „Night's Harvest" korrekt, beide Seiten (Status/General)
  fehlerfrei mit korrekten Werten. M1.1 damit vollständig ingame bestätigt.
- `docs/tests/M0.6.md` um die komplette Ursachenkette (4 gefundene Probleme) ergänzt.
- Housekeeping offen: MO2-Instanzen umbenennen (`MO2-clean-test` → `MO2`), sobald Spiel/MO2
  geschlossen sind – blockierte den Ordner beim Versuch während der laufenden Session.

### 2026-09-22 (Fortsetzung 4, MCM-Grundgerüst)
- SkyUI-SDK-Quellen (`SKI_ConfigBase.psc`, `SKI_QuestBase.psc`) von GitHub
  (schlangster/skyui) geholt statt Nexus-Download abzuwarten – öffentlich verfügbar,
  keine Kontoanmeldung nötig. Liegen jetzt in `.tools/skyui-sdk/`.
- `NHV_MCMScript.psc` neu: Seiten „Status" (read-only) und „General" (5 Optionen,
  State-API `AddXOptionST`/`OnXST`). `NHV_Sys_MCM` (000808) als neue Start-Game-Enabled-
  Quest mit Player-Alias (`SKI_PlayerLoadGameAlias`, Registrierungsmuster laut SkyUI-MCM-
  Quickstart) und `NHV_MCMScript` angehängt.
- papyrus-reviewer-Runde: Hoch-Befund (Pages-Array wurde bei `OnVersionUpdate()` nicht neu
  aufgebaut, hätte künftige MCM-Seiten in Bestandsspielständen verhindert) sowie mehrere
  Mittel-/Hinweis-Befunde (fehlende Hilfetexte auf der Status-Seite, hartkodierte
  Versionsnummer statt `Core.VERSION_TEXT`, fehlende `OnDefaultST()`, CRLF, Variablen-
  Namenskonvention) – alle eingearbeitet.
- `docs/DECISIONS.md`: E19 (MCM-Texte vorerst Literal-Strings statt `$NHV_*`-Keys, Umstellung
  in M6) neu; E06 (MCM-Technik = SkyUI direkt) von „Offen" auf „Entschieden" nachgetragen,
  war im Konzept bereits festgelegt.
- Build (7/7 .pex), ESP gebaut (1578 Bytes, 9 Records), Sync + Live-Verifikation grün.
- ROADMAP-Status M1.1 auf „Test" gesetzt – Paket ist inhaltlich vollständig.

### 2026-09-22 (Fortsetzung 3, Core-Property geprüft)
- Entwickler hat `Core` am `NHV_PlayerAliasScript` im CK gesetzt und erneut gespeichert.
- Zurückgeholt und in der YAML verifiziert: `Core` zeigt korrekt auf `000801:NightsHarvest.esp`
  (NHV_Sys_Core selbst). Build + Live-Verifikation grün.
- ROADMAP-Status M1.1 bewusst NICHT auf „Test" gesetzt: Der Core-Teil ist fertig, aber die
  MCM-Seiten (Teil des M1.1-Aufgabenpakets) fehlen noch.

### 2026-09-22 (Fortsetzung 2, nach CK-Speichern des Entwicklers)
- Entwickler hat `NHV_PlayerAliasScript` im CK an den Player-Alias gehängt und gespeichert.
- `tools/sync_dev.ps1 -Direction FromDev` + `tools/plugin_text.ps1 -Direction ToText`
  geholt: Schema für Alias-Scripts jetzt aus echtem CK-Speicherstand bekannt (siehe
  „Gelöste Schema-Frage" oben) – meine zwei YAML-Rateversuche waren nah dran, aber falsch
  (`MutagenObjectType` im `Property`-Block war das Problem).
  Gebraucht wird das für M1.4/M1.6 nicht mehr geraten werden.
- Fund: Property `Core` am Alias-Script ist noch leer (Entwickler hat nur das Script
  hinzugefügt, nicht die Property gesetzt) – neuer Schritt A in „Nächster Schritt".
- Build + Live-Verifikation weiterhin grün.

### 2026-09-22 (Fortsetzung)
- Hintergrund-Export von `Skyrim.esm` ausgewertet: `DB10SanctuaryFamilyFaction` als
  Vorbild für `plugin-text/Factions/NHV_FamilyFaction.yaml` (000807) genutzt.
- Vanilla-FormIDs verifiziert (im serialisierten `Skyrim.esm`, nicht geraten): DB11 „Hail
  Sithis!" = `01EA59:Skyrim.esm`, DBDestroy „Destroy the Dark Brotherhood!" = `0934FB:Skyrim.esm`,
  DawnstarSanctuaryLocation = `019429:Skyrim.esm`.
- `NHV_Sys_Core` erweitert: Player-Alias (ForcedReference), alle Script-Properties gefüllt.
- Zwei Versuche, `NHV_PlayerAliasScript` per YAML an den Player-Alias zu hängen, sind beim
  Spriggit-Rundlauf stillschweigend verworfen worden (kein Fehler, Feld einfach weg) –
  nicht weiter geraten, CK-Nacharbeit dokumentiert (siehe „Nächster Schritt" A).
- ESP gebaut (1117 Bytes, 8 Records), zum Dev-Copy synct, Build weiterhin grün,
  `verify_live_untouched.ps1` grün (zwei bereits erklärte Nebeneffekte, keine echten
  Änderungen an Live-Spieldaten).
- `docs/ck/M0.7-Record-Inventar-M1.md`: „vermutlich DB11" durch verifizierte FormIDs ersetzt.

### 2026-09-22
- papyrus-reviewer-Befunde aus der M1.6-Review eingearbeitet:
  - `NHV_FollowerAliasScript.psc`: Hoch – State-Guard vor `RegisterForSingleUpdate` in
    `StartFollowing()`, sonst stapeln sich Timer bei Mehrfachaufruf.
  - `NHV_PlayerAliasScript.psc`: None-Checks auf `Core` in beiden Events.
  - `NHV_FamilyManagerScript.psc`: None-Checks auf `FollowerSlot1`; Property jetzt als
    `NHV_FollowerAliasScript` typisiert statt generisch `ReferenceAlias`; `AssignFollower()`
    ruft jetzt `StartFollowing()`; Kommentar zum vorerst ungenutzten `NHV_FamilyFaction`
    ergänzt (reserviert für M1.7).
  - `NHV_RecruitAliasScript.psc`: Schutz gegen doppeltes `OnDeath()` (z. B. Killmove +
    Damage-Event).
  - Neu kompiliert: 6/6 .pex, keine Fehler.
- Token-Sparstrategie eingerichtet: diese Datei (`docs/PROGRESS.md`) sowie Abschnitt
  „Token sparen" in `CLAUDE.md`.

### 2026-09-21 (vor Kontext-Kompaktierung, aus Zusammenfassung rekonstruiert)
- Repo-Bootstrap, Doppel-Dateien entfernt (`Claude2.md`, leerer `NightsHarvest-claude-code/`-Ordner).
- Tool-Links recherchiert und geliefert (CKPE, Pyro, Spriggit, SSEEdit, LOOT, gh, SkyUI SDK).
- Tools entpackt/installiert, Dev-Umgebung angelegt (`C:\Dev\brotherhood-devenv`): Kopie des
  Spiels, portable MO2-Instanz, Backups (Vortex-Export, INIs, Saves) mit SHA-256-Verifikation.
- MCP-Server-Vergleich, houseCARL installiert und konfiguriert (Vorstufe zu E17).
- **E17** entschieden: Claude bearbeitet die ESP selbst (Spriggit primär, houseCARL für
  Lookups), Ein-Schreiber-Regel mit dem CK (`tools/plugin_text.ps1` erzwingt sie technisch).
- CK-Rundlauf getestet (inkl. „test.esp"-Fehlgriff durch fehlendes „active file"-Flag,
  korrigiert, kein Datenverlust, echte ESP unverändert).
- Reale Vanilla-FormIDs via houseCARL verifiziert (Nazir, Babette, Cicero, DB11-Quest,
  Dawnstar-Sanctuary-Location); Night Mother-Referenz bewusst offen gelassen statt geraten.
- **E18** (Status 2 für Tod), **E16** (Deep Sanctuary Zugang = Script-Tür statt Zell-Kopie),
  **E09** (Pathing = MoveTo, kein Navmesh-Edit), **E14** (Startverzögerung = 2 Tage) entschieden.
- `dialogue/Q00.csv` (~86 Zeilen) und `Q01.csv` (10 Zeilen) + `Journal.csv` geschrieben,
  lore-editor-geprüft, `tools/dialogue_lint.py` gebaut und grün (0 Fehler, 112 LineIDs).
- MO2-Startproblem (schwarzes Fenster, bricht nach ~1s ab) diagnostiziert, Ursache nicht
  gefunden – live-Test auf Entwicklerwunsch vertagt; direkter Doppelklick auf `SkyrimSE.exe`
  ohne MO2 funktioniert (grenzt das Problem auf MO2/usvfs ein).
- M1.1/M1.6-Scriptgerüst geschrieben: `NHV_CoreScript` (V2, Startbedingung mit Verzögerung),
  `NHV_PlayerAliasScript`, `NHV_FamilyManagerScript`, `NHV_RecruitAliasScript`,
  `NHV_FollowerAliasScript`, Ergänzung `SendRecruitEvent()` in `NHV_Util.psc`. Kompiliert.
- 5 neue Globals als `plugin-text/`-YAML angelegt (`NHV_Cfg_Enabled`, `NHV_Cfg_StartDelay`,
  `NHV_Cfg_Notify`, `NHV_Cfg_Markers`, `NHV_Cfg_Delivery`) – noch nicht in die ESP gebacken.

## Bekannte Umgebungs-Falle (nicht in ENVIRONMENT.md, hier vermerkt)

CK-Sessions über MO2 können den Schreibvorgang „Vanilla-Skripte neu entpacken" per usvfs
nach `MO2\overwrite\Source\Scripts` statt in den echten `Data\Source\Scripts`-Ordner der
Dev-Kopie umleiten. Symptom: `tools/build.ps1` bricht ab, weil `TESV_Papyrus_Flags.flg`
fehlt. Fix: `robocopy <MO2>\overwrite\Source\Scripts <DevKopie>\Data\Source\Scripts /E`.
Nach jeder CK-Session, die „Scripts.zip entpacken?" bestätigt hat, prüfen.

## Meilenstein-/Paket-Kurzstatus (Details und Ist-Stunden: `docs/ROADMAP.md`)

- M0.1–M0.5, M0.8: siehe ROADMAP, größtenteils „Offen"/Entwickler-Aufgaben.
- M0.6 Smoke-Test: **Test** (wartet auf Ingame-Prüfung).
- M0.7 Record-Inventar: **Test**.
- M1.1 Core-System: **Test, ingame bestätigt** – Scripts + ESP-Records + MCM (Status/General)
  fertig, reviewed, Build/Live-Check grün, vom Entwickler erfolgreich getestet (23.09.).
  „Fertig" setzt der Entwickler, sobald er möchte.
- M1.2 Veyra: **In Arbeit** – Grunddaten (Npc-Record, Rasse, Fraktion, Level, VoiceType)
  gebaut. Fehlt: FaceGen, Kampfstil/Klasse, Packages, Platzierung (alles CK).
- M1.3 Deep Sanctuary Stufe 1: Offen, nicht begonnen.
- M1.4 Sanctuary-Aliase: **Test** – Nazir/Babette/Cicero fertig, Night Mother offen (CK).
- M1.5 Q00 im CK: **In Arbeit** – Dialog-CSV fertig (141 Zeilen, gelintet, lore-editor-
  geprüft), Quest+8 Stages als Records gebaut, alle 24 Player-Choice-Dialog-Topics
  gebaut. Fehlt: Journal-Text im CK nachtragen (Spriggit-Bug), Script-Fragmente an den
  INFOs (Stage-Übergänge/Variablen), Szenen (CK), 2 Bücher.
- M1.6 Family-Grundgerüst: **Test** – FollowerSlot1+HrefnaSlot fertig, Reserve-Aliase für
  M2-Rekruten schon angelegt (leer).
