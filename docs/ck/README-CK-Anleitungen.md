# CK-Anleitungen Q00–Q02: Einstieg und Reihenfolge

Stand: 02.10.2026. **Nichts hiervon ist ingame getestet.** Die frühere Sammelanleitung `Q00-Q02-CK-Anleitung-Final.md` ist durch drei Dateien ersetzt (die alte Datei bleibt als Quelle liegen). Die Q03-Anleitung bleibt unverändert und separat.

| Datei | Typ | Aufgaben |
|---|---|---|
| `CK-1-Nur-Kontrollieren.md` | K (existiert, Werte prüfen) | 26 (übergreifend 7, Q00 5, Q01 3, Q02 11); enthält die Zuordnungstabelle alt zu neu |
| `CK-2-Nur-Aendern.md` | Ä (Wert falsch/fehlt, Record vorhanden) | 10 (Q00 1, Q01 2, Q02 7) |
| `CK-3-Nur-Neu.md` | N (Record oder Ref fehlt) | 13 (Q00 1, Q01 2, Q02 10) |

IDs: `K-`, `Ä-`, `N-` plus Quest-Kürzel (`Q00`, `Q01`, `Q02`, `ALL` = übergreifend) plus laufende Nummer, z. B. `K-Q02-03`. Die IDs bleiben stabil.

## Voraussetzung (gilt für alle drei)

ESP wurde von Claude geschrieben und in die Dev-Kopie synchronisiert (Claude meldet „ESP geschrieben und synchronisiert“); das CK läuft aus `C:\Dev\brotherhood-devenv\SkyrimSE-Dev`; **ein Schreiber am ESP (E17)**: CK und Claude nie gleichzeitig. Keine Vanilla-Records ändern (Regel 1).

## Empfohlene Reihenfolge

| Schritt | Was | Aufgaben | Begründung |
|---|---|---|---|
| 0 | Vorbereitung | CK-1: K-ALL-01 (ESP-Stand, Backup, Skripte), **K-ALL-02 (SKSE-`ObjectReference.psc` kopieren)**, K-ALL-03 (CK starten, Warnungen) | Ohne Skripte fehlen Properties; ohne K-ALL-02 scheitert der Fragment-Compile von `QF_NHV_Q02_ColdWaters_02004100` (`SetDisplayName`). Ohne Sync gehen Nachträge verloren. |
| 1 | **Ändern, unabhängige Pflichtkorrekturen** | CK-2: Ä-Q02-01, Ä-Q02-02, Ä-Q02-03 (je 5 min, P1), Ä-Q02-04, Ä-Q02-06, Ä-Q02-07, Ä-Q01-01; Ä-Q00-01 nur wenn Zeit | Kurz, klar umrissen, blockieren den Quest-Ablauf (Hollow-Tür, Leiche, Sings). Ä-Q02-04 (Zell-Owner/Name/Location) **vor** dem Platzieren von Betten und Refs in diesen Zellen, sonst erben sie fremden Besitz. Ä-Q02-06 (Race des Kuriers, FaceGen) vor dem Platzieren der Enforcer-/Kurier-Refs; Ä-Q02-07 (Item-Modelle) vor dem Platzieren der Items. |
| 2 | **Neu erstellen** | CK-3, Q02 zuerst in der Reihenfolge N-Q02-01, -02, -04, -05, -06, -03; dann -08 (Betten), Q01: N-Q01-01; optional N-Q02-07/09/10, N-Q01-02; N-Q00-01 zuletzt (mehrtägig) | Schaltet den Q02-Test frei (Tidehouse, Salzplatz, Kurier). Erzeugt die Refs und FormKeys, die Schritt 3 und die Rückmeldung brauchen. Navmesh (N-Q02-03) erst nach dem Raum; Backup vorher. |
| 3 | **Ändern, abhängige Aufgaben** | CK-2: Ä-Q02-05 (4 Quest-Properties), Ä-Q01-02 (5 Sleep-Packages) | Brauchen die Refs und Betten aus Schritt 2 (EditorIDs müssen vorhanden sein, sonst fehlen sie in der Auswahl). |
| 4 | **Kontrollieren** | CK-1: alle übrigen K-Aufgaben (Quest-/Package-/Szenenabgleich, K-Q02-07 Alias-Typen, Navmesh K-Q02-10 und K-Q01-02, K-ALL-04/05/06, Q00-Kontrollen) | Zuletzt, weil die Kontrolle den **Endzustand** (nach Ändern und Neu) prüft und Navmesh/Erreichbarkeit der neuen Refs einschließt. Reine Lese-Aufgaben können aber jederzeit zwischendurch laufen, wenn das CK ohnehin offen ist. |
| 5 | Abschluss | CK-1: K-ALL-07 (Strg+S, schließen, Backup), dann Rückmeldung | Einmal speichern; danach `ToText` durch Claude. |

