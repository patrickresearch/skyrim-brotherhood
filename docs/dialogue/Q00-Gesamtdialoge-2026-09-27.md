# Q00 – A Shadow at the Door: Gesamtdialoge

Quelle: `dialogue/Q00.csv` (192 Zeilen) und Q00-Journalziele aus `dialogue/Journal.csv` (8 Zeilen).

Diese Lesefassung enthält alle aktuellen Q00-Zeilen, einschließlich Folge-Topics und Antworten. Änderungen erfolgen ausschließlich im CSV-Master. „Noch nicht im Plugin“ bedeutet, dass die Zeile redaktionell vorliegt, aber noch nicht im Creation Kit verkabelt ist.

## Stage 10 – Standoff und Befragung

`NHV_Q00_010_01` · Nazir · Topic `SCN_Standoff`

> Listener. Good. You can settle this before I settle it myself.

**Notes:** Automatische Szene; Veyra sitzt am Esstisch, Nazir steht mit gezogener Klinge ueber ihr, Szene startet < 800 Units

---

`NHV_Q00_010_02` · Nazir · Topic `SCN_Standoff`

> This one walked through the Black Door like she owned the place. Say the word and I open her up.

**Notes:** Im CK als zweite Response im Topic NHV_Q00_010_01 der Szene angelegt (eine Aktion je Phase und Actor)

---

`NHV_Q00_010_03` · Veyra · Topic `SCN_Standoff`

> He's been saying that for an hour. I'm beginning to think he doesn't mean it.

**Notes:** ruhig, ohne aufzusehen

---

`NHV_Q00_010_04` · Babette · Topic `SCN_Standoff`

> Oh, he means it. He just hasn't decided where to start.

**Notes:** Babette lehnt an einer Saeule

---

`NHV_Q00_010_05` · Cicero · Topic `SCN_Standoff`

> Cicero knows that face! Cicero knows it! But from where, from where...

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition, echte Pruefung ueber Alias NHV_Sys_Sanctuary::Cicero (M1.4); Cicero kauert hinter einer Kiste

---

`NHV_Q00_010_06` · Veyra · Topic `SCN_Standoff`

> Ah. So it's Cicero these days.

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition; leise, ohne aufzusehen. Keine Reaktion, keine Nachfrage; die Szene laeuft einfach weiter

---

`NHV_Q00_010_10` · Spieler · Topic `Veyra_Standoff`

> You have a name. Let's hear it.

**Notes:** Option 1 von 6; Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.; E22: Informationszweig, zurueck zum Standoff-Menue, kein Stage-Wechsel und keine Abschlusskette.

---

`NHV_Q00_010_11` · Veyra · Topic `Veyra_Standoff`

> Veyra Othren. Once of Bravil, once of Cheydinhal, once of a dozen sanctuaries that don't exist anymore.

---

`NHV_Q00_010_12` · Veyra · Topic `Veyra_Standoff`

> The family used to call me the Gleaner.

---

`NHV_Q00_010_13` · Spieler · Topic `Veyra_Standoff`

> The Gleaner. An odd name for an assassin.

**Notes:** Folgeoption zu Option 1; Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_010_14` · Veyra · Topic `Veyra_Standoff`

> After the harvest, someone walks the fields and gathers what the reapers left behind.

---

`NHV_Q00_010_15` · Veyra · Topic `Veyra_Standoff`

> That was my work. I found the ones worth keeping.

---

`NHV_Q00_010_20` · Spieler · Topic `Veyra_Standoff`

> Knowing the door's answer doesn't make you family.

**Notes:** Option 2 von 6; Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.; E22: Informationszweig, zurueck zum Standoff-Menue, kein Stage-Wechsel und keine Abschlusskette.

---

`NHV_Q00_010_21` · Veyra · Topic `Veyra_Standoff`

> No. It means someone trusted me with it once. You needn't repeat their judgment.

**Notes:** Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_010_22` · Nazir · Topic `Veyra_Standoff`

> At last. Something we agree on.

**Notes:** Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_010_23` · Veyra · Topic `Veyra_Standoff`

> Keep the blade, Nazir. I'd be more concerned if you welcomed me.

**Notes:** Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_010_30` · Spieler · Topic `Veyra_Standoff`

> You chose a poor time to ask for our trust.

**Notes:** Option 3 von 6; Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.; E22: Informationszweig, zurueck zum Standoff-Menue, kein Stage-Wechsel und keine Abschlusskette.

---

`NHV_Q00_010_31` · Veyra · Topic `Veyra_Standoff`

> The family grows thin, and I come. It has always been that way.

---

`NHV_Q00_010_32` · Veyra · Topic `Veyra_Standoff`

> So I came north. I found Falkreath in ashes. I was too late for them.

---

`NHV_Q00_010_33` · Veyra · Topic `Veyra_Standoff`

> I don't intend to be too late for you.

---

`NHV_Q00_010_40` · Spieler · Topic `Veyra_Standoff`

> Nazir, lower your blade. Let her talk.

**Notes:** E22: beim Gespraech mit Nazir; nach 41-42 bleibt Stage 10; keine automatische Abschlusskette. Gehoert nicht in Veyras Sprecher-Menue.

---

`NHV_Q00_010_41` · Nazir · Topic `Veyra_Standoff`

> ...Fine. But it stays out of its sheath.

---

`NHV_Q00_010_42` · Veyra · Topic `Veyra_Standoff`

> A sensible compromise.

**Notes:** ; E22: nach dieser Reaktion zurueck zur Befragung, Stage 10 bleibt.

---

`NHV_Q00_010_50` · Spieler · Topic `Veyra_Standoff`

> Do it, Nazir.

