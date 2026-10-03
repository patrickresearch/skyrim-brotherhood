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
ObjectReference Property VeyraHollowMarker Auto ; NHV_Mk_Q02_VeyraHollow, where Veyra appears for the Stage 50 scene (Drowned Hollow)
ObjectReference Property SingsHollowMarker Auto ; NHV_Mk_Q02_SingsHollow, where Sings waits from Stage 50 (Drowned Hollow)
ObjectReference Property DispatchDeskRef Auto ; NHV_Q02_DispatchDeskRef, the dispatch on Aelius' desk, Initially Disabled; None = give directly

; Dialogue-gating Globals set by this script (M2.2 additions)
GlobalVariable Property NHV_Q02_FragmentFound Auto   ; 1 once the Oculatus fragment is in the player's hands (gates the reveal lines)
GlobalVariable Property NHV_Q02_TrialAnnounced Auto  ; 1 once Veyra's Stage 50 scene has run (or was skipped): unlocks the acceptance dialogue

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

; -- Q02 Enhanced additions (Phase B, E46/E48-E56; all additive, nothing above was renamed or removed) --
ReferenceAlias Property EnforcerAlias Auto   ; alias 8: the enforcer who speaks in a scene (filled by script from the ref arrays below)
ReferenceAlias Property CourierAlias Auto    ; alias 9: the Imperial courier (filled by script from CourierRef)
ReferenceAlias Property BabetteAlias Auto    ; alias 10: Babette (unique actor), only for the homecoming scene
Book Property TidehouseLedger Auto           ; NHV_Book_Q02_TidehouseLedger (0xAF30), the item behind the "I have the log" dialogue
; CK-placed refs (tasks in docs/plan/Q02-Phase-B-Ergebnis.md): all optional, the script logs and degrades when one is missing
ObjectReference[] Property TidehouseEnforcerRefs Auto ; the dock enforcers inside the tidehouse (hostile after their talk)
ObjectReference[] Property SaltYardEnforcerRefs Auto  ; the dock enforcers in the salt yard
ObjectReference Property SaltYardMarker Auto          ; where Drinks-the-Brine waits at stage 45
ObjectReference Property CourierRef Auto              ; the placed, initially disabled Imperial courier near Aelius' desk

; BEGIN FLOW CONSTANTS (generated by tools/build_q02_enhanced.py - do not edit)
Int Property FLOW_CURSOR_MAIN = 40965 AutoReadOnly
Int Property FLOW_HUB_TABLE = 38 AutoReadOnly
Int Property FLOW_CURSOR_HOME = 40964 AutoReadOnly
Int Property FLOW_ENTRY_HOME = 1001 AutoReadOnly
Int Property FLOW_CURSOR_SINGS = 40967 AutoReadOnly
Int Property FLOW_HUB_OBS = 26 AutoReadOnly
Int Property FLOW_HUB_DESK = 28 AutoReadOnly
Int Property FLOW_AELIUS_OBSERVED = 40970 AutoReadOnly
Int Property FLOW_SCENE_OBS = 41235 AutoReadOnly
Int Property FLOW_SCENE_COURIER = 41228 AutoReadOnly
Int Property FLOW_SCENE_LIST = 41120 AutoReadOnly
Int Property FLOW_SCENE_DESK_S = 41248 AutoReadOnly
Int Property FLOW_SCENE_DESK_P = 41251 AutoReadOnly
Int Property FLOW_SCENE_DESK_O = 41254 AutoReadOnly
Int Property FLOW_COURIER_DONE = 40971 AutoReadOnly
; END FLOW CONSTANTS

; Placed refs of the Q02 NPCs (plugin-text, checked 01.10.2026): the getters fall back to them when an alias did not fill
; (optional aliases stay empty while their ref is not loaded, Q01 lesson 6).
Int Property REF_SINGS = 0x005190 AutoReadOnly
Int Property REF_TORBJORN = 0x005191 AutoReadOnly
Int Property REF_DRINKS = 0x005192 AutoReadOnly
Int Property REF_HJORALD = 0x005194 AutoReadOnly
Int Property REF_HALDOR = 0x005195 AutoReadOnly
Int Property REF_AELIUS = 0x005953 AutoReadOnly

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
Int Property WATCH_KILL = 3 AutoReadOnly
Int Property WATCH_DOCKS = 4 AutoReadOnly
Int Property WATCH_TICK_CAP = 200 AutoReadOnly
Int iWatchTicks = 0
Bool bSurrenderFinished = False
Int iWatchMode = 0
Bool bSurrenderPending = False  ; custody (FinishSurrender) follows after iSurrenderTicks timer ticks even if Hjorald's scene never ran
Int iSurrenderTicks = 0

; Enhanced additions: plain variables, additive. All of them re-arm after a load through RearmWatches() (one timer, one dispatcher).
Bool bObsWatch = False          ; stage 55: waiting for the player to stand in front of Aelius with Sings
Bool bObsDone = False           ; the observation scene was started (or skipped) once
Bool bObsRequested = False      ; BeginAeliusObservation() ran (stage 55): only then the watch is re-armed after a load
Int iObsTicks = 0
Bool bDeskWatch = False         ; stage 70: waiting for the player to reach Sings at the desk
Bool bDeskScenePlayed = False
Bool bCourierStarted = False    ; the courier encounter was started once
Bool bCourierDisable = False    ; the courier flees and is disabled after iCourierTicks timer ticks
Int iCourierTicks = 0
Bool bReleasePending = False    ; the released Sings walks off and is disabled after iReleaseTicks timer ticks
Int iReleaseTicks = 0
Bool bHideSings = False         ; stage 45: Sings (who fled) is moved to the Hollow out of sight on a later tick
Bool bBribePaid = False         ; the 25 gold of the bribe line are taken once
Bool bLedgerGiven = False       ; the rescue hand-over of the tidehouse ledger happened once
Int iPendingScene = 0           ; a scene waiting for its delay (DelayScene)
Bool bDebriefWatch = False      ; stage 100 until the debrief ended: Veyra comes to the player inside the sanctuary
Bool bTableOpened = False
Bool bTableCursorPending = False ; the debrief chain resets the cursor right after OpenMapTable(): the hub is armed a moment later
Bool bTableMenuPending = False   ; the map table menu is a modal message: shown after the dialogue closed

; Death fallbacks (developer feedback 03.10.2026, docs/plan/Q02-Todes-Fallbacks.md): plain variables, additive, re-armed after a load.
Bool bDeathWatch = False        ; stages 10-99: slow poll that settles the death of a conversation partner (DeathTick)
Bool bTideTalked = False        ; the tidehouse enforcers had their talk (TidehouseHostile ran): their fallback note is not needed
Bool bSaltTalked = False        ; the salt yard talk with the enforcers happened (SaltYardHostile/SaltYardSlip ran)
Bool bEnforcerNoteGiven = False ; the enforcer fallback note was put on one corpse
Bool bDrinksNoted = False       ; the hint about Drinks' death was shown once
Int iDeathHighStage = 0         ; highest stage the death watch has seen: stage 10 again after a higher one means a quest reset
Float Property DEATH_POLL_INTERVAL = 8.0 AutoReadOnly
Int Property NOTE_ENFORCER = 0x00AF75 AutoReadOnly ; NHV_Note_Fallback_DockEnforcer (script-delivered: the enforcer is a cloned, non-unique base)
Int Property NOTE_LEDGER = 0x00AF30 AutoReadOnly   ; NHV_Book_Q02_TidehouseLedger (FormID fallback of the TidehouseLedger property)

