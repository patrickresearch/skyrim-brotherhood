# Technische Architektur – Night's Harvest

Leitlinie: so viel wie möglich über Records und Conditions, so wenig wie möglich über Papyrus, keine eigene SKSE-DLL. Ausführlich: Konzept Abschnitte 14 und 15.

## Plattform & Abhängigkeiten

- Skyrim SE 1.5.97 und AE 1.6.x; GOG sofern SKSE verfügbar.
- Hart: SKSE64, SkyUI (MCM über `SKI_ConfigBase`).
- Master: nur `Skyrim.esm`, `Update.esm` (E05). DLC-Inhalte weich per `Game.GetFormFromFile()`.
- Genutzte SKSE-Papyrus-Funktionen u. a.: `Form.GetName()`, `StringUtil`, `Game.GetModByName()`, ModEvents, `SKSE.GetVersion()`.
- Fehlt SKSE, zeigt `NHV_Sys_Core` eine Warnung und bleibt inaktiv.

## Plugin

- Normales ESP (E04, Neubewertung nach Record-Inventur in M1). Geschätzt 3.500–4.800 neue Records; ESL-Grenze 4.096.
- Nicht lokalisiert; Übersetzungen später per xTranslator.
- FormIDs werden nach Release nie gelöscht oder neu vergeben. Veraltetes erhält das Präfix `zzNHV_DEPRECATED_`.
- **Zell-Kopien (E16):** Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin. Diese Kopien bleiben inhaltlich identisch mit Vanilla und werden hier gelistet:

| Vanilla-Zelle | Grund | Seit |
|---|---|---|
| (noch keine) | | |

## Quest-Architektur

| Quest | Start | Aufgabe |
|---|---|---|
| `NHV_Sys_Core` | Start Game Enabled | Versionierung, `Maintenance()`, SKSE- und Kompatibilitätserkennung, Laufzeit-Fraktionsbeziehungen, Start von Q00 nach Wartezeit |
| `NHV_Sys_MCM` | Start Game Enabled | SkyUI-MCM |
| `NHV_Sys_Sanctuary` | Q00 Stage 10 | Optionale Aliase für Nazir, Babette, Cicero, Night Mother; neue Dialoge/Packages; Zustände Deep Sanctuary |
| `NHV_Sys_Family` | Q00 Stage 100 | Aliase der Story-Rekruten, Status-Globals, `NHV_FamilyStrength`, Follower-Slots, Tod/Memorial Wall; Reserve-Aliase |
| `NHV_Q00_…` bis `NHV_Q06_…` | stage-gesteuert | Story-Quests |
| `NHV_Sys_Ledger` | Abschluss Q06 | 12 Slot-Aliase `RecruitSlot01`–`12`, Eignung, Initiation |
| `NHV_Sys_Banter` | Abschluss Q01 | Banter-Szenen B01–B12 |
| `NHV_Sys_Debug` | nur über MCM | Test-Sprünge, Reparaturfunktionen |

Grundsatz: Story-Quests enthalten nur Stage-Logik und quest-eigene Aliase. Alles, was eine Quest überdauert, lebt in System-Quests. Abgeschlossene Story-Quests lassen sich stoppen, ohne Rekruten zu verlieren.

## Aliase & Vanilla-NPCs

- Vanilla-NPC-Records werden nie verändert. Dialoge, Packages, Fraktionen, Scripts hängen an Reference-Aliasen in `NHV_Sys_Sanctuary`.
- Aliase auf Vanilla-Referenzen sind immer **Optional**, Fill-Type „Specific Reference“. Ohne Optional startet die Quest stumm nicht, wenn z. B. Cicero tot ist.
- Alias-Packages haben Vorrang vor NPC-Packages; die Alias-Reihenfolge bestimmt die Priorität.
- Story-Rekruten: eigene Unique-NPCs, persistente Referenzen im Deep Sanctuary, anfangs deaktiviert.
- Generische Rekruten: `ForceRefTo()` in freie Slot-Aliase; Entlassen = `Clear()`, Fraktionen entfernen, `MoveToMyEditorLocation()`.
- Aliase in laufenden Quests werden bei Updates nicht neu befüllt → System-Quests bekommen Reserve-Aliase.

