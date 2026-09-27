Scriptname NHV_Q01Script extends NHV_ContractBaseScript
{Q01 "The Unanswered Sacrament" - Hrefna Stormhollow, Morthal/Hjaalmarch. First recruitment
contract after Q00; runs the Whisper/Hunt/Observation/Trial/Judgement/Homecoming schema from
concept section 5 for this one candidate. Stage numbers match dialogue/Journal.csv exactly and
must never be renumbered once released (docs/CONVENTIONS.md). See docs/plan/Q01-The-Unanswered-
Sacrament.md for the full design and open CK decisions. M1.7.}

; -- Aliases filled in the CK on THIS quest. VeyraAlias and the Core/PlayerRef properties used
; below are inherited from NHV_ContractBaseScript. The quest's PlayerRef alias itself carries no
; property here - it only needs NHV_ContractPlayerAliasScript attached directly to it in the CK. --
ReferenceAlias Property HakanAlias Auto
ReferenceAlias Property HrefnaAlias Auto
ReferenceAlias Property QuintusAlias Auto

; -- Globals (both already exist in plugin-text, reused, not re-created) --
GlobalVariable Property NHV_Status_Hrefna Auto      ; 000811:NightsHarvest.esp
GlobalVariable Property NHV_Flag_HrefnaUnproven Auto ; new, see docs/plan Record-Inventar

; -- NHV_Sys_Family's reserved alias for Hrefna (alias 2, "HrefnaSlot" - already exported with
; NHV_RecruitAliasScript and StatusGlobal wired, see plugin-text/Quests/NHV_Sys_Family) --
ReferenceAlias Property HrefnaFamilySlotAlias Auto

; -- World references (XMarkers, filled in the CK) --
ObjectReference Property CampMarker Auto      ; NHV_Mk_Q01_CampMarker, ambush poll target
ObjectReference Property KitchenMarker Auto   ; NHV_Mk_Q01_KitchenSpot, Homecoming destination

; -- Scenes --
Scene Property CampAmbushScene Auto  ; NHV_Scn_Q01_01CampAmbush
Scene Property VeyraTrialScene Auto  ; NHV_Scn_Q01_02VeyraTrial

; -- Items --
Book Property OculatusFragment1 Auto   ; NHV_Item_OculatusFragment1
Weapon Property BogwifesKnife Auto     ; NHV_Weap_BogwifesKnife, Judgement "Recruit" reward
Book Property HrefnaReleaseLetter Auto ; NHV_Book_HrefnaReleaseLetter, delivered 7 days after Release

; Player must be within this many game units of CampMarker for the ambush to trigger. A plain
; GetDistance() comparison is used on purpose - no squared-distance literal math anywhere in this
; file (docs/CONVENTIONS.md warns the German-locale Papyrus compiler mishandles constant float
; multiplication such as "450.0 * 450.0").
Float Property CampAmbushRadius = 700.0 AutoReadOnly

; Neither variable below needs to be read by a CK Condition, so neither carries "Conditional".
Bool bCampWatchStarted = False
Float fLetterDueGameTime = 0.0 ; absolute Utility.GetCurrentGameTime() the letter is due; 0 = none pending

; ---------------------------------------------------------------------------
; Stage 20 -> 30: ambush watch
; ---------------------------------------------------------------------------

; Called once, from the Stage 20 fragment, after the player has read the farm/cellar documents.
; Polling here mirrors the accepted Q00 pattern (docs/ARCHITECTURE.md, "E24"): a position check
; avoids a trigger box and any navmesh edit in a vanilla exterior cell. Guarded against a double
; start (e.g. a dialogue branch re-running the fragment) so only one OnUpdate chain is ever alive.
Function BeginCampWatch()
    If bCampWatchStarted
        Return
    EndIf
    bCampWatchStarted = True
    RegisterForSingleUpdate(2.0)
EndFunction