; ---------------------------------------------------------------------------
; Small None-safe getters for the alias actors used across several functions below. Each one logs
; once (Debug-gated) instead of letting a poll chain call a method on a None alias property silently
; every tick if the CK left it unset.
; ---------------------------------------------------------------------------

; The actor of an alias, or (alias still empty, e.g. its placed ref was not loaded when the quest started) the placed ref
; itself by FormID, which then fills the alias again when abRefill is set. None only when the ref does not exist at all
; (Q01 lesson 6: "GetScout" pattern; a fallback never skips a stage silently, the caller decides).
Actor Function ResolveActor(ReferenceAlias akAlias, Int aiRefID, Bool abRefill)
    Actor kActor = None
    If akAlias
        kActor = akAlias.GetActorRef()
    EndIf
    If !kActor && aiRefID != 0
        kActor = Game.GetFormFromFile(aiRefID, "NightsHarvest.esp") as Actor
        If kActor && abRefill && akAlias
            akAlias.ForceRefTo(kActor)
            NHV_Util.Log(NHV_Cfg_Debug, "ResolveActor: an empty alias was filled from the placed ref")
        EndIf
    EndIf
    Return kActor
EndFunction

; Sings: the alias is cleared by CompleteRecruitment() at the end of stage 70 (so his recruit-alias script stops watching
; him), therefore it is only refilled while the quest is below 100.
Actor Function GetSings()
    If !SingsAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetSings: SingsAlias property not set in the CK")
    EndIf
    Actor kSings = ResolveActor(SingsAlias, REF_SINGS, GetStage() < 100)
    ; Sings' placed ref is Initially Disabled in the CK (hidden before the night scene): he appears with the Stage-30 night
    ; window or later, never at/after Stage 100 (JudgeRelease and FinishSurrender disable him on purpose). Idempotent.
    If kSings && kSings.IsDisabled() && !kSings.IsDead() && SingsMayAppear()
        NHV_Util.Log(NHV_Cfg_Debug, "GetSings: enabling Sings (stage " + GetStage() + ")")
        kSings.Enable()
    EndIf
    Return kSings
EndFunction

Bool Function SingsMayAppear()
    Int iStage = GetStage()
    Return (iStage >= 40 && iStage < 100) || (iStage == 30 && IsNightWindow())
EndFunction

Actor Function GetHaldor()
    If !HaldorAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetHaldor: HaldorAlias property not set in the CK")
    EndIf
    Return ResolveActor(HaldorAlias, REF_HALDOR, True)
EndFunction

Actor Function GetAelius()
    If !AeliusAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetAelius: AeliusAlias property not set in the CK")
    EndIf
    Return ResolveActor(AeliusAlias, REF_AELIUS, True)
EndFunction

Actor Function GetHjorald()
    If !HjoraldAlias
        NHV_Util.Log(NHV_Cfg_Debug, "GetHjorald: HjoraldAlias property not set in the CK")
    EndIf
    Return ResolveActor(HjoraldAlias, REF_HJORALD, True)
EndFunction

Actor Function GetTorbjorn()
    Return ResolveActor(TorbjornAlias, REF_TORBJORN, True)
EndFunction

Actor Function GetDrinks()
    Return ResolveActor(DrinksAlias, REF_DRINKS, True)
EndFunction

; The courier is a CK-placed, initially disabled ref (CourierRef); the alias is filled from it when the encounter starts.
Actor Function GetCourier()
    Actor kCourier = None
    If CourierAlias
        kCourier = CourierAlias.GetActorRef()
    EndIf
    If !kCourier && CourierRef
        kCourier = CourierRef as Actor
        If kCourier && CourierAlias
            CourierAlias.ForceRefTo(kCourier)
        EndIf
    EndIf
    Return kCourier
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
    EnsureHaldorEnabled()
    iWatchMode = WATCH_NIGHT
    RegisterForSingleUpdate(5.0)
EndFunction

; Haldor is hidden at stage 45-99 (HideHaldor); after a quest reset he would stay disabled: the night scene needs him visible.
Function EnsureHaldorEnabled()
    Actor kHaldor = GetHaldor()
    If kHaldor && kHaldor.IsDisabled() && !kHaldor.IsDead()
        kHaldor.Enable()
    EndIf
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
;
; Enhanced additions (Q01 lesson 9: one script, one timer): RunPendingWork() handles the one-shot jobs and the new watches
; of the Enhanced arc first, the old iWatchMode dispatch runs unchanged afterwards, and RearmWatches() books the next tick
; whenever one of the new jobs is still waiting.
Event OnUpdate()
    RunPendingWork()
    If iWatchMode == WATCH_NIGHT
        UpdateNightWatch()
    ElseIf iWatchMode == WATCH_TAIL
        UpdateTailWatch()
    ElseIf iWatchMode == WATCH_KILL
        UpdateKillWatch()
    ElseIf iWatchMode == WATCH_DOCKS
        UpdateDocksWatch()
    Else
        Parent.OnUpdate()
    EndIf
    RearmWatches()
EndEvent

Function RearmWatches()
    If bObsWatch || bDeskWatch || bTableCursorPending || bTableMenuPending || iPendingScene != 0 || bHideSings || bReleasePending || bCourierDisable || bSurrenderPending
        RegisterForSingleUpdate(2.5)
    ElseIf bDebriefWatch
        If IsCutsceneLocked()
            RegisterForSingleUpdate(2.0) ; keep the base watchdog cadence while a scene holds the controls
        Else
            RegisterForSingleUpdate(10.0) ; the player may be anywhere in Skyrim: a slow poll is enough
        EndIf
    ElseIf bDeathWatch && iWatchMode == WATCH_NONE && !IsCutsceneLocked()
        ; death poll only when no older watch owns the timer (those re-register themselves and run RunPendingWork on every tick)
        RegisterForSingleUpdate(DEATH_POLL_INTERVAL)
    EndIf
EndFunction

Function RunPendingWork()
    If bSurrenderPending
        iSurrenderTicks -= 1
        If iSurrenderTicks <= 0
            bSurrenderPending = False
            FinishSurrender()
        EndIf
    EndIf
    If bTableCursorPending
        bTableCursorPending = False
        NHV_Util.FlowSet(FLOW_CURSOR_MAIN, FLOW_HUB_TABLE) ; after the debrief chain reset the cursor to 0 (Q01 lesson 4)
        NHV_Util.Log(NHV_Cfg_Debug, "OpenMapTable: the table hub is armed")
    EndIf
    If bTableMenuPending
        bTableMenuPending = False
        ShowTableMenu()
    EndIf
    If iPendingScene != 0
        Int iSid = iPendingScene
        iPendingScene = 0
        NHV_Util.FlowScene(iSid)
    EndIf
    If bHideSings
        bHideSings = False
        MoveSingsToHollow()
    EndIf
    If bReleasePending
        iReleaseTicks -= 1
        If iReleaseTicks <= 0
            bReleasePending = False
            Actor kReleased = GetSings()
            If kReleased && !kReleased.IsDead()
                kReleased.Disable(True) ; he left Windhelm by road (no CK package needed)
            EndIf
        EndIf
    EndIf
    If bCourierDisable
        iCourierTicks -= 1
        If iCourierTicks <= 0
            bCourierDisable = False
            Actor kCourier = GetCourier()
            If kCourier && !kCourier.IsDead()
                kCourier.StopCombat()
                kCourier.Disable(True)
            EndIf
        EndIf
    EndIf
    If bDebriefWatch
        DebriefTick()
    EndIf
    If bObsWatch
        ObsTick()
    EndIf
    If bDeskWatch
        DeskTick()
    EndIf
    If bDeathWatch
        DeathTick()
    EndIf
