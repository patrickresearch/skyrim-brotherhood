# Q00 „Zweifel“ und Luciens dauerhafte Gespräche

Stand: 29.09.2026. **Textlieferung; Dialog-Records und Audio noch nicht eingebaut, nicht ingame getestet.** Grundlage: Entwicklerauftrag vom 28.09., E23 und E35. Der vorhandene technische Vorbau steht in `docs/ck/M1.5-Q00-Zweifel-Lucien.md` und `NHV_CoreScript` v35.

## Lieferung

| Master | Neue IDs | Inhalt |
|---|---|---|
| `dialogue/Q00.csv` | `NHV_Q00_080_01–08` | Veyra beginnt; annehmen, höflich ablehnen, schroff ablehnen |
| `dialogue/Q00.csv` | `NHV_SYS_LUC_01–13` | Nachholen, gemeinsame Annahmeantwort, zwei Rufzeilen, zwei Ankunftszeilen, zwei Spielerprompts und fünf Bürgschaftsantworten |
| `dialogue/Lucien.csv` | `NHV_SYS_LUC_14–41` | Sieben Dauerthemen mit je einem Prompt und drei Antworten |
| `dialogue/Journal.csv` | `NHV_Q00_080_09` | Stage-80-Ziel und Log-Text |

50 neue Masterzeilen insgesamt. Bestehende Texte bleiben erhalten; nur die Anschluss-Notes von `NHV_Q00_060_63` und `NHV_Q00_100_01` ändern sich. `tools/dialogue_lint.py` kennt Lucien jetzt als Vanilla-Sprecher; die schon vorhandenen lokalen Änderungen an der Sprecherliste bleiben erhalten.

Die Dauerthemen behandeln Cheydinhal, das Speaker-Amt, Bellamonts Verrat und Luciens Mitverantwortung, seinen Dienst als Geist, Erwartungen an den Listener, Veyra und den Zusammenhalt der Familie. Sie benötigen keine Q01–Q06-Stage. Veyras Herkunft bleibt ungenannt; Lucien bestätigt ihre freiwillige Treue zu Sithis aus eigener Erfahrung.

## Zuordnung und Ablauf für den Einbau

Die Datei bestimmt nicht den Quest-Eigentümer: `Quest=Q00` gehört zu `NHV_Q00_ShadowAtTheDoor`, `Quest=Sanctuary` zu `NHV_Sys_Sanctuary`. Die gemeinsamen Zeilen stehen aus redaktionellen Gründen in Q00.csv, tragen aber System-IDs. Beim Import ausdrücklich nach der Quest-Spalte zuordnen; ein Import allein nach Dateiname wäre falsch.

1. Nach dem Contract Stage 80 erreichen; `VeyraDoubtTopic` am Core auf den vollständigen Topic-Record `NHV_Q00_Veyra_Doubt` setzen. Solange diese Property leer ist, überspringt der vorhandene Core den Dialog. Das Journal-Ziel aus `080_09` ersetzt den Platzhalter; das alte Objective 60 abschließen und Objective 80 anzeigen, bei Q00-Abschluss erledigen.
2. Veyra eröffnet mit `080_01–03`. Die drei Spielerwahlen müssen gleichzeitig sichtbar sein; wie bei den vorhandenen Q00-Wahlen separate Branches verwenden. Ein Abbruch entscheidet nichts; erneutes Ansprechen muss die Auswahl anbieten.
3. Beide Annahme-Einstiege (`080_04` und `SYS_LUC_01`) verlinken **dieselbe** Antwort `SYS_LUC_02`. Danach die Rufzeilen `03–04` vollständig und nacheinander abspielen. Erst am Ende von `04`: bei Q00 Stage 80 vorhandenes `OnDoubtAccepted`, beim Nachholen vorhandenes `OnDoubtRetryAccepted` verwenden. Das erste beendet Q00, gibt das Ledger, startet Q01 und ruft Lucien; das zweite ruft nur Lucien. Keine neuen Abschlussfunktionen oder Globals nötig.
4. Beide Ablehnungen rufen erst nach ihrer NPC-Antwort (`080_06` bzw. `080_08`) das vorhandene `OnDoubtDeclined` auf. Q01 startet auf allen Wegen einmalig. Späteres Nachholen ist bei Veyra in der Deep Sanctuary verfügbar, solange `NHV_Q00_LucienSummoned == 0`.
5. Nach erfolgreichem Erscheinen `SYS_LUC_05–06` in Reihenfolge spielen; keine Wiederholung beim Laden. Danach `Lucien_Vouch` anbieten, mit Abschlusszweig `Lucien_VouchEnd`. Dieses Gespräch hat keine Stage-Folgen: Q00 ist bereits abgeschlossen. Es kann ebenso nach späterem Ruf geführt werden.
6. Dauerthemen `14–41` und Bürgschaft liegen auf `NHV_Sys_Sanctuary`, mit Alias `Lucien` und dem vorhandenen Global `NHV_Q00_LucienSummoned` (004403). Kein zusätzlicher `Vouched`-Zustand. Alle Gespräche sind wiederholbar; sie dürfen keine Quests neu starten.

