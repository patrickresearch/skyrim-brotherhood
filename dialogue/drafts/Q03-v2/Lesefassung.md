# Q03 V2 – The Scholar's Sin

**Inactive editorial draft.** Q02 is complete; Nirelda's examination follows the same Listener authority established in Q00/Q01.

## Stage 10 · Ein neuer Name im Ledger

**Veyra** · `NHV_Q03_010_1000`

> Winterhold has been losing travelers on the road. The last report names an Altmer scholar, Nirelda Aurantil.

**Veyra** · `NHV_Q03_010_1001`

> Begin with the College. An old expulsion record may tell you whether the tower is rumor or refuge.

- I'll ask the College for her record. → `urag`
- What do you expect me to find? → `brief`
## Stage 10 · Die Untersuchung bleibt offen

**Veyra** · `NHV_Q03_010_1004`

> A rival died in a magical accident. That is a description, not a verdict.

**Veyra** · `NHV_Q03_010_1005`

> Find out what she studied, and what the road has been paying for it.

Continue: `urag`.

## Stage 10 · Urag hÃ¼tet die Akten

**Urag** · `NHV_Q03_010_1006`

> Aurantil. That file stays sealed unless you give me a reason worth the ink.

**Urag** · `NHV_Q03_010_1007`

> Travelers are dying on the Winterhold road. That is not yet proof she did it.

- (Persuade) The road is becoming a graveyard. → `persuade_record`
- (Bribe) Perhaps the Arcanaeum could use a donation. → `bribe_record`
- I am the Arch-Mage. Give me the record. → `archmage_record`
- Then I will find another lead. → `widow`
## Stage 10 · Ãœberzeugung statt AutoritÃ¤tsbehauptung

**Direction:** Der echte Speech-Check wird spÃ¤ter im CK umgesetzt.

- World event: Speech check succeeds → `record`
- World event: Speech check fails → `record_fail`
## Stage 10 · Ein Fehlschlag verschlieÃŸt nur diese TÃ¼r

**Urag** · `NHV_Q03_010_1012`

> Then bring me something less convenient than suspicion. The widow in town may have it.

**Urag** · `NHV_Q03_010_1013`

> The file remains here. Your dead do not become evidence because you are angry.

Continue: `widow`.

## Stage 10 · Eine Zahlung Ã¶ffnet den Aktenschrank

**Urag** · `NHV_Q03_010_1014`

> Gold is a language the College pretends not to speak. Take the record, and return it without blood.

Continue: `record`.

## Stage 10 · Der Arch-Mage erhÃ¤lt die Akte

**Urag** · `NHV_Q03_010_1015`

> Of course, Arch-Mage. Try not to become a chapter in it.

**Urag** · `NHV_Q03_010_1016`

> The file concerns an accident, not a confession. Remember that distinction.

Continue: `record`.

## Stage 10 · Die Disziplinarakte ist widersprÃ¼chlich

**Urag** · `NHV_Q03_010_1017`

> Nirelda Aurantil was expelled eleven years ago. Her rival died during a destructive experiment.

**Urag** · `NHV_Q03_010_1018`

> The statements disagree about intent. The College filed the uncertainty and called it closure.

- What does the file say about her tower? → `record_tower`
- Who else saw the accident? → `record_witness`
- I'll take the uncertainty with me. → `widow`
## Stage 10 · Ein Ort und noch keine Schuld

**Urag** · `NHV_Q03_010_1022`

> Hollowfrost Spire. A private tower on the tundra. The College has no claim there now.

**Urag** · `NHV_Q03_010_1023`

> If she is still alive, she may prefer the cold to another hearing.

Continue: `widow`.

## Stage 10 · Die Akte bleibt unvollstÃ¤ndig

**Urag** · `NHV_Q03_010_1024`

> Students, a master, and one apprentice who changed her account twice.

**Urag** · `NHV_Q03_010_1025`

> No sentence in that file tells you what happened inside her head.

Continue: `record`.

## Stage 20 · Thyra erzÃ¤hlt vom fehlenden Heimweg

**Thyra** · `NHV_Q03_020_1000`

> My Brandr took the south road to Dawnstar. His horse came home. He did not.

**Thyra** · `NHV_Q03_020_1001`

