# Q03 Enhanced - Lesefassung

Diese Fassung ist ein inaktiver Enhanced-Draft. Q03-V2 und der aktive Master bleiben unverändert.

## Stage 10 - Ein neuer Name im Ledger

### `NHV_Q03_010_4000` - Veyra - Topic `V2_start`

> Winterhold has been losing travelers on the road. The last report names an Altmer scholar, Nirelda Aurantil.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4001` - Veyra - Topic `V2_start`

> Begin with the College. An old expulsion record may tell you whether the tower is rumor or refuge.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- I'll ask the College for her record. -> `urag`
- What do you expect me to find? -> `brief`

## Stage 10 - Die Untersuchung bleibt offen

### `NHV_Q03_010_4004` - Veyra - Topic `V2_brief`

> A rival died in a magical accident. That is a description, not a verdict.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4005` - Veyra - Topic `V2_brief`

> Find out what she studied, and what the road has been paying for it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `urag`.


## Stage 10 - Urag hütet die Akten

### `NHV_Q03_010_4006` - Urag - Topic `V2_urag`

> Aurantil. That file stays sealed unless you give me a reason worth the ink.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4007` - Urag - Topic `V2_urag`

> Travelers are dying on the Winterhold road. That is not yet proof she did it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- (Persuade) The road is becoming a graveyard. -> `persuade_record`
- (Bribe) Perhaps the Arcanaeum could use a donation. -> `bribe_record`
- I am the Arch-Mage. Give me the record. -> `archmage_record`
- Then I will find another lead. -> `widow`

## Stage 10 - Überzeugung statt Autoritätsbehauptung

**Direction:** Der echte Speech-Check wird später im CK umgesetzt.

- World event: Speech check succeeds -> `record`
- World event: Speech check fails -> `record_fail`

## Stage 10 - Ein Fehlschlag verschließt nur diese Tür

### `NHV_Q03_010_4012` - Urag - Topic `V2_record_fail`

> Then bring me something less convenient than suspicion. The widow in town may have it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4013` - Urag - Topic `V2_record_fail`

> The file remains here. Your dead do not become evidence because you are angry.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `selveni`.


## Stage 10 - Eine Zahlung öffnet den Aktenschrank

### `NHV_Q03_010_4014` - Urag - Topic `V2_bribe_record`

> Gold is a language the College pretends not to speak. Take the record, and return it without blood.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `record`.


## Stage 10 - Der Arch-Mage erhält die Akte

### `NHV_Q03_010_4015` - Urag - Topic `V2_archmage_record`

> Of course, Arch-Mage. Try not to become a chapter in it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4016` - Urag - Topic `V2_archmage_record`

> The file concerns an accident, not a confession. Remember that distinction.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `record`.


## Stage 10 - Die Disziplinarakte ist widersprüchlich

### `NHV_Q03_010_4017` - Urag - Topic `V2_record`

> Nirelda Aurantil was expelled eleven years ago. Her rival died during a destructive experiment.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4018` - Urag - Topic `V2_record`

> The statements disagree about intent. The College filed the uncertainty and called it closure.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- What does the file say about her tower? -> `record_tower`
- Who else saw the accident? -> `record_witness`
- I'll take the uncertainty with me. -> `widow`

## Stage 10 - Ein Ort und noch keine Schuld

### `NHV_Q03_010_4022` - Urag - Topic `V2_record_tower`

> Hollowfrost Spire. A private tower on the tundra. The College has no claim there now.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4023` - Urag - Topic `V2_record_tower`

> If she is still alive, she may prefer the cold to another hearing.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `selveni`.


## Stage 10 - Die Akte bleibt unvollständig

### `NHV_Q03_010_4024` - Urag - Topic `V2_record_witness`

> Students, a master, and one apprentice who changed her account twice.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_010_4025` - Urag - Topic `V2_record_witness`

> No sentence in that file tells you what happened inside her head.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `selveni`.


## Stage 20 - Thyra erzählt vom fehlenden Heimweg

### `NHV_Q03_020_4000` - Thyra - Topic `V2_widow`

