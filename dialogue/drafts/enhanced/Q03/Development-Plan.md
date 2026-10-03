# Q03 Enhanced – Entwicklungsplan

**Status:** Inaktiver Story- und Dialogentwurf. Keine Aussage über Ingame-Funktion.

## Neue oder zu prüfende Records

| EditorID-Vorschlag | Typ | Zweck |
|---|---|---|
| `NHV_Q03_Selveni` | NPC/VoiceType | Selveni als College-Zeugin; eigener Alias, kein Vanilla-Override |
| `NHV_Q03_RoadSurvivor` | NPC/VoiceType | Kurzer Straßen-Encounter an der Wegstation |
| `NHV_Q03_WaystationCell` | CELL | Kontrollierter Innenraum für Überlebenden, Pack und Beweise |
| `NHV_Q03_ResonanceChamber` | CELL/Activator-Set | Innere Phase des Hollowfrost Spire ohne zusätzliche Fraktion |
| `NHV_Q03_FocusFragment` | MISC/Activator | College-Beweis und ruhige Resonanzroute |
| `NHV_Q03_TravelerToken` | MISC | Persönlicher Gegenstand des Opfers |
| `NHV_Q03_ConsentLedger` | BOOK | Nireldas Prüfungsvorbereitung |
| `NHV_Q03_CountermarkSeal` | MISC/BOOK | Optionales Beweisstück neben Whisperbane |
| `NHV_Q03_CollegeWitness` | GLOBAL | Selveni-Phase abgeschlossen |
| `NHV_Q03_RoadEvidence` | GLOBAL | Wegstation untersucht |
| `NHV_Q03_Resonance` | GLOBAL | Resonanzkammer passiert |
| `NHV_Q03_LedgerRead` | GLOBAL | Consent-Ledger gelesen |
| `NHV_Q03_CountermarkKept` | GLOBAL | Gegenzeichen verwahrt |

## Reihenfolge im Creation Kit

1. Eigene VoiceTypes, NPC-Platzhalter und Globals anlegen. Keine Vanilla-NPCs oder Vanilla-Scripts ändern.
2. Die Wegstation als eigene kontrollierte Zelle bauen. Überlebender, verbrannter Rucksack und Token müssen in einem kurzen, navmeshten Bereich liegen.
3. Selveni über einen Q03-Alias in der College-Zelle platzieren. Die Dialoge dürfen erst nach dem V2/V3-Redaktionsentscheid aktiviert werden.
4. Hollowfrost Spire und Resonanzkammer trennen, sofern die bestehende Spire-Zelle keine sichere Erweiterung zulässt. Alternativ nur eigene Activators und Packages in der vorhandenen Q03-Zelle verwenden.
5. Die vier Resonanzrouten auf denselben Übergang zur Joric-Szene führen. Keine Route darf die Beobachtung überspringen.
6. Joric-Entscheidung und Consent-Ledger als zwei getrennte Szenen oder ForceGreets verdrahten. `ledgerRead` wird additiv gesetzt.
7. Whisperbane- und Gegenzeichenfund erst nach Nireldas Prüfung aktivieren. Der Gegenzeichenpfad darf L.M. nicht in einen vollständigen Namen auflösen.
8. Urteil, Arcanum-Freischaltung und College-Übergabe erst nach dem tatsächlichen Weltzustand auslösen. Bei totem Nirelda darf kein Nirelda-Dialog erscheinen.

## Testfälle

- Urag verweigert die Akte; Selveni und Thyra führen trotzdem zur Wegstation.
- Der Spieler nimmt Selvenis Kopie oder lässt sie im College; beide Wege bleiben vollständig.
- Alle drei Wegstationsrouten erreichen den Turm mit derselben `roadEvidence`-Voraussetzung.
- Die vier Stillnesses und alle Resonanzrouten führen zu Joric.
- Joric wird geheilt, stirbt oder die Beobachtung wird unterbrochen; die Consent-Phase startet jeweils genau einmal.
- Nireldas Prüfung besteht über zwei tragfähige Antworten oder endet nach kontrolliertem Kampf.
- Whisperbane und Gegenzeichen erscheinen erst nach der Prüfung; L.M. bleibt eine Initiale.
- Aufnahme, College, Exil und Schweigen setzen jeweils einen eindeutigen Outcome; tote Nirelda bleibt tot.

**CK-Hinweis:** Zellkoordinaten, Navmesh, FaceGen, Packages, Scene-Phasen und Property-Bindings bleiben Entwicklerarbeit im Creation Kit. Der Enhanced-Draft wird erst nach redaktioneller Freigabe in Topics und Scenes überführt.