> Some nights there is a light on the tundra. Hollowfrost Spire, they call it. Nobody honest lives there.

- Did Brandr ever meet Nirelda? → `widow_nirelda`
- I'll find the tower. → `tower`
## Stage 20 · Ein Zeugenbericht, kein Monsterbeweis

**Thyra** · `NHV_Q03_020_1004`

> He said a woman asked about the color of his blood. He thought she was a healer until she stopped listening.

**Thyra** · `NHV_Q03_020_1005`

> That is all I know. Do not turn my grief into a story that makes you brave.

Continue: `widow`.

## Stage 20 · Der Weg zum Turm

**Veyra** · `NHV_Q03_020_1006`

> The record and the widow point to one place. Hollowfrost Spire is not a verdict. It is where your questions become dangerous.

- World event: Zum Hollowfrost Spire reisen → `defenses`
## Stage 30 · The Four Stillnesses

**Nirelda** · `NHV_Q03_030_1000`

> Frost. Poison. Blade. Silence. Four ways for a body to stop arguing with the world.

**Nirelda** · `NHV_Q03_030_1001`

> You may solve the order, or show me what you do when a door refuses to open.

- Use the notes to set the four pillars. → `pillars_notes`
- Force the mechanism with fire. → `pillars_force`
- Disarm the runes by hand. → `pillars_careful`
## Stage 30 · Notizen lesen statt Opfer nachspielen

**Nirelda** · `NHV_Q03_030_1005`

> You read before touching. A modest virtue. The order is frost, venom, blade, silence.

**Nirelda** · `NHV_Q03_030_1006`

> The door opens. Do not mistake comprehension for permission.

Continue: `observation`.

## Stage 30 · Feuer gegen eine Feuergelehrte

**Nirelda** · `NHV_Q03_030_1007`

> A destructive solution. Efficient, loud, and careless with the structure.

**Nirelda** · `NHV_Q03_030_1008`

> The order was written in the margins. You could have read it.

Continue: `observation`.

## Stage 30 · Vorsicht ist keine Feigheit

**Nirelda** · `NHV_Q03_030_1009`

> You disarm the runes one pin at a time. Patience is a form of knowledge, I suppose.

**Nirelda** · `NHV_Q03_030_1010`

> The tower admits you. I will adjust my notes.

Continue: `observation`.

## Stage 40 · Nirelda beobachtet einen Sterbenden

**Joric** · `NHV_Q03_040_1000`

> Help me... please...

**Nirelda** · `NHV_Q03_040_1001`

> Do not touch him. He is almost finished. I need the exact moment.

**Nirelda** · `NHV_Q03_040_1002`

> You have entered my tower. Now you are another variable.

- Heal the traveler. → `heal`
- Let him die and watch Nirelda's notes. → `let_die`
- Step between them and end the observation. → `interrupt`
## Stage 40 · Mitleid verÃ¤ndert ihren Versuch

**Nirelda** · `NHV_Q03_040_1006`

> You ruined eleven days of observation. And yet the man is breathing.

**Nirelda** · `NHV_Q03_040_1007`

> Mercy is not a measurement. That may be why it interests me.

Continue: `question_intro`.

## Stage 40 · Beobachten heiÃŸt nicht verstehen

**Nirelda** · `NHV_Q03_040_1008`

> There. The pupils change before the breath ends. Did you see it?

**Nirelda** · `NHV_Q03_040_1009`

> You watched a person become a note. You may regret how familiar that feels.

Continue: `question_intro`.

## Stage 40 · Der Listener setzt eine Grenze

**Nirelda** · `NHV_Q03_040_1010`

> You interrupt the observation without healing him. An inelegant mercy.

**Nirelda** · `NHV_Q03_040_1011`

> Still, you chose a limit. That is data of a sort.

Continue: `question_intro`.

## Stage 40 · Nirelda stellt die Bedingungen

**Nirelda** · `NHV_Q03_040_1012`

> You call yourselves servants of the dark. I call you a household with knives.

**Nirelda** · `NHV_Q03_040_1013`

> Answer two questions honestly. I will hear what you offer. Fail, and I will test your last breath instead.

Continue: `exam`.

## Stage 50 · Nireldas PrÃ¼fung des Listeners