> My Brandr took the south road to Dawnstar. His horse came home. He did not.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_020_4001` - Thyra - Topic `V2_widow`

> Some nights there is a light on the tundra. Hollowfrost Spire, they call it. Nobody honest lives there.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Did Brandr ever meet Nirelda? -> `widow_nirelda`
- I'll find the tower. -> `road`

## Stage 20 - Ein Zeugenbericht, kein Monsterbeweis

### `NHV_Q03_020_4004` - Thyra - Topic `V2_widow_nirelda`

> He said a woman asked about the color of his blood. He thought she was a healer until she stopped listening.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_020_4005` - Thyra - Topic `V2_widow_nirelda`

> That is all I know. Do not turn my grief into a story that makes you brave.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `road`.


## Stage 20 - Der Weg zum Turm

### `NHV_Q03_020_4006` - Veyra - Topic `V2_tower`

> The record and the widow point to one place. Hollowfrost Spire is not a verdict. It is where your questions become dangerous.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- World event: Zum Hollowfrost Spire reisen -> `defenses`

## Stage 30 - The Four Stillnesses

### `NHV_Q03_030_4000` - Nirelda - Topic `V2_defenses`

> Frost. Poison. Blade. Silence. Four ways for a body to stop arguing with the world.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_030_4001` - Nirelda - Topic `V2_defenses`

> You may solve the order, or show me what you do when a door refuses to open.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Use the notes to set the four pillars. -> `pillars_notes`
- Force the mechanism with fire. -> `pillars_force`
- Disarm the runes by hand. -> `pillars_careful`

## Stage 30 - Notizen lesen statt Opfer nachspielen

### `NHV_Q03_030_4005` - Nirelda - Topic `V2_pillars_notes`

> You read before touching. A modest virtue. The order is frost, venom, blade, silence.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_030_4006` - Nirelda - Topic `V2_pillars_notes`

> The door opens. Do not mistake comprehension for permission.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `resonance`.


## Stage 30 - Feuer gegen eine Feuergelehrte

### `NHV_Q03_030_4007` - Nirelda - Topic `V2_pillars_force`

> A destructive solution. Efficient, loud, and careless with the structure.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_030_4008` - Nirelda - Topic `V2_pillars_force`

> The order was written in the margins. You could have read it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `resonance`.


## Stage 30 - Vorsicht ist keine Feigheit

### `NHV_Q03_030_4009` - Nirelda - Topic `V2_pillars_careful`

> You disarm the runes one pin at a time. Patience is a form of knowledge, I suppose.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_030_4010` - Nirelda - Topic `V2_pillars_careful`

> The tower admits you. I will adjust my notes.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `resonance`.


## Stage 40 - Nirelda beobachtet einen Sterbenden

### `NHV_Q03_040_4000` - Joric - Topic `V2_observation`

> Help me... please...

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4001` - Nirelda - Topic `V2_observation`

> Do not touch him. He is almost finished. I need the exact moment.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4002` - Nirelda - Topic `V2_observation`

> You have entered my tower. Now you are another variable.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Heal the traveler. -> `heal`
- Let him die and watch Nirelda's notes. -> `let_die`
- Step between them and end the observation. -> `interrupt`

## Stage 40 - Mitleid verändert ihren Versuch

### `NHV_Q03_040_4006` - Nirelda - Topic `V2_heal`

> You ruined eleven days of observation. And yet the man is breathing.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4007` - Nirelda - Topic `V2_heal`

> Mercy is not a measurement. That may be why it interests me.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `consent_ledger`.


## Stage 40 - Beobachten heißt nicht verstehen

### `NHV_Q03_040_4008` - Nirelda - Topic `V2_let_die`

> There. The pupils change before the breath ends. Did you see it?

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4009` - Nirelda - Topic `V2_let_die`

> You watched a person become a note. You may regret how familiar that feels.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `consent_ledger`.


## Stage 40 - Der Listener setzt eine Grenze

### `NHV_Q03_040_4010` - Nirelda - Topic `V2_interrupt`

