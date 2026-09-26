# Entscheidungen – Night's Harvest

Offene Fragen und getroffene Entscheidungen. Claude legt nichts fest, was hier als „Offen“ steht, sondern fragt nach. Getroffene Entscheidungen werden unten als Eintrag dokumentiert und in der Tabelle auf „Entschieden“ gesetzt.

## Übersicht

| Nr. | Frage | Optionen | Empfehlung | Fällig | Status |
|---|---|---|---|---|---|
| E01 | Follower-System | Eigenes System / Vanilla-Slot / Framework-Integration | Eigenes System + MCM-Kompatibilitätsmodus | vor M1 | Offen |
| E02 | Standard-Sterblichkeit der Rekruten | Essential / Protected / Mortal | Protected | vor M1 | Offen |
| E03 | Release-Strategie | Komplette v1.0 / Kapitel-Releases | Komplette v1.0 mit geschlossener Beta | bis Ende M2 | Offen |
| E04 | Plugin-Format | ESP / ESL-geflaggtes ESP | ESP, nach Record-Inventur neu prüfen | Ende M1 | Offen |
| E05 | Master-Dateien | Skyrim.esm + Update.esm / zusätzlich Dawnguard, Dragonborn | Nur Skyrim.esm + Update.esm | in M0 | Entschieden |
| E06 | MCM-Technik | SkyUI direkt / MCM Helper | SkyUI direkt | vor M1 | Entschieden |
| E07 | Einstellungs-Export | Keiner / optional über PapyrusUtil-JSON | Optional, erst in M6 | vor M6 | Offen |
| E08 | Livia-Rekrutierungspfad in v1.0 | Behalten / nach v1.1 | Behalten, erster Scope-Hebel | während M3 | Offen |
| E09 | Pathing Vanilla-Sanctuary | Option B `MoveTo` / Option A Navmesh-Edits | B für v1.0 (bereits so geplant), A für v1.1 prüfen | Ende M1 | Entschieden |
| E10 | Vertonung zum Start | Nur Text / Release erst mit Stimmen | Nur Text, Voice-Pack in v1.1 | vor M6 | Offen |
| E11 | Voice-Pack-Format | BSA mit Dummy-ESL / Loose Files | BSA mit Dummy-ESL | vor v1.1 | Offen |
| E12 | Schreibweise Ingame-Texte | Amerikanisch / britisch | Amerikanisch | vor M1 | Offen |
| E13 | Unique-NPCs im Black Ledger | Erlaubt / verboten | Erlaubt (außer Essential, Blacklist), MCM | vor M4 | Offen |
| E14 | Standard-Wartezeit bis Q00 | 0–7 Tage | 2 Tage | vor M1 | Entschieden |
| E15 | Finaler Mod-Name | „Night's Harvest“ / Alternative | „Night's Harvest“, falls auf Nexus frei | vor M6 | Offen |
| E16 | Zugang Deep Sanctuary | A: Load Door mit Zell-Kopie / B: Script-Tür per `PlaceAtMe` + `MoveTo` | B, wegen `Sanctuary Reborn.esp` in der Load Order | vor M1.3 | Entschieden |
| E17 | ESP-Bearbeitung durch Claude | Nur CK / Claude per MCP oder Spriggit | Claude bearbeitet das ESP, Ein-Schreiber-Regel | vor M0.6 | Entschieden |
| E18 | Status-Wert für getötete Rekruten | 2 (Definition in Konzept Abschnitt 5) / 4 (zwei Stellen im Konzept) | 2 | vor M1.6 | Entschieden |
| E19 | MCM-Texte: Übersetzungsschlüssel in v0.0.1 | Jetzt `$NHV_*`-Keys + Translations-Datei / vorerst Literal-Strings, Umstellung in M6 | Vorerst Literal-Strings | vor M6 | Entschieden |
| E20 | Startbedingung Q00 | Nach „Hail Sithis!“ / nach „The Dark Brotherhood Forever“ (`DBrecurring`) | Nach `DBrecurring`, Wartezeit ab diesem Zeitpunkt | vor M1.9 | Entschieden |
| E21 | Technik für unvertonte Zeilen | Stille Sprachdateien mitliefern / Fuz Ro D-oh voraussetzen | Stille Sprachdateien (`tools/silent_voice.py`) | M1.5 | Entschieden |
| E22 | Ende der Standoff-Befragung | Automatisch nach erster Antwort / nur ausdrückliche Abschlusswahl | Nur ausdrückliche Abschlusswahl | M1.5 | Entschieden |
| E23 | Veyras Natur und Bindung an Sithis | Sterbliche Amtserbin / gebundene Nachleserin / wiederkehrende Gestalt / göttliche Verwandtschaft | Tochter Sithis', ungebunden und freiwillig treu; externe Helferin der Night Mother | vor weiterem Mysteriums-Dialogausbau | Entschieden |

