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
GlobalVariable Property NHV_Q01_TrialActive Auto     ; 004993; 1 while Veyra's trial runs: condition of the alias package NHV_Pkg_Q01_VeyraTrialHold

; -- NHV_Sys_Family's reserved alias for Hrefna (alias 2, "HrefnaSlot" - already exported with
; NHV_RecruitAliasScript and StatusGlobal wired, see plugin-text/Quests/NHV_Sys_Family) --
ReferenceAlias Property HrefnaFamilySlotAlias Auto

; -- World references (XMarkers, filled in the CK) --
ObjectReference Property CampMarker Auto      ; NHV_Mk_Q01_CampMarker, ambush poll target
ObjectReference Property KitchenMarker Auto   ; NHV_Mk_Q01_KitchenSpot, Homecoming destination
ObjectReference Property VeyraTrialMarker Auto ; NHV_Mk_Q01_VeyraAppearSpot, where Veyra steps out of the dark for the trial

; -- Scenes --
Scene Property CampAmbushScene Auto  ; NHV_Scn_Q01_01CampAmbush
Scene Property VeyraTrialScene Auto  ; NHV_Scn_Q01_02VeyraTrial
Scene Property QuintusApproachScene Auto ; NHV_Scn_Q01_03QuintusApproach, played when Hrefna and the player reach Quintus

; -- Items --
Book Property OculatusFragment1 Auto   ; NHV_Item_OculatusFragment1
Book Property QuintusFieldNote Auto ; NHV_Book_QuintusFieldNote, found on his body
Weapon Property BogwifesKnife Auto     ; NHV_Weap_BogwifesKnife, Judgement "Recruit" reward
Book Property HrefnaReleaseLetter Auto ; NHV_Book_HrefnaReleaseLetter, delivered 7 days after Release

; Player must be within this many game units of CampMarker for the ambush to trigger. A plain
; GetDistance() comparison is used on purpose - no squared-distance literal math anywhere in this
; file (docs/CONVENTIONS.md warns the German-locale Papyrus compiler mishandles constant float
; multiplication such as "450.0 * 450.0").
Float Property CampAmbushRadius = 700.0 AutoReadOnly

; Player and Hrefna must both be this close to Quintus before the approach scene starts and Hrefna attacks.
Float Property KillApproachRadius = 600.0 AutoReadOnly

; Neither variable below needs to be read by a CK Condition, so neither carries "Conditional".
Bool bCampWatchStarted = False
Float fLetterDueGameTime = 0.0 ; absolute Utility.GetCurrentGameTime() the letter is due; 0 = none pending

; Stage 50 "Hrefna kills Quintus herself" path (29.09.2026). Additive variables, no CK condition needs them.
Bool bHrefnaWillKill = False   ; set when Persuade/Intimidate succeeded; cleared by "Step aside"
Bool bApproachStarted = False  ; approach scene was started (or skipped) once
Bool bHrefnaAttacked = False   ; Hrefna was sent into combat against Quintus once
Bool bHrefnaFought = False     ; her aggression/protection were changed and still need restoring
Int iApproachTicks = 0         ; ticks waited for the approach scene to report IsPlaying() when no lock is held
Int iAttackTries = 0           ; retries of HrefnaAttacksQuintus() while Hrefna/Quintus are not available
Float fHrefnaAggression = 0.0  ; her Aggression value before the fight

; ---------------------------------------------------------------------------
; Stage 20 -> 30: ambush watch
; ---------------------------------------------------------------------------

