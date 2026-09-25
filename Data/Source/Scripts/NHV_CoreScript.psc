Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: SKSE check, versioning, maintenance, startbedingung. Attached to NHV_Sys_Core (Start Game Enabled). Concept sections 2 and 14.}

; Script version. Bump for every save-relevant change and add one idempotent step to Migrate().
Int Property VERSION = 7 AutoReadOnly
; Human-readable mod version, keep in sync with fomod/info.xml and the git tag.
String Property VERSION_TEXT = "0.0.1" AutoReadOnly

GlobalVariable Property NHV_Cfg_Debug Auto
; Master switch (M0.6). Off: no new quest starts, running quests are not paused.
GlobalVariable Property NHV_Cfg_Enabled Auto
; Days between "Hail Sithis!" and Q00, MCM slider 0-7, default 2 (E14).
GlobalVariable Property NHV_Cfg_StartDelay Auto

; DB11 "Hail Sithis!", verified 22.09.2026 via houseCARL against Skyrim.esm (docs/GOAL.md).
Quest Property HailSithisQuest Auto
; DBrecurring "The Dark Brotherhood Forever" (01EA5A:Skyrim.esm, verified 25.09.2026 via houseCARL): the
; vanilla follow-up after "Hail Sithis!". Q00 starts only once it has been started, i.e. once the family
; has been rebuilt in the Dawnstar Sanctuary (E20). Skipping Hail Sithis with setstage leaves the world
; in the pre-move state (Falkreath sanctuary alive, characters missing), so this is the real gate.
Quest Property DBRecurringQuest Auto
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
; Vanilla NorRubblePile06 (03BC38:Skyrim.esm) - smallest plain Nordic rubble pile Static found
; (no snow/ice), verified 23.09.2026 via houseCARL against Skyrim.esm; still scaled down further
; in SpawnPassageRubble(). Visible at the sealed-passage wall spot before Q00 Stage 40. (Earlier
; picks MG05Rubble/NorRubblePile05 were wrong - a wall sconce, then a 6m-wide pile - corrected.)
Static Property RubbleBase Auto
; NHV_SealedPassageDoor - our own Door record (Nordic door model reused from vanilla
; NorDoorSmLoad01MinUse, own base so NHV_SealedPassageDoorScript can attach to it; this
; compiler has no RegisterForRemoteEvent, so the base-object script handles OnActivate
; instead of NHV_CoreScript). Replaces RubbleBase from Q00 Stage 40 onward.
Door Property PassageDoorBase Auto

; --- Q00 Szene 1 (Standoff) ---
; NHV_Veyra (000817:NightsHarvest.esp). She has no placed reference (a new reference in the vanilla
; cell would create a cell copy, E16), so she is created here at Q00 start.
ActorBase Property VeyraBase Auto

; --- Return door inside NHV_DeepSanctuaryCell ---
; The duplicated Markarth exit door (001586:NightsHarvest.esp, no teleport destination); disabled
; after ReturnDoorBase was placed at its exact position/rotation (used as PlaceAtMe anchor too).
ObjectReference Property ExitDoorRef Auto
; NHV_SealedPassageReturnDoor - own Door record carrying NHV_ReturnDoorScript.
Door Property ReturnDoorBase Auto

; Runtime-created references (PlaceAtMe), not CK properties. Persist in the save as normal
; script variables - never rename these (Regel 3, Save-Kompatibilitaet).
ObjectReference RubbleRef
ObjectReference PassageDoorRef
ObjectReference ReturnDoorRef
Actor VeyraRef
Bool bReturnDoorBusy = False

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
    If aiFrom < 7
        ; Start gate moved behind DBrecurring (E20). No per-save state to migrate.
    EndIf
    If aiFrom < 6
        ; Start delay now counts from Hail Sithis completion (fHailSithisDoneTime). Saves that already
        ; completed it get the reference time on the next location change; the delay restarts then.
    EndIf
    If aiFrom < 5
        ; Standoff preparation introduced (Veyra spawn at Q00 start). No per-save state to migrate.
    EndIf
    If aiFrom < 4
        ; Return door introduced. Nothing to migrate: ReturnDoorRef is created lazily by
        ; EnsureReturnDoor() the first time the player arrives in NHV_DeepSanctuaryCell.
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
        ; SetPosition right after PlaceAtMe in the same frame is unreliable (the reference isn't
        ; fully cell-registered yet) - a short wait fixes it. Confirmed 23.09.2026: without this,
        ; the rubble landed ~25/121/9 units off from the intended spot.
        Utility.Wait(0.1)
        ; Wall spot in DawnstarSanctuary, taken via getpos/getangle 23.09.2026 (docs/ck/M1.3-Deep-Sanctuary-Stufe1.md).
        RubbleRef.SetPosition(2648.75, 4930.81, 5649.73)
        RubbleRef.SetAngle(0.0, 0.0, 0.0)
        ; NorRubblePile06's own bounds are still ~4.5x3.5x1.1m - shrunk down so it reads as a
        ; blocked passage, not furniture-sized clutter in the middle of the room. Adjust to taste
        ; once seen in place (23.09.2026: developer testing scale/position live, see PROGRESS.md).
        RubbleRef.SetScale(0.3)
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
        Utility.Wait(0.1) ; see SpawnPassageRubble() - same PlaceAtMe/SetPosition timing issue.
        PassageDoorRef.SetPosition(2648.75, 4930.81, 5649.73)
        PassageDoorRef.SetAngle(0.0, 0.0, 0.0)
        NHV_Util.Log(NHV_Cfg_Debug, "Sealed passage door spawned")
    EndIf
