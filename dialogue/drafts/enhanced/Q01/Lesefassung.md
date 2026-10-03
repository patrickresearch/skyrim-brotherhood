# Q01 Enhanced – Lesefassung

Automatisch aus `Q01.csv` erzeugt. Diese Fassung ist ein inaktiver Redaktionsentwurf; Conditions und Notes zeigen die geplante Verdrahtung.

## Stage 10

### `NHV_Q01_010_2000` · Player · `Enhanced_Briefing`

> What exactly are we going to Morthal to find?

**Conditions:** `—`  
**Notes:** Enhanced draft; Q00 has ended, but the case is not yet a contract.

### `NHV_Q01_010_2001` · Veyra · `Enhanced_Briefing`

> A prayer that waited six weeks. Begin with the people who noticed the waiting.

**Conditions:** `—`  
**Notes:** Veyra frames the quest as an investigation.

### `NHV_Q01_010_2002` · Player · `Enhanced_Briefing`

> You said find. Not kill.

**Conditions:** `—`  
**Notes:** Clarifies the objective before travel.

### `NHV_Q01_010_2003` · Veyra · `Enhanced_Briefing`

> Until we know who answered, a knife would only be a confession.

**Conditions:** `—`  
**Notes:** No Night Mother certainty is claimed.

### `NHV_Q01_010_2004` · Veyra · `Enhanced_Briefing`

> Hakan Reed-Walker found the first body. He remembers what the marsh kept and what it gave back.

**Conditions:** `—`  
**Notes:** Introduces the first witness.

### `NHV_Q01_010_2005` · Player · `Enhanced_Briefing`

> And the woman who made the Sacrament?

**Conditions:** `—`  
**Notes:** Optional question.

### `NHV_Q01_010_2006` · Veyra · `Enhanced_Briefing`

> Hrefna Stormhollow is the name in the ledger. A name is an invitation to look, not permission to decide.

**Conditions:** `—`  
**Notes:** Connects to The Gleaner’s Ledger.

### `NHV_Q01_010_2010` · Player · `Enhanced_Hakan`

> You found Eirik Ashmark in the reeds.

**Conditions:** `—`  
**Notes:** Starts Hakan interview.

### `NHV_Q01_010_2011` · Hakan · `Enhanced_Hakan`

> Found him face down. Purse still tied. Boots still dry inside.

**Conditions:** `—`  
**Notes:** Hakan separates facts from rumor.

### `NHV_Q01_010_2012` · Player · `Enhanced_Hakan`

> What does that tell you?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_010_2013` · Hakan · `Enhanced_Hakan`

> That the bog did not take him. Someone put him where the water would take the blame.

**Conditions:** `—`  
**Notes:** Evidence, not omniscience.

### `NHV_Q01_010_2014` · Player · `Enhanced_Hakan`

> Who else was asking about him?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_010_2015` · Hakan · `Enhanced_Hakan`

> An Imperial calling himself a trader. Asked about the cellar, not the debt. Traders ask about prices.

**Conditions:** `—`  
**Notes:** Introduces Quintus without naming the Oculatus.

### `NHV_Q01_010_2016` · Hakan · `Enhanced_Hakan`

> He paid for lamp oil, then watched who watched him. That is no way to sell grain.

**Conditions:** `—`  
**Notes:** Optional second Hakan response.

### `NHV_Q01_010_2017` · Player · `Enhanced_Hakan`

> Take me to the reeds.

**Conditions:** `—`  
**Notes:** Begins the first subquest.

### `NHV_Q01_010_2018` · Hakan · `Enhanced_Hakan`

> Bring back my red ferry marker. The marsh swallowed it when I found the body. Then I will show you where Hrefna crossed.

**Conditions:** `—`  
**Notes:** Subquest gate: recover marker.

### `NHV_Q01_010_2019` · Player · `Enhanced_Hakan`