; Called once, from the Stage 20 fragment, after the player has read the farm/cellar documents.
; Polling here mirrors the accepted Q00 pattern (docs/ARCHITECTURE.md, "E24"): a position check
; avoids a trigger box and any navmesh edit in a vanilla exterior cell. Guarded against a double
; start (e.g. a dialogue branch re-running the fragment) so only one OnUpdate chain is ever alive.
Function BeginCampWatch()
    If bCampWatchStarted || GetStage() >= 30
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
    If GetStage() == 50 && bHrefnaWillKill && !bHrefnaAttacked
        ; Kill watch (Hrefna will kill Quintus). While the approach scene locks the controls the base
        ; watchdog runs and this chain is kept alive; the tick after the unlock sends Hrefna in even if
        ; the scene's end fragment never ran (watchdog recovery, load).
        If IsCutsceneLocked()
            Parent.OnUpdate()
            RegisterForSingleUpdate(2.0)
        ElseIf bApproachStarted
            ; No lock held (Core lock skipped it, or the watchdog already released it). Never send Hrefna in
            ; while the scene is still playing; give a just-started scene a few ticks (IsPlaying() lags).
            iApproachTicks += 1
            If QuintusApproachScene && (QuintusApproachScene.IsPlaying() || iApproachTicks <= 3)
                RegisterForSingleUpdate(2.0)
            Else
                HrefnaAttacksQuintus()
            EndIf
        Else
            KillWatchCheck()
        EndIf
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
    ; Stage 50 (Trial) begins here, even when the appearance scene cannot run below - the Trial01/
    ; Persuade/Intimidate dialogue is gated on Stage 50 and must stay reachable (fallback path).
    Int iStage = GetStage()
    If iStage < 40 || iStage >= 60
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: called in Stage " + iStage + ", ignored")
        Return
    EndIf
    If VeyraTrialScene && VeyraTrialScene.IsPlaying()
        Return ; double call (both Offer07 topics); the scene is already running
    EndIf
    Bool bFirstCall = (iStage < 50)
    If bFirstCall
        SetStage(50)
    Else
        Return ; Stage 50 already reached: the trial was started by an earlier call
    EndIf
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
    ; Veyra lives in the Deep Sanctuary; bring her to the camp (the scene has no travel action).
    Actor kVeyra = VeyraAlias.GetActorRef()
    If kVeyra.IsDead() || kVeyra.IsDisabled()
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: Veyra dead or disabled, skipping scene")
        Return
    EndIf
    If VeyraTrialMarker
        kVeyra.MoveTo(VeyraTrialMarker)
    ElseIf CampMarker
        kVeyra.MoveTo(CampMarker, 0.0, 256.0, 0.0)
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: VeyraTrialMarker not set, Veyra placed near CampMarker")
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: no marker for Veyra, she stays where she is")
    EndIf
    ; The alias package NHV_Pkg_Q01_VeyraTrialHold (stage 50 + this global) keeps her at the marker for the scene.
    If NHV_Q01_TrialActive
        NHV_Q01_TrialActive.SetValueInt(1)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraTrial: NHV_Q01_TrialActive property not set, Veyra is not held")
    EndIf
    kVeyra.EvaluatePackage()
    LockCutscene(VeyraTrialScene)
    VeyraTrialScene.Start()
EndFunction

Function EndVeyraTrial()
    UnlockCutscene()
    ReleaseVeyraFromTrial()
    If bHrefnaWillKill && !bHrefnaAttacked
        RegisterForSingleUpdate(2.0) ; the trial scene's watchdog chain ended with the unlock: resume the kill watch
    EndIf
    ; Stage stays 50; the Persuade/Intimidate/"Step aside" branch and the Quintus scenes are
    ; dialogue- and package-driven from here (CK), ending in OnQuintusKilled() below.
EndFunction

; The trial is over (or was abandoned): Veyra's hold package ends, she may leave normally.
Function ReleaseVeyraFromTrial()
    If NHV_Q01_TrialActive && NHV_Q01_TrialActive.GetValueInt() != 0
        NHV_Q01_TrialActive.SetValueInt(0)
        If VeyraAlias
            Actor kVeyra = VeyraAlias.GetActorRef()
            If kVeyra
                kVeyra.EvaluatePackage()
            EndIf
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "Veyra released from the trial hold")
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Stage 50: Hrefna kills Quintus herself (Persuade / Intimidate succeeded)
; ---------------------------------------------------------------------------

