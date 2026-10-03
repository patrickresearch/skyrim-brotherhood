# Q02 Cold Waters: Todes-Fallbacks (Stand 03.10.2026)

Auftrag: Entwickler-Feedback "Allgemeine Fallbacks, wenn ein Charakter stirbt, bevor seine Dialoge enden". **Nichts ist ingame getestet.** Das ESP wurde nicht geschrieben (kein `ToPlugin` ins echte ESP, kein Sync), es gab keinen Commit, `build_q02_enhanced.py` lief nicht. Basis ist der `plugin-text/`-Export des CK-gespeicherten ESP (Lehre 1).

## 1. Befund Essential/Protected

In keinem der NPC-Records (4107–410C, AF10, AF11) steht `Essential` oder `Protected` (nur `Unique`, bei AF10/AF11 nicht einmal das). Einziger Schutz: die Quest-Aliase **TorbjornAlias (3)** und **HjoraldAlias (7)** sind `Protected` (nur der Spieler kann sie töten, andere nur bewusstlos schlagen). Alle anderen sind sterblich, auch durch NPCs. Der Entwickler hat gesagt: jeder Tod kann auch durch den Spieler passieren, also gelten alle Fälle unten für Spielertötungen.

## 2. Tabelle NPC × kritischer Dialog × Fallback

| NPC | Kritischer Dialog (Alias/Stage) | Folge ohne Fallback | Item (Base-Inventar, lootbar) | Handler (`NHV_Q02Script`) |
|---|---|---|---|---|
| Torbjorn (3, Ref 5191) | Stage 10: Brückenzeile 10_4091 setzt Stage 15; Stage 20: Körpergespräch 20_4095 setzt Stage 30 | **Softlock** bei 10 und 20 | `NHV_Note_Fallback_Torbjorn` 0xAF70 | `DeathTick`: Stage 10 + tot → `SetStage(15)`; Stage 20 + tot → `SetStage(30)`; je ein Hinweis |
| Hjorald (7, Ref 5194) | Stage 15: Schlüsselgespräch 15_4093–4204, Ledger-Bericht 15_4094 setzt Stage 20 | **Softlock** bei 15 | `NHV_Note_Fallback_Hjorald` 0xAF74 | `DeathTick`: Stage 15 + tot → Ledger per Skript (`GiveTidehouseLedgerFallback`, einmal, teilt `bLedgerGiven`) und `SetStage(20)` |
| Haldor (5, Ref 5195) | Stage 30: Nachtszene 004125 (Szene braucht ihn) | Szene startet mit totem Alias; nur der Szenen-Watch rettet es (3 Ticks Wartezeit, ungeplant) | `NHV_Note_Fallback_Haldor` 0xAF72 | `StartHaldorDocksScene`: Haldor tot → Szene überspringen, `EndHaldorDocksScene()` (Pfad "keiner greift ein", Stage 40, Beschattung). Sings tot → `HandleSingsDead()` |
| Drinks (4, Ref 5192) | Stage 10: Hub (Hitch-Hinweis, nicht gating); Stage 45: Salzplatz-Hub (Sluice-Hinweis) | kein Softlock: die Hollow-Tür akzeptiert Stage 40–45 | `NHV_Note_Fallback_Drinks` 0xAF71 | `DeathTick`: Stage 45 + tot → einmaliger Hinweis (Sluice hinter den Salzkisten) |
| Sings (2, Ref 5190) | Stage 30 (Nachtszene), Stage 50 (Geständnis, Hub), 55, 70 (Urteil) | **Softlock** bei 30–50 (Teilfall 55/60/70 war schon behandelt) | `NHV_Note_Fallback_SingsBeneathIce` 0xAF77 | `DeathTick` ab Stage 10: tot → `HandleSingsDead()` (Ergebnis "killed", Result 2, `SetStage(100)`, Debrief-Zweig "Sings is dead" bei Veyra, E51). Das schon vorhandene `RecruitDied`-Override bleibt |
| Aelius (6, Ref 5953) | Stage 55: Beobachtung 55_4402/4403; Stage 60: Kill-Szene | Tod gehört zur Quest, **kein Handler nötig**: `ObsTick` → `FinishObservationWithoutScene`, `UpdateKillWatch`/`StartAeliusKillScene` → Stage 70 mit `SingsUnproven` (Spieler) oder `AeliusFallback` | `NHV_Note_Fallback_Aelius` 0xAF73 (gibt die "Güte" der verpassten Beobachtung) | keiner neu |
| Dock Enforcer (8, AF10, Klon) | Stage 15 Hello 15_4210–4212; Stage 45 Salzplatz 35_4302/4304 | kein Softlock (das Ledger liegt als Buch in der Zelle; Tür und Hollow offen) | `NHV_Note_Fallback_DockEnforcer` 0xAF75, **nicht im Klon-Base** (bis zu 5 Kopien), sondern per Skript auf **eine** Leiche, wenn sie vor dem Gespräch stirbt | `DeathTick`: `GiveEnforcerNote()` bei Stage 15 (nicht `bTideTalked`) und Stage 45 (nicht `bSaltTalked`); die Flags setzen `TidehouseHostile`/`SaltYardHostile`/`SaltYardSlip` |
| Imperial Courier (9, AF11) | Stage 70: Begegnung 70_4500–4505, Ende setzt `courierInterrupted` und startet die Listenszene | kein Softlock (Urteils-Hub ist ab Stage 70 bewaffnet), aber die Listenszene fehlt; vor dem Start war es schon behandelt | `NHV_Note_Fallback_Courier` 0xAF76 | `DeathTick`: Stage 70 + `bCourierStarted` + tot + Flow-Flag nicht gesetzt → Flag setzen, Objective 71 abschließen, `DelayScene(FLOW_SCENE_LIST, 2.0)` |