- The Void is a belief, not a fact I can prove. → `q1_uncertain`
- We serve Sithis. We do not own what comes after death. → `q1_service`
- I do not know what waits. I know why I choose. → `q1_choice`
## Stage 50 · Eine ehrliche Grenze

**Nirelda** · `NHV_Q03_050_1003`

> Good. You have not dressed uncertainty as a theorem. One point, perhaps.

Continue: `exam2`.

## Stage 50 · Dienst ohne Allwissenheit

**Nirelda** · `NHV_Q03_050_1004`

> A creed and a boundary. Better than certainty. One point.

Continue: `exam2`.

## Stage 50 · Verantwortung statt kosmischer Behauptung

**Nirelda** · `NHV_Q03_050_1005`

> Choice is observable. Motive is less so. I will count the answer.

Continue: `exam2`.

## Stage 50 · Die zweite Frage

**Nirelda** · `NHV_Q03_050_1006`

> Why kill when study would leave the subject intact?

- Because study without consent is already a kind of taking. → `q2_consent`
- For gold. → `q2_gold`
- Because killing is honest. → `q2_honest`
## Stage 50 · Grenzen der Forschung

**Nirelda** · `NHV_Q03_050_1010`

> Consent. An inconvenient variable. Two points.

Continue: `exam3`.

## Stage 50 · Ein ehrlicher, aber dÃ¼nner Grund

**Nirelda** · `NHV_Q03_050_1011`

> Mercenary. Honest, perhaps. Not sufficient.

Continue: `exam3`.

## Stage 50 · Tod als bloÃŸe Klarheit

**Nirelda** · `NHV_Q03_050_1012`

> A clean answer can still be a lazy one.

Continue: `exam3`.

## Stage 50 · Die letzte Frage

**Nirelda** · `NHV_Q03_050_1013`

> What would your family make of me?

- A sister, if you accept limits. → `q3_sister`
- A tool, useful until it is not. → `q3_tool`
- A subject for the Arcanum. → `q3_subject`
## Stage 50 · Eine Einladung mit Bedingung

**Nirelda** · `NHV_Q03_050_1017`

> Limits. I have not enjoyed them since Alinor. A useful answer.

Continue: `exam_result`.

## Stage 50 · NÃ¼tzlichkeit ist kein Vertrag

**Nirelda** · `NHV_Q03_050_1018`

> A clear answer. It does not make me want to kneel.

Continue: `exam_result`.

## Stage 50 · Der Listener dreht die Forschung zurÃ¼ck

**Nirelda** · `NHV_Q03_050_1019`

> You would make a specimen of me. At least you admit it.

Continue: `exam_result`.

## Stage 50 · Die PrÃ¼fung endet mit Nireldas Wahl

Continue: `exam_passed`.

## Stage 50 · Freiwilliges Unterordnen

**Nirelda** · `NHV_Q03_050_1020`

> Very well. I will come and study your family, provided I may be corrected.

**Nirelda** · `NHV_Q03_050_1021`

> That is the closest thing to surrender I have offered in years.

Continue: `correspondence`.

## Stage 50 · Feuer statt Zustimmung

**Direction:** Combat simulation; Nirelda is a master Destruction fire battle-mage. A kill is not required or intended.

**Nirelda** · `NHV_Q03_050_1022`

> You have answers. I have not heard a reason to trust the hands holding them.

**Nirelda** · `NHV_Q03_050_1023`

> Let us see whether your magic is more precise than your ethics.

- World event: Fight until Nirelda yields → `combat`
## Stage 50 · Nirelda yields at the edge of defeat

**Nirelda** · `NHV_Q03_050_1024`

> Enough. Your strength is clearer than your answers. I yield. I will come, but I will not call that agreement.

Continue: `correspondence`.

## Stage 60 · Die Korrespondenz wird nach der PrÃ¼fung gelesen

**Nirelda** · `NHV_Q03_060_1000`

> The letter concerns a poison called Whisperbane. The buyer signed only with the initials L.M.

**Nirelda** · `NHV_Q03_060_1001`

> Two doses. An old woman and a Redguard in the north. I thought it was a family quarrel.

**Found item: V2_WhisperbaneLetter** · `NHV_Q03_060_3000`

> ORDER: WHISPERBANE
> 
> Two doses. One for the old woman, one for the Redguard. Payment in Imperial gold. Sign only L.M.