; Called from the end fragments of the successful Persuade and Intimidate responses. Does not start
; anything by itself: once the flag is set, a distance poll waits until player and Hrefna are near Quintus.
Function HrefnaAgreesToKill()
    If GetStage() != 50 || bHrefnaAttacked
        NHV_Util.Log(NHV_Cfg_Debug, "HrefnaAgreesToKill: ignored (stage " + GetStage() + ")")
        Return
    EndIf
    bHrefnaWillKill = True
    iAttackTries = 0
    NHV_Util.Log(NHV_Cfg_Debug, "HrefnaAgreesToKill: Hrefna will kill Quintus, kill watch running")
    RegisterForSingleUpdate(2.0)
EndFunction

; Called from the "Step aside" response: the player does it, no scene, Trial counts as unproven.
Function PlayerWillKill()
    If bHrefnaAttacked
        Return ; too late, the fight already started
    EndIf
    bHrefnaWillKill = False
    bApproachStarted = False ; a later HrefnaAgreesToKill() starts from scratch (distance check, scene)
    iApproachTicks = 0
    iAttackTries = 0
    NHV_Util.Log(NHV_Cfg_Debug, "PlayerWillKill: kill watch off")
EndFunction

Function KillWatchCheck()
    If GetStage() != 50 || !bHrefnaWillKill || bApproachStarted
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    Actor kQuintus = None
    Actor kHrefna = None
    If QuintusAlias
        kQuintus = QuintusAlias.GetActorRef()
    EndIf
    If HrefnaAlias
        kHrefna = HrefnaAlias.GetActorRef()
    EndIf
    If kQuintus && kQuintus.IsDead()
        Return ; dead: OnQuintusKilled() advances the quest
    EndIf
    If kHrefna && kHrefna.IsDead()
        bHrefnaWillKill = False ; nobody left to do it; the player can still kill him (unproven)
        NHV_Util.Log(NHV_Cfg_Debug, "KillWatchCheck: Hrefna is dead, kill watch off")
        Return
    EndIf
    If kPlayer && kQuintus && kHrefna && !kHrefna.IsDead() && kQuintus.Is3DLoaded() && kHrefna.Is3DLoaded()
        If kPlayer.GetDistance(kQuintus) <= KillApproachRadius && kHrefna.GetDistance(kQuintus) <= KillApproachRadius
            StartQuintusApproach()
            Return
        EndIf
    EndIf
    RegisterForSingleUpdate(3.0) ; not there yet (or Hrefna/Quintus not loaded): keep waiting, cheap
EndFunction

Function StartQuintusApproach()
    bApproachStarted = True
    If !QuintusApproachScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartQuintusApproach: QuintusApproachScene property not set in the CK, attacking without scene")
        HrefnaAttacksQuintus()
        Return
    EndIf
    iApproachTicks = 0
    LockCutscene(QuintusApproachScene)
    QuintusApproachScene.Start()
    RegisterForSingleUpdate(2.0) ; also when no lock was taken: OnUpdate then waits for the scene
EndFunction

; Called from the QuintusApproach scene's end fragment.
Function EndQuintusApproach()
    UnlockCutscene()
    If bHrefnaWillKill
        HrefnaAttacksQuintus()
    EndIf
EndFunction