> You interrupt the observation without healing him. An inelegant mercy.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4011` - Nirelda - Topic `V2_interrupt`

> Still, you chose a limit. That is data of a sort.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `consent_ledger`.


## Stage 40 - Nirelda stellt die Bedingungen

### `NHV_Q03_040_4012` - Nirelda - Topic `V2_question_intro`

> You call yourselves servants of the dark. I call you a household with knives.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_040_4013` - Nirelda - Topic `V2_question_intro`

> Answer two questions honestly. I will hear what you offer. Fail, and I will test your last breath instead.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam`.


## Stage 50 - Nireldas Prüfung des Listeners

- The Void is a belief, not a fact I can prove. -> `q1_uncertain`
- We serve Sithis. We do not own what comes after death. -> `q1_service`
- I do not know what waits. I know why I choose. -> `q1_choice`

## Stage 50 - Eine ehrliche Grenze

### `NHV_Q03_050_4003` - Nirelda - Topic `V2_q1_uncertain`

> Good. You have not dressed uncertainty as a theorem. One point, perhaps.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam2`.


## Stage 50 - Dienst ohne Allwissenheit

### `NHV_Q03_050_4004` - Nirelda - Topic `V2_q1_service`

> A creed and a boundary. Better than certainty. One point.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam2`.


## Stage 50 - Verantwortung statt kosmischer Behauptung

### `NHV_Q03_050_4005` - Nirelda - Topic `V2_q1_choice`

> Choice is observable. Motive is less so. I will count the answer.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam2`.


## Stage 50 - Die zweite Frage

### `NHV_Q03_050_4006` - Nirelda - Topic `V2_exam2`

> Why kill when study would leave the subject intact?

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Because study without consent is already a kind of taking. -> `q2_consent`
- For gold. -> `q2_gold`
- Because killing is honest. -> `q2_honest`

## Stage 50 - Grenzen der Forschung

### `NHV_Q03_050_4010` - Nirelda - Topic `V2_q2_consent`

> Consent. An inconvenient variable. Two points.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam3`.


## Stage 50 - Ein ehrlicher, aber dünner Grund

### `NHV_Q03_050_4011` - Nirelda - Topic `V2_q2_gold`

> Mercenary. Honest, perhaps. Not sufficient.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam3`.


## Stage 50 - Tod als bloße Klarheit

### `NHV_Q03_050_4012` - Nirelda - Topic `V2_q2_honest`

> A clean answer can still be a lazy one.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam3`.


## Stage 50 - Die letzte Frage

### `NHV_Q03_050_4013` - Nirelda - Topic `V2_exam3`

> What would your family make of me?

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- A sister, if you accept limits. -> `q3_sister`
- A tool, useful until it is not. -> `q3_tool`
- A subject for the Arcanum. -> `q3_subject`

## Stage 50 - Eine Einladung mit Bedingung

### `NHV_Q03_050_4017` - Nirelda - Topic `V2_q3_sister`

> Limits. I have not enjoyed them since Alinor. A useful answer.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam_result`.


## Stage 50 - Nützlichkeit ist kein Vertrag

### `NHV_Q03_050_4018` - Nirelda - Topic `V2_q3_tool`

> A clear answer. It does not make me want to kneel.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam_result`.


## Stage 50 - Der Listener dreht die Forschung zurück

### `NHV_Q03_050_4019` - Nirelda - Topic `V2_q3_subject`

> You would make a specimen of me. At least you admit it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `exam_result`.


## Stage 50 - Die Prüfung endet mit Nireldas Wahl

Continue: `exam_passed`.


## Stage 50 - Freiwilliges Unterordnen

### `NHV_Q03_050_4020` - Nirelda - Topic `V2_exam_passed`

> Very well. I will come and study your family, provided I may be corrected.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_050_4021` - Nirelda - Topic `V2_exam_passed`

> That is the closest thing to surrender I have offered in years.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `correspondence`.


## Stage 50 - Feuer statt Zustimmung

**Direction:** Combat simulation; Nirelda is a master Destruction fire battle-mage. A kill is not required or intended.

