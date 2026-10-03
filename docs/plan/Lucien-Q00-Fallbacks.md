# Lucien ab Q00-Stage 12/15 ansprechbar, Q00-Todes-Fallbacks (03.10.2026)

Nichts davon ist ingame getestet. `Data/NightsHarvest.esp` wurde nicht geschrieben, kein Sync, kein Commit.

## Auftrag A: Lucien

### Ablauf bisher (Stage 12 bis 50)

- Stage 12: `SummonLucienAtStandoff()` setzt `NHV_Q00_LucienSummoned` = 1, stellt Lucien per `MoveTo` ca. 220 Units vor Veyra (Vanilla Dawnstar Sanctuary), Ritual, `AppearLucien()`. Danach Ankunftsszene `NHV_Scn_Sys_LucienArrival` (458A).
- Stage 15: Veyra geht zum Windpeak Inn.
- Stage 30 (Fragment_4 im QF): `kCore.DismissLucien()` machte Lucien per `Disable(True)` unsichtbar. Zurück kam er erst bei Stage 50 (`OnEnterDeepSceneEnd` -> `RestoreLucienHome`).
- Lucien-NPC (004400) hatte nur ein Package: `NHV_Pkg_Sys_LucienStand` (004404), Sandbox, Radius 1500 um `NHV_Mk_Sys_LucienSpot` (004402) in der **Deep Sanctuary**, ohne Bedingung und ohne Stage-Grenze.

### Ursachen (Analyse, nicht ingame bestätigt)

1. **Package zieht ihn weg (Hauptverdacht).** Das unbedingte Package 004404 gilt auch in Stage 12 bis 49. Es zeigt in eine andere Zelle (Deep Sanctuary, Zugang erst ab Stage 50). Sobald keine Szene ihn mehr hält, versucht er dorthin zu laufen und ist für den Spieler nicht mehr in der Halle zu finden bzw. steht blockiert.
2. **Disable in Stage 30 bis 49.** `DismissLucien()` schaltete ihn ab. Das ist der einzige Grund, warum er in diesem Fenster sicher nicht ansprechbar war.
3. Szenen: Die Ankunftsszene wird vom Watchdog (`NHV_SanctuaryScript`) und `NHV_Sys_LucienAliasScript.ReleaseArrivalScene()` bereits abgefangen. Kein neuer Befund.

### Dialog-Conditions (kein Eingriff nötig)

Alle Lucien-Topics (`NHV_Sys_Lucien_*`, Quest `NHV_Sys_Sanctuary`) prüfen:
`GetGlobalValue NHV_Q00_LucienSummoned == 1` UND (`GetIsAliasRef 4` ODER `GetIsID NHV_LucienSpirit`).
**Keine GetStage-Bedingung.** Die Global wird in Stage 12 gesetzt. Die Conditions blockieren ihn in Stage 15 also nicht. `dialogue/Lucien.csv` und die INFO-Conditions bleiben unverändert (nur CSV-Spalte `Conditions`, dort bereits identisch zum Plugin außer dem ODER-Zweig, wie vorher).

### Änderungen

- **Neues Package** `NHV_Pkg_Sys_LucienSanctuaryIdle` (00AC00): Sandbox (Template 01C254, gleiche Flags wie 004404), Zeitplan ganztägig (ScheduleHour -1, Tag und Nacht, ein Geist schläft nicht), Ort `NHV_Mk_Q00_StandoffVeyra` (004343, Marker in der Vanilla-Sanctuary-Halle bei der Standoff-Gruppe), Radius 600. Bedingungen: `GetStage NHV_Q00_ShadowAtTheDoor >= 12` UND `< 50`.
- **NPC 004400:** Package-Liste jetzt `00AC00`, dann `004404`. Lückenlos: Stage < 12 nichts (Lucien ist deaktiviert), 12 bis 49 Halle, ab 50 wie bisher Deep Sanctuary.
- **`NHV_CoreScript.psc`** (additiv, keine Property/Variable umbenannt):
  - `DismissLucien()` bleibt als Name (QF-Fragment und Saves), deaktiviert Lucien aber nicht mehr (ruft `KeepLucienInSanctuary()`).
  - Neu `KeepLucienInSanctuary()`: Stage 12 bis 49, gerufen, Ritual nicht aktiv: ist er deaktiviert (alte Dev-Saves nach Stage 30), wird er neben 004343 gestellt und aktiviert; steht er in einer anderen Zelle und ist nicht geladen, wird er in die Halle versetzt.
  - `EnsureLucienState()` (Maintenance) ruft das auf und setzt ihn ab Stage 50 still (nur wenn nicht geladen) an `NHV_Mk_Sys_LucienSpot`, falls er noch in der Halle steht.
  - Kommentare zu Stage 12/30/50 angepasst.
- Kein SetGhost (Lehre 5), kein Timer neu (Lehre 9), keine Vanilla-Records verändert.

### Verträglichkeit mit E41/E35

