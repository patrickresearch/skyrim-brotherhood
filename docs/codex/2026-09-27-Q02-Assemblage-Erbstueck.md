# Auftrag: Q02 – Nebenaufgabe „The Assemblage's Due“ (Vorschlag, nicht im Konzept)

**Wofür:** [Vorschlag] optionale Nebenaufgabe zu Q02 „Cold Waters“, siehe
`docs/plan/Q02-Cold-Waters.md` Abschnitt 7. Drinks-the-Brine erzählt (nach erfolgreichem
Persuade/Bribe in Stage 10), dass Haldors Schuldeneintreiber der Argonierin Scouts-Many-Marshes
(Vanilla-NPC in `WindhelmArgonianAssemblage`) ein Erbstück abgenommen hat. Der Spieler kann es
zurückholen und zurückgeben. Rein atmosphärisch, kein Gameplay-Effekt auf Sings. **Nur schreiben,
wenn der Entwickler diese Nebenaufgabe bestätigt hat.**

**Was schreiben:**
- Eine Drinks-the-Brine-Zeile (2–3 Sätze), die vom Erbstück erzählt: knapp, misstrauisch, im Ton
  von `docs/concept/Q02-Nebenfiguren-Autorenprofile.md` („er hilft nur so weit, wie dadurch kein
  anderer Argonier sichtbar wird“). Sollte anbieten, ohne zu betteln.
- Eine bis zwei Scouts-Many-Marshes-Zeilen (Dank, zurückhaltend, keine übertriebene Rührung – sie ist
  ein Vanilla-Charakter, keine neue Lore über sie erfinden, nur eine kurze Alltagsreaktion).

**Speichern:** `dialogue/Q02.csv`, neue LineIDs im Schema `NHV_Q02_010_9x` (Drinks-Zeile, Topic
`Q02_Docks`, Bedingung: Persuade/Bribe-Erfolg aus Stage 10 bereits erreicht) und ein neues Topic
`Q02_Assemblage` (Scouts-Many-Marshes-Zeilen, Speaker `ScoutsManyMarshes` – VoiceType: vorhandene
Vanilla-Stimme verwenden, keine neue anlegen). LineIDs `NHV_Q02_015_xx` (Nebenaufgabe, keine
Kollision mit Hauptpfad-Stages).

**Grenzen:** Amerikanische Schreibweise. Scouts-Many-Marshes bleibt lore-konform (keine erfundene
Vorgeschichte über sie hinaus, die dem Vanilla-Charakter widerspricht). Keine Ich-Perspektive-Texte,
die eine Fraktionszugehörigkeit implizieren, die sie im Vanilla-Spiel nicht hat.

**Technik:** `NHV_Q02Script.DeliverLocket()` (bereits implementiert) prüft, ob der Spieler
`NHV_Item_Q02_FamilyLocket` trägt, entfernt es bei Rückgabe und setzt
`NHV_Q02_Flag_SideB_Done`. Fundort des Erbstücks (Haldor-Container oder -Leiche) legt der
Entwickler im CK fest.