### Hintergrund E16

Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin. Die Kopie ändert nichts, kann aber Änderungen anderer Mods an derselben Zelle (z. B. Beleuchtung) überdecken, wenn Night's Harvest später lädt. Das betrifft auch Quest-Referenzen in Städten (Q01–Q05). Grundregel unabhängig von E16: Schlüsselszenen in eigenen Innenzellen, berührte Vanilla-Zellen minimieren und in `docs/ARCHITECTURE.md` listen.

## Entscheidungs-Einträge

### E23 – Veyra als ungebundene Tochter Sithis'

- **Datum:** 26.09.2026; Grundrichtung durch den Entwickler nach der Lore-Analyse gewählt.
- **Entscheidung:** Veyra ist innerhalb unserer Mod eine Tochter von Sithis. Sie dient ihrem Vater freiwillig, ohne Fraktionsbindung, Zwangspakt oder abzutragende Schuld. Sein Dienst ist ihr einziges übergeordnetes Ziel. Sie ist kein Mitglied der Dark Brotherhood, sondern bietet der Night Mother ihre Hilfe zur Erhaltung und Erneuerung der Bruderschaft an.
- **Natur:** Endgültiger Tod theoretisch möglich, jedoch nicht durch Alter oder gewöhnliche Waffen. Konkrete außergewöhnliche Todesursachen und Verwundbarkeit sind noch offen. Die alte 230-jährige Biografie gilt nicht länger als objektive Autorenwahrheit.
- **Autorität:** Sie respektiert Night Mother und Listener. Ihre über Fraktionen hinausreichende Treue verleiht ihr keinen Rang innerhalb der Brotherhood; die angebotene Zusammenarbeit lässt die Aufnahmeentscheidungen beim Listener.
- **Mögliche Vergangenheit, nicht beschlossen:** Frühere Hilfe für die Morag Tong und ein Treffen mit der lebenden späteren Night Mother. Keine Behauptung, sie sei Sithis' allererste Dienerin oder eines der fünf Kinder aus der Gründungslegende.
- **Kanon/Enthüllung:** Göttliche Herkunft ist unsere Mod-Ergänzung, keine belegte TES-Tatsache. Was Spieler und Figuren davon erfahren, bleibt offen. Entstehungsweise und Mutter ebenfalls offen.
- **Verbindliches Autorenprofil:** `docs/concept/Veyra-Autorenprofil.md`; Hauptkonzept Abschnitt 3 angepasst. Frühere Empfehlung einer gebundenen Nachleserin in `docs/lore/Veyra-Sithis-Chronologie.md` ist als Entwurf vor dieser Entscheidung überholt.
- **Umsetzungsstand:** Konzeptentscheidung dokumentiert; betroffene Dialog-/Buchstellen im Autorenprofil aufgelistet. CSV, ESP, Schutzflags und Scripts noch nicht angepasst. Vor Plugin-Übernahme des Dialogausbaus gegen E23 abgleichen. E02 für die übrigen Rekruten bleibt offen.

### E22 – Standoff: Nachfragen vor der Entscheidung

- **Datum:** 26.09.2026
- **Entschieden von:** Entwickler, ausdrücklich auf die Rückfrage zum Dialogausbau.
- **Entscheidung:** Informationsfragen und Nachfragen dürfen nacheinander gestellt werden. Erst eine ausdrückliche Abschlusswahl beendet die Befragung. Auch das Senken von Nazirs Klinge lässt die Befragung offen.
- **Abschlusswege:** Night Mother befragen (`010_127` → `010_70–73`), vorhandene Drohung (`010_50–52` → `010_70–73`) oder Verweisung (`010_60–62`). Alle führen weiterhin über Stage 15 zum vorhandenen Windpeak-/Night-Mother-Ablauf.
- **Folgen:** `dialogue/Q00.csv` um sechs vertiefende Gesprächsketten ergänzt; automatische Verbindungen von Informationsfragen zur Abschlusskette beim Plugin-Einbau entfernen. Keine neuen Quest-Stages, keine neue Angriffs- oder Überredungsmechanik. Gespräch abbrechen verändert Stage 10 nicht.
- **Umsetzungsstand:** Text und Einbauplan vorhanden; ESP, Fragmente und stille Sprachdateien noch nicht angepasst. Zusätzliche allgemeine Gespräche stehen in `dialogue/Sanctuary.csv`, ab Q00 Stage 100.


