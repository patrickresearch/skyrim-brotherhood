# Hauptbogen-Technik: NHV_Sys_Oculatus

Technisches Skelett für den vom Entwickler entschiedenen Hauptbogen (E28–E31, `docs/DECISIONS.md`): Heat-Zähler
nur erzählt + MCM-Debug (E28), Chiffre = Schlüsselbuch + Veyra-Dialog-Fallback (E29), Interludes „First Blood“ +
„Knock at Dawnstar“ + Spitzel-NPC in Dawnstar (E30), Magie = leises Gleaning, kein Relikt (E31).

**Umsetzungsstand:** Die vier neuen Scripts unten sind geschrieben und kompiliert (`Data/Source/Scripts/`,
`Data/Scripts/*.pex`), vom `papyrus-reviewer` geprüft. Noch **nicht** im CK verdrahtet (Quest-Record, Aliase,
Encounter, Dialoge – das macht der Entwickler laut `docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md`). Nichts an
`NHV_ContractBaseScript`, `NHV_CoreScript` oder einem anderen bestehenden Script wurde geändert – ein anderer
Agent bearbeitet parallel das ESP für Q01, deshalb bleibt dieser Hauptbogen rein additiv und ESP-frei.

## 1. Neue System-Quest

**`NHV_Sys_Oculatus`** (Quest, Start Game Enabled, analog zu `NHV_Sys_Core`/`NHV_Sys_Family`). Lebt neben den
bestehenden System-Quests, nicht als Kind einer Story-Quest, damit sie Q00–Q06 überdauert.

**Script `NHV_OculatusScript`** (neu, Basis Quest, `Data/Source/Scripts/NHV_OculatusScript.psc`):

- `GlobalVariable Property NHV_Cfg_Debug Auto` – wie überall, Log-Schalter.
- `GlobalVariable Property NHV_Status_OculatusHeat Auto` – **neuer Global**, spiegelt `iHeat` für CK-Conditions und
  die MCM-Debug-Seite (E28: nie auf einer normalen MCM-Seite). Ein Quest-Script-Int ist keine gültige
  Condition-Quelle; der Global ist es (Papyrus-Regel 2, „Conditions vor Scripts“).
- `Int Property VERSION = 1 AutoReadOnly` + `Int iInstalledVersion` – eigene, von `NHV_CoreScript.VERSION`
  unabhängige Versionskette, gleiches Muster wie dort (`Maintenance()`/`Migrate(aiFrom)`, ein nummerierter,
  idempotenter Block pro Version).
- `Int iHeat = 0` – der eigentliche Zähler, 0–5.
- `Function ReportEvidence(Int aiAmount, String asReason)` – **einzige öffentliche Melde-Funktion** (ersetzt die
  vier einzelnen Funktionen aus dem ersten Entwurf, siehe E28-Vorgabe des Team-Leads: eine Schnittstelle statt
  vier). `aiAmount` wird auf `iHeat` addiert, auf 0–5 geklemmt; `asReason` ist nur ein Log-Tag, nie im Spiel
  sichtbar.
- `Int Function GetHeat()` / `Int Function GetHeatStage()` – Lesezugriff; Stufen 0 Unbemerkt (0–1), 1 Fragt nach
  (2–3), 2 Handelt (4), 3 Vollalarm (5). CK-Conditions vergleichen immer den rohen Heat-Wert (`GetGlobalValue
  NHV_Status_OculatusHeat >= N`), nie diese Stufe – siehe Abschnitt 4 für die konkreten Schwellen der
  Interludes.
- `Bool Function TryClaimInterlude(Int aiInterludeId)` – maßgebliche, quest-unabhängige Sperre gegen doppelte
  Heat-Buchung bei einem Interlude-Neustart, siehe Abschnitt 4.
- `Function Maintenance()` / `Function Migrate(Int aiFrom)` / `Function EnsureHeatMirror()` – Save-sicheres
  Muster wie `NHV_CoreScript`.

**`NHV_OculatusPlayerAliasScript`** (neu, Basis ReferenceAlias, `Data/Source/Scripts/
NHV_OculatusPlayerAliasScript.psc`): eigene PlayerRef-Alias-Instanz auf `NHV_Sys_Oculatus` mit
`OnPlayerLoadGame() → OculatusSys.Maintenance()` – bewusst **nicht** die bestehende `NHV_PlayerAliasScript`
wiederverwendet oder verändert, sondern eine zweite, unabhängige Instanz derselben Idee (Team-Lead-Vorgabe:
keine bestehende `.psc` anfassen).