EndFunction

; Re-arms every timer based job after a load (timers do not survive a save). Also called by OnContractLoadGame().
Function RearmAfterLoad()
    Int iStage = GetStage()
    If iWatchMode != WATCH_NONE
        RegisterForSingleUpdate(3.0)
    EndIf
    If iStage == 55 && bObsRequested && !bObsDone
        bObsWatch = True
    EndIf
    If iStage == 70 && !bDeskScenePlayed
        bDeskWatch = True
    EndIf
    If iStage >= 100 && !bTableOpened
        bDebriefWatch = True
    EndIf
    If iStage >= 10 && iStage < 100
        PatchStageActivators()
    EndIf
    If iStage >= 45 && iStage < 100
        HideHaldor()
    ElseIf iStage >= 100
        ShowHaldor()
    EndIf
    If iStage >= 30 && iStage < 100
        GetSings() ; enables the Initially Disabled Sings after a reload once his time has come (SingsMayAppear)
    EndIf
    RearmWatches()
EndFunction

Function OnContractLoadGame()
    RearmAfterLoad()
EndFunction

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
    GetSings() ; night window reached: enables the Initially Disabled Sings before the player walks into the radius (no pop-in)
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
    If kSings.IsDead() && HandleSingsDead()
        Return ; the candidate is dead: the outcome is settled (killed), no scene
    EndIf
    If kHaldor.IsDead()
        ; Death fallback: Haldor died before the night scene (the player killed him). No scene without him: go on exactly like the
        ; "nobody intervened" path (stage 40, Sings is followed to the Hollow); his fallback note lies on the corpse.
        NHV_Util.Log(NHV_Cfg_Debug, "StartHaldorDocksScene: Haldor is already dead, skipping the night scene (stage 40)")
        iWatchMode = WATCH_NONE
        EndHaldorDocksScene()
        Return
    EndIf
    EnsureHaldorEnabled()
    If !HaldorDocksScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartHaldorDocksScene: HaldorDocksScene property not set in the CK")
        Return
    EndIf
    HaldorDocksScene.Start()
    ; The scene is not cutscene-locked, so the base watchdog does not cover it: this watch moves on to
    ; Stage 40 if the scene ends without its end fragment firing (or never really runs).
    iWatchMode = WATCH_DOCKS
    iWatchTicks = 0
    RegisterForSingleUpdate(3.0)
EndFunction

Function UpdateDocksWatch()
    If GetStage() != 30
        iWatchMode = WATCH_NONE
        Return
    EndIf
    iWatchTicks += 1
    If (HaldorDocksScene && HaldorDocksScene.IsPlaying() && iWatchTicks < WATCH_TICK_CAP)
        RegisterForSingleUpdate(3.0)
        Return
    EndIf
    If iWatchTicks <= 3 && HaldorDocksScene
        RegisterForSingleUpdate(3.0) ; start-up grace: IsPlaying() may not have flipped yet
        Return
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "UpdateDocksWatch: scene over without end fragment, moving on")
    iWatchMode = WATCH_NONE
    If HaldorDocksScene && HaldorDocksScene.IsPlaying()
        HaldorDocksScene.Stop()
    EndIf
    EndHaldorDocksScene()
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
    ; The scene is NOT stopped: it plays on to its end, where Haldor's "Something pulled me under!" line
    ; (NHV_Q02_030_10, NHV_Q02_HaldorSaved == 1) replaces the drowning line, and EndHaldorDocksScene()
    ; then routes to the tracking path.
EndFunction

; Called from HaldorDocksScene's end fragment (scene ran to completion, no intervention). No
; UnlockCutscene() call here: the scene was never locked in the first place (see
; StartHaldorDocksScene()'s comment).
Function EndHaldorDocksScene()
    If GetStage() >= 40
        Return ; already handled: UpdateDocksWatch() and the end fragment can both land here
    EndIf
    If HaldorSaved()
        ; E49 (Enhanced): the saved path goes straight to stage 45, the salt yard and the sluice, which replaces the old
        ; tracking fallback (stage 40 is skipped on this path; the Hollow door accepts stages 40 and 45).
        NHV_Util.Log(NHV_Cfg_Debug, "EndHaldorDocksScene: Haldor was saved, salt yard (stage 45)")
        SetStage(45)
    Else
        SetStage(40)
        KillHaldorInWater()
        BeginTailWatch() ; Pfad A: stealth-follow Sings to the Drowned Hollow
    EndIf
EndFunction

; Pfad A: nobody intervened, so Sings drowns Haldor. He dies where the scene left him, at the water's
; edge by NHV_Mk_Q02_DockWatch, and stays there as a findable corpse (DECISIONS E39). Sings is passed
; as the killer so the death reads as Sings' kill; no bounty reaches the player.
Function KillHaldorInWater()
    Actor kHaldor = GetHaldor()
    If !kHaldor
        NHV_Util.Log(NHV_Cfg_Debug, "KillHaldorInWater: Haldor alias empty, nothing to kill")
        Return
    EndIf
    If kHaldor.IsDead()
        Return
    EndIf
    Actor kSings = GetSings()
    If kSings && !kSings.IsDead()
        kHaldor.Kill(kSings)
    Else
        kHaldor.Kill()
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "KillHaldorInWater: Haldor drowned (Pfad A), corpse stays at the docks")
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

; RETIRED by E51 (Enhanced): Veyra stays in the Dawnstar Sanctuary and never goes to the Hollow; nothing calls this any more.
; Kept (together with scene 004126 and its topics) so no property, record or save reference breaks.
; Called from the Stage 50 dialogue fragment once Sings has finished explaining himself.
Function StartVeyraHollowScene()
    If GetStage() != 50 || (VeyraHollowScene && VeyraHollowScene.IsPlaying())
        Return
    EndIf
    FillVeyraAlias() ; NHV_ContractBaseScript: ForceRefTo from NHV_CoreScript.GetVeyraActor()
    If !VeyraAlias || !VeyraAlias.GetActorRef()
        ; Optional alias unfilled (E16-style soft dependency broke, or Veyra is otherwise
        ; unavailable) - fall back to a plain dialogue-driven trial announcement without the
        ; appearance scene, same escape hatch as NHV_Q01Script.StartVeyraTrial(). The CK wires a
        ; fallback topic for this case (docs/ck/M1.7-Q02-CK-Anleitung.md).
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: Veyra unavailable, skipping scene")
        SetTrialAnnounced()
        Return
    EndIf
    If !VeyraHollowScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: VeyraHollowScene property not set in the CK")
        SetTrialAnnounced()
        Return
    EndIf
    Actor kVeyra = VeyraAlias.GetActorRef()
    If kVeyra.IsDead() || kVeyra.IsDisabled()
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: Veyra dead or disabled, skipping scene")
        SetTrialAnnounced()
        Return
    EndIf
    If VeyraHollowMarker
        kVeyra.MoveTo(VeyraHollowMarker) ; Veyra appears in the Hollow (no travel across Skyrim)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "StartVeyraHollowScene: VeyraHollowMarker property not set in the CK")
    EndIf
    LockCutscene(VeyraHollowScene)
    VeyraHollowScene.Start()