Function HrefnaAttacksQuintus()
    If bHrefnaAttacked || GetStage() != 50
        Return
    EndIf
    MakeQuintusMortal()
    Actor kHrefna = None
    Actor kQuintus = None
    If HrefnaAlias
        kHrefna = HrefnaAlias.GetActorRef()
    EndIf
    If QuintusAlias
        kQuintus = QuintusAlias.GetActorRef()
    EndIf
    If (kHrefna && kHrefna.IsDead()) || (kQuintus && kQuintus.IsDead())
        bHrefnaWillKill = False ; one of them is dead: nothing to fight (Quintus' death is handled by OnQuintusKilled)
        NHV_Util.Log(NHV_Cfg_Debug, "HrefnaAttacksQuintus: Hrefna or Quintus already dead, giving up")
        Return
    EndIf
    If !kHrefna || !kQuintus || !kHrefna.Is3DLoaded() || !kQuintus.Is3DLoaded()
        iAttackTries += 1
        If iAttackTries > 10
            bHrefnaWillKill = False ; give up quietly; the player can still kill him (unproven)
            bApproachStarted = False
            NHV_Util.Log(NHV_Cfg_Debug, "HrefnaAttacksQuintus: Hrefna or Quintus not available, giving up")
        Else
            RegisterForSingleUpdate(3.0) ; try again (stays in the approach-started branch of OnUpdate)
        EndIf
        Return
    EndIf
    bHrefnaAttacked = True
    fHrefnaAggression = kHrefna.GetActorValue("Aggression")
    kHrefna.SetActorValue("Aggression", 1.0)
    kHrefna.GetActorBase().SetProtected(True) ; only the player can kill her while she fights (contract must not fail)
    bHrefnaFought = True
    kHrefna.StartCombat(kQuintus)
    NHV_Util.Log(NHV_Cfg_Debug, "HrefnaAttacksQuintus: Hrefna attacks Quintus")
EndFunction

; Undo the fight state (aggression, protection, combat). Idempotent; called when Quintus dies and on load.
Function RestoreHrefnaAfterFight()
    If !bHrefnaFought
        Return
    EndIf
    ; The protection lives on the ActorBase (persistent), so take it off even if the alias is already
    ; empty (CompleteRecruitment clears it): NHV_Hrefna is 004007 in this plugin.
    ActorBase kBase = Game.GetFormFromFile(0x004007, "NightsHarvest.esp") as ActorBase
    If kBase
        kBase.SetProtected(False)
    EndIf
    Actor kHrefna = None
    If HrefnaAlias
        kHrefna = HrefnaAlias.GetActorRef()
    EndIf
    If kHrefna
        kHrefna.StopCombat()
        kHrefna.StopCombatAlarm()
        kHrefna.SetActorValue("Aggression", fHrefnaAggression)
        kHrefna.EvaluatePackage()
    EndIf
    If kBase
        bHrefnaFought = False ; only forget the fight state once the protection is really gone
        NHV_Util.Log(NHV_Cfg_Debug, "RestoreHrefnaAfterFight: Hrefna calm again")
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "RestoreHrefnaAfterFight: NHV_Hrefna base not found, will retry on load")
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Stage 50 -> 60: Quintus dies
; ---------------------------------------------------------------------------

; Called by NHV_Q01_QuintusAliasScript.OnDeath(), regardless of which scene/variant played or who
; struck the killing blow.
Function OnQuintusKilled(Actor akKiller)
    RestoreHrefnaAfterFight() ; before the stage guards: also undoes a fight state left by an odd death
    If GetStage() < 40 || GetStage() >= 60
        Return ; too early (unscripted death, see docs/plan section 10) or already handled
    EndIf
    If akKiller == Game.GetPlayer() && NHV_Flag_HrefnaUnproven
        NHV_Flag_HrefnaUnproven.SetValueInt(1) ; player did the killing herself: Trial not passed
    EndIf
    StockQuintusBody()
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
    Actor kPlayer = Game.GetPlayer()
    If BogwifesKnife && kPlayer
        kPlayer.AddItem(BogwifesKnife, 1, True)
    EndIf
    ; Stage 100 FIRST: NHV_Pkg_Hrefna_CampWait (Q01 stage < 100) must be invalid before she is moved and
    ; re-evaluated, otherwise she walks straight back to her camp (ingame test 29.09.2026).
    SetStage(100)
    CompleteRecruitment(kHrefna, NHV_Status_Hrefna, HrefnaFamilySlotAlias, HrefnaAlias, KitchenMarker)
    bRecruitHomeChecked = True ; she was placed correctly just now
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
; CK NOTE (team lead, 28.09.2026): Stage 100 SHOULD be flagged "Complete Quest" - that only marks the
; quest completed in the journal, it keeps running and still receives OnUpdateGameTime/OnPlayerLoadGame.
; What must NOT happen before the release letter is delivered is Stop() / "Shut Down Quest": a stopped
; Q01 could never deliver the letter or reconcile the timer on load.
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
    If GetStage() != 50 || (VeyraTrialScene && !VeyraTrialScene.IsPlaying())
        ReleaseVeyraFromTrial() ; a hold from an interrupted trial must not outlive the trial scene
    EndIf
    If GetStage() >= 50
        MakeQuintusMortal() ; saves that reached stage 50 before this fix (ingame test 29.09.2026)
    EndIf
    If GetStage() >= 60 && GetStage() < 100
        StockQuintusBody() ; saves where Quintus died before his body carried the papers
    EndIf
    If GetStage() >= 60
        RestoreHrefnaAfterFight() ; no-op unless a fight state was left behind
    ElseIf GetStage() == 50
        Actor kQuintusDead = None
        If QuintusAlias
            kQuintusDead = QuintusAlias.GetActorRef()
        EndIf
        If kQuintusDead && kQuintusDead.IsDead()
            OnQuintusKilled(None) ; he died while the OnDeath event was missed (load, odd death): move on
        ElseIf bHrefnaWillKill && !bHrefnaAttacked
            RegisterForSingleUpdate(2.0) ; resume the kill watch after loading
        EndIf
    EndIf
    ReturnRecruitHome()
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

