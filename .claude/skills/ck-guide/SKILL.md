---
name: ck-guide
description: Schritt-für-Schritt-Anleitungen für das Creation Kit und Record-Inventare für Night's Harvest schreiben, weil Claude das CK nicht selbst bedienen kann. Verwenden, sobald eine Aufgabe neue oder geänderte Records braucht (Quests, Stages, Aliase, Szenen, Packages, NPCs, Zellen, Navmesh, Dialog-Topics, Globals, FormLists, Spells, Items), wenn der Entwickler fragt, wie etwas im CK geht, oder ein Arbeitspaket CK-Arbeit enthält.
---

# CK-Anleitungen für Night's Harvest

Der Entwickler setzt im Creation Kit um, was du planst. Eine gute Anleitung lässt sich Schritt für Schritt abarbeiten, nennt jeden Wert explizit und endet mit einer Prüfung im Spiel. Unklare Anleitungen kosten ihn Stunden im CK, das instabil ist und keine Undo-Historie für viele Aktionen hat.

## Ablauf

1. Konzept-Abschnitt und `docs/ARCHITECTURE.md` lesen, EditorIDs nach `docs/CONVENTIONS.md` vergeben.
2. Record-Inventar erstellen (alle neuen und geänderten Records).
3. Anleitung in der Reihenfolge der Abhängigkeiten schreiben: Globals/Fraktionen/FormLists → NPCs/Items → Zellen/Referenzen → Quest mit Aliasen → Packages → Dialoge → Szenen → Scripts anhängen und Properties füllen.
4. Prüfschritte im Spiel ergänzen.
5. Anleitung als `docs/ck/<Paket-ID>.md` ablegen, damit sie im Repo nachvollziehbar bleibt.

## Vorlage

```markdown
# CK-Anleitung <Paket-ID>: <Titel>

**Ziel:** Was nach diesen Schritten im Spiel existiert.
**Voraussetzungen:** Benötigte Records/Scripts, kompilierte .pex, offene Entscheidungen.
**Dauer (Schätzung):** …

## Record-Inventar
| EditorID | Typ | Zweck | Quest | neu/ändern |

## Schritte
1. **<Record-Typ> anlegen:** Formular, Feld → Wert. (Menüpfad nur, wenn sicher bekannt.)
   | Feld | Wert |
2. …

## Script anhängen & Properties
| Record/Alias | Script | Property | Wert |

## Speichern & Sichern
CK speichern → Spriggit-Serialize → Commit `[<Bereich>] …`

## Prüfen im Spiel
1. `coc …` / `setstage …`
2. Erwartet: …
3. Papyrus-Log: keine `[NHV]`-Fehler; zurückmelden: …
```

## Pflichtwissen für Anleitungen

- **Vanilla-Records nicht anfassen.** Vanilla-NPCs nur über Aliase in eigenen Quests. Beim Arbeiten in Vanilla-Zellen nichts verschieben; versehentliche Änderungen („dirty edits“) nach jeder Session in xEdit prüfen und entfernen lassen. Jede neue Referenz in einer Vanilla-Zelle erzeugt eine Zell-Kopie: nur nach E16 und mit Eintrag in `docs/ARCHITECTURE.md`.
- **Aliase auf Vanilla-Referenzen:** immer „Optional“, Fill-Type „Specific Reference“.
- **Start Game Enabled:** nur `NHV_Sys_Core` und `NHV_Sys_MCM`. Enthält eine Start-Game-Enabled-Quest Dialog, muss eine SEQ-Datei erzeugt werden (xEdit: Rechtsklick auf das Plugin → Other → Create SEQ File) und mit ausgeliefert werden.
- **NPCs:** Nach Gesichtsänderungen FaceGen exportieren (NPC im Object Window markieren, Strg+F4), sonst erscheint das Gesicht ingame dunkel. Eigene VoiceType zuweisen, Protected/Essential laut E02.
- **Zellen:** Navmesh nach dem Zeichnen finalisieren, damit Türen verknüpft werden. Room Bounds und Portale für mehrräumige Zellen. Encounter Zone mit „Never Resets“ für das Deep Sanctuary. Lighting Template statt Einzelwerten.
- **Referenzen, die Scripts brauchen:** eindeutige EditorID vergeben; bei Enable-Parents den Parent-Marker dokumentieren.
- **Dialoge:** Topics und INFOs gemäß `dialogue/*.csv`, LineID in das Notizfeld bzw. die Kommentarspalte übernehmen. Speaker-Conditions (`GetIsID`, `GetIsVoiceType`) nicht vergessen.
- **Szenen:** Beteiligte Actors vor Szenenstart per Script auf XMarker bewegen; „Interruptible“ bewusst setzen; Fallback-Stage angeben.
- **Packages:** Als Alias-Packages anlegen, nicht am NPC-Record von Vanilla-Figuren.
- **Properties:** Jede Script-Property in der Anleitung mit Zielwert nennen. Nicht gefüllte Properties sind die häufigste Fehlerquelle.
- **Speichern:** Häufig speichern; vor größeren Aktionen (Navmesh, Szenen) ein ESP-Backup.

## Was du nicht tust

- Keine Schritte erfinden, die du nicht sicher kennst. Ist ein Menüpfad oder Feldname unsicher, schreibe „Feld für <Zweck> (Name im CK prüfen)“.
- Keine Record-Änderungen per Tool oder Spriggit-Deserialize.