## 2. Patch-Vorschlag für NHV_ContractBaseScript (NICHT umgesetzt, nur beschrieben)

Bewusst **keine Änderung** in diesem Arbeitspaket, da parallel ein anderer Agent das Q01-ESP bearbeitet und die
Ein-Schreiber-Regel (Regel 7, `CLAUDE.md`) gilt. Für ein späteres, eigenes Arbeitspaket vorgeschlagen:

```papyrus
; Neue, optionale Property – keine bestehende Property/Funktion/State wird umbenannt oder entfernt.
NHV_OculatusScript Property OculatusSys Auto Hidden   ; im CK gesetzt, wie Core/VeyraAlias
```

Kein Pflichtaufruf in bestehenden Funktionen. Die einzelnen Q0x-Quests (`NHV_Q01Script` … `NHV_Q05Script`)
rufen `OculatusSys.ReportEvidence(aiAmount, asReason)` gezielt aus **neuen, additiven** Stage-Fragmenten oder
Dialog-Ergebnis-Skripten auf, nicht aus der Basisklasse selbst. Beispiel-Hook Q01 (illustrativ, Stage-Nummern
legt das CK-Team fest): nach Stage 60 eine neue, optionale Handlung „Cover his tracks“ am Fundort von Fragment
1 → `OculatusSys.ReportEvidence(0, "Q01 evidence covered")` (kein Heat-Effekt laut Plan, nur geloggt) bzw. eine
Variante, die Beweise liegen lässt → `ReportEvidence(1, "Q01 evidence left")`.

**Wann umsetzen:** erst, wenn kein anderer Agent gleichzeitig an `NHV_ContractBaseScript` oder den Q0x-ESP-
Records arbeitet. Bis dahin bleibt der Heat-Zähler nur durch die zwei Interludes und den Spitzel gefüttert
(siehe unten) – funktioniert bereits eigenständig, auch ohne die Q01–Q05-Anbindung.

## 3. Chiffre-Puzzle (E29), ohne SKSE-DLL

Unverändert gegenüber dem ursprünglichen Vorschlag, jetzt als Entscheidung bestätigt: **Schlüsselbuch +
Veyra-Dialog-Fallback**, kein Script-Rätsel.

- `NHV_Note_Dispatch01`–`05` bleiben unverändert. Neu: `NHV_Note_Dispatch01_Decoded` bis `_05` (reine
  Content-Records, kein Script).
- `NHV_Book_PrefectsKey` (neues Buch) – Fundort noch offen (Livia in Q06 vs. Aelius in Q02), siehe Entscheidung
  in `docs/plan/Hauptbogen-Oculatus.md` Abschnitt 9.
- Veyra-Dialog-Branch, Condition `GetItemCount NHV_Book_PrefectsKey >= 1`, Topic „Decode this for me“ pro
  vorhandenem Fragment, Ergebnis `AddItem()` des `_Decoded`-Buchs. Kein neues Script nötig.

## 4. Interludes (E30): First Blood, Knock at Dawnstar, Spitzel

**Doppelte Buchungssperre (Team-Lead-Review Runde 2):** Ein Quest-eigenes `bResolved`-Flag reicht allein
nicht als Schutz gegen doppelte Heat-Buchung, weil eine Quest-Instanz bei einem Neustart (CK-Reset,
Dev-Save, versehentliches `resetquest`) ihren lokalen Zustand verliert. Die **maßgebliche** Sperre liegt
deshalb in `NHV_OculatusScript` selbst: `Bool Function TryClaimInterlude(Int aiInterludeId)` (1 = First
Blood, 2 = Knock at Dawnstar) liefert nur beim ersten Aufruf `True` und merkt sich das dauerhaft in
`bIL01Done`/`bIL02Done` – diese Flags gehören zur System-Quest, die nie neu gestartet wird. Beide
Interlude-Quests rufen diese Funktion vor jeder `ReportEvidence()`-Meldung auf; zusätzlich **müssen**
beide Quests im CK auf „Run Once“ gesetzt werden (siehe CK-Anleitung Schritt 5) – zwei unabhängige
Sperren statt einer.