EndFunction

; Stage 60 is NOT set here: after the scene the player still talks to Sings (NHV_Q02_050_70..95), and
; the last of those answers sets Stage 60. TrialAnnounced unlocks those topics.
Function EndVeyraHollowScene()
    UnlockCutscene()
    SetTrialAnnounced()
    ; Veyra "leaves for Dawnstar" in the last line: put her back in the Sanctuary (same Core helper Q00 uses
    ; for her return; no Core change).
    If Core
        Core.CompleteVeyraReturnToSanctuary()
    EndIf
EndFunction

Function SetTrialAnnounced()
    If NHV_Q02_TrialAnnounced
        NHV_Q02_TrialAnnounced.SetValueInt(1)
    EndIf
EndFunction

; Stage 50 fragment: Sings waits in the Drowned Hollow (moved out of sight when the player heads for the Hollow).
Function MoveSingsToHollow()
    Actor kSings = GetSings()
    If kSings && SingsHollowMarker
        kSings.MoveTo(SingsHollowMarker)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "MoveSingsToHollow: Sings or SingsHollowMarker missing")
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Stage 60: the Trial - Sings kills Aelius
; ---------------------------------------------------------------------------

; Checked by the Stage 60 entry fragment before offering the scene topic, so an unscripted death of
; Aelius (random encounter, player kills him early) cannot softlock the quest.
Bool Function IsAeliusAvailable()
    Actor kAelius = GetAelius()
    Return kAelius && !kAelius.IsDead() && !kAelius.IsDisabled()
EndFunction

; Stage 60 fragment: polls until the player is in loaded range of Aelius, then puts Sings next to him and
; starts the kill scene (the scene needs both actors in one place). Stops itself when the stage moves on.
Function BeginKillWatch()
    iWatchMode = WATCH_KILL
    iWatchTicks = 0
    RegisterForSingleUpdate(3.0)
EndFunction

Function UpdateKillWatch()
    If GetStage() != 60
        iWatchMode = WATCH_NONE
        Return
    EndIf
    Actor kAelius = GetAelius()
    Actor kSings = GetSings()
    iWatchTicks += 1
    ; Enhanced (E53): waiting is allowed, the trial is only postponed while the player stays away. The old tick cap forced
    ; the "Aelius already dead" fallback after ~10 minutes; it now only slows the poll down.
    If HandleSingsDead()
        Return
    EndIf
    If !kAelius || kAelius.IsDead() || kAelius.IsDisabled() || !kSings
        NHV_Util.Log(NHV_Cfg_Debug, "UpdateKillWatch: Aelius or Sings unavailable, using the fallback")
        iWatchMode = WATCH_NONE
        StartAeliusKillScene() ; fallback: unavailable -> Stage 70
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kPlayer && kAelius.Is3DLoaded() && kPlayer.GetDistance(kAelius) <= 1000.0
        kSings.MoveTo(kAelius, 120.0, 0.0, 0.0)
        iWatchMode = WATCH_NONE
        StartAeliusKillScene()
    ElseIf iWatchTicks < WATCH_TICK_CAP
        RegisterForSingleUpdate(3.0)
    Else
        RegisterForSingleUpdate(10.0)
    EndIf
EndFunction

; Scene 03 end fragment: the killing blow is Sings' (concept: the trial is his deed).
; Returns True if the player was the killer (Aelius already dead by the player's hand) so the caller can
; pass abPlayerKilled to EndAeliusKillScene().
Bool Function KillAelius()
    Actor kAelius = GetAelius()
    If !kAelius
        Return False
    EndIf
    If kAelius.IsDead()
        Return kAelius.GetKiller() == Game.GetPlayer()
    EndIf
    kAelius.Kill(GetSings())
    Return False
EndFunction

; Sings died before the judgment (stage 50-70, any cause): the outcome is "killed" (Result 2) and the quest goes on to the
; debrief, so a dead candidate can never leave the quest hanging. Returns True when it handled the case.
Bool Function HandleSingsDead()
    If GetStage() >= 100
        Return False
    EndIf
    Actor kSings = GetSings()
    If !kSings || !kSings.IsDead()
        Return False
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "HandleSingsDead: Sings is dead before the judgment, settling the outcome as killed")
    ; a settled outcome (judgment chain already ran, stage 70 before SetStage(100)) is never overwritten by KILLED
    Bool bSettled = False
    If NHV_Status_Sings
        Int iSt = NHV_Status_Sings.GetValueInt()
        bSettled = (iSt == STATUS_RECRUITED || iSt == STATUS_RELEASED || iSt == STATUS_SPECIAL)
        If !bSettled && iSt != STATUS_KILLED
            NHV_Status_Sings.SetValueInt(STATUS_KILLED)
        EndIf
    EndIf
    If NHV_Q02_Result && !bSettled
        NHV_Q02_Result.SetValueInt(2)
    EndIf
    If HaldorDocksScene && HaldorDocksScene.IsPlaying()
        HaldorDocksScene.Stop() ; Sings died in the middle of the night scene: it must not play on
    EndIf
    iWatchMode = WATCH_NONE
    bObsWatch = False
    bDeskWatch = False
    RecoverActiveCutscene() ; stops a locked scene (e.g. the kill scene) and releases the controls; harmless when nothing runs
    SetStage(100)
    Return True
EndFunction

Function StartAeliusKillScene()
    If !IsAeliusAvailable()
        Actor kGone = GetAelius()
        If kGone && kGone.IsDead() && kGone.GetKiller() == Game.GetPlayer()
            ; the player killed him before the trial: that is the "player" ending of the draft, not "somebody else"
            If NHV_Q02_Flag_SingsUnproven
                NHV_Q02_Flag_SingsUnproven.SetValueInt(1)
            EndIf
        ElseIf NHV_Q02_Flag_AeliusFallback
            NHV_Q02_Flag_AeliusFallback.SetValueInt(1)
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "StartAeliusKillScene: Aelius unavailable, using fallback dialogue instead of the scene")
        If GetStage() < 70
            SetStage(70)
        EndIf
        Return
    EndIf
    If !AeliusKillScene
        NHV_Util.Log(NHV_Cfg_Debug, "StartAeliusKillScene: AeliusKillScene property not set in the CK, using the fallback")
        If NHV_Q02_Flag_AeliusFallback
            NHV_Q02_Flag_AeliusFallback.SetValueInt(1)
        EndIf
        If GetStage() < 70
            SetStage(70)
        EndIf
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
    If DispatchDeskRef
        ; Hidden find (30.09.2026): the dispatch lies on Aelius' desk, disabled until he is dead. The
        ; player has to find it; NHV_Q02_DispatchRefScript reports the read/pickup via OnDispatchFound().
        DispatchDeskRef.Enable()
        NHV_Util.Log(NHV_Cfg_Debug, "GiveOculatusFragment: dispatch enabled on Aelius' desk")
        Return
    EndIf
    GiveFragmentIfMissing(None, OculatusFragment2) ; fallback without the desk reference: hand it over directly
    OnDispatchFound()
EndFunction