**Notes:** E22: explizite Drohung; vorhandene Antwort 51-52 -> Abschluss 70-73 -> Stage 15.

---

`NHV_Q00_010_51` · Veyra · Topic `Veyra_Standoff`

> Ask the Night Mother, Listener. If she refuses my help, I'll leave you to your prayers.

---

`NHV_Q00_010_52` · Nazir · Topic `Veyra_Standoff`

> ...The elf has a point. I hate that.

**Notes:** → 010_70

---

`NHV_Q00_010_60` · Spieler · Topic `Veyra_Standoff`

> I want you out of this Sanctuary.

**Notes:** Option 6 von 6 → Stage 15; Fragment BeginVeyraExitSanctuary()

---

`NHV_Q00_010_61` · Veyra · Topic `Veyra_Standoff`

> As you wish. I'll be at the Windpeak Inn.

---

`NHV_Q00_010_62` · Veyra · Topic `Veyra_Standoff`

> I've waited longer than you would believe. A few more days won't trouble me.

**Notes:** Veyra verlaesst die Sanctuary; Stage-15-Fragment: BeginVeyraExitSanctuary(); Core setzt danach Stage 20

---

`NHV_Q00_010_70` · Nazir · Topic `Veyra_Standoff`

> An old assassin turns up the moment we're weakest, with a sad story and the right words.

**Notes:** E22: Abschlusskette nur nach explizitem 010_127 oder Drohung 010_50-52; nicht nach Informationsfragen. Mehrsprecher-Sequenz: Nazir 70-71 -> Veyra 72-73.

---

`NHV_Q00_010_71` · Nazir · Topic `Veyra_Standoff`

> That's exactly what a spy would do.

---

`NHV_Q00_010_72` · Veyra · Topic `Veyra_Standoff`

> It's exactly what a spy would do. So don't take my word for it. Take hers.

**Notes:** Blick zum Sarg der Night Mother → 010_73

---

`NHV_Q00_010_73` · Veyra · Topic `Veyra_Standoff`

> Until she speaks, I'll remove myself from your threshold.

**Notes:** Nach 010_72 → Stage 15; Fragment: BeginVeyraExitSanctuary(); Core setzt danach Stage 20

---

`NHV_Q00_010_91` · Spieler · Topic `Veyra_StandoffTrust`

> You speak of family. We buried ours.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.

---

`NHV_Q00_010_92` · Veyra · Topic `Veyra_StandoffTrust`

> Yes. And now a stranger sits at their table, asking you to make room. I know what that looks like.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_93` · Veyra · Topic `Veyra_StandoffTrust`

> I won't ask you to mistake an empty chair for an invitation.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_94` · Spieler · Topic `Veyra_StandoffTrustFollow`

> Then stop speaking as though you belong here.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_95` · Veyra · Topic `Veyra_StandoffTrustFollow`

> Fairly said. I belonged somewhere once. I have been careless with the distinction.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_96` · Veyra · Topic `Veyra_StandoffTrustFollow`

> Ask the Mother whether I belong. I will wait elsewhere until you have your answer.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.; Lore-Review 26.09.2026 eingearbeitet.

---

`NHV_Q00_010_97` · Spieler · Topic `Veyra_StandoffDelay`

> You found the ashes. Where were you when we needed you?

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.

---

`NHV_Q00_010_98` · Veyra · Topic `Veyra_StandoffDelay`

> On the road. Late. Those are the only parts of the answer that matter.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_99` · Veyra · Topic `Veyra_StandoffDelay`

> I could tell you how far I traveled. It wouldn't put anyone back in that chair.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_100` · Spieler · Topic `Veyra_StandoffDelayFollow`

> You could have come straight here.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_101` · Veyra · Topic `Veyra_StandoffDelayFollow`

> With the Emperor's death still being planned? An unfamiliar face would have looked like a knife at your back.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_102` · Veyra · Topic `Veyra_StandoffDelayFollow`

> I waited. Nazir has made a persuasive case that waiting improved nothing.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_103` · Spieler · Topic `Veyra_StandoffMother`

> You keep invoking the Mother. Has she spoken to you?

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.

---

`NHV_Q00_010_104` · Veyra · Topic `Veyra_StandoffMother`

> I have spoken with the Mother. Not in the way she speaks to you.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; deutet eine frühere Verbindung an, bestätigt kein Treffen.

---

`NHV_Q00_010_105` · Veyra · Topic `Veyra_StandoffMother`

> That does not give me your place, Listener. Ask her whether she wants my help.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; wahrt die Zuständigkeit des Listeners.

---

`NHV_Q00_010_106` · Spieler · Topic `Veyra_StandoffMotherFollow`

> Yet you expect me to believe she wants you here.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_107` · Veyra · Topic `Veyra_StandoffMotherFollow`

> I hope she does. Hope is a poor witness. Ask her before you trust me.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.; Lore-Review 26.09.2026 eingearbeitet.

---

`NHV_Q00_010_108` · Veyra · Topic `Veyra_StandoffMotherFollow`

> Ask her. You needn't tell me what she says. Only what you decide.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_109` · Spieler · Topic `Veyra_StandoffProof`

> Give me proof that you served the Brotherhood.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.

---

`NHV_Q00_010_110` · Veyra · Topic `Veyra_StandoffProof`

> Names can be stolen. Robes can be taken from a corpse. You already know what a remembered answer is worth.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_111` · Veyra · Topic `Veyra_StandoffProof`

> I can offer work you may judge. For tonight, I can offer only a claim you should question.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_112` · Spieler · Topic `Veyra_StandoffProofFollow`

> Convenient. Nothing you say can be tested.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_113` · Veyra · Topic `Veyra_StandoffProofFollow`

> Not by another story from me. You're right to notice.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_114` · Veyra · Topic `Veyra_StandoffProofFollow`

