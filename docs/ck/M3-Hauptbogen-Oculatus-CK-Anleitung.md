# CK-Anleitung M3: Hauptbogen Oculatus (E28–E31)

**Ziel:** `NHV_Sys_Oculatus` als neue System-Quest anlegen, ihr die vier bereits geschriebenen und
kompilierten Scripts (`NHV_OculatusScript`, `NHV_OculatusPlayerAliasScript`, `NHV_IL01Script`,
`NHV_IL02Script`, `NHV_InformantAliasScript`) verdrahten, zwei Interlude-Quests und den Spitzel-NPC
anlegen. Alle Scripts liegen bereits kompiliert unter `Data/Scripts/*.pex`
(`Data/Source/Scripts/*.psc` für den Quelltext) – hier geht es nur noch um CK-Records und
Verdrahtung, kein Script-Code mehr nötig.

**FormID-Bereich:** `0x004200`–`0x0042FF` (Vorschlag, siehe `docs/plan/Hauptbogen-Technik.md`
Abschnitt 6). Vor dem Anlegen die aktuell höchste vergebene NHV-FormID im Plugin prüfen
(Kollisionsvermeidung, dieser Bereich ist nicht garantiert frei, nur eine Empfehlung).

**Nicht Teil dieses Arbeitspakets:** Der Patch-Vorschlag an `NHV_ContractBaseScript` (neue Property
`OculatusSys`, siehe Technik-Dokument Abschnitt 2) – erst nach Freigabe und außerhalb der aktuellen
Q01-ESP-Session eines anderen Agenten. Die Interludes und der Spitzel funktionieren bereits ohne diese
Anbindung (sie befüllen den Heat-Zähler eigenständig).

## Record-Inventar (Vorschlag)

| FormID (Vorschlag) | EditorID | Record-Typ | Zweck |
|---|---|---|---|
| 0x004200 | `NHV_Sys_Oculatus` | Quest | System-Quest, Start Game Enabled, Script `NHV_OculatusScript` |
| 0x004201 | `NHV_Status_OculatusHeat` | Global (Short) | Spiegel von `iHeat`, 0–5, nur MCM-Debug-Seite + CK-Conditions |
| 0x004210 | PlayerRef-Alias auf `NHV_Sys_Oculatus` | ReferenceAlias | `ForcedRef` auf `PlayerRef` (wie `NHV_PlayerAliasScript`), Script `NHV_OculatusPlayerAliasScript` |
| 0x004211 | Spitzel-Alias auf `NHV_Sys_Oculatus` | ReferenceAlias | Optional, Script `NHV_InformantAliasScript` |
| 0x004220 | `NHV_IL01_FirstBlood` | Quest | Interlude-Quest, Script `NHV_IL01Script` |
| 0x004221 | `NHV_IL02_KnockAtDawnstar` | Quest | Interlude-Quest, Script `NHV_IL02Script` |
| 0x004230 | `NHV_Informant` | NPC_ | Spitzel-NPC, Basis (Name: siehe `docs/codex/2026-09-28-Spitzel-Dawnstar.md`) |
| 0x004231 | `NHV_InformantRef` | REFR (Actor) | Platzierte, persistente Referenz am Dawnstar-Hafen |
| 0x004232 | `NHV_VoiceInformant` | VoiceType | Eigener VoiceType |
| 0x004240 | `NHV_FormList_OculatusMercs` | FormList (LVLN oder einfache Liste) | 2–3 Söldner-Templates für „First Blood“ |
| 0x004241 | `NHV_FormList_OculatusAgents` | FormList | 3–4 Agenten-Templates für „Knock at Dawnstar“ |
| 0x004250 | `NHV_Mk_IL01_AmbushSpot` | REFR (XMarkerHeading) | Encounter-Punkt First Blood (Wildnis, Straße) |
| 0x004251 | `NHV_Mk_IL02_ScoutCamp` | REFR (XMarkerHeading) | Encounter-Punkt Knock at Dawnstar (Wildnis-Zelle bei Dawnstar, **nicht** `DawnstarSanctuary`) |
| 0x004252 | `NHV_Pkg_Informant_Harbor` | Package | Tagsüber, Hafenarbeit/Fischer |
| 0x004253 | `NHV_Pkg_Informant_WatchNight` | Package | Nachts, Sandbox-Radius in Sichtweite des Sanctuary-Zugangs |
| 0x004260 | `NHV_Item_OculatusLetter` | MISC (Flavour) | Brief bei einem First-Blood-Söldner |
| 0x004270–0x004276 | Dialog-Branches | TOPC | Verhör (Knock at Dawnstar), Spitzel-Konfrontation/Ausgänge, siehe unten |