; Overrides NHV_ContractBaseScript.OnUpdate(): runs the Stage 20 ambush-distance check first. Once a
; scene is locked, later ticks fall through to Parent.OnUpdate() (the base watchdog) instead. The
; two branches never both run in the SAME tick: AmbushDistanceCheck() already re-registers itself
; (still waiting) or triggers LockCutscene() (which re-registers on the scene's behalf) - calling
; Parent.OnUpdate() right after in that same tick would immediately re-read the just-set lock state
; with iCutsceneTicks still at 0 and IsPlaying() still False, a start-up race. Returning instead lets
; the NEXT tick take the Parent.OnUpdate() branch cleanly.
Event OnUpdate()
    If GetStage() == 20 && !IsCutsceneLocked()
        AmbushDistanceCheck()
        Return
    EndIf
    Parent.OnUpdate()
EndEvent

Function AmbushDistanceCheck()
    If GetStage() != 20
        bCampWatchStarted = False ; quest moved on (or was reset by MCM debug) - stop polling silently
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer || !CampMarker
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    If kPlayer.GetDistance(CampMarker) <= CampAmbushRadius
        StartCampAmbush()
    Else
        RegisterForSingleUpdate(2.0)
    EndIf
EndFunction

Function StartCampAmbush()
    If !HrefnaAlias
        NHV_Util.Log(NHV_Cfg_Debug, "StartCampAmbush: HrefnaAlias property not set in the CK")
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    Actor kHrefna = HrefnaAlias.GetActorRef()
    If !kHrefna || kHrefna.IsDead() || kHrefna.IsDisabled()
        NHV_Util.Log(NHV_Cfg_Debug, "StartCampAmbush: Hrefna unavailable, staying on Stage 20")
        RegisterForSingleUpdate(2.0) ; keep polling; she may become available again after a load
        Return
    EndIf
    If !CampAmbushScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartCampAmbush: CampAmbushScene property not set in the CK")
        Return
    EndIf
    bCampWatchStarted = False
    LockCutscene(CampAmbushScene)
    CampAmbushScene.Start()
EndFunction

; Called from the CampAmbushScene's end fragment.
Function EndCampAmbush()
    UnlockCutscene()
    If GetStage() < 30
        SetStage(30)
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Stage 50: Veyra's Trial
; ---------------------------------------------------------------------------

; Called from the Stage 40->50 dialogue fragment (Hrefna agrees to hear Veyra out).
Function StartVeyraTrial()
    FillVeyraAlias() ; NHV_ContractBaseScript: ForceRefTo from NHV_CoreScript.GetVeyraActor()
    If !VeyraAlias || !VeyraAlias.GetActorRef()
        ; Optional alias unfilled (E16-style soft dependency broke, or a patch removed Veyra) -
        ; fall back to a plain dialogue-driven Stage 50 without the appearance scene. The CK
        ; wires a fallback topic for this case (docs/ck/M1.6-Q01-CK-Anleitung.md).
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: Veyra unavailable, skipping scene")
        Return
    EndIf
    If !VeyraTrialScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: VeyraTrialScene property not set in the CK")
        Return
    EndIf
    LockCutscene(VeyraTrialScene)
    VeyraTrialScene.Start()
EndFunction

Function EndVeyraTrial()
    UnlockCutscene()
    ; Stage stays 50; the Persuade/Intimidate/"Step aside" branch and the Quintus scenes are
    ; dialogue- and package-driven from here (CK), ending in OnQuintusKilled() below.
EndFunction

; ---------------------------------------------------------------------------
; Stage 50 -> 60: Quintus dies
; ---------------------------------------------------------------------------

; Called by NHV_Q01_QuintusAliasScript.OnDeath(), regardless of which scene/variant played or who
; struck the killing blow.
Function OnQuintusKilled(Actor akKiller)
    If GetStage() < 40 || GetStage() >= 60
        Return ; too early (unscripted death, see docs/plan section 10) or already handled
    EndIf
    If akKiller == Game.GetPlayer() && NHV_Flag_HrefnaUnproven
        NHV_Flag_HrefnaUnproven.SetValueInt(1) ; player did the killing herself: Trial not passed
    EndIf
    SetStage(60)
EndFunction

; Called from the Stage 60 fragment when the player searches Quintus' belongings.
Function GiveOculatusFragment()
    GiveFragmentIfMissing(None, OculatusFragment1)
EndFunction

; ---------------------------------------------------------------------------
; Stage 70: Judgement
; ---------------------------------------------------------------------------
; All three functions guard on GetStage() == 70 so a doubled dialogue callback (e.g. the topic
; fires twice from a fast double-click) can never run the outcome twice.

Function JudgeRecruit()
    If GetStage() != 70
        Return
    EndIf
    If !HrefnaAlias
        NHV_Util.Log(NHV_Cfg_Debug, "JudgeRecruit: HrefnaAlias property not set in the CK")
        Return
    EndIf
    Actor kHrefna = HrefnaAlias.GetActorRef()
    CompleteRecruitment(kHrefna, NHV_Status_Hrefna, HrefnaFamilySlotAlias, HrefnaAlias, KitchenMarker)
    Actor kPlayer = Game.GetPlayer()
    If BogwifesKnife && kPlayer
        kPlayer.AddItem(BogwifesKnife, 1, True)
    EndIf
    SetStage(100)
EndFunction

Function JudgeRelease()
    If GetStage() != 70
        Return
    EndIf
    If NHV_Status_Hrefna
        NHV_Status_Hrefna.SetValueInt(STATUS_RELEASED)
    EndIf
    fLetterDueGameTime = Utility.GetCurrentGameTime() + 7.0 ; 7 in-game days, concept section 7
    RegisterForSingleUpdateGameTime(168.0)
    SetStage(100)
EndFunction

Function JudgeSilence()
    If GetStage() != 70
        Return
    EndIf
    ; Set STATUS_KILLED immediately: the Brotherhood's judgement is final the moment it is spoken,
    ; regardless of whether the ensuing fight actually finishes her off in this session (she could
    ; flee, or the player could stop chasing). This guarantees the Global never sits at
    ; STATUS_UNKNOWN forever. RecruitDied() (triggered by her eventual OnDeath, whenever that
    ; happens) still fires the NHV_RecruitDied ModEvent - only the redundant SetValueInt is skipped
    ; there since the status already reads STATUS_KILLED.
    If NHV_Status_Hrefna
        NHV_Status_Hrefna.SetValueInt(STATUS_KILLED)
    EndIf
    If !HrefnaAlias
        NHV_Util.Log(NHV_Cfg_Debug, "JudgeSilence: HrefnaAlias property not set in the CK")
    Else
        Actor kHrefna = HrefnaAlias.GetActorRef()
        If kHrefna && !kHrefna.IsDead()
            kHrefna.StartCombat(Game.GetPlayer())
        EndIf
    EndIf
    SetStage(100)
EndFunction

; ---------------------------------------------------------------------------
; Release letter (game-time timer, fully independent of the OnUpdate cutscene watchdog above)
; ---------------------------------------------------------------------------
; IMPORTANT CK NOTE: Stage 100 must NOT be flagged "Complete Quest" while a pending release letter
; needs to fire (Judgement "Release"). Completing/stopping a quest stops its script from receiving
; further OnUpdateGameTime callbacks and its aliases (incl. PlayerRefAlias) from receiving
; OnPlayerLoadGame - so a stopped Q01 could never deliver the letter or reconcile the timer on load.
; Leave Stage 100 as the quest's final-but-not-completed stage instead (a common, intentional
; Bethesda pattern for exactly this reason); the Journal/Debrief plays identically either way. See
; docs/ck/M1.6-Q01-CK-Anleitung.md and docs/plan/Q01-The-Unanswered-Sacrament.md section 8b.