> You have a Listener's privilege. Use it before you give a stranger a Listener's trust.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_115` · Spieler · Topic `Veyra_StandoffGleaning`

> Finding killers hardly sounds difficult.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.; Nur nach 010_14-15 verlinkt, kein Top-Level-Einstieg (Lore-Review).

---

`NHV_Q00_010_116` · Veyra · Topic `Veyra_StandoffGleaning`

> It isn't. Finding one who can put the knife away is considerably harder.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.; Nur nach 010_14-15 verlinkt, kein Top-Level-Einstieg (Lore-Review).

---

`NHV_Q00_010_117` · Veyra · Topic `Veyra_StandoffGleaning`

> A family must sleep beside its own blades. I look for someone who understands that.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.; Nur nach 010_14-15 verlinkt, kein Top-Level-Einstieg (Lore-Review).

---

`NHV_Q00_010_118` · Spieler · Topic `Veyra_StandoffGleaningFollow`

> We're assassins. You make us sound respectable.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_119` · Veyra · Topic `Veyra_StandoffGleaningFollow`

> Respectable? No. Dependable, I hope. There is an important difference when the person beside you has a knife.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_120` · Veyra · Topic `Veyra_StandoffGleaningFollow`

> I would rather hear an ugly truth at this table than discover a pretty lie in my bed.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_121` · Spieler · Topic `Veyra_StandoffAuthority`

> If you stay, you answer to me.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Einstieg; nach Antwort bleibt Stage 10.

---

`NHV_Q00_010_122` · Veyra · Topic `Veyra_StandoffAuthority`

> In the work, yes. I bring you names. You decide what becomes of them.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_123` · Veyra · Topic `Veyra_StandoffAuthority`

> And when I think you wrong, I will tell you while there is still time to matter.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_124` · Spieler · Topic `Veyra_StandoffAuthorityFollow`

> That sounds like a condition.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Nachfrage nur aus Eltern-INFO verlinken.

---

`NHV_Q00_010_125` · Veyra · Topic `Veyra_StandoffAuthorityFollow`

> It is an offer. You have the Mother's voice. You will still need someone willing to disagree with yours.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_126` · Veyra · Topic `Veyra_StandoffAuthorityFollow`

> Quietly, if you prefer. I have never found shouting improves advice.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; optionaler Standoff-Ausbau; noch nicht im Plugin. Antwort im selben INFO wie unmittelbar vorausgehende Spielerzeile; danach zurueck zum Fragenmenue.

---

`NHV_Q00_010_127` · Spieler · Topic `Veyra_StandoffVerdict`