**Wenn die Zeit knapp ist (Q02-Test freischalten):** K-ALL-01, K-ALL-02, K-ALL-03, Ä-Q02-01, Ä-Q02-02, Ä-Q02-03, N-Q02-01, N-Q02-04, N-Q02-05, N-Q02-02, N-Q02-06, Ä-Q02-06, Ä-Q02-05, N-Q02-03, K-ALL-07. Alles andere ist für den ersten Q02-Durchlauf verzichtbar (Fallbacks im Script, siehe „Ohne diese Aufgabe“ bei den Aufgaben).

## Was hängt wovon ab

| Ergebnis | Wird gebraucht von |
|---|---|
| K-ALL-02 (SKSE-Quelle kopiert) | jedem CK-Fragment-Compile, der `NHV_CoreScript`/`NHV_Util` anspricht (alle Quest-Fragmente) |
| Ä-Q02-04 (Zell-Owner geleert, EditorID Hollow) | N-Q02-08 (Betten in Kontor und Hollow), N-Q02-06 (Kurier im Kontor) |
| Ä-Q02-06 (Race Kurier entschieden, FaceGen) | N-Q02-05, N-Q02-06 (Platzieren der Refs von AF10/AF11) und K-ALL-05 (`00AF10/11.NIF`) |
| Ä-Q02-07 (Item-Models) | N-Q02-05, N-Q02-06 (Messer, Token, Seal) |
| N-Q02-01 (Tidehouse-Zelle, Türen) | N-Q02-02, N-Q02-03 |
| N-Q02-02, -04, -05, -06 (Refs mit EditorIDs) | **Ä-Q02-05** (Properties `TidehouseEnforcerRefs`, `SaltYardEnforcerRefs`, `SaltYardMarker`, `CourierRef`) |
| N-Q01-01 (Bett-Refs) | **Ä-Q01-02** (Sleep-Packages), K-Q01-02 (Navmesh) |
| N-Q02-08 (Bett-FormKeys) | K-Q02-11 (Claude trägt `BEDS` in `tools/build_q02_packages.py` ein, dann zweiter CK-Durchgang) |
| Ä-Q02-03 (Sings Initially Disabled) | K-Q02-07 (Alias-Kontrolle, ob die Quest Sings über den Unique-Actor-Alias hält) |
| N-Q02-03 (Tidehouse-Navmesh), N-Q02-04 (Marker) | K-Q02-10 (Navmesh-Kontrolle) |
| Alle drei Dateien | K-ALL-07 (Speichern), Rückmeldung (Ergebnisse je Datei), E16-Tabelle (geänderte Zellen) |

## Grundgriffe im CK (einmal lesen)

| Aufgabe | Wo / Wie |
|---|---|
| Zelle öffnen | Menü **World, Cell View**. Oben **World Space** wählen: `Tamriel` für Außenzellen, `Interiors` für Innenräume. Außenzelle: Spalten X/Y oder Suchfeld; Doppelklick in der linken Liste lädt die Zelle ins **Render Window**. Windhelm Docks: `WindhelmDocksExterior01` (00B4B9), Tamriel, Gitter 34/8 laut Export. |
| Objekt suchen | **Object Window** (links), Baum links, Feld **Filter** oben (filtert EditorID und Name). |
| Objekt platzieren | Eintrag im Object Window anklicken und **ins Render Window ziehen**. Taste **F** setzt es auf den Boden/die Oberfläche darunter. |
| Referenz bearbeiten | **Doppelklick auf das Objekt im Render Window** öffnet den Dialog „Reference“: **EditorID** (oben), Haken **Initially Disabled**, Reiter **3D Data** (Position, Rotation), Reiter **Scripts**, Feld **Enable Parent**. Reiternamen im CK prüfen. **Der Haken „Persistent“ erscheint bei Charakter-Refs nicht** (Meldung des Entwicklers 02.10.2026); bei Nicht-Charakter-Refs (Marker, Betten, Items, Türen): vorhanden ja/nein melden. |
| Position ablesen/setzen | Ref-Dialog, Reiter **3D Data**, Werte X/Y/Z und Rotation. Ca. 70 Einheiten entsprechen 1 m. |
| Navmesh sichtbar | Render Window: Taste **M** (Navmesh-Anzeige), Navmesh-Bearbeitung über Menü **World, Navmesh** bzw. die Navmesh-Werkzeugleiste (im CK prüfen). |
| FaceGen | NPC im Object Window markieren, **Strg+F4** (oder im Preview-Fenster des NPC). |
| Duplicate | Object Window: Rechtsklick auf den Eintrag, **Duplicate**; im sich öffnenden Dialog **sofort EditorID ändern**, OK. Nie das Original speichern. |
| Quest-Script-Properties | Object Window, **Character, Quest**, Quest doppelklicken, Reiter **Scripts**, Script markieren, **Properties**, Zeile markieren, **Edit Value** (Arrays: im Dialog Einträge hinzufügen, im CK prüfen). |
| Package öffnen | Object Window, **Character, Package**, Doppelklick, Reiter **Package Data** (Ort), **Conditions**, **Schedule**. |
| FormID/FormKey ablesen | Ref-Dialog oder Object-Window-Spalte „FormID“. Die ersten beiden Stellen sind der Load-Order-Index im CK und **nicht** Teil des FormKeys. Melde die letzten 6 Stellen. |