### `NHV_Q03_050_4022` - Nirelda - Topic `V2_exam_failed`

> You have answers. I have not heard a reason to trust the hands holding them.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_050_4023` - Nirelda - Topic `V2_exam_failed`

> Let us see whether your magic is more precise than your ethics.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- World event: Fight until Nirelda yields -> `combat`

## Stage 50 - Nirelda yields at the edge of defeat

### `NHV_Q03_050_4024` - Nirelda - Topic `V2_combat`

> Enough. Your strength is clearer than your answers. I yield. I will come, but I will not call that agreement.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `correspondence`.


## Stage 60 - Die Korrespondenz wird nach der Prüfung gelesen

### `NHV_Q03_060_4000` - Nirelda - Topic `V2_correspondence`

> The letter concerns a poison called Whisperbane. The buyer signed only with the initials L.M.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_060_4001` - Nirelda - Topic `V2_correspondence`

> Two doses. An old woman and a Redguard in the north. I thought it was a family quarrel.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### Found item: `NHV_Q03_060_6000` - V2_WhisperbaneLetter

> ORDER: WHISPERBANE\n\nTwo doses. One for the old woman, one for the Redguard. Payment in Imperial gold. Sign only L.M.

- You were paid to poison my family. -> `poison_reveal`
- You did not know who the doses were for. -> `poison_limit`

## Stage 60 - Die persönliche Gefahr wird konkret

### `NHV_Q03_060_4004` - Nirelda - Topic `V2_poison_reveal`

> Your family? Then my research has acquired a very inconvenient audience.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_060_4005` - Nirelda - Topic `V2_poison_reveal`

> I sold a method, not a target. The distinction is suddenly less comfortable.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `dead_drop`.


## Stage 60 - Wissen und Verantwortung bleiben getrennt

### `NHV_Q03_060_4006` - Nirelda - Topic `V2_poison_limit`

> I knew the doses, not the faces. Ignorance is not innocence, but it is not intent either.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `dead_drop`.


## Stage 70 - Nireldas Zukunft bleibt eine Entscheidung

### `NHV_Q03_070_4000` - Nirelda - Topic `V2_judgment`

> Laboratory, exile, or grave? You have turned my own question back toward me.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_070_4001` - Nirelda - Topic `V2_judgment`

> The poison was meant for your family. Decide what you will do with the woman who made it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Come to Dawnstar. You may build an Arcanum under our rules. -> `recruit`
- Take her back to the College. -> `college`
- Tolfdir has agreed to receive her. -> `college`
- Leave Skyrim and take your research with you. -> `release`
- Your research ends here. -> `silence`

## Stage 70 - Aufnahme mit Grenzen

### `NHV_Q03_070_4006` - Nirelda - Topic `V2_recruit`

> An invitation with conditions. Accepted. I will need shelves, fireproof tables, and permission before I open anything.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_070_4007` - Nirelda - Topic `V2_recruit`

> Do not mistake curiosity for obedience. I am choosing the arrangement.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `return`.


## Stage 70 - Übergabe an das College

### `NHV_Q03_070_4008` - Nirelda - Topic `V2_college`

> Back to the College, to be judged by people who faint at a nosebleed.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_070_4009` - Nirelda - Topic `V2_college`

> Very well. Let them decide whether an exile is more dangerous than a fire.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `return`.


## Stage 70 - Freilassung aus Skyrim

### `NHV_Q03_070_4010` - Nirelda - Topic `V2_release`