Haldor ab Stage 45 deaktiviert, ab 100 aktiv (E59): `HideHaldor`/`ShowHaldor` prüfen `IsDead()` und lassen Leichen liegen. Ein Haldor, der nach der Rettung stirbt, bleibt am Kai liegen, Stage 45 läuft normal weiter. E51 (Debrief nur bei Veyra) bleibt unberührt, Sings' Tod endet im bestehenden Debrief-Zweig. E53/E54/E55/E56 sind nicht berührt: kein neuer Ausgang, Mord am Kurier bleibt unbelohnt (kein Kopfgeld eingebaut), das Fragment kommt weiter über `GiveFragmentDebrief`.

## 3. Technik

* **Ein Timer (Lehre 9):** neue Variable `bDeathWatch`; `RearmWatches()` bucht den Poll (`DEATH_POLL_INTERVAL` = 8 s) nur, wenn kein älterer Watch (`iWatchMode`) und keine Cutscene den Timer besitzen. Die älteren Watches rufen `RunPendingWork()` bei jedem Tick selbst, dort hängt `DeathTick()`.
* **Anschluss ohne Fragment-Änderung:** `PatchStageActivators()` (ruft Fragment 10/15/20/30/45 und `RearmAfterLoad()` bei Stage 10–99) ruft am Ende `ArmDeathWatch()`. Das ist der Wiederanlauf nach jedem Laden. Ab Stage 100 schaltet sich der Watch selbst ab.
* **Getter mit FormID-Rückfall (Lehre 6):** `IsNpcDead(alias, refID)` über `ResolveActor(..., False)`: keine Nebenwirkung (kein Enable, kein Refill).
* **Kaskade:** ein Poll kann 10 → 15 → 20 → 30 nacheinander setzen, wenn Torbjorn und Hjorald beide tot sind.
* Notizen im Base-Inventar werden bei jedem Tod gelootet, auch im normalen Verlauf (z. B. Aelius nach der Kill-Szene); das ist gewollt (Welt-Flavour).
* **Save-Regel 3:** nur neue Variablen/Properties/Funktionen (`bDeathWatch`, `bTideTalked`, `bSaltTalked`, `bEnforcerNoteGiven`, `bDrinksNoted`, `DEATH_POLL_INTERVAL`, `NOTE_ENFORCER`, `NOTE_LEDGER`, `IsNpcDead`, `ArmDeathWatch`, `DeathTick`, `GiveTidehouseLedgerFallback`, `GiveEnforcerNote`); geändert nur additiv: `RearmWatches`, `RunPendingWork`, `PatchStageActivators`, `StartHaldorDocksScene`, `TidehouseHostile`, `SaltYardHostile`, `SaltYardSlip`. Keine Quest-VMAD-Änderung (keine neuen Properties am Quest-Script gebunden: die Notizen werden über FormID aufgelöst).
* Journal-Hinweis: bei den Stage-Sprüngen liefert der Journal-Text der Zielstage den Hinweis (5201, 5003/5004, 5005, 5007); die Zwischen-Texte sind kurze `Debug.Notification`-Zeilen (Abschnitt 6). Neue Stages für eigene Journaltexte habe ich bewusst nicht angelegt (Stage-Bereichsbedingungen der Dialoge und Packages würden brechen).