> I'll hear the Night Mother's judgment. Wait at the inn.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 10; GetIsID NHV_Veyra == 1`

**Notes:** NEU 26.09.2026; E22 bestaetigt: expliziter Abschluss; verlinkt 010_70-73; BeginVeyraExitSanctuary erst nach letzter Response; noch nicht im Plugin.

---

## Stage 15 – Verweisung / Übergang

`NHV_Q00_015_01` · Veyra · Topic `Veyra_Inn`

> Give me a moment, Listener. I know the way out.

**Notes:** Kurzer Stage-15-Fallback, falls Veyra waehrend des sichtbaren Exit-Fensters angesprochen wird

---

`NHV_Q00_015_10` · Spieler · Topic `Veyra_Inn`

> Wait at the inn.

**Notes:** Kurzer Stage-15-Fallback

---

`NHV_Q00_015_11` · Veyra · Topic `Veyra_Inn`

> Windpeak. Yes. I heard you.

**Notes:** Kein normales CK-Fragment; Core setzt Stage 20 nach sichtbarem Exit

---

`NHV_Q00_015_20` · Spieler · Topic `Veyra_Inn`

> Do not make me regret this.

**Notes:** Option 2 von 2; kurzer Stage-15-Fallback

---

`NHV_Q00_015_21` · Veyra · Topic `Veyra_Inn`

> Regret is for the living. I will try not to burden you with more.

---

## Stage 20 – Night Mother und Windpeak Inn

`NHV_Q00_020_00` · NightMother · Topic `NM_Call`

> Come to me, my Listener. A stranger stood among my children. She is no stranger to me.

**Notes:** Ruf auf Stage 20: Idle-Topic (IDAT, Say Once) des Sprech-Aktivators am Sarg, wie Vanillas Night Mother in DBrecurring; Sprecher NHV_NightMotherVoice. Danach Sarg oeffnen → Gespraech. Fassung nach lore-editor 26.09. (Vergangenheit, da Veyra schon weg; fuer die Mother keine Fremde)

---

`NHV_Q00_020_01` · Spieler · Topic `NM_Gleaner`

> Mother, a stranger has come. She calls herself the Gleaner.

**Notes:** Topic am Actor der Night Mother

---

`NHV_Q00_020_02` · NightMother · Topic `NM_Gleaner`

> My Listener. You come with a question on your lips.

---

`NHV_Q00_020_03` · NightMother · Topic `NM_Gleaner`

> The Gleaner has come before, my Listener. She comes whenever the harvest fails.

---

`NHV_Q00_020_04` · NightMother · Topic `NM_Gleaner`

> She gathered when the family was many, and when it was few. Let her gather now.

---

`NHV_Q00_020_10` · Spieler · Topic `NM_Gleaner`

> Can she be trusted?

**Notes:** Option 1 von 5

---

`NHV_Q00_020_11` · NightMother · Topic `NM_Gleaner`

> Trust is for the living to squabble over. I know only this: her heart beats for Sithis.

---

`NHV_Q00_020_12` · NightMother · Topic `NM_Gleaner`

> What she does with it is yours to watch.

---

`NHV_Q00_020_20` · Spieler · Topic `NM_Gleaner`

> Why did she leave the family?

**Notes:** Option 2 von 5; setzt NHV_Q00_AskedLeave (CK: Alias-Variable oder Stage-Zwischenschritt, im CK festlegen)

---

`NHV_Q00_020_21` · NightMother · Topic `NM_Gleaner`

> She served my family without belonging to it. Her path is her own.

**Notes:** Veyra gehört nicht formal zur Brotherhood; ihre Verbindung bleibt eigenständig und übergeordnet.

---

`NHV_Q00_020_30` · Spieler · Topic `NM_Gleaner`

> Why have you never spoken to her?

**Notes:** Option 3 von 5

---

`NHV_Q00_020_31` · NightMother · Topic `NM_Gleaner`

> I speak to one as Listener. It has always been one.

**Notes:** E23-Präzisierung: Die Night Mother meint ihre heutige Übermittlung an den Listener; frühere persönliche Gespräche mit Veyra bleiben offen.

---

`NHV_Q00_020_32` · NightMother · Topic `NM_Gleaner`

> That is the burden of the Listener, and the wound of all the rest.

---

`NHV_Q00_020_35` · Spieler · Topic `NM_Gleaner`

> What is she, Mother?

**Notes:** Option 4 von 5

---

`NHV_Q00_020_36` · NightMother · Topic `NM_Gleaner`

> She is the one who gathers. What else she is, only Sithis knows.

**Notes:** Veyras Alter/Natur bleibt bewusst ungeklaert; Sithis kennt das Geheimnis, eine konkrete Enthüllung bleibt aus.

---

`NHV_Q00_020_40` · Spieler · Topic `NM_Gleaner`

> That is all I needed, Mother.

**Notes:** Option 5 von 5 → Stage 30 (Goodbye); Antwort 020_39

---

`NHV_Q00_020_39` · NightMother · Topic `NM_Gleaner`

> Go, then. The Gleaner waits.

**Notes:** Antwort auf 020_40; eine Option ohne (bzw. mit leerer) Antwort bietet die Engine nicht an (Test 26.09.)

---

`NHV_Q00_020_42` · Veyra · Topic `Veyra_Inn`

> The Mother first, Listener. I have nowhere else to be.

**Conditions:** `NHV_Q00_VeyraReturned == 0; NHV_Q00_VeyraReturning == 0`

**Notes:** Windpeak Inn if player visits Veyra before speaking to the Night Mother

---

`NHV_Q00_020_43` · Spieler · Topic `Veyra_Inn`

> I wanted to make sure you were still here.

**Notes:** Optional check before Night Mother

---

`NHV_Q00_020_44` · Veyra · Topic `Veyra_Inn`

> Still here. Still waiting. I am very good at both.

---

`NHV_Q00_020_45` · Spieler · Topic `Veyra_InnWaiting`

> You seem comfortable being sent away.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.

---

`NHV_Q00_020_46` · Veyra · Topic `Veyra_InnWaiting`

> Comfortable? No. Practiced. There is a difference, though I try not to advertise it.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.

---

`NHV_Q00_020_47` · Veyra · Topic `Veyra_InnWaiting`

> The room is warm, and the innkeeper hasn't drawn a weapon. The evening has improved.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.

---

`NHV_Q00_020_48` · Spieler · Topic `Veyra_InnWaitingFollow`

> And if the Mother turns you away?

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.

---

`NHV_Q00_020_49` · Veyra · Topic `Veyra_InnWaitingFollow`

> Then you won't have to send me away twice.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.; Lore-Review 26.09.2026 eingearbeitet.

---

`NHV_Q00_020_50` · Veyra · Topic `Veyra_InnWaitingFollow`

> Now go. Waiting becomes rather less dignified when someone watches you do it.

**Conditions:** `GetStage NHV_Q00_ShadowAtTheDoor == 20; GetIsID NHV_Veyra == 1; GetGlobalValue NHV_Q00_VeyraReturned == 0; GetGlobalValue NHV_Q00_VeyraReturning == 0`

**Notes:** NEU 26.09.2026; optional im Windpeak Inn vor Urteil; kein Stage-Wechsel; Nachfrage nur verlinkt; noch nicht im Plugin.

---

## Stage 30 – Rückkehr und Proposal

`NHV_Q00_030_01` · Cicero · Topic `CIC_Remembers`

> Cicero remembers now! Cheydinhal! The pointy-eared lady who left!

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition, echte Pruefung ueber Alias NHV_Sys_Sanctuary::Cicero; "left" betont; faengt den Spieler auf dem Rueckweg ab

---

`NHV_Q00_030_02` · Cicero · Topic `CIC_Remembers`

> Who left Cicero alone with Mother and the dust and the rats!

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition

---

`NHV_Q00_030_03` · Cicero · Topic `CIC_Remembers`

> Cicero talked to the rats for years, you know. They were terrible listeners. Terrible!

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition

---

`NHV_Q00_030_10` · Spieler · Topic `CIC_Remembers`

> She came when the family was nearly gone.

**Notes:** Option 1 von 3

---

`NHV_Q00_030_11` · Cicero · Topic `CIC_Remembers`

> Does it? Does it count? Cicero will count. Cicero is very good at counting grudges.

---

`NHV_Q00_030_20` · Spieler · Topic `CIC_Remembers`

> You have every right to be angry.

**Notes:** Option 2 von 3

---

`NHV_Q00_030_21` · Cicero · Topic `CIC_Remembers`

> Yes! Rights! Cicero has so many rights! Thank you, Listener!

---

`NHV_Q00_030_30` · Spieler · Topic `CIC_Remembers`

> Not now, Cicero.

**Notes:** Option 3 von 3

---

`NHV_Q00_030_31` · Cicero · Topic `CIC_Remembers`

> Not now. Never now. Always later with Cicero...

**Notes:** Aufloesung erst in "The Keeper and the Gleaner" (Abschnitt 11, M5.3)

---

`NHV_Q00_030_32` · Veyra · Topic `Veyra_Return`

> You went to the Mother. I can see it in your face.

**Conditions:** `NHV_Q00_VeyraReturned == 0; NHV_Q00_VeyraReturning == 0`

**Notes:** Windpeak Inn nach Night-Mother-Dialog; Greeting/Starttopic

---

`NHV_Q00_030_33` · Spieler · Topic `Veyra_Return`

> The Night Mother says you may gather.

**Conditions:** `NHV_Q00_VeyraReturned == 0; NHV_Q00_VeyraReturning == 0`

**Notes:** Antwort → 030_34

---

`NHV_Q00_030_34` · Veyra · Topic `Veyra_Return`

> Then I return to the door I crossed. Lead on, Listener.

**Conditions:** `NHV_Q00_VeyraReturned == 0; NHV_Q00_VeyraReturning == 0`

**Notes:** Fragment: BeginVeyraReturnToSanctuary(); Alias-Package folgt Spieler bis Dawnstar Sanctuary

---

`NHV_Q00_030_40` · Veyra · Topic `Veyra_Proposal`

> Well? Am I to stand in your doorway, or be put to work?

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Nur in Dawnstar Sanctuary nach Veyras Rueckkehr

---

`NHV_Q00_030_41` · Spieler · Topic `Veyra_Proposal`

> The Night Mother vouches for you. Welcome to the family.

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Option 1 von 3

---

`NHV_Q00_030_42` · Veyra · Topic `Veyra_Proposal`

> Family. No one has said that word to me in a very long time. Thank you, Listener.

---

`NHV_Q00_030_43` · Spieler · Topic `Veyra_Proposal`

> The Night Mother vouches for you. I don't. Not yet.

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Option 2 von 3

---

`NHV_Q00_030_44` · Veyra · Topic `Veyra_Proposal`

> Then let me earn it. The Mother's word brought me through the door. It needn't put your doubts to rest.

**Notes:** Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_030_45` · Spieler · Topic `Veyra_Proposal`