> Exile again. At least this time I choose the direction.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_070_4011` - Nirelda - Topic `V2_release`

> I will leave the poison behind. The questions are mine to carry.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `return`.


## Stage 70 - Das Ende der Forschung

**Direction:** Der Todesausgang wird erst durch den Weltvorgang bestätigt. Kein toter NPC spricht danach.

### `NHV_Q03_070_4012` - Nirelda - Topic `V2_silence`

> All that knowledge, and you still prefer a closed book.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- World event: Weltvorgang: Nirelda stirbt -> `dead`

## Stage 100 - Nireldas Tod bestätigt

Continue: `return`.


## Stage 100 - Bericht in der Sanctuary

**Direction:** Alle Ausgänge führen zum Debrief; nur Recruit schaltet das Arcanum frei.

- World event: Nach Dawnstar zurückkehren und Veyra Bericht erstatten -> `report`

## Stage 100 - Der Listener berichtet den Ausgang

- Nirelda joined us. She yielded after the fight. -> `debrief_recruit`
- Nirelda joined us after the examination. -> `debrief_recruit`
- I handed Nirelda to the College. -> `debrief_college`
- Nirelda left Skyrim. -> `debrief_release`
- Nirelda is dead. -> `debrief_dead`

## Stage 100 - Veyras Urteil über die Feuergelehrte

### `NHV_Q03_100_4005` - Veyra - Topic `V2_debrief_recruit`

> She accepted a boundary after trying to burn through it. Make sure the Arcanum has doors, not only shelves.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4006` - Veyra - Topic `V2_debrief_recruit`

> Her fire is a discipline. Her curiosity is not a license.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `debrief_fragment`.


## Stage 100 - Missbilligung ohne große Rede

### `NHV_Q03_100_4007` - Veyra - Topic `V2_debrief_college`

> The College may call that justice. It may also call it convenient. Your choice is recorded.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4008` - Veyra - Topic `V2_debrief_college`

> The Arcanum will wait for another mind.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `debrief_fragment`.


## Stage 100 - Freilassung mit offener Forschung

### `NHV_Q03_100_4009` - Veyra - Topic `V2_debrief_release`

> She leaves with questions and without our walls. That is safer for some people, and lonelier for her.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4010` - Veyra - Topic `V2_debrief_release`

> Do not confuse distance with an answer.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `debrief_fragment`.


## Stage 100 - Verlust ohne Verklärung

### `NHV_Q03_100_4011` - Veyra - Topic `V2_debrief_dead`

> A waste. Knowledge does not make a death less final.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4012` - Veyra - Topic `V2_debrief_dead`

> We will remember the question, not pretend we solved it.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `debrief_fragment`.


## Stage 100 - Fragment drei wird eingeordnet

Continue: `fragment`.


## Stage 100 - L.M. ist eine Spur, kein vollständiger Name

### `NHV_Q03_100_4013` - Veyra - Topic `V2_fragment`

> L.M. ordered poison for an old woman and a Redguard. Their deaths were meant to look natural.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4014` - Veyra - Topic `V2_fragment`

> Keep the letter with the earlier fragments. A pattern can be deliberate without being understood.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- Does this identify the hand behind it? -> `fragment_limit`
- Then the next contract may be watched too. -> `fragment_watch`
- Keep it in the ledger. -> `finish`

## Stage 100 - Keine vorzeitige Enthüllung

### `NHV_Q03_100_4018` - Veyra - Topic `V2_fragment_limit`

> It gives us initials and a method. Names require more than suspicion.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `fragment`.


## Stage 100 - Vorsicht für den nächsten Contract

### `NHV_Q03_100_4019` - Veyra - Topic `V2_fragment_watch`

> Assume the road is being watched. Do not let caution become paralysis.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

Continue: `fragment`.


## Stage 100 - Q03 abgeschlossen

- World event: Lesetest abschließen -> `finished`
- World event: Nirelda im Arcanum begrüßen -> `home`

## Stage 100 - Nirelda beginnt im Arcanum

### `NHV_Q03_100_4020` - Nirelda - Topic `V2_home`

> The room is smaller than my tower. The questions are better.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

### `NHV_Q03_100_4021` - Nirelda - Topic `V2_home`

> I will ask before I experiment. You may quote me on that.

**Notes:** Enhanced draft; inherited Q03 V2 baseline. CK conditions remain to be wired.

- World event: Lesetest abschließen -> `finished`

## Stage 100 - Ende des Q03-Lesetests


## Stage 15 - Eine College-Zeugin ergänzt die Akte

### `NHV_Q03_015_4200` - Selveni - Topic `Enhanced_Selveni`

> You are asking about Aurantil? Read the margin, too.