## 4. FormIDs (Bereich 0xAF70–0xAFBF, frei bis auf diese acht, Kollisionsprüfung gegen `plugin-text/` bestanden)

| FormID | EditorID | Anzeigename | im Inventar von |
|---|---|---|---|
| 0xAF70 | `NHV_Note_Fallback_Torbjorn` | Harbor Slate | Torbjorn 004108 |
| 0xAF71 | `NHV_Note_Fallback_Drinks` | Net Tally | Drinks 004109 |
| 0xAF72 | `NHV_Note_Fallback_Haldor` | Crumpled Dock Roster | Haldor 00410A |
| 0xAF73 | `NHV_Note_Fallback_Aelius` | Clerk's Pocket Ledger | Aelius 00410B |
| 0xAF74 | `NHV_Note_Fallback_Hjorald` | Watch Key Tag | Hjorald 00410C |
| 0xAF75 | `NHV_Note_Fallback_DockEnforcer` | Watch Orders Slip | (Skript, eine Leiche) |
| 0xAF76 | `NHV_Note_Fallback_Courier` | Sealed Order | Courier 00AF11 |
| 0xAF77 | `NHV_Note_Fallback_SingsBeneathIce` | Scratched Slate | Sings 004107 |

Frei bleiben 0xAF78–0xAFBF. Die Bücher haben Modell `JournalLowPoly01.nif` wie die anderen Notizen (Vorlage CipherKey, per Hand erzeugt, ohne den Generator).

## 5. Geänderte Dateien

`Data/Source/Scripts/NHV_Q02Script.psc` (kompiliert fehlerfrei: `tools/build.ps1` lief ohne Execution-Policy-Problem, Pyro "succeeded, 0 failed"); `dialogue/Books.csv` (8 Zeilen, LineIDs `NHV_Q02_010_6400`, `015_6401`, `030_6402`, `045_6403`, `050_6404`, `055_6405`, `070_6406`, `015_6407`: je größer als alle Nummern des Stage-Präfixes in Q02.csv, Journal.csv, Books.csv; Datei war vorher unversioniert); `plugin-text/Books/NHV_Note_Fallback_*` (8 neue Dateien); `plugin-text/Npcs/` 004107, 004108, 004109, 00410A, 00410B, 00410C, 00AF11 (nur `Items:` additiv). Prüfungen: `dialogue_lint.py` 0 Fehler, 6 alte Warnungen (nichts Neues); Spriggit `convert-to-plugin` in ein Temp-ESP im Scratchpad: erfolgreich; alle 8 FormKeys definiert, 0 offene Links. `silent_voice.py` nicht nötig (nur Bücher, keine Sprachzeilen).

## 6. Neue Texte zur Prüfung durch `lore-editor`

Notizen (Zeilen in `dialogue/Books.csv`, Titel in Großbuchstaben, 2 Absätze, 4 Sätze):