EndFunction

; Called by NHV_SealedPassageDoorScript right after the player arrived in NHV_DeepSanctuaryCell.
; PlaceAtMe from a ref in a cell that is not loaded yet is unreliable, so the return door is
; created only now, once the cell is loaded. Cheap no-op on every later visit.
Function OnEnterDeepSanctuary()
    If ReturnDoorRef || bReturnDoorBusy
        Return
    EndIf
    bReturnDoorBusy = True
    Utility.Wait(0.5)
    EnsureReturnDoor()
    bReturnDoorBusy = False
EndFunction

Function EnsureReturnDoor()
    If ReturnDoorRef
        Return
    EndIf
    If !ExitDoorRef || !ReturnDoorBase
        NHV_Util.Log(NHV_Cfg_Debug, "EnsureReturnDoor: ExitDoorRef or ReturnDoorBase not set")
        Return
    EndIf
    ReturnDoorRef = ExitDoorRef.PlaceAtMe(ReturnDoorBase, 1, False, False)
    If ReturnDoorRef
        Utility.Wait(0.1) ; see SpawnPassageRubble() - same PlaceAtMe/SetPosition timing issue.
        ; Same spot and rotation as the duplicated Markarth exit door, which is only disabled now
        ; that its replacement exists (a failed PlaceAtMe must never leave the player without a door).
        ReturnDoorRef.SetPosition(ExitDoorRef.GetPositionX(), ExitDoorRef.GetPositionY(), ExitDoorRef.GetPositionZ())
        ReturnDoorRef.SetAngle(0.0, 0.0, ExitDoorRef.GetAngleZ())
        ExitDoorRef.Disable()
        NHV_Util.Log(NHV_Cfg_Debug, "Return door spawned")
    EndIf
EndFunction

; Called by NHV_ReturnDoorScript. Puts the player in front of the sealed-passage door in
; DawnstarSanctuary (100 units off the wall along -Y, the wall lies at +Y from that spot).
Function ReturnToSanctuary()
    If !PassageDoorRef
        NHV_Util.Log(NHV_Cfg_Debug, "ReturnToSanctuary: passage door does not exist")
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    kPlayer.MoveTo(PassageDoorRef, 0.0, -100.0, 8.0, False)
    kPlayer.SetAngle(0.0, 0.0, PassageDoorRef.GetAngleZ() + 180.0)
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
    If !DBRecurringQuest || !(DBRecurringQuest.IsRunning() || DBRecurringQuest.IsCompleted() || DBRecurringQuest.GetStage() > 0)
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

; Game time (days) at which "Hail Sithis!" was first seen as completed. The start delay (E14, days
; from NHV_Cfg_StartDelay) counts from here, not from the first Sanctuary visit. 0 = not seen yet.
Float fHailSithisDoneTime = 0.0

; Called by NHV_PlayerAliasScript.OnLocationChange() whenever the player enters any location.
; Cheap to call often: everything before the location check is a couple of comparisons.
; Q00 starts when the delay has elapsed AND the player enters the Dawnstar Sanctuary; the Standoff
; scene itself then starts once the player comes near Veyra (scene condition in the CK).
Function OnEnterDawnstarSanctuary(Location akNewLoc)
    NoteHailSithisCompletion()
    If akNewLoc != DawnstarSanctuaryLocation
        Return
    EndIf
    If !CanStartQ00() || fHailSithisDoneTime <= 0.0
        Return
    EndIf
    Float fDelay = 0.0
    If NHV_Cfg_StartDelay
        fDelay = NHV_Cfg_StartDelay.GetValue()
    EndIf
    Float fElapsed = Utility.GetCurrentGameTime() - fHailSithisDoneTime
    If fElapsed >= fDelay
        StartQ00()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 not started yet: " + (fDelay - fElapsed) + " day(s) of delay left")
    EndIf
EndFunction