> Why did you leave Cheydinhal?

**Conditions:** `NHV_Q00_AskedLeave == 1; NHV_Q00_VeyraReturned == 1`

**Notes:** Option 3 von 3, nur wenn Stage-20-Option 2 gewaehlt wurde

---

`NHV_Q00_030_46` · Veyra · Topic `Veyra_Proposal`

> My Dread Father had other work for me. I chose to answer, and it could not wait. Cicero bore the cost of that choice.

**Conditions:** `NHV_Q00_AskedLeave == 1`

**Notes:** Redaktion E23: Veyras Fortgang folgt einem nicht aufschiebbaren Auftrag Sithis'; keine Mitgliedschafts- oder Listenerbehauptung.

---

`NHV_Q00_030_47` · Veyra · Topic `Veyra_Proposal`

> Cicero stayed. The fool stayed. And he was right about one thing: silence still asks to be endured.

**Conditions:** `NHV_Q00_AskedLeave == 1`

**Notes:** Redaktion E23: Cicero hatte mit seinem Bleiben recht; keine automatische Versöhnung.

---

`NHV_Q00_030_48` · Veyra · Topic `Veyra_Proposal`

> Don't tell him I said that. He'd never let me forget it.

**Conditions:** `GetDead Cicero == 0; NHV_Q00_AskedLeave == 1`

**Notes:** Platzhalter-Condition fuer Cicero; zweite Bedingung ergaenzt (lore-editor-Fund 23.09.): Zeile folgt inhaltlich nur auf 030_45-47

---

`NHV_Q00_030_50` · Veyra · Topic `Veyra_Proposal`

> Then hear my proposal.

**Notes:** Unabhaengig von der vorherigen Wahl

---

`NHV_Q00_030_51` · Veyra · Topic `Veyra_Proposal`

> The family is currently two killers, a jester and a horse.

**Conditions:** `GetDead Cicero == 0`

**Notes:** Platzhalter-Condition

---

`NHV_Q00_030_52` · Veyra · Topic `Veyra_Proposal`

> The family is currently two killers and a horse.

**Conditions:** `GetDead Cicero == 1`

**Notes:** Platzhalter-Condition; Alternativzeile falls Cicero tot

---

`NHV_Q00_030_53` · Babette · Topic `Veyra_Proposal`

> I'll have you know I count as at least three killers on my own.

**Notes:** Emotion korrigiert (lore-editor-Fund 23.09.): spielerisches Prahlen statt Aerger, passt zu Babettes Stimme

---

`NHV_Q00_030_54` · Veyra · Topic `Veyra_Proposal`

> The Brotherhood has never posted notices. We watch.

---

`NHV_Q00_030_55` · Veyra · Topic `Veyra_Proposal`

> Across Skyrim there are people who have already crossed the line. Killers who don't yet know they're family.

---

`NHV_Q00_030_56` · Veyra · Topic `Veyra_Proposal`

> I keep a ledger of them.

---

`NHV_Q00_030_75` · Spieler · Topic `Veyra_Proposal`

> And if the right stranger refuses your invitation?

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** NEU 26.09.2026; Nachfrage nach dem Ledger; kein Stage-Wechsel.

---

`NHV_Q00_030_76` · Veyra · Topic `Veyra_Proposal`