1. **Harbor Slate** (010_6400): "TORBJORN ICE-VEIN — HARBOR SLATE" / "Five bodies since the thaw, all Nords, all bound with the same hitch. Complaints are on file against Haldor Frost-Knuckle and his night crew, but a complaint is not a verdict." / "Sergeant Hjorald holds the key to the sealed tidehouse, where the watch log lies. Ask what the night shift saw after the late bell."
2. **Watch Key Tag** (015_6401): "TIDEHOUSE KEY — SERGEANT HJORALD" / "Tidehouse sealed after the fourth body. The log stays inside, and nobody takes it out." / "The log records late shifts, missing names, and Aelius Varro's neat corrections. It shows a pattern, not a killer."
3. **Crumpled Dock Roster** (030_6402): "NIGHT CREW ROSTER — H. FROST-KNUCKLE" / "East pier after the late bell: four men on the roster, one short again. Something splashes under the planks most nights, and the lads will not stand at the end of the pier alone." / "Anyone who loses a knife finds me at the salt yard. If the guards ask, the crew saw nothing."
4. **Net Tally** (045_6403): "DRINKS-THE-BRINE — NET TALLY" / "Knots counted by the dozen, nothing else written. The hitch on the dead men is a marsh hitch, learned where the reeds grow, not on a Nord's boat." / "The old sluice lies behind the salt bins. Haldor's friends watch the yard, so keep low and do not follow the street."
5. **Scratched Slate** (050_6404): "SINGS-BENEATH-ICE — NAMES ON THE SLATE" / "A slate scratched with names. Five are crossed out, the men who laughed when we were hurt. One is not: Aelius Varro, the harbor clerk, who paid fair and learned our names." / "Beneath it, in a clumsy hand: Fear has been a poor teacher."
6. **Clerk's Pocket Ledger** (055_6405): "A. VARRO — HARBOR CLERK" / "Argonian net crew to the dry shift; their hands are split to the bone. No man loses pay because a clerk prefers a clean ledger." / "I keep their names so I can send word when a body comes up. The northern desk asks for more than a clerk should keep, and I answer what is asked."
7. **Sealed Order** (070_6406): "EASTERN WATCH — ORDER OF SEALING" / "By order of the eastern watch, the desk of the harbor clerk is sealed upon his death. His papers are to be collected under escort and forwarded to the northern desk." / "No person outside the roster may handle them."
8. **Watch Orders Slip** (015_6407): "TIDEHOUSE AND SALT YARD — WATCH ORDERS" / "The tidehouse stays shut, and the log does not leave it. Haldor's friends hold the salt yard until his knife turns up." / "Aelius Varro keeps the shift tallies; we keep the dead, and nobody mixes the two. Anyone asking questions is turned around at the door."

Hinweiszeilen (`Debug.Notification` im Script, nicht in der CSV, wie die bestehenden Tisch-Hinweise):

* "Torbjorn is dead. His harbor slate points to the sealed tidehouse."
* "Sergeant Hjorald is dead. His key tag still opens the tidehouse log."
* "Torbjorn is dead. Haldor's night crew may still talk at the east pier after the late bell."
* "Drinks-the-Brine is dead. The sluice should still lie behind the salt bins."

LORE-CHECKs für den Lektor: (a) Die Notiz 6 deutet das Oculatus-Netz vor der Enthüllung nur an; ist "the northern desk" in Stage 55 zu früh? (b) Notiz 5 benennt die fünf Opfer nicht; passt "five" zu den fünf Leichen aus Torbjorns Zeile? (c) Notiz 2 und 8 widersprechen dem späteren Hjorald-Text nicht ("Sergeant" ohne Namen im Enforcer-Zettel). (d) Notiz 4 sagt "learned where the reeds grow": deckt sich mit 10_4019 (marsh hitch).

## 7. CK-Aufgaben

Reihenfolge: ESP öffnen und speichern (E17), `plugin-text` zurückspielen **vor** dem CK nur nach dem Probelauf, danach:

| # | Aufgabe |
|---|---|
| K1 | Bücher 0xAF70–0xAF77 laden ohne Warnung (Name, Text, Modell). Optional: Wert/Gewicht und Inventarbild anpassen. |
| K2 | Torbjorn, Drinks, Haldor, Aelius, Hjorald, Sings, Courier: Tab "Inventory" zeigt je eine Notiz (Anzahl 1). |
| K3 | Kein weiterer CK-Schritt für den Handler nötig: keine neuen Quest-Properties. Wichtig bleibt K-Pflicht Ä1/Ä2 aus `Q02-Phase-B-Ergebnis.md` (Hollow-Tür/Leichen-Ref). |
| K4 | Optional: Enforcer-Refs `TidehouseEnforcerRefs`/`SaltYardEnforcerRefs` müssen gesetzt sein, sonst bekommt keine Leiche die Enforcer-Notiz (sie ist dann nur nice-to-have). |

