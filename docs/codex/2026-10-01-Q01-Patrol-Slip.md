# Codex-Auftrag: Q01 – Imperial Patrol Slip (Farm-Clue zum alten Wachposten)

Stand: 01.10.2026. Ersetzt den Platzhaltertext in `dialogue/Books.csv`, Zeile `NHV_Q01_020_9107` (Spiegel in `dialogue/drafts/enhanced/Q01/Books.csv`).

## Wofür

- Q01, Stage 20 (Stormhollow-Farm, Innenzelle `NHV_StormhollowFarmCell`). Der Spieler findet das Item `NHV_Book_Q01_PatrolSlip` („Imperial Patrol Slip“) neben der Kellertür.
- Spielmechanik: Erst **mit dem Slip im Inventar** erscheint Veyras Hub-Frage „There are Imperial boot prints beside the cellar door.“ (LineID `NHV_Q01_020_2108`) und danach „They lead toward an old watchpost near the road.“ (`…_2109`). Danach beginnt Stage 25, und der Wachposten erscheint auf der Karte.
- Der Slip muss den Spieler also **zum alten Wachposten an der Morthal-Straße** führen, ohne Hrefnas Camp zu verraten (das erfährt der Spieler erst vom Scout, Stage 25).

## Inhalt (Vorgaben)

- Quelle: kaiserlicher Wachzettel, den ein Trupp beim Abmarsch von der Farm verloren hat (Penitus Oculatus arbeitet verdeckt, daher keine Oculatus-Nennung im Klartext; „Imperial Watch“ genügt).
- Muss enthalten: Ort „alter Wachposten / Old Watchpost an der Morthal-Straße“, Hinweis auf einen Trupp („four on the post“ oder ähnlich) und dass dort jemand Bericht erstattet. Kein Hinweis auf das Camp, keine Namen von Hrefna, Quintus oder Veyra.
- Länge: 2–4 Sätze, Book-Format wie die anderen Fundstücke (`\n\n` für Absätze, Titelzeile in Großbuchstaben).
- Stil und Ton: wie `NHV_Q01_020_9101…9103` (nüchtern, administrativ, Amerikanisch, Englisch).
- Der Platzhalter lautet derzeit: „IMPERIAL WATCH - RELIEF SLIP / Old Watchpost, Morthal road. Four on the post. Report to the scout, not to the garrison. Nothing is written down twice.“ Der Gedanke („Report to the scout“) passt zur Szene mit dem Scout und kann bleiben.
- Optional: die Spielerzeilen `NHV_Q01_020_2108/2109` an den Fund anpassen („boot prints“ ist ein Fund neben dem Slip; Zeile darf auch den Zettel nennen). Dann bitte beide Zeilen und ihre Voice-Notizen konsistent halten.

## Ablage und Format

- Nur in `dialogue/Books.csv` (und im Enhanced-Spiegel) ändern. LineID `NHV_Q01_020_9107` bleibt unverändert.
- Danach stößt Claude den Build an (Teilbuild für Bücher und Dialog, nicht für die NPCs) und synchronisiert das ESP.
