# Q02 V2 – Cold Waters

**Inactive editorial draft.** Q00/Q01 are complete; Q02 begins as a chosen contract. Existing voice masters remain untouched.

## Stage 10 · Ein ausgewÃ¤hlter Contract â€“ unabhÃ¤ngig von anderen Rekrutierungen

**Direction:** Q01-Debrief abgeschlossen; Q02 am Map Table ausgewÃ¤hlt. Kein anderer Kernrekrut wird vorausgesetzt.

**Veyra** · `NHV_Q02_010_1000`

> Windhelm's harbor has been giving back bodies. Four in the report I received. The guards blame the cold.

**Veyra** · `NHV_Q02_010_1001`

> The bindings suggest someone helped. Ask Torbjorn Ice-Vein at the docks. He keeps the harbor records.

- [You think the killer could serve the family?](#brief)
- [I'll begin with the harbor records.](#torbjorn)
## Stage 10 · Die Ermittlung bleibt offen

**Veyra** · `NHV_Q02_010_1004`

> Perhaps. First learn whose work it is. A length of rope cannot tell us whether its owner belongs with you.

**Veyra** · `NHV_Q02_010_1005`

> Find the person before you decide what to make of the skill.

Continue: `torbjorn`.

## Stage 10 · Vier im Bericht, ein neuer Fund

**Torbjorn** · `NHV_Q02_010_1006`

> Four since the thaw. Then another came up this morning. Five now. East pier, if you mean to look.

**Torbjorn** · `NHV_Q02_010_1007`

> All Nords. I've recorded complaints against some of those names as well as their deaths.

- [What sort of complaints?](#complaints)
- [Who else knows the night shifts?](#brine)
- [Show me the latest body.](#body)
## Stage 10 · Hafenakten sind keine Mordbeweise

**Torbjorn** · `NHV_Q02_010_1011`

> Dockhands beaten. Wages taken. Haldor Frost-Knuckle comes up often. He's still alive, before you ask.

**Torbjorn** · `NHV_Q02_010_1012`

> A complaint doesn't prove who drowned a man. Neither does throwing the complaint away.

Continue: `torbjorn`.

## Stage 10 · Drinks-the-Brine schÃ¼tzt die Namen der Arbeiter

**DrinksTheBrine** · `NHV_Q02_010_1013`

> You ask after dead Nords and come looking among Argonians. A short journey for a conclusion.

- [(Persuade) I want a witness, not a name to give the guards.](#brine_check)
- [(Bribe) For your time. Tell me what I should examine.](#brine_bribe)
- [Then I'll examine the body myself.](#body)
## Stage 10 · Ãœberredung auswerten

Continue: `brine_yes`.

## Stage 10 · Misstrauen blockiert nicht die Quest

**DrinksTheBrine** · `NHV_Q02_010_1017`

> You can promise that. I cannot afford to believe it. The body is still there. Look for yourself.

Continue: `body`.

## Stage 10 · Bezahlung kauft keinen Schuldigen

**Direction:** Vorschau: Bestechung verfÃ¼gbar bei mindestens 25 Gold; bei spÃ¤terem Einbau Geld genau einmal abziehen.

**DrinksTheBrine** · `NHV_Q02_010_1018`

> For my time, then. Not another worker's name. Keep that distinction clear.

Continue: `brine_yes`.

## Stage 10 · Ein Handwerkshinweis statt ethnischer Schuldzuweisung

**DrinksTheBrine** · `NHV_Q02_010_1019`

> Look at the bindings. Some of us learned that hitch in the marshes. Anyone willing to learn could tie it.

**DrinksTheBrine** · `NHV_Q02_010_1020`

> Rope has no scales, warm-blood. Remember that when you begin pointing.

Continue: `body`.

## Stage 20 · Den Befund von seiner Deutung trennen

**Direction:** Weltvorgang: Leiche tatsÃ¤chlich untersuchen. Keine medizinische Gewissheit aus bloÃŸem Sehen behaupten.

**Torbjorn** · `NHV_Q02_020_1000`

> The rope was still on him when we brought him up. That knot held through the tide.

**Torbjorn** · `NHV_Q02_020_1001`

> I've seen it on marsh fishing nets. Could be a dockhand. Could be someone who watched one work.

- [Then the knot gives us a place to watch, not a name.](#watch_plan)
- [Who saw this happen?](#body_witness)
## Stage 20 · Kein allwissender Hafenmeister

**Torbjorn** · `NHV_Q02_020_1004`

> Nobody who has spoken to me. The night shift hears plenty and remembers less when the guards arrive.

**Torbjorn** · `NHV_Q02_020_1005`

> Watch after the late bell. You'll find Haldor making himself useful to no one.

Continue: `watch_plan`.

## Stage 20 · Die Nachtwache wird begrÃ¼ndet

**Direction:** Zeitfenster der vorhandenen Nachtszene. Kein fÃ¼nfter Mord wurde dem unbekannten TÃ¤ter bereits bewiesen.

- [World event: Zwischen 22 und 4 Uhr den Hafen beobachten](#night)
## Stage 30 · Haldors Gewalt und der Angriff aus dem Wasser

**Direction:** Sings zieht Haldor ins Wasser. Die Regiewahl simuliert die echte Spielerintervention; Haldors Tod oder Rettung muss spÃ¤ter aus dem Weltvorgang folgen.

**HaldorFrostKnuckle** · `NHV_Q02_030_1000`

> Move that crate. Or shall I show you which end of a boot gives orders?

**HaldorFrostKnuckle** · `NHV_Q02_030_1001`

> What... let go! Someone's got me! Help!

- [World event: Eingreifen und Haldor aus dem Wasser retten](#rescue)
- [World event: Verborgen bleiben und den Angreifer beobachten](#observe)
## Stage 30 · Ein Geretteter wird dadurch kein anderer Mensch

**Direction:** Haldor lebt. Sings flieht; die normale Beschattung wird durch Spuren ersetzt.

**HaldorFrostKnuckle** · `NHV_Q02_030_1002`

> Guards! Something pulled me under! What are you staring at? Go after it!

Continue: `trail`.

## Stage 30 · Die Beobachtung hat einen Preis

**Direction:** Haldor ertrinkt. Der Angreifer lÃ¶st sich vom Wasser und bewegt sich unter den Stegen entlang. Keine Schlussfolgerung Ã¼ber frÃ¼here Opfer allein aus dieser Szene.

Continue: `tail`.

## Stage 40 · Beschatten oder die verlorene Spur aufnehmen

**Direction:** Distanz und Entdeckung sind simuliert. Der zweite Pfad muss die Suche ermÃ¶glichen statt die Quest scheitern zu lassen.

- [World event: Unbemerkt bis zum Zugang der Drowned Hollow folgen](#hollow)
- [World event: Entdeckt werden â€“ Sings entkommt vorerst](#trail)
## Stage 40 · Spuren unter den Docks

**Direction:** LÃ¤ngerer Fallback nach Rettung oder Entdeckung. Keine tauchende KI und kein Wissen Ã¼ber ein noch unbekanntes Versteck voraussetzen.

- [World event: Wasserspur und nassen Tritten zum landseitigen Zugang folgen](#hollow)
## Stage 50 · Der TÃ¤ter wird angesprochen

**Sings** · `NHV_Q02_050_1000`

> Stop there. You have followed far enough. You are not wearing a guard's colors. Whose work brings you here?

- [The Dark Brotherhood. I watched you at the docks.](#identity)
## Stage 50 · Name und Verbindung statt Ã¼bernatÃ¼rlichem Erkennen

**Sings** · `NHV_Q02_050_1099`

> You smell of the Void, warm-blood. Not a guard, then. Something worse.

**Sings** · `NHV_Q02_050_1002`

> Veezara's family. I have heard that name. Never met the one who carried it.

**Sings** · `NHV_Q02_050_1003`

> I am Sings-Beneath-Ice. Now you have a name to put beside what you saw.

Continue: `rescue_gate`.

## Stage 50 · Sings erinnert sich an den Eingriff

Continue: `rescue_question`.

## Stage 50 · Rettung verlangt keine Billigung Haldors

**Sings** · `NHV_Q02_050_1004`

> You pulled Haldor out. Why? He would not have reached for you.

- [His death wasn't the decision I came here to make.](#rescue_reply)
- [I wanted you alive and talking, not lost beneath the docks.](#rescue_reply)
## Stage 50 · Kein Dank fÃ¼r den geretteten Peiniger

**Sings** · `NHV_Q02_050_1007`

> Then you have more decisions left than he does. Speak.

Continue: `confess`.

## Stage 50 · Sings benennt seine Taten selbst

**Sings** · `NHV_Q02_050_1008`

> The others? Yes. I took them to the water. Men who found it easy to hurt us when the watch looked away.

**Sings** · `NHV_Q02_050_1009`

> I remembered their hands longer than they remembered our faces.

Continue: `sings_hub`.

## Stage 50 · Wut, Herkunft und eine noch offene Zukunft

- [The workers will face the guards when another body rises.](#reprisal)
- [You speak of Veezara as if you knew him.](#veezara)
- [Where did you learn this work?](#shadow)
- [What do you want when there is no one left to punish?](#purpose)
- [There's a place beyond these docks. Hear what it asks first.](#veyra)
## Stage 50 · Schutz kann andere gefÃ¤hrden

**Sings** · `NHV_Q02_050_1015`

> I know who gets questioned. I know who loses a shift while the guards ask.

**Sings** · `NHV_Q02_050_1016`

> I told myself fear would teach the city. Fear has been a poor teacher for me.

Continue: `sings_hub`.

## Stage 50 · Verehrung ist keine erfundene Bekanntschaft

**Sings** · `NHV_Q02_050_1017`

> A name passed between people who needed to hear that an Argonian could belong somewhere.

**Sings** · `NHV_Q02_050_1018`

> A story is not a meeting. I would not steal his friendship merely because I wanted it.

Continue: `sings_hub`.

## Stage 50 · Das Sternzeichen ersetzt keine Ausbildung

**Sings** · `NHV_Q02_050_1019`

> I was born under the Shadow. In another life, perhaps I would have been taken young and trained as a Shadowscale.

**Sings** · `NHV_Q02_050_1020`

> That is not the life I lived. I learned the harbor. The rope. Which footsteps made the others go quiet.

Continue: `sings_hub`.

## Stage 50 · Die eigentliche Leerstelle

**Sings** · `NHV_Q02_050_1021`

> I have thought more about the next name than the morning after it.

**Sings** · `NHV_Q02_050_1022`

> If you have something better than another name, let me hear it.

Continue: `sings_hub`.

## Stage 50 · Veyra tritt hinzu und erhÃ¤lt einen Bericht

**Direction:** Veyra kommt sichtbar durch den landseitigen Eingang. Keine magische Kenntnis des GestÃ¤ndnisses; der Listener berichtet es.

**Veyra** · `NHV_Q02_050_1023`

> You found the end of the trail, Listener. May I hear what it has told you?

**Sings** · `NHV_Q02_050_1024`

> Another guest. My door is growing careless.

- [Sings admits the drownings. He kills men who hurt the dockworkers.](#trial)
## Stage 50 · Aelius wird vor der PrÃ¼fung vorgestellt

**Direction:** Aelius' Ã¶ffentliches Amt und sein Ruf werden benannt. Keine Kenntnis der geheimen Liste oder seiner Oculatus-Verbindung.

**Veyra** · `NHV_Q02_050_1026`

> Then grievance has chosen his work for him. What of Aelius, the harbor clerk? You speak well of him, Sings.

**Sings** · `NHV_Q02_050_1027`

> He paid us fairly. Used our names. Listened when the others laughed.

**Veyra** · `NHV_Q02_050_1028`

> Would you undertake the family's work against someone you did not hate? I propose Aelius as that test.

- [You are proposing a man's death to test a recruit.](#trial_plain)
## Stage 50 · Der Vorschlag erhÃ¤lt keine erfundene Rechtfertigung

**Veyra** · `NHV_Q02_050_1030`

> Yes. I am not claiming he wronged you, or that the Mother has named him. I am asking you to weigh my proposal.

**Sings** · `NHV_Q02_050_1031`

> Aelius is the man I would have kept outside my anger. You have chosen carefully.

**Veyra** · `NHV_Q02_050_1032`

> The Listener must still choose. So must you.

Continue: `trial_hub`.

## Stage 50 · VerstÃ¤ndnis, Zustimmung und Vertagung

- [Killing him will not free Sings from every hatred.](#hate)
- [Sings, what would make you choose this?](#sings_choice)
- [I am not ready to authorize it.](#trial_wait)
## Stage 50 · Keine Wunderheilung durch einen weiteren Mord

**Veyra** · `NHV_Q02_050_1036`

> No. One act cannot empty a lifetime. It can show whether anger is the only voice he obeys.

**Veyra** · `NHV_Q02_050_1037`

> Afterward, there will still be a man to judge.

Continue: `trial_hub`.

## Stage 50 · Die Entscheidung bleibt offen

**Veyra** · `NHV_Q02_050_1038`

> Then leave the proposal here until you can answer it. My impatience is not a command.

Continue: `trial_hub`.

## Stage 50 · Sings' Zustimmung ist keine Vorfreude

**Sings** · `NHV_Q02_050_1039`

> I want work that does not begin with counting every insult. A family that can ask something of me besides vengeance.

**Sings** · `NHV_Q02_050_1040`

> If I accept its work, I cannot keep every kindness as an exception. I understand the price.

- [I authorize the task. Your place in the family is still undecided.](#authorize)
- [Take time. We have not agreed to this yet.](#trial_wait)
## Stage 50 · Klare ZustÃ¤ndigkeit vor der Tat

**Sings** · `NHV_Q02_050_1043`

> Then I will go to him. Do not tell me later that I must have secretly hated him.

**Veyra** · `NHV_Q02_050_1044`

> I will return to Dawnstar. Bring me the truth of what happens, not merely the answer you think I prefer.

Continue: `aelius_state`.

## Stage 60 · Den tatsÃ¤chlichen Weltzustand beachten

**Direction:** Fallback aus vorhandenem Q02-Plan. Ein frÃ¼her Tod ist kein von Sings bestandener Auftrag und wird nicht als gÃ¶ttliche Absicht erklÃ¤rt.

- [World event: Aelius lebt â€“ Sings spricht ihn nach Feierabend an](#aelius)
- [World event: Aelius ist bereits aus unbekannter Ursache tot](#aelius_early)
## Stage 60 · Eine verhinderte PrÃ¼fung

**Sings** · `NHV_Q02_060_1000`

> He is dead. Whatever brought him here, it was not my choice or my hand. You have no answer to your test.

Continue: `desk`.

## Stage 60 · Aelius bleibt freundlich

**Aelius** · `NHV_Q02_060_1001`

> Sings? The shift finished some time ago. Has someone been troubling you again?

**Sings** · `NHV_Q02_060_1002`

> Walk with me. There is something I cannot say across a desk.

**Aelius** · `NHV_Q02_060_1003`

> You're shaking. Take my cloak. We can talk without you freezing.

- [World event: Sings fÃ¼hrt den vereinbarten Auftrag aus](#sings_kill)
- [World event: Spieler greift ein und tÃ¶tet Aelius selbst](#player_kill)
- [World event: Noch nicht handeln â€“ Begegnung vertagen](#aelius_wait)
## Stage 60 · Vertagung ist keine endgÃ¼ltige Begnadigung

**Direction:** Der Auftrag bleibt offen. Der Lesetest ersetzt nicht die spÃ¤ter erforderliche Unterbrechungs- und Wiederaufnahmelogik.

Continue: `aelius`.

## Stage 60 · Die eigene Tat

**Direction:** Erst nach tatsÃ¤chlichem Tod durch Sings. Keine TÃ¶tungsanimation wird aus dem GesprÃ¤ch allein abgeleitet.

**Sings** · `NHV_Q02_060_1004`

> He offered me his cloak. I took it before I remembered why I had come.

**Sings** · `NHV_Q02_060_1005`

> Keep walking. If I stay here, I will start finding excuses.

Continue: `desk`.

## Stage 60 · Ein fremder Schlag beantwortet seine PrÃ¼fung nicht

**Sings** · `NHV_Q02_060_1006`

> Your hand. Not mine. Do not put that death in my account merely because I stood beside you.

Continue: `desk`.

## Stage 70 · Die Liste wird erst nach der Tat gefunden

**Direction:** Weltvorgang: verschlossene Arbeitsunterlagen durchsuchen. Den Liste-Dialog nicht vor Aelius' tatsÃ¤chlichem Tod zeigen.

**Sings** · `NHV_Q02_070_1000`

> His desk. I thought there might be someone to send word to.

**Sings** · `NHV_Q02_070_1001`

> Why are our shifts here? Our debts? These are not pay records.

**Found item: OculatusDispatch02** · `NHV_SYS_BOOK_82`

> PENITUS OCULATUS — EASTERN HARBOR
> 
> Observe the laborers who move after the bell. Offer fair measure before asking for names. A frightened witness is a door; a grateful one is a key.
> 
> Argonian workers: record shifts, debts, quarrels, and absences. Do not call this persecution. Call it prevention. Forward all patterns to the northern desk under seal.

**Found item: V2_AeliusList** · `NHV_Q02_070_3000`

> PENITUS OCULATUS — EASTERN HARBOR
> 
> Observe the laborers who move after the bell. Offer fair measure before asking for names. A frightened witness is a door; a grateful one is a key.

**Found item: V2_AeliusList** · `NHV_Q02_070_3001`

> Argonian workers: record shifts, debts, quarrels, and absences. Do not call this persecution. Call it prevention. Forward all patterns to the northern desk under seal.

- [World event: Open the locked desk and read the list](#list)
- [World event: Leave the papers and decide Sings' fate](#judgment_gate)
## Stage 70 · Verrat lÃ¶scht die vorherige Entscheidung nicht

**Sings** · `NHV_Q02_070_1002`

> He remembered our names. I thought that was kindness. Here they are, ready to be sent north.

**Sings** · `NHV_Q02_070_1003`

> It makes me want to change the reason I went to him. I cannot. I did not know this then.

- [His kindness and his spying can both have been real.](#list_kindness)
- [This doesn't tell us who at the northern desk receives it.](#list_limits)
- [We still have your future to decide.](#judgment_gate)
## Stage 70 · Keine einfache Umwertung

**Sings** · `NHV_Q02_070_1007`

> Yes. That is harder than finding another monster.

**Sings** · `NHV_Q02_070_1008`

> Take the list. Let the workers' names be evidence against his work, not an invitation to repeat it.

Continue: `list`.

## Stage 70 · Das Fragment bleibt ein Teil

**Sings** · `NHV_Q02_070_1009`

> Then keep the question open. I have had enough certainty for one night.

Continue: `list`.

## Stage 70 · Urteil nach dem tatsÃ¤chlichen TÃ¤ter

Continue: `judgment`.

## Stage 70 · Urteil nach dem tatsÃ¤chlichen TÃ¤ter

Continue: `judgment_player`.

## Stage 70 · Aelius' Tat Ã¤ndert die Frage nicht

**Direction:** Recruit/Release/Silence/Surrender bleiben getrennte Urteile. Die Liste wird berÃ¼cksichtigt, aber nicht als nachtrÃ¤gliche Rechtfertigung verwendet.

**Sings** · `NHV_Q02_070_1010`

> The list does not make my hand clean. It only tells me what his kindness was buying.

**Sings** · `NHV_Q02_070_1011`

> Tell me whether the family wants a shadow, or only another body in its rooms.

- [Come to Dawnstar. Learn what you can do without a harbor to blame.](#recruit)
- [Leave Windhelm. Let the water keep your name.](#release)
- [The family has no room for you.](#silence)
- [I will take you to the Jarl's guards.](#surrender)
## Stage 70 · Eine Ã¼bernommene Tat bleibt ungeklÃ¤rt

**Sings** · `NHV_Q02_070_1016`

> You killed Aelius. I will not call that my proof.

- [Come to Dawnstar, but the question remains open.](#recruit_unproven)
- [Leave Windhelm and do not return.](#release)
- [The family has no room for you.](#silence)
- [I will take you to the Jarl's guards.](#surrender)
## Stage 70 · Ein fremder Tod lÃ¤sst keine PrÃ¼fung bestehen

**Sings** · `NHV_Q02_070_1021`

> Aelius is gone. You have no deed from me to judge.

- [Come to Dawnstar under an open question.](#recruit_unproven)
- [Leave Windhelm.](#release)
- [The family has no room for you.](#silence)
- [The Jarl's guards can question you.](#surrender)
## Stage 70 · Sings entscheidet sich fÃ¼r einen anderen Schatten

**Sings** · `NHV_Q02_070_1026`

> A place where scales are not a crime. I will come, and I will learn what the water cannot teach me.

**Sings** · `NHV_Q02_070_1027`

> Do not mistake my arrival for peace. It is only a direction.

Continue: `return`.

## Stage 70 · Aufnahme mit offener PrÃ¼fung

**Sings** · `NHV_Q02_070_1028`

> You admit me after another hand made the choice. I will carry that uncertainty without pretending it is honor.

**Sings** · `NHV_Q02_070_1029`

> Give me work. I will show you what the missing answer costs.

Continue: `return`.

## Stage 70 · Freilassung ohne geheime RÃ¼ckkehrpflicht

**Sings** · `NHV_Q02_070_1030`

> South, then. I will leave the names behind, if the city lets me.

**Sings** · `NHV_Q02_070_1031`

> The water keeps memories. I do not need to keep every one.

Continue: `return`.

## Stage 70 · Das Urteil gegen Sings

**Direction:** Der Regieknopf simuliert den bestÃ¤tigten Tod. Kein toter Sings spricht danach.

**Sings** · `NHV_Q02_070_1032`

> Then make it quick. I have been waiting for the city to choose a name for me.

- [World event: Weltvorgang: Sings stirbt](#dead)
## Stage 70 · Auslieferung an den Jarl

**Direction:** Vorschau des bestehenden JudgeSurrender: 500 Gold Kopfgeld und VeyraDisapproval; Status bleibt eigener Ausgang.

**Sings** · `NHV_Q02_070_1033`

> You lead me into the dark only to hand me to the light?

**Hjorald** · `NHV_Q02_070_1034`

> There were complaints. We called them dock trouble. That was convenient.

Continue: `return`.

## Stage 100 · Sings' Tod bestÃ¤tigt

**Direction:** Weltvorgang bestÃ¤tigt den Tod. Kein Homecoming als Rekrut.

Continue: `return`.

## Stage 100 · Bericht in der Sanctuary

**Direction:** Alle AusgÃ¤nge fÃ¼hren zum Bericht; nur Recruit aktiviert den Drowned Pool.

- [World event: Nach Dawnstar zurÃ¼ckkehren und Veyra Bericht erstatten](#report)
## Stage 100 · Der Listener berichtet Tat und Entscheidung

- [Sings killed Aelius himself. I recruited him.](#report_recruit)
- [I killed Aelius. I recruited Sings under an open question.](#report_unproven)
- [Sings left Windhelm.](#report_release)
- [Sings is dead.](#report_dead)
- [I handed Sings to the Jarl.](#report_surrender)
## Stage 100 · Veyras Urteil Ã¼ber die bestandene PrÃ¼fung

**Veyra** · `NHV_Q02_100_1005`

> He killed without the old hatred carrying him. That is a beginning, not a cure.

**Veyra** · `NHV_Q02_100_1006`

> Give him water, work, and names that are not targets.

Continue: `report_fragment`.

## Stage 100 · Veyras Urteil Ã¼ber die Ã¼bernommene Tat

**Veyra** · `NHV_Q02_100_1007`

> You removed the danger. You did not answer my question about him.

**Veyra** · `NHV_Q02_100_1008`

> Leave the question in his record. A family can carry uncertainty without lying about it.

Continue: `report_fragment`.

## Stage 100 · Freilassung beendet keine Freundschaft

**Veyra** · `NHV_Q02_100_1009`

> Then he leaves with the names in his head and no room in ours. That is a choice, not a failure of memory.

**Veyra** · `NHV_Q02_100_1010`

> The harbor may be quieter. You are not responsible for making it kind.

Continue: `report_fragment`.

## Stage 100 · Verlust ohne nachtrÃ¤gliche Verherrlichung

**Veyra** · `NHV_Q02_100_1011`

> A waste. You had the right to decide, Listener. Rights do not make every result wise.

**Veyra** · `NHV_Q02_100_1012`

> The Drowned Pool will wait for another shadow.

Continue: `report_fragment`.

## Stage 100 · Auslieferung und Missbilligung

**Veyra** · `NHV_Q02_100_1013`

> An interesting choice. The Jarl will call it order; the harbor may call it relief.

**Veyra** · `NHV_Q02_100_1014`

> You have bought a bounty with a man's silence. Keep the receipt.

Continue: `report_fragment`.

## Stage 100 · Fragment zwei â€“ die Liste bleibt ein BeweisstÃ¼ck

Continue: `fragment_player`.

## Stage 100 · Der Listener legt die Namensliste vor

**Player** · `NHV_Q02_100_1015`

> Aelius kept a list of Argonian names and shifts. It was meant for the Oculatus.

**Veyra** · `NHV_Q02_100_1016`

> A net of whispers cast over the docks. Someone at the northern desk is hauling it in.

Continue: `fragment_analysis`.

## Stage 100 · Veyra holt das BeweisstÃ¼ck nach

**Direction:** GewÃ¶hnliche Bergung; im spÃ¤teren Plugin muss die Vergabe des Fragments einmalig abgesichert werden.

**Veyra** · `NHV_Q02_100_1017`

> You left the desk unopened. I went back before the harbor could lose the paper.

**Veyra** · `NHV_Q02_100_1018`

> Aelius kept Argonian names, shifts, debts, and absences. The seal is Penitus Oculatus.

Continue: `fragment_analysis`.

## Stage 100 · Freundlichkeit und Ãœberwachung zugleich

**Veyra** · `NHV_Q02_100_1019`

> He may have meant the kindness. He also meant the list. Both can be true, and neither repairs the drowned.

**Veyra** · `NHV_Q02_100_1020`

> Fragment two names a northern desk. It does not name the hand that reads it.

- [Then we have a pattern, not a culprit.](#pattern)
- [Does this connect to the earlier dispatch?](#connect)
- [Keep it with the ledger.](#finish)
## Stage 100 · Der Zirkel bleibt ein Verdacht

**Veyra** · `NHV_Q02_100_1024`

> The same kind of watch appears around troubled families. That is enough to be careful, not enough to name an enemy.

Continue: `fragment_analysis`.

## Stage 100 · Der grÃ¶ÃŸere Faden wÃ¤chst langsam

**Veyra** · `NHV_Q02_100_1025`

> Compare the reports. A net is easier to see once two knots hold the same shape.

Continue: `fragment_analysis`.

## Stage 100 · Q02 abgeschlossen

**Direction:** Der nÃ¤chste Contract bleibt am Map Table wÃ¤hlbar. Der Surrender-Ausgang setzt die bestehende Missbilligung, nicht eine neue Lore-Tatsache.

- [World event: Lesetest abschlieÃŸen](#finished)
- [World event: Sings in the Drowned Pool begrÃ¼ÃŸen](#home)
## Stage 100 · Sings beginnt mit einer Aufgabe

**Direction:** Mehrsprecherszene nach tatsÃ¤chlicher Ankunft; kein automatischer Followervertrag.

**Sings** · `NHV_Q02_100_1026`

> The pool is quiet. I can hear the pipes arguing with it.

**Sings** · `NHV_Q02_100_1027`

> Give me a route to walk, and names that need remembering.

- [How do you settle here?](#home_more)
- [Ask Babette about the water.](#home_babette)
- [World event: Lesetest abschlieÃŸen](#finished)
## Stage 100 · Ein anderer Schatten als Rache

**Sings** · `NHV_Q02_100_1030`

> I am learning which footsteps mean work and which mean fear.

**Sings** · `NHV_Q02_100_1031`

> It is slower than hatred. That may be the point.

Continue: `home`.

## Stage 100 · Wasser und Erinnerung

**Sings** · `NHV_Q02_100_1032`

> She has lived long enough to make death impatient.

**Babette** · `NHV_Q02_100_1033`

> And you have drowned long enough to make water jealous. We will get along.

Continue: `home`.

## Stage 100 · Ende des Q02-Lesetests

## Journal variants

**Stage 10 · V2_JournalObjective** `NHV_Q02_010_2000`

> Investigate the bodies in Windhelm's harbor.

**Stage 10 · V2_JournalLog** `NHV_Q02_010_2001`

> Veyra sent you to identify the hand behind the harbor deaths. Torbjorn's records and the workers' silence point toward the docks.

**Stage 20 · V2_JournalObjective** `NHV_Q02_020_2002`

> Examine the latest victim.

**Stage 20 · V2_JournalLog** `NHV_Q02_020_2003`

> A marsh hitch and signs of a struggle offer a place to watch, not a culprit.

**Stage 30 · V2_JournalObjective** `NHV_Q02_030_2004`

> Watch the docks at night.

**Stage 30 · V2_JournalLog** `NHV_Q02_030_2005`

> Haldor Frost-Knuckle was attacked after dark. Sings-Beneath-Ice fled or led you onward, depending on your intervention.

**Stage 40 · V2_JournalObjective** `NHV_Q02_040_2006`

> Follow the killer without being seen.

**Stage 40 · V2_JournalLog** `NHV_Q02_040_2007`

> The trail under the docks leads toward a hidden shore entrance.

**Stage 50 · V2_JournalObjective** `NHV_Q02_050_2008`

> Confront Sings-Beneath-Ice.

**Stage 50 · V2_JournalLog** `NHV_Q02_050_2009`

> Sings admitted the drownings. Veyra arrived only after you reported what he had done.

**Stage 60 · V2_JournalObjective** `NHV_Q02_060_2010`

> Authorize and witness the Aelius trial.

**Stage 60 · V2_JournalLog** `NHV_Q02_060_2011`

> Veyra proposed a test against Aelius, whose kindness to Argonians made the choice harder.

**Stage 70 · V2_JournalObjective** `NHV_Q02_070_2012`

> Decide Sings-Beneath-Ice's fate.

**Stage 70 · V2_JournalLog** `NHV_Q02_070_2013`

> Aelius is dead, but his list has not yet explained whether kindness and surveillance were both genuine.

**Stage 100 · V2_JournalObjective** `NHV_Q02_100_2014`

> Report the outcome to Veyra.

**Stage 100 · V2_JournalLog** `NHV_Q02_100_2015`

> Your report must name the actual killer and the decision you made about Sings.

**Stage 100 · V2_JournalObjective** `NHV_Q02_100_2016`

> Compare Oculatus Fragment Two with earlier reports.

**Stage 100 · V2_JournalLog** `NHV_Q02_100_2017`

> The list identifies a northern desk, not its operator. Two matching knots make a pattern, not a culprit.
