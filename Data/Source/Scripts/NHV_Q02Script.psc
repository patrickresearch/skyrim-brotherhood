Scriptname NHV_Q02Script extends NHV_ContractBaseScript
{Q02 "Cold Waters" - Sings-Beneath-Ice, Windhelm harbor. Second recruitment contract after Q01;
runs the Whisper/Hunt/Observation/Trial/Judgement/Homecoming schema from concept section 7 for this
candidate. Stage numbers match dialogue/Journal.csv and dialogue/Q02.csv exactly and must never be
renumbered once released (docs/CONVENTIONS.md). No Maintenance()/Migrate() here, same as
NHV_Q01Script: nothing save-relevant needs versioned migration for a single contract quest: state
lives in Globals and Aliases, which the save game already tracks natively. VeyraAlias, Core,
PlayerRef, LockCutscene(Scene)/UnlockCutscene()/IsCutsceneLocked()/RecoverCutsceneOnLoad()/
OnContractLoadGame() and CompleteRecruitment()'s five-parameter Homecoming signature are all
inherited from NHV_ContractBaseScript (Team-Lead, Runde 2) - do not redeclare them here. See
docs/plan/Q02-Cold-Waters.md for the full design and open CK decisions. M1.7.}

; -- Aliases (filled in the CK). VeyraAlias is inherited from NHV_ContractBaseScript - do not
; redeclare it here (that would shadow the base property with an always-empty one of the same
; name, and the base's own FillVeyraAlias()/StartVeyraTrial()-style helpers would then fill the
; INHERITED property while every read in this script saw the local, unfilled one instead). The
; quest's PlayerRef alias itself carries no property here either - it only needs
; NHV_ContractPlayerAliasScript attached directly to it in the CK, same as NHV_Q01Script. --
ReferenceAlias Property SingsAlias Auto
ReferenceAlias Property TorbjornAlias Auto
ReferenceAlias Property DrinksAlias Auto
ReferenceAlias Property HaldorAlias Auto
ReferenceAlias Property AeliusAlias Auto
ReferenceAlias Property HjoraldAlias Auto
ReferenceAlias Property AssemblageWitnessAlias Auto ; Optional; [proposal] side quest B only

; NHV_Sys_Family's reserved alias for Sings (ID 3, "SingsSlot" - already exported with
; NHV_RecruitAliasScript and StatusGlobal wired, see plugin-text/Quests/NHV_Sys_Family). Passed as
; akFamilySlotAlias to CompleteRecruitment(), exactly like NHV_Q01Script.HrefnaFamilySlotAlias.
ReferenceAlias Property SingsFamilySlotAlias Auto

; -- Globals --
GlobalVariable Property NHV_Status_Sings Auto
GlobalVariable Property NHV_Q02_Result Auto             ; 1 recruit / 2 silence / 3 release / 4 surrender, matches dialogue/Q02.csv conditions
GlobalVariable Property NHV_Q02_HaldorSaved Auto        ; 0/1, matches dialogue/Q02.csv conditions - read/write only via HaldorSaved()/SetHaldorSaved() below
GlobalVariable Property NHV_Q02_Flag_SingsUnproven Auto ; [proposal] mirrors NHV_Flag_HrefnaUnproven
GlobalVariable Property NHV_Q02_Flag_VeyraDisapproval Auto
GlobalVariable Property NHV_Q02_Flag_AeliusFallback Auto ; [proposal] set when Aelius is already dead at Stage 60
GlobalVariable Property NHV_Q02_Flag_SideA_Done Auto    ; [proposal] side quest A, "Torbjorn's Ledger"
GlobalVariable Property NHV_Q02_Flag_SideB_Done Auto    ; [proposal] side quest B, "The Assemblage's Due"
GlobalVariable Property NHV_Q02_Flag_RewardGiven Auto   ; guards GiveRecruitReward() against a second grant if the debrief line is repeated

; -- World references (XMarkers, filled in the CK) --
ObjectReference Property DockWatchMarker Auto  ; NHV_Mk_Q02_DockWatch, Stage 30 night-window poll target
ObjectReference Property SingsHomeMarker Auto  ; NHV_Mk_Q02_SingsHomeMarker, Homecoming destination (Drowned Pool)

; -- Scenes --
Scene Property HaldorDocksScene Auto ; NHV_Scn_Q02_01HaldorDocks - deliberately never cutscene-locked, see StartHaldorDocksScene()
Scene Property VeyraHollowScene Auto ; NHV_Scn_Q02_02VeyraHollow
Scene Property AeliusKillScene Auto  ; NHV_Scn_Q02_03AeliusKill