**Notes:** New College witness; no Vanilla record change.

### `NHV_Q03_015_4201` - Player - Topic `Enhanced_Selveni`

> You signed one of these statements.

- What did you see after the blast? -> `selveni_accident`
- Why did your account change? -> `selveni_changed`
- I have enough. Keep your margin. -> `widow`

## Stage 15 - Die erste Zeugenaussage

### `NHV_Q03_015_4205` - Selveni - Topic `Enhanced_Selveni`

> I was an apprentice. I saw smoke, a broken focus crystal, and Nirelda pulling me clear.

### `NHV_Q03_015_4206` - Selveni - Topic `Enhanced_Selveni`

> The master wanted certainty. I had only a room full of witnesses who remembered different fire.

Continue: `selveni_copy`.


## Stage 15 - Die Aussage, die sich veränderte

### `NHV_Q03_015_4207` - Selveni - Topic `Enhanced_Selveni`

> She chose a person before she chose an explanation. I have never forgiven her for making that difficult.

### `NHV_Q03_015_4208` - Selveni - Topic `Enhanced_Selveni`

> The margin is a copy, not a verdict. It still names the focus crystal and the first witness.

Continue: `selveni_copy`.


## Stage 15 - Eine Kopie ohne Urteil

- Give me the copied margin. -> `selveni_take`
- Leave it here. The College can keep its own doubt. -> `selveni_leave`

## Stage 15 - Die Randnotiz wird gesichert

### `NHV_Q03_015_4211` - Selveni - Topic `Enhanced_Selveni`

> Take it. Return it if the College asks what you learned.

### Found item: `NHV_Q03_015_6150` - Enhanced_CollegeMargin

> COLLEGE MARGIN
> 
> The focus crystal failed before the second flare. Aurantil pulled Selveni clear. Three witnesses called it an accident; none agreed on who lit the room. The file closes around the uncertainty.

Continue: `widow`.


## Stage 15 - Die Randnotiz bleibt im College

### `NHV_Q03_015_4212` - Selveni - Topic `Enhanced_Selveni`

> Then take the road with only Urag's version. It is safer for the College.

Continue: `widow`.


## Stage 25 - Die verlassene Wegstation

### `NHV_Q03_025_4250` - Player - Topic `Enhanced_Roadside`

> The south road has a cold silence to it. Search the waystation.

### `NHV_Q03_025_4251` - RoadSurvivor - Topic `Enhanced_Roadside`

> Do not go to the tower. The woman with the fire was not taking coin.

- Treat the survivor first. -> `road_aid`
- Inspect the burned pack. -> `road_pack`
- Follow the scorch marks. -> `road_tracks`

## Stage 25 - Der Überlebende

### `NHV_Q03_025_4255` - RoadSurvivor - Topic `Enhanced_RoadsideAid`

> The frost took my brother. She measured his breath until the fire went out.

### `NHV_Q03_025_4256` - Player - Topic `Enhanced_RoadsideAid`

> You are alive. Tell the College what you saw when you can.

Continue: `road_resolved`.


## Stage 25 - Der verbrannte Rucksack

### `NHV_Q03_025_4257` - Player - Topic `Enhanced_RoadsidePack`

> The pack is burned from the inside. No coin was taken.

### `NHV_Q03_025_4258` - RoadSurvivor - Topic `Enhanced_RoadsidePack`

> Take the token. It was my brother's. Nirelda took nothing else.

Continue: `road_resolved`.


## Stage 25 - Die verklingenden Spuren

### `NHV_Q03_025_4259` - Player - Topic `Enhanced_RoadsideTracks`

> The scorch marks stop where the snow begins. Someone wanted the trail to end.

### `NHV_Q03_025_4260` - RoadSurvivor - Topic `Enhanced_RoadsideTracks`

> The light moved uphill. I never saw a face, only a hand bright with fire.

Continue: `road_resolved`.


## Stage 25 - Die Spur zum Turm

### `NHV_Q03_025_4261` - Veyra - Topic `Enhanced_RoadsideResolved`

> A witness, a token, and a road that refuses to name its dead.