; Defense in depth for OnContractLoadGame() below and for the timer surviving an unexpected engine
; hiccup: always re-derives the wait from the stored absolute due time rather than trusting that a
; previously registered RegisterForSingleUpdateGameTime call is still pending.
Event OnUpdateGameTime()
    If fLetterDueGameTime <= 0.0
        Return ; stray callback, nothing pending
    EndIf
    Float fRemainingDays = fLetterDueGameTime - Utility.GetCurrentGameTime()
    If fRemainingDays <= 0.0
        fLetterDueGameTime = 0.0
        DeliverReleaseLetter()
    Else
        ; re-arm for exactly what is left; covers a load that jumped the clock forward or back
        RegisterForSingleUpdateGameTime(fRemainingDays * 24.0)
    EndIf
EndEvent

Function DeliverReleaseLetter()
    Actor kPlayer = Game.GetPlayer()
    If kPlayer && HrefnaReleaseLetter
        kPlayer.AddItem(HrefnaReleaseLetter, 1, True)
        NHV_Util.Log(NHV_Cfg_Debug, "DeliverReleaseLetter: letter delivered")
    EndIf
EndFunction

; Overrides NHV_ContractBaseScript.OnContractLoadGame(), called from
; NHV_ContractPlayerAliasScript.OnPlayerLoadGame(). Re-arms the release-letter timer on load: if
; fLetterDueGameTime is still pending but for any reason (engine hiccup, a future edit that stops
; the quest too early) no OnUpdateGameTime callback is currently scheduled, this makes sure one gets
; scheduled again instead of the letter silently never arriving. Safe to call even when a callback IS
; still pending - RegisterForSingleUpdateGameTime just replaces it with the same due time.
Function OnContractLoadGame()
    If fLetterDueGameTime <= 0.0
        Return ; nothing pending
    EndIf
    Float fRemainingDays = fLetterDueGameTime - Utility.GetCurrentGameTime()
    If fRemainingDays <= 0.0
        fLetterDueGameTime = 0.0
        DeliverReleaseLetter()
    Else
        RegisterForSingleUpdateGameTime(fRemainingDays * 24.0)
    EndIf
EndFunction