- You were paid to poison my family. → `poison_reveal`
- You did not know who the doses were for. → `poison_limit`
## Stage 60 · Die persÃ¶nliche Gefahr wird konkret

**Nirelda** · `NHV_Q03_060_1004`

> Your family? Then my research has acquired a very inconvenient audience.

**Nirelda** · `NHV_Q03_060_1005`

> I sold a method, not a target. The distinction is suddenly less comfortable.

Continue: `judgment`.

## Stage 60 · Wissen und Verantwortung bleiben getrennt

**Nirelda** · `NHV_Q03_060_1006`

> I knew the doses, not the faces. Ignorance is not innocence, but it is not intent either.

Continue: `judgment`.

## Stage 70 · Nireldas Zukunft bleibt eine Entscheidung

**Nirelda** · `NHV_Q03_070_1000`

> Laboratory, exile, or grave? You have turned my own question back toward me.

**Nirelda** · `NHV_Q03_070_1001`

> The poison was meant for your family. Decide what you will do with the woman who made it.

- Come to Dawnstar. You may build an Arcanum under our rules. → `recruit`
- Take her back to the College. → `college`
- Tolfdir has agreed to receive her. → `college`
- Leave Skyrim and take your research with you. → `release`
- Your research ends here. → `silence`
## Stage 70 · Aufnahme mit Grenzen

**Nirelda** · `NHV_Q03_070_1006`

> An invitation with conditions. Accepted. I will need shelves, fireproof tables, and permission before I open anything.

**Nirelda** · `NHV_Q03_070_1007`

> Do not mistake curiosity for obedience. I am choosing the arrangement.

Continue: `return`.

## Stage 70 · Ãœbergabe an das College

**Nirelda** · `NHV_Q03_070_1008`

> Back to the College, to be judged by people who faint at a nosebleed.

**Nirelda** · `NHV_Q03_070_1009`

> Very well. Let them decide whether an exile is more dangerous than a fire.

Continue: `return`.

## Stage 70 · Freilassung aus Skyrim

**Nirelda** · `NHV_Q03_070_1010`

> Exile again. At least this time I choose the direction.

**Nirelda** · `NHV_Q03_070_1011`

> I will leave the poison behind. The questions are mine to carry.

Continue: `return`.

## Stage 70 · Das Ende der Forschung

**Direction:** Der Todesausgang wird erst durch den Weltvorgang bestÃ¤tigt. Kein toter NPC spricht danach.

**Nirelda** · `NHV_Q03_070_1012`

> All that knowledge, and you still prefer a closed book.

- World event: Weltvorgang: Nirelda stirbt → `dead`
## Stage 100 · Nireldas Tod bestÃ¤tigt

Continue: `return`.

## Stage 100 · Bericht in der Sanctuary

**Direction:** Alle AusgÃ¤nge fÃ¼hren zum Debrief; nur Recruit schaltet das Arcanum frei.

- World event: Nach Dawnstar zurÃ¼ckkehren und Veyra Bericht erstatten → `report`
## Stage 100 · Der Listener berichtet den Ausgang

- Nirelda joined us. She yielded after the fight. → `debrief_recruit`
- Nirelda joined us after the examination. → `debrief_recruit`
- I handed Nirelda to the College. → `debrief_college`
- Nirelda left Skyrim. → `debrief_release`
- Nirelda is dead. → `debrief_dead`
## Stage 100 · Veyras Urteil Ã¼ber die Feuergelehrte

**Veyra** · `NHV_Q03_100_1005`

> She accepted a boundary after trying to burn through it. Make sure the Arcanum has doors, not only shelves.

**Veyra** · `NHV_Q03_100_1006`

> Her fire is a discipline. Her curiosity is not a license.

Continue: `debrief_fragment`.

## Stage 100 · Missbilligung ohne groÃŸe Rede

**Veyra** · `NHV_Q03_100_1007`

> The College may call that justice. It may also call it convenient. Your choice is recorded.

**Veyra** · `NHV_Q03_100_1008`

> The Arcanum will wait for another mind.

Continue: `debrief_fragment`.

## Stage 100 · Freilassung mit offener Forschung

**Veyra** · `NHV_Q03_100_1009`

> She leaves with questions and without our walls. That is safer for some people, and lonelier for her.

