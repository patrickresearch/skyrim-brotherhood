Scriptname NHV_ContractBaseScript extends Quest
{Shared base for the five recruitment-contract quests (NHV_Q01Script .. NHV_Q05Script): the
common tail of the Whisper/Hunt/Observation/Trial/Judgement/Homecoming schema (concept section 5)
- filling in Veyra for the Trial scene, recruiting the candidate into NHV_FamilyFaction via her
reserved NHV_Sys_Family alias, handing over an Oculatus dispatch fragment, reporting a candidate
death that happens BEFORE Homecoming, and a generic cutscene lock with its own real-time watchdog
(mirrors the NHV_CoreScript/Q00 ActiveCutscene/RecoverActiveCutscene pattern, docs/ARCHITECTURE.md).

Deliberately its own lock, not a reuse of NHV_CoreScript's (that one is wired specifically to Q00's
StandoffScene). Since NHV_CoreScript v32 (Team-Lead, Runde 2) exposes a public
Bool Function IsCutsceneLocked(), LockCutscene() below checks it via the Core property and refuses
to double-lock while Q00's own cutscene is holding the controls - the Property Q01 that v32 also
added to NHV_CoreScript (StartQ01(), called at the end of Q00) is what actually starts this quest.

CompleteRecruitment(Actor akRecruit, GlobalVariable akStatusGlobal, ReferenceAlias akFamilySlotAlias,
ReferenceAlias akContractAlias, ObjectReference akHomeMarker) is the fixed, five-parameter Homecoming
API every NHV_Q0xScript calls - see its own doc comment below before changing call sites. M1.7.}

GlobalVariable Property NHV_Cfg_Debug Auto
Faction Property NHV_FamilyFaction Auto
Actor Property PlayerRef Auto
NHV_CoreScript Property Core Auto ; for GetVeyraActor(), see FillVeyraAlias()
ReferenceAlias Property VeyraAlias Auto ; the contract quest's own (Optional) Veyra alias

; Status-Global values, concept section 5 ("Status-Tracking"). Fixed by design, never renumber.
Int Property STATUS_UNKNOWN = 0 AutoReadOnly
Int Property STATUS_RECRUITED = 1 AutoReadOnly
Int Property STATUS_KILLED = 2 AutoReadOnly
Int Property STATUS_RELEASED = 3 AutoReadOnly
Int Property STATUS_SPECIAL = 4 AutoReadOnly

; How many 2s watchdog ticks a locked cutscene gets before RecoverActiveCutscene() forces it open,
; matching the ~120s cap NHV_CoreScript uses for the Q00 Standoff watchdog.
Int Property CUTSCENE_WATCHDOG_CAP = 60 AutoReadOnly

Bool bCutsceneLocked = False Conditional
Scene ActiveCutscene
Int iCutsceneTicks