> Then the ledger keeps a name and loses a hope. I do not drag souls through a door they choose to leave closed.

**Notes:** NEU 26.09.2026; freiwillige Bindung und Grenzen ihrer Hilfe.

---

`NHV_Q00_030_77` · Veyra · Topic `Veyra_Proposal`

> The Listener decides who is tested. I only notice who has begun to listen.

**Notes:** NEU 26.09.2026; Veyra bleibt Helferin, nicht Aufnahmeinstanz.

---

`NHV_Q00_030_57` · Nazir · Topic `Veyra_Proposal`

> And after Astrid, you want us to open the door to strangers?

---

`NHV_Q00_030_58` · Veyra · Topic `Veyra_Proposal`

> No. I want us to open it to the right strangers.

---

`NHV_Q00_030_59` · Veyra · Topic `Veyra_Proposal`

> Every one of them watched, tested and judged. By the Listener. Not by me.

---

`NHV_Q00_030_60` · Spieler · Topic `Veyra_Proposal`

> Agreed. We rebuild.

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Option 1 von 3 → 030_70; im ESP vorerst: Veyra antwortet direkt mit 030_72/73 (INFO 000845), Fragment → Stage 40; Nazir 030_70/71 folgt als Szene

---

`NHV_Q00_030_61` · Spieler · Topic `Veyra_Proposal`

> What's in it for you?

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Option 2 von 3

---

`NHV_Q00_030_62` · Veyra · Topic `Veyra_Proposal`

> A family. A home that doesn't burn. And one day, perhaps, a name on a wall that someone bothers to remember.

---

`NHV_Q00_030_63` · Spieler · Topic `Veyra_Proposal`

> A test wouldn't have exposed Astrid.

**Conditions:** `NHV_Q00_VeyraReturned == 1`