Continue: `tower`.


## Stage 35 - Die Resonanzkammer

### `NHV_Q03_035_4350` - Nirelda - Topic `Enhanced_Resonance`

> The pillars open the first chamber. The second responds to what you carry.

- Use Selveni's focus fragment. -> `resonance_fragment`
- Break the chamber before it can test us. -> `resonance_break`
- Wait and watch the mechanism. -> `resonance_wait`

## Stage 35 - Der Fokus erinnert sich

### `NHV_Q03_035_4354` - Nirelda - Topic `Enhanced_ResonanceFragment`

> You brought a fragment from the College. It remembers the shape of my first mistake.

### `NHV_Q03_035_4357` - Nirelda - Topic `Enhanced_ResonanceEnd`

> The frostfire ward is quiet. Continue, but do not touch the empty crystal cradle.

### Found item: `NHV_Q03_035_6350` - Enhanced_FrostfireNote

> FROSTFIRE WARD
> 
> The ward responds to carried evidence. A fragment remembers the hand that broke it. Fire opens nothing by force alone; patience leaves fewer burns.

Continue: `observation`.


## Stage 35 - Feuer ist kein Schlüssel

### `NHV_Q03_035_4355` - Nirelda - Topic `Enhanced_ResonanceBreak`

> Fire is not a key merely because I wield it.

### `NHV_Q03_035_4357` - Nirelda - Topic `Enhanced_ResonanceEnd`

> The frostfire ward is quiet. Continue, but do not touch the empty crystal cradle.

Continue: `observation`.


## Stage 35 - Geduld im Frostfeuer

### `NHV_Q03_035_4356` - Nirelda - Topic `Enhanced_ResonanceWait`

> Patience gives the tower time to decide whether you are worth the stairs.

### `NHV_Q03_035_4357` - Nirelda - Topic `Enhanced_ResonanceEnd`

> The frostfire ward is quiet. Continue, but do not touch the empty crystal cradle.

Continue: `observation`.


## Stage 45 - Das Einverständnis im Ledger

### `NHV_Q03_045_4450` - Player - Topic `Enhanced_ConsentLedger`

> Before we continue, show me the names in your ledger.

### `NHV_Q03_045_4451` - Nirelda - Topic `Enhanced_ConsentLedger`

> Names, dates, responses. I released three subjects when they asked. I kept the others when they did not.

- Read the page marked 'refused'. -> `consent_refusal`
- You wrote down consent after the fact. -> `consent_after`
- Close the ledger. -> `consent_close`

## Stage 45 - Eine leere Seite

### `NHV_Q03_045_4453` - Nirelda - Topic `Enhanced_ConsentRefusal`

> The page is blank. I could not make a measurement from a refusal.

Continue: `question_intro`.


## Stage 45 - Ein verspätetes Verständnis

### `NHV_Q03_045_4455` - Nirelda - Topic `Enhanced_ConsentAfter`

> I wrote down the moment I understood that consent changes the experiment.

Continue: `question_intro`.


## Stage 45 - Eine gesetzte Grenze

### `NHV_Q03_045_4457` - Nirelda - Topic `Enhanced_ConsentClose`

> A boundary without an explanation is still a boundary. You keep surprising me.

Continue: `question_intro`.


## Stage 65 - Der falsche Boden

### `NHV_Q03_065_4650` - Player - Topic `Enhanced_DeadDrop`

> The letter was hidden behind a false panel.

### `NHV_Q03_065_4651` - Nirelda - Topic `Enhanced_DeadDrop`

> A countermark. L.M. sent it through another hand.

### Found item: `NHV_Q03_065_6650` - Enhanced_Countermark

> COUNTERMARK
> 
> A black seal pressed into wax. No name, no office, only a route and a payment mark. The hand that orders a death need not stand near the body.

- Keep the seal with the fragments. -> `dead_drop_keep`
- Burn the seal. It teaches us nothing yet. -> `dead_drop_burn`

## Stage 65 - Das Siegel bleibt im Ledger

