# Q00 V2 – vollständige Lesefassung

**Inaktiver Entwurf vom 29.09.2026.** Aus Q00.csv und flow.json erzeugt. Diese Redaktion verändert den aktiven Master nicht. Spielertext und Responses stammen ausschließlich aus CSV.

Lies die Pflichtblöcke in Reihenfolge; die Auswahlziele führen zu Nachfragen oder Fortsetzungen. `Weiter` und Ortswechsel sind Regie des Lesetests, keine gesprochenen Spielerzeilen. Zum Durchklicken: Lesetest.html neben dieser Datei öffnen. Details zur späteren Aktivierung: README.md.

<a id="standoff"></a>
## Standoff – Ruf, Ernte, dann erst ein Name

**Stage 10 · standoff**

*Regie: Veyra bleibt trotz der Klinge ruhig. Sithis' Ruf ist ihre eigene religiöse Aussage, kein objektiver Erzählerbeleg. Erst Nazir verlangt ihren Namen.*

**Nazir** · `NHV_Q00_010_1000` · Anger 40

> Listener. She knew the answer to the door. Perhaps she'll tell you what she's doing here.

**Veyra** · `NHV_Q00_010_1001` · Neutral 30

> My Dread Father called. I followed. There is another harvest to gather.

**Babette** · `NHV_Q00_010_1002` · Happy 25

> A harvest? You've come a long way to find a field.

**Veyra** · `NHV_Q00_010_1003` · Neutral 30

> Not a field. A family that need not spend its remaining years remembering what it used to be.

**Nazir** · `NHV_Q00_010_1004` · Neutral 30

> We're still here. You can start with a name.

**Veyra** · `NHV_Q00_010_1041` · Neutral 30

> Veyra Othren. Though some in the old sanctuaries knew me as the Gleaner.