### E21 – Technik für unvertonte Zeilen

- **Datum:** 25.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Ohne Sprachdatei zeigt Skyrim eine Antwort nur für einen Sekundenbruchteil, und Szenen-Zeilen werden gar nicht abgespielt (Standoff-Szene lief „leer“, Test 25.09.2026). Fuz Ro D-oh löst das zur Laufzeit, wäre aber eine neue harte Abhängigkeit (Regel 5).
- **Optionen:** A stille Sprachdateien je Zeile mitliefern, B Fuz Ro D-oh voraussetzen.
- **Entscheidung:** A. `tools/silent_voice.py` erzeugt aus `plugin-text/` je NPC-Antwort eine stille `.fuz` (xWMA, ohne Lip-Daten; Dauer = Wörter / 2,5 + 1 s, mindestens 2 s) unter `Data/Sound/Voice/NightsHarvest.esp/<VoiceType>/`. Dateiname nach Engine-Schema `<Quest>_<Topic>_<00+INFO-ID>_<Antwortnummer>`, Quest- und Topic-EditorID zusammen auf 25 Zeichen gekürzt (ohne Topic-EditorID behält die Quest bis zu 25, sonst Quest 10 + Topic 15; aus allen Namen in `Skyrim - Voices_en0.bsa` abgeleitet, 25.09.2026 – die verbreitete „10 + 15“-Regel und houseCARLs Prüfung liegen bei Szenen-Zeilen falsch). Die Dateien sind Build-Artefakte (nicht im Git), `sync_dev.ps1` kopiert sie in die Dev-Kopie, `package.ps1` packt sie unkomprimiert ins BSA.
- **Folgen:** Jede INFO mit NPC-Text braucht einen eindeutigen Sprecher (Speaker oder `GetIsID`) und Antwortnummern ab 1, sonst meldet das Tool einen Fehler. Echte Aufnahmen (E10/E11, Voice-Pack) ersetzen die Dateien später; das Tool überschreibt nur Dateien aus seinem eigenen Manifest. E10 (Vertonung zum Release) bleibt davon unberührt offen.

### E19 – MCM-Texte: Übersetzungsschlüssel in v0.0.1

- **Datum:** 22.09.2026
- **Entschieden von:** Claude (Umsetzungsdetail, keine Design-Abweichung – zur Nachvollziehbarkeit dokumentiert)
- **Kontext:** Konzept Abschnitt 16 sieht `$NHV_*`-Übersetzungsschlüssel für alle MCM-Texte vor (`Interface/Translations/NightsHarvest_ENGLISH.txt`, UTF-16 LE mit BOM), damit das MCM übersetzbar ist. Beim Bau von `NHV_MCMScript` (M1.1, Seiten Status/General) fiel im `papyrus-reviewer` auf, dass die Texte als englische Literal-Strings stehen, nicht als Keys.
- **Optionen:** A: Jetzt auf `$NHV_MCM_*`-Keys umstellen und die Translations-Datei parallel anlegen. B: Für v0.0.1/M1.1 bei Literal-Strings bleiben, Umstellung erst mit dem restlichen Lokalisierungs-Fahrplan in M6 (Polish).
- **Entscheidung:** B – vorerst Literal-Strings. Lokalisierung ist laut Roadmap ohnehin erst ab M6 vorgesehen (Voice-Pack v1.1), eine halbfertige Key-Infrastruktur jetzt wäre ungetestet und zusätzlicher Pflegeaufwand pro neuer MCM-Seite (M1.6+) ohne aktuellen Nutzen.
- **Folgen:** Alle MCM-Texte bleiben bis M6 englische Literale. Vor M6: `Interface/Translations/NightsHarvest_ENGLISH.txt` anlegen und alle `AddXOption*`/`SetInfoText`/`SetTitleText`-Aufrufe in `NHV_MCMScript.psc` (und späteren MCM-Erweiterungen) auf `$NHV_MCM_*`-Keys umstellen. Betrifft M1.1 (jetzt), M1.6/M2/M3/M4 (weitere MCM-Seiten), M6.1 (MCM komplett).

