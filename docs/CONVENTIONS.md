# Konventionen – Night's Harvest

## EditorIDs

Alle eigenen Records beginnen mit `NHV_`. CamelCase, keine Leerzeichen, keine Umlaute.

| Record-Typ | Muster | Beispiel |
|---|---|---|
| Story-Quest | `NHV_Q<Nr>_<Name>` | `NHV_Q00_ShadowAtTheDoor` |
| System-Quest | `NHV_Sys_<Name>` | `NHV_Sys_Core` |
| NPC / Referenz | `NHV_<Name>` / `NHV_<Name>Ref` | `NHV_Veyra`, `NHV_VeyraRef` |
| VoiceType | `NHV_Voice<Name>` | `NHV_VoiceVeyra` |
| Global | `NHV_<Bereich>_<Name>` | `NHV_Status_Hrefna`, `NHV_Cfg_FinaleDeath` |
| Package | `NHV_Pkg_<NPC>_<Aktivität>` | `NHV_Pkg_Veyra_NightWalk` |
| Szene | `NHV_Scn_<Quest>_<Nr><Name>` | `NHV_Scn_Q00_01Standoff` |
| Dialog-Branch / Topic | `NHV_<Quest>_<Sprecher>_<Thema>` | `NHV_Q01_Hrefna_Offer` |
| Zelle / Location | `NHV_<Name>Cell` / `NHV_<Name>Location` | `NHV_DeepSanctuaryCell` |
| XMarker | `NHV_Mk_<Quest>_<Zweck>` | `NHV_Mk_Q00_VeyraStandoff` |
| Fraktion | `NHV_<Name>Faction` | `NHV_FamilyFaction` |
| FormList | `NHV_<Name>` (Plural oder Zweck) | `NHV_RecruitBlacklist` |
| Item / Waffe | `NHV_<Typ>_<Name>` | `NHV_Weap_BogwifesKnife` |
| Spell / Magic Effect | `NHV_Spell_<Name>` / `NHV_MGEF_<Name>` | `NHV_Spell_SenseTheDarkness` |
| Message | `NHV_Msg_<Zweck>` | `NHV_Msg_SkseMissing` |
| Script | `NHV_<Name>Script` | `NHV_ContractBaseScript` |

Nach Release werden EditorIDs nicht mehr umbenannt, wenn Scripts oder Patches sie referenzieren. Veraltetes: Präfix `zzNHV_DEPRECATED_`.

## Papyrus-Stil

- Ein Script pro Datei, Dateiname = Scriptname.
- Kopfkommentar mit Zweck, zugehörigem Record und Konzept-Abschnitt.
- Properties in PascalCase, benannt wie der Record (`NHV_FamilyFaction`), `Auto` wo möglich. Den Spieler als Property `PlayerRef` halten statt wiederholt `Game.GetPlayer()` aufzurufen.
- Parameter mit Bethesda-Präfixen: `akActor`, `akRef`, `abFlag`, `aiCount`, `afValue`, `asText`.
- Lokale und Script-Variablen mit Typ-Präfix: `iCount`, `fDistance`, `bBusy`, `sName`, `kTarget`.
- Konstanten als Properties mit `AutoReadOnly` (z. B. `Int Property VERSION = 1 AutoReadOnly`).
- Kommentare auf Englisch, knapp, erklären das Warum.
- Logging nur über `NHV_Util.Log()`, das `Debug.Trace("[NHV] …")` nur bei `NHV_Cfg_Debug == 1` schreibt.

## Papyrus-Regeln (verbindlich)

1. **Kein Polling.** Keine dauerhaften `OnUpdate`-Schleifen; nur `RegisterForSingleUpdate()` / `RegisterForSingleUpdateGameTime()` mit gezielter Neuregistrierung. Sonst Story-Manager-Events, Trigger-Boxen, Alias-Events.
2. **Conditions vor Scripts.** Was eine Condition-Funktion am Record prüfen kann, prüft kein Script.
3. **Fragmente kurz.** Stage-Fragmente rufen 1–3 Funktionen des Quest-Scripts auf. Kein `Utility.Wait()` in Fragmenten. Fragment-Dateien (`QF_…`, `TIF_…`, `SF_…`) erzeugt das CK; Claude liefert nur den Fragment-Text zum Einfügen.
4. **Properties statt Lookups.** `Game.GetFormFromFile()` nur für weiche Abhängigkeiten.
5. **Persistenz sparsam.** Referenzen in Properties werden dauerhaft persistent; für wechselnde Actors Aliase nutzen.
6. **None-Sicherheit.** Jede Alias-Referenz (`GetReference()`, `GetActorRef()`) vor Gebrauch auf `None` prüfen.
7. **States** für Mehrphasen-Logik und gegen doppelte Ausführung (`GotoState("Busy")`).
8. **Idempotenz.** `OnInit()` und `Maintenance()` dürfen mehrfach laufen, ohne Schaden anzurichten.
9. **Save-Stabilität ab 0.1.0.** Keine Properties, Variablen, States, Functions mit Event-Bindung oder Scripts umbenennen oder entfernen.
10. **Versionierung.** `NHV_CoreScript` hält die Script-Version; jede Migration ist ein eigener, nummerierter Schritt in `Maintenance()`.

## Git

- `main` ist immer spielbar und bekommt Änderungen nur per Merge aus `dev`, nach bestandenem Ingame-Test (in der Regel je Meilenstein). Releases entstehen aus `main`.
- Die laufende Entwicklung findet auf `dev` statt. Feature-Branches nur für Scripts und Tools, abgezweigt von `dev`: `feat/<paket>-<thema>`, z. B. `feat/m1-core`.
- ESP-Änderungen direkt auf `dev` (Binärdatei, nicht mergebar). ESP, Spriggit-Export und Scripts im selben Commit.
- Entwickelt wird nur im Repository und in der Dev-Kopie des Spiels; das Live-Spiel bleibt unangetastet (`docs/ENVIRONMENT.md`).
- Commit-Format: `[<Bereich>] <Was>` – Bereich ist Quest (`Q00`), System (`Core`, `Family`, `Ledger`, `MCM`) oder `Tools`, `Docs`, `Build`. Beispiel: `[Q00] Szene 1: Marker und Packages`.
- Nicht versionieren: `.pex`, `.bsa`, `.7z`, CK-Backups, Logs.
- Tags: `v0.1.0` je Meilenstein, `v0.9.x` Beta, `v1.0.0` Release. Claude taggt und pusht nur auf Aufforderung.

## Versionierung

Semantic Versioning, dieselbe Nummer in `NHV_CoreScript`, `fomod/info.xml`, Nexus-Eintrag und Git-Tag. Jeder Changelog-Eintrag nennt „save-safe: yes/no“.

## Dateien & Kodierung

- Markdown und CSV: UTF-8 ohne BOM.
- MCM-Übersetzungsdatei `Interface/Translations/NightsHarvest_ENGLISH.txt`: UTF-16 LE mit BOM, Tab zwischen Schlüssel und Text, Schlüssel mit `$NHV_`.
- Zeilenenden: CRLF für `.psc` und `.txt` im `Data/`-Baum (Windows-Tools), sonst LF.