Für Annahme und Ruf eine geordnete Szene/INFO-Kette verwenden. Zwei unmittelbar aufeinander folgende `Say`-Aufrufe garantieren keinen vollständigen Ablauf. Die hier beschriebene Dialogverdrahtung ist noch zu implementieren; CSV-Notes führen keine Aktionen aus. Bei Abbruch vor dem Erscheinen muss der Annahmepfad erneut erreichbar bleiben. Die bestehende einmalige Lucien-Referenz weiterverwenden, keinen zweiten Geist erzeugen. Den Sanctuary-Alias in bereits laufenden Saves ausdrücklich prüfen: neue Aliase werden dort nicht automatisch neu gefüllt.

**Vorhandene Records:** `NHV_LucienSpirit` (004400), `NHV_Ref_Sys_Lucien` (004401), `NHV_Mk_Sys_LucienSpot` (004402), Global (004403), `NHV_Pkg_Sys_LucienStand` (004404), Sanctuary-Alias `Lucien` (4), Q00 Stage 80. Neu einzubauen sind die Dialog-Branches/Topics/INFOs, geordnete Ruf-/Ankunftssequenz und das Objective. Keine neuen NPCs, Vanilla-Overrides oder Raumänderungen für diese Textlieferung.

## Stimme und Lore-Abgleich

Veyra: `NHV_VoiceVeyra`, ElevenLabs; ruhig, präzise, ohne verletzte Eitelkeit. Lucien: CSV `Vanilla`, tatsächlicher VoiceType `MaleUniqueDBSpectralLachance`; xVASynth, falls das passende Modell verfügbar ist. Modellbestand und Audio wurden nicht geprüft oder erzeugt. Bis zur Vertonung stille FUZ nach E21. Alle neuen NPC-Zeilen haben höchstens 25 Wörter, Spielerprompts höchstens 80 Zeichen.

Lucien als ehemaliger Speaker und heutiger Spectral Assassin: [Skyrim-Referenz](https://elderscrolls.fandom.com/wiki/Spectral_Assassin_(Skyrim)). Cheydinhal, Purification und Verrat: [Oblivion-Referenz](https://elderscrolls.fandom.com/wiki/Lucien_Lachance_(Oblivion)). Abruf 29.09.2026; UESP war mit HTTP 403 nicht erreichbar. Bekanntschaft mit Veyra und dauerhafter Aufenthalt sind die ausdrücklich beauftragte Mod-Erweiterung, keine Vanilla-Behauptungen. Keine Vanilla-Zeilen übernommen.

## Prüfung nach Einbau

Clean-Profil: echten Save **vor** dem Contract-Ende verwenden; keine abgeschlossene Q00 per Stage-Rücksprung zurücksetzen. Debug-Logging aktivieren.

| Test | Erwartung |
|---|---|
| Contract endet | Stage 80, Veyra beginnt; drei Optionen, neues Journalziel; Q01 noch nicht gestartet |
| Annehmen | Gemeinsame Antwort, beide Rufzeilen, dann Q00 100/Q01-Start und Luciens Ankunft; jede Zeile vollständig |
| Höflich/schroff ablehnen, jeweils frischer Ausgangssave | Eigene Antwort, Q00 100, Q01 startet; Lucien bleibt aus; Retry sichtbar |
| Retry während laufendem Q01 oder nach Q06 | Gleiche Annahmeantwort und Beschwörung; Q00/Q01–Q06 und Belohnungen bleiben unverändert; Retry verschwindet |
| Nie/zuvor Vanilla-Lucien beschworen; Ruf tagsüber/nachts | Begrüßung und Ruf passen in allen Fällen |
| Vouch und sieben Dauerthemen | Zwei Vouch-Prompts/fünf Antworten; je Dauerthema ein Prompt/drei Antworten; wiederholbar, keine Questfolgen |
| Abbruch, Zellwechsel, Speichern/Laden vor und nach Ruf | Keine verlorene Auswahl, keine doppelten Geister/Belohnungen; Lucien bleibt nach Ankunft verfügbar |
| Alter Save mit abgeschlossenem Q00 | Kein Rücksprung auf 80; späterer Ruf und Sanctuary-Alias funktionieren |

Vorhandene Log-Zeilen zurückmelden: `Q00 finished (stage 100)`, `Q01 started`, `Lucien summoned`; bei Ablehnung zusätzlich `Veyra's doubt declined, Lucien stays unsummoned`. Beim Retry kein erneuter Q01-Start. Ebenso Screenshot des Journalziels und Luciens sowie fehlende/abgeschnittene LineIDs melden. Der vorhandene Fallback nach drei unbeantworteten Spieltagen bleibt zu testen.

## Redaktionelle Prüfung

Dialog-Lint: 7 Dateien, 671 IDs, 0 Fehler; eine Warnung wegen des nicht installierten optionalen `pyspellchecker`. Ausgeführt mit dem vorhandenen Codex-Python, da `python` nicht im PATH liegt. `lore-editor`: keine offenen Lore-/E23-Befunde; CSV-Quoting und tageszeitneutrale Rufzeile korrigiert. Journalziel endet mit der Annahme/Ablehnung, bevor das freie Bürgschaftsgespräch beginnt.

Commit-Vorschlag: `[Q00] Zweifel-Nachgespräch und Luciens Sanctuary-Dialoge`