; Idempotent. Called when the player reads or takes the dispatch (NHV_Q02_DispatchRefScript) or by the
; direct-give fallback above.
Function OnDispatchFound()
    If NHV_Q02_FragmentFound && NHV_Q02_FragmentFound.GetValueInt() == 0
        NHV_Q02_FragmentFound.SetValueInt(1) ; gates the list talk and the debrief branch (flow state "listRead")
        NHV_Util.Log(NHV_Cfg_Debug, "OnDispatchFound: Oculatus dispatch found")
    EndIf
    If GetStage() == 70
        OnDeskOpened() ; E54: the courier only appears once the desk is open
    EndIf
EndFunction

; E55 / Q2-15: Fragment 2 is ONE item (NHV_Note_Dispatch02). Whoever left the desk closed (or read the dispatch in place)
; gets it once at the debrief. Idempotent through GiveFragmentIfMissing().
Function GiveFragmentDebrief()
    GiveFragmentIfMissing(None, OculatusFragment2)
    OnDispatchFound()
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
    If !kSings
        kSings = GetSings() ; alias empty: the placed ref (CompleteRecruitment() clears the alias itself afterwards)
    EndIf
    If !kSings
        NHV_Util.Log(NHV_Cfg_Debug, "JudgeRecruit: Sings not found (alias and placed ref empty), the judgment stays open")
        Return
    EndIf
    CompleteRecruitment(kSings, NHV_Status_Sings, SingsFamilySlotAlias, SingsAlias, SingsHomeMarker)
    If NHV_Q02_Result
        NHV_Q02_Result.SetValueInt(1)
    EndIf
    ; Sings greets the player once in the Drowned Pool (Hello, optional): arm his "home" entry (lane Home)
    NHV_Util.FlowSet(FLOW_CURSOR_HOME, FLOW_ENTRY_HOME)
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
    ; Q2-23: no CK package is needed any more: he walks off and is disabled on a later tick (RunPendingWork)
    bReleasePending = True
    iReleaseTicks = 4 ; ~10 seconds at the 2.5 s tick of RearmWatches()
    RegisterForSingleUpdate(2.5)
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
    If kHjorald && kPlayer && !kHjorald.IsDead() && !kHjorald.IsDisabled()
        kHjorald.MoveTo(kPlayer, 250.0, 0.0, 0.0) ; Hjorald arrives; his line (NHV_Q02_070_4034) is a delayed scene started by the chain
        kHjorald.EvaluatePackage()
        bSurrenderPending = True
        iSurrenderTicks = 8 ; ~20 seconds: scene delay plus his lines, then the custody happens anyway
        RegisterForSingleUpdate(2.5)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "JudgeSurrender: Hjorald unavailable, taking Sings into custody directly")
        FinishSurrender()
    EndIf
    SetStage(100)
EndFunction

; Called after Hjorald's lines: Sings is taken into custody.
Function FinishSurrender()
    If bSurrenderFinished || !NHV_Q02_Result || NHV_Q02_Result.GetValueInt() != 4
        Return
    EndIf
    bSurrenderFinished = True
    Actor kSings = GetSings()
    If kSings && !kSings.IsDisabled()
        kSings.Disable(True)
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Q02 Enhanced (Phase B, E46/E48-E56): tidehouse (15), salt yard (45), observation (55), desk and courier (70), debrief (100)
; ---------------------------------------------------------------------------

Int Property OBS_TICK_CAP = 600 AutoReadOnly ; ~25 minutes of waiting for the observation, then it is skipped (no softlock)

; Stage 15 fragment: the room is guarded by dock enforcers (CK-placed). They talk first (Hello), then turn hostile.
; The CK refs still carry the V1 values of NHV_Q02_StageActivatorScript: the body (RequiredStage 10 / TargetStage 20) would jump
; over the tidehouse at stage 10 and the Hollow door (RequiredStage 40) would not take the salt-yard path (stage 45). Properties of
; an Auto script are writable, so the quest sets the Enhanced values at runtime (idempotent, saved with the refs). The CK tasks A1/A2
; in docs/plan/Q02-Phase-B-Ergebnis.md make the same change permanent in the plugin.
Function PatchStageActivators()
    NHV_Q02_StageActivatorScript kCorpse = Game.GetFormFromFile(0x005959, "NightsHarvest.esp") as NHV_Q02_StageActivatorScript
    If kCorpse
        kCorpse.RequiredStage = 20
        kCorpse.TargetStage = 0
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "PatchStageActivators: corpse ref 0x005959 or its script not found")
    EndIf
    NHV_Q02_StageActivatorScript kDoor = Game.GetFormFromFile(0x0057D4, "NightsHarvest.esp") as NHV_Q02_StageActivatorScript
    If kDoor
        kDoor.RequiredStageMax = 45
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "PatchStageActivators: Hollow door ref 0x0057D4 or its script not found")
    EndIf
    ArmDeathWatch() ; called by the fragments of stage 10/15/20/30/45 and by RearmAfterLoad(): the one hook every stage and every load passes
EndFunction

Function BeginTidehouse()
    FillEnforcerAlias(TidehouseEnforcerRefs)
    If !TidehouseEnforcerRefs || TidehouseEnforcerRefs.Length == 0
        NHV_Util.Log(NHV_Cfg_Debug, "BeginTidehouse: TidehouseEnforcerRefs not set in the CK (nobody guards the log)")
    EndIf
EndFunction

Function OnTidehouseBriefed()
    FillEnforcerAlias(TidehouseEnforcerRefs)
    ; Lesson 11 (rescue path in the script, no console): as long as the CK has not set up the tidehouse (no enforcer refs), Hjorald's
    ; key talk hands over the ledger itself, so stage 15 cannot block.
    If !bLedgerGiven && (!TidehouseEnforcerRefs || TidehouseEnforcerRefs.Length == 0) && TidehouseLedger
        Actor kPlayer = Game.GetPlayer()
        If kPlayer && kPlayer.GetItemCount(TidehouseLedger) == 0
            bLedgerGiven = True
            kPlayer.AddItem(TidehouseLedger, 1, False)
            NHV_Util.Log(NHV_Cfg_Debug, "OnTidehouseBriefed: TidehouseEnforcerRefs not set in the CK, the ledger was handed over directly")
        EndIf
    EndIf
EndFunction

; The first living enforcer of the list becomes the scene alias (scene runs need a filled alias).
Function FillEnforcerAlias(ObjectReference[] akRefs)
    If !EnforcerAlias
        Return
    EndIf
    Actor kPick = None
    Int i = 0
    While akRefs && i < akRefs.Length && !kPick
        Actor kEnforcer = akRefs[i] as Actor
        If kEnforcer && !kEnforcer.IsDead()
            kPick = kEnforcer
        EndIf
        i += 1
    EndWhile
    If kPick
        If EnforcerAlias.GetActorRef() != kPick
            EnforcerAlias.ForceRefTo(kPick)
        EndIf
    Else
        EnforcerAlias.Clear() ; never keep a stale (e.g. dead tidehouse) enforcer when the list has nobody alive
    EndIf
EndFunction

; E54: every enforcer of the list fights the player. NHV_Fac_DockEnforcer has no crime group, so there is no bounty.
Function EnforcersHostile(ObjectReference[] akRefs)
    Actor kPlayer = Game.GetPlayer()
    Int i = 0
    While akRefs && i < akRefs.Length
        Actor kEnforcer = akRefs[i] as Actor
        If kEnforcer && !kEnforcer.IsDead() && !kEnforcer.IsDisabled()
            kEnforcer.StartCombat(kPlayer)
        EndIf
        i += 1
    EndWhile
    NHV_Util.Log(NHV_Cfg_Debug, "EnforcersHostile: the enforcers attack")
EndFunction

