Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: SKSE check, versioning, maintenance, startbedingung. Attached to NHV_Sys_Core (Start Game Enabled). Concept sections 2 and 14.}

; Script version. Bump for every save-relevant change and add one idempotent step to Migrate().
Int Property VERSION = 3 AutoReadOnly
; Human-readable mod version, keep in sync with fomod/info.xml and the git tag.
String Property VERSION_TEXT = "0.0.1" AutoReadOnly

GlobalVariable Property NHV_Cfg_Debug Auto
; Master switch (M0.6). Off: no new quest starts, running quests are not paused.
GlobalVariable Property NHV_Cfg_Enabled Auto
; Days between "Hail Sithis!" and Q00, MCM slider 0-7, default 2 (E14).
GlobalVariable Property NHV_Cfg_StartDelay Auto

; DB11 "Hail Sithis!", verified 22.09.2026 via houseCARL against Skyrim.esm (docs/GOAL.md).
Quest Property HailSithisQuest Auto
; DBDestroy "Destroy the Dark Brotherhood!", the alternate path that keeps the mod inactive.
Quest Property DestroyQuest Auto
; NHV_Q00_ShadowAtTheDoor (M1.5). Journal texts for its stages are set directly in the
; CK for now, not via Spriggit - see docs/PROGRESS.md "Bekannte Spriggit-Limitation".
Quest Property Q00 Auto
; DawnstarSanctuaryLocation, verified 22.09.2026 via houseCARL against Skyrim.esm.
Location Property DawnstarSanctuaryLocation Auto

; --- Sealed Passage (E16, E09, M1.3/M1.5 Q00 Szene 4) ---
; Any persistent vanilla reference already inside the DawnstarSanctuary cell, used only as a
; spawn anchor for PlaceAtMe (never modified itself). Suggested: DanestarSanctuaryPlayerMarker
; (09725F:Skyrim.esm) - verified 23.09.2026 via houseCARL, actually present in that cell.
; "Danestar" (not "Dawnstar") is Bethesda's own typo in the vanilla EditorID, not ours.
ObjectReference Property DawnstarAnchorRef Auto
; Vanilla NorRubblePile05 (03011F:Skyrim.esm) - plain Nordic rubble pile Static (no snow/ice),
; verified 23.09.2026 via houseCARL against Skyrim.esm. Visible at the sealed-passage wall spot
; before Q00 Stage 40. (Earlier pick MG05Rubble looked right by name but is actually a small
; wall sconce model - corrected.) PlaceAtMe takes any Form, so Static works here too.
Static Property RubbleBase Auto
; NHV_SealedPassageDoor - our own Door record (Nordic door model reused from vanilla
; NorDoorSmLoad01MinUse, own base so NHV_SealedPassageDoorScript can attach to it; this
; compiler has no RegisterForRemoteEvent, so the base-object script handles OnActivate
; instead of NHV_CoreScript). Replaces RubbleBase from Q00 Stage 40 onward.
Door Property PassageDoorBase Auto

; Runtime-created references (PlaceAtMe), not CK properties. Persist in the save as normal
; script variables - never rename these (Regel 3, Save-Kompatibilitaet).
ObjectReference RubbleRef
ObjectReference PassageDoorRef

Int iInstalledVersion = 0
; True between registering the start-delay timer and it firing; guards against a second
; registration if the player leaves and re-enters the Sanctuary before the delay elapses.
Bool bStartTimerPending = False

Event OnInit()
    Maintenance()
EndEvent

; Safe to run any number of times (OnInit now, on every game load once NHV_PlayerAliasScript exists).
Function Maintenance()
    If SKSE.GetVersion() <= 0
        NHV_Util.Log(NHV_Cfg_Debug, "SKSE missing, core inactive")
        Debug.MessageBox("Night's Harvest requires SKSE64 and stays inactive without it.")
        Return
    EndIf
    If iInstalledVersion < VERSION
        Migrate(iInstalledVersion)
        iInstalledVersion = VERSION
        Debug.Notification("Night's Harvest " + VERSION_TEXT + " loaded")
    EndIf
    EnsureSealedPassageState()
    NHV_Util.Log(NHV_Cfg_Debug, "Maintenance done, mod " + VERSION_TEXT + ", script version " + iInstalledVersion)
EndFunction

Function Migrate(Int aiFrom)
    ; One block per script version, in order, each idempotent. Never renumber or remove steps.
    ; If aiFrom < 2
    ;     ...
    ; EndIf
    If aiFrom < 3
        ; Sealed Passage introduced. No per-save state to migrate here - EnsureSealedPassageState()
        ; runs unconditionally from Maintenance() below and is itself idempotent (checks both
        ; refs first), so a fresh install and an upgraded save both just fall through to it.
    EndIf