## 8. Testschritte ohne `cqf` (Tod per Spielerangriff)

Save pro Fall vor dem Stage-Ziel; Debug-Log an (`set NHV_Cfg_Debug to 1`); Stage-Sprünge nur mit `setstage 004100 <n>`. Log-Zeilen kommen mit `DeathTick:`-Präfix zurück. Papyrus-Log mit aktuellem Zeitstempel (Lehre 13).

1. **Torbjorn bei Stage 10:** `setstage 004100 10`, Torbjorn töten. Erwartet binnen 8–10 s: Hinweis "Torbjorn is dead...", Quest steht auf 15, Journal "Secure the sealed tidehouse log.", Torbjorn trägt die Notiz "Harbor Slate" (looten).
2. **Hjorald bei Stage 15:** Stage 15, Hjorald töten (Protected: nur der Spieler kann das, ggf. mehrmals zuschlagen). Erwartet: Ledger im Inventar, Stage 20; mit lebendem Torbjorn weiter wie normal.
3. **Torbjorn bei Stage 20:** Stage 20, Torbjorn töten. Erwartet: Stage 30, Hinweis, Nachtwatch läuft (Zeit auf 22–04 Uhr warten, am Dock-Marker stehen).
4. **Beide tot (Kaskade):** Stage 10, Torbjorn und Hjorald vor dem ersten Poll töten oder nacheinander; Erwartet 10 → 15 → 20 → 30 ohne Haken (Log zeigt die drei `DeathTick`-Zeilen).
5. **Haldor vor der Nachtszene:** Stage 30 tagsüber, Haldor am Kai töten, dann nachts am Dock stehen. Erwartet: keine Szene, Log `Haldor is already dead, skipping the night scene`, Stage 40, Beschattung (`UpdateTailWatch`), Leiche trägt "Crumpled Dock Roster".
6. **Sings tot vor Stage 50:** Stage 40 (Sings erscheint, Initially Disabled nötig, sonst am Hafen), Sings töten. Erwartet: Result "killed", Stage 100, Veyra-Debrief mit dem Zweig "Sings is dead", Fragment einmalig im Debrief. Gegenprobe bei Stage 55/60/70 (alter Pfad `HandleSingsDead` aus den Watches).
7. **Drinks bei Stage 45:** `setstage 004100 45` (Haldor gerettet nötig: `HaldorSaved`-Global auf 1), Drinks töten. Erwartet: Hinweis, die Hollow-Tür bleibt benutzbar, Stage 50 erreichbar.
8. **Enforcer vor dem Gespräch:** Stage 15, einen Tidehouse-Enforcer aus der Ferne/schleichend töten, bevor er spricht. Erwartet: eine Leiche trägt "Watch Orders Slip"; Gegenprobe: normaler Ablauf (Gespräch, dann Kampf) lässt keine Notiz entstehen.
9. **Aelius früh tot:** Aelius bei Stage 10–50 töten, dann Stage 55 wählen. Erwartet: keine Beobachtungsszene, `FinishObservationWithoutScene`, Hub "authorize" erreichbar, später Stage 70 mit `AeliusFallback`/`SingsUnproven`; Leiche trägt "Clerk's Pocket Ledger".
10. **Kurier tot mitten in der Begegnung:** Stage 70, Pult öffnen, Kurier töten, bevor das Gespräch endet. Erwartet: Objective 71 abgeschlossen, Listenszene startet nach ca. 2 s, Urteil möglich.
11. **Laden:** Save mitten in Stage 15/20 mit totem Torbjorn/Hjorald laden, der Poll läuft ohne neuen Anstoß weiter (`RearmAfterLoad` → `PatchStageActivators` → `ArmDeathWatch`).

## 9. Offene Fragen