## Nach dem CK (macht Claude)

1. CK **geschlossen**, Backup gemacht (K-ALL-07).
2. Claude: `sync_dev.ps1 -Direction FromDev`, `plugin_text.ps1 -Direction ToText`, prüft den Export (neue FormKeys, Properties, Betten, Vanilla-Overrides), `tools\build_q02_packages.py` mit den Bett-FormKeys (`BEDS`), trägt E16-Einträge ein, aktualisiert ROADMAP (Status „Test“) und PROGRESS. Falls Claude per Spriggit noch Werte setzt (z. B. Q01-Packages, Farmtür-Teleport), folgt ein **zweiter, kurzer CK-Durchgang** (ESP öffnen, speichern), nie parallel.
3. **Commit durch den Entwickler** (Claude schlägt die Nachricht vor, kein Push, kein Tag). Q02-Dateien und die vielen fremden Löschungen im Arbeitsbaum (Q00/Q01-Altrecords) **getrennt committen** (Phase-B-Datei Frage 10).
4. Spiel: ESP-Sync nur bei geschlossenem Spiel (Dev-Kopie, Lehre 14); `.psc` und `.pex` können auch bei laufendem Spiel kopiert werden, wirken aber erst nach dem Laden eines Saves.

## Ingame-Testhinweise (ohne `cqf`)

Vorbereitung: Papyrus-Logging an, Konsole `set NHV_Cfg_Debug to 1`. Refs sind in der Konsole **nur per FormID** ansprechbar (`prid 06xxxxxx`, Slot 06 wie in den bisherigen Tests; nach Hinzufügen neuer Plugins prüfen, ob der Index noch stimmt). `cqf` wird nicht benutzt; Rettungswege liegen im Skript.
**Konsolenhilfen:** `getstage NHV_Q02_ColdWaters`, `setstage NHV_Q02_ColdWaters <n>` (führt das Fragment aus und bewaffnet den passenden Hub), `coc <Zell-EditorID>` (z. B. `coc NHV_Q02_TidehouseCell`, Tidehouse sichtbar), `player.moveto 06<FormKey>` zum Springen, `prid 06005190` Sings, `…5191` Torbjorn, `…5192` Drinks, `…5195` Haldor, `…5194` Hjorald, `…5953` Aelius, `wait 24` / `set gamehour to 21.9` für Nachtszenen. Papyrus-Log mit **aktuellem Zeitstempel** zurückgeben (`Papyrus.0.log`, ins Repo-Root; ein altes Log ist wertlos, Lehre 13).