Function TidehouseHostile()
    bTideTalked = True
    EnforcersHostile(TidehouseEnforcerRefs)
EndFunction

; Stage 45+: the rescued Haldor is hidden (his associates look for him, E-Packages 02.10.2026). Plain Disable, no ghost flag,
; no package needed. Idempotent; a dead Haldor stays where he is (his corpse is findable, E39).
Function HideHaldor()
    If !HaldorSaved()
        Return
    EndIf
    Actor kHaldor = GetHaldor()
    If kHaldor && !kHaldor.IsDead() && !kHaldor.IsDisabled()
        NHV_Util.Log(NHV_Cfg_Debug, "HideHaldor: Haldor leaves the docks (disabled)")
        kHaldor.Disable(False) ; not latent: Disable(True) would stall RearmAfterLoad / RunPendingWork / RearmWatches until the fade ended
    EndIf
EndFunction

; Stage 100 (and after a load at stage >= 100): the living Haldor returns to the docks (his own package takes over, S >= 100).
; Enable only if he is disabled and not dead, so a repeated call never double-enables.
Function ShowHaldor()
    If !HaldorSaved()
        Return
    EndIf
    Actor kHaldor = GetHaldor()
    If kHaldor && !kHaldor.IsDead() && kHaldor.IsDisabled()
        NHV_Util.Log(NHV_Cfg_Debug, "ShowHaldor: Haldor returns to the docks (enabled)")
        kHaldor.Enable()
    EndIf
EndFunction

; Stage 45 fragment (only the "Haldor was saved" path): Drinks-the-Brine waits at the salt yard, the enforcers search it,
; Sings (who fled) is moved to the Hollow out of sight a few seconds later.
Function BeginSaltYard()
    bHideSings = True
    RegisterForSingleUpdate(6.0)
    Actor kDrinks = GetDrinks()
    If kDrinks && !kDrinks.IsDead() && SaltYardMarker
        If kDrinks.IsDisabled()
            kDrinks.Enable()
        EndIf
        kDrinks.MoveTo(SaltYardMarker)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "BeginSaltYard: Drinks or SaltYardMarker missing, the salt yard talk starts wherever Drinks stands")
    EndIf
    FillEnforcerAlias(SaltYardEnforcerRefs)
    HideHaldor() ; last: Disable(True) waits for the fade
EndFunction

Function SaltYardHostile()
    bSaltTalked = True
    EnforcersHostile(SaltYardEnforcerRefs)
EndFunction

Function SaltYardSlip()
    bSaltTalked = True
    NHV_Util.Log(NHV_Cfg_Debug, "SaltYardSlip: the player takes the sluice route, the enforcers stay unaware")
EndFunction

; Q2-14: the bribe line costs real gold (the dialogue condition checks >= 25), paid once.
Function PayBribe()
    If bBribePaid || !Gold001
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kPlayer && kPlayer.GetItemCount(Gold001) >= 25
        kPlayer.RemoveItem(Gold001, 25, True, GetDrinks())
        bBribePaid = True
    EndIf
EndFunction

; Stage 55 fragment: Sings follows the player (NHV_Pkg_Q02_SingsFollow, stage 55-59; Q01 lesson 8: only from the stage that
; the conversation sets).
Function OnStage55()
    Actor kSings = GetSings()
    If kSings && !kSings.IsDead()
        kSings.EvaluatePackage()
    EndIf
EndFunction

; Chain end of "show me how Aelius treats the people he serves": wait until the player stands in front of Aelius, then play the
; observation scene (Aelius, Sings). If Aelius or Sings are gone, or the wait is very long, the observation is skipped.
Function BeginAeliusObservation()
    If bObsWatch || bObsDone
        Return
    EndIf
    bObsRequested = True
    bObsWatch = True
    iObsTicks = 0
    RegisterForSingleUpdate(3.0)
    OnStage55()
EndFunction

Function ObsTick()
    If GetStage() != 55 || bObsDone
        bObsWatch = False
        Return
    EndIf
    iObsTicks += 1
    If HandleSingsDead()
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    Actor kAelius = GetAelius()
    Actor kSings = GetSings()
    If !kSings || !kAelius || kAelius.IsDead() || iObsTicks > OBS_TICK_CAP
        FinishObservationWithoutScene()
        Return
    EndIf
    If IsCutsceneLocked() || !kAelius.Is3DLoaded() || kPlayer.GetDistance(kAelius) > 600.0
        Return
    EndIf
    If !kSings.Is3DLoaded() || kSings.GetDistance(kPlayer) > 900.0
        kSings.MoveTo(kPlayer, 150.0, -150.0, 0.0) ; he fell behind: he steps up next to the player
    EndIf
    bObsWatch = False
    bObsDone = True
    NHV_Util.FlowScene(FLOW_SCENE_OBS)
EndFunction

; The observation could not be played: flag it as seen and open the same hub the scene would have opened.
Function FinishObservationWithoutScene()
    bObsWatch = False
    bObsDone = True
    NHV_Util.Log(NHV_Cfg_Debug, "FinishObservationWithoutScene: Aelius or Sings unavailable (or timeout), observation skipped")
    NHV_Util.FlowSet(FLOW_AELIUS_OBSERVED, 1)
    NHV_Util.FlowSet(FLOW_CURSOR_SINGS, FLOW_HUB_OBS)
EndFunction

; Stage 70 fragment: Sings waits at the desk, the dispatch on it is enabled (GiveOculatusFragment), the desk watch starts.
Function OnStage70()
    MoveSingsToDesk() ; before the dispatch is enabled (without a desk ref GiveOculatusFragment() hands the item over directly)
    ; the judgment hub is armed right away, so a scene that fails to start can never block the judgment (the desk and list
    ; scenes only move the cursor on to richer hubs)
    NHV_Util.FlowSet(FLOW_CURSOR_SINGS, FLOW_HUB_DESK)
    GiveOculatusFragment()
    BeginDeskWatch()
EndFunction

Function MoveSingsToDesk()
    Actor kSings = GetSings()
    If kSings && !kSings.IsDead() && DispatchDeskRef
        kSings.MoveTo(DispatchDeskRef, 130.0, 0.0, 0.0)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "MoveSingsToDesk: Sings or DispatchDeskRef missing, he stays where he is")
    EndIf
EndFunction

Function BeginDeskWatch()
    If bDeskScenePlayed
        Return
    EndIf
    bDeskWatch = True
    RegisterForSingleUpdate(3.0)
EndFunction

; 0 = Sings killed Aelius, 1 = the player did (SingsUnproven), 2 = somebody else / unknown (AeliusFallback): the same
; Globals the dialogue conditions read ("killer" in the flow).
Int Function GetKillerKind()
    If NHV_Q02_Flag_SingsUnproven && NHV_Q02_Flag_SingsUnproven.GetValueInt() == 1
        Return 1
    EndIf
    If NHV_Q02_Flag_AeliusFallback && NHV_Q02_Flag_AeliusFallback.GetValueInt() == 1
        Return 2
    EndIf
    Return 0
EndFunction