**`NHV_IL01Script`** (neu, Basis Quest, „First Blood“): `Conclude(Bool abLetterFound)`. `bResolved` wird
sofort gesetzt (ein `Bool`-Parameter hat keinen ungültigen Zustand, anders als bei `NHV_IL02Script`),
dann erst `OculatusSys.TryClaimInterlude(1)` geprüft. Meldet `OculatusSys.ReportEvidence(0, ...)` – reine
Flavour-Episode ohne Heat-Effekt, aber geloggt. Start über Story-Manager-Quest-Event, Condition
`GetGlobalValue NHV_Status_OculatusHeat >= 2` (roher Heat-Wert) im CK (kein Polling, Papyrus-Regel 1).
Encounter: 1 FormList `NHV_FormList_OculatusMercs` (2–3 Templates), platziert über
Zufallsbegegnungs-Mechanismen entlang der Straßen (Details CK-Anleitung).

**`NHV_IL02Script`** (neu, Basis Quest, „Knock at Dawnstar“): `Conclude(Int aiOutcome)` – 0 Kampf gewonnen
(Heat −1), 1 Verhör erfolgreich (Heat −1), 2 nur beobachtet/gefolgt (kein Heat-Effekt). Ein ungültiger
`aiOutcome`-Wert wird geloggt und **nicht** als „resolved“ verbucht (`bResolved` bleibt `False`, ein
späterer, gültiger Aufruf bleibt möglich) – bewusst anders als `NHV_IL01Script`, weil `Int` hier einen
ungültigen Zustand kennt. Danach `OculatusSys.TryClaimInterlude(2)`. Optionale Property `Informant` (Typ
`NHV_InformantAliasScript`): **sinnvoll genutzt**, nicht nur als Platzhalter – ist sie gesetzt, hängt
`Conclude()` den bereits erreichten Ausgang des Spitzels (`Informant.GetOutcome()`) als Diagnose-Zusatz an
den Log-Text an (kein zusätzlicher Heat-Effekt aus der Verknüpfung selbst, rein informativ für den
Entwickler beim Testen). `None` bleibt ein gültiger, geprüfter Zustand, falls der Entwickler den Spitzel
nicht mit diesem Interlude verknüpft. Encounter: 3–4 Agenten-Templates in einer **Wildnis-Zelle im Umland
von Dawnstar**, ausdrücklich nicht in `DawnstarSanctuary` selbst (keine neue E16-Zellkopie, kein Vorgriff
auf Q06). Condition `GetGlobalValue NHV_Status_OculatusHeat >= 4` im CK.

**`NHV_InformantAliasScript`** (neu, Basis ReferenceAlias, Spitzel-NPC in Dawnstar – **jetzt Teil von v1.0**,
abweichend von der ursprünglichen Planempfehlung, siehe E30):

- `Function Expose()` – vom Erkennungs-/Dialog-Fragment aufgerufen, wenn der Spieler ihn beim Beobachten der
  Sanctuary ertappt (Condition auf `GetGlobalValue NHV_Status_OculatusHeat >= 2`, roher Heat-Wert,
  Papyrus-Regel 2, kein eigener Poll-Loop).
- `Function Resolve(Int aiChoice)` – 0 töten (Heat −1, `Kill()`), 1 umdrehen/Doppelagent (Heat −1, rein
  narratives Flag, kein Begleiter-Mechanismus), 2 laufen lassen (Heat +1, „berichtet weiter“). Ein
  ungültiger `aiChoice` ändert nichts und wird nur geloggt – der Spitzel bleibt im entlarvten Zustand
  wiederholbar ansprechbar. `iOutcome` und, im Töten-Fall, `Kill()` laufen immer, sobald `aiChoice`
  gültig ist; nur der `ReportEvidence()`-Aufruf selbst ist gegen ein fehlendes `OculatusSys`-Property
  abgesichert (Team-Lead-Review Runde 2: kein Zustand soll an einem fehlenden CK-Property hängen
  bleiben, der eigentliche Spielausgang – tot/umgedreht/freigelassen – muss auch ohne die
  Heat-Anbindung korrekt eintreten).