| Test | Erwartet (nichts davon ist getestet) |
|---|---|
| Save vor Q02, Map Table | Menü mit 5 Buttons; „Windhelm“ startet Q02 Stage 10; Veyra am Marker (K-Q02-01, Z-Abstand beachten) |
| Stage 10 | Torbjorn, Drinks, Veyra sprechen die Hubs an (kein Hello nötig) |
| **Stage 15** | Tidehouse betreten (N-Q02-01); Enforcer sprechen zuerst, greifen dann an; Ledger aufheben; Hjorald „I have the log“ setzt Stage 20; Log ohne „TidehouseEnforcerRefs not set“ |
| **Stage 20** | Leiche untersuchen setzt **nicht** Stage 20 bei Stage 10 (Ä-Q02-02) |
| Stage 30 nachts | Sings erscheint (Ä-Q02-03: nur mit Enable-Skript; Log „GetSings: enabling Sings (stage 30)“), Nachtszene startet |
| Stage 40/45 | Gerettet führt zu 45; Haldor verschwindet (Log `HideHaldor`); Salzplatz mit Drinks und Enforcern; Hollow-Tür akzeptiert 40–45 (Ä-Q02-01) |
| Stage 50 bis 100 | wie `Q02-Phase-B-Ergebnis.md` Abschnitt 10; Kurier erscheint nur bei geöffnetem Pult; nach Stage 100 Haldor wieder aktiv (Log `ShowHaldor`) |
| Nacht, Wartezeit | Torbjorn, Drinks (Assemblage), Aelius schlafen in ihren Betten (N-Q02-08, K-Q02-08); Stage 10–29 Torbjorn und Drinks wach |
| Q01 | Hakan/Hrefna/Quintus Tag/Nacht (Ä-Q01-02); Farmtür Landung (Ä-Q01-01); Veyra ab Stage 100 über mehrere Tage (K-Q00-02) |
| Fehlerbild | Reglos oder weggelaufen: Name, `getstage`, Spielstunde und Papyrus-Log melden |

## Offene Fragen (nicht geklärt, nicht als Fakt behandelt)

1. **Sings Variante B (Initially Disabled)** ist entschieden (`Q02-NPC-Packages.md` Ä4). Offen: Bleibt Sings nach Release/Surrender bewusst deaktiviert (laut jener Datei kein Re-Enable)? **Neu:** Greift `Enable()` auf die Sings-Ref aus einer anderen Zelle ohne Persistent-Haken (Test: Stage 30 nachts)? Wenn nein: Skript-Anpassung oder Rückfall Variante A.
2. **Tidehouse-Tür:** an welche Hafengebäude-Fassade (Vorschlag: zwischen Hjoralds Posten und der Kontor-Tür) und welcher Anzeigename („Tidehouse“ ist ein Platzhalter)? (N-Q02-01)
3. **Cell-Location** für Kontor, Hollow und Tidehouse: leer lassen, oder soll Claude eigene Locations anlegen (Vanilla-Locations erzeugen automatische Overrides)? (Ä-Q02-04, N-Q02-01)
4. **Kurier-Race:** Nord (Export) oder Imperial (`013744`)? Entscheidung vor dem FaceGen-Export. (Ä-Q02-06)
5. **Q01-Bett-Umstellung:** im CK (Weg A, ein Durchgang) oder per FormKey-Meldung und Spriggit (Weg B, wie Q02, zweiter CK-Durchgang)? (Ä-Q01-02)
6. **Farmtür:** Welche Seite zeigt die Türvorderseite? (Ä-Q01-01 Schritt 1; Vorschlag nimmt Süden an.)
7. **Vanilla-Altlasten:** Soll `DeepSanctuaryNEW` (016204), die Fremd-FaceGen `0004DDA0` und `ChillfurrowFarmDUPLICATE001` bereinigt werden? Nie ohne Entscheidung löschen. (K-ALL-04, K-ALL-05)
8. **Map-Table-Marker Z:** Marker -15,5 gegen Tisch 224 laut Export: gewollt (zwei Ebenen) oder Marker versetzen? (K-Q02-01)
9. **Q00-NPCs ohne Idle-Package (nicht beauftragt):** Laut Export hat `NHV_Veyra` (000817) im NPC-Record nur AD10–AD12 (Bedingung Q01-Stage >= 100) und zusätzlich Q00-Alias-Packages (Q00-Stage < 100 bzw. Szenen) und Q01-Alias-Packages (Stage 10 bis < 100). Es gibt also **keine** Idle-Routine zwischen Q00-Ende und Q01-Start (Dauer ungeprüft) und ab Q00-Ende bis Q01-Briefing. Lucien hat nur `NHV_Pkg_Sys_LucienStand` (004404). Nazir, Babette und Cicero nutzen Vanilla-Routinen (Q00 hält sie nur bis Stage 15 fest). Soll ein Package-Bau für Q00 beauftragt werden? Dann eigene Aufgabe (Veyra Q00-Ende, Lucien).
10. **Chiffre-Schlüsselbuch:** Enable-Parent am Dispatch (Vorschlag in N-Q02-07) ja/nein?
11. **Haldor:** Soll Haldor nach Stage 100 an seinem Ursprungsplatz bleiben (laut Package-Datei so umgesetzt) oder an einem eigenen Marker (`NHV_Mk_Q02_HaldorReturn`, N-Q02-10)? Die Entscheidung gehört auch in `docs/DECISIONS.md` (Haldor versteckt 45–99, zurück ab 100, tot bleibt liegen). **Der frühere Vorschlag „Persistent“ an Ref 005195 ist gestrichen** (Haken existiert nicht); Haldor wird über den Unique-Actor-Alias gehalten (K-Q02-07). Offen und ungetestet: `Enable()` auf Haldor ab Stage 100.
12. **Vanilla-Reste in Kontor und Hollow** (`TGCrown09Go001`, `TGCrownGemAct010`, `WindhelmPalaceUp1PatrolB004`, `WindhelmWuunferthLabMarker001`, `LargashburBasementToExterior001`): vor Release entfernen? Jetzt oder später? (Ä-Q02-04)
13. **Schreibtisch im Kontor:** Soll das Buch auf Aelius' Schreibtisch (PROGRESS 30.09.: „nicht entschieden“) bleiben oder entfallen? (N-Q02-09, K-Q02-09)
14. **Q01-Soldaten-Template (F9):** Nebenwirkungen des entfernten Template-Flags? Im Test beobachten (Wachposten anschleichen). (K-Q01-01)
15. **Owner der Deep Sanctuary** (`06566B:Skyrim.esm` laut Export): Vanilla-Besitzer gewollt? Betrifft Diebstahl-Warnungen und Schlafen. (K-Q00-05)
16. **Hrefna im Inn-Ende (F6 der Q01-Package-Anleitung):** Farm-Wartepfad auch dort? (Skript-/Journal-Entscheidung, nicht CK; nur der Vollständigkeit halber.)
17. **Neu:** Enforcer- und Kurier-Refs ohne Persistent: reicht die Property (Spieler in derselben Zelle), oder soll das Skript sie zusätzlich über `EnforcerAlias`/`CourierAlias` per `ForceRefTo` halten? (Skript-Entscheidung nach dem ersten Test; Ä-Q02-05)