1. **Sprung statt Plünderung:** Der Stage-Sprung passiert sofort beim Tod, nicht erst, wenn der Spieler die Notiz liest oder aufnimmt (Lesen ließe sich nur über ein Alias-/Ref-Script abfangen). Reicht das, oder soll das Lesen/Looten der Notiz den Sprung auslösen?
2. **Hjorald-Fall überspringt die Enforcer-Begegnung** (Ledger per Skript). Gewollt? Alternative wäre, das Tidehouse-Buch nicht zu geben und nur auf das Buch in der Zelle zu verweisen (Gefahr: ohne gesetzte Zellen-Refs Softlock, Lehre 11).
3. **Kein Journal-Hinweis mit eigenem Text** bei Drinks, Enforcer, Courier und Aelius (nur Notification oder keiner). Eigene Journal-Einträge bräuchten neue Stages (Bereichsbedingungen!). Soll ich das über ein Journal-Topic ohne Stage lösen (z. B. Nachricht über `Debug.MessageBox`), oder genügt die Notification?
4. **Veyra, Babette** sind nicht Teil des Auftrags und haben keinen Handler; Veyra ist im Debrief die einzige Berichtsperson (E51): stirbt sie vor dem Bericht, ist `OpenMapTable()` nie erreichbar (Fallback "Show me the table." hängt an Veyra). Prüfung für Q01–Q06 insgesamt vorschlagen?
5. **Sings ohne Initially-Disabled-Flag (Ä4)** ist am Hafen angreifbar; mit dem Flag ist der Fall vor Stage 30 praktisch unmöglich. Ä4 bleibt Pflicht.
6. Heat-/Kopfgeld-Folgen bei Spielertötung (Torbjorn, Hjorald, Haldor sind Zivilisten/Wache): bewusst nicht eingebaut, Vanilla-Verbrechenssystem greift unverändert.

## 10. Nachtrag 03.10.2026: Review-Befunde und Entscheidungen

Entscheidungen des Entwicklers: Stage-Sprung sofort beim Tod ok, Hjorald-Fall (Ledger per Skript, Enforcer-Begegnung übersprungen) ok, nur Notifications ok, Veyra ohne Handler ok (Fragen 1–4 in Abschnitt 9 sind damit beantwortet). Eingearbeitet (`papyrus-reviewer`, alles additiv, Save-Regel 3 gewahrt, kompiliert fehlerfrei, Spriggit-Probelauf in ein Temp-ESP erfolgreich; nichts ingame getestet):

1. **`HandleSingsDead`:** Status und Result werden nur gesetzt, wenn der Status nicht schon Recruited/Released/Special ist (Stage 70 zwischen Urteil und `SetStage(100)`). Vor `SetStage(100)` stoppt `HaldorDocksScene`, falls sie läuft (Sings stirbt mitten in der Nachtszene).
2. **Quest-Reset:** neue Variable `iDeathHighStage`; `ArmDeathWatch()` setzt bei Stage 10 nach einer höheren Stage `bDrinksNoted`, `bEnforcerNoteGiven`, `bTideTalked`, `bSaltTalked` zurück. Neue Funktion `EnsureHaldorEnabled()` (Enable, falls disabled und nicht tot) in `BeginNightWatch()` und `StartHaldorDocksScene()`. Grenze: der Reset-Zeitpunkt wird nur an Arm- und Poll-Zeitpunkten erkannt (Fragmente 10/15/20/30/45, 8-s-Poll).
3. **`HideHaldor`:** `Disable(False)` statt latentem `Disable(True)` (blockiert sonst `RearmAfterLoad`/`RunPendingWork`/`RearmWatches` bis zum Ende der Überblendung). Andere `Disable(True)`-Stellen (Release, Surrender, Courier) unverändert; bei Bedarf gesondert prüfen.
4. **Notification-Zeilen** (Lektor): Hjorald "Sergeant Hjorald is dead. His key tag still opens the tidehouse log." und Torbjorn bei Stage 20 "Torbjorn is dead. Haldor's night crew may still talk at the east pier after the late bell."; übrige unverändert (auch in Abschnitt 6 aktualisiert).
5. Zusätzliche Testschritte: (a) Sings bei Stage 30 mitten in der Nachtszene töten: Szene stoppt, Stage 100, Result 2. (b) Stage 70, Urteil "Recruit" wählen und Sings in derselben Sekunde töten: Result bleibt 1, nicht 2. (c) Quest zurücksetzen (Stage 45 mit gerettetem Haldor → Reset → neu starten): Haldor sichtbar zur Nachtszene, Hinweis- und Enforcer-Notiz-Flags wieder frei.