; -- Items --
Book Property OculatusFragment2 Auto ; NHV_Note_Dispatch02 / OculatusDispatch02, already in dialogue/Books.csv (NHV_SYS_BOOK_82) - do not create a new record for this, only reference the existing one
MiscObject Property Gold001 Auto     ; vanilla Gold, filled in the CK as a soft reference (not a Vanilla-Record edit, just a Property pointing at it)
Armor Property ShadowscaleWraps Auto ; NHV_Armor_ShadowscaleWraps, Recruit-only Homecoming reward, see docs/concept/Q02-Gegenstaende-und-Lore.md ("Veyra uebergibt sie erst nach dem Urteil, im Debrief")

; -- [proposal] Side quest A: "Torbjorn's Ledger" --
Book Property HarborLog01 Auto
Book Property HarborLog02 Auto
Book Property HarborLog03 Auto

; -- [proposal] Side quest B: "The Assemblage's Due" --
MiscObject Property FamilyLocket Auto

; Bounty paid to the player on the "surrender to the Jarl" Judgement branch (concept: 500 gold).
Int Property BOUNTY_GOLD = 500 AutoReadOnly

; Distances use plain GetDistance() everywhere, never a squared-distance literal (docs/CONVENTIONS.md
; warns the German-locale Papyrus compiler mishandles constant float multiplication, e.g. "450.0 * 450.0").
Float Property NightWatchRadius = 1200.0 AutoReadOnly
Float Property TailDetectionRadius = 350.0 AutoReadOnly

; Which poll BeginNightWatch()/BeginTailWatch() is currently running. Only one is ever active; each
; one re-checks GetStage() on every tick and stops itself the moment the quest has moved on, so a
; stale poll from a previous session can never fire on the wrong stage after a load. Plain variable,
; not Conditional: Conditional only controls whether a CK Condition can read it via
; GetVMQuestVariable (which would also require appending "Conditional" to this script's own name in
; the CK) - it has no effect on save persistence either way, so it is left off here since no CK
; Condition needs to read this dispatch flag.
Int Property WATCH_NONE = 0 AutoReadOnly
Int Property WATCH_NIGHT = 1 AutoReadOnly
Int Property WATCH_TAIL = 2 AutoReadOnly
Int iWatchMode = 0

; ---------------------------------------------------------------------------
; Small None-safe getters for the alias actors used across several functions below. Each one logs
; once (Debug-gated) instead of letting a poll chain call a method on a None alias property silently
; every tick if the CK left it unset.
; ---------------------------------------------------------------------------

Actor Function GetSings()
    If !SingsAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetSings: SingsAlias property not set in the CK")
        Return None
    EndIf
    Return SingsAlias.GetActorRef()
EndFunction

Actor Function GetHaldor()
    If !HaldorAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetHaldor: HaldorAlias property not set in the CK")
        Return None
    EndIf
    Return HaldorAlias.GetActorRef()
EndFunction

Actor Function GetAelius()
    If !AeliusAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetAelius: AeliusAlias property not set in the CK")
        Return None
    EndIf
    Return AeliusAlias.GetActorRef()
EndFunction

Actor Function GetHjorald()
    If !HjoraldAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetHjorald: HjoraldAlias property not set in the CK")
        Return None
    EndIf
    Return HjoraldAlias.GetActorRef()
EndFunction

; None-safe read/write for NHV_Q02_HaldorSaved, so every call site logs the same way if the CK
; forgot to wire the Global instead of risking a None.GetValueInt() call.
Bool Function HaldorSaved()
    If !NHV_Q02_HaldorSaved
        NHV_Util.Log(NHV_Cfg_Debug, "HaldorSaved: NHV_Q02_HaldorSaved property not set in the CK")
        Return False
    EndIf
    Return NHV_Q02_HaldorSaved.GetValueInt() == 1
EndFunction

Function SetHaldorSaved(Bool abSaved)
    If !NHV_Q02_HaldorSaved
        NHV_Util.Log(NHV_Cfg_Debug, "SetHaldorSaved: NHV_Q02_HaldorSaved property not set in the CK")
        Return
    EndIf
    NHV_Q02_HaldorSaved.SetValueInt(abSaved as Int)
EndFunction

; ---------------------------------------------------------------------------
; Stage 20 -> 30: night window watch (no trigger box, no navmesh edit in the vanilla dock cell -
; same accepted pattern as NHV_Q01Script.BeginCampWatch(), docs/ARCHITECTURE.md "E24")
; ---------------------------------------------------------------------------