; NHV_Quintus is Essential in the ESP so he cannot die before the trial. From stage 50 on he must be killable
; (by Hrefna or the player); ActorBase.SetEssential persists in the save. Idempotent.
Function MakeQuintusMortal()
    If !QuintusAlias
        Return
    EndIf
    Actor kQuintus = QuintusAlias.GetActorRef()
    If !kQuintus
        NHV_Util.Log(NHV_Cfg_Debug, "MakeQuintusMortal: QuintusAlias empty")
        Return
    EndIf
    ActorBase kBase = kQuintus.GetActorBase()
    If kBase.IsEssential()
        kBase.SetEssential(False)
        NHV_Util.Log(NHV_Cfg_Debug, "Quintus is no longer essential")
    EndIf
EndFunction

; Quintus' papers (field note + Oculatus fragment 1) on his body, so stage 60 "search his belongings" has
; something to find. Idempotent: only adds what the body and the player do not have yet.
Bool bBodyStocked = False
Bool bRecruitReturned = False       ; legacy one-shot (first repair, 29.09.2026), kept for saves
Bool bRecruitHomeChecked = False    ; second repair: she left again although the first check ran (CampWait still valid)

Function StockQuintusBody()
    If bBodyStocked || !QuintusAlias
        Return
    EndIf
    Actor kQuintus = QuintusAlias.GetActorRef()
    If !kQuintus
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If QuintusFieldNote && kQuintus.GetItemCount(QuintusFieldNote) == 0 && kPlayer.GetItemCount(QuintusFieldNote) == 0
        kQuintus.AddItem(QuintusFieldNote, 1, True)
    EndIf
    If OculatusFragment1 && kQuintus.GetItemCount(OculatusFragment1) == 0 && kPlayer.GetItemCount(OculatusFragment1) == 0
        kQuintus.AddItem(OculatusFragment1, 1, True)
    EndIf
    bBodyStocked = True ; once: items the player drops or sells later are not restocked
EndFunction

; A recruited Hrefna walked back to her camp (CampWait had no stage condition before 29.09.2026): put her home.
Function ReturnRecruitHome()
    If bRecruitHomeChecked || GetStage() < 100 || !HrefnaFamilySlotAlias || !KitchenMarker || !NHV_Status_Hrefna
        Return
    EndIf
    If NHV_Status_Hrefna.GetValueInt() != STATUS_RECRUITED
        Return
    EndIf
    Actor kHrefna = HrefnaFamilySlotAlias.GetActorRef()
    If kHrefna && !kHrefna.IsDead() && kHrefna.GetParentCell() != KitchenMarker.GetParentCell()
        kHrefna.MoveTo(KitchenMarker)
        NHV_Util.Log(NHV_Cfg_Debug, "Hrefna returned to the Kitchen")
    EndIf
    If kHrefna && !kHrefna.IsDead()
        kHrefna.EvaluatePackage() ; also drops CampWait (stage 100 is done) for a save where she never left
    EndIf
    bRecruitHomeChecked = True ; one-time repair only; later family logic owns her position
EndFunction