### `NHV_Q03_065_4654` - Nirelda - Topic `Enhanced_DeadDropKeep`

> It teaches you that distance can be part of a murder.

Continue: `judgment`.


## Stage 65 - Das Siegel wird verbrannt

### `NHV_Q03_065_4655` - Player - Topic `Enhanced_DeadDropBurn`

> Then we keep the distance in mind.

Continue: `judgment`.


## Journal variants

### Stage 10 - `NHV_Q03_010_5000` - V2_JournalObjective

> Learn why Nirelda Aurantil was expelled from the College.

### Stage 10 - `NHV_Q03_010_5001` - V2_JournalLog

> Veyra sent you to investigate an expelled Altmer and travelers who never reached Winterhold.

### Stage 20 - `NHV_Q03_020_5002` - V2_JournalObjective

> Find Hollowfrost Spire.

### Stage 20 - `NHV_Q03_020_5003` - V2_JournalLog

> The College record and Thyra's grief point toward a tower on the tundra.

### Stage 30 - `NHV_Q03_030_5004` - V2_JournalObjective

> Pass the Four Stillnesses.

### Stage 30 - `NHV_Q03_030_5005` - V2_JournalLog

> Nirelda's defenses measure how you react. The order can be learned without repeating her experiments.

### Stage 40 - `NHV_Q03_040_5006` - V2_JournalObjective

> Find Nirelda.

### Stage 40 - `NHV_Q03_040_5007` - V2_JournalLog

> Nirelda is observing Joric's last breath. Your response becomes part of her evidence.

### Stage 50 - `NHV_Q03_050_5008` - V2_JournalObjective

> Pass Nirelda's examination, or survive it.

### Stage 50 - `NHV_Q03_050_5009` - V2_JournalLog

> Nirelda will hear the Brotherhood only if you answer for your service and its limits.

### Stage 60 - `NHV_Q03_060_5010` - V2_JournalObjective

> Search Nirelda's correspondence.

### Stage 60 - `NHV_Q03_060_5011` - V2_JournalLog

> A poison order signed L.M. connects her research to a threat against the family.

### Stage 70 - `NHV_Q03_070_5012` - V2_JournalObjective

> Decide Nirelda's fate.

### Stage 70 - `NHV_Q03_070_5013` - V2_JournalLog

> Nirelda's knowledge does not decide her place. You do.

### Stage 100 - `NHV_Q03_100_5014` - V2_JournalObjective

> Return to Veyra.

### Stage 100 - `NHV_Q03_100_5015` - V2_JournalLog

> Report Nirelda's outcome and add Fragment Three to the ledger.

### Stage 15 - `NHV_Q03_015_5200` - Enhanced_JournalObjective

> Cross-check the Aurantil file with a College witness.

### Stage 15 - `NHV_Q03_015_5201` - Enhanced_JournalLog

> Selveni's copied margin complicates the College's account of Nirelda's expulsion.

### Stage 25 - `NHV_Q03_025_5250` - Enhanced_JournalObjective

> Search the abandoned waystation on the south road.

### Stage 25 - `NHV_Q03_025_5251` - Enhanced_JournalLog

> A survivor and a burned pack place Nirelda's tests between rescue and cruelty.

### Stage 35 - `NHV_Q03_035_5350` - Enhanced_JournalObjective

> Pass the resonance chamber beneath the Four Stillnesses.

### Stage 35 - `NHV_Q03_035_5351` - Enhanced_JournalLog

> The focus fragment opens a ward tied to Nirelda's first experiment.

### Stage 45 - `NHV_Q03_045_5450` - Enhanced_JournalObjective

> Read Nirelda's consent ledger before answering her questions.

### Stage 45 - `NHV_Q03_045_5451` - Enhanced_JournalLog

> Her notes distinguish refusal, consent, and the moments she chose to ignore both.

### Stage 65 - `NHV_Q03_065_5650` - Enhanced_JournalObjective

> Search the false panel for the order's countermark.

### Stage 65 - `NHV_Q03_065_5651` - Enhanced_JournalLog

> L.M. used a seal and distance to keep the poison order deniable.