> What took it?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_010_2020` · Hakan · `Enhanced_Hakan`

> Men with hooks and empty sacks. Eirik’s debt was worth stealing twice.

**Conditions:** `—`  
**Notes:** Sets scavenger encounter.

## Stage 12

### `NHV_Q01_012_2021` · MarshScavenger · `Enhanced_Reedbed`

> The dead man owed us. We are only collecting what his paper promised.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** Optional encounter at the reedbed.

### `NHV_Q01_012_2022` · Player · `Enhanced_Reedbed`

> Drop the ledger and step away from the marker.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** —

### `NHV_Q01_012_2023` · MarshScavenger · `Enhanced_Reedbed`

> You are late. The woman was later. Everyone is late in this marsh.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** —

### `NHV_Q01_012_2024` · Player · `Enhanced_Reedbed`

> Who hired you?

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** Speech/intimidation hook; no forced answer.

### `NHV_Q01_012_2025` · MarshScavenger · `Enhanced_Reedbed`

> No one hired us. A seal on a page is enough to make hungry men brave.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** Shows debt system without making Eirik a cultist.

### `NHV_Q01_012_2026` · Hakan · `Enhanced_Reedbed`

> You found the marker. The woman crossed east, toward the old watchpost.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 0`  
**Notes:** Hakan gives the route only after the marker is returned; farm map marker follows.

### `NHV_Q01_012_2027` · Player · `Enhanced_Reedbed`

> You know who killed Eirik.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 1`  
**Notes:** —

### `NHV_Q01_012_2028` · Hakan · `Enhanced_Reedbed`

> I know who had reason, means, and mud on her boots. Hrefna Stormhollow.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 1`  
**Notes:** Hakan reveals his suspicion only after the marker is returned; set NHV_Q01_ReedbedResolved after this response.

### `NHV_Q01_012_2029` · Hakan · `Enhanced_Reedbed`

> The farm is east of the reed road. I will mark it.

**Conditions:** `GetGlobalValue NHV_Q01_ReedbedMarkerReturned == 1`  
**Notes:** Place the Hrefna farm quest marker.

## Stage 20

### `NHV_Q01_020_2100` · Player · `Enhanced_FarmSearch`

> The house is empty, but the cellar was used recently.

**Conditions:** `—`  
**Notes:** Stage 20 research start.

### `NHV_Q01_020_2101` · Veyra · `Enhanced_FarmSearch`

> A Black Sacrament leaves a shape even when no voice answers it. Read the shape before you read your anger into it.

**Conditions:** `—`  
**Notes:** Veyra does not explain why no answer came.

### `NHV_Q01_020_2102` · Player · `Enhanced_FarmSearch`

> The heart, skull, flesh, bones, and nightshade were arranged correctly.

**Conditions:** `—`  
**Notes:** Ritual research clue.

### `NHV_Q01_020_2103` · Veyra · `Enhanced_FarmSearch`

> Correct enough to show intent. Not proof that the dark was listening.

**Conditions:** `—`  
**Notes:** Keeps the ritual ambiguous.

### `NHV_Q01_020_2104` · Player · `Enhanced_FarmSearch`

> There is ash beneath the altar. Someone burned a second note.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_020_2105` · Veyra · `Enhanced_FarmSearch`

> Then find what the fire spared. Truth is often the least flammable part of a lie.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_020_2106` · Player · `Enhanced_FarmSearch`

> The note names a debt, a date, and a place by the watchpost.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_020_2107` · Veyra · `Enhanced_FarmSearch`

> Now you have a route, not an answer. Follow it.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_020_2110` · Hrefna · `Enhanced_HrefnaCamp`

> You found me. Did the Scout tell you, or did the marsh?

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1; GetGlobalValue NHV_Q01_ScoutEncountered == 1`  
**Notes:** Camp arrival after the surviving Scout reveals the location.

### `NHV_Q01_020_2111` · Player · `Enhanced_HrefnaCamp`

> The Scout lived. He gave us your camp.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1; GetGlobalValue NHV_Q01_ScoutEncountered == 1`  
**Notes:** —

### `NHV_Q01_020_2112` · Hrefna · `Enhanced_HrefnaCamp`