; Stage 70: as soon as the player stands near Sings at the desk he speaks first (a scene, no Hello that could be missed);
; the scene ends in the desk hub (judgment, lane Sings).
Function DeskTick()
    If GetStage() != 70 || bDeskScenePlayed
        bDeskWatch = False
        Return
    EndIf
    If HandleSingsDead()
        Return
    EndIf
    Actor kSings = GetSings()
    If !kSings
        bDeskWatch = False
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If IsCutsceneLocked() || !kSings.Is3DLoaded() || kPlayer.GetDistance(kSings) > 800.0
        Return
    EndIf
    bDeskWatch = False
    bDeskScenePlayed = True
    Int iKind = GetKillerKind()
    If iKind == 1
        NHV_Util.FlowScene(FLOW_SCENE_DESK_P)
    ElseIf iKind == 2
        NHV_Util.FlowScene(FLOW_SCENE_DESK_O)
    Else
        NHV_Util.FlowScene(FLOW_SCENE_DESK_S)
    EndIf
EndFunction

; E54: the courier appears only when the desk has been opened (the dispatch was read or taken, OnDispatchFound at stage 70).
Function OnDeskOpened()
    ; FLOW_COURIER_DONE is the flow state "courierInterrupted" (set when the courier talk ends): never a second encounter
    If bCourierStarted || GetStage() != 70 || NHV_Util.FlowGet(FLOW_COURIER_DONE) == 1
        Return
    EndIf
    If !DispatchDeskRef
        NHV_Util.Log(NHV_Cfg_Debug, "OnDeskOpened: no DispatchDeskRef set in the CK, no desk to open, courier skipped")
        Return
    EndIf
    bCourierStarted = True
    bDeskWatch = False
    bDeskScenePlayed = True ; the courier scene replaces the desk intro
    Actor kCourier = GetCourier()
    Actor kSings = GetSings()
    If !kCourier || kCourier.IsDead() || !kSings || kSings.IsDead()
        NHV_Util.Log(NHV_Cfg_Debug, "OnDeskOpened: courier or Sings unavailable, the encounter is skipped (list talk follows)")
        NHV_Util.FlowSet(FLOW_COURIER_DONE, 1)
        DelayScene(FLOW_SCENE_LIST, 2.0)
        Return
    EndIf
    If kCourier.IsDisabled()
        kCourier.Enable()
    EndIf
    If DispatchDeskRef
        kCourier.MoveTo(DispatchDeskRef, 180.0, 0.0, 0.0)
    Else
        kCourier.MoveTo(Game.GetPlayer(), 180.0, 0.0, 0.0)
    EndIf
    SetObjectiveDisplayed(71)
    DelayScene(FLOW_SCENE_COURIER, 2.5)
EndFunction

; Chain end of the courier talk: the courier runs (a coward, never a fight: E54) and is disabled a few seconds later.
Function CourierFlees()
    Actor kCourier = GetCourier()
    If kCourier && !kCourier.IsDead()
        kCourier.SetActorValue("Confidence", 0.0)
        kCourier.StartCombat(Game.GetPlayer())
        bCourierDisable = True
        iCourierTicks = 3 ; ~7 seconds at the 2.5 s tick of RearmWatches()
        RegisterForSingleUpdate(2.5)
    EndIf
    If IsObjectiveDisplayed(71)
        SetObjectiveCompleted(71)
    EndIf
EndFunction

; Hooks of the surrender chain and of the Babette line: the second speaker has to stand next to the first before the
; delayed scene starts.
Function MoveHjoraldNear()
    Actor kHjorald = GetHjorald()
    Actor kPlayer = Game.GetPlayer()
    If kHjorald && kPlayer && !kHjorald.IsDead()
        If kHjorald.IsDisabled()
            kHjorald.Enable()
        EndIf
        kHjorald.MoveTo(kPlayer, 250.0, 0.0, 0.0)
        kHjorald.EvaluatePackage()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "MoveHjoraldNear: Hjorald unavailable")
    EndIf
EndFunction

Function MoveBabetteNear()
    Actor kBabette = None
    If BabetteAlias
        kBabette = BabetteAlias.GetActorRef()
    EndIf
    Actor kSings = GetSings()
    If kBabette && kSings && !kBabette.IsDead()
        kBabette.MoveTo(kSings, 200.0, 0.0, 0.0)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "MoveBabetteNear: Babette or Sings unavailable")
    EndIf
EndFunction

; The recruit-alias script reports Sings' death while the contract runs (stage < 100). The base class only sets the status
; Global; here the quest additionally settles the outcome as "killed" and moves on to the debrief (Opus review 01.10.2026:
; a dead candidate must never leave the quest hanging at stage 30-70).
Function RecruitDied(Actor akRecruit, GlobalVariable akStatusGlobal)
    Parent.RecruitDied(akRecruit, akStatusGlobal)
    If GetStage() >= 30 && GetStage() < 100
        HandleSingsDead()
    EndIf
EndFunction

; A scene start after a delay (the dialogue that triggers it has to be closed first). One pending scene at a time: a second
; call before the first one ran replaces it (today only OnDeskOpened, the list-scene fallback and the chain-end starts use it).
Function DelayScene(Int aiSceneID, Float afDelay)
    iPendingScene = aiSceneID
    RegisterForSingleUpdate(afDelay)
EndFunction