; Remembers when "Hail Sithis!" was first observed as completed (Destroy path stays inactive).
Function NoteHailSithisCompletion()
    If fHailSithisDoneTime > 0.0
        Return
    EndIf
    If !HailSithisQuest || !HailSithisQuest.IsCompleted()
        Return
    EndIf
    If !DBRecurringQuest || !(DBRecurringQuest.IsRunning() || DBRecurringQuest.IsCompleted() || DBRecurringQuest.GetStage() > 0)
        Return
    EndIf
    If DestroyQuest && (DestroyQuest.IsRunning() || DestroyQuest.IsCompleted())
        Return
    EndIf
    fHailSithisDoneTime = Utility.GetCurrentGameTime()
    NHV_Util.Log(NHV_Cfg_Debug, "Start gate reached (Hail Sithis done, Dark Brotherhood Forever started) at game time " + fHailSithisDoneTime)
EndFunction

; Obsolete since script version 6 (the start delay is now measured from Hail Sithis completion, see
; OnEnterDawnstarSanctuary). Kept so saves that still have the old timer registered behave as before.
Event OnUpdateGameTime()
    bStartTimerPending = False
    ; Re-check: conditions may no longer hold (mod disabled, Destroy path taken meanwhile).
    If CanStartQ00()
        StartQ00()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 start delay elapsed, but conditions no longer met")
    EndIf
EndEvent

; Places Veyra at the chair and Nazir over her, and fills the Q00 aliases. Q00 alias IDs follow the
; order in the quest: 0 Veyra, 1 Nazir, 2 Babette, 3 Cicero (never renumber, save compatibility).
; Coordinates from getpos/getangle in DawnstarSanctuary, 25.09.2026. Veyra stands beside the chair
; for now; sitting comes with the Standoff scene's package/furniture in the CK.
Function PrepareStandoff()
    If !VeyraRef && VeyraBase && DawnstarAnchorRef
        VeyraRef = DawnstarAnchorRef.PlaceAtMe(VeyraBase, 1, True, False) as Actor
        If VeyraRef
            Utility.Wait(0.1) ; see SpawnPassageRubble() - same PlaceAtMe/SetPosition timing issue.
            VeyraRef.SetPosition(2477.90, 4740.29, 5617.24)
            VeyraRef.SetAngle(0.0, 0.0, 80.24)
        EndIf
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareStandoff: Veyra already exists or VeyraBase/DawnstarAnchorRef not set")
    EndIf
    ReferenceAlias kVeyra = Q00.GetAlias(0) as ReferenceAlias
    If kVeyra && VeyraRef
        kVeyra.ForceRefTo(VeyraRef)
    EndIf
    ReferenceAlias kNazir = Q00.GetAlias(1) as ReferenceAlias
    If kNazir
        Actor kNazirActor = kNazir.GetActorReference()
        If kNazirActor
            kNazirActor.MoveTo(DawnstarAnchorRef)
            kNazirActor.SetPosition(2462.77, 4975.05, 5675.23)
            kNazirActor.SetAngle(0.0, 0.0, 343.0)
        EndIf
    EndIf
    ; Babette and Cicero: two spots taken 25.09.2026, which of them stands where is still open
    ; (developer: does not matter for now). Cicero only if alive.
    ReferenceAlias kBabette = Q00.GetAlias(2) as ReferenceAlias
    If kBabette
        Actor kBabetteActor = kBabette.GetActorReference()
        If kBabetteActor && !kBabetteActor.IsDead()
            kBabetteActor.MoveTo(DawnstarAnchorRef)
            kBabetteActor.SetPosition(2002.43, 5345.85, 5695.10)
            kBabetteActor.SetAngle(0.0, 0.0, 0.0)
        EndIf
    EndIf
    ReferenceAlias kCicero = Q00.GetAlias(3) as ReferenceAlias
    If kCicero
        Actor kCiceroActor = kCicero.GetActorReference()
        If kCiceroActor && !kCiceroActor.IsDead()
            kCiceroActor.MoveTo(DawnstarAnchorRef)
            kCiceroActor.SetPosition(2485.03, 4466.59, 5618.41)
            kCiceroActor.SetAngle(0.0, 0.0, 0.0)
        EndIf
    EndIf
    ; Everyone has to stand in place when the player walks into the room, so their AI is frozen until
    ; the scene runs. ReleaseStandoff() unfreezes them (scene start, and as a safety net on Q00 stage 15/20).
    FreezeStandoffActors(True)
EndFunction

; Freezes/unfreezes the Q00 actors (aliases 0-3). Dead actors and empty aliases are skipped.
Function FreezeStandoffActors(Bool abFreeze)
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias
            Actor kActor = kAlias.GetActorReference()
            If kActor && !kActor.IsDead()
                kActor.EnableAI(!abFreeze)
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; Called when the Standoff scene starts and from the Q00 stage 15/20 fragments.
Function ReleaseStandoff()
    FreezeStandoffActors(False)
EndFunction

Function StartQ00()
    Q00.Start()
    PrepareStandoff()
    Q00.SetStage(10)
    NHV_Util.Log(NHV_Cfg_Debug, "Q00 started")
EndFunction