> Then he has more sense than the men he brought.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1; GetGlobalValue NHV_Q01_ScoutEncountered == 1`  
**Notes:** —

### `NHV_Q01_020_2108` · Player · `Enhanced_FarmSearch`

> There are Imperial boot prints beside the cellar door.

**Conditions:** `GetGlobalValue NHV_Q01_FarmInspected == 0`  
**Notes:** Set NHV_Q01_FarmInspected after the farm search.

### `NHV_Q01_020_2109` · Player · `Enhanced_FarmSearch`

> They lead toward an old watchpost near the road.

**Conditions:** `GetGlobalValue NHV_Q01_FarmInspected == 1`  
**Notes:** Place the watchpost quest marker on the map.

## Stage 25

### `NHV_Q01_025_2120` · Player · `Enhanced_Watchpost`

> The old watchpost overlooks the road and the farm.

**Conditions:** `—`  
**Notes:** Subquest: reconstruct the route.

### `NHV_Q01_025_2121` · Player · `Enhanced_Watchpost`

> A boot print, a broken seal, and fresh candle wax.

**Conditions:** `—`  
**Notes:** Evidence nodes, not dialogue-only.

### `NHV_Q01_025_2122` · OculatusScout · `Enhanced_Watchpost`

> You should not be reading Imperial notes.

**Conditions:** `—`  
**Notes:** Mandatory post-battle conversation; set NHV_Q01_ScoutEncountered after the Scout survives and the interrogation begins.

### `NHV_Q01_025_2123` · Player · `Enhanced_Watchpost`

> Then you should not leave them where a reader can find them.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_025_2124` · OculatusScout · `Enhanced_Watchpost`

> A report from this post names a living witness. That is all you need to know.

**Conditions:** `—`  
**Notes:** Does not reveal full conspiracy.

### `NHV_Q01_025_2125` · Player · `Enhanced_Watchpost`

> And what do you need to know?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_025_2126` · OculatusScout · `Enhanced_Watchpost`

> Whether the woman who prayed is still alive.

**Conditions:** `—`  
**Notes:** Creates pressure; scout may flee or fight.

## Stage 30

### `NHV_Q01_030_2200` · Hrefna · `Enhanced_HrefnaCamp`

> Hands where I can see them. You have been in my cellar.

**Conditions:** `—`  
**Notes:** Night encounter at the camp.

### `NHV_Q01_030_2201` · Player · `Enhanced_HrefnaCamp`

> I followed the trail you left behind.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2202` · Hrefna · `Enhanced_HrefnaCamp`

> Then you know I wanted to be found. You do not yet know why.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2203` · Player · `Enhanced_HrefnaCamp`

> Tell me about the six weeks.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2204` · Hrefna · `Enhanced_HrefnaCamp`

> Six weeks of candles, empty cupboards, and a door that stayed shut. Waiting became another kind of work.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2205` · Player · `Enhanced_HrefnaCamp`

> And Eirik?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2206` · Hrefna · `Enhanced_HrefnaCamp`

> He took the farm on paper. I took his breath in the water. Neither of us called it murder while we were doing it.

**Conditions:** `—`  
**Notes:** Confession without absolution.

### `NHV_Q01_030_2207` · Player · `Enhanced_HrefnaCamp`

> Why hide the ritual remains?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2208` · Hrefna · `Enhanced_HrefnaCamp`

> Because I could bear an empty answer. I could not bear a town laughing at the question.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2209` · Player · `Enhanced_HrefnaCamp`

> Come back with me and tell the whole story.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_030_2210` · Hrefna · `Enhanced_HrefnaCamp`

> I will tell it. Whether I walk beside you is still mine to choose.

**Conditions:** `—`  
**Notes:** Preserves agency.

### `NHV_Q01_030_2211` · Player · `Enhanced_HrefnaCamp`

> Wait here. I am going back to Morthal to find the trader.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** Hrefna remains at the camp.

### `NHV_Q01_030_2212` · Hrefna · `Enhanced_HrefnaCamp`

> I will wait. Do not let him turn my life into another report.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** —

### `NHV_Q01_030_2213` · Player · `Enhanced_HrefnaCamp`

> If I return, we go to the inn together. You read everything I find.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** —

### `NHV_Q01_030_2214` · Hrefna · `Enhanced_HrefnaCamp`

> Then return with the truth. I have lived too long with other people’s versions of it.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** —

### `NHV_Q01_030_2215` · Player · `Enhanced_HrefnaFamily`

> What happened to your husband and your daughter?

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** Optional deeper question.

### `NHV_Q01_030_2216` · Hrefna · `Enhanced_HrefnaFamily`

> The debts broke my husband. He drank until there was nothing left that could wake him.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** Hrefna’s husband died from alcohol after the debt pressure.

### `NHV_Q01_030_2217` · Hrefna · `Enhanced_HrefnaFamily`

> Eirik’s hired man kept cornering my daughter. I found her after she ended her life. The farm became a grave with a roof.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** Handle the abuse and suicide reference without graphic detail.

### `NHV_Q01_030_2218` · Hrefna · `Enhanced_HrefnaFamily`

> Eirik still came for the land. That was when waiting stopped being a virtue.

**Conditions:** `GetGlobalValue NHV_Q01_HrefnaCampReady == 1`  
**Notes:** —

## Stage 40

### `NHV_Q01_040_2303` · Quintus · `Enhanced_Moorside`

> You have the look of someone asking about a death without wishing to own the answer.

**Conditions:** `—`  
**Notes:** First Quintus conversation after the return to Morthal.

### `NHV_Q01_040_2304` · Player · `Enhanced_Moorside`

> You are asking about Hjaalmarch’s Black Sacraments.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_040_2305` · Quintus · `Enhanced_Moorside`