### E06 – MCM-Technik (Bestätigung aus Konzept Abschnitt 16)

- **Datum:** 22.09.2026
- **Entschieden von:** Konzept (Abschnitt 16, bereits vor dieser Session festgelegt), hier nur in die Entscheidungs-Tabelle nachgetragen
- **Kontext:** Tabellen-Zeile stand auf „Offen", obwohl Konzept Abschnitt 16 bereits eindeutig sagt: „Das MCM basiert direkt auf SkyUI (`SKI_ConfigBase`), ohne zusätzliche Abhängigkeit wie MCM Helper." `NHV_MCMScript` (M1.1) ist entsprechend gebaut.
- **Optionen:** A: SkyUI direkt (`SKI_ConfigBase`). B: MCM Helper (zusätzliche Abhängigkeit).
- **Entscheidung:** A, SkyUI direkt – keine neue harte Abhängigkeit über SkyUI hinaus (Regel 5).
- **Folgen:** Keine; nur Status-Korrektur, Umsetzung war bereits konzeptkonform.

Neue Einträge oben anfügen, mit folgender Vorlage:

```markdown
### E<Nr> – <Titel>

- **Datum:** TT.MM.JJJJ
- **Entschieden von:** Entwickler
- **Kontext:** Warum die Frage aufkam (1–3 Sätze)
- **Optionen:** A …, B …
- **Entscheidung:** …
- **Folgen:** Was sich in Code, Records, Doku ändert; betroffene Arbeitspakete
```

### E16 – Zugang Deep Sanctuary

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Jede Referenz in einer Vanilla-Zelle zieht eine Kopie des Zell-Records ins Plugin, die Änderungen anderer Mods an derselben Zelle überdecken kann. `docs/TOOLING.md` (Abschnitt 6) listet `Sanctuary Reborn.esp` als aktives Mod mit hohem Konfliktrisiko für genau diese Zelle.
- **Optionen:** A Load Door mit Zell-Kopie (einfacher im CK), B Script-Tür per `PlaceAtMe` + `MoveTo` (kein Zell-Override).
- **Entscheidung:** B. Vor Q00 ist an der Wandstelle nur ein Geröll-Activator sichtbar; in Q00 Szene 4 tauscht ein Enable-Parent den Activator gegen eine per Script platzierte Tür, die per `MoveTo` in die Deep Sanctuary führt. Keine Referenz wird in der Vanilla-Sanctuary-Zelle neu angelegt.
- **Folgen:** `docs/ARCHITECTURE.md` (Zell-Kopien-Tabelle bleibt leer), CK-Anleitung für M1.3 muss die Script-Tür statt einer normalen Load Door beschreiben. Betrifft M1.3 (Deep Sanctuary Stufe 1) und M1.5 (Q00 Szene 4).

### E09 – Pathing Vanilla-Sanctuary

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Folgt aus E16 (Script-Tür statt Load Door): Ohne echte Türverbindung gibt es auch keine Navmesh-Kante zwischen den Zellen.
- **Optionen:** A Navmesh-Verknüpfung (echtes Gehen durch die Tür), B `MoveTo` ohne Navmesh-Edit.
- **Entscheidung:** B für v1.0, wie im Konzept vorgesehen. Follower folgen dem Spieler wie gewohnt über die Script-Tür (Catch-up-Teleport des Follower-Systems, M1.6/M2.1), NPC-Packages bleiben im jeweils eigenen Flügel. Option A für v1.1 offen zu prüfen, falls echtes Pendeln gewünscht wird.
- **Folgen:** Keine Navmesh-Änderungen an der Vanilla-Sanctuary-Zelle. Betrifft M1.3 und das Follower-System (M1.6).

### E14 – Standard-Wartezeit bis Q00

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** `NHV_Cfg_StartDelay` braucht einen Startwert zwischen 0 und 7 Tagen nach „Hail Sithis!“.
- **Optionen:** 0–7 Tage, Konzept-Empfehlung 2 Tage.
- **Entscheidung:** 2 Tage, per MCM änderbar.
- **Folgen:** `NHV_Cfg_StartDelay` wird mit Standardwert 2.0 angelegt (M1.1).