**Veyra** · `NHV_Q03_100_1010`

> Do not confuse distance with an answer.

Continue: `debrief_fragment`.

## Stage 100 · Verlust ohne VerklÃ¤rung

**Veyra** · `NHV_Q03_100_1011`

> A waste. Knowledge does not make a death less final.

**Veyra** · `NHV_Q03_100_1012`

> We will remember the question, not pretend we solved it.

Continue: `debrief_fragment`.

## Stage 100 · Fragment drei wird eingeordnet

Continue: `fragment`.

## Stage 100 · L.M. ist eine Spur, kein vollstÃ¤ndiger Name

**Veyra** · `NHV_Q03_100_1013`

> L.M. ordered poison for an old woman and a Redguard. Their deaths were meant to look natural.

**Veyra** · `NHV_Q03_100_1014`

> Keep the letter with the earlier fragments. A pattern can be deliberate without being understood.

- Does this identify the hand behind it? → `fragment_limit`
- Then the next contract may be watched too. → `fragment_watch`
- Keep it in the ledger. → `finish`
## Stage 100 · Keine vorzeitige EnthÃ¼llung

**Veyra** · `NHV_Q03_100_1018`

> It gives us initials and a method. Names require more than suspicion.

Continue: `fragment`.

## Stage 100 · Vorsicht fÃ¼r den nÃ¤chsten Contract

**Veyra** · `NHV_Q03_100_1019`

> Assume the road is being watched. Do not let caution become paralysis.

Continue: `fragment`.

## Stage 100 · Q03 abgeschlossen

- World event: Lesetest abschlieÃŸen → `finished`
- World event: Nirelda im Arcanum begrÃ¼ÃŸen → `home`
## Stage 100 · Nirelda beginnt im Arcanum

**Nirelda** · `NHV_Q03_100_1020`

> The room is smaller than my tower. The questions are better.

**Nirelda** · `NHV_Q03_100_1021`

> I will ask before I experiment. You may quote me on that.

- World event: Lesetest abschlieÃŸen → `finished`
## Stage 100 · Ende des Q03-Lesetests

## Journal variants

**Stage 10 · V2_JournalObjective** `NHV_Q03_010_2000`

> Learn why Nirelda Aurantil was expelled from the College.

**Stage 10 · V2_JournalLog** `NHV_Q03_010_2001`

> Veyra sent you to investigate an expelled Altmer and travelers who never reached Winterhold.

**Stage 20 · V2_JournalObjective** `NHV_Q03_020_2002`

> Find Hollowfrost Spire.

**Stage 20 · V2_JournalLog** `NHV_Q03_020_2003`

> The College record and Thyra's grief point toward a tower on the tundra.

**Stage 30 · V2_JournalObjective** `NHV_Q03_030_2004`

> Pass the Four Stillnesses.

**Stage 30 · V2_JournalLog** `NHV_Q03_030_2005`

> Nirelda's defenses measure how you react. The order can be learned without repeating her experiments.

**Stage 40 · V2_JournalObjective** `NHV_Q03_040_2006`

> Find Nirelda.

**Stage 40 · V2_JournalLog** `NHV_Q03_040_2007`

> Nirelda is observing Joric's last breath. Your response becomes part of her evidence.

**Stage 50 · V2_JournalObjective** `NHV_Q03_050_2008`

> Pass Nirelda's examination, or survive it.

**Stage 50 · V2_JournalLog** `NHV_Q03_050_2009`

> Nirelda will hear the Brotherhood only if you answer for your service and its limits.

**Stage 60 · V2_JournalObjective** `NHV_Q03_060_2010`

> Search Nirelda's correspondence.

**Stage 60 · V2_JournalLog** `NHV_Q03_060_2011`

> A poison order signed L.M. connects her research to a threat against the family.

**Stage 70 · V2_JournalObjective** `NHV_Q03_070_2012`

> Decide Nirelda's fate.

**Stage 70 · V2_JournalLog** `NHV_Q03_070_2013`

> Nirelda's knowledge does not decide her place. You do.

**Stage 100 · V2_JournalObjective** `NHV_Q03_100_2014`

> Return to Veyra.

**Stage 100 · V2_JournalLog** `NHV_Q03_100_2015`

> Report Nirelda's outcome and add Fragment Three to the ledger.
