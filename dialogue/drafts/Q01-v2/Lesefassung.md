# Q01 V2 – The Unanswered Sacrament

**Inaktive Lesefassung vom 29.09.2026.** Aus CSV und flow.json erzeugt. Aktive Dialoge und Stimmen bleiben erhalten.

Anschluss: Q00 abgeschlossen, Veyras Ledger erhalten. Hrefna ist eine mögliche Kandidatin; der Listener hat ihr keinen Platz versprochen.

Die Auswahlziele verlinken Folgegespräche. Regieknöpfe simulieren Weltvorgänge. Conditions/Gates sind hier ein Autorenablauf, keine fertige Plugin-Integration.

<a id="start"></a>
## Stage 10 · Nach Q00 – eine Kandidatin suchen, keine Aufnahme versprechen

**Regie:** Q00 ist abgeschlossen, The Gleaner's Ledger erhalten. Hrefna, Eirik und Hakan sind eingeführt. Der Rückblick ist optional; kein Wissen über Lucien erforderlich.

- [Regie: Nach Morthal reisen und Hakan ansprechen](#hakan_start)
- [Regie: Vor der Reise Veyra noch einmal nach dem Auftrag fragen](#brief)

<a id="brief"></a>
## Stage 10 · Der Auftrag bleibt eine Ermittlung

**Veyra** · `NHV_Q01_010_1000`

> Hrefna Stormhollow. Begin with Hakan in Morthal. He found Eirik Ashmark's body.

**Veyra** · `NHV_Q01_010_1001`

> A drowned man and a desperate petitioner. Find out what joins them before you offer her anything.

- [You haven't promised her a place?](#brief_place) · `NHV_Q01_010_1002`
- [And if this leads nowhere?](#brief_empty) · `NHV_Q01_010_1003`
- [I'll hear Hakan's account first.](#hakan_start) · `NHV_Q01_010_1004`

<a id="brief_place"></a>
## Stage 10 · Keine Zusage hinter dem Rücken des Listeners

**Veyra** · `NHV_Q01_010_1005`

> I have written her name in a ledger, not above a bed. There is a difference.

Weiter: [brief](#brief).

<a id="brief_empty"></a>
## Stage 10 · Ergebnisoffene Untersuchung

**Veyra** · `NHV_Q01_010_1006`

> Then her name remains a question. An empty trail proves little. We can look elsewhere without pretending we have judged her.

Weiter: [brief](#brief).

<a id="hakan_start"></a>
## Stage 10 · Morthal – den genannten Zeugen finden

**Hakan** · `NHV_Q01_010_1007`

> If you're after fish, come earlier. If you're after talk, tell me whose.

- [Eirik Ashmark. I was told you found him.](#hakan_body) · `NHV_Q01_010_1008`

<a id="hakan_body"></a>
## Stage 10 · Was Hakan sah – und was nicht

**Hakan** · `NHV_Q01_010_1009`

> Aye. Face down in the reeds. His purse was still on him. I called for help, but there was nothing left to help.

**Hakan** · `NHV_Q01_010_1010`

> They said he slipped. Could have. I didn't see him fall.

- [What ties him to Hrefna Stormhollow?](#hakan_farm) · `NHV_Q01_010_1011`
- [You don't sound convinced it was an accident.](#hakan_doubt) · `NHV_Q01_010_1012`

<a id="hakan_doubt"></a>
## Stage 10 · Verdacht ist kein Augenzeugenbericht

**Hakan** · `NHV_Q01_010_1013`

> A man who takes farms ought to expect enemies. Doesn't mean an enemy put him in the water.

**Hakan** · `NHV_Q01_010_1014`

> Ask about the living. The dead give you less to go on.

Weiter: [hakan_body](#hakan_body).

<a id="hakan_farm"></a>
## Stage 10 · Pfändung, Hof und verschwundene Bäuerin

**Hakan** · `NHV_Q01_010_1015`

> He took her farm for debt. Stormhollow place, north of the river. Her husband drank. She tried to keep things growing.

**Hakan** · `NHV_Q01_010_1016`

> Now the house stands empty. There's an old hunting camp beyond it. She knows those paths better than most.

- [I'll look for her. What else should I know?](#hakan_warning) · `NHV_Q01_010_1017`
- [You knew her before all this?](#hakan_hrefna) · `NHV_Q01_010_1018`

<a id="hakan_hrefna"></a>
## Stage 10 · Hrefna war bereits jemand vor ihrem Mord

**Hakan** · `NHV_Q01_010_1019`

> She mended nets when the fields were frozen. Brought bread instead of asking if a man was hungry.

**Hakan** · `NHV_Q01_010_1020`

> Don't tell her I said that. She'll think I'm asking for some.

Weiter: [hakan_farm](#hakan_farm).

<a id="hakan_warning"></a>
## Stage 10 · Der andere Fragesteller wird eingeführt

**Hakan** · `NHV_Q01_010_1021`

> There's an Imperial asking after her too. Quintus Aufidius. Staying at the Moorside. Says he's a trader.

**Hakan** · `NHV_Q01_010_1022`

> Asked who visited her. Who bought candles. Who knew the cellar. Not once what the barley cost.

- [Why are you telling me this?](#hakan_pressure) · `NHV_Q01_010_1023`
- [I'll speak to this trader before I leave.](#quintus_cover) · `NHV_Q01_010_1024`
- [The farm first. I won't trouble you further.](#farm) · `NHV_Q01_010_1025`

<a id="hakan_pressure"></a>
## Stage 10 · Hakan spricht aus eigenem Interesse

**Hakan** · `NHV_Q01_010_1026`

> He found an old debt of mine. Keeps bringing it up whenever my memory disappoints him.

**Hakan** · `NHV_Q01_010_1027`

> I want him finished with my name. That's all. Don't make it sound finer.

Weiter: [hakan_warning](#hakan_warning).

<a id="quintus_cover"></a>
## Stage 10 · Optional: der höfliche Ermittler unter Tarnung

**Regie:** Optionales frühes Gespräch im Moorside. Quintus bestätigt hier keine Oculatus-Zugehörigkeit; Hakan hat zuvor seinen Namen genannt.

**Quintus** · `NHV_Q01_010_1028`

> A new face. Are you staying long? I find it helps to know who else is traveling these roads.

- [Hakan says you've been asking about the Stormhollow farm.](#quintus_accounts) · `NHV_Q01_010_1029`
- [What do you trade in?](#quintus_trade) · `NHV_Q01_010_1030`
- [I'll leave you to your business.](#farm) · `NHV_Q01_010_1031`

<a id="quintus_accounts"></a>
## Stage 10 · Eine Tarnantwort, kein Beweis

**Regie:** Quintus gibt eine unverbindliche geschäftliche Erklärung. Kein Nachweis seiner Behörde.

**Quintus** · `NHV_Q01_010_1032`

> Unsettled accounts. A dead man's obligations do not always die with him.

**Quintus** · `NHV_Q01_010_1033`

> If you meet anyone recently acquainted with the Stormhollow farm, I would be grateful for a name.

Weiter: [quintus_cover](#quintus_cover).

<a id="quintus_trade"></a>
## Stage 10 · Zuvorkommend und kontrollierend

**Quintus** · `NHV_Q01_010_1034`

> Whatever the district needs. Grain when the harvest fails. Information when a customer proves unreliable.

**Quintus** · `NHV_Q01_010_1035`

> You seem particularly interested in the second.

Weiter: [quintus_cover](#quintus_cover).

<a id="farm"></a>
## Stage 20 · Den leeren Hof und den Wurzelkeller untersuchen

**Regie:** Weltvorgang: Hakan hat den Hof und das Jagdlager genannt. Der Spieler findet Ritualreste im Keller. Hrefna ist hier noch keine Gesprächspartnerin. Die Untersuchung startet erst danach die Begegnung am Lager.

**Fundstück: EirikDemandNotice** · `NHV_SYS_BOOK_55` · unveränderte Buchreferenz

> NOTICE OF DEBT
> 
> To Hrefna Stormhollow: payment is overdue. The west field, livestock, tools, and dwelling are collateral against the outstanding sum.

**Fundstück: HrefnaUnsentLetter** · `NHV_SYS_BOOK_46` · unveränderte Buchreferenz

> UNSENT LETTER
> 
> To the Mother in the dark: Eirik Ashmark is taking the farm, the animals, and whatever is left of my husband's name. I ask for an answer.

- [Regie: Tagebuchauszug und Hofunterlagen lesen](#diary)
- [Regie: Ritualreste untersuchen und Hrefnas Spur zum Jagdlager folgen](#camp)

<a id="diary"></a>
## Stage 20 · Freiwillige Lektüre – keine automatische Schuldzuweisung

**Regie:** Unveränderte Buchauszüge aus dem aktiven Master als Referenz. Hrefnas Selbstkorrektur begründet Verdacht; sie ersetzt ihr späteres Geständnis nicht.

**Fundstück: HrefnaMoorJournal** · `NHV_SYS_BOOK_50` · unveränderte Buchreferenz

> NOTES FROM THE MOOR
> 
> Day seven: no answer. Eirik sent another boy to measure the fence. The boy would not meet my eyes.

**Fundstück: HrefnaMoorJournal** · `NHV_SYS_BOOK_52` · unveränderte Buchreferenz

> Day forty-two: the answer did not come. I found Eirik at the waterline, laughing at the deed in his hand. I asked him to give it back.

**Fundstück: HrefnaMoorJournal** · `NHV_SYS_BOOK_53` · unveränderte Buchreferenz

> He said the farm was already his. I keep writing that he slipped. I keep crossing it out.

**Fundstück: HrefnaDiaryExcerpt** · `NHV_SYS_BOOK_86` · unveränderte Buchreferenz

> HREFNA'S DIARY — SIXTH WEEK
> 
> The wick burned out before the answer came. I lit another. I wrote the words again. The page stayed dry.
> 
> Tomorrow I go to the bog. I will ask him once. Then I will stop asking.

- [Regie: Nachts das Jagdlager aufsuchen](#camp)

<a id="camp"></a>
## Stage 30 · Hrefna stellt den Fremden aus ihrem Keller

Voraussetzung: `{"investigated": true}`.

**Hrefna** · `NHV_Q01_030_1000`

> Stop there. Hands where I can see them. You came out of my cellar.

**Hrefna** · `NHV_Q01_030_1001`

> Did the Imperial send you? He's had enough answers from me.

- [I'm with the Dark Brotherhood. I came about your prayer.](#identify) · `NHV_Q01_030_1002`
- [Lower the bow. Let me tell you why I'm here.](#calm) · `NHV_Q01_030_1003`
- [I read your diary. You waited six weeks.](#diary_confront) · `NHV_Q01_030_1004` · nur `{"diary": true}`

<a id="calm"></a>
## Stage 30 · Keine falsche Sicherheitsgarantie

**Hrefna** · `NHV_Q01_030_1005`

> Then tell me from there. I've listened to promises at closer range.

- [The Brotherhood sent me to find you.](#identify) · `NHV_Q01_030_1006`

<a id="diary_confront"></a>
## Stage 30 · Wissen stammt aus tatsächlich gelesenen Unterlagen

**Hrefna** · `NHV_Q01_030_1007`

> That wasn't written for strangers. Or for him.

**Hrefna** · `NHV_Q01_030_1008`

> Who are you?

- [Someone from the Brotherhood. Someone who came late.](#identify) · `NHV_Q01_030_1009`

<a id="identify"></a>
## Stage 30 · Erst die Identität klären, dann ihre Geschichte

**Hrefna** · `NHV_Q01_030_1010`

> The Brotherhood. Now.

**Hrefna** · `NHV_Q01_030_1011`

> Put your weapon away. I'll lower mine. Then you can explain where you've been.

Weiter: [accusation](#accusation).

<a id="accusation"></a>
## Stage 40 · Sechs Wochen – ihre Erwartung, keine göttliche Diagnose

**Hrefna** · `NHV_Q01_040_1000`

> Six weeks I waited. Said the words. Kept the candles burning. Eirik took the farm all the same.

**Hrefna** · `NHV_Q01_040_1001`

> I thought I'd hear a knock. Instead I heard him coming for the keys.

- [Our Sanctuary was destroyed. I can't account for every unanswered prayer.](#loss) · `NHV_Q01_040_1002`
- [I can't undo the waiting. I can hear you now.](#late_answer) · `NHV_Q01_040_1003`
- [I'll hear what happened before I offer excuses.](#listen) · `NHV_Q01_040_1004`

<a id="loss"></a>
## Stage 40 · Falkreath erklärt Verluste, keine exakte Ritualchronologie

**Hrefna** · `NHV_Q01_040_1005`

> Falkreath. I'd heard there was a fire. Didn't know it was your people.

**Hrefna** · `NHV_Q01_040_1006`

> That doesn't give me the weeks back. I suppose it doesn't give you yours either.

Weiter: [confession](#confession).

<a id="late_answer"></a>
## Stage 40 · Verspätete Hilfe wird nicht romantisiert

**Hrefna** · `NHV_Q01_040_1007`

> Hear me, then. Don't tell me it all happened for a reason.

Weiter: [confession](#confession).

<a id="listen"></a>
## Stage 40 · Der Listener lässt ihr die Aussage

**Hrefna** · `NHV_Q01_040_1008`

> Good. I've had enough reasons given to me.

Weiter: [confession](#confession).

<a id="confession"></a>
## Stage 40 · Das Geständnis kommt von Hrefna selbst

**Hrefna** · `NHV_Q01_040_1009`

> Eirik came to the water with the deed. I asked for the farm back. He laughed.

**Hrefna** · `NHV_Q01_040_1010`

> I held him under. He stopped fighting. I kept holding him.

**Hrefna** · `NHV_Q01_040_1011`

> I've called it a fall so often I almost hear a splash that never happened.

Weiter: [story_hub](#story_hub).

<a id="story_hub"></a>
## Stage 40 · Was die Tat erklärt – und was sie nicht entschuldigt

Voraussetzung: `{"confessed": true}`.

- [Did you think his death would give the farm back?](#farm_after) · `NHV_Q01_040_1012`
- [What did you want from the Night Mother?](#prayer) · `NHV_Q01_040_1013`
- [And your husband?](#husband) · `NHV_Q01_040_1014`
- [You regret killing him?](#remorse) · `NHV_Q01_040_1015`
- [The Imperial you mentioned. What does he know?](#threat) · `NHV_Q01_040_1016`
- [I need time to consider what you've told me.](#story_wait) · `NHV_Q01_040_1017`

<a id="farm_after"></a>
## Stage 40 · Keine wundersame Aufhebung der Schulden

**Hrefna** · `NHV_Q01_040_1018`

> No. His papers are still papers. Someone else can come with them.

**Hrefna** · `NHV_Q01_040_1019`

> I wanted him gone. The rest was what I told myself while I waited.

Weiter: [story_hub](#story_hub).

<a id="prayer"></a>
## Stage 40 · Sakrament bedeutet Bitte, nicht Mitgliedschaft

**Hrefna** · `NHV_Q01_040_1020`

> Someone to take the choice out of my hands. That's the shame of it. I wanted him dead and wanted someone else to do it.

**Hrefna** · `NHV_Q01_040_1021`

> When no one came, I decided the silence meant something. Easier than admitting I didn't know.

- [I won't tell you what the Mother meant by it.](#prayer_limit) · `NHV_Q01_040_1022`
- [Calling us didn't make you one of us.](#prayer_family) · `NHV_Q01_040_1023`

<a id="prayer_limit"></a>
## Stage 40 · Der Listener erfindet keine Botschaft

**Hrefna** · `NHV_Q01_040_1024`

> Then we're both without an answer. At least you're not selling me one.

Weiter: [story_hub](#story_hub).

<a id="prayer_family"></a>
## Stage 40 · Eine offene Zukunft statt einer rückwirkenden Weihe

**Hrefna** · `NHV_Q01_040_1025`

> I wasn't asking to be family. I was asking for a death.

**Hrefna** · `NHV_Q01_040_1026`

> What I want now... I haven't had much room to think about that.

Weiter: [story_hub](#story_hub).

<a id="husband"></a>
## Stage 40 · Kein erfundenes Ende seiner Geschichte

**Hrefna** · `NHV_Q01_040_1027`

> He drank. I worked. After a while that was all we had to say to each other.

**Hrefna** · `NHV_Q01_040_1028`

> Leave him out of this. Eirik was under my hands, not his.

Weiter: [story_hub](#story_hub).

<a id="remorse"></a>
## Stage 40 · Widerspruch statt vollständiger Läuterung

**Hrefna** · `NHV_Q01_040_1029`

> I don't wish him back. I wish that wasn't the first thing I knew when I woke.

**Hrefna** · `NHV_Q01_040_1030`

> You can make what you like of that. I can't make it prettier.

Weiter: [story_hub](#story_hub).

<a id="story_wait"></a>
## Stage 40 · Nachdenken ist noch keine Entscheidung

**Hrefna** · `NHV_Q01_040_1031`

> I'll stay near the camp. There's nothing waiting for me in that house.

Weiter: [story_hub](#story_hub).

Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.

<a id="threat"></a>
## Stage 40 · Die Verbindung zwischen Quintus und der Bruderschaft

**Hrefna** · `NHV_Q01_040_1032`

> He asked about Eirik first. Then the candles. Then who I expected to come after I lit them.

**Hrefna** · `NHV_Q01_040_1033`

> He said he'd wait and see who found me. I don't think he's only looking for a murderer.

- [He may be watching whoever answers the prayer.](#offer) · `NHV_Q01_040_1034`

<a id="offer"></a>
## Stage 40 · Eine Prüfung anbieten, keinen Platz versprechen

**Hrefna** · `NHV_Q01_040_1035`

> And you walked straight to my cellar. What happens now?

- [You might have a place with us. First, hear what that would ask of you.](#hear_offer) · `NHV_Q01_040_1036`

<a id="hear_offer"></a>
## Stage 40 · Hrefna stimmt einem Gespräch zu

**Regie:** Hier endet das Geständnis. Vor dem Prüfungsbriefing muss Veyra sichtbar zum Gespräch kommen; kein unsichtbarer Sprecherwechsel.

**Hrefna** · `NHV_Q01_040_1037`

> A place isn't much of an answer without the price. I'll hear it.

Weiter: [veyra_arrives](#veyra_arrives).

<a id="veyra_arrives"></a>
## Stage 50 · Veyra tritt hinzu – erst Bericht, dann Urteil

Voraussetzung: `{"confessed": true}`.

**Regie:** Veyra nähert sich sichtbar aus dem Moor. Aufstellung im späteren Test-Build erforderlich; bestehendes MoveTo allein erzählt diese Ankunft nicht.

**Veyra** · `NHV_Q01_050_1000`

> Hakan told me which way you'd gone. I see you found someone more talkative than the marsh.

**Hrefna** · `NHV_Q01_050_1001`

> Another one? How many people know about this?

- [Veyra finds candidates. I decide who joins. She needs to hear this.](#field_report) · `NHV_Q01_050_1002`

<a id="field_report"></a>
## Stage 50 · Der Spieler übergibt das tatsächlich Erfahrene

- [Hrefna drowned Eirik. Quintus is watching for whoever answers her prayer.](#trial_brief) · `NHV_Q01_050_1003`

<a id="trial_brief"></a>
## Stage 50 · Warum dieser Mann ein Ziel wird

**Veyra** · `NHV_Q01_050_1004`

> Then his questions have brought him to your doorstep, Listener. He is following the prayer to the people who answer it.

**Veyra** · `NHV_Q01_050_1005`

> I propose we silence him. Hrefna would take the task, with you beside her.

- [Explain what this would prove before I agree.](#trial_meaning) · `NHV_Q01_050_1006`

<a id="trial_meaning"></a>
## Stage 50 · Die Aufgabe ist zugleich Gefahr und Prüfung

**Veyra** · `NHV_Q01_050_1007`

> Eirik was a personal grievance. Quintus is not. Can she undertake the family's work when hatred does not carry her hand?

**Hrefna** · `NHV_Q01_050_1008`

> So another body before I get a bed.

**Veyra** · `NHV_Q01_050_1009`

> A bed would be cheaper. This is a life of killing, Hrefna. You should know whether you can bear it before you enter.

**Veyra** · `NHV_Q01_050_1010`

> You will judge her afterward, Listener. Completing this task need not settle her place among you.

Weiter: [trial_hub](#trial_hub).

<a id="trial_hub"></a>
## Stage 50 · Nachfragen und ausdrückliche Freigabe

Voraussetzung: `{"briefed": true}`.

- [This is your proposal, not an order from the Mother.](#trial_mother) · `NHV_Q01_050_1011`
- [We don't even know who Quintus works for.](#trial_evidence) · `NHV_Q01_050_1012`
- [And if she cannot go through with it?](#trial_failure) · `NHV_Q01_050_1013`
- [Hrefna, you've heard the terms. Will you come with me?](#candidate_choice) · `NHV_Q01_050_1014`
- [I need time before I authorize this.](#trial_wait) · `NHV_Q01_050_1015`

<a id="trial_mother"></a>
## Stage 50 · Keine geliehene göttliche Autorität

**Veyra** · `NHV_Q01_050_1016`

> Precisely. I propose it. You authorize it. Let us not borrow her voice to make the choice easier.

Weiter: [trial_hub](#trial_hub).

<a id="trial_evidence"></a>
## Stage 50 · Verdacht und bekannte Gefahr auseinanderhalten

**Veyra** · `NHV_Q01_050_1017`

> No. We know what he is looking for. His papers may tell us whose questions he is asking.

**Veyra** · `NHV_Q01_050_1018`

> If you require more certainty before acting, take the time. I cannot give you evidence I do not have.

Weiter: [trial_hub](#trial_hub).

<a id="trial_failure"></a>
## Stage 50 · Unproven wird vor dem entscheidenden Moment erklärt

**Veyra** · `NHV_Q01_050_1019`

> You may finish the task yourself. You will have removed the danger, but you will not have answered the question about her.

**Hrefna** · `NHV_Q01_050_1020`

> Don't decide what I'll fail before I've stood there.

Weiter: [trial_hub](#trial_hub).

<a id="trial_wait"></a>
## Stage 50 · Eine noch nicht erteilte Freigabe

**Veyra** · `NHV_Q01_050_1021`

> Then we wait. Your permission should be worth more than my impatience.

Weiter: [trial_hub](#trial_hub).

Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.

<a id="candidate_choice"></a>
## Stage 50 · Hrefna sagt zu, ohne Stärke vorzutäuschen

**Hrefna** · `NHV_Q01_050_1022`

> I'll come. I can't promise what my hands will do when he's in front of me.

**Hrefna** · `NHV_Q01_050_1023`

> But I won't make you drag me there.

- [Then we deal with Quintus. I'll judge your place afterward.](#authorize) · `NHV_Q01_050_1024`
- [Not yet. I need to think.](#trial_wait) · `NHV_Q01_050_1025`

<a id="authorize"></a>
## Stage 50 · Freigabe und praktische Übergabe

**Veyra** · `NHV_Q01_050_1026`

> Keep his papers. Whatever you decide about Hrefna, I want to know how far his questions have reached.

**Hrefna** · `NHV_Q01_050_1027`

> He's staying at the Moorside. Said he'd be on the Solitude road in the morning. We can find him in either place.

Weiter: [route_choice](#route_choice).

<a id="route_choice"></a>
## Stage 50 · Die beiden vorgesehenen Begegnungen

- [We'll find him at the inn tonight.](#room) · `NHV_Q01_050_1028`
- [We'll meet him on the road in the morning.](#road) · `NHV_Q01_050_1029`
- [Wait here. I'm not ready to move.](#route_wait) · `NHV_Q01_050_1030`

<a id="route_wait"></a>
## Stage 50 · Vorbereitung ohne automatische Tötung

**Hrefna** · `NHV_Q01_050_1031`

> I'm not going anywhere near him alone.

Weiter: [route_choice](#route_choice).

Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.

<a id="room"></a>
## Stage 50 · Zimmer nachts – hinter der Tarnung liegt ein Privatleben

**Regie:** Weltvorgang: Zimmer erreichen, Brief sichtbar lesen; Quintus schläft. Weder Anreise noch Schleichen werden durch den Lesetest simuliert. Der neue Brieftext liegt nur im V2-Books-Master.

**Hrefna** · `NHV_Q01_050_1032`

> He's asleep. That sound... my husband snored like that. Never thought I'd miss it.

**Hrefna** · `NHV_Q01_050_1033`

> There's a letter by the bed. To his daughter. He wants to be home before Frostfall.

**Fundstück: V2_QuintusLetter** · `NHV_Q01_050_1053` · V2-Buchmaster

> To my little owl,
> 
> Your last letter caught up with me in Morthal. I have been counting other people's troubles again. You would say I ought to finish my own work before taking on theirs.

**Fundstück: V2_QuintusLetter** · `NHV_Q01_050_1054` · V2-Buchmaster

> I still hope to be home before Frostfall. Hope is an awkward word to send a child, but I would rather write it than promise another day I cannot keep.
> 
> Keep a page for me in your stories. I will bring mine.
> 
> Father

Weiter: [hesitation](#hesitation).

<a id="road"></a>
## Stage 50 · Straße morgens – Quintus erkennt Hrefna

**Quintus** · `NHV_Q01_050_1034`

> Stormhollow. I hoped we'd speak again. And you've brought company.

- [You seem eager to finish your business here.](#road_letter) · `NHV_Q01_050_1035`

<a id="road_letter"></a>
## Stage 50 · Seine private Bindung wird hörbar

**Regie:** In dieser Variante hört Hrefna selbst von der Tochter. Sie behauptet nicht, einen unzugänglichen Brief aus Quintus' Tasche gelesen zu haben. Kurzer Seitenwechsel zum Listener vor dem Angriff.

**Quintus** · `NHV_Q01_050_1036`

> I have a daughter waiting for word. Your answers would let me finish my report.

**Quintus** · `NHV_Q01_050_1037`

> Then perhaps I could keep my promise about Frostfall. Shall we walk?

Weiter: [hesitation](#hesitation).

<a id="hesitation"></a>
## Stage 50 · Eine Tochter macht ihn menschlich, nicht ungefährlich

**Hrefna** · `NHV_Q01_050_1038`

> A daughter. Waiting for him to come home.

**Hrefna** · `NHV_Q01_050_1039`

> Eirik laughed at me. This man hasn't even raised his voice. I thought that wouldn't matter. It does.

Weiter: [choice_kill](#choice_kill).

<a id="choice_kill"></a>
## Stage 50 · Der entscheidende Moment bleibt beim Spieler

Voraussetzung: `{"authorized": true}`.

**Regie:** Persuade im späteren Spiel gemäß bestehendem Schwellenwert Speech 30; Intimidate über den Engine-Check, nicht einen erfundenen ActorValue. Jeder Versuch einmal pro Begegnung. Kein Erfolg tötet Quintus unmittelbar.

- [(Persuade) His daughter is real. So is the danger. Can you still choose?](#persuade_test) · `NHV_Q01_050_1040` · nur `{"triedPersuade": false}`
- [(Intimidate) Finish it, or I'll count you among the loose ends.](#intimidate_test) · `NHV_Q01_050_1041` · nur `{"triedIntimidate": false}`
- [Stand back. I'll take responsibility for the killing.](#player_takes_over) · `NHV_Q01_050_1042`
- [Not now. We need to step away.](#withdraw) · `NHV_Q01_050_1043`

<a id="persuade_test"></a>
## Stage 50 · Überredung auswerten

Bedingung: `{"persuade": true}`. Sonst: [persuade_fail](#persuade_fail).

Weiter: [persuade_pass](#persuade_pass).

<a id="persuade_pass"></a>
## Stage 50 · Hrefna nimmt die Verantwortung an

**Hrefna** · `NHV_Q01_050_1044`

> I can. But don't call it mercy, and don't tell me I had no choice.

**Hrefna** · `NHV_Q01_050_1045`

> I had one. Remember that when you ask what happened.

Weiter: [hrefna_attack](#hrefna_attack).

<a id="persuade_fail"></a>
## Stage 50 · Ein Argument beseitigt keine Blockade

**Hrefna** · `NHV_Q01_050_1046`

> I understand you. My hands don't.

**Hrefna** · `NHV_Q01_050_1047`

> I can't be the reason she keeps waiting.

Weiter: [choice_kill](#choice_kill).

<a id="intimidate_test"></a>
## Stage 50 · Einschüchterung auswerten

Bedingung: `{"intimidate": true}`. Sonst: [intimidate_fail](#intimidate_fail).

Weiter: [intimidate_pass](#intimidate_pass).

<a id="intimidate_pass"></a>
## Stage 50 · Erzwungene Tat bleibt erzwungen

**Hrefna** · `NHV_Q01_050_1048`

> I heard you. Put that threat away. I've got enough to hold.

**Hrefna** · `NHV_Q01_050_1049`

> And don't ask me to thank you afterward.

Weiter: [hrefna_attack](#hrefna_attack).

<a id="intimidate_fail"></a>
## Stage 50 · Auch die Drohung kann scheitern

**Hrefna** · `NHV_Q01_050_1050`

> Then you've made your choice about me. It hasn't changed my hands.

Weiter: [choice_kill](#choice_kill).

<a id="withdraw"></a>
## Stage 50 · Abbruch für den Moment – kein erfundener Freilassungsabschluss

**Regie:** Stage 50 bleibt offen. Wiederansprechen setzt die noch verfügbaren Entscheidungen fort; erfolglose Checks werden nicht neu gewürfelt. Quintus wurde nicht endgültig freigelassen.

**Hrefna** · `NHV_Q01_050_1051`

> Yes. Away from him. I need to breathe.

Weiter: [choice_kill](#choice_kill).

Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.

<a id="player_takes_over"></a>
## Stage 50 · Die Prüfung bleibt offen

**Regie:** Ein Gesprächsabschluss ist noch kein Tod. Übergang erst nach tatsächlichem Kampf-/Todesereignis. Kein technischer Combat-Test.

**Hrefna** · `NHV_Q01_050_1052`

> I'll stand back. I won't pretend that means my hands are clean.

- [Regie: Weltvorgang: Spieler tötet Quintus](#kill_player)

<a id="hrefna_attack"></a>
## Stage 50 · Hrefna setzt zur Tat an

**Regie:** Die Reaktion richtet sich nach dem tatsächlichen Täter, nicht nach dem zuvor gewählten Speech-Check. Fremde Todesursachen bleiben vor Plugin-Aktivierung gesondert zu behandeln.

- [Regie: Weltvorgang: Hrefna tötet Quintus selbst](#kill_hrefna)
- [Regie: Weltvorgang: Spieler greift ein und tötet Quintus selbst](#kill_player)

<a id="kill_hrefna"></a>
## Stage 60 · Nach ihrer zweiten Tat

**Hrefna** · `NHV_Q01_060_1000`

> Twice. I thought the second would tell me something the first hadn't.

**Hrefna** · `NHV_Q01_060_1001`

> He's still dead. I'm still here. That's all I've got.

Weiter: [papers](#papers).

<a id="kill_player"></a>
## Stage 60 · Nach der übernommenen Tat

**Hrefna** · `NHV_Q01_060_1002`

> You did what I couldn't. Don't make it a kindness. We both know why we came.

Weiter: [papers](#papers).

<a id="papers"></a>
## Stage 60 · Quintus ist tot – die Unterlagen sind noch eine eigene Aufgabe

**Regie:** Erst jetzt bestätigt ein Dokument seine Behörde. Das Übersehen des Fragments blockiert den Abschluss nicht; Veyras spätere Bergung wird ausdrücklich erzählt.

- [Regie: Quintus' dienstliche Papiere sichern und lesen](#papers_read)
- [Regie: Die Unterlagen vorerst zurücklassen; mit Hrefna sprechen](#judgment)

<a id="papers_read"></a>
## Stage 60 · Eine Behörde wird belegt, keine Verschwörung vollständig erklärt

**Hrefna** · `NHV_Q01_060_1003`

> That's no trader's account. What does the seal mean?

**Fundstück: QuintusFieldNote** · `NHV_SYS_BOOK_59` · unveränderte Buchreferenz

> FIELD NOTE – HJAALMARCH
> 
> Locals call Ashmark's death an accident. No witness will speak plainly.

**Fundstück: QuintusFieldNote** · `NHV_SYS_BOOK_60` · unveränderte Buchreferenz

> Hrefna Stormhollow: Nord farmer. Farm seized for debt. Husband reportedly drinking heavily. Defensive when questioned. Do not approach her without a second route out.

**Fundstück: QuintusFieldNote** · `NHV_SYS_BOOK_61` · unveränderte Buchreferenz

> Ritual remains indicate a deliberate petition. No Brotherhood contact confirmed. Watch the farm and question anyone asking after Ashmark.

**Fundstück: QuintusFieldNote** · `NHV_SYS_BOOK_62` · unveränderte Buchreferenz

> If the woman killed Ashmark, she may be useful to the Brotherhood. If she did not, someone else is using the marsh to hide a better story.

**Fundstück: OculatusDispatch01** · `NHV_SYS_BOOK_85` · unveränderte Buchreferenz

> PENITUS OCULATUS — HJAALMARCH
> 
> Subject: repeated Black Sacrament activity. Record the petitioner, the named target, the local witness, and any surviving household. Do not intervene before the pattern is confirmed.
> 
> Forward copies to the northern desk. A prayer unanswered is still a signal.

- [Penitus Oculatus. He was investigating more than a debt.](#papers_confirm) · `NHV_Q01_060_1004`

<a id="papers_confirm"></a>
## Stage 60 · Was im Bericht tatsächlich steht

**Hrefna** · `NHV_Q01_060_1005`

> He wrote down the candles. The cellar. Everyone who might come asking.

**Hrefna** · `NHV_Q01_060_1006`

> I was a trail for him to follow. Doesn't make him any less dead.

Weiter: [judgment](#judgment).

<a id="judgment"></a>
## Stage 70 · Die Tat entscheidet nicht automatisch über die Aufnahme

**Hrefna** · `NHV_Q01_070_1000`

> Quintus is dead. I haven't forgotten what you said. That doesn't settle my place with you.

**Hrefna** · `NHV_Q01_070_1001`

> Tell me what you're offering. Or tell me to go. I'd rather hear it plainly.

- [What would you bring to the family besides a bow?](#skills) · `NHV_Q01_070_1002`
- [There will be other contracts. The people may have families.](#future) · `NHV_Q01_070_1003`
- [There's a place for you in Dawnstar, if you choose it.](#recruit_gate) · `NHV_Q01_070_1004`
- [Go. I won't ask you to give us the rest of your life.](#release) · `NHV_Q01_070_1005`
- [You know too much. I won't let you leave.](#silence) · `NHV_Q01_070_1006`

<a id="skills"></a>
## Stage 70 · Versorgung als Fähigkeit, nicht Trostpreis

**Hrefna** · `NHV_Q01_070_1007`

> I can make stores last a winter. Keep a kitchen clean. Tell you when grain's gone bad before you eat it.

**Hrefna** · `NHV_Q01_070_1008`

> And I can hunt. You can't feed a house on threats, however good you are at making them.

Weiter: [judgment](#judgment).

<a id="future"></a>
## Stage 70 · Mitgliedschaft ist keine einmalige Schuldtilgung

**Hrefna** · `NHV_Q01_070_1009`

> I know. One death won't buy me a quiet life with you.

**Hrefna** · `NHV_Q01_070_1010`

> I'm not asking for quiet. I'm asking for work I won't have to lie to myself about.

Weiter: [judgment](#judgment).

<a id="recruit_gate"></a>
## Stage 70 · Antwort nach tatsächlichem Ausgang der Prüfung

Bedingung: `{"killer": "player"}`. Sonst: [recruit_proven](#recruit_proven).

Weiter: [recruit_unproven](#recruit_unproven).

<a id="recruit_proven"></a>
## Stage 70 · Hrefna nimmt die angebotene Aufnahme an

**Hrefna** · `NHV_Q01_070_1011`

> Then I choose it. Not because a prayer bought me a bed. Because I can't go back to pretending nothing happened.

**Hrefna** · `NHV_Q01_070_1012`

> Show me where I'm needed.

Weiter: [recruit_knife](#recruit_knife).

<a id="recruit_unproven"></a>
## Stage 70 · Aufnahme trotz offener Prüfung

**Hrefna** · `NHV_Q01_070_1013`

> Even after you had to finish it?

- [I know what remains unproven. I'm offering you the chance to face it.](#recruit_unproven_yes) · `NHV_Q01_070_1014`

<a id="recruit_unproven_yes"></a>
## Stage 70 · Keine rückwirkend bestandene Prüfung

**Hrefna** · `NHV_Q01_070_1015`

> Then I accept. I'll work. I'll learn. I won't tell the others I did something I didn't.

Weiter: [recruit_knife](#recruit_knife).

<a id="recruit_knife"></a>
## Stage 70 · Die persönliche Klinge und der Weg nach Dawnstar

**Regie:** Aufnahme abschließen, Bogwife's Knife einmal vergeben; Unproven anhand des tatsächlichen Prüfungsergebnisses. Erst jetzt Zugang zur Familie. Transport/Ankunft nicht durch den Lesetest bewiesen.

**Hrefna** · `NHV_Q01_070_1016`

> Take my working knife. Roots, reeds, whatever needed cutting. I kept it sharp when there wasn't much else worth tending.

**Hrefna** · `NHV_Q01_070_1017`

> Dawnstar, then. I'll bring what I can carry. The rest can stay in the mud.

Weiter: [return](#return).

<a id="release"></a>
## Stage 70 · Freilassung ist ein eigener Abschluss

**Hrefna** · `NHV_Q01_070_1018`

> You mean it? No debt to be collected later?

- [You're free to leave. Keep our meeting to yourself.](#release_confirm) · `NHV_Q01_070_1019`

<a id="release_confirm"></a>
## Stage 70 · Kein versteckter Dienst gegen Freilassung

**Regie:** Status Freigelassen; Brief nach sieben Spieltagen. Keine Sanctuary-Mitgliedschaft, keine Küche oder Rekrutierungsbelohnung.

**Hrefna** · `NHV_Q01_070_1020`

> I can do that. I've had practice keeping things quiet.

**Hrefna** · `NHV_Q01_070_1021`

> Thank you for coming. Even late.

Weiter: [return](#return).

<a id="silence"></a>
## Stage 70 · Die Drohung löst Widerstand aus

**Regie:** Kein Tod allein durch die Auswahl. Diese V2 unterscheidet Urteil und tatsächlichen Tod. Der aktive JudgeSilence-Code setzt Status 2 bereits vor dem Kampf; vor Aktivierung ist dieser Unterschied zu lösen.

**Hrefna** · `NHV_Q01_070_1022`

> So that's the price of telling you the truth.

**Hrefna** · `NHV_Q01_070_1023`

> You'll have to take more than my word, then.

- [Regie: Kampf ausspielen – Hrefnas Tod bestätigen](#silence_dead)
- [Regie: Hrefna entkommt zunächst; Tod ist nicht bestätigt](#silence_unfinished)

<a id="silence_unfinished"></a>
## Stage 70 · Das Urteil ist gesprochen, der Kampf nicht abgeschlossen

**Regie:** Kein Todesbericht, solange Hrefna lebt. Die Vorschau bewertet nicht, ob Flucht oder Kampf ingame funktionieren.

- [Regie: Zum offenen Kampf zurückkehren](#silence)

Gespräch vertagt; Wiederaufnahme ohne neuen Questabschluss.

<a id="silence_dead"></a>
## Stage 100 · Todesausgang erst nach dem Ereignis

**Regie:** Weltvorgang bestätigt Hrefnas Tod. Kein Dialog einer Toten danach.

Weiter: [return](#return).

<a id="return"></a>
## Stage 100 · Bericht in der Sanctuary

**Regie:** Alle gewählten Ausgänge führen zum Bericht. Bei Aufnahme reist Hrefna zur Deep Sanctuary; sonst erscheint sie dort nicht als neue Bewohnerin.

- [Regie: Nach Dawnstar zurückkehren und Veyra Bericht erstatten](#report)

<a id="report"></a>
## Stage 100 · Der Listener berichtet Tatsachen statt Schlagworte

- [Hrefna has joined us. She killed Quintus herself.](#debrief_proven) · `NHV_Q01_100_1000` · nur `{"outcome": "recruited", "killer": "hrefna", "coerced": false, "triedIntimidate": false}`
- [Hrefna joined us. She killed him after threats failed and persuasion worked.](#debrief_after_threat) · `NHV_Q01_100_1057` · nur `{"outcome": "recruited", "killer": "hrefna", "coerced": false, "triedIntimidate": true}`
- [Hrefna joined us. I threatened her, and she killed him.](#debrief_coerced) · `NHV_Q01_100_1001` · nur `{"outcome": "recruited", "killer": "hrefna", "coerced": true}`
- [I killed Quintus. I admitted Hrefna with her trial unfinished.](#debrief_unproven) · `NHV_Q01_100_1002` · nur `{"outcome": "recruited", "killer": "player"}`
- [Quintus is dead. I let Hrefna go.](#debrief_release) · `NHV_Q01_100_1003` · nur `{"outcome": "released"}`
- [Quintus and Hrefna are dead. There will be no recruit.](#debrief_dead) · `NHV_Q01_100_1004` · nur `{"outcome": "dead"}`

<a id="debrief_proven"></a>
## Stage 100 · Bestandene Prüfung macht keine fertige Assassinin

**Veyra** · `NHV_Q01_100_1005`

> Then she has taken a task beyond her grievance and chosen to stay. A beginning, Listener. Leave her room to become useful.

**Veyra** · `NHV_Q01_100_1006`

> Nazir can help with that. So can a kitchen that needs putting in order.

Weiter: [report_questions](#report_questions).

<a id="debrief_after_threat"></a>
## Stage 100 · Nach erfolgloser Drohung überzeugt – der Bericht verschweigt nichts

**Veyra** · `NHV_Q01_100_1058`

> Then your argument reached her where your threat did not. Remember which one gave her a reason to stay.

**Veyra** · `NHV_Q01_100_1059`

> And do not expect her to forget the other merely because you have found her a bed.

Weiter: [report_questions](#report_questions).

<a id="debrief_coerced"></a>
## Stage 100 · Veyra verwechselt Furcht nicht mit freier Überzeugung

**Regie:** Keine neue Strafe. Erzählerische Reaktion auf Einschüchterung; der bestehende Unproven-Ausgang bleibt der übernommenen Tötung vorbehalten.

**Veyra** · `NHV_Q01_100_1007`

> Then you know she can act under threat. You have not learned what she would choose without one.

**Veyra** · `NHV_Q01_100_1008`

> She is yours to teach now. I suggest you give her something to remain for besides fear.

Weiter: [report_questions](#report_questions).

<a id="debrief_unproven"></a>
## Stage 100 · Die offene Prüfung bleibt sichtbar

**Veyra** · `NHV_Q01_100_1009`

> You have accepted a question along with a recruit. Keep it open. Do not write your deed beneath her name.

**Veyra** · `NHV_Q01_100_1010`

> There is work she can do here while you learn whether she will face the rest.

Weiter: [report_questions](#report_questions).

<a id="debrief_release"></a>
## Stage 100 · Freilassung ohne nachträgliche Verdrehung der Tat

**Veyra** · `NHV_Q01_100_1011`

> Then the danger was removed and the candidate was not admitted. Those are separate judgments. I am glad you treated them so.

**Veyra** · `NHV_Q01_100_1012`

> Her name can leave the list without becoming an epitaph.

Weiter: [report_questions](#report_questions).

<a id="debrief_dead"></a>
## Stage 100 · Verlust ohne nachträgliche Gutheißung

Voraussetzung: `{"hrefnaDead": true}`.

**Veyra** · `NHV_Q01_100_1013`

> A waste. You had the right to decide, Listener. That does not oblige me to admire the result.

**Veyra** · `NHV_Q01_100_1014`

> We will seek another name. Hers stays in the record.

Weiter: [report_questions](#report_questions).

<a id="report_questions"></a>
## Stage 100 · Was die erste Ernte gezeigt hat

- [Why begin with someone so uncertain?](#debrief_candidate) · `NHV_Q01_100_1015`
- [Can you tell whether the Mother ever heard her?](#debrief_silence) · `NHV_Q01_100_1016`
- [There is the matter of his papers.](#fragment_gate) · `NHV_Q01_100_1017`

<a id="debrief_candidate"></a>
## Stage 100 · Veyra bleibt fehlbar

**Veyra** · `NHV_Q01_100_1018`

> She asked for a death. Then the man died. I wanted to know whether she had answered her own prayer.

**Veyra** · `NHV_Q01_100_1019`

> I brought you a possibility. You have now learned more than my ledger could tell you.

Weiter: [report_questions](#report_questions).

<a id="debrief_silence"></a>
## Stage 100 · Keine erfundene Antwort der Night Mother

**Veyra** · `NHV_Q01_100_1020`

> I know that Hrefna waited and no assassin came. I cannot tell you what the Mother heard, or why she remained unanswered.

**Veyra** · `NHV_Q01_100_1021`

> If Hrefna made a judgment out of that silence, we need not make another.

Weiter: [report_questions](#report_questions).

<a id="fragment_gate"></a>
## Stage 100 · Spielerfund oder nachvollziehbare Bergung

Bedingung: `{"fragment": true}`. Sonst: [fragment_recovery](#fragment_recovery).

Weiter: [fragment_player](#fragment_player).

<a id="fragment_player"></a>
## Stage 100 · Das gesicherte Fragment vorlegen

- [His papers identify the Penitus Oculatus. This dispatch was with them.](#fragment_analysis) · `NHV_Q01_100_1022`

<a id="fragment_recovery"></a>
## Stage 100 · Veyra erklärt, wie die Unterlagen zu ihr kamen

**Regie:** Gewöhnliche Bergung, keine magische Kenntnis. Im späteren Plugin überprüfbarer Übergabepfad ohne doppelte Fragmentvergabe erforderlich.

**Veyra** · `NHV_Q01_100_1023`

> You left his papers behind. I went back for them. Here. This was folded among the local notes.

**Veyra** · `NHV_Q01_100_1024`

> Penitus Oculatus. So our trader had an employer after all.

**Fundstück: OculatusDispatch01** · `NHV_SYS_BOOK_85` · unveränderte Buchreferenz

> PENITUS OCULATUS — HJAALMARCH
> 
> Subject: repeated Black Sacrament activity. Record the petitioner, the named target, the local witness, and any surviving household. Do not intervene before the pattern is confirmed.
> 
> Forward copies to the northern desk. A prayer unanswered is still a signal.

Weiter: [fragment_analysis](#fragment_analysis).

<a id="fragment_analysis"></a>
## Stage 100 · Fragment eins – Beobachtung, noch kein vollständiger Plan

**Veyra** · `NHV_Q01_100_1025`

> Petitioner. Target. Witness. Household. He was recording the shape of a prayer and waiting to see who answered it.

**Veyra** · `NHV_Q01_100_1026`

> The dispatch speaks of repeated activity. It does not tell us how many agents are watching, or where their reports finally go.

- [Then someone may be following our recruitment.](#fragment_suspicion) · `NHV_Q01_100_1027`
- [Does this name the person directing them?](#fragment_limit) · `NHV_Q01_100_1028`
- [We should compare this with anything else we find.](#next_work) · `NHV_Q01_100_1029`

<a id="fragment_suspicion"></a>
## Stage 100 · Ein begründeter Verdacht bleibt ein Verdacht

**Veyra** · `NHV_Q01_100_1030`

> They are following the same troubled households that interest us. Whether they understand why we visit them is another question.

**Veyra** · `NHV_Q01_100_1031`

> For now, assume your questions may be remembered. We have no need to help them remember your face.

Weiter: [fragment_analysis](#fragment_analysis).

<a id="fragment_limit"></a>
## Stage 100 · Kein vorzeitiger Livia-/Spion-Spoiler

**Veyra** · `NHV_Q01_100_1032`

> No. A northern desk is an address, not a name. Keep the fragment. Another may give it meaning.

Weiter: [fragment_analysis](#fragment_analysis).

<a id="next_work"></a>
## Stage 100 · Weitere Contracts werden möglich – keiner startet zwangsläufig

**Regie:** Q01-Debrief abschließen. Der Map-Table-Fortgang öffnet die verbleibenden vier Kern-Contracts; kein automatischer Start nur von Q02.

**Veyra** · `NHV_Q01_100_1033`

> Keep it with the ledger. We can compare what follows.

**Veyra** · `NHV_Q01_100_1034`

> There are four other names to consider. When you are ready, we can look at the map together.

Weiter: [after](#after).

<a id="after"></a>
## Stage 100 · Abschluss und passende Nachwirkung

- [Regie: Hrefna in der neuen Küche begrüßen](#home) · nur `{"outcome": "recruited"}`
- [Regie: Sieben Spieltage später: Hrefnas Brief lesen](#release_letter) · nur `{"outcome": "released"}`
- [Regie: Lesetest abschließen](#finished)

<a id="home"></a>
## Stage 100 · Eine neue Bewohnerin beginnt mit Arbeit

Voraussetzung: `{"outcome": "recruited"}`.

**Regie:** Mehrsprecherszene nach tatsächlicher Ankunft; Hrefna lebt. Küche und Rekrutierungsstatus sind Voraussetzung, kein bloßer Questabschluss.

**Nazir** · `NHV_Q01_100_1035`

> Found the kitchen already? Most people ask about the beds first.

**Hrefna** · `NHV_Q01_100_1036`

> You can sleep hungry. Doesn't mean you should.

**Nazir** · `NHV_Q01_100_1037`

> Show me what you need. We'll see what the stores can spare.

- [How are you settling in?](#home_hrefna) · `NHV_Q01_100_1038`
- [Nazir, make sure she learns more than the pantry.](#home_nazir) · `NHV_Q01_100_1039`
- [I'll leave you to it.](#finished) · `NHV_Q01_100_1040`

<a id="home_hrefna"></a>
## Stage 100 · Wärme erscheint in einer konkreten Aufgabe

**Hrefna** · `NHV_Q01_100_1041`

> The shelves need cleaning. Someone put grain where the damp gets in. That's something I can mend.

**Hrefna** · `NHV_Q01_100_1042`

> The rest will take longer. There's a bowl for you when you come back.

Weiter: [home](#home).

<a id="home_nazir"></a>
## Stage 100 · Der Küchendienst ersetzt keine Ausbildung

**Nazir** · `NHV_Q01_100_1043`

> I haven't forgotten what family this is. Neither has she.

**Hrefna** · `NHV_Q01_100_1044`

> I can hear you both. Put a lesson between meals and I'll be there.

Weiter: [home](#home).

<a id="release_letter"></a>
## Stage 100 · Ein Brief nach sieben Spieltagen

Voraussetzung: `{"outcome": "released"}`.

**Regie:** Nur Freilassung, Hrefna lebt. Vorschau des bestehenden Sieben-Tage-Nachklangs; kein tatsächlicher Zeitablauf oder Kurier-Test.

**Fundstück: V2_HrefnaReleaseLetter** · `NHV_Q01_100_1045` · V2-Buchmaster

> To the one who came,
> 
> I am still in Hjaalmarch. There is work if you do not ask too much about the roof over it. I have been mending nets. The hands remember that work too.

**Fundstück: V2_HrefnaReleaseLetter** · `NHV_Q01_100_1046` · V2-Buchmaster

> I will not write down what happened. You know. I know. I wanted to tell you I have lit no more candles in the cellar. There are things I must decide without waiting for someone at the door.
> 
> Thank you for letting me leave.
> 
> Hrefna

- [Regie: Lesetest nach dem Brief abschließen](#finished)

<a id="finished"></a>
## Stage 100 · Ende des Q01-Lesetests

**Ende des Lesetests.**

## Journalvarianten

**Stage 10 · V2_JournalObjective** · `NHV_Q01_010_1036`

> Travel to Morthal and speak with Hakan Reed-Walker.

INACTIVE V2; Nur Teilphase/Bedingung: queststart; kein neuer Quest-Stage.

**Stage 10 · V2_JournalLog** · `NHV_Q01_010_1037`

> Veyra asked you to investigate Hrefna Stormhollow. Hakan, who found Eirik Ashmark's body, was your first lead.

INACTIVE V2; Nur Teilphase/Bedingung: queststart; kein neuer Quest-Stage.

**Stage 20 · V2_JournalObjective** · `NHV_Q01_020_1000`

> Investigate the Stormhollow farm and its cellar.

INACTIVE V2; Nur Teilphase/Bedingung: farm; kein neuer Quest-Stage.

**Stage 20 · V2_JournalLog** · `NHV_Q01_020_1001`

> Hakan linked Eirik to the seized farm and warned you about Quintus, a supposed trader asking about Hrefna's visitors.

INACTIVE V2; Nur Teilphase/Bedingung: farm; kein neuer Quest-Stage.

**Stage 30 · V2_JournalObjective** · `NHV_Q01_030_1012`

> Find Hrefna at the hunting camp.

INACTIVE V2; Nur Teilphase/Bedingung: camp; kein neuer Quest-Stage.

**Stage 30 · V2_JournalLog** · `NHV_Q01_030_1013`

> The cellar held traces of a Black Sacrament. You followed the trail toward Hrefna's hunting camp.

INACTIVE V2; Nur Teilphase/Bedingung: camp; kein neuer Quest-Stage.

**Stage 40 · V2_JournalObjective** · `NHV_Q01_040_1038`

> Hear Hrefna's account of Eirik's death.

INACTIVE V2; Nur Teilphase/Bedingung: accusation; kein neuer Quest-Stage.

**Stage 40 · V2_JournalLog** · `NHV_Q01_040_1039`

> Hrefna confronted you at the camp. Once she learned who you were, she demanded to know why no one had come.

INACTIVE V2; Nur Teilphase/Bedingung: accusation; kein neuer Quest-Stage.

**Stage 50 · V2_JournalObjective** · `NHV_Q01_050_1055`

> Hear Veyra's proposed trial before deciding.

INACTIVE V2; Nur Teilphase/Bedingung: veyra_arrives; kein neuer Quest-Stage.

**Stage 50 · V2_JournalLog** · `NHV_Q01_050_1056`

> Hrefna admitted drowning Eirik. She said Quintus was watching for whoever answered her prayer.

INACTIVE V2; Nur Teilphase/Bedingung: veyra_arrives; kein neuer Quest-Stage.

**Stage 50 · V2_JournalObjective** · `NHV_Q01_050_1057`

> Confront Quintus with Hrefna.

INACTIVE V2; Nur Teilphase/Bedingung: authorized=true; kein neuer Quest-Stage.

**Stage 50 · V2_JournalLog** · `NHV_Q01_050_1058`

> You authorized the task against Quintus. Hrefna agreed to accompany you, but her admission to the family remained undecided.

INACTIVE V2; Nur Teilphase/Bedingung: authorized=true; kein neuer Quest-Stage.

**Stage 60 · V2_JournalObjective** · `NHV_Q01_060_1007`

> Search Quintus's belongings.

INACTIVE V2; Nur Teilphase/Bedingung: killer=hrefna; kein neuer Quest-Stage.

**Stage 60 · V2_JournalLog** · `NHV_Q01_060_1008`

> Hrefna killed Quintus. His papers could explain the purpose of his investigation.

INACTIVE V2; Nur Teilphase/Bedingung: killer=hrefna; kein neuer Quest-Stage.

**Stage 60 · V2_JournalObjective** · `NHV_Q01_060_1009`

> Examine the papers Quintus carried.

INACTIVE V2; Nur Teilphase/Bedingung: killer=player; kein neuer Quest-Stage.

**Stage 60 · V2_JournalLog** · `NHV_Q01_060_1010`

> You killed Quintus yourself. Hrefna's ability to complete the task remained unproven.

INACTIVE V2; Nur Teilphase/Bedingung: killer=player; kein neuer Quest-Stage.

**Stage 70 · V2_JournalObjective** · `NHV_Q01_070_1024`

> Decide whether Hrefna belongs in the Brotherhood.

INACTIVE V2; Nur Teilphase/Bedingung: judgment; kein neuer Quest-Stage.

**Stage 70 · V2_JournalLog** · `NHV_Q01_070_1025`

> Quintus was dead. You still had to decide whether to admit Hrefna, release her, or silence her.

INACTIVE V2; Nur Teilphase/Bedingung: judgment; kein neuer Quest-Stage.

**Stage 100 · V2_JournalObjective** · `NHV_Q01_100_1047`

> Report Hrefna's recruitment to Veyra.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=recruited; killer=hrefna; kein neuer Quest-Stage.

**Stage 100 · V2_JournalLog** · `NHV_Q01_100_1048`

> Hrefna accepted a place in Dawnstar after killing Quintus herself. Her work in the family had yet to begin.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=recruited; killer=hrefna; kein neuer Quest-Stage.

**Stage 100 · V2_JournalObjective** · `NHV_Q01_100_1049`

> Tell Veyra why you admitted Hrefna despite her unfinished trial.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=recruited; killer=player; kein neuer Quest-Stage.

**Stage 100 · V2_JournalLog** · `NHV_Q01_100_1050`

> You completed the killing and admitted Hrefna. She accepted without claiming your deed as her own.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=recruited; killer=player; kein neuer Quest-Stage.

**Stage 100 · V2_JournalObjective** · `NHV_Q01_100_1051`

> Tell Veyra you released Hrefna.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=released; kein neuer Quest-Stage.

**Stage 100 · V2_JournalLog** · `NHV_Q01_100_1052`

> You let Hrefna leave after Quintus's death. She had no further obligation to the Brotherhood beyond keeping your meeting secret.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=released; kein neuer Quest-Stage.

**Stage 100 · V2_JournalObjective** · `NHV_Q01_100_1053`

> Report Hrefna's death to Veyra.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=dead; hrefnaDead=true; kein neuer Quest-Stage.

**Stage 100 · V2_JournalLog** · `NHV_Q01_100_1054`

> You chose to silence Hrefna, and her death was confirmed. There would be no recruit from this investigation.

INACTIVE V2; Nur Teilphase/Bedingung: outcome=dead; hrefnaDead=true; kein neuer Quest-Stage.

**Stage 100 · V2_JournalObjective** · `NHV_Q01_100_1055`

> Discuss the Oculatus dispatch with Veyra.

INACTIVE V2; Nur Teilphase/Bedingung: fragment=true; kein neuer Quest-Stage.

**Stage 100 · V2_JournalLog** · `NHV_Q01_100_1056`

> Quintus's documents identified the Penitus Oculatus and a wider interest in Black Sacrament activity. They did not identify who directed the reports.

INACTIVE V2; Nur Teilphase/Bedingung: fragment=true; kein neuer Quest-Stage.