## Fraktionen

| Fraktion | Zweck |
|---|---|
| `NHV_FamilyFaction` | Alle Mitglieder, Vanilla-DB-Mitglieder über Aliase |
| `NHV_CandidateFaction` | Von „Sense the Darkness“ markierte Kandidaten |
| `NHV_InitiateFaction` | Rekruten während der Initiation |
| `NHV_OculatusFaction` | Livia Maro und Agenten, feindlich |

Neue Rekruten erhalten nicht die Vanilla-`DarkBrotherhoodFaction`. Die Allianz setzt `NHV_Sys_Core` zur Laufzeit per `Faction.SetAlly()`.

## Follower-System (Empfehlung, E01)

- Eigenes System in `NHV_Sys_Family`: `FollowerSlot1`, `FollowerSlot2` (MCM 0–2).
- Befehle per Dialog: „Walk with me“, „Wait here“, „Go home“, Inventar (`OpenInventory`).
- `SetPlayerTeammate(true)`, kein Eintrag in `CurrentFollowerFaction` → Vanilla-Slot frei, Frameworks greifen nicht zu.
- Catch-up-Teleport per `RegisterForSingleUpdate` nur, solange ein Follower aktiv ist.
- Optionaler MCM-Kompatibilitätsmodus mit `CurrentFollowerFaction`.

## Scripts

| Script | Basis | Aufgabe |
|---|---|---|
| `NHV_CoreScript` | Quest | Version, Startbedingung, Fraktionen, Kompatibilität |
| `NHV_PlayerAliasScript` | ReferenceAlias | `OnPlayerLoadGame()` → `Maintenance()` |
| `NHV_MCMScript` | SKI_ConfigBase | MCM |
| `NHV_ContractBaseScript` | Quest | Basisklasse Q01–Q05: Phasen, Status-Global, Belohnung, Fragment |
| `NHV_Q01Script` … `NHV_Q05Script` | NHV_ContractBaseScript | Quest-spezifische Logik |
| `NHV_FamilyManagerScript` | Quest | Rekruten registrieren, Familienstärke, Follower-Slots |
| `NHV_RecruitAliasScript` | ReferenceAlias | `OnDeath()` → Status 2 (getötet), Memorial, ModEvent |
| `NHV_FollowerAliasScript` | ReferenceAlias | Folgen, Warten, Catch-up |
| `NHV_LedgerScript` | Quest | Eignung, Slots, Initiation |
| `NHV_SenseDarknessEffect` | ActiveMagicEffect | Kandidaten markieren |
| `NHV_BanterControllerScript` | Quest | Banter-Timer und -Auswahl |
| `NHV_FinaleWaveScript` | Quest | Q06 Wellen |
| `NHV_SanctuaryStateScript` | ObjectReference | Enable-Parents der Räume |
| `NHV_Util` | Globale Funktionen | Logging, gemeinsame Prüfungen |

ModEvents für Patches/Addons: `NHV_RecruitJoined`, `NHV_RecruitDied`, `NHV_ContractCompleted`.

## Globals (Auswahl)

- `NHV_Status_<Name>` je Story-Rekrut: 0 = unbekannt, 1 = rekrutiert, 2 = getötet, 3 = freigelassen, 4 = Sonderfall (ausgeliefert, verhaftet); nie umnummerieren
- `NHV_FamilyStrength`: Summe der Rekruten plus Boni, beeinflusst das Finale
- `NHV_AstridMemorial` (1–3, Q00 Szene 5)
- `NHV_CiceroReconciled`
- `NHV_Cfg_*` für alle MCM-Werte, damit Conditions sie lesen können

## Dialoge, Szenen, AI, Zellen