**Notes:** Option 3 von 3; Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_030_64` · Veyra · Topic `Veyra_Proposal`

> Perhaps not. A test is a beginning. Watch what they do once they believe they've passed.

**Notes:** Redaktion 26.09.2026: Haltung/Subtext vertieft; CSV voraus, Plugin-Abgleich offen.

---

`NHV_Q00_030_70` · Nazir · Topic `Veyra_Proposal`

> ...Contracts are scarce anyway. Fine. She answers to the Listener, and I keep my scimitar sharp.

---

`NHV_Q00_030_71` · Veyra · Topic `Veyra_Proposal`

> I would expect nothing less.

---

`NHV_Q00_030_72` · Veyra · Topic `Veyra_Proposal`

> One more thing. One of your walls is not what it pretends to be. Someone went to considerable trouble over it.

**Notes:** E24: Text ohne Geroell, bereitet 040_12 vor

---

`NHV_Q00_030_73` · Veyra · Topic `Veyra_Proposal`

> If we mean to build a family, we'll need somewhere to put it.

**Notes:** → Stage 40

---

## Stage 40 – Verschleierte Passage

`NHV_Q00_040_01` · Veyra · Topic `SealedPassage`

> Help me with this. Stone remembers pressure better than flesh does.

**Notes:** DEPRECATED (E24: Schleier statt Geroell, ersetzt durch 040_10-12). Am Geroell; Spieler aktiviert Geroell, Zellwechsel in die Deep Sanctuary. Redaktion E23: keine unbestätigte Alters- oder Körpergeschichte.

---

`NHV_Q00_040_03` · Spieler · Topic `SealedPassage`

> You have opened doors like this before?

**Notes:** DEPRECATED (E24: Schleier statt Geroell, ersetzt durch 040_10-12). 

---

`NHV_Q00_040_04` · Veyra · Topic `SealedPassage`

> I have stood before many doors. Opening them is rarely the difficult part.

**Notes:** DEPRECATED (E24: Schleier statt Geroell, ersetzt durch 040_10-12). 

---

`NHV_Q00_040_05` · Veyra · Topic `SealedPassage`

> The difficult part is deciding who should hear what waits beyond.

**Notes:** DEPRECATED (E24: Schleier statt Geroell, ersetzt durch 040_10-12). 

---

`NHV_Q00_040_10` · Veyra · Topic `SCN_VeiledPassage`

> This wall is lying. Stone does not hum like that. A veil, old and patient, over a doorway.

**Notes:** E24: Szene A (NHV_Scn_Q00_02VeiledPassage) an der Wand, Phase 1; ersetzt 040_01, 040_03-05; Urheber des Schleiers bewusst offen

---

`NHV_Q00_040_11` · Nazir · Topic `SCN_VeiledPassage`

> All this time we slept beside it, and the elf finds it first. Wonderful.

**Notes:** Szene A Phase 2

---

`NHV_Q00_040_12` · Veyra · Topic `SCN_VeiledPassage`

> Illusion is my trade, Nazir. Walls that pretend are the easiest to see through. Stand back.

**Notes:** Szene A Phase 3; danach bannt sie die Verschleierung, die Tuer erscheint (Szenenende)

---

## Stage 50 – Deep Sanctuary und Eintritt

`NHV_Q00_050_01` · Veyra · Topic `SCN_DeepSanctuaryEntry`

> Nordic. Older than the sanctuary above. Someone sealed this for a reason.

**Notes:** Szene 2 Phase 1: Veyra prüft die enthüllte Tür.

---

`NHV_Q00_050_08` · Nazir · Topic `SCN_DeepSanctuaryEntry`

> If this place kills us, I am blaming the elf.

**Notes:** Szene 2 Phase 2: Nazir sichert den Durchgang.

---

`NHV_Q00_050_09` · Babette · Topic `SCN_DeepSanctuaryEntry`

> You already blame me for everything else. Let her have a turn.

**Notes:** Szene 2 Phase 2: Babette folgt und stichelt.

---

`NHV_Q00_050_10` · Cicero · Topic `SCN_DeepSanctuaryEntry`

> New halls! New echoes! Cicero approves of the echoes!

**Conditions:** `GetDead Cicero == 0`

**Notes:** Szene 2 Phase 3: nur bei lebendem Cicero.

---

`NHV_Q00_050_11` · Veyra · Topic `SCN_DeepSanctuaryEntry`

> Stay close. Old stone has a talent for making a family feel alone.

**Notes:** Szene 2 Phase 3: Veyra sammelt die Gruppe.

---

`NHV_Q00_050_12` · Spieler · Topic `SCN_DeepSanctuaryEntry`

> Then we enter together.

**Notes:** Szene 2 Phase 4: Spieler bestätigt den gemeinsamen Eintritt.

---

`NHV_Q00_050_13` · Nazir · Topic `SCN_DeepSanctuaryEntry`

> Together, then. Keep your eyes open and your hands where I can see them.

**Notes:** Szene 2 Phase 4: gemeinsame Bewegung zur Tür.

---

`NHV_Q00_050_14` · Babette · Topic `SCN_DeepSanctuaryEntry`

> How touching. Try not to make a habit of it.

**Notes:** Szene 2 Phase 4: gemeinsame Bewegung zur Tür.

---

`NHV_Q00_050_15` · Cicero · Topic `SCN_DeepSanctuaryEntry`

> Cicero will bring the laughter! The dark hates an empty room!

**Conditions:** `GetDead Cicero == 0`

**Notes:** Szene 2 Phase 4: nur bei lebendem Cicero.

---

`NHV_Q00_050_16` · Veyra · Topic `SCN_DeepSanctuaryEntry`

> Let the dark keep its room. We have work to do.

**Notes:** Szene 2 Phase 5: Gruppe überschreitet die Schwelle.

---

`NHV_Q00_050_02` · Veyra · Topic `SealedPassage`

> Well. Now we know the reason.

**Notes:** Nach dem Kampf gegen die Draugr

---

`NHV_Q00_050_03` · Veyra · Topic `SealedPassage`

> A long table. A fire pit. Imagine it full.

**Notes:** Hall of Whispers

---

`NHV_Q00_050_04` · Veyra · Topic `SealedPassage`

> This room will do for me. Quiet walls, a desk, and people who have not learned my habits yet.

**Notes:** Ledger Room; Redaktion E23: freiwilliges Bleiben statt Besitzanspruch.

---

`NHV_Q00_050_05` · Veyra · Topic `SealedPassage`

> Beds for a dozen. If we do this right, we'll need every one. If we fail, dust needs less room.

**Notes:** Initiates' Dormitory

---

`NHV_Q00_050_06` · Veyra · Topic `SealedPassage`

> A builder's record? Read it. I like to know who dug the hole I'm going to die in.

**Notes:** Buch "Builder's Record of the Dawnstar Vaults" aufgehoben

---

## Stage 60 – Memorial und erster Contract

`NHV_Q00_060_01` · Veyra · Topic `Veyra_Memorial`

> Festus. Gabriella. Arnbjorn. Veezara. I'll carve their names myself.

---

`NHV_Q00_060_74` · Spieler · Topic `Veyra_Memorial`

> You knew them all?

---

`NHV_Q00_060_75` · Veyra · Topic `Veyra_Memorial`

> I know their names. That is enough to begin.

**Notes:** Redaktion E23: Erinnerung ohne erfundene intime Biografie.

---

`NHV_Q00_060_76` · Veyra · Topic `Veyra_Memorial`

> The dead cannot correct a story. That is why I keep mine small.

**Notes:** Redaktion E23: Veyra bleibt fehlbar und begrenzt.

---

`NHV_Q00_060_77` · Nazir · Topic `Veyra_Memorial`

> You plan to fill this wall before we fill the beds.

**Notes:** Nachfrage nach der Memorial-Wahl.

---

`NHV_Q00_060_78` · Veyra · Topic `Veyra_Memorial`

> The wall is for those we lost. The beds are for those we may yet find.

---

`NHV_Q00_060_79` · Babette · Topic `Veyra_Memorial`

> Fill the beds, then. I have had quite enough of empty chairs.

**Notes:** Nur wenn Babette in der Sanctuary anwesend ist.

---

`NHV_Q00_060_80` · Veyra · Topic `Veyra_Memorial`

> A mess can be cleaned. An empty room is more stubborn.

---

`NHV_Q00_060_02` · Veyra · Topic `Veyra_Memorial`

> And Cicero. I owed the Keeper more than a chisel. It's all I have left to give.

**Conditions:** `GetDead Cicero == 1`

---

`NHV_Q00_060_03` · Veyra · Topic `Veyra_Memorial`

> And Astrid? She led them. She also sold them. Your call, Listener.

---

`NHV_Q00_060_10` · Spieler · Topic `Veyra_Memorial`

> Carve her name with the others.

**Conditions:** `NHV_AstridMemorial == 0`

**Notes:** Option 1 von 3 → NHV_AstridMemorial = 1

---

`NHV_Q00_060_11` · Veyra · Topic `Veyra_Memorial`

> Mercy for the dead. The dead rarely deserve it, but they never complain.

---

`NHV_Q00_060_20` · Spieler · Topic `Veyra_Memorial`

> Leave her off.

**Conditions:** `NHV_AstridMemorial == 0`

**Notes:** Option 2 von 3 → NHV_AstridMemorial = 2

---

`NHV_Q00_060_21` · Veyra · Topic `Veyra_Memorial`

> Forgotten, then. The Void will remember her. We needn't.

---

`NHV_Q00_060_30` · Spieler · Topic `Veyra_Memorial`

> Carve it beneath the others. Smaller.

**Conditions:** `NHV_AstridMemorial == 0`

**Notes:** Option 3 von 3 → NHV_AstridMemorial = 3

---

`NHV_Q00_060_31` · Veyra · Topic `Veyra_Memorial`

> Remembered, but not honored. I like the way you think.

---

`NHV_Q00_060_40` · Nazir · Topic `Nazir_Memorial`

> You carved her name. You're a better person than me, Listener. That's not a compliment.

**Conditions:** `NHV_AstridMemorial == 1`

**Notes:** Einmalig nach Stage 60 im Sanctuary

---

`NHV_Q00_060_41` · Nazir · Topic `Nazir_Memorial`

> Good. Let the Void have her. We have enough ghosts.

**Conditions:** `NHV_AstridMemorial == 2`

**Notes:** Einmalig

---

`NHV_Q00_060_42` · Nazir · Topic `Nazir_Memorial`

> Small letters, low on the stone. Fitting. I'd have used a smaller chisel.

**Conditions:** `NHV_AstridMemorial == 3`

**Notes:** Einmalig

---

`NHV_Q00_060_60` · Veyra · Topic `Veyra_FirstContract`

> Before Falkreath burned, the Night Mother heard a prayer from Hjaalmarch. A Black Sacrament.

---

`NHV_Q00_060_61` · Veyra · Topic `Veyra_FirstContract`

> No one answered it. There was no one left to answer.

---

`NHV_Q00_060_62` · Veyra · Topic `Veyra_FirstContract`

> Let's find out what became of the one who performed it.

---

`NHV_Q00_060_63` · Veyra · Topic `Veyra_FirstContract`

> Take my ledger. Everything I know about our first candidate is in there. Try not to bleed on it.

**Notes:** Gibt "The Gleaner's Ledger" (I) → Stage 100, Q01 startet

---

`NHV_Q00_060_70` · Spieler · Topic `Veyra_FirstContract`

> What about the initiates who are already here?

**Notes:** Optional, nur wenn Vanilla-Initiates in der Sanctuary vorhanden sind

---

`NHV_Q00_060_71` · Veyra · Topic `Veyra_FirstContract`

> They found the door by luck, not judgment. Luck is a fine thing. Judgment lasts longer.

**Notes:** Konzept/Skript schreibt "judgement" (britisch) an einer Stelle; auf amerikanische Schreibweise korrigiert (E12, docs/DIALOGUE.md)

---

`NHV_Q00_060_72` · Veyra · Topic `Veyra_FirstContract`

> I'll keep an eye on them.

---

## Q00-Journalziele

`NHV_Q00_010_90` · Stage 10

> Find out who has entered the Sanctuary.

**Notes:** Quest-Start per Story Manager; Zaehlung verschoben, weil dialogue/Q00.csv Stage 10 jetzt bis 010_73 reicht. Quest-Log-Text: "Someone has walked through the Black Door without an invitation. Nazir has a blade at her throat."

---

`NHV_Q00_015_22` · Stage 15

> Veyra has left the Sanctuary.

**Notes:** Uebergangsstufe nach dem Standoff. Quest-Log-Text: "Veyra left the Sanctuary and will wait at the Windpeak Inn while I ask the Night Mother to judge her."

---

`NHV_Q00_020_41` · Stage 20

> Consult the Night Mother about Veyra.

**Notes:** Fortsetzung der Sequenz aus Q00.csv Stage 20 (bis 40 dort). Quest-Log-Text: "The stranger calls herself Veyra Othren, the Gleaner. She asked me to let the Night Mother judge her."

---

`NHV_Q00_030_74` · Stage 30

> Return to Veyra at the Windpeak Inn.

**Notes:** Fortsetzung der Sequenz aus Q00.csv Stage 30; erst Veyra im Windpeak Inn holen, danach Proposal in der Sanctuary. Quest-Log-Text: "The Night Mother spoke for the Gleaner. It is my choice what to do with her."

---

`NHV_Q00_040_02` · Stage 40

> Open the sealed passage with Veyra.

**Notes:** Fortsetzung der Sequenz aus Q00.csv Stage 40 (bis 01 dort). Quest-Log-Text: "Veyra wants to rebuild the family with killers she has been watching across Skyrim. First, she wants to open a passage hidden behind a wall that is not a wall."

---

`NHV_Q00_050_07` · Stage 50

> Explore the Deep Sanctuary.

**Notes:** Fortsetzung der Sequenz aus Q00.csv Stage 50 (bis 06 dort). Quest-Log-Text: "Behind the veil lies an old Nordic vault, far older than the Sanctuary. It was not empty."

---

`NHV_Q00_060_73` · Stage 60

> Decide whose names belong on the Memorial Wall.

**Notes:** Fortsetzung der Sequenz aus Q00.csv Stage 60 (bis 72 dort, hoechste Nummer aus Veyra_FirstContract). Quest-Log-Text: "Veyra means to carve the names of the fallen into a wall of the Deep Sanctuary. She asked me about Astrid."

---

`NHV_Q00_100_01` · Stage 100

> Find out what became of the one who performed the sacrament.

**Notes:** Keine Dialogzeilen fuer Stage 100 in Q00.csv (Uebergang direkt zu Q01), daher Sequenz 01. Text korrigiert (lore-editor-Fund 23.09.): urspruengliches Ziel verwies auf das Ledger-Gespraech, das bereits in Stage 60 (060_60-63) erledigt ist; neuer Text fuehrt organisch zu NHV_Q01_010_01. Quest-Log-Text: "Veyra told me of a Black Sacrament performed in Hjaalmarch that no one answered."

---