EndFunction

; Idempotent: does nothing once either RubbleRef or PassageDoorRef already exists. Safe to call
; on every load. Picks the door directly if Q00 already passed stage 40 (e.g. save from before
; this feature existed, or the player fast-travelled away and back after the swap).
Function EnsureSealedPassageState()
    If RubbleRef || PassageDoorRef
        Return
    EndIf
    If Q00 && Q00.GetStage() >= 40
        SpawnPassageDoor()
    Else
        SpawnPassageRubble()
    EndIf
EndFunction

Function SpawnPassageRubble()
    If !DawnstarAnchorRef || !RubbleBase
        NHV_Util.Log(NHV_Cfg_Debug, "SpawnPassageRubble: DawnstarAnchorRef or RubbleBase not set")
        Return
    EndIf
    RubbleRef = DawnstarAnchorRef.PlaceAtMe(RubbleBase, 1, False, False)
    If RubbleRef
        ; Wall spot in DawnstarSanctuary, taken via getpos/getangle 23.09.2026 (docs/ck/M1.3-Deep-Sanctuary-Stufe1.md).
        RubbleRef.SetPosition(2648.75, 4930.81, 5649.73)
        RubbleRef.SetAngle(0.0, 0.0, 0.0)
    EndIf
EndFunction

; Called once from EnsureSealedPassageState() (stage already >= 40 on load) or from the Q00
; Stage-40 fragment (docs/ck/M1.5-Q00-Dialog-Fragmente.md follow-up) via OpenSealedPassage().
Function SpawnPassageDoor()
    If PassageDoorRef
        Return
    EndIf
    If RubbleRef
        RubbleRef.Disable()
        RubbleRef.Delete()
        RubbleRef = None
    EndIf
    If !DawnstarAnchorRef || !PassageDoorBase
        NHV_Util.Log(NHV_Cfg_Debug, "SpawnPassageDoor: DawnstarAnchorRef or PassageDoorBase not set")
        Return
    EndIf
    PassageDoorRef = DawnstarAnchorRef.PlaceAtMe(PassageDoorBase, 1, False, False)
    If PassageDoorRef
        PassageDoorRef.SetPosition(2648.75, 4930.81, 5649.73)
        PassageDoorRef.SetAngle(0.0, 0.0, 0.0)
        NHV_Util.Log(NHV_Cfg_Debug, "Sealed passage door spawned")
    EndIf
EndFunction

; Public entry point for the Q00 Stage-40 fragment: swaps rubble for the door. The door's own
; OnActivate->MoveTo is handled by NHV_SealedPassageDoorScript on PassageDoorBase itself, not here.
Function OpenSealedPassage()
    SpawnPassageDoor()
EndFunction

; All conditions from concept section 2, "Startbedingungen", except the Story Manager /
; location-change trigger itself, which the caller (NHV_PlayerAliasScript) already handled.
Bool Function CanStartQ00()
    If !NHV_Cfg_Enabled || NHV_Cfg_Enabled.GetValueInt() != 1
        Return False
    EndIf
    If !HailSithisQuest || !HailSithisQuest.IsCompleted()
        Return False
    EndIf
    If DestroyQuest && (DestroyQuest.IsRunning() || DestroyQuest.IsCompleted())
        Return False
    EndIf
    If !Q00 || Q00.IsRunning() || Q00.IsCompleted()
        Return False
    EndIf
    Return True
EndFunction

; Called by NHV_PlayerAliasScript.OnLocationChange() whenever the player enters any location.
; Cheap to call often: the location check happens before anything else runs.
Function OnEnterDawnstarSanctuary(Location akNewLoc)
    If akNewLoc != DawnstarSanctuaryLocation
        Return
    EndIf
    If bStartTimerPending || !CanStartQ00()
        Return
    EndIf
    Float fDelay = 0.0
    If NHV_Cfg_StartDelay
        fDelay = NHV_Cfg_StartDelay.GetValue()
    EndIf
    If fDelay <= 0.0
        StartQ00()
    Else
        bStartTimerPending = True
        RegisterForSingleUpdateGameTime(fDelay * 24.0)
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 start delayed by " + fDelay + " day(s)")
    EndIf
EndFunction

Event OnUpdateGameTime()
    bStartTimerPending = False
    ; Re-check: conditions may no longer hold (mod disabled, Destroy path taken meanwhile).
    If CanStartQ00()
        StartQ00()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 start delay elapsed, but conditions no longer met")
    EndIf
EndEvent

Function StartQ00()
    Q00.Start()
    Q00.SetStage(10)
    NHV_Util.Log(NHV_Cfg_Debug, "Q00 started")
EndFunction