> I am asking why this prayer went unanswered.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_040_2306` · Player · `Enhanced_Moorside`

> Are you Penitus Oculatus?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_040_2307` · Quintus · `Enhanced_Moorside`

> In this room, I am a trader. Outside it, I am a man trying to stop the next death.

**Conditions:** `—`  
**Notes:** He avoids a direct confession.

### `NHV_Q01_040_2308` · Quintus · `Enhanced_Moorside`

> I have a letter to finish before I leave. Duty is easier when it has a door to go home to.

**Conditions:** `—`  
**Notes:** Humanizes him without a new family fact.

### `NHV_Q01_040_2309` · Player · `Enhanced_Investigation`

> Hrefna is alive. She performed the Sacrament.

**Conditions:** `—`  
**Notes:** Optional reveal to Quintus; raises risk.

### `NHV_Q01_040_2310` · Quintus · `Enhanced_Moorside`

> Then the unanswered prayer has a living witness. I cannot leave that loose.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_040_2311` · Veyra · `Enhanced_Investigation`

> Now he knows enough to become dangerous. That does not make him wrong.

**Conditions:** `—`  
**Notes:** Veyra distinguishes threat from moral guilt.

### `NHV_Q01_040_2312` · Player · `Enhanced_MoorsideReveal`

> A trader does not know the cellar, the watchpost, and the ritual dates.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 0`  
**Notes:** Contradiction-based reveal.

### `NHV_Q01_040_2313` · Quintus · `Enhanced_MoorsideReveal`

> You have been reading the wrong books and asking the right questions.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 0`  
**Notes:** —

### `NHV_Q01_040_2314` · Player · `Enhanced_MoorsideReveal`

> Stop hiding behind the ledger. Tell me who you are.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 0`  
**Notes:** —

### `NHV_Q01_040_2315` · Quintus · `Enhanced_MoorsideReveal`

> Penitus Oculatus. I was sent to find the woman behind the Sacrament.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 0`  
**Notes:** Sets NHV_Q01_QuintusTruth = 1.

### `NHV_Q01_040_2316` · Player · `Enhanced_MoorsideReveal`

> And if I find you again?

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 1`  
**Notes:** —

### `NHV_Q01_040_2317` · Quintus · `Enhanced_MoorsideReveal`

> Then you will decide whether a witness is more useful alive.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 1`  
**Notes:** —

## Stage 42

### `NHV_Q01_042_2320` · Player · `Enhanced_QuintusDocuments`

> The room holds a letter addressed to his daughter.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 1`  
**Notes:** Set NHV_Q01_DocumentsFound = 1.

### `NHV_Q01_042_2321` · Player · `Enhanced_QuintusDocuments`

> The papers list Stormhollow, the watchpost, and other cases.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusTruth == 1`  
**Notes:** —

### `NHV_Q01_042_2322` · Quintus · `Enhanced_QuintusDocuments`

> You searched my room while I was speaking plainly.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

### `NHV_Q01_042_2323` · Player · `Enhanced_QuintusDocuments`

> You started with a lie. I am checking what the truth costs.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

## Stage 45

### `NHV_Q01_045_2330` · Player · `Enhanced_QuintusChoice`

> Stay here until I return.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** Quintus remains at the inn; set NHV_Q01_QuintusLocation = 1.

### `NHV_Q01_045_2331` · Quintus · `Enhanced_QuintusChoice`

> You mean to bring the witness to me.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

### `NHV_Q01_045_2332` · Player · `Enhanced_QuintusChoice`

> Leave Morthal. Hrefna will return to her farm.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** Lie; set NHV_Q01_QuintusLocation = 2 and send Quintus toward the farm.

### `NHV_Q01_045_2333` · Quintus · `Enhanced_QuintusChoice`

> Then I will follow the road and meet her there.

**Conditions:** `GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** —