; ---------------------------------------------------------------------------
; Death fallbacks (developer feedback 03.10.2026): a conversation partner that dies (usually by the player's hand) before his
; talk can never leave the quest hanging. One slow poll (DeathTick, in the single timer of RearmWatches) settles every case
; idempotently; every NPC also carries a lootable NHV_Note_Fallback_<Name> with the hints of the missed talk (base inventory;
; the enforcers, a cloned non-unique base, get theirs from GiveEnforcerNote). The destination stage supplies the journal text.
; Aelius' death belongs to the quest and needs no handler here (ObsTick / UpdateKillWatch / StartAeliusKillScene settle it).
; ---------------------------------------------------------------------------

; Dead check without side effects (no Enable, no refill): the alias actor or the placed ref by FormID (Q01 lesson 6).
Bool Function IsNpcDead(ReferenceAlias akAlias, Int aiRefID)
    Actor kActor = ResolveActor(akAlias, aiRefID, False)
    Return kActor && kActor.IsDead()
EndFunction

; Called from PatchStageActivators() and therefore at stage 10 and after every load (RearmAfterLoad), never at stage >= 100.
Function ArmDeathWatch()
    Int iStage = GetStage()
    If iStage < 10 || iStage >= 100
        Return
    EndIf
    If iStage == 10 && iDeathHighStage > 10
        ; quest restarted (reset): the one-shot flags of the previous run must not carry over
        bDrinksNoted = False
        bEnforcerNoteGiven = False
        bTideTalked = False
        bSaltTalked = False
        iDeathHighStage = 10
    EndIf
    If iStage > iDeathHighStage
        iDeathHighStage = iStage
    EndIf
    bDeathWatch = True
    RearmWatches()
EndFunction

Function DeathTick()
    Int iStage = GetStage()
    If iStage < 10 || iStage >= 100
        bDeathWatch = False
        Return
    EndIf
    If iStage > iDeathHighStage
        iDeathHighStage = iStage
    EndIf
    ; The candidate: dead at any stage before the judgment means outcome "killed" and the debrief (HandleSingsDead). Without it a dead
    ; Sings would leave stage 30 (night scene) and stage 50 (his talk) without a way on.
    If IsNpcDead(SingsAlias, REF_SINGS) && HandleSingsDead()
        bDeathWatch = False
        Return
    EndIf
    ; Torbjorn sends the player to the tidehouse (stage 10 -> 15).
    If iStage == 10 && IsNpcDead(TorbjornAlias, REF_TORBJORN)
        NHV_Util.Log(NHV_Cfg_Debug, "DeathTick: Torbjorn is dead at stage 10, going on to the tidehouse (stage 15)")
        Debug.Notification("Torbjorn is dead. His harbor slate points to the sealed tidehouse.")
        SetStage(15)
        iStage = 15
    EndIf
    ; Hjorald gives the key talk and takes the ledger report (stage 15 -> 20): the ledger is handed over, the stage moves on.
    If iStage == 15 && IsNpcDead(HjoraldAlias, REF_HJORALD)
        NHV_Util.Log(NHV_Cfg_Debug, "DeathTick: Hjorald is dead at stage 15, handing over the tidehouse ledger (stage 20)")
        GiveTidehouseLedgerFallback()
        Debug.Notification("Sergeant Hjorald is dead. His key tag still opens the tidehouse log.")
        SetStage(20)
        iStage = 20
    EndIf
    ; Torbjorn shows the body and names the night shift (stage 20 -> 30).
    If iStage == 20 && IsNpcDead(TorbjornAlias, REF_TORBJORN)
        NHV_Util.Log(NHV_Cfg_Debug, "DeathTick: Torbjorn is dead at stage 20, going on to the night watch (stage 30)")
        Debug.Notification("Torbjorn is dead. Haldor's night crew may still talk at the east pier after the late bell.")
        SetStage(30)
        iStage = 30
    EndIf
    ; Drinks-the-Brine: the salt yard talk names the sluice; the Hollow door itself stays usable at stage 45 (no softlock), only a hint.
    If iStage == 45 && !bDrinksNoted && IsNpcDead(DrinksAlias, REF_DRINKS)
        bDrinksNoted = True
        NHV_Util.Log(NHV_Cfg_Debug, "DeathTick: Drinks is dead at stage 45, the Hollow door is the way on")
        Debug.Notification("Drinks-the-Brine is dead. The sluice should still lie behind the salt bins.")
    EndIf
    ; Dock enforcers: a corpse killed before the talk carries the fallback note (one copy in total).
    If !bEnforcerNoteGiven
        If iStage == 15 && !bTideTalked
            GiveEnforcerNote(TidehouseEnforcerRefs)
        ElseIf iStage == 45 && !bSaltTalked
            GiveEnforcerNote(SaltYardEnforcerRefs)
        EndIf
    EndIf
    ; Courier: dead during the encounter (before the talk ended): close the encounter, the list talk follows (the desk hub is armed).
    If iStage == 70 && bCourierStarted && NHV_Util.FlowGet(FLOW_COURIER_DONE) != 1
        Actor kCourier = GetCourier()
        If kCourier && kCourier.IsDead()
            NHV_Util.Log(NHV_Cfg_Debug, "DeathTick: the courier died during the encounter, closing it")
            NHV_Util.FlowSet(FLOW_COURIER_DONE, 1)
            If IsObjectiveDisplayed(71)
                SetObjectiveCompleted(71)
            EndIf
            DelayScene(FLOW_SCENE_LIST, 2.0)
        EndIf
    EndIf
    If GetStage() >= 100
        bDeathWatch = False
    EndIf
EndFunction

; The tidehouse ledger by script (once, bLedgerGiven shared with OnTidehouseBriefed): FormID fallback if the property is unbound.
Function GiveTidehouseLedgerFallback()
    If bLedgerGiven
        Return
    EndIf
    Book kLedger = TidehouseLedger
    If !kLedger
        kLedger = Game.GetFormFromFile(NOTE_LEDGER, "NightsHarvest.esp") as Book
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kLedger && kPlayer && kPlayer.GetItemCount(kLedger) == 0
        bLedgerGiven = True
        kPlayer.AddItem(kLedger, 1, False)
    EndIf
EndFunction

; Puts the enforcer fallback note on the first dead enforcer of the list.
Function GiveEnforcerNote(ObjectReference[] akRefs)
    Int i = 0
    While akRefs && i < akRefs.Length
        Actor kEnforcer = akRefs[i] as Actor
        If kEnforcer && kEnforcer.IsDead()
            Book kNote = Game.GetFormFromFile(NOTE_ENFORCER, "NightsHarvest.esp") as Book
            If kNote
                kEnforcer.AddItem(kNote, 1, True)
                bEnforcerNoteGiven = True
                NHV_Util.Log(NHV_Cfg_Debug, "GiveEnforcerNote: the watch orders were put on a dead enforcer")
            EndIf
            Return
        EndIf
        i += 1
    EndWhile
EndFunction

; ---------------------------------------------------------------------------
; Stage 100: the debrief with Veyra in the Dawnstar Sanctuary (E51) and the map table (Q01 pattern, lesson 4)
; ---------------------------------------------------------------------------

Function BeginDebriefWatch()
    ShowHaldor()
    If bDebriefWatch || bTableOpened
        Return
    EndIf
    bDebriefWatch = True
    RegisterForSingleUpdate(4.0)
    NHV_Util.Log(NHV_Cfg_Debug, "Debrief watch started")
EndFunction

; Veyra stays in the sanctuary (E51). Wherever the script left her, she steps in front of the player once as soon as he
; stands in the Dawnstar Sanctuary or the Deep Sanctuary and she is not close; then the watch ends (she is reachable).
Function DebriefTick()
    If GetStage() < 100 || bTableOpened
        bDebriefWatch = False
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    Cell kCell = kPlayer.GetParentCell()
    Cell kDawnstar = Game.GetFormFromFile(0x0193EE, "Skyrim.esm") as Cell
    Cell kDeep = Game.GetFormFromFile(0x001342, "NightsHarvest.esp") as Cell
    If !kCell || (kCell != kDawnstar && kCell != kDeep)
        Return
    EndIf
    Actor kVeyra = None
    If Core
        kVeyra = Core.GetVeyraActor()
    EndIf
    If !kVeyra || kVeyra.IsDead()
        Return
    EndIf
    If kVeyra.IsDisabled()
        kVeyra.Enable()
    EndIf
    If kVeyra.Is3DLoaded() && kPlayer.GetDistance(kVeyra) < 1500.0
        bDebriefWatch = False
        Return
    EndIf
    Float fAngle = kPlayer.GetAngleZ()
    kVeyra.MoveTo(kPlayer, 350.0 * Math.Sin(fAngle), 350.0 * Math.Cos(fAngle), 0.0)
    kVeyra.EvaluatePackage()
    bDebriefWatch = False
    NHV_Util.Log(NHV_Cfg_Debug, "DebriefTick: Veyra steps in front of the player")
EndFunction

; End of the debrief: the table hub (Main lane) is armed a moment later because the chain end resets the cursor to 0.
Function OpenMapTable()
    If bTableOpened
        Return
    EndIf
    bTableOpened = True
    bDebriefWatch = False
    bTableCursorPending = True
    RegisterForSingleUpdate(2.0)
    Debug.Notification("The map table in the Ledger Room is open.")
EndFunction

; Fallback "Show me the table.": the table menu opens after the dialogue closed (E48: no pin order is assumed).
Function OpenTableMenu()
    bTableMenuPending = True
    RegisterForSingleUpdate(1.5)
EndFunction

Function ShowTableMenu()
    NHV_MapTableScript kTable = Game.GetFormFromFile(0x005ECC, "NightsHarvest.esp") as NHV_MapTableScript ; NHV_Ref_MapTable
    If kTable
        kTable.ShowMenu()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "ShowTableMenu: the map table script is not reachable")
    EndIf
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
