---
name: release-build
description: Build, FOMOD-Paket und Release-Checkliste für eine Version von Night's Harvest vorbereiten (z. B. /release-build 0.1.0).
argument-hint: "[Version, z. B. 0.1.0]"
disable-model-invocation: true
---

# Release-Build $ARGUMENTS

Ein Release geht in echte Spielstände. Was hier durchrutscht, lässt sich später nur mit Migrationen reparieren. Arbeite die Schritte der Reihe nach ab und brich bei einem roten Punkt ab.

## 1. Vorbedingungen prüfen

- [ ] Alle Arbeitspakete des Meilensteins mindestens „Test“, die tragenden „Fertig“ (`docs/ROADMAP.md`)
- [ ] Keine offenen Bugs „kritisch“/„hoch“ (Entwickler fragen oder Issues prüfen)
- [ ] `git status` sauber, Branch `main`
- [ ] Dialog-Lint grün

## 2. Version setzen

Dieselbe Nummer `$ARGUMENTS` an allen Stellen:

- `VERSION` in `NHV_CoreScript` erhöhen, wenn sich Save-relevantes geändert hat (Migration in `Migrate()` ergänzen)
- `fomod/info.xml` → `<Version>`
- `CHANGELOG.md`: neuer Abschnitt mit Datum, Änderungen, **save-safe: yes/no** und Begründung

## 3. Save-Kompatibilität gegen die letzte Version prüfen

`git diff <letzter Tag>..HEAD -- Data/Source/Scripts` durchsehen:

- [ ] Keine Property, Variable, State, Event-Funktion oder Script umbenannt oder entfernt
- [ ] Neue Aliase nur in noch nicht gestarteten Quests oder als Reserve-Alias
- [ ] Migrationen idempotent

Befunde als Blocker melden.

## 4. Bauen

1. Scripts kompilieren und BSA packen (Befehl aus `docs/ENVIRONMENT.md`).
2. SEQ-Datei nötig? (Start-Game-Enabled-Quest mit Dialog) → Entwickler um Erzeugung in xEdit bitten.
3. Spriggit-Serialize ausführen, Diff auf unerwartete Änderungen prüfen.
4. FOMOD prüfen: `fomod/ModuleConfig.xml` gegen die Vorlage in [references/fomod-template.md](references/fomod-template.md), alle Quellpfade existieren, Patch-Optionen mit `fileDependency`.
5. Archiv `NightsHarvest-$ARGUMENTS.7z` erzeugen (Struktur siehe Vorlage).

## 5. Checks durch den Entwickler (Checkliste ausgeben)

- [ ] xEdit „Check for Errors“ ohne Befund, 0 ITM, 0 UDR
- [ ] Keine Vanilla-Overrides außer den Zell-Kopien in `docs/ARCHITECTURE.md`
- [ ] Frische FOMOD-Installation in Vortex (und vor 1.0 zusätzlich MO2), Patch-Erkennung korrekt
- [ ] Neues Spiel bzw. T02 starten: Versionsmeldung, keine `[NHV]`-Fehler
- [ ] Update-Test: Spielstand der Vorversion laden, Kernfunktionen prüfen
- [ ] Ab 1.0: Durchlauf auf SE 1.5.97

## 6. Abschluss

- Release-Notes für Nexus entwerfen (Englisch): Was ist neu, Anforderungen (SKSE64, SkyUI), save-safe, bekannte Probleme.
- Tag `v$ARGUMENTS` und Push nur nach ausdrücklicher Freigabe.
- `docs/ROADMAP.md`: Meilenstein-Status aktualisieren.