Weiter → [recognition](#recognition).

<a id="recognition"></a>
## Cicero erkennt eine Bekannte

**Stage 10 · recognition**

Nur bei `{"cicero": true}`; sonst [harvest_question](#harvest_question).

**Cicero** · `NHV_Q00_010_1005` · Puzzled 45

> That face. Cicero has seen that face beside Mother's coffin. It was not smiling then.

**Veyra** · `NHV_Q00_010_1006` · Neutral 30

> Nor was yours, Cicero.


Weiter → [harvest_question](#harvest_question).

<a id="harvest_question"></a>
## Der Listener verlangt eine greifbare Erklärung

**Stage 10 · harvest_question**

- Then speak plainly, Veyra. What are you offering? (`NHV_Q00_010_1042`) → [harvest_plain](#harvest_plain)
- We've buried enough. What would you have us harvest? (`NHV_Q00_010_1043`) → [harvest_plain](#harvest_plain)

<a id="harvest_plain"></a>
## Die Ernte bekommt Bedeutung – mögliche neue Mitglieder

**Stage 10 · harvest_plain**

**Veyra** · `NHV_Q00_010_1044` · Neutral 30

> People, Listener. There are killers beyond these walls who have found no purpose for what they are.

**Veyra** · `NHV_Q00_010_1045` · Neutral 30

> Some might find it here. I can help you seek them out, if you will hear me.

**Nazir** · `NHV_Q00_010_1046` · Neutral 30

> Recruits. You might have led with that.

**Veyra** · `NHV_Q00_010_1047` · Happy 30

> And deprived you of the chance to ask my name?

**Babette** · `NHV_Q00_010_1048` · Neutral 30

> Finding a killer is easy. Finding one worth keeping takes longer.

**Veyra** · `NHV_Q00_010_1049` · Neutral 30

> Which is why I bring you possibilities. The choice remains yours, Listener.


Weiter → [standoff_hub](#standoff_hub).

Nach vollständigem Block im Lesetest: `{"heardInvitation": true}`.

<a id="standoff_hub"></a>
## Freie Befragung – keine Frage beendet den Standoff

**Stage 10 · standoff_hub**

Voraussetzung im Lesetest: `{"heardInvitation": true}`.

- You speak as though you've done this before. (`NHV_Q00_010_1007`) → [gleaner](#gleaner)
- Knowing the answer to the door proves very little. (`NHV_Q00_010_1008`) → [door](#door)
- You arrive after Falkreath burns. Convenient. (`NHV_Q00_010_1009`) → [late](#late)
- Has the Night Mother spoken to you? (`NHV_Q00_010_1010`) → [mother_past](#mother_past)
- Nazir, let her finish without the blade at her throat. (`NHV_Q00_010_1011`) → [blade](#blade)
- I'll ask the Night Mother. Wait at the Windpeak Inn. (`NHV_Q00_010_1012`) → [departure](#departure)
- Leave. I'll hear the Mother's judgment before yours. (`NHV_Q00_010_1013`) → [dismiss](#dismiss)

<a id="gleaner"></a>
## Die Nachleserin – Metapher mit greifbarer Bedeutung

**Stage 10 · gleaner**

**Veyra** · `NHV_Q00_010_1014` · Neutral 30

> After a harvest, someone gathers what the reapers left. That has been my work for a very long time.

**Veyra** · `NHV_Q00_010_1015` · Neutral 30

> In my case, people. A killer without a purpose. A survivor with nowhere to go.

**Veyra** · `NHV_Q00_010_1016` · Neutral 30

> I watch them before I offer their names. Some never make it onto the page.

- So every murderer is a possible recruit? (`NHV_Q00_010_1017`) → [murderers](#murderers)
- I've heard enough about your work. For now. (`NHV_Q00_010_1018`) → [standoff_hub](#standoff_hub)

<a id="murderers"></a>
## Ein Mord allein genügt nicht

**Stage 10 · murderers**

**Veyra** · `NHV_Q00_010_1019` · Neutral 30

> A murder tells me where to look. It does not tell me whom to trust.

**Veyra** · `NHV_Q00_010_1020` · Neutral 30

> Someone who needs a new enemy every morning will eventually find one at your table.


Weiter → [standoff_hub](#standoff_hub).

<a id="door"></a>
## Zugang ist kein Vertrauensbeweis

**Stage 10 · door**

**Veyra** · `NHV_Q00_010_1021` · Neutral 30

> It proves I was trusted with an answer. Nothing more. The invitation must come from you.

**Nazir** · `NHV_Q00_010_1022` · Neutral 30

> You might have tried asking before walking in.

**Veyra** · `NHV_Q00_010_1023` · Neutral 30

> You would have had a quieter evening. I suspect I would still be outside.


Weiter → [standoff_hub](#standoff_hub).

<a id="late"></a>
## Falkreath und die Grenzen ihrer Hilfe

**Stage 10 · late**

**Veyra** · `NHV_Q00_010_1024` · Sad 35

> I found ashes. Coming sooner is a comfort I cannot offer the dead.

**Veyra** · `NHV_Q00_010_1025` · Neutral 30

> I can offer the living something useful. Names. People worth finding before someone else finds them.

**Nazir** · `NHV_Q00_010_1026` · Neutral 30

> Useful is a promising start. It isn't an answer to everything.

**Veyra** · `NHV_Q00_010_1027` · Neutral 30

> No. You should distrust anyone who brings one of those.


Weiter → [standoff_hub](#standoff_hub).

<a id="mother_past"></a>
## Die Mutter – das persönliche Mysterium bleibt

**Stage 10 · mother_past**

**Veyra** · `NHV_Q00_010_1028` · Neutral 30

> I have spoken with the Mother in a way you would not yet understand.

**Veyra** · `NHV_Q00_010_1029` · Neutral 30

> Her words to the Brotherhood are yours to hear, Listener. I have come with an offer, not a message.

- Then you won't speak in her place. (`NHV_Q00_010_1030`) → [mother_limit](#mother_limit)
- I'll put that question to her myself. (`NHV_Q00_010_1031`) → [standoff_hub](#standoff_hub)

<a id="mother_limit"></a>
## Kein zweiter Listener

**Stage 10 · mother_limit**

**Veyra** · `NHV_Q00_010_1032` · Neutral 30

> Nor choose in yours. Ask her about me. You needn't take my history on trust.


Weiter → [standoff_hub](#standoff_hub).

<a id="blade"></a>
## Nazirs Klinge – die Befragung läuft weiter

**Stage 10 · blade**

*Regie: Die Drohung beendet die Befragung. Veyra ruft den Zeugen aus Trotz, nicht aus Zustimmung.*

**Nazir** · `NHV_Q00_010_1033` · Neutral 30

> Very well. The blade comes down. My attention stays where it is.

**Veyra** · `NHV_Q00_010_1034` · Happy 15

> I find that arrangement quite reasonable.


Weiter → [stage12_blade](#stage12_blade).

<a id="dismiss"></a>
## Scharfer Abschied

**Stage 10 · dismiss**

**Veyra** · `NHV_Q00_010_1035` · Neutral 30

> Then I will wait at the Windpeak Inn. If you want me back, you know where to look.


Weiter → [stage12_dismiss](#stage12_dismiss).

<a id="departure"></a>
## Bewusster Abschluss

**Stage 10 · departure**

**Veyra** · `NHV_Q00_010_1036` · Neutral 30

> Ask her whether my work is welcome. I will wait at the Windpeak Inn.


Weiter → [departure_reason](#departure_reason).

<a id="departure_reason"></a>
## Warum die Night Mother befragt wird

**Stage 10 · departure_reason**

*Regie: Erst nach letzter Response folgt Stage 12; die Beschwörung liegt vor Veyras Abgang.*

**Nazir** · `NHV_Q00_010_1037` · Neutral 30

> Then ask her. Knowing the answer to a door does not earn this woman's place behind it.

**Veyra** · `NHV_Q00_010_1038` · Neutral 30

> I will leave you to it.


Weiter → [stage12_departure](#stage12_departure).

<a id="stage12_departure"></a>
## Zeuge nach dem Urteil der Night Mother

**Stage 12 · stage12_departure**

**Veyra** · `NHV_Q00_012_1000` · Neutral 30

> Then ask the Mother. Before I leave, let someone this family knows speak for me.

**Veyra** · `NHV_Q00_012_1001` · Neutral 30

> I will call him now. Judge the witness as you judge me.


Weiter → [lucien_standoff](#lucien_standoff).

<a id="stage12_blade"></a>
## Zeuge trotz der Drohung

**Stage 12 · stage12_blade**

**Veyra** · `NHV_Q00_012_1002` · Neutral 30

> If Nazir's blade is your answer, let a witness speak before it falls.

**Veyra** · `NHV_Q00_012_1003` · Neutral 30

> Someone who knew my service can answer. I will call him, even if you would rather see me go.


Weiter → [lucien_standoff](#lucien_standoff).

<a id="stage12_dismiss"></a>
## Zeuge an der Tür

**Stage 12 · stage12_dismiss**

**Veyra** · `NHV_Q00_012_1004` · Neutral 30

> You would send me away before deciding what I am. Very well.

**Veyra** · `NHV_Q00_012_1005` · Neutral 30

> Let a witness speak before I go. Then you can judge what follows.


Weiter → [lucien_standoff](#lucien_standoff).

<a id="lucien_standoff"></a>
## Luciens Bürgschaft im Standoff

**Stage 12 · lucien_standoff**

*Regie: Veyra ruft verpflichtend. Lucien bürgt für ihre freiwillige Treue, Nazir bleibt misstrauisch, dann löst Lucien sich auf.*

**Veyra** · `NHV_Q00_012_1006` · Neutral 30

> Someone in this family's memory can speak for me. I will call him now.

**Veyra** · `NHV_Q00_012_1007` · Neutral 30

> Lucien Lachance. If you still answer Sithis, come and speak.

**Lucien** · `NHV_Q00_012_1008` · Happy 20

> A summons in a sanctuary. Veyra, you do cultivate unusual meetings.

**Lucien** · `NHV_Q00_012_1009` · Neutral 35

> Lucien Lachance, Listener. I served this family as a Speaker. What would you ask?

**Lucien** · `NHV_Q00_012_1010` · Neutral 35

> I knew Veyra in Cheydinhal, when I still had a pulse. She came as a visitor, never as one of my assassins.

**Lucien** · `NHV_Q00_012_1011` · Neutral 50

> She serves Sithis willingly. I have never known her to turn from that purpose.

**Nazir** · `NHV_Q00_012_1012` · Neutral 30

> A witness is not a pardon. But it is more than a stranger's word.

**Lucien** · `NHV_Q00_012_1013` · Neutral 30

> When the family calls again, I will answer. Until then, judge her by what she does.


Weiter → [exit](#exit).

Nach vollständigem Block im Lesetest: `{"lucien": true}`.

<a id="exit"></a>
## Veyra verlässt die Sanctuary

**Stage 15 · exit**

*Regie: Räumlicher Übergang: sichtbarer Abschied, dann Windpeak; Vorschau simuliert den vorhandenen Stage-15/20-Ablauf.*

**Veyra** · `NHV_Q00_015_1000` · Neutral 30

> Give me a moment to get past Nazir. He has made a rather thorough doorway.


Weiter → [before_mother](#before_mother).

<a id="before_mother"></a>
## Vor der Befragung

**Stage 20 · before_mother**

- Regie: Die Night Mother aufsuchen → [nm_start](#nm_start)
- Regie: Veyra vorher im Windpeak Inn besuchen → [inn_early](#inn_early)

<a id="inn_early"></a>
## Zu früh im Gasthaus

**Stage 20 · inn_early**

**Veyra** · `NHV_Q00_020_1000` · Neutral 30

> Back already? I would rather hear what the Mother said than how far you walked.

- I haven't spoken to her yet. (`NHV_Q00_020_1001`) → [inn_wait](#inn_wait)
- I wanted to know whether you'd wait. (`NHV_Q00_020_1002`) → [inn_patience](#inn_patience)

<a id="inn_wait"></a>
## Zur Mutter zurück

**Stage 20 · inn_wait**

**Veyra** · `NHV_Q00_020_1003` · Neutral 30

> Then we are both waiting. She is in the Sanctuary, Listener. I shall remain here.


Weiter → [before_mother](#before_mother).

<a id="inn_patience"></a>
## Veyras Geduld

**Stage 20 · inn_patience**

**Veyra** · `NHV_Q00_020_1004` · Happy 15

> The room is warm. The innkeeper has asked only for coin. I have endured worse arrangements.


Weiter → [before_mother](#before_mother).

<a id="nm_start"></a>
## Die Night Mother bestätigt den Auftrag

**Stage 20 · nm_start**

**NightMother** · `NHV_Q00_020_1005` · Neutral 30

> My Listener. You have heard the Gleaner's offer. Now hear me.

**NightMother** · `NHV_Q00_020_1006` · Neutral 30

> She has found servants for my family before. Let her bring you names again.

**NightMother** · `NHV_Q00_020_1007` · Neutral 30

> You shall judge those she finds. My children are not hers to choose.


Weiter → [nm_hub](#nm_hub).

<a id="nm_hub"></a>
## Fragen an die Night Mother

**Stage 20 · nm_hub**

- Do you trust her, Mother? (`NHV_Q00_020_1008`) → [nm_trust](#nm_trust)
- Was she ever one of your children? (`NHV_Q00_020_1009`) → [nm_family](#nm_family)
- Have you spoken with her before, Mother? (`NHV_Q00_020_1010`) → [nm_voice](#nm_voice)
- What is she? (`NHV_Q00_020_1011`) → [nm_nature](#nm_nature)
- Then I will bring her back and hear her plan. (`NHV_Q00_020_1012`) → [nm_close](#nm_close)

<a id="nm_trust"></a>
## Vertrauen ersetzt keine Verantwortung

**Stage 20 · nm_trust**

**NightMother** · `NHV_Q00_020_1013` · Neutral 30

> Her devotion is to Sithis. Watch the work she does in his name.

**NightMother** · `NHV_Q00_020_1014` · Neutral 30

> I have given you leave to hear her. Your judgment remains your own.


Weiter → [nm_hub](#nm_hub).

<a id="nm_family"></a>
## Zugehörigkeit ohne Mitgliedschaft

**Stage 20 · nm_family**

**NightMother** · `NHV_Q00_020_1015` · Neutral 30

> She was never bound to the family as my children are. Yet she has served it.

**NightMother** · `NHV_Q00_020_1016` · Neutral 30

> Some return to the door without ever calling the house their own.


Weiter → [nm_hub](#nm_hub).

<a id="nm_voice"></a>
## Amt des Listeners

**Stage 20 · nm_voice**

*Regie: Kein Datum, keine lebende Night Mother als bestätigtes Ereignis; kein Anspruch auf ein historisch immer einziges Listeneramt.*

**NightMother** · `NHV_Q00_020_1017` · Neutral 30

> You are my Listener. It is through you that my family hears my will.

**NightMother** · `NHV_Q00_020_1018` · Neutral 30

> What passed between the Gleaner and me is not yours to carry.


Weiter → [nm_hub](#nm_hub).

<a id="nm_nature"></a>
## Sithis bewahrt das Geheimnis

**Stage 20 · nm_nature**

**NightMother** · `NHV_Q00_020_1019` · Neutral 30

> She is the one who gathers. What else she is remains a secret in Sithis' keeping.

**NightMother** · `NHV_Q00_020_1020` · Neutral 30

> Seek the worth of her work, my Listener. Her beginning is not your task.


Weiter → [nm_hub](#nm_hub).

<a id="nm_close"></a>
## Erlaubnis, noch keine Zusage

**Stage 20 · nm_close**

**NightMother** · `NHV_Q00_020_1021` · Neutral 30

> Go to her. Let the Gleaner offer her service. Let my Listener decide.


Weiter → [cicero_memory](#cicero_memory).

<a id="cicero_memory"></a>
## Optional – Ciceros Erinnerung

**Stage 30 · cicero_memory**

Nur bei `{"cicero": true}`; sonst [inn_return](#inn_return).

**Cicero** · `NHV_Q00_030_1000` · Anger 50

> Cheydinhal! Now Cicero remembers. She came to Mother there. And then she left.

**Cicero** · `NHV_Q00_030_1001` · Sad 45

> Cicero stayed with the coffin. She had other doors to visit.

- Coming back doesn't erase leaving you. (`NHV_Q00_030_1002`) → [cicero_validate](#cicero_validate)
- The Mother wants her work. I intend to hear her out. (`NHV_Q00_030_1003`) → [cicero_duty](#cicero_duty)
- We'll speak about this another time. (`NHV_Q00_030_1004`) → [cicero_later](#cicero_later)

<a id="cicero_validate"></a>
## Cicero fühlt sich gehört

**Stage 30 · cicero_validate**

**Cicero** · `NHV_Q00_030_1005` · Sad 35

> No. No, it doesn't. The Listener remembers what returning feet like to forget.


Weiter → [inn_return](#inn_return).

<a id="cicero_duty"></a>
## Cicero respektiert die Mother

**Stage 30 · cicero_duty**

**Cicero** · `NHV_Q00_030_1006` · Neutral 30

> For Mother, then. Cicero can be civil. Briefly. With effort.


Weiter → [inn_return](#inn_return).

<a id="cicero_later"></a>
## Keine erzwungene Versöhnung

**Stage 30 · cicero_later**

**Cicero** · `NHV_Q00_030_1007` · Sad 25

> Another time. Cicero will keep the grievance somewhere safe.


Weiter → [inn_return](#inn_return).

<a id="inn_return"></a>
## Windpeak – Einladung zurück

**Stage 30 · inn_return**

**Veyra** · `NHV_Q00_030_1008` · Neutral 30

> Well, Listener? Am I to remain an expense to this inn?

- She permits your work. Come back and explain your plan. (`NHV_Q00_030_1009`) → [return_yes](#return_yes)
- She permits it. I still have doubts. Come with me. (`NHV_Q00_030_1010`) → [return_caution](#return_caution)
- Wait here. I need more time. (`NHV_Q00_030_1011`) → [return_wait](#return_wait)

<a id="return_wait"></a>
## Vertagen im Windpeak

**Stage 30 · return_wait**

**Veyra** · `NHV_Q00_030_1012` · Neutral 30

> Then take it. I would rather have a considered answer.


Gespräch pausiert; beim Wiederansprechen → [inn_return](#inn_return).

<a id="return_yes"></a>
## Gemeinsamer Rückweg

**Stage 30 · return_yes**

**Veyra** · `NHV_Q00_030_1013` · Neutral 30

> Gladly. Nazir and Babette should hear what we propose to bring into their home.


Weiter → [travel](#travel).

<a id="return_caution"></a>
## Misstrauen bleibt zulässig

**Stage 30 · return_caution**

**Veyra** · `NHV_Q00_030_1014` · Neutral 30

> Keep them. We are discussing recruits, not exchanging vows. Let us return.


Weiter → [travel](#travel).

<a id="travel"></a>
## Rückkehr in die Dawnstar Sanctuary

**Stage 30 · travel**

*Regie: Vorschau-Ereignis für CompleteVeyraReturnToSanctuary. Im Spiel erst nach tatsächlicher Rückkehr.*


Weiter → [proposal_start](#proposal_start).

Nach vollständigem Block im Lesetest: `{"returned": true}`.

<a id="proposal_start"></a>
## Pflicht 1 – Was Veyra tatsächlich anbietet

**Stage 30 · proposal_start**

Voraussetzung im Lesetest: `{"returned": true}`.

**Nazir** · `NHV_Q00_030_1015` · Neutral 30

> She's back. I assume the Mother has her reasons.

**Veyra** · `NHV_Q00_030_1016` · Neutral 30

> She permits me to help. The Listener has agreed to hear how.

**Veyra** · `NHV_Q00_030_1017` · Neutral 30

> I want to help you rebuild the Brotherhood by finding new members. People who can serve it beyond their next killing.

**Veyra** · `NHV_Q00_030_1018` · Neutral 30

> I have kept a ledger of possible candidates across Skyrim. Observations, habits, places to begin looking.

- Tell us how you intend to choose them. (`NHV_Q00_030_1019`) → [proposal_method](#proposal_method)

Nach vollständigem Block im Lesetest: `{"heardPlan": true}`.

<a id="proposal_method"></a>
## Pflicht 2 – Beobachten, prüfen, urteilen

**Stage 30 · proposal_method**

**Veyra** · `NHV_Q00_030_1020` · Neutral 30

> You find the person behind the rumors. Watch what they do when they think no one is judging.

**Veyra** · `NHV_Q00_030_1021` · Neutral 30

> Then we devise a test. Killing may be easy for them. Restraint, obedience, or leaving an old life may prove harder.

**Babette** · `NHV_Q00_030_1022` · Happy 25

> A talent for murder is common. Someone who can follow instructions is a much rarer pleasure.

**Veyra** · `NHV_Q00_030_1023` · Neutral 30

> A name in my ledger is a possibility. You may find nothing worth bringing home.

- And who has the final word? (`NHV_Q00_030_1024`) → [proposal_authority](#proposal_authority)

Nach vollständigem Block im Lesetest: `{"heardMethod": true}`.

<a id="proposal_authority"></a>
## Pflicht 3 – Wer entscheidet und wer hier arbeitet

**Stage 30 · proposal_authority**

**Veyra** · `NHV_Q00_030_1025` · Neutral 30

> You do, Listener. I advise. You decide whether to invite them into the family, turn them away, or silence a danger.

**Nazir** · `NHV_Q00_030_1026` · Anger 30

> And you expect us to sleep beside whatever walks back through that door?

**Veyra** · `NHV_Q00_030_1027` · Neutral 30

> Only those the Listener admits. You know this house, Nazir. We will need your judgment here.

**Veyra** · `NHV_Q00_030_1028` · Neutral 30

> Members need beds, food, training. Rebuilding means giving them work and a place in this Sanctuary.

**Veyra** · `NHV_Q00_030_1029` · Neutral 30

> That is my offer. I can begin with one lead. You needn't promise me a full table.


Weiter → [proposal_hub](#proposal_hub).

Nach vollständigem Block im Lesetest: `{"heardAuthority": true}`.

<a id="proposal_hub"></a>
## Angebot verstanden – Nachfragen und bewusste Entscheidung

**Stage 30 · proposal_hub**

Voraussetzung im Lesetest: `{"returned": true, "heardPlan": true, "heardMethod": true, "heardAuthority": true}`.

- Are you offering your service, or asking to join us? (`NHV_Q00_030_1030`) → [motive](#motive)
- Words of devotion won't make a killer trustworthy. (`NHV_Q00_030_1031`) → [trust](#trust)
- A test wouldn't have saved us from Astrid. (`NHV_Q00_030_1032`) → [astrid_warning](#astrid_warning)
- What happens if a candidate refuses? (`NHV_Q00_030_1033`) → [refusal](#refusal)
- We already have initiates. What do they lack? (`NHV_Q00_030_1034`) → [initiates](#initiates) — nur bei `{"initiates": true}`
- Why did you leave Cheydinhal? (`NHV_Q00_030_1035`) → [cheydinhal](#cheydinhal) — nur bei `{"cicero": true}`
- Where would we put these new members? (`NHV_Q00_030_1036`) → [space](#space)
- We'll recruit carefully. I'll judge each candidate myself. (`NHV_Q00_030_1037`) → [accept](#accept) — nur bei `{"heardPlan": true, "heardMethod": true, "heardAuthority": true, "returned": true}`
- I'm not ready to bring strangers into this family. (`NHV_Q00_030_1038`) → [proposal_wait](#proposal_wait)

<a id="motive"></a>
## Veyras Dienst – My Dread Father

**Stage 30 · motive**

**Veyra** · `NHV_Q00_030_1039` · Neutral 30

> My Dread Father has not lacked for deaths. Your Brotherhood lacks people to carry on its work.

**Veyra** · `NHV_Q00_030_1040` · Neutral 30

> I offer my service to the Mother. I am not asking to join your Brotherhood.

**Veyra** · `NHV_Q00_030_1041` · Happy 15

> If you accept, I will stay and keep the ledger. You will have ample time to regret my handwriting.


Weiter → [proposal_hub](#proposal_hub).

<a id="trust"></a>
## Glaube ist keine Absolution

**Stage 30 · trust**

**Veyra** · `NHV_Q00_030_1042` · Neutral 30

> Agreed. Anyone can learn the words. Watch what remains when speaking them costs something.

**Veyra** · `NHV_Q00_030_1043` · Neutral 30

> A person may begin with hatred. What matters is whether they can serve anything beyond it.

**Nazir** · `NHV_Q00_030_1044` · Neutral 30

> And if they can't, we find out before they learn where we sleep.


Weiter → [proposal_hub](#proposal_hub).

<a id="astrid_warning"></a>
## Kein Versprechen vollkommener Sicherheit

**Stage 30 · astrid_warning**

**Veyra** · `NHV_Q00_030_1045` · Neutral 30

> No test promises that. Astrid had a family. She still chose to betray it.

**Veyra** · `NHV_Q00_030_1046` · Neutral 30

> We keep watching after the invitation. So should you.

**Babette** · `NHV_Q00_030_1047` · Anger 25

> And this time, if someone starts making private arrangements for our safety, we ask whose throat pays for them.


Weiter → [proposal_hub](#proposal_hub).

<a id="refusal"></a>
## Ablehnung und Gefahr unterscheiden

**Stage 30 · refusal**

**Veyra** · `NHV_Q00_030_1048` · Neutral 30

> Then there is no recruit. Refusing an invitation is not the same as betraying the family.

**Veyra** · `NHV_Q00_030_1049` · Neutral 30

> If they threaten us, you judge that danger. I will not call every refusal a threat.


Weiter → [proposal_hub](#proposal_hub).

<a id="initiates"></a>
## Vorhandene Initiates respektieren

**Stage 30 · initiates**

Voraussetzung im Lesetest: `{"initiates": true}`.

**Veyra** · `NHV_Q00_030_1050` · Neutral 30

> Nothing we have established. They have a place here. We should learn what they can do.

**Veyra** · `NHV_Q00_030_1051` · Neutral 30

> My ledger extends the search. It does not erase those who have already arrived.


Weiter → [proposal_hub](#proposal_hub).

<a id="cheydinhal"></a>
## Der Abschied und seine Kosten

**Stage 30 · cheydinhal**

**Veyra** · `NHV_Q00_030_1052` · Neutral 30

> My Dread Father had other work for me. Work that could not wait.

**Veyra** · `NHV_Q00_030_1053` · Neutral 30

> I left. Cicero remained with the Mother. Duty does not spare the people we leave behind.


Weiter → [cheydinhal_tail](#cheydinhal_tail).

<a id="cheydinhal_tail"></a>
## Cicero lebt – die offene Wunde

**Stage 30 · cheydinhal_tail**

Nur bei `{"cicero": true}`; sonst [proposal_hub](#proposal_hub).

**Veyra** · `NHV_Q00_030_1054` · Sad 30

> He has cause to resent me. I will answer him myself when he is willing to hear it.


Weiter → [proposal_hub](#proposal_hub).

<a id="space"></a>
## Eine Spur zum Raum, keine Zusage über seinen Zustand

**Stage 30 · space**

**Veyra** · `NHV_Q00_030_1055` · Neutral 30

> I noticed an illusion over one of the walls. It may conceal a passage.

**Veyra** · `NHV_Q00_030_1056` · Neutral 30

> If there are usable chambers beyond it, we could make room. I haven't seen what waits inside.


Weiter → [proposal_hub](#proposal_hub).

<a id="proposal_wait"></a>
## Angebot vertagt

**Stage 30 · proposal_wait**

**Veyra** · `NHV_Q00_030_1057` · Neutral 30

> Then we wait. You know what I am offering. Come back when you have an answer.


Gespräch pausiert; beim Wiederansprechen → [proposal_hub](#proposal_hub).

<a id="accept"></a>
## Ausdrücklicher Auftrag zur Rekrutierung

**Stage 30 · accept**

*Regie: Erst nach letzter Response Stage 40. Einstieg fordert alle drei Pflichtblöcke; noch kein Q01-Start.*

**Veyra** · `NHV_Q00_030_1058` · Neutral 30

> Then I will bring you leads. You will decide which become invitations.

**Nazir** · `NHV_Q00_030_1059` · Neutral 30

> I'll see to the people you bring back. You see to making them worth the trouble.

**Veyra** · `NHV_Q00_030_1060` · Neutral 30

> First, let us look for room. There is a concealed passage I would like you to see.


Weiter → [veil](#veil).

Nach vollständigem Block im Lesetest: `{"accepted": true}`.

<a id="veil"></a>
## Türszene A – Warum diese Wand

**Stage 40 · veil**

Voraussetzung im Lesetest: `{"accepted": true}`.

*Regie: Szene A: fünf Phasen. Tür erst nach Veyras letzter Zeile enthüllen; kein erfundener Urheber.*

**Veyra** · `NHV_Q00_040_1000` · Neutral 30

> Here. The stone seems continuous, but the light along this edge does not belong to it.

**Nazir** · `NHV_Q00_040_1001` · Neutral 30

> I've walked past this wall more times than I care to count.

**Veyra** · `NHV_Q00_040_1002` · Neutral 30

> It was meant to escape notice. Whoever laid the veil knew their craft.

**Babette** · `NHV_Q00_040_1003` · Happy 20

> Do be careful. I'd hate to lose the recruits before we've even found them.

**Veyra** · `NHV_Q00_040_1004` · Neutral 30

> Stand clear. I will loosen the veil. We will see what it was hiding.


Weiter → [door_revealed](#door_revealed).

<a id="door_revealed"></a>
## Türszene B – Reaktion auf die sichtbare Tür

**Stage 50 · door_revealed**

*Regie: Sichtbare Tür ist Voraussetzung. Szene B vor Bewegung; keine Behauptung, dass Kammern bereits sicher sind.*

**Nazir** · `NHV_Q00_050_1000` · Neutral 30

> A door. I'll admit that's an improvement on a wall.

**Veyra** · `NHV_Q00_050_1001` · Neutral 30

> Old stonework. We will inspect the rooms before anyone brings down a bed.

**Babette** · `NHV_Q00_050_1002` · Neutral 30

> Or a coffin. Some of us have standards.


Weiter → [entry_cicero](#entry_cicero).

<a id="entry_cicero"></a>
## Optionaler Kommentar des Keepers

**Stage 50 · entry_cicero**

Nur bei `{"cicero": true}`; sonst [entry_hub](#entry_hub).

**Cicero** · `NHV_Q00_050_1003` · Neutral 35

> Mother stays where Mother is. Cicero will inspect the new corners first.


Weiter → [entry_hub](#entry_hub).

<a id="entry_hub"></a>
## Vor dem gemeinsamen Eintritt

**Stage 50 · entry_hub**

- We enter together. Keep close. (`NHV_Q00_050_1004`) → [entry](#entry)
- Wait. Let me get ready before we go down. (`NHV_Q00_050_1005`) → [entry_wait](#entry_wait)

<a id="entry_wait"></a>
## An der offenen Tür warten

**Stage 50 · entry_wait**

**Nazir** · `NHV_Q00_050_1006` · Neutral 30

> Take your time. I'll watch the opening.


Gespräch pausiert; beim Wiederansprechen → [entry_hub](#entry_hub).

<a id="entry"></a>
## Gemeinsamer Eintritt und Sicherung

**Stage 50 · entry**

*Regie: Danach gemeinsam eintreten; im Spiel Eintritt und Draugr-Kampf abwarten. Vorschau-Schaltfläche simuliert das Ende beider Ereignisse.*

**Veyra** · `NHV_Q00_050_1007` · Neutral 30

> Listener, take the lead. I will watch the passage behind us.

**Nazir** · `NHV_Q00_050_1008` · Neutral 30

> Babette, with me. Nobody wanders off.

**Babette** · `NHV_Q00_050_1009` · Happy 20

> You make exploring a tomb sound positively domestic.


Weiter → [cleared](#cleared).

<a id="cleared"></a>
## Nach den Draugr – vorsichtige Bestandsaufnahme

**Stage 50 · cleared**

**Nazir** · `NHV_Q00_050_1010` · Neutral 30

> That accounts for the welcome. Let's check the remaining corners.

**Veyra** · `NHV_Q00_050_1011` · Neutral 30

> Burial chambers, by the look of them. The dead have had the larger share of this house.

**Babette** · `NHV_Q00_050_1012` · Neutral 30

> They won't miss the elbow room.


Weiter → [rooms](#rooms).

<a id="rooms"></a>
## Was die Räume mit Rekrutierung zu tun haben

**Stage 50 · rooms**

*Regie: Rundgang zu Hall/Ledger Room; keine Freischaltung des späteren Dormitory. Danach erst zur Memorial Wall und Stage 60.*

**Veyra** · `NHV_Q00_050_1013` · Neutral 30

> This hall could take a table. A place to eat, hear reports, and discover whom not to sit beside whom.

**Nazir** · `NHV_Q00_050_1014` · Neutral 30

> The other chambers need clearing. We can make them useful a few at a time.

**Veyra** · `NHV_Q00_050_1015` · Neutral 30

> There is space for my ledger and your reports here. I can work while you are away.

**Veyra** · `NHV_Q00_050_1016` · Neutral 30

> No point furnishing beds for people we haven't met. Let us begin with the names we already know.


Weiter → [memorial_intro](#memorial_intro).

<a id="memorial_intro"></a>
## Gedenkwand vor der nächsten Einladung

**Stage 60 · memorial_intro**

**Veyra** · `NHV_Q00_060_1000` · Sad 40

> This wall will serve. Festus. Gabriella. Arnbjorn. Veezara. Their names should remain where the family can see them.

**Nazir** · `NHV_Q00_060_1001` · Neutral 30

> Names first. The people we bring here can learn what they meant.


Weiter → [cicero_dead](#cicero_dead).

<a id="cicero_dead"></a>
## Optional – der tote Keeper

**Stage 60 · cicero_dead**

Nur bei `{"cicero": false}`; sonst [memorial_hub](#memorial_hub).

**Veyra** · `NHV_Q00_060_1002` · Sad 40

> And Cicero. Whatever came between you, he carried the Mother when she had few hands left.


Weiter → [memorial_hub](#memorial_hub).

<a id="memorial_hub"></a>
## Erinnerung und Astrids Eintrag

**Stage 60 · memorial_hub**

**Veyra** · `NHV_Q00_060_1003` · Neutral 30

> There is one name I will leave to you. Astrid led them. She also betrayed them.

- Did you know the people we're remembering? (`NHV_Q00_060_1004`) → [memorial_knowledge](#memorial_knowledge)
- Carve Astrid's name alongside the others. (`NHV_Q00_060_1005`) → [memorial_equal](#memorial_equal)
- Leave Astrid's name off the wall. (`NHV_Q00_060_1006`) → [memorial_none](#memorial_none)
- Put Astrid below the others, in smaller letters. (`NHV_Q00_060_1007`) → [memorial_small](#memorial_small)

<a id="memorial_knowledge"></a>
## Kein erfundener gemeinsamer Lebenslauf

**Stage 60 · memorial_knowledge**

**Veyra** · `NHV_Q00_060_1008` · Neutral 30

> I know their names. You knew their lives. I will not pretend those are the same.

**Veyra** · `NHV_Q00_060_1009` · Neutral 30

> If you wish to tell me about them, I will listen.


Weiter → [memorial_hub](#memorial_hub).

<a id="memorial_equal"></a>
## Astrid – gemeinsamer Eintrag

**Stage 60 · memorial_equal**

**Veyra** · `NHV_Q00_060_1010` · Neutral 30

> Then she will be named with them.

**Nazir** · `NHV_Q00_060_1011` · Neutral 30

> I'll remember what she cost us. The stone can carry the rest.


Weiter → [first_lead](#first_lead).

Nach vollständigem Block im Lesetest: `{"memorial": 1}`.

<a id="memorial_none"></a>
## Astrid – kein Eintrag

**Stage 60 · memorial_none**

**Veyra** · `NHV_Q00_060_1012` · Neutral 30

> The others' names will stand without hers.

**Nazir** · `NHV_Q00_060_1013` · Neutral 30

> There are enough things in this house I would rather not look at.


Weiter → [first_lead](#first_lead).

Nach vollständigem Block im Lesetest: `{"memorial": 2}`.

<a id="memorial_small"></a>
## Astrid – kleiner Eintrag darunter

**Stage 60 · memorial_small**

**Veyra** · `NHV_Q00_060_1014` · Neutral 30

> Below them. Her place in the story, without their place of honor.

**Nazir** · `NHV_Q00_060_1015` · Neutral 30

> That, I can live with.


Weiter → [first_lead](#first_lead).

Nach vollständigem Block im Lesetest: `{"memorial": 3}`.

<a id="first_lead"></a>
## Der erste Auftrag – Person und Zweck

**Stage 60 · first_lead**

*Regie: Tod ist Gerücht, Hrefnas Täterschaft bleibt Q01-Ermittlung. Kein direkt empfangener Night-Mother-Auftrag behauptet.*

**Veyra** · `NHV_Q00_060_1016` · Neutral 30

> Now, the first name in my ledger. Hrefna Stormhollow, near Morthal.

**Veyra** · `NHV_Q00_060_1017` · Neutral 30

> She performed the Black Sacrament against a moneylender who took her farm. No assassin came.

**Veyra** · `NHV_Q00_060_1018` · Neutral 30

> Weeks later, he was found dead in the marsh. An accident, according to those who prefer not to ask.

**Veyra** · `NHV_Q00_060_1019` · Neutral 30

> I want you to find Hrefna. Learn whether she killed him, and what she has become since.


Weiter → [lead_hub](#lead_hub).

<a id="lead_hub"></a>
## Den Untersuchungsauftrag klären

**Stage 60 · lead_hub**

- A desperate murder doesn't make her one of us. (`NHV_Q00_060_1020`) → [lead_judgment](#lead_judgment)
- Where should I begin looking? (`NHV_Q00_060_1021`) → [lead_where](#lead_where)
- Why did no one answer her sacrament? (`NHV_Q00_060_1022`) → [lead_silence](#lead_silence)
- I'll investigate Hrefna. I haven't promised her a place. (`NHV_Q00_060_1023`) → [lead_accept](#lead_accept)
- I need a moment before we discuss the journey. (`NHV_Q00_060_1024`) → [lead_wait](#lead_wait)

<a id="lead_judgment"></a>
## Keine Vorentscheidung für den Spieler

**Stage 60 · lead_judgment**

**Veyra** · `NHV_Q00_060_1025` · Neutral 30

> Precisely. Grief may have moved her once. It tells us little about what she would do tomorrow.

**Veyra** · `NHV_Q00_060_1026` · Neutral 30

> Find out before you offer anything. We are looking for a person, not collecting a debt.


Weiter → [lead_hub](#lead_hub).

<a id="lead_where"></a>
## Konkreter nächster Schritt

**Stage 60 · lead_where**

**Veyra** · `NHV_Q00_060_1027` · Neutral 30

> Morthal. Ask Hakan Reed-Walker, a fisherman, about the death of Eirik Ashmark. The names are in my ledger.

**Veyra** · `NHV_Q00_060_1028` · Neutral 30

> Follow what you find to Hrefna. Then bring me what you learned. We will decide how to test her.


Weiter → [lead_hub](#lead_hub).

<a id="lead_silence"></a>
## Keine erfundene Antwort auf das Schweigen

**Stage 60 · lead_silence**

**Veyra** · `NHV_Q00_060_1029` · Neutral 30

> I know she waited through the family's troubles. I cannot tell you what the Mother heard in that time.

**Veyra** · `NHV_Q00_060_1030` · Neutral 30

> Hrefna knows only that no one came. Begin with what that did to her.


Weiter → [lead_hub](#lead_hub).

<a id="lead_wait"></a>
## Auftrag noch nicht angenommen

**Stage 60 · lead_wait**

**Veyra** · `NHV_Q00_060_1031` · Neutral 30

> Of course. A journey into the marsh deserves at least a dry pair of boots.


Gespräch pausiert; beim Wiederansprechen → [lead_hub](#lead_hub).

<a id="lead_accept"></a>
## Briefing abgeschlossen

**Stage 60 · lead_accept**

*Regie: FinishQ00Contract beendet Q00 nach dem ersten Contract; Lucien wurde bereits im Standoff gerufen.*

**Veyra** · `NHV_Q00_060_1032` · Neutral 30

> Good. Morthal first, Hakan Reed-Walker, then the farm. I have written down what I know.


Weiter → [end](#end).

<a id="end"></a>
## Q00 abgeschlossen – Q01 und spätere Nachfrage

**Stage 100 · end**

*Regie: The Gleaner's Ledger erhalten; Q01 Morthal-Ziel aktiv. Vorschau simuliert nur die Übergabe.*

- Regie: Lesetest beenden → [finished](#finished)

<a id="finished"></a>
## Ende des Lesetests

**Stage 100 · finished**


## Journalvarianten

**Stage 10 · V2_JournalObjective** · `NHV_Q00_010_1039`

> Find out why the stranger has come to the Sanctuary.

**Stage 10 · V2_JournalLog** · `NHV_Q00_010_1040`

> A stranger entered the Sanctuary. She spoke of Sithis' call and a new harvest, but had yet to explain what she meant.

**Stage 12 · V2_JournalObjective** · `NHV_Q00_012_1014`

> Witness Veyra's proof.

**Stage 12 · V2_JournalLog** · `NHV_Q00_012_1015`

> Before Veyra left the Sanctuary, Lucien Lachance appeared and vouched for her willing service to Sithis.

**Stage 20 · V2_JournalObjective** · `NHV_Q00_020_1022`

> Ask the Night Mother about Veyra.

**Stage 20 · V2_JournalLog** · `NHV_Q00_020_1023`

> Veyra agreed to wait at the Windpeak Inn while you sought the Night Mother's judgment.

**Stage 30 · V2_JournalObjective** · `NHV_Q00_030_1061`

> Bring Veyra back from the Windpeak Inn.

**Stage 30 · V2_JournalLog** · `NHV_Q00_030_1062`

> The Night Mother permitted Veyra to offer her service. You still had to hear and decide upon her plan.

**Stage 30 · V2_JournalObjective** · `NHV_Q00_030_1063`

> Hear Veyra's recruitment plan in the Sanctuary.

**Stage 30 · V2_JournalLog** · `NHV_Q00_030_1064`

> Veyra returned with you. She needed to explain how candidates would be found, tested, and admitted.

**Stage 40 · V2_JournalObjective** · `NHV_Q00_040_1005`

> Inspect the concealed passage with Veyra.

**Stage 40 · V2_JournalLog** · `NHV_Q00_040_1006`

> You agreed to investigate possible recruits and judge each yourself. Veyra offered to uncover rooms that might house them.

**Stage 50 · V2_JournalObjective** · `NHV_Q00_050_1017`

> Enter and explore the hidden chambers with the family.

**Stage 50 · V2_JournalLog** · `NHV_Q00_050_1018`

> Veyra revealed a doorway. The chambers beyond still needed to be explored and secured.

**Stage 60 · V2_JournalObjective** · `NHV_Q00_060_1033`

> Decide how Astrid should be remembered.

**Stage 60 · V2_JournalLog** · `NHV_Q00_060_1034`

> You reached the memorial wall. Veyra left Astrid's place among the fallen to your judgment.

**Stage 60 · V2_JournalObjective** · `NHV_Q00_060_1035`

> Hear the first lead in Veyra's ledger.

**Stage 60 · V2_JournalLog** · `NHV_Q00_060_1036`

> You chose Astrid's memorial. Veyra was ready to explain why Hrefna Stormhollow might be worth finding.

**Stage 80 · V2_JournalObjective** · `NHV_Q00_080_1009`

> Decide whether to hear Veyra's witness.

**Stage 80 · V2_JournalLog** · `NHV_Q00_080_1010`

> You agreed to investigate Hrefna. Veyra offered to call someone who could speak about her past service.

**Stage 100 · V2_JournalObjective** · `NHV_Q00_100_1017`

> Travel to Morthal and ask Hakan about Eirik's death.

**Stage 100 · V2_JournalLog** · `NHV_Q00_100_1018`

> Veyra gave you her ledger. You had accepted an investigation into Hrefna's actions, not her membership in the family.