**Nicht neu anzulegen:** `NHV_Cfg_Debug` (bereits vorhanden, wiederverwenden).

## Schritt für Schritt

1. **Quest `NHV_Sys_Oculatus` anlegen.** Start Game Enabled, kein Quest-Alias außer den zwei unten
   genannten. Script `NHV_OculatusScript` anhängen, Properties setzen: `NHV_Cfg_Debug` (bestehender
   Global), `NHV_Status_OculatusHeat` (neu anlegen, Kurzzahl, Startwert 0).
2. **PlayerRef-Alias anlegen** (ForcedRef auf den Spieler, wie bei `NHV_Sys_Core`), Script
   `NHV_OculatusPlayerAliasScript` anhängen, Property `OculatusSys` auf `NHV_Sys_Oculatus` setzen.
3. **Spitzel-Alias anlegen** (Optional, Referenztyp Actor), Script `NHV_InformantAliasScript`
   anhängen, Property `OculatusSys` setzen. Referenz wird in Schritt 6 mit `NHV_InformantRef`
   verknüpft (`ForceRefTo` im Dialog-/Erkennungsfragment oder direkt als `ForcedRef`, falls die
   Referenz von Anfang an existiert).
4. **`NHV_Status_OculatusHeat` in die MCM-Debug-Seite einhängen** (nur dort, nie auf einer normalen
   Seite, E28). `NHV_MCMScript` selbst bleibt unverändert – die Debug-Seite liest den Global direkt
   per `GetValueInt()`, kein neuer Code nötig.
5. **Interlude-Quests anlegen.** Beide Quests **müssen „Run Once“ gesetzt bekommen** (Pflicht, nicht
   optional) – das ist die CK-seitige Hälfte der Doppelsicherung gegen doppelte Heat-Buchung; die
   zweite, script-seitige Hälfte ist `NHV_OculatusScript.TryClaimInterlude()`, das unabhängig vom
   Quest-Zustand selbst Buch führt (`bIL01Done`/`bIL02Done`), falls „Run Once“ trotzdem umgangen wird
   (z. B. durch `resetquest` in einem Dev-Save).
   - `NHV_IL01_FirstBlood`: Start-Bedingung über Story-Manager-Quest-Event (Zufallsbegegnung
     entlang der Straßen), Condition `GetValue NHV_Status_OculatusHeat >= 2` (roher Heat-Wert). Script
     `NHV_IL01Script`, Property `OculatusSys` setzen. Ein Stage-Fragment am Questende ruft
     `Conclude(abLetterFound)` auf (True, wenn der Spieler `NHV_Item_OculatusLetter` genommen hat).
   - `NHV_IL02_KnockAtDawnstar`: Start-Bedingung Story-Manager, Condition
     `GetValue NHV_Status_OculatusHeat >= 4` (roher Heat-Wert). Script `NHV_IL02Script`, Properties
     `OculatusSys` und optional `Informant` (auf den Spitzel-Alias, nur für den Log-Hinweis genutzt –
     siehe Script-Kommentar) setzen. Ein Stage-Fragment ruft `Conclude(aiOutcome)` auf: 0 Kampf
     gewonnen, 1 Verhör erfolgreich (Speech-Check-Ergebnis), 2 nur beobachtet/gefolgt.