## Stage 48

### `NHV_Q01_048_2340` · Player · `Enhanced_CampReturn`

> I found the truth. Come with me to the inn.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** Player returns to the camp; Hrefna joins the inn trip.

### `NHV_Q01_048_2341` · Hrefna · `Enhanced_CampReturn`

> I will read the papers where he expected to hide them.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

### `NHV_Q01_048_2342` · Player · `Enhanced_CampReturn`

> Then we go together. Whatever happens, you will know what he knew.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

## Stage 50

### `NHV_Q01_050_2530` · Veyra · `Enhanced_TrialRoom`

> In the room, the letter is the first witness. Let Hrefna read before she reaches for steel.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 1`  
**Notes:** Trial route: room.

### `NHV_Q01_050_2531` · Hrefna · `Enhanced_TrialRoom`

> His words are ordinary. That is what makes the knife feel like a lie.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 1`  
**Notes:** —

### `NHV_Q01_050_2540` · Veyra · `Enhanced_TrialRoad`

> On the road, there is no wall to hide behind and no witness to blame.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 2`  
**Notes:** Trial route: road.

### `NHV_Q01_050_2541` · Quintus · `Enhanced_TrialRoad`

> You chose a dangerous place for a conversation. I assume that was the point.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 2`  
**Notes:** —

### `NHV_Q01_050_2550` · Veyra · `Enhanced_TrialFalseLead`

> A false lead gives Hrefna one advantage: Quintus arrives believing he chose the ground.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 3`  
**Notes:** Trial route: false lead.

### `NHV_Q01_050_2551` · Player · `Enhanced_TrialFalseLead`

> Let him speak first. We learn more from a man who thinks he is safe.

**Conditions:** `GetGlobalValue NHV_Q01_TrialRoute == 3`  
**Notes:** —

### `NHV_Q01_050_2360` · Hrefna · `Enhanced_InnDocuments`

> The letter is to his daughter. He was still trying to go home.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** Hrefna reads the letter in the inn.

### `NHV_Q01_050_2361` · Hrefna · `Enhanced_InnDocuments`

> He was looking for me, but he was also looking for a way back to his own life.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** —

### `NHV_Q01_050_2362` · Player · `Enhanced_InnDocuments`

> Now choose: kill him, leave him alive, or let me end this.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1`  
**Notes:** Three final options.

### `NHV_Q01_050_2370` · Player · `Enhanced_InnChoice`

> Quintus is here. You will kill him in the inn.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 1`  
**Notes:** Sets NHV_Q01_FinalChoice = 1; Quintus remains in the inn.

### `NHV_Q01_050_2371` · Hrefna · `Enhanced_InnChoice`

> Then let him come. I will not pretend I am killing Eirik again.

**Conditions:** `GetGlobalValue NHV_Q01_FinalChoice == 1; GetGlobalValue NHV_Q01_QuintusLocation == 1`  
**Notes:** —

### `NHV_Q01_050_2372` · Player · `Enhanced_InnChoice`

> Quintus is at the farm. I will bring him back to the inn.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** Sets NHV_Q01_FinalChoice = 1; move Quintus to the inn.

### `NHV_Q01_050_2373` · Hrefna · `Enhanced_InnChoice`

> Bring him here. I will face him in the inn.

**Conditions:** `GetGlobalValue NHV_Q01_FinalChoice == 1; GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** Hrefna agrees to the relocated inn confrontation.

### `NHV_Q01_050_2380` · Player · `Enhanced_InnChoice`