; ---------------------------------------------------------------------------
; Veyra (shared across every contract's Trial phase)
; ---------------------------------------------------------------------------

; Veyra has no fixed placed reference or alias of her own (NHV_Sys_Sanctuary does not carry one;
; she is spawned once by NHV_CoreScript.PrepareStandoff() via PlaceAtMe and kept alive only in that
; script's own VeyraRef variable). Fills THIS quest's Optional VeyraAlias from the public getter
; NHV_CoreScript.GetVeyraActor() instead of assuming a "NHV_VeyraRef" record exists. Call this once
; before a Trial scene that needs her (e.g. from the Stage 40->50 fragment).
Function FillVeyraAlias()
    If !Core || !VeyraAlias
        NHV_Util.Log(NHV_Cfg_Debug, "FillVeyraAlias: Core or VeyraAlias property not set in the CK")
        Return
    EndIf
    Actor kVeyra = Core.GetVeyraActor()
    If !kVeyra
        NHV_Util.Log(NHV_Cfg_Debug, "FillVeyraAlias: NHV_CoreScript.GetVeyraActor() returned None")
        Return
    EndIf
    VeyraAlias.ForceRefTo(kVeyra)
EndFunction

; ---------------------------------------------------------------------------
; Cutscene lock, generic across all contract quests
; ---------------------------------------------------------------------------

Function LockCutscene(Scene akScene)
    If bCutsceneLocked
        Return
    EndIf
    If Core && Core.IsCutsceneLocked()
        ; Q00 holds the controls (should never overlap); do not stack a second DisablePlayerControls.
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_ContractBaseScript: NHV_CoreScript lock active, contract lock skipped")
        Return
    EndIf
    Game.DisablePlayerControls(True, True, False, False, True, True, True, False)
    bCutsceneLocked = True
    ActiveCutscene = akScene
    iCutsceneTicks = 0
    RegisterForSingleUpdate(2.0)
    NHV_Util.Log(NHV_Cfg_Debug, "NHV_ContractBaseScript: cutscene lock engaged")
EndFunction

Function UnlockCutscene()
    If !bCutsceneLocked
        Return
    EndIf
    bCutsceneLocked = False
    ActiveCutscene = None
    Game.EnablePlayerControls(True, True, False, False, True, True, True, False)
    NHV_Util.Log(NHV_Cfg_Debug, "NHV_ContractBaseScript: cutscene lock released")
EndFunction

Bool Function IsCutsceneLocked()
    Return bCutsceneLocked
EndFunction

; How many ticks Scene.Start() gets before "not playing yet" is treated as a real failure instead
; of normal start-up lag (Start() is not synchronous - IsPlaying() reads False for a few ticks).
Int Property CUTSCENE_STARTUP_GRACE_TICKS = 3 AutoReadOnly

; Real-time watchdog (2s ticks, same cadence as Q00's WatchStandoffCutscene). A subclass that also
; needs OnUpdate for its own polling (e.g. NHV_Q01Script's ambush-distance check) must call
; "Parent.OnUpdate()" at the end of its own override so this still runs - see NHV_Q01Script.psc.
Event OnUpdate()
    If !bCutsceneLocked || !ActiveCutscene
        Return ; nothing locked right now, e.g. called via Parent.OnUpdate() with no active scene
    EndIf
    iCutsceneTicks += 1
    If iCutsceneTicks > CUTSCENE_WATCHDOG_CAP
        NHV_Util.Log(NHV_Cfg_Debug, "Cutscene watchdog cap reached, forcing recovery")
        RecoverActiveCutscene()
        Return
    EndIf
    If ActiveCutscene.IsPlaying()
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    If iCutsceneTicks <= CUTSCENE_STARTUP_GRACE_TICKS
        ; Scene.Start() was just called and the engine has not flipped IsPlaying() to True yet -
        ; a start-up race, not a stalled/failed scene. Keep waiting instead of recovering early.
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    ; scene stopped/never started/was interrupted by combat - never leave the player locked
    RecoverActiveCutscene()
EndEvent

; Stops the scene if it is still technically playing, then always unlocks. Safe to call when
; nothing is playing at all (e.g. from RecoverCutsceneOnLoad() after a load).
Function RecoverActiveCutscene()
    If ActiveCutscene && ActiveCutscene.IsPlaying()
        ActiveCutscene.Stop()
    EndIf
    UnlockCutscene()
EndFunction

; Called from a small ReferenceAlias script on the contract quest's PlayerRef alias
; (NHV_ContractPlayerAliasScript.OnPlayerLoadGame()) - scenes never resume across a save/load, so a
; lock still flagged True after loading is stale by definition and must be released immediately,
; the same safety net NHV_PlayerAliasScript.OnPlayerLoadGame() -> Maintenance() gives Q00.
Function RecoverCutsceneOnLoad()
    If bCutsceneLocked
        NHV_Util.Log(NHV_Cfg_Debug, "RecoverCutsceneOnLoad: lock was still set after loading, releasing")
        RecoverActiveCutscene()
    EndIf
EndFunction

; ---------------------------------------------------------------------------
; Recruit death before Homecoming / Homecoming itself / Oculatus fragment
; ---------------------------------------------------------------------------

; Called by NHV_ContractRecruitAliasScript.OnDeath() when the candidate dies WHILE the contract
; quest is still running (before Judgement/Homecoming). Never called for a death after the
; candidate already joined the family - NHV_RecruitAliasScript (docs/ARCHITECTURE.md) owns that.
; Guards against a STALE event: CompleteRecruitment() clears the contract alias on Homecoming
; specifically so this cannot fire afterwards, but the status Global is the authoritative check in
; case the alias-clear and a queued OnDeath race each other. A settled outcome (recruited, released,
; or the special case) is never overwritten by a late/duplicate death report.
Function RecruitDied(Actor akRecruit, GlobalVariable akStatusGlobal)
    If akStatusGlobal
        Int iCurrent = akStatusGlobal.GetValueInt()
        If iCurrent == STATUS_RECRUITED || iCurrent == STATUS_RELEASED || iCurrent == STATUS_SPECIAL
            NHV_Util.Log(NHV_Cfg_Debug, "RecruitDied: outcome already settled (" + iCurrent + "), ignoring")
            Return
        EndIf
    EndIf
    UnlockCutscene() ; safety net: never leave the player locked because a scene's actor died
    If akStatusGlobal && akStatusGlobal.GetValueInt() != STATUS_KILLED
        akStatusGlobal.SetValueInt(STATUS_KILLED)
    EndIf
    If akRecruit
        NHV_Util.SendRecruitEvent("NHV_RecruitDied", akRecruit)
        NHV_Util.Log(NHV_Cfg_Debug, "Contract candidate died")
    EndIf
EndFunction

; Common Homecoming step. Fixed signature, called by every NHV_Q0xScript the same way:
;   CompleteRecruitment(akRecruit, akStatusGlobal, akFamilySlotAlias, akContractAlias, akHomeMarker)
; Marks the candidate recruited, adds her/him to the family faction, moves her/him into the
; RESERVED alias already sitting in NHV_Sys_Family (e.g. HrefnaSlot, alias 2 - already exported
; with NHV_RecruitAliasScript and StatusGlobal wired, see plugin-text/Quests/NHV_Sys_Family) via
; ForceRefTo, CLEARS the contract quest's own candidate alias (akContractAlias) so
; NHV_ContractRecruitAliasScript's OnDeath can no longer fire for her once she belongs to the
; family, moves her to the Deep Sanctuary marker, and fires the ModEvent NHV_FamilyManagerScript
; already listens for. Does not touch the follower slot - that stays an explicit dialogue choice
; per docs/ARCHITECTURE.md.
Function CompleteRecruitment(Actor akRecruit, GlobalVariable akStatusGlobal, ReferenceAlias akFamilySlotAlias, ReferenceAlias akContractAlias, ObjectReference akHomeMarker)
    If !akRecruit
        NHV_Util.Log(NHV_Cfg_Debug, "CompleteRecruitment: recruit actor is None")
        Return
    EndIf
    If akStatusGlobal
        akStatusGlobal.SetValueInt(STATUS_RECRUITED)
    EndIf
    If NHV_FamilyFaction
        akRecruit.AddToFaction(NHV_FamilyFaction)
    EndIf
    If akFamilySlotAlias
        akFamilySlotAlias.ForceRefTo(akRecruit)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "CompleteRecruitment: FamilySlotAlias property not set in the CK")
    EndIf
    If akContractAlias
        akContractAlias.Clear() ; stop this quest's own recruit-alias script from watching her further
    EndIf
    If akHomeMarker
        akRecruit.MoveTo(akHomeMarker)
    EndIf
    akRecruit.EvaluatePackage()
    NHV_Util.SendRecruitEvent("NHV_RecruitJoined", akRecruit)
    NHV_Util.Log(NHV_Cfg_Debug, "CompleteRecruitment: recruit joined the family")
EndFunction

; Extension point for subclasses that need to reconcile their own state on load (e.g. NHV_Q01Script
; re-arming a pending release-letter timer). No-op here; called from
; NHV_ContractPlayerAliasScript.OnPlayerLoadGame() right after RecoverCutsceneOnLoad(). Overriding
; this in a subclass and calling it through this base-typed property still dispatches to the
; override (Papyrus functions/events are virtual; only plain variables are not inherited - see the
; ActiveCutscene lesson in docs/plan/Q01-The-Unanswered-Sacrament.md section 6).
Function OnContractLoadGame()
EndFunction

; Gives the Oculatus fragment once, whether the killer (akGiver) is carrying it or it has to be
; conjured onto the player directly (e.g. Veyra hands it over at Homecoming per the concept:
; "You left this on the body. I didn't."). Idempotent: a second call with the fragment already
; in the player's inventory does nothing, so Maintenance()-style re-checks stay safe.
Function GiveFragmentIfMissing(Actor akGiver, Form akFragment)
    If !akFragment || !PlayerRef
        Return
    EndIf
    If PlayerRef.GetItemCount(akFragment) > 0
        Return
    EndIf
    If akGiver && akGiver.GetItemCount(akFragment) > 0
        akGiver.RemoveItem(akFragment, 1, True, PlayerRef)
    Else
        PlayerRef.AddItem(akFragment, 1, True)
    EndIf
    NHV_Util.SendRecruitEvent("NHV_ContractCompleted", Self)
    NHV_Util.Log(NHV_Cfg_Debug, "GiveFragmentIfMissing: fragment delivered")
EndFunction