; Called once, from the Stage 20 fragment, once the knot has been identified as a night-worker's.
; Caller must SetStage(30) before or immediately after this call: UpdateNightWatch() only keeps
; polling while GetStage() == 30 and stops silently otherwise.
Function BeginNightWatch()
    iWatchMode = WATCH_NIGHT
    RegisterForSingleUpdate(5.0)
EndFunction

; Called from the Stage 30->40 fragment on the Pfad-A branch (player did not intervene): starts the
; stealth-follow watch described in docs/concept/Q02-Nebenfiguren-Autorenprofile.md ("Distanz- und
; Detection-Checks in einem Quest-Script, RegisterForSingleUpdate, kein Dauer-Polling").
Function BeginTailWatch()
    iWatchMode = WATCH_TAIL
    RegisterForSingleUpdate(1.5)
EndFunction

; Lets the two alias scripts (NHV_Q02_SingsAliasScript.OnHit()) tell a Stage-40 attack on Sings
; apart from an ordinary Pfad-B tracking moment, where no tail-watch is running and Sings' package
; must not be interrupted by a spurious OnSingsSpotted() call.
Bool Function IsTailWatchActive()
    Return iWatchMode == WATCH_TAIL
EndFunction

; Overrides NHV_ContractBaseScript.OnUpdate(): Stage 30/40's own watch runs first; once neither is
; active, later ticks fall through to Parent.OnUpdate(), the base class's single cutscene watchdog
; (docs/plan/Q01-The-Unanswered-Sacrament.md: only ONE watchdog may ever run - this class must not
; keep its own OnUpdateGameTime-based copy, which NHV_Q01Script.OnUpdate() also does not). The two
; branches never both run in the same tick, same reasoning as NHV_Q01Script.OnUpdate(): whichever
; watch function fires already re-registers itself (still watching) or calls LockCutscene() (which
; re-registers on the scene's behalf via the base class) - falling through to Parent.OnUpdate() in
; that same tick would re-read the just-set lock state with iCutsceneTicks still at 0, a start-up
; race the base class's own grace-tick handling already exists to avoid. Returning instead lets the
; NEXT tick take the Parent.OnUpdate() branch cleanly.
Event OnUpdate()
    If iWatchMode == WATCH_NIGHT
        UpdateNightWatch()
        Return
    ElseIf iWatchMode == WATCH_TAIL
        UpdateTailWatch()
        Return
    EndIf
    Parent.OnUpdate()
EndEvent

Function UpdateNightWatch()
    If GetStage() != 30
        iWatchMode = WATCH_NONE
        Return ; quest moved on (or was reset by MCM debug) - stop polling silently
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer || !DockWatchMarker
        NHV_Util.Log(NHV_Cfg_Debug, "UpdateNightWatch: DockWatchMarker property not set in the CK, still polling")
        RegisterForSingleUpdate(5.0)
        Return
    EndIf
    If !IsNightWindow()
        ; Stretch the interval while it is nowhere near the 22:00-04:00 window and/or the player is
        ; elsewhere - no need to re-check every 5s for hours on end.
        RegisterForSingleUpdate(30.0)
        Return
    EndIf
    If kPlayer.GetDistance(DockWatchMarker) <= NightWatchRadius
        StartHaldorDocksScene()
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndFunction

Function UpdateTailWatch()
    If GetStage() != 40 || HaldorSaved()
        iWatchMode = WATCH_NONE
        Return ; either the quest moved on, or the intervention branch already switched to tracking
    EndIf
    Actor kPlayer = Game.GetPlayer()
    Actor kSings = GetSings()
    If !kPlayer || !kSings || kSings.IsDead()
        RegisterForSingleUpdate(1.5)
        Return
    EndIf
    If kSings.HasLOS(kPlayer) && (kSings.IsDetectedBy(kPlayer) || kPlayer.GetDistance(kSings) <= TailDetectionRadius)
        OnSingsSpotted()
    Else
        RegisterForSingleUpdate(1.5)
    EndIf
EndFunction

; Game hour of the current in-game day, 0.0-24.0, without a Math script (Skyrim's base Papyrus has
; none): Utility.GetCurrentGameTime() is fractional days since the game started, so the whole-day
; part truncates away via a Float->Int cast and the remainder times 24 gives the hour.
Float Function GetGameHour()
    Float fDays = Utility.GetCurrentGameTime()
    Int iWholeDays = fDays as Int
    Return (fDays - iWholeDays) * 24.0
EndFunction

Bool Function IsNightWindow()
    Float fHour = GetGameHour()
    Return fHour >= 22.0 || fHour < 4.0
EndFunction

; ---------------------------------------------------------------------------
; Stage 30: the Haldor/Sings night scene and the intervene-or-watch decision
; ---------------------------------------------------------------------------

; Deliberately does NOT call LockCutscene(): this scene must stay interruptible so the player can
; activate Haldor or attack Sings mid-scene (the "rescue Haldor" branch) - a cutscene lock disables
; the player's attack/activate controls (Game.DisablePlayerControls(..., True, ...)), which would
; make the whole intervention impossible. NHV_Q02_HaldorAliasScript.Rescue() and
; NHV_Q02_SingsAliasScript.OnHit() both rely on the player being able to act freely during this one
; scene; every other Q02 scene (VeyraHollowScene, AeliusKillScene) has no such requirement and is
; locked normally.
Function StartHaldorDocksScene()
    Actor kSings = GetSings()
    Actor kHaldor = GetHaldor()
    If !kSings || !kHaldor
        NHV_Util.Log(NHV_Cfg_Debug, "StartHaldorDocksScene: Sings or Haldor unavailable, staying on Stage 30")
        RegisterForSingleUpdate(5.0) ; keep polling; either may become available again after a load
        Return
    EndIf
    If !HaldorDocksScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartHaldorDocksScene: HaldorDocksScene property not set in the CK")
        Return
    EndIf
    iWatchMode = WATCH_NONE
    HaldorDocksScene.Start()
EndFunction

; Called by NHV_Q02_HaldorAliasScript.Rescue() the moment the player intervenes (activates Haldor or
; attacks Sings) while HaldorDocksScene is still playing.
Function OnHaldorRescued()
    If HaldorSaved()
        Return ; idempotent: do not re-trigger the flee reaction twice
    EndIf
    SetHaldorSaved(True)
    Actor kSings = GetSings()
    If kSings
        kSings.EvaluatePackage() ; the CK-side flee package outranks the scene once the scene stops driving her/him
    EndIf
    If HaldorDocksScene && HaldorDocksScene.IsPlaying()
        HaldorDocksScene.Stop()
    EndIf
EndFunction

; Called from HaldorDocksScene's end fragment (scene ran to completion, no intervention). No
; UnlockCutscene() call here: the scene was never locked in the first place (see
; StartHaldorDocksScene()'s comment).
Function EndHaldorDocksScene()
    If GetStage() < 40
        SetStage(40)
    EndIf
    If HaldorSaved()
        NHV_Util.Log(NHV_Cfg_Debug, "EndHaldorDocksScene: Haldor was saved, tracking fallback (Pfad B)")
        ; Pfad B (Q02_Tracking dialogue) is dialogue- and marker-driven from here (CK); no poll needed.
    Else
        BeginTailWatch() ; Pfad A: stealth-follow Sings to the Drowned Hollow
    EndIf
EndFunction

; Called from UpdateTailWatch() once the player is spotted. The concept's fallback ("Beschattung
; entdeckt -> Spurensuche als Fallback") reuses the same Q02_Tracking dialogue branch as the
; Haldor-rescued Pfad B, so both cases funnel into one shared fallback instead of two.
Function OnSingsSpotted()
    iWatchMode = WATCH_NONE
    Actor kSings = GetSings()
    If kSings
        kSings.EvaluatePackage() ; flee package takes over; no combat is intended here
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "OnSingsSpotted: tail broken off, falling back to tracking")
EndFunction

; ---------------------------------------------------------------------------
; Stage 50: Confront the killer / Veyra's trial announcement
; ---------------------------------------------------------------------------

; Called from the Stage 50 dialogue fragment once Sings has finished explaining himself.
Function StartVeyraHollowScene()
    FillVeyraAlias() ; NHV_ContractBaseScript: ForceRefTo from NHV_CoreScript.GetVeyraActor()
    If !VeyraAlias || !VeyraAlias.GetActorRef()
        ; Optional alias unfilled (E16-style soft dependency broke, or Veyra is otherwise
        ; unavailable) - fall back to a plain dialogue-driven trial announcement without the
        ; appearance scene, same escape hatch as NHV_Q01Script.StartVeyraTrial(). The CK wires a
        ; fallback topic for this case (docs/ck/M1.7-Q02-CK-Anleitung.md).
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: Veyra unavailable, skipping scene")
        Return
    EndIf
    If !VeyraHollowScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: VeyraHollowScene property not set in the CK")
        Return
    EndIf
    LockCutscene(VeyraHollowScene)
    VeyraHollowScene.Start()
EndFunction

Function EndVeyraHollowScene()
    UnlockCutscene()
    If GetStage() < 60
        SetStage(60)
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Stage 60: the Trial - Sings kills Aelius
; ---------------------------------------------------------------------------

; Checked by the Stage 60 entry fragment before offering the scene topic, so an unscripted death of
; Aelius (random encounter, player kills him early) cannot softlock the quest.
Bool Function IsAeliusAvailable()
    Actor kAelius = GetAelius()
    Return kAelius && !kAelius.IsDead()
EndFunction

Function StartAeliusKillScene()
    If !IsAeliusAvailable()
        If NHV_Q02_Flag_AeliusFallback
            NHV_Q02_Flag_AeliusFallback.SetValueInt(1)
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "StartAeliusKillScene: Aelius unavailable, using fallback dialogue instead of the scene")
        If GetStage() < 70
            SetStage(70)
        EndIf
        Return
    EndIf
    If !AeliusKillScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartAeliusKillScene: AeliusKillScene property not set in the CK")
        Return
    EndIf
    LockCutscene(AeliusKillScene)
    AeliusKillScene.Start()
EndFunction

; Called from AeliusKillScene's end fragment. abPlayerKilled is True only if the player struck the
; killing blow instead of Sings (e.g. the player interrupted the scene) - [proposal] mirrors Q01's
; "Trial not passed" handling for a player-performed kill.
Function EndAeliusKillScene(Bool abPlayerKilled = False)
    UnlockCutscene()
    If abPlayerKilled && NHV_Q02_Flag_SingsUnproven
        NHV_Q02_Flag_SingsUnproven.SetValueInt(1)
    EndIf
    If GetStage() < 70
        SetStage(70)
    EndIf
EndFunction

; Called from the Stage 70 fragment (Sings searches Aelius' locked desk) - kept here, next to the
; Trial functions it depends on, even though it fires on Stage 70; see docs/plan/Q02-Cold-Waters.md
; section 6.
Function GiveOculatusFragment()
    GiveFragmentIfMissing(None, OculatusFragment2) ; found in the desk, not on the body - no giver actor
EndFunction

; ---------------------------------------------------------------------------
; Stage 70: Judgement. All four functions guard on GetStage() == 70 so a doubled dialogue callback
; (e.g. the topic fires twice from a fast double-click) can never run an outcome twice.
; ---------------------------------------------------------------------------

Function JudgeRecruit()
    If GetStage() != 70
        Return
    EndIf
    If !SingsAlias
        NHV_Util.Log(NHV_Cfg_Debug, "JudgeRecruit: SingsAlias property not set in the CK")
        Return
    EndIf
    Actor kSings = SingsAlias.GetActorRef()
    CompleteRecruitment(kSings, NHV_Status_Sings, SingsFamilySlotAlias, SingsAlias, SingsHomeMarker)
    If NHV_Q02_Result
        NHV_Q02_Result.SetValueInt(1)
    EndIf
    SetStage(100)
EndFunction

; Called from the Stage 100 debrief fragment (Recruit branch only) - deliberately kept separate from
; JudgeRecruit() because the reward is handed over "im Debrief" per
; docs/concept/Q02-Gegenstaende-und-Lore.md, not at the moment of the Judgement decision itself.
; Idempotent via NHV_Q02_Flag_RewardGiven, in case the debrief line is heard more than once.
Function GiveRecruitReward()
    If NHV_Q02_Flag_RewardGiven && NHV_Q02_Flag_RewardGiven.GetValueInt() == 1
        Return
    EndIf
    If !ShadowscaleWraps
        Return
    EndIf
    If !NHV_Q02_Result
        NHV_Util.Log(NHV_Cfg_Debug, "GiveRecruitReward: NHV_Q02_Result property not set in the CK")
        Return
    EndIf
    If NHV_Q02_Result.GetValueInt() != 1
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kPlayer
        kPlayer.AddItem(ShadowscaleWraps, 1, True)
    EndIf
    If NHV_Q02_Flag_RewardGiven
        NHV_Q02_Flag_RewardGiven.SetValueInt(1)
    EndIf
EndFunction

Function JudgeRelease()
    If GetStage() != 70
        Return
    EndIf
    If NHV_Status_Sings
        NHV_Status_Sings.SetValueInt(STATUS_RELEASED)
    EndIf
    If NHV_Q02_Result
        NHV_Q02_Result.SetValueInt(3)
    EndIf
    Actor kSings = GetSings()
    If kSings
        kSings.EvaluatePackage() ; CK-side "leave Windhelm by road" package takes over
    EndIf
    SetStage(100)
EndFunction

Function JudgeSilence()
    If GetStage() != 70
        Return
    EndIf
    ; Set STATUS_KILLED immediately, same as NHV_Q01Script.JudgeSilence(): the Brotherhood's
    ; judgement is final the moment it is spoken, regardless of whether the ensuing fight actually
    ; finishes Sings off in this session (he could flee, or the player could stop chasing). This
    ; guarantees the Global never sits at STATUS_UNKNOWN forever. RecruitDied() (triggered by his
    ; eventual OnDeath, whenever that happens) still fires the NHV_RecruitDied ModEvent - only the
    ; redundant SetValueInt is skipped there since the status already reads STATUS_KILLED.
    If NHV_Status_Sings
        NHV_Status_Sings.SetValueInt(STATUS_KILLED)
    EndIf
    If NHV_Q02_Result
        NHV_Q02_Result.SetValueInt(2)
    EndIf
    Actor kSings = GetSings()
    If kSings && !kSings.IsDead()
        kSings.StartCombat(Game.GetPlayer())
    EndIf
    SetStage(100)
EndFunction

; "An den Jarl ausliefern" - concept: 500 gold bounty, permanent NHV_Flag_VeyraDisapproval, Watch-
; Sergeant Hjorald takes Sings into custody. Uses STATUS_SPECIAL, the documented "Sonderfall
; (ausgeliefert, verhaftet)" value (docs/ARCHITECTURE.md line 95).
Function JudgeSurrender()
    If GetStage() != 70
        Return
    EndIf
    If NHV_Status_Sings
        NHV_Status_Sings.SetValueInt(STATUS_SPECIAL)
    EndIf
    If NHV_Q02_Result
        NHV_Q02_Result.SetValueInt(4)
    EndIf
    If NHV_Q02_Flag_VeyraDisapproval
        NHV_Q02_Flag_VeyraDisapproval.SetValueInt(1)
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kPlayer && Gold001
        kPlayer.AddItem(Gold001, BOUNTY_GOLD, True)
    EndIf
    Actor kHjorald = GetHjorald()
    Actor kSings = GetSings()
    If kHjorald && kSings
        kHjorald.EvaluatePackage() ; CK-side "take the prisoner" package takes over
    EndIf
    SetStage(100)
EndFunction

; ---------------------------------------------------------------------------
; [Vorschlag] Side quest A - "Torbjorn's Ledger" (not in the concept, optional, see plan section 7)
; ---------------------------------------------------------------------------

; Called from a condition-gated Torbjorn dialogue fragment. Idempotent and safe to call repeatedly.
Function CompleteSideQuestA()
    If NHV_Q02_Flag_SideA_Done && NHV_Q02_Flag_SideA_Done.GetValueInt() == 1
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer || !HarborLog01 || !HarborLog02 || !HarborLog03
        Return
    EndIf
    If kPlayer.GetItemCount(HarborLog01) > 0 && kPlayer.GetItemCount(HarborLog02) > 0 && kPlayer.GetItemCount(HarborLog03) > 0
        If NHV_Q02_Flag_SideA_Done
            NHV_Q02_Flag_SideA_Done.SetValueInt(1)
        EndIf
        If Gold001
            kPlayer.AddItem(Gold001, 50, True)
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "CompleteSideQuestA: Torbjorn's Ledger completed")
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; [Vorschlag] Side quest B - "The Assemblage's Due" (not in the concept, optional, see plan section 7)
; ---------------------------------------------------------------------------

; Called from a dialogue/activate fragment when the player gives the locket back to the optional
; AssemblageWitnessAlias (vanilla Argonian NPC, Optional Specific-Reference alias).
Function DeliverLocket()
    If NHV_Q02_Flag_SideB_Done && NHV_Q02_Flag_SideB_Done.GetValueInt() == 1
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer || !FamilyLocket
        Return
    EndIf
    If kPlayer.GetItemCount(FamilyLocket) > 0
        kPlayer.RemoveItem(FamilyLocket, 1, True, None)
        If NHV_Q02_Flag_SideB_Done
            NHV_Q02_Flag_SideB_Done.SetValueInt(1)
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "DeliverLocket: Assemblage's Due completed")
    EndIf
EndFunction