> Let Quintus live. I will send him to the farm and let him take you there.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 1`  
**Notes:** Sets NHV_Q01_FinalChoice = 2; move Quintus to the farm; Hrefna returns there.

### `NHV_Q01_050_2381` · Hrefna · `Enhanced_InnChoice`

> If I go willingly, he may leave the town without burning it around me.

**Conditions:** `GetGlobalValue NHV_Q01_FinalChoice == 2`  
**Notes:** Hrefna chooses capture rather than killing.

### `NHV_Q01_050_2382` · Player · `Enhanced_InnChoice`

> Let Quintus live. I will return to the farm and let him take me.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** Sets NHV_Q01_FinalChoice = 2; Hrefna returns to the farm.

### `NHV_Q01_050_2390` · Player · `Enhanced_InnChoice`

> I will kill Quintus. We go to the farm.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** Sets NHV_Q01_FinalChoice = 3; player travels to farm.

### `NHV_Q01_050_2392` · Player · `Enhanced_InnChoice`

> Quintus is here. I will send him to the farm, then kill him there.

**Conditions:** `GetGlobalValue NHV_Q01_DocumentsFound == 1; GetGlobalValue NHV_Q01_QuintusLocation == 1`  
**Notes:** Sets NHV_Q01_FinalChoice = 3; move Quintus to the farm before the player kills him.

### `NHV_Q01_050_2393` · Hrefna · `Enhanced_InnChoice`

> Then I will stand beside you. The inn will not become another cage.

**Conditions:** `GetGlobalValue NHV_Q01_FinalChoice == 3; GetGlobalValue NHV_Q01_QuintusLocation == 1`  
**Notes:** —

### `NHV_Q01_050_2391` · Hrefna · `Enhanced_InnChoice`

> Then I will walk beside you. I will not let another man decide what my silence means.

**Conditions:** `GetGlobalValue NHV_Q01_FinalChoice == 3; GetGlobalValue NHV_Q01_QuintusLocation == 2`  
**Notes:** —

## Stage 55

### `NHV_Q01_055_2560` · Quintus · `Enhanced_HrefnaKill`

> You brought me the woman from the farm. I hoped you had chosen mercy.

**Conditions:** `—`  
**Notes:** Quintus is present in the inn; if he was sent to the farm, the scene brings him back before Hrefna strikes.

### `NHV_Q01_055_2561` · Hrefna · `Enhanced_HrefnaKill`

> I read your letter. I know you were going home.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_055_2562` · Hrefna · `Enhanced_HrefnaKill`

> I am sorry you will not get there.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_055_2563` · Hrefna · `Enhanced_HrefnaKill`

> I choose this knowing who you are.

**Conditions:** `—`  
**Notes:** Hrefna performs the kill; outcome Proven.

### `NHV_Q01_055_2570` · Hrefna · `Enhanced_HrefnaCapture`

> I will not kill him. I will return to the farm and let him take me.

**Conditions:** `—`  
**Notes:** Hrefna returns to the farm and surrenders; outcome Unproven/Captured.

### `NHV_Q01_055_2571` · Player · `Enhanced_HrefnaCapture`

> You are choosing a cell over another death.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_055_2573` · Quintus · `Enhanced_HrefnaCapture`

> Then return to the farm. I will be there before nightfall.

**Conditions:** `—`  
**Notes:** Quintus follows the surrender route to the farm.

### `NHV_Q01_055_2572` · Hrefna · `Enhanced_HrefnaCapture`

> I am choosing what I can still answer for.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_055_2580` · Quintus · `Enhanced_PlayerKill`

> You brought me to the farm. You will not take her from me.

**Conditions:** `—`  
**Notes:** Quintus is at the farm for the player-kill route, whether he was sent there directly or followed the false return story.

### `NHV_Q01_055_2581` · Player · `Enhanced_PlayerKill`

> You were going to take her. I will not let you.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_055_2582` · Hrefna · `Enhanced_PlayerKill`

> Do it, then. But do not call it my choice.

**Conditions:** `—`  
**Notes:** Player kills Quintus; outcome Unproven.

## Stage 60

### `NHV_Q01_060_2600` · Hrefna · `Enhanced_Papers`

> A seal marked with the Oculatus sign. He kept my name beside the names of other prayers.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_060_2601` · Player · `Enhanced_Papers`

> This is not a local report.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_060_2602` · Veyra · `Enhanced_Papers`

> No. It is a pattern seen by people who count absences. That makes it useful, not complete.

**Conditions:** `—`  
**Notes:** Fragment remains partial.

### `NHV_Q01_060_2603` · Player · `Enhanced_Papers`