6. **Encounter platzieren.**
   - First Blood: `NHV_FormList_OculatusMercs` (2–3 Templates) an `NHV_Mk_IL01_AmbushSpot`, über
     bestehende Zufallsbegegnungs-Mechanismen entlang der Straßen (keine neue Zelle nötig). Brief
     `NHV_Item_OculatusLetter` einem Template ins Inventar legen.
   - Knock at Dawnstar: `NHV_FormList_OculatusAgents` (3–4 Templates) an `NHV_Mk_IL02_ScoutCamp`, in
     einer **Wildnis-Zelle im Umland von Dawnstar** – ausdrücklich nicht in der Zelle
     `DawnstarSanctuary` platzieren (sonst zusätzliche Zell-Kopie nach E16, siehe
     `docs/ARCHITECTURE.md`). Ein Verhör-Dialogset am gefangenen Agenten mit Speech-Check-Verzweigung
     (Erfolg → `Conclude(1)`, Kampf/Niederlage → `Conclude(0)`, „nur folgen“-Option → `Conclude(2)`).
7. **Spitzel-NPC `NHV_Informant` anlegen** (Aussehen/Name laut Codex-Brief, nach `lore-editor`-Prüfung
   des Namens), Referenz `NHV_InformantRef` am Dawnstar-Hafen platzieren (persistent, nicht Vanilla-
   Zelle-verändernd – prüfen, ob der Hafen in einer eigenen Exterior-Zelle liegt oder ob eine neue
   Referenz dort eine Zell-Kopie nach E16 auslöst; falls ja, mit dem Entwickler abklären, bevor
   platziert wird). **Wichtig:** `NHV_Informant` darf **nicht** als Essential oder Protected geflaggt
   werden – `NHV_InformantAliasScript.Resolve(0)` ruft `Kill()` auf, das gegen einen Essential/
   Protected-Actor wirkungslos bleibt. Auf `NHV_InformantAliasScript` zusätzlich die Property
   `PlayerRef` auf den Spieler setzen (Actor-Property, wie an anderer Stelle im Projekt üblich) – sie
   entscheidet in `OnDeath()`, ob ein Tod außerhalb des Dialogs dem Spieler zugeschrieben wird.
   - **FaceGen:** wie bei anderen neuen NPCs im CK generieren (Export FaceGen Data), Dateien landen
     unter `Data/Meshes/Actors/Character/FaceGenData/FaceGeom/NightsHarvest.esp/` und
     `Data/Textures/Actors/Character/FaceGenData/FaceTint/NightsHarvest.esp/` (analog zu Veyras
     `0004DDA0`-Dateien, bereits im Repo als Beispiel vorhanden).
   - Package `NHV_Pkg_Informant_Harbor` (Tag) und `NHV_Pkg_Informant_WatchNight` (Nacht) zuweisen,
     beide ohne Navmesh-Edits (Sandbox auf bestehenden Wegen/Radius).
8. **Entlarvungs-Dialog anlegen** (Konfrontation, Condition `GetValue NHV_Status_OculatusHeat >= 2 (roher Heat-Wert)`):
   ein Topic, das `NHV_InformantAliasScript.Expose()` aufruft (Ergebnis-Fragment), gefolgt von einem
   Ausgangs-Dialog mit drei Optionen:
   - Töten → `Resolve(0)`, **ausschließlich im End-Fragment der Ausgangs-Option**, kein separater
     Zwischenschritt.
   - Umdrehen (Doppelagent) → `Resolve(1)`.
   - Laufen lassen → `Resolve(2)`.
   **Hinweis:** `Resolve(0)` ruft bereits `Actor.Kill()` selbst auf – im CK-Dialog also **nicht**
   zusätzlich eine „Kill Actor“-Ergebnisfunktion einbauen, sonst doppelter Tod/Fehler, und `Resolve(0)`
   nicht vor dem eigentlichen Ende der Option aufrufen (z. B. nicht schon in einem Zwischen-Fragment,
   das der Spieler noch verlassen könnte). Die `OnDeath()`-Function im Script fängt einen Tod außerhalb
   dieses Dialogs (Spieler greift direkt an, oder ein Dritter tötet ihn vorher) separat ab; Heat sinkt
   dabei nur, wenn `akKiller` dem gesetzten `PlayerRef` entspricht.
