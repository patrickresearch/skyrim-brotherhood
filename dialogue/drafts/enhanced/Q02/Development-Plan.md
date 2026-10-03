# Q02 Enhanced – Entwicklungsplan und CK-Inventar

**Status:** Inaktiver Story- und Dialogentwurf. Keine Aussage über Ingame-Funktion.

## Neue oder zu prüfende Records

| EditorID-Vorschlag | Typ | Zweck |
|---|---|---|
| `NHV_Q02_TidehouseCell` | CELL | Eigener Innenraum für die versiegelte Akte; vermeidet unnötige Vanilla-Zellkopie |
| `NHV_Q02_SaltYardMarker` | XMarker/REFR | Orientierung zwischen Kai und Sluice |
| `NHV_Q02_SluiceEntrance` | XMarker/REFR | Landseitiger Zugang zur bestehenden oder neuen Hollow-Zelle |
| `NHV_Q02_DockEnforcer` | NPC/VoiceType | Generischer Tidehouse-/Salzplatz-Gegner |
| `NHV_Q02_ImperialCourier` | NPC/VoiceType | Kurierencounter nach Aelius’ Tod |
| `NHV_Q02_TidehouseLedger` | BOOK | Recherchefund; aktive Übergabe erst nach Auswahl der Fassung |
| `NHV_Q02_TidehouseRead` | GLOBAL | Tidehouse-Phase abgeschlossen |
| `NHV_Q02_SluiceFound` | GLOBAL | Salzplatzroute abgeschlossen |
| `NHV_Q02_AeliusObserved` | GLOBAL | Aelius-Beobachtung vor der Prüfung |
| `NHV_Q02_CourierInterrupted` | GLOBAL | Kurierencounter abgeschlossen |

## Umsetzungsreihenfolge

1. Globals, VoiceTypes und NPC-Platzhalter anlegen; keine Vanilla-NPCs ändern.
2. Tidehouse als eigene Innenzelle mit Ledger, zwei Enforcer-Referenzen und Hjorald-Alias vorbereiten.
3. Salzplatz nur in einer kontrollierten Q02-Zelle platzieren. Falls die Windhelm-Docks-Vanilla-Zelle verwendet werden müsste, zuerst Zellkopie und Kompatibilitätsrisiko in `docs/ARCHITECTURE.md` dokumentieren.
4. Sluice-Marker und Hollow-Zugang so setzen, dass beide Salzplatzwege am selben Übergang enden.
5. Aelius-Beobachtung als kurze Szene oder ForceGreet nach der Autorisierung bauen. Aelius’ Verhalten muss vor der Prüfung sichtbar sein.
6. Kurierencounter nach Aelius’ bestätigtem Tod starten; kein Spawn vor dem tatsächlichen Todeszustand.
7. CSV-Topics und INFOs aus `Q02.csv` verdrahten. Die Enhanced-Datei bleibt bis zur redaktionellen Freigabe getrennt vom aktiven Master.
8. Erst danach Packages, Szenen, Stage-Fragmente und Save-Migration planen. Neue Globals additiv anlegen; keine bestehenden Q02-Variablen umbenennen.

## Testfälle

- Tidehouse wird vor der Nachtwache abgeschlossen; ohne Ledger darf Stage 30 nicht starten.
- Haldor wird gerettet: Sings flieht, Salzplatz und Sluice bleiben erreichbar.
- Haldor stirbt: Sings’ Methode wird beobachtet, Salzplatz bleibt erreichbar.
- Salzplatz wird gewaltsam oder schleichend gelöst; beide Wege öffnen denselben Hollow-Zugang.
- Aelius’ Freundlichkeit ist vor seiner Prüfung sichtbar.
- Aelius stirbt durch Sings, Spieler, anderen Weltzustand oder bleibt aus einem gültigen Pfad offen; der Urteilsknoten bewertet den tatsächlichen Täter.
- Der Kurier erscheint erst nach Aelius’ Tod und verrät weder Livia noch den nördlichen Auftraggeber.
- Liste gesichert oder zurückgelassen; beide Wege führen zu einem konsistenten Veyra-Debrief.

**CK-Hinweis:** Die konkreten Zellkoordinaten, Navmesh-Kanten, FaceGen-Exporte und Packages bleiben Entwicklerarbeit im Creation Kit.