## Nicht geprüft / Hinweise zur Verlässlichkeit

- **Nicht geprüft** (CK-Verhalten, nicht lesbar aus dem Export): Menüpfade und exakte Feldnamen im CK; ob ein Enable auf eine nicht persistente, deaktivierte Ref aus anderer Zelle in Skyrim SE zuverlässig funktioniert (ungetestet in diesem Projekt, siehe K-Q02-07); ob ein Unique-Actor-Alias auf eine Initially-Disabled-Ref füllt; Art der Item-Platzierung im NPC-Inventar per Ref; Kit-Namen für den Tidehouse-Innenraum; Outfit-Auswahl der Enforcer.
- **Nicht ingame getestet:** alles. Insbesondere der Rückfall-Pfad ohne neue Refs, die Package-Übergänge (Schlaf, Sandbox), der Kurier (Confidence 0 plus `StartCombat`), Veyras Tagesroutine über die Ladetür.
- **Datenquellen:** Alle Vanilla-Namen und -Modelle aus `housecarl_records` (`Skyrim.esm`): `BedrollHay01` (FURN 01899D), `Bedroll01` (036ED3), `CommonBed01` (030091), `CommonChair01` (02EC1C), `BedrollHay01STATIC` (STAT 101A36), `CivilWarMap02` (STAT 070BC2), `DockRopeStr02` (STAT 0BEC5E), `XMarker` (00003B), `XMarkerHeading` (000034), `MapMarker` (000010). Alle anderen Objektnamen stammen aus den älteren Anleitungen oder sind mit „im CK prüfen“ markiert.
- **Quellen der Zusammenführung:** `docs/plan/Q02-Phase-B-Ergebnis.md` (Abschnitt 9), `docs/plan/Q02-NPC-Packages.md`, `docs/plan/Q01-NPC-Packages.md`, `docs/ck/M1.7-Q01-Enhanced-CK-Anleitung.md`, `docs/ck/M2.0-Map-Table.md`, `docs/ck/M2.2-Q02-CK-Anleitung*.md`, `docs/ck/M1.3-Deep-Sanctuary-*`, `docs/PROGRESS.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, Export `plugin-text/` (Stand 02.10.2026).