Ab Stage 50 unverändert: `OnEnterDeepSceneEnd` -> `RestoreLucienHome()` (MoveTo 004402), Package wechselt per Stage-Bedingung auf 004404, Dauergespräche in der Deep Sanctuary. **Abweichung von E41** („Lucien verschwindet"): Er bleibt Stage 15 bis 49 in der Halle sichtbar. Bitte E41 in `docs/DECISIONS.md` entsprechend ergänzen (Entscheidung Entwickler 03.10.2026; vom Entwickler bestätigen lassen).

### Geänderte Dateien

- `plugin-text/Packages/NHV_Pkg_Sys_LucienSanctuaryIdle - 00AC00_NightsHarvest.esp.yaml` (neu)
- `plugin-text/Npcs/NHV_LucienSpirit - 004400_NightsHarvest.esp.yaml`
- `Data/Source/Scripts/NHV_CoreScript.psc`
- Probelauf: Spriggit `convert-to-plugin` plugin-text -> Temp-ESP (645 533 Bytes) fehlerfrei, Package im Ergebnis vorhanden. FormIDs 00AC00 frei (keine Kollision).

### Build

`powershell -File tools\build.ps1` startet hier nicht (Execution Policy deaktiviert). Policy nicht umgangen, **nicht kompiliert**. Für den Entwickler:
`powershell -ExecutionPolicy Bypass -File tools\build.ps1` (oder in einer PowerShell mit erlaubter Policy), danach `NHV_CoreScript.pex` in die Dev-Kopie syncen. `papyrus-reviewer` nicht gelaufen (Subagent nicht verfügbar), bitte nachholen.

### CK-Aufgaben

- **KONTROLLIEREN (nach ToPlugin/ESP-Sync, CK einmal öffnen und speichern):** Package `NHV_Pkg_Sys_LucienSanctuaryIdle` (00AC00): Conditions (Q00 Stage >= 12 und < 50), Location 004343 / Radius 600, Template Sandbox. NPC `NHV_LucienSpirit`: Package-Reihenfolge 00AC00 oben, 004404 darunter.
- **KONTROLLIEREN:** Marker 004343 liegt auf Navmesh und frei in der Halle; Lucien-MoveTo (+150 X) steht nicht in einem Möbel.
- **ÄNDERN:** nichts zwingend. Optional Sandbox-Flags im Package (kein Sitzen/Schlafen) nachsehen.
- **NEU ERSTELLEN:** nichts.

### Testschritte (ohne cqf)

1. Neuer Save kurz vor dem Ende des Standoffs (Stage 10), `set NHV_Cfg_Debug to 1`. Standoff abschließen, Ritual/Vouch abwarten.
2. Stage 15 (Veyra geht): Lucien steht sichtbar in der Halle (Gruppenbereich), nach 2 bis 3 Spielminuten noch dort. Aktivieren: Themenmenü erscheint. Log: `Lucien activated: ...`.
3. Zum Windpeak Inn gehen, Night Mother befragen (Stage 30), zurück: Lucien noch sichtbar und ansprechbar (Log `Lucien stays in the Sanctuary hall`, kein `dismissed`).
4. Speichern, laden, Tag/Nacht wechseln (Warten): Lucien bleibt in der Halle.
5. Alter Dev-Save mit Stage 30 bis 49 und deaktiviertem Lucien: laden, Log `Lucien re-enabled in the Sanctuary hall`.
6. Stage 50 (Tür aufdecken): Lucien steht danach in der Deep Sanctuary am Marker, Themen funktionieren, Log `Lucien back at his place`.

Wenn er trotzdem nicht ansprechbar ist: Papyrus-Log ins Repo kopieren (Zeilen `Lucien activated: summoned=... scene=... ai=...`).

## Auftrag B: Todes-Fallbacks Q00

Befund (Records, houseCARL und plugin-text):

| NPC | Base | Flags | Folge |
|---|---|---|---|
| Veyra | `NHV_Veyra` 000817 | Essential, Invulnerable | kein Fallback nötig |
| Lucien | `NHV_LucienSpirit` 004400 | Protected, Invulnerable | kein Fallback nötig |
| Nazir | Vanilla `Nazir` 01C3AB (Ref 01C3AD) | Essential | kein Fallback nötig |
| Babette | Vanilla `Babette` 01D4B7 (Ref 01D4BC) | Essential | kein Fallback nötig |
| Cicero | Vanilla `CiceroDawnstar` 09BCAF (Ref 09BCB0) | Essential | kein Fallback nötig; Q00 prüft ihn ohnehin per `GetDead` (Standoff-Szene, optionaler Alias) |
| Hrefna | nicht Q00 (Q01) | – | außerhalb des Auftrags |

Vanilla-Records dürfen nicht verändert werden, und alle fünf Q00-Figuren sind Essential bzw. Protected. Daher **keine** Fallback-Items, keine `Books.csv`-Einträge, kein Todes-Handler (Regel „nur wo wirklich nötig"). Es wurde nichts angelegt, also nichts für den `lore-editor`.

Restrisiken (dokumentiert, nicht gebaut):
- Skripte anderer Mods oder Vanilla-DB-Quests, die `SetEssential(False)` setzen, oder Konsolen-Kill (`kill`) können die Figuren töten. Nur Cicero ist dafür bereits abgesichert.
- Falls der Entwickler einen Schutz gegen Vanilla-Quest-Eingriffe will: periodische Prüfung `IsDead()` für Veyra/Nazir/Babette im bestehenden `OnUpdate`-Dispatcher mit Journal-Hinweis. Bitte entscheiden, ob gewünscht.

## Offene Fragen

1. E41 anpassen (Lucien sichtbar in der Halle Stage 12 bis 49)? Vom Entwickler bestätigen.
2. Gefällt der Aufenthaltsort (Radius 600 um den Standoff-Marker von Veyra)? Sonst anderen Marker im CK nennen.
3. Soll ein Todes-Schutz gegen Fremd-Mods für Veyra/Nazir/Babette gebaut werden?