### E18 – Status getöteter Rekruten

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Konzept Abschnitt 5 definiert die Werte 0 = unbekannt, 1 = rekrutiert, 2 = getötet, 3 = freigelassen, 4 = Sonderfall (ausgeliefert, verhaftet). Zwei Stellen (Script-Tabelle, Break-Test BT07) nannten für den Tod Status 4.
- **Optionen:** A Status 2 für den Tod, B Status 4.
- **Entscheidung:** A. Tod = 2, Verhaftung und Auslieferung (Q04) = 4.
- **Folgen:** `docs/concept/konzept.md` an den zwei Stellen korrigiert (Export). Das Claude Doc muss der Entwickler ebenfalls anpassen, sonst überschreibt ein neuer Export die Korrektur. Betrifft `NHV_RecruitAliasScript`, `NHV_ContractBaseScript` (M1.6, M1.7) und BT07.

### E17 – ESP-Bearbeitung durch Claude

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Ohne eigene Bearbeitung des ESP wäre der Entwickler der Engpass für Globals, Fraktionen, Quests, Aliase, Packages und Dialog-INFOs. Es gibt MCP-Server und Spriggit (Text → ESP), mit denen Claude Plugins ohne Creation Kit lesen und schreiben kann (`docs/TOOLING.md`, Abschnitt 4).
- **Optionen:** A nur CK, B Claude bearbeitet das ESP (MCP oder Spriggit), Entwickler übernimmt nur den räumlichen Teil im CK.
- **Entscheidung:** B, mit Ein-Schreiber-Regel: CK und Claude bearbeiten das ESP nie gleichzeitig. Nach jedem Eingriff von Claude öffnet der Entwickler das ESP einmal im CK und speichert es, bevor er weiterarbeitet. Zellbau, Platzierung, Navmesh, Beleuchtung, Room Bounds, FaceGen, Lip-Sync und der Ingame-Test bleiben beim Entwickler. Regel 6 (nichts als ingame funktionierend melden) gilt unverändert.
- **Umsetzung:** Zuerst Spriggit (`convert-to-plugin`, Mutagen-Projekt). Ein MCP-Server wird erst nach Prüfung des Quelltexts und ausdrücklicher Freigabe installiert, weil er fremden Code mit Dateizugriff ausführt.
- **Folgen:** `CLAUDE.md` (Regel 7), `docs/ENVIRONMENT.md`, `docs/TOOLING.md`, `README.md` und die Skill `ck-guide` angepasst. Betrifft alle Pakete mit Records ab M0.6; die Spalte „Wer“ in `docs/ROADMAP.md` gilt weiter als Richtwert.

### E05 – Master-Dateien

- **Datum:** 22.09.2026
- **Entschieden von:** Entwickler
- **Kontext:** Jeder zusätzliche Master (Dawnguard, Dragonborn) macht den Mod von dem DLC abhängig und lässt sich nicht mehr entfernen.
- **Optionen:** A nur `Skyrim.esm` und `Update.esm`, B zusätzlich Dawnguard und Dragonborn.
- **Entscheidung:** A. DLC-Inhalte nur weich über `Game.GetFormFromFile()`.
- **Folgen:** `NightsHarvest.esp` hat genau die Master `Skyrim.esm` und `Update.esm`. Betrifft M0.6 und alle Records, die DLC-Formen brauchen (z. B. Vampire-Lord-Erkennung).

### E20 – Startbedingung Q00

- **Datum:** 25.09.2026
- **Entschieden von:** Entwickler (Vorschlag), Claude (Umsetzung)
- **Kontext:** Ein Sprung mit `setstage DB11 200` überspringt den Umzug nach Dawnstar und alle Weltzustände (Falkreath-Sanctuary bleibt bestehen, Astrid lebt, Nazir/Babette/Cicero fehlen in Dawnstar, Black Door fragt das Passwort). Auch im regulären Spiel beginnt die Sanctuary-Nutzung erst mit `DBrecurring` „The Dark Brotherhood Forever“.
- **Optionen:** A nach „Hail Sithis!“ (bisher), B nach Start von `DBrecurring`.
- **Entscheidung:** B. `NHV_CoreScript.CanStartQ00()` verlangt zusätzlich, dass `DBrecurring` läuft, abgeschlossen ist oder Stage > 0 hat. Die Wartezeit (E14) zählt ab diesem Zeitpunkt; Q00 startet beim nächsten Betreten der Dawnstar Sanctuary.
- **Folgen:** Konzept Abschnitt 2 (Startbedingungen) ist anzupassen. Zum Testen entweder DB regulär spielen (Save nach `DBrecurring` aufheben) oder Q00 per `cqf NHV_Sys_Core StartQ00` aus der Sanctuary heraus starten.
