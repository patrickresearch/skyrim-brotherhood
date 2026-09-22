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
- Dialog Q00/Q01 + Journal.csv geschrieben, `tools/dialogue_lint.py` grün, lore-editor
  geprüft – dann **pausiert**: Dialoge/Bücher/Briefe werden aktuell extern geschrieben,
  nicht anfassen bis der Entwickler das wieder freigibt.
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

## Nächster Schritt

**M1.4 und M1.6 sind ESP-seitig fertig (Status „Test"), Housekeeping erledigt.**
1. `NHV_Q00_ShadowAtTheDoor`-Quest-Shell (8 Stages, ohne Dialogtext, der kommt später aus
   `dialogue/Q00.csv`) – nächstes großes Stück, M1.5.
2. Sobald Q00/FamilyManager existieren: `Q00`- und `NHV_FamilyStrength`-Properties in
   `NHV_MCMScript` (Status-Seite) im CK nachtragen, damit die Platzhalter „not available
   yet" verschwinden.
3. M2-Story-Rekruten (Sings/Nirelda/Corisande/Kharzog): Reserve-Aliase in `NHV_Sys_Family`
   existieren schon (siehe Log 23.09.), Scripts/Properties erst anhängen, wenn die
   jeweilige NPC- und Status-Global-Arbeit dran ist (M2.2–M2.5).
4. Nach jedem ESP-Write: `tools/sync_dev.ps1 -Direction ToDev -IncludeEsp`, Build,
   `tools/verify_live_untouched.ps1`.

**Für den Entwickler, sobald Zeit ist:** M1.4 (Sanctuary-Aliase) und M1.6 (Family-
Grundgerüst) sind bereit für einen Ingame-Test analog zu M1.1 – `sqv NHV_Sys_Sanctuary`
bzw. `sqv NHV_Sys_Family` in der Konsole zeigt den Alias-Zustand. Beide Quests starten
aber erst automatisch, sobald Q00 existiert (M1.5) und die jeweilige Stage erreicht;
bis dahin lassen sie sich nur mit `StartQuest`/`SetStage` von Hand anstoßen.

## Offene Rückfragen an den Entwickler

- **Night Mother**: exakte platzierte Referenz-FormID muss im CK nachgesehen werden
  (bewusst nicht geraten, siehe `docs/ck/M0.7-Record-Inventar-M1.md` Punkt 6).
- **RecruitDied() vs. OnDeath()**: Überschneidung zwischen Contract-Phase
  (`NHV_ContractBaseScript.RecruitDied()`, kommt in M1.7) und Post-Homecoming-Phase
  (`NHV_RecruitAliasScript.OnDeath()`, M1.6) – Klärung vor M1.7 nötig.

## Log (neueste zuerst)

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
- M1.2 Veyra: Offen, nicht begonnen.
- M1.3 Deep Sanctuary Stufe 1: Offen, nicht begonnen.
- M1.4 Sanctuary-Aliase: **Test** – Nazir/Babette/Cicero fertig, Night Mother offen (CK).
- M1.5 Q00 im CK: Offen – Dialog-CSV steht, Stages/Szenen noch nicht als Records gebaut.
- M1.6 Family-Grundgerüst: **Test** – FollowerSlot1+HrefnaSlot fertig, Reserve-Aliase für
  M2-Rekruten schon angelegt (leer).