- Pro Quest eigene Branches; Veyra mit Top-Level-Branch `NHV_Veyra_Hub`.
- Generischer Rekrutierungsdialog in `NHV_Sys_Ledger`, Condition `GetInFaction NHV_CandidateFaction == 1`.
- Szenen als Scene-Records; Actors vorher per `MoveTo` auf XMarker (Pathing-Option B, keine Navmesh-Edits in der Vanilla-Sanctuary). Jede Szene hat eine Fallback-Stage.
- Tagesabläufe über Alias-Packages; Veyra nachtaktiv.
- `NHV_DeepSanctuaryCell` mit Location `NHV_DeepSanctuaryLocation` (Parent: Vanilla-Sanctuary-Location), Encounter Zone „Never Resets“, Room Bounds und Portale, Lighting Template. Räume mit Enable-Parents für verfallen/eingerichtet.
- **Zugang Deep Sanctuary (E16, E09):** Script-Tür statt Load Door, keine Zell-Kopie der Vanilla-Sanctuary. Vor Q00 Stage 40 steht an der Wandstelle nur ein Geröll-Activator (`NHV_Mk_Q00_SealedPassageDoor`, Platzierung im CK); ein Enable-Parent tauscht ihn nach der Proposal-Szene gegen eine Tür-Referenz. Die Tür ruft `MoveTo` auf ein XMarker in `NHV_DeepSanctuaryCell`, keine Navmesh-Verknüpfung zur Vanilla-Zelle. Follower folgen über den Catch-up-Teleport des Follower-Systems (M1.6), nicht über echtes Gehen durch die Tür.

## Repository-Struktur

```text
NightsHarvest/
├─ CLAUDE.md
├─ .claude/                      Skills und Subagents für Claude Code
├─ Data/                         Mod-Staging
│  ├─ NightsHarvest.esp
│  ├─ Scripts/                   .pex (Build-Artefakt, nicht versioniert)
│  ├─ Source/Scripts/            .psc
│  ├─ Interface/Translations/    NightsHarvest_ENGLISH.txt (UTF-16 LE mit BOM)
│  ├─ SEQ/                       NightsHarvest.seq, falls nötig
│  └─ Sound/Voice/NightsHarvest.esp/   ab v1.1
├─ plugin-text/                  Spriggit-Export
├─ dialogue/                     CSV-Master-Skript
├─ tools/                        Python-Tools
├─ fomod/                        info.xml, ModuleConfig.xml, images/
├─ docs/
└─ NightsHarvest.ppj             Pyro-Build
```

Entwicklung mit Loose Files, Release als `NightsHarvest.bsa` (Name muss zum Plugin passen).

## Kompatibilität

| Kategorie | Risiko | Maßnahme |
|---|---|---|
| USSEP | niedrig | Empfohlen; Startbedingung prüfen |
| Sanctuary-Überarbeitungen | mittel–hoch | Zugang an Wand mit wenig Geometrie, Tests, ggf. Patches |
| DB-Erweiterungen | mittel | Nur Questabschluss gelesen, optionale Aliase |
| Follower-Frameworks | mittel | Eigenes System, Kompatibilitätsmodus |
| Stadt-Overhauls | mittel | Schlüsselszenen in eigenen Innenzellen, `MoveTo` auf XMarker |
| AI-Overhauls | niedrig | Alias-Packages haben Vorrang |
| Gameplay-Overhauls | mittel | Eigene Leveled Lists; Patches durch Community |
| Beleuchtung/ENB | niedrig | Lighting Templates |
| Mantella | niedrig | Läuft parallel, ersetzt keine geskripteten Zeilen |

## Save-Sicherheit & Updates

- Installation mitten im Spiel: sicher, Mod bleibt passiv bis „Hail Sithis!“.
- Deinstallation: nicht unterstützt; MCM-Funktion „Prepare for Uninstall“ räumt auf.
- Patch 1.0.x: nur Fixes, keine neuen Aliase in laufenden Quests. Minor 1.x: additiv, Migration über `Maintenance()`. Major: nur wenn unvermeidbar.
- Nie: FormIDs löschen, Properties/Variablen/States/Scripts umbenennen oder entfernen, Stages entfernen oder umnummerieren.
- Timer über Spielzeit-Globals, nicht über `Utility.Wait()`.
- Szenen prüfen `IsDead()` und `IsDisabled()` und springen sonst auf eine Fallback-Stage.