9. **Chiffre-Schlüssel und Spitzel-Codex-Texte einbauen**, sobald Codex geliefert hat (siehe
   `docs/codex/2026-09-28-Oculatus-Prefects-Key.md`, `docs/codex/2026-09-28-Interludes-
   FirstBlood-KnockAtDawnstar.md`, `docs/codex/2026-09-28-Gleaning-Faden-Texte.md`,
   `docs/codex/2026-09-28-Spitzel-Dawnstar.md`) – separater Schritt, nicht Teil dieser
   Script-/Quest-Verdrahtung.

## Test im Spiel

Debug-Global `NHV_Cfg_Debug` auf 1 setzen (Papyrus-Log an), dann:

1. Neues/bestehendes Save laden. Erwartet im Log: `[NHV] NHV_Sys_Oculatus Maintenance done, heat=0`.
2. Per Konsole `NHV_Status_OculatusHeat` auf 2 setzen (`set NHV_Status_OculatusHeat to 2`), Sanctuary-
   Umgebung betreten. Erwartet: First-Blood-Encounter wird laut Story-Manager-Log als Kandidat
   erwogen (bzw. beim nächsten Straßenkontakt ausgelöst); nach Abschluss im Log:
   `[NHV] ReportEvidence: IL01 First Blood: letter found (no change, heat=2)`. Danach die Quest erneut
   starten (z. B. `resetquest NHV_IL01_FirstBlood` oder ein zweiter Story-Manager-Durchlauf, falls die
   „Run Once“-Sperre umgangen wird) und `Conclude()` ein zweites Mal auslösen: Erwartet im Log
   `NHV_IL01Script.Conclude: interlude 1 already claimed, heat not booked again` – kein zweiter
   `ReportEvidence`-Eintrag.
3. Global auf 4 setzen, zur Wildnis-Zelle bei `NHV_Mk_IL02_ScoutCamp` reisen. Erwartet: Encounter
   erscheint; nach Verhör-Erfolg im Log `ReportEvidence: IL02 Knock at Dawnstar: agent talked (4 -> 3)`
   (ggf. mit Zusatz `(informant outcome N)`, falls die `Informant`-Property gesetzt ist). Testweise mit
   ungültigem Wert `Conclude(9)` aufrufen (Debug-Konsole): Erwartet `NHV_IL02Script.Conclude: invalid
   outcome 9`, kein Heat-Effekt, `bResolved` bleibt False (Wiederholung mit gültigem Wert muss noch
   funktionieren).
4. Spitzel am Hafen tagsüber beobachten (normales Sandbox-Verhalten), nachts an seinem Watch-Punkt
   antreffen. Global auf 2 setzen, ihn konfrontieren. Erwartet im Log:
   `[NHV] NHV_InformantAliasScript: informant exposed`, danach je nach gewählter Option eine der
   drei `ReportEvidence`-Zeilen (`Informant killed`, `Informant turned`, `Informant released, keeps
   reporting`). Test „Dritter tötet ihn zuerst“: Spitzel per Konsole von einem Wachtposten statt vom
   Spieler töten lassen (oder `Kill()` über eine fremde Referenz simulieren) – erwartet nur
   `NHV_InformantAliasScript.OnDeath: died without player attribution, no heat change`, kein
   `ReportEvidence`-Eintrag.
5. Speichern/Laden während `NHV_Sys_Oculatus` läuft: Heat-Wert bleibt erhalten, `Maintenance()`-Zeile
   erscheint erneut im Log ohne Fehler oder doppelte Migration.
6. `GetHeatStage()` grob mitprotokollieren (z. B. über eine Debug-Konsolenausgabe im CK oder indem
   der Entwickler kurz den Wert von `NHV_Status_OculatusHeat` gegen die Stufentabelle prüft): 0–1
   Unbemerkt, 2–3 Fragt nach, 4 Handelt, 5 Vollalarm.

Vor dem Einbau: FormIDs gegen den aktuellen Record-Export prüfen (Kollisionsvermeidung), Namen und
Dialogtexte erst nach Codex-Lieferung und `lore-editor`-Freigabe final einsetzen.