> The report says: “A prayer unanswered is still a signal.”

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_060_2604` · Veyra · `Enhanced_Papers`

> Then someone is watching the spaces where our family fails to arrive.

**Conditions:** `—`  
**Notes:** Campaign hook, no Livia reveal.

### `NHV_Q01_060_2605` · Hrefna · `Enhanced_Papers`

> Do they watch every woman who waits?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_060_2606` · Veyra · `Enhanced_Papers`

> Only the ones who leave a mark. You have left one. So have we.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_060_2620` · Player · `Enhanced_FragmentChoice`

> Leave the incomplete report. We have enough to know the pattern exists.

**Conditions:** `—`  
**Notes:** Player leaves the fragment; set NHV_Q01_FragmentFound = 0.

### `NHV_Q01_060_2621` · Veyra · `Enhanced_FragmentChoice`

> Then remember the absence. It is still a warning.

**Conditions:** `—`  
**Notes:** Veyra acknowledges the missing fragment.

### `NHV_Q01_060_2622` · Player · `Enhanced_FragmentChoice`

> Secure the dispatch fragment. The pattern may matter later.

**Conditions:** `—`  
**Notes:** Player keeps the fragment; set NHV_Q01_FragmentFound = 1.

## Stage 70

### `NHV_Q01_070_2700` · Hrefna · `Enhanced_Judgment`

> So. What happens to me now?

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_070_2701` · Player · `Enhanced_JudgmentRecruitProven`

> You are coming to Dawnstar. You will earn your place.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 1`  
**Notes:** Recruit proven.

### `NHV_Q01_070_2702` · Hrefna · `Enhanced_JudgmentRecruitProven`

> Then give me work that keeps my hands busy and my eyes open.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 1`  
**Notes:** —

### `NHV_Q01_070_2703` · Player · `Enhanced_JudgmentRecruitUnproven`

> You are coming to Dawnstar, but the question remains open.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 2`  
**Notes:** Recruit unproven.

### `NHV_Q01_070_2704` · Hrefna · `Enhanced_JudgmentRecruitUnproven`

> An open door is still more mercy than I expected.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 2`  
**Notes:** —

### `NHV_Q01_070_2705` · Player · `Enhanced_JudgmentRelease`

> Go back to your life. We are square.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 3`  
**Notes:** Release.

### `NHV_Q01_070_2706` · Hrefna · `Enhanced_JudgmentRelease`

> Square is a word people use when they cannot afford another debt.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 3`  
**Notes:** —

### `NHV_Q01_070_2707` · Player · `Enhanced_JudgmentSilence`

> The Brotherhood leaves no witnesses.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 4`  
**Notes:** Silence branch.

### `NHV_Q01_070_2708` · Hrefna · `Enhanced_JudgmentSilence`

> Please. I answered the prayer. Do not make that the only thing I am.

**Conditions:** `GetGlobalValue NHV_Q01_Result == 4`  
**Notes:** —

## Stage 100

### `NHV_Q01_100_2800` · Veyra · `Enhanced_Debrief`

> You did not bring me a clean story. Good. Clean stories are usually hiding a body.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_100_2801` · Player · `Enhanced_Debrief`

> Hrefna made a second choice.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_100_2802` · Veyra · `Enhanced_Debrief`

> The first death explains the wound. The choice that followed shows whether she can carry it.

**Conditions:** `—`  
**Notes:** —

### `NHV_Q01_100_2803` · Player · `Enhanced_Debrief`

> The Oculatus has records of other unanswered Sacraments.

**Conditions:** `GetGlobalValue NHV_Q01_FragmentFound == 1`  
**Notes:** Only when the dispatch fragment was found.

### `NHV_Q01_100_2804` · Veyra · `Enhanced_Debrief`

> Four more names wait in the ledger. Choose the next road when you are ready.

**Conditions:** `—`  
**Notes:** No Q02 details revealed.

### `NHV_Q01_100_2805` · Veyra · `Enhanced_Debrief`

> Someone is learning our absences. We will teach them our returns.

**Conditions:** `—`  
**Notes:** Campaign-level hook.

### `NHV_Q01_100_2806` · Veyra · `Enhanced_Debrief`

> The Oculatus was watching the same silence we found. The missing fragment is still a warning.

**Conditions:** `GetGlobalValue NHV_Q01_FragmentFound == 0`  
**Notes:** Alternate debrief when the fragment was missed.