- `Int Function GetOutcome()` – Lesezugriff für andere Scripts (aktuell `NHV_IL02Script`, siehe oben).
- `Event OnDeath(Actor akKiller)` – setzt `iOutcome` immer auf 2, senkt Heat aber nur, wenn `akKiller`
  dem gesetzten `PlayerRef`-Property entspricht (None-sicherer Vergleich). Ein Tod durch einen Dritten
  (Wache, wildes Tier, o. Ä.) vor der Entlarvung wird nur geloggt, nicht als Heat-Ereignis gewertet – der
  Zirkel erfährt so nichts über eine Handlung, an der der Spieler gar nicht beteiligt war.
- `Actor Property PlayerRef Auto` – im CK auf den Spieler zu setzen, ausschließlich für den
  Attributions-Check in `OnDeath()` verwendet.
- `Int iOutcome` – 0 unentdeckt, 1 entlarvt, 2 getötet, 3 umgedreht, 4 freigelassen; nie umnummerieren.

**Design (Ort, Tagesablauf, Entlarvung – Ergänzung zum Plan-Dokument):** Der Spitzel ist ein neuer, eigener NPC
(kein Vanilla-Edit), tagsüber am Dawnstar-Hafen mit einer Fischer-/Händler-Rolle getarnt (Package „Arbeiten am
Hafen“), nachts in Sichtweite des Sanctuary-Zugangs mit einem „Watch“-Package (Sandbox-Radius, kein
Navmesh-Edit, nutzt bestehende Dawnstar-Wege). Entlarvung: eine neue, optionale Beobachtungs-/Speech-Szene, die
ab `NHV_Status_OculatusHeat >= 2 (roher Heat-Wert)` verfügbar wird (der Spieler bemerkt sein Verhalten als zu regelmäßig/gezielt) –
Details, Dialogtext und genaue Trigger-Bedingung folgen in der CK-Anleitung und im Codex-Brief für den Spitzel.

## 5. Gleaning-Text (E31)

Reine Textarbeit (Veyra-Kommentare, siehe `docs/codex/2026-09-28-Gleaning-Faden-Texte.md`), kein neues Script,
kein neues Relikt (E31 schließt das für v1.0 explizit aus).

## 6. FormID-Bereich

Unverändert: `0x004200`–`0x0042FF` für alle neuen Records dieses Hauptbogens. Vor Nutzung im CK die aktuell
höchste vergebene NHV-FormID im Plugin prüfen (Kollisionsgefahr, da diese Übersicht nicht jede bisher im CK
vergebene ID kennt).

## 7. Save-Kompatibilitäts-Checkliste

- `NHV_Sys_Oculatus` ist eine **neue** Quest, unabhängig von `NHV_CoreScript` gestartet (Start Game Enabled,
  kein Aufruf aus `NHV_CoreScript` nötig oder vorgesehen) – bei Bestandsspielständen ab dem ersten Laden nach
  dem Patch aktiv, `iHeat` startet bei 0.
- `NHV_OculatusPlayerAliasScript` übernimmt die Load-Maintenance eigenständig; `NHV_PlayerAliasScript` bleibt
  unverändert.
- Kein Zugriff auf oder Änderung an `NHV_ContractBaseScript`, `NHV_CoreScript` oder einem anderen bestehenden
  Script in diesem Arbeitspaket – nur der Patch-Vorschlag in Abschnitt 2, für später.
- Alle neuen Dialoge/Bücher/Encounter sind additiv; keine bestehende Stage wird umnummeriert.
- Migration ausschließlich in `NHV_OculatusScript.Migrate()`, eigene Versionskette, keine Kollision mit
  `NHV_CoreScript.VERSION`.
- Kein SKSE-DLL, keine neue harte Abhängigkeit.

## 8. Was noch fehlt / offen

- CK-Verdrahtung: Quest-Record `NHV_Sys_Oculatus`, PlayerRef-Alias, Spitzel-Alias, Interlude-Quests,
  Encounter-Zonen, Dialoge, Globals – siehe `docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md`.
- Patch an `NHV_ContractBaseScript` (Abschnitt 2) – eigenes, späteres Arbeitspaket, erst nach Freigabe durch
  den Entwickler und außerhalb der aktuellen Q01-ESP-Session.
- Entscheidung Fundort Schlüsselbuch (Livia in Q06 vs. Aelius in Q02).
- Name und Autorenprofil-Feinschliff für den Spitzel-NPC (Codex-Brief liegt vor, siehe
  `docs/codex/2026-09-28-Spitzel-Dawnstar.md`).
