Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: SKSE check, versioning, maintenance, startbedingung. Attached to NHV_Sys_Core (Start Game Enabled). Concept sections 2 and 14.}

; Script version. Bump for every save-relevant change and add one idempotent step to Migrate().
Int Property VERSION = 31 AutoReadOnly
; Human-readable mod version, keep in sync with fomod/info.xml and the git tag.
String Property VERSION_TEXT = "0.0.1" AutoReadOnly

GlobalVariable Property NHV_Cfg_Debug Auto
; Master switch (M0.6). Off: no new quest starts, running quests are not paused.
GlobalVariable Property NHV_Cfg_Enabled Auto
; Days between "Hail Sithis!" and Q00, MCM slider 0-7, default 2 (E14).
GlobalVariable Property NHV_Cfg_StartDelay Auto
; 0 while Veyra waits at the Windpeak Inn, 1 after she has returned to the Sanctuary.
GlobalVariable Property NHV_Q00_VeyraReturned Auto
; 1 after the Windpeak return dialogue, until the player enters the Sanctuary with Veyra.
GlobalVariable Property NHV_Q00_VeyraReturning Auto

; DB11 "Hail Sithis!", verified 22.09.2026 via houseCARL against Skyrim.esm (docs/GOAL.md).
Quest Property HailSithisQuest Auto
; NHV_Scn_Q00_01Standoff (built in the CK, docs/ck/M1.5-Q00-Szene1-Standoff.md). Started from
; OnUpdate() once the player is closer than 800 units to Veyra (concept section 6, stage 10).
; Filled in the CK on NHV_Sys_Core; None until then (the Standoff simply does not start).
Scene Property StandoffScene Auto

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
; XMarkerHeading in Windpeak Inn where Veyra waits after the Standoff while the Listener consults
; the Night Mother. Filled in the CK once the marker exists.
ObjectReference Property VeyraWindpeakMarkerRef Auto
; Existing XMarkerHeading just inside the Dawnstar Sanctuary exit route. A stage-15 travel package sends
; Veyra here so the player sees her leave before the script places her in the inn.
ObjectReference Property VeyraSanctuaryExitMarkerRef Auto
; XMarkerHeading in Dawnstar Sanctuary where Veyra is placed once the player brings her back from
; Windpeak Inn for the proposal dialogue.
ObjectReference Property VeyraSanctuaryReturnMarkerRef Auto

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
; Random NPCs (Dark Brotherhood initiates) hidden during the Standoff so they neither block Veyra's chair
; nor walk through the scene. Filled by HideStandoffBystanders(), cleared by ReleaseStandoff().
Actor[] StandoffBystanders
Int iBystanderCount = 0
Bool bStandoffSceneStarted = False
; Set by the scene's End fragment (RefreezeStandoff), so a finished Standoff is never re-armed.
Bool bStandoffSceneDone = False
; The Standoff runs as a fixed cutscene like the Helgen intro (developer, 25.09.2026): the player can look
; around but not move, fight, open menus or talk until it is over. Watchdog: iCutsceneTicks (2 s each).
Bool bCutsceneLocked = False
Int iCutsceneTicks = 0
Bool bReturnDoorBusy = False
Bool bVeyraExitStageAdvancePending = False
Bool bVeyraReturningToSanctuary = False

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
    EnsureProperties()
    If iInstalledVersion < VERSION
        Migrate(iInstalledVersion)
        iInstalledVersion = VERSION
        Debug.Notification("Night's Harvest " + VERSION_TEXT + " loaded")
    EndIf
    EnsureSealedPassageState()
    ; E25 self-heal: a script door of an earlier build still around (the migration found no load door back then).
    If DeepSanctuaryDoorRef && (ReturnDoorRef || (PassageDoorRef && PassageDoorRef != DeepSanctuaryDoorRef))
        MigrateToLoadDoor()
    EndIf
    ; Never leave the player without controls after loading a save made during the Standoff cutscene.
    If bCutsceneLocked
        Scene kLockedScene = StandoffScene
        If ActiveCutscene
            kLockedScene = ActiveCutscene
        EndIf
        If kLockedScene && kLockedScene.IsPlaying()
            bCutsceneSeenPlaying = True
            RegisterForSingleUpdate(2.0)
        Else
            UnlockCutscene()
        EndIf
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Maintenance done, mod " + VERSION_TEXT + ", script version " + iInstalledVersion)
EndFunction

; Skyrim does not copy property values changed in the ESP into script instances that already exist in a
; save, so a save made with an earlier build keeps None for properties filled later. This refills every
; property that is still None from its known FormID (own plugin or vanilla, never changes). Idempotent,
; runs on every load via Maintenance(). New properties added later belong in here as well.
Function EnsureProperties()
    If !DeepSanctuaryDoorRef
        DeepSanctuaryDoorRef = Game.GetFormFromFile(0x003D8B, "NightsHarvest.esp") as ObjectReference
    EndIf
    If !DeepSanctuaryLocation
        DeepSanctuaryLocation = Game.GetFormFromFile(0x000DD3, "NightsHarvest.esp") as Location
    EndIf
    If !MemorialScene
        MemorialScene = Game.GetFormFromFile(0x00380A, "NightsHarvest.esp") as Scene
    EndIf
    If !ContractScene
        ContractScene = Game.GetFormFromFile(0x003819, "NightsHarvest.esp") as Scene
    EndIf
    If !VeiledPassageScene
        VeiledPassageScene = Game.GetFormFromFile(0x0037F0, "NightsHarvest.esp") as Scene
    EndIf
    If !EnterDeepScene
        EnterDeepScene = Game.GetFormFromFile(0x0037F7, "NightsHarvest.esp") as Scene
    EndIf
    If !DeepSanctuaryEntryMarker
        DeepSanctuaryEntryMarker = Game.GetFormFromFile(0x001456, "NightsHarvest.esp") as ObjectReference
    EndIf
    If !NightMotherVoiceBase
        NightMotherVoiceBase = Game.GetFormFromFile(0x0037EC, "NightsHarvest.esp") as TalkingActivator
    EndIf
    If !NightMotherCallTopic
        NightMotherCallTopic = Game.GetFormFromFile(0x0037ED, "NightsHarvest.esp") as Topic
    EndIf
    If !NightMotherCoffinRef
        NightMotherCoffinRef = Game.GetFormFromFile(0x074766, "Skyrim.esm") as ObjectReference
    EndIf
    If !Q00
        Q00 = Game.GetFormFromFile(0x000815, "NightsHarvest.esp") as Quest
    EndIf
    If !VeyraBase
        VeyraBase = Game.GetFormFromFile(0x000817, "NightsHarvest.esp") as ActorBase
    EndIf
    If !PassageDoorBase
        PassageDoorBase = Game.GetFormFromFile(0x000DD5, "NightsHarvest.esp") as Door
    EndIf
    If !ReturnDoorBase
        ReturnDoorBase = Game.GetFormFromFile(0x000DD6, "NightsHarvest.esp") as Door
    EndIf
    If !ExitDoorRef
        ExitDoorRef = Game.GetFormFromFile(0x001586, "NightsHarvest.esp") as ObjectReference
    EndIf
    If !RubbleBase
        RubbleBase = Game.GetFormFromFile(0x03BC38, "Skyrim.esm") as Static
    EndIf
    If !DawnstarAnchorRef
        DawnstarAnchorRef = Game.GetFormFromFile(0x09725F, "Skyrim.esm") as ObjectReference
    EndIf
    If !DBRecurringQuest
        DBRecurringQuest = Game.GetFormFromFile(0x01EA5A, "Skyrim.esm") as Quest
    EndIf
    If !NHV_Q00_VeyraReturned
        NHV_Q00_VeyraReturned = Game.GetFormFromFile(0x00327B, "NightsHarvest.esp") as GlobalVariable
    EndIf
    If !NHV_Q00_VeyraReturning
        NHV_Q00_VeyraReturning = Game.GetFormFromFile(0x00327C, "NightsHarvest.esp") as GlobalVariable
    EndIf
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
    If aiFrom < 4
        ; Return door introduced. Nothing to migrate: ReturnDoorRef is created lazily by
        ; EnsureReturnDoor() the first time the player arrives in NHV_DeepSanctuaryCell.
    EndIf
    If aiFrom < 5
        ; Standoff preparation introduced (Veyra spawn at Q00 start). No per-save state to migrate.
    EndIf
    If aiFrom < 6
        ; Start delay now counts from Hail Sithis completion (fHailSithisDoneTime). Saves that already
        ; completed it get the reference time on the next location change; the delay restarts then.
    EndIf
    If aiFrom < 7
        ; Start gate moved behind DBrecurring (E20). No per-save state to migrate.
    EndIf
    If aiFrom < 8
        ; EnsureProperties() introduced (refills None properties in old saves). Runs before Migrate().
    EndIf
    If aiFrom < 9
        ; Bystander hiding introduced (StandoffBystanders/iBystanderCount). Nothing to migrate.
    EndIf
    If aiFrom < 10
        ; StandoffScene polling introduced. Nothing to migrate.
    EndIf
    If aiFrom < 11
        ; Dead actors leave their alias, bystanders only counted when disabled. Nothing to migrate.
    EndIf
    If aiFrom < 12
        ; HoldStandoffActors (SetDontMove) introduced. Nothing to migrate.
    EndIf
    If aiFrom < 13
        ; StopOtherScenes/ForceStart introduced. Nothing to migrate.
    EndIf
    If aiFrom < 14
        ; No DontMove; bystanders lose their own scene and AI. Nothing to migrate.
    EndIf
    If aiFrom < 15
        ; The Standoff opening is spoken via Actor.Say instead of the scene. Nothing to migrate.
    EndIf
    If aiFrom < 16
        ; SayStandoffLine enables the speaker's AI while it talks. Nothing to migrate.
    EndIf
    If aiFrom >= 6 && aiFrom < 17
        ; Script versions 6-16 froze the Standoff actors (EnableAI false, SetDontMove) and froze bystanders.
        ; Frozen actors cannot speak or answer (Veyra hung in dialogue, 25.09.2026). Undo it in saves that
        ; still carry the state; keeping them in place is now the job of the alias package (PrepareStandoff).
        RepairFrozenActors()
        ; Versions 15/16 set bStandoffSceneStarted with the Say intro and stopped polling, so a save still
        ; on stage 10 would never start the scene. Arm it again.
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 10 && StandoffScene && !StandoffScene.IsPlaying() && !bStandoffSceneDone
            bStandoffSceneStarted = False
            RegisterForSingleUpdate(2.0)
        EndIf
    EndIf
    If aiFrom < 18
        ; Cutscene lock (bCutsceneLocked/iCutsceneTicks) introduced; both start at their defaults.
    EndIf
    If aiFrom < 19
        ; Veyra travel markers and return flag introduced for the revised Q00 flow. Existing dev saves
        ; pick them up when the relevant dialog fragments run.
        If NHV_Q00_VeyraReturned && Q00 && Q00.GetStage() >= 30
            NHV_Q00_VeyraReturned.SetValue(1.0)
        EndIf
        If NHV_Q00_VeyraReturning
            NHV_Q00_VeyraReturning.SetValue(0.0)
        EndIf
    EndIf
    If aiFrom < 20
        ; Stage 15 now advances from the Core update instead of waiting inside the CK fragment.
    EndIf
    If aiFrom < 21
        ; Night Mother voice at her coffin introduced. Saves already on stage 20 need the coffin alias (new in a
        ; running quest, so empty) and the voice now, otherwise stage 20 cannot be finished.
        UpdateNightMother()
    EndIf
    If aiFrom < 22
        ; E24: stage 40 is a cutscene at the veiled wall now. A save whose door already stands (old flow, the
        ; stage 40 fragment spawned it at once) keeps that door and skips the cutscene.
        If PassageDoorRef
            bVeiledPassageDone = True
        EndIf
    EndIf
    If aiFrom < 23
        ; Memorial and contract cutscenes (stage 50 -> 60 -> 100) introduced; saves on stage 50 arm the poll.
        ArmMemorialPoll()
    EndIf
    If aiFrom < 24
        ; E25: a real load door (NHV_DeepSanctuaryDoorRef, placed in the CK) replaces the script door and the
        ; script return door. Remove what earlier builds spawned and switch over.
        MigrateToLoadDoor()
    EndIf
    If aiFrom < 25
        ; No per-save state: PlaceMemorialActor switched from SetPosition to MoveTo offsets.
    EndIf
    If aiFrom < 26
        ; Family walk: VeilMarkers/MemorialMarkers are new properties (ESP values). A save in stage 40/50 sends the
        ; family off at once; the gather counter starts at 0.
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && !bVeiledPassageStarted && !bVeiledPassageDone
            GatherFamily(VeilMarkers)
        ElseIf Q00 && Q00.IsRunning() && Q00.GetStage() == 50 && !bMemorialStarted
            GatherFamily(MemorialMarkers)
        EndIf
    EndIf
    If aiFrom < 27
        ; Veil markers moved to the corridor side of the door (ESP values); a family walking in stage 40 re-targets.
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && !bVeiledPassageStarted && !bVeiledPassageDone
            GatherFamily(VeilMarkers)
        EndIf
    EndIf
    If aiFrom < 28
        ; Memorial markers were ~270 units below the floor (z -236, navmesh -16..+35; Codex analysis 27.09.2026).
        ; Stage 50: re-target the walk. Stage 60 before the contract: whoever fell below the floor goes to the
        ; corrected marker.
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 50 && !bMemorialStarted
            GatherFamily(MemorialMarkers)
        ElseIf Q00 && Q00.IsRunning() && Q00.GetStage() == 60 && !bContractStarted && MemorialMarkers.Length >= 4
            Int i = 0
            While i < 4
                Actor kActor = GetFamilyActor(i)
                If kActor && MemorialMarkers[i] && kActor.GetParentCell() == MemorialMarkers[i].GetParentCell() && kActor.GetPositionZ() < -100.0 && MemorialMarkers[i].GetPositionZ() > -100.0
                    kActor.MoveTo(MemorialMarkers[i])
                    NHV_Util.Log(NHV_Cfg_Debug, "Migrate 28: alias " + i + " lifted from below the memorial floor")
                EndIf
                i += 1
            EndWhile
        EndIf
    EndIf
    If aiFrom < 29
        ; Door moved (now 3200/3552, see step 30; corridor at +Y): rubble of a stage-40 save moves along, the family re-targets.
        ; Q00 already past the contract: plaques and ledger were added in this version.
        If RubbleRef
            RubbleRef.SetPosition(3200.0, 3552.0, 5664.0)
            RubbleRef.SetAngle(0.0, 0.0, 180.0)
        EndIf
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && !bVeiledPassageStarted && !bVeiledPassageDone
            GatherFamily(VeilMarkers)
        EndIf
        If bContractStarted
            ShowMemorialPlaques()
        EndIf
        If bContractDone && GleanersLedger && Game.GetPlayer().GetItemCount(GleanersLedger) == 0
            GiveLedger()
        EndIf
    EndIf
    If aiFrom < 30
        ; Door at 3200/3552 (angle 180); the family faces the plaques at -5232/-1728 (developer 27.09.2026).
        If RubbleRef
            RubbleRef.SetPosition(3200.0, 3552.0, 5664.0)
            RubbleRef.SetAngle(0.0, 0.0, 180.0)
        EndIf
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && !bVeiledPassageStarted && !bVeiledPassageDone
            GatherFamily(VeilMarkers)
        ElseIf Q00 && Q00.IsRunning() && Q00.GetStage() == 50 && !bMemorialStarted
            GatherFamily(MemorialMarkers)
        EndIf
    EndIf
    If aiFrom < 31
        ; Standoff markers are new properties (ESP values); the placement only runs when Q00 starts.
    EndIf
EndFunction

; Idempotent: does nothing once either RubbleRef or PassageDoorRef already exists. Safe to call
; on every load. Picks the door directly if Q00 already passed stage 40 (e.g. save from before
; this feature existed, or the player fast-travelled away and back after the swap).
Function EnsureSealedPassageState()
    If RubbleRef || PassageDoorRef
        Return
    EndIf
    ; E24: on stage 40 the rubble (the veil) stands until the cutscene reveals the door.
    If Q00 && (Q00.GetStage() >= 50 || bVeiledPassageDone)
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
        ; E25: on the load door NHV_DeepSanctuaryDoorRef (developer 27.09.2026: 3200/3552/5664, angle 180,
        ; the corridor lies at +Y); earlier 3296/3392 and 2648.75/4930.81.
        RubbleRef.SetPosition(3200.0, 3552.0, 5664.0)
        RubbleRef.SetAngle(0.0, 0.0, 180.0)
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
    If DeepSanctuaryDoorRef
        ; E25: the real load door placed in the CK (initially disabled) - NPCs can path through it.
        DeepSanctuaryDoorRef.Enable()
        PassageDoorRef = DeepSanctuaryDoorRef
        NHV_Util.Log(NHV_Cfg_Debug, "Deep Sanctuary load door enabled")
        Return
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
    ArmMemorialPoll()
    If DeepSanctuaryDoorRef
        Return ; E25: the Deep Sanctuary's own exit door (ExitDoorRef) leads back, no script return door
    EndIf
    If ReturnDoorRef || bReturnDoorBusy
        Return
    EndIf
    bReturnDoorBusy = True
    Utility.Wait(0.5)
    EnsureReturnDoor()
    bReturnDoorBusy = False
EndFunction

; E25: legacy fallback only (used when NHV_DeepSanctuaryDoorRef is missing).
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
; E25: legacy fallback only (script return door of earlier builds).
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
    If DeepSanctuaryLocation && akNewLoc == DeepSanctuaryLocation
        ; E25: the player walked through the load door himself (fallback if the cutscene did not bring him).
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && bVeiledPassageDone
            Q00.SetStage(50)
        EndIf
        OnEnterDeepSanctuary()
        Return
    EndIf
    If akNewLoc != DawnstarSanctuaryLocation
        Return
    EndIf
    UpdateNightMother()
    ArmVeiledPassagePoll()
    If Q00 && Q00.IsRunning() && Q00.GetStage() == 30 && (bVeyraReturningToSanctuary || (NHV_Q00_VeyraReturning && NHV_Q00_VeyraReturning.GetValueInt() == 1))
        CompleteVeyraReturnToSanctuary()
    EndIf
    ; Q00 already waits for the player near Veyra (he left the Sanctuary before): resume the polling.
    If Q00 && Q00.IsRunning() && Q00.GetStage() == 10 && !bStandoffSceneStarted && !bStandoffSceneDone
        RegisterForSingleUpdate(2.0)
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
; for now. Keeping everybody on their spot is NOT done here: the Q00 aliases carry the package
; NHV_Pkg_Q00_StandoffHold (vanilla DoNothing template, until stage 15), which outranks their own
; sandbox packages. Script-side freezing (EnableAI/SetDontMove) was removed in version 17.
Function PrepareStandoff()
    If !VeyraRef && VeyraBase && DawnstarAnchorRef
        VeyraRef = DawnstarAnchorRef.PlaceAtMe(VeyraBase, 1, True, False) as Actor
        If VeyraRef
            Utility.Wait(0.1) ; see SpawnPassageRubble() - same PlaceAtMe/SetPosition timing issue.
            ; The coordinates were taken standing IN the chair, so she stood inside it; moved ~70 units back
            ; along her heading (80.24 degrees). Sitting down is handled by the Standoff scene (CK).
            VeyraRef.SetPosition(2408.90, 4728.30, 5617.24)
            VeyraRef.SetAngle(0.0, 0.0, 80.24)
        EndIf
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareStandoff: Veyra already exists or VeyraBase/DawnstarAnchorRef not set")
    EndIf
    ReferenceAlias kVeyra = Q00.GetAlias(0) as ReferenceAlias
    If kVeyra && VeyraRef
        kVeyra.ForceRefTo(VeyraRef)
    EndIf
    ; The vanilla actors: the forced-reference aliases were still empty right after Q00.Start() in the
    ; 25.09.2026 test, so they are resolved from their placed refs (NazirRef/BabetteRef/CiceroRef) and
    ; forced into the alias here. Dead actors are skipped (Cicero may be dead).
    PlaceStandoffActor(1, 0x01C3AD, 2462.77, 4975.05, 5620.0, 343.0)
    PlaceStandoffActor(2, 0x01D4BC, 2002.43, 5345.85, 5695.10, 0.0)
    ; Babette and Cicero: which of the two spots is whose does not matter for now (developer, 25.09.2026).
    ; Cicero is CiceroDawnstarRef (0x09BCB0), the one who lives in Dawnstar after "The Cure for Madness"
    ; if spared (UESP). Killing him there kills only the Falkreath Cicero 0x01E64A; the Dawnstar one then
    ; stays disabled but alive, and PlaceStandoffActor would enable him. So 0x01E64A decides (same test as
    ; the scene's phase 4 and Proposal04b). Until version 17 the alias pointed at 0x01E64A itself.
    Actor kFalkreathCicero = Game.GetFormFromFile(0x01E64A, "Skyrim.esm") as Actor
    If kFalkreathCicero && kFalkreathCicero.IsDead()
        ReferenceAlias kCiceroAlias = Q00.GetAlias(3) as ReferenceAlias
        If kCiceroAlias
            kCiceroAlias.Clear()
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareStandoff: Cicero was killed (0x01E64A dead), alias 3 cleared")
    Else
        PlaceStandoffActor(3, 0x09BCB0, 2485.03, 4466.59, 5618.41, 0.0)
    EndIf
    HideStandoffBystanders()
    LogStandoffActor("Veyra", 0)
    LogStandoffActor("Nazir", 1)
    LogStandoffActor("Babette", 2)
    LogStandoffActor("Cicero", 3)
    bStandoffSceneStarted = False
    bStandoffSceneDone = False
    RegisterForSingleUpdate(2.0)
EndFunction

Actor Function GetVeyraActor()
    If VeyraRef
        Return VeyraRef
    EndIf
    If Q00
        ReferenceAlias kVeyra = Q00.GetAlias(0) as ReferenceAlias
        If kVeyra
            VeyraRef = kVeyra.GetActorReference()
        EndIf
    EndIf
    Return VeyraRef
EndFunction

Function SendVeyraToWindpeak()
    ReleaseStandoff()
    Actor kVeyra = GetVeyraActor()
    If !kVeyra
        NHV_Util.Log(NHV_Cfg_Debug, "SendVeyraToWindpeak: Veyra actor not available")
        Return
    EndIf
    If !VeyraWindpeakMarkerRef
        NHV_Util.Log(NHV_Cfg_Debug, "SendVeyraToWindpeak: VeyraWindpeakMarkerRef not set")
        Return
    EndIf
    If kVeyra.IsDisabled()
        kVeyra.Enable()
    EndIf
    kVeyra.EnableAI(True)
    kVeyra.SetDontMove(False)
    kVeyra.EvaluatePackage()
    kVeyra.MoveTo(VeyraWindpeakMarkerRef)
    kVeyra.SetAngle(0.0, 0.0, VeyraWindpeakMarkerRef.GetAngleZ())
    kVeyra.EvaluatePackage()
    bVeyraReturningToSanctuary = False
    If NHV_Q00_VeyraReturned
        NHV_Q00_VeyraReturned.SetValue(0.0)
    EndIf
    If NHV_Q00_VeyraReturning
        NHV_Q00_VeyraReturning.SetValue(0.0)
    EndIf
    ; The marker in the log shows which property value this save really holds (the ESP value does not
    ; replace one already stored in a save).
    NHV_Util.Log(NHV_Cfg_Debug, "Veyra moved to Windpeak Inn, marker " + VeyraWindpeakMarkerRef)
EndFunction

Function BeginVeyraExitSanctuary()
    ReleaseStandoff()
    Actor kVeyra = GetVeyraActor()
    If !kVeyra
        NHV_Util.Log(NHV_Cfg_Debug, "BeginVeyraExitSanctuary: Veyra actor not available")
        Return
    EndIf
    If kVeyra.IsDisabled()
        kVeyra.Enable()
    EndIf
    bVeyraReturningToSanctuary = False
    If NHV_Q00_VeyraReturned
        NHV_Q00_VeyraReturned.SetValue(0.0)
    EndIf
    If NHV_Q00_VeyraReturning
        NHV_Q00_VeyraReturning.SetValue(0.0)
    EndIf
    kVeyra.EvaluatePackage()
    bVeyraExitStageAdvancePending = True
    RegisterForSingleUpdate(8.0)
    NHV_Util.Log(NHV_Cfg_Debug, "Veyra exit from Sanctuary armed")
EndFunction

Function BeginVeyraReturnToSanctuary()
    Actor kVeyra = GetVeyraActor()
    If !kVeyra
        NHV_Util.Log(NHV_Cfg_Debug, "BeginVeyraReturnToSanctuary: Veyra actor not available")
        Return
    EndIf
    If kVeyra.IsDisabled()
        kVeyra.Enable()
    EndIf
    bVeyraReturningToSanctuary = True
    If NHV_Q00_VeyraReturned
        NHV_Q00_VeyraReturned.SetValue(0.0)
    EndIf
    If NHV_Q00_VeyraReturning
        NHV_Q00_VeyraReturning.SetValue(1.0)
    EndIf
    kVeyra.EvaluatePackage()
    NHV_Util.Log(NHV_Cfg_Debug, "Veyra return to Sanctuary armed")
EndFunction

Function CompleteVeyraReturnToSanctuary()
    Actor kVeyra = GetVeyraActor()
    If !kVeyra
        NHV_Util.Log(NHV_Cfg_Debug, "CompleteVeyraReturnToSanctuary: Veyra actor not available")
        Return
    EndIf
    ObjectReference kTarget = VeyraSanctuaryReturnMarkerRef
    If !kTarget
        kTarget = DawnstarAnchorRef
    EndIf
    If !kTarget
        NHV_Util.Log(NHV_Cfg_Debug, "CompleteVeyraReturnToSanctuary: no return marker available")
        Return
    EndIf
    If kVeyra.IsDisabled()
        kVeyra.Enable()
    EndIf
    kVeyra.MoveTo(kTarget)
    kVeyra.SetAngle(0.0, 0.0, kTarget.GetAngleZ())
    kVeyra.EvaluatePackage()
    bVeyraReturningToSanctuary = False
    If NHV_Q00_VeyraReturned
        NHV_Q00_VeyraReturned.SetValue(1.0)
    EndIf
    If NHV_Q00_VeyraReturning
        NHV_Q00_VeyraReturning.SetValue(0.0)
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Veyra returned to Dawnstar Sanctuary")
EndFunction

; Polls (real time, every 2 s) while Q00 sits on stage 10 and the player is in the Sanctuary, until he
; comes near Veyra, then starts the Standoff scene once. Stops by itself once the stage moves on, the scene
; has been started or the player leaves; OnEnterDawnstarSanctuary() resumes it on his return.
; The scene only speaks if every line has a voice file: silent ones come from tools/silent_voice.py (E21).
; Once the scene runs, the same update watches the cutscene lock (WatchStandoffCutscene).
Event OnUpdate()
    If bVeyraExitStageAdvancePending
        bVeyraExitStageAdvancePending = False
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 15
            Q00.SetStage(20)
        EndIf
        Return
    EndIf
    If bNightMotherCallPending
        ; No Return: a cutscene watchdog chain (dev saves, console setstage) must not starve behind it.
        bNightMotherCallPending = False ; legacy (call is idle dialogue since 26.09.2026): only clear it
    EndIf
    If bPassagePlacePending
        bPassagePlacePending = False
        PlaceVeiledPassageFamily()
        Return
    EndIf
    If bMemorialPollPending && !bCutsceneLocked
        bMemorialPollPending = False
        PollMemorial()
        Return
    EndIf
    If bPassagePollPending
        ; Return: a scene started here must not be judged by the watchdog in the same event (IsPlaying lags).
        bPassagePollPending = False
        PollVeiledPassage()
        Return
    EndIf
    ; The watchdog hangs on the lock itself, so nothing that resets bStandoffSceneStarted (Q00 restart in a
    ; dev save) can break its chain while the player is locked.
    If bCutsceneLocked
        WatchStandoffCutscene()
        Return
    EndIf
    If bStandoffSceneStarted
        Return
    EndIf
    If !Q00 || !Q00.IsRunning() || Q00.GetStage() != 10
        Return
    EndIf
    If !StandoffScene
        NHV_Util.Log(NHV_Cfg_Debug, "OnUpdate: StandoffScene not set, Standoff scene cannot start")
        Return
    EndIf
    If !VeyraRef
        NHV_Util.Log(NHV_Cfg_Debug, "OnUpdate: VeyraRef not set, Standoff scene cannot start")
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If VeyraRef.GetDistance(kPlayer) < 800.0
        bStandoffSceneStarted = True
        ; A vanilla Sanctuary scene holding Nazir or Babette would keep ours from getting them.
        StopOtherScenes()
        LockCutscene()
        StandoffScene.Start()
        NHV_Util.Log(NHV_Cfg_Debug, "Standoff scene started")
        If NHV_Cfg_Debug && NHV_Cfg_Debug.GetValueInt() == 1
            Utility.Wait(2.0)
            NHV_Util.Log(NHV_Cfg_Debug, "Standoff scene IsPlaying=" + StandoffScene.IsPlaying())
            LogSceneMembership()
        EndIf
        RegisterForSingleUpdate(2.0) ; watchdog, see WatchStandoffCutscene()
    ElseIf kPlayer.IsInLocation(DawnstarSanctuaryLocation)
        RegisterForSingleUpdate(2.0)
    EndIf
EndEvent

; Resolves one vanilla actor (alias first, then its placed ref), fills the alias, activates it if it is
; disabled, brings it into the Sanctuary and puts it on its spot.
Function PlaceStandoffActor(Int aiAlias, Int aiRefFormID, Float afX, Float afY, Float afZ, Float afAngle)
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    Actor kActor
    If kAlias
        kActor = kAlias.GetActorReference()
    EndIf
    If !kActor
        kActor = Game.GetFormFromFile(aiRefFormID, "Skyrim.esm") as Actor
        If kActor && kAlias
            kAlias.ForceRefTo(kActor)
        EndIf
    EndIf
    If !kActor
        NHV_Util.Log(NHV_Cfg_Debug, "PlaceStandoffActor: alias " + aiAlias + " has no actor (ref " + aiRefFormID + ")")
        Return
    EndIf
    If kActor.IsDead()
        ; A scene does not start with a dead actor among its aliases (Cicero in a save where he died).
        ; The alias is optional, so emptying it makes the scene skip that actor.
        If kAlias
            kAlias.Clear()
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "PlaceStandoffActor: alias " + aiAlias + " actor is dead, alias cleared")
        Return
    EndIf
    If kActor.IsDisabled()
        kActor.Enable()
    EndIf
    ; An actor caught sitting keeps the sit pose after being moved (Nazir hovered next to the chair,
    ; 25.09.2026), so leave the furniture state before the move.
    If kActor.GetSitState() != 0
        Debug.SendAnimationEvent(kActor, "IdleForceDefaultState")
        Utility.Wait(0.5)
    EndIf
    ; Standoff (stage 10): marker placed in the CK wins over the hard coordinates (developer 27.09.2026: the family
    ; should stand close together near Veyra and face her). The veiled passage (stage 40) keeps its coordinates.
    ObjectReference kMarker = None
    If Q00 && Q00.GetStage() < 20
        kMarker = GetStandoffMarker(aiAlias)
    EndIf
    If kMarker
        kActor.MoveTo(kMarker)
    Else
        kActor.MoveTo(DawnstarAnchorRef)
        kActor.SetPosition(afX, afY, afZ)
        kActor.SetAngle(0.0, 0.0, afAngle)
    EndIf
EndFunction

; XMarkerHeading refs in DawnstarSanctuary (NHV_Mk_Q00_Standoff<Name>, 004340-004342), heading towards Veyra.
ObjectReference Property StandoffNazirMarker Auto
ObjectReference Property StandoffBabetteMarker Auto
ObjectReference Property StandoffCiceroMarker Auto

ObjectReference Function GetStandoffMarker(Int aiAlias)
    If aiAlias == 1
        Return StandoffNazirMarker
    ElseIf aiAlias == 2
        Return StandoffBabetteMarker
    ElseIf aiAlias == 3
        Return StandoffCiceroMarker
    EndIf
    Return None
EndFunction

; Debug aid (25.09.2026): one log line per Q00 actor - alias filled, dead, disabled, position, cell.
Function LogStandoffActor(String asName, Int aiAlias)
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    If !kAlias
        NHV_Util.Log(NHV_Cfg_Debug, "Standoff " + asName + ": alias " + aiAlias + " not found")
        Return
    EndIf
    Actor kActor = kAlias.GetActorReference()
    If !kActor
        NHV_Util.Log(NHV_Cfg_Debug, "Standoff " + asName + ": alias empty")
        Return
    EndIf
    ; Cell.GetName()/Form.GetName() are SKSE additions and would break the CK's own compiler (it
    ; only sees the vanilla Form.psc), so the cell is logged by FormID.
    String sCell = "none"
    Cell kCell = kActor.GetParentCell()
    If kCell
        sCell = kCell.GetFormID() as String
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Standoff " + asName + ": dead=" + kActor.IsDead() + " disabled=" + kActor.IsDisabled() + " pos=" + kActor.GetPositionX() + "/" + kActor.GetPositionY() + "/" + kActor.GetPositionZ() + " cell=" + sCell)
EndFunction

; Freezes/unfreezes the Q00 actors (aliases 0-3). Since version 17 only ever called with False, to undo
; the freezing of earlier dev builds (RepairFrozenActors, ReleaseStandoff). Dead actors/empty aliases skipped.
Function FreezeStandoffActors(Bool abFreeze)
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias
            Actor kActor = kAlias.GetActorReference()
            If kActor && !kActor.IsDead()
                kActor.EnableAI(!abFreeze)
                If !abFreeze
                    kActor.EvaluatePackage() ; pick up NHV_Pkg_Q00_StandoffHold right away
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; Hides every other living, enabled NPC in the Sanctuary cell for the duration of the Standoff. The
; player, Veyra, the Q00 alias actors and the player's teammates are left alone. At most 20 are remembered.
Function HideStandoffBystanders()
    If !DawnstarAnchorRef
        Return
    EndIf
    Cell kCell = DawnstarAnchorRef.GetParentCell()
    If !kCell
        Return
    EndIf
    If !StandoffBystanders
        StandoffBystanders = new Actor[20]
    EndIf
    Actor kPlayer = Game.GetPlayer()
    Int iNum = kCell.GetNumRefs(43)
    Int i = 0
    While i < iNum && iBystanderCount < 20
        Actor kActor = kCell.GetNthRef(i, 43) as Actor
        If kActor && kActor != kPlayer && kActor != VeyraRef && !kActor.IsDead() && !kActor.IsDisabled() && !kActor.IsPlayerTeammate() && !IsStandoffActor(kActor)
            ; The prisoners have an enable-state parent and stay enabled (one harmless "cannot disable" line
            ; each in the log). IsDisabled() cannot tell right after Disable(), so every candidate is remembered.
            ; Their own looping scenes (the torture victims keep talking) would drown out the Standoff
            ; subtitles, so those are stopped; their AI stays on.
            Scene kOwnScene = kActor.GetCurrentScene()
            If kOwnScene
                kOwnScene.Stop()
            EndIf
            kActor.Disable()
            StandoffBystanders[iBystanderCount] = kActor
            iBystanderCount += 1
        EndIf
        i += 1
    EndWhile
    NHV_Util.Log(NHV_Cfg_Debug, "Standoff: " + iBystanderCount + " bystander(s) hidden")
EndFunction

Bool Function IsStandoffActor(Actor akActor)
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias && kAlias.GetReference() == akActor
            Return True
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

; Debug aid: which Q00 actors are currently inside the Standoff scene (25.09.2026: scene "played" but nobody spoke).
Function LogSceneMembership()
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias
            Actor kActor = kAlias.GetActorReference()
            If kActor
                NHV_Util.Log(NHV_Cfg_Debug, "Standoff alias " + i + " in our scene: " + (kActor.GetCurrentScene() == StandoffScene))
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; Stops every scene other than the Standoff that currently holds one of the Q00 actors.
Function StopOtherScenes()
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias
            Actor kActor = kAlias.GetActorReference()
            If kActor
                Scene kScene = kActor.GetCurrentScene()
                If kScene && kScene != StandoffScene
                    NHV_Util.Log(NHV_Cfg_Debug, "Stopping foreign scene on Standoff actor " + i)
                    kScene.Stop()
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; SetDontMove on the Q00 actors. Since version 17 only ever called with False, to undo earlier dev builds
; (it made everybody walk on the spot, 25.09.2026).
Function HoldStandoffActors(Bool abHold)
    Int i = 0
    While i < 4
        ReferenceAlias kAlias = Q00.GetAlias(i) as ReferenceAlias
        If kAlias
            Actor kActor = kAlias.GetActorReference()
            If kActor && !kActor.IsDead()
                kActor.SetDontMove(abHold)
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; Called from the Q00 stage 15/20 fragments.
Function ReleaseStandoff()
    FreezeStandoffActors(False)
    HoldStandoffActors(False)
    RestoreStandoffBystanders()
EndFunction

; Called by the End fragment of NHV_Scn_Q00_01Standoff (SF_NHV_Scn_Q00_01Standoff_02002B4E). Froze the
; actors until version 16; now it only notes that the scene has finished - the alias package keeps them in
; place, and frozen actors cannot answer the player. Name kept because the compiled fragment calls it.
Function RefreezeStandoff()
    bStandoffSceneDone = True
    NHV_Util.Log(NHV_Cfg_Debug, "Standoff scene finished")
    UnlockCutscene()
EndFunction

; Player controls off for the Standoff cutscene: looking around stays possible, everything else is locked.
Function LockCutscene()
    Game.DisablePlayerControls(True, True, False, False, True, True, True, False)
    bCutsceneLocked = True
    iCutsceneTicks = 0
    bCutsceneSeenPlaying = False
    NHV_Util.Log(NHV_Cfg_Debug, "Cutscene " + ActiveCutscene + ": player controls locked")
EndFunction

Function UnlockCutscene()
    If !bCutsceneLocked
        Return
    EndIf
    bCutsceneLocked = False
    If ActiveCutscene && ActiveCutscene != StandoffScene
        RecoverActiveCutscene()
    EndIf
    ; Mirror LockCutscene() exactly, so locks of other systems (werewolf camera, other mods) stay untouched.
    Game.EnablePlayerControls(True, True, False, False, True, True, True, False)
    NHV_Util.Log(NHV_Cfg_Debug, "Cutscene: player controls released")
EndFunction

; Every 2 s while the cutscene lock is on. Releases the player as soon as the scene is no longer playing
; (normally the End fragment has done that already) and stops a scene that hangs for more than 120 s, so a
; broken scene (e.g. a missing voice file) can never keep the player locked.
Function WatchStandoffCutscene()
    If !bCutsceneLocked
        Return
    EndIf
    iCutsceneTicks += 1
    Scene kWatched = StandoffScene
    If ActiveCutscene
        kWatched = ActiveCutscene
    EndIf
    Bool bPlaying = kWatched && kWatched.IsPlaying()
    If bPlaying
        bCutsceneSeenPlaying = True
    ElseIf !bCutsceneSeenPlaying && iCutsceneTicks < 3
        ; A scene reports IsPlaying a moment after Start(); give it up to ~6 s to get going.
        RegisterForSingleUpdate(2.0)
        Return
    ElseIf kWatched == VeiledPassageScene && !bVeiledPassageDone && !bPassageEndGrace
        ; Scene A just ended but its End fragment (door, scene B) may not have run yet: one grace tick.
        bPassageEndGrace = True
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    ; A locked player cannot defend himself: combat ends the cutscene like the timeout does.
    Bool bInCombat = Game.GetPlayer().IsInCombat()
    If bPlaying && iCutsceneTicks < 60 && !bInCombat
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    If bPlaying
        If bInCombat
            NHV_Util.Log(NHV_Cfg_Debug, "Cutscene watchdog: player in combat, stopping " + kWatched)
        Else
            NHV_Util.Log(NHV_Cfg_Debug, "Cutscene watchdog: " + kWatched + " still running after 120 s, stopping it")
        EndIf
        kWatched.Stop()
        If ActiveCutscene && ActiveCutscene != kWatched
            RegisterForSingleUpdate(2.0) ; the End fragment handed over to the next scene
            Return
        EndIf
    ElseIf kWatched == StandoffScene && !bStandoffSceneDone
        NHV_Util.Log(NHV_Cfg_Debug, "Standoff watchdog: scene not playing and never finished")
    EndIf
    UnlockCutscene()
EndFunction

; Undoes the freezing of script versions 9-16 in existing saves (Migrate step 17).
Function RepairFrozenActors()
    If !Q00
        Return
    EndIf
    FreezeStandoffActors(False)
    HoldStandoffActors(False)
    ; Veyra too, in case Q00 was stopped/reset in the dev save and her alias is empty.
    If VeyraRef
        VeyraRef.EnableAI(True)
        VeyraRef.SetDontMove(False)
        VeyraRef.EvaluatePackage()
    EndIf
    Int i = 0
    While i < iBystanderCount
        If StandoffBystanders[i]
            StandoffBystanders[i].EnableAI(True)
        EndIf
        i += 1
    EndWhile
    NHV_Util.Log(NHV_Cfg_Debug, "RepairFrozenActors: AI of Standoff actors and bystanders re-enabled")
EndFunction

; Brings the hidden random NPCs back.
Function RestoreStandoffBystanders()
    Int i = 0
    While i < iBystanderCount
        If StandoffBystanders[i]
            StandoffBystanders[i].Enable()
            StandoffBystanders[i].EnableAI(True)
            StandoffBystanders[i] = None
        EndIf
        i += 1
    EndWhile
    iBystanderCount = 0
EndFunction

Function StartQ00()
    Q00.Start()
    PrepareStandoff()
    Q00.SetStage(10)
    NHV_Util.Log(NHV_Cfg_Debug, "Q00 started")
EndFunction

; ---------------------------------------------------------------------------------------------------------
; Night Mother (Q00 stage 20). In Dawnstar the vanilla talking activator is not at her coffin, and the coffin
; itself (door NMCoffin01) can only be opened. So on stage 20 our own invisible talking activator
; NHV_NightMotherVoice (Night Mother voice type) is placed at the coffin; she calls the Listener once by idle dialogue
; (NHV_Q00_NM_Call, Say Once), and opening the coffin (Q00 alias NightMotherCoffin, NHV_NightMotherCoffinAliasScript) starts the
; conversation (NM_Gleaner topics). The activator is removed once the player enters the Sanctuary after stage 20.
; ---------------------------------------------------------------------------------------------------------
TalkingActivator Property NightMotherVoiceBase Auto
Topic Property NightMotherCallTopic Auto
ObjectReference Property NightMotherCoffinRef Auto

ObjectReference NightMotherVoiceRef
Bool bNightMotherCalled = False
Bool bNightMotherCallPending = False
Int iNightMotherCallTries = 0 ; unused since 26.09.2026, kept for saves
Bool bNightMotherBusy = False

; Stage 20 fragment, every entry into the Sanctuary and Migrate 21. Outside stage 20 the voice is removed.
Function UpdateNightMother()
    If !Q00 || !Q00.IsRunning() || Q00.GetStage() != 20
        RemoveNightMotherVoice()
        Return
    EndIf
    PrepareNightMother()
EndFunction

; Places the voice at the coffin (once) and makes sure the coffin alias is filled.
Function PrepareNightMother()
    If !Q00 || Q00.GetStage() != 20
        Return
    EndIf
    If !NightMotherVoiceBase || !NightMotherCallTopic || !NightMotherCoffinRef
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareNightMother: property missing (voice " + NightMotherVoiceBase + ", topic " + NightMotherCallTopic + ", coffin " + NightMotherCoffinRef + ")")
        Return
    EndIf
    ; Which coffin stands in Dawnstar depends on how the vanilla questline moved them (26.09.2026 test: opening
    ; the coffin never reached the alias on 074766). The alias follows the coffin that is really there.
    ObjectReference kCoffinRef = FindNightMotherCoffin()
    ReferenceAlias kCoffin = Q00.GetAlias(4) as ReferenceAlias
    If kCoffin && kCoffin.GetReference() != kCoffinRef
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareNightMother: coffin alias was on " + kCoffin.GetReference() + ", now on " + kCoffinRef)
        kCoffin.ForceRefTo(kCoffinRef)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "PrepareNightMother: coffin alias already on " + kCoffinRef)
    EndIf
    If !NightMotherVoiceRef && !bNightMotherBusy
        bNightMotherBusy = True
        NightMotherVoiceRef = kCoffinRef.PlaceAtMe(NightMotherVoiceBase, 1, True, False)
        bNightMotherBusy = False
        NHV_Util.Log(NHV_Cfg_Debug, "Night Mother voice placed at her coffin: " + NightMotherVoiceRef)
    EndIf
    ; The call itself (NHV_Q00_NM_Call) is idle dialogue of this activator (Say Once), like the vanilla Night
    ; Mother's idle lines in DBRecurring: Say() from a talking activator never showed a line (26.09.2026).
EndFunction

; The Night Mother's coffin (door NMCoffin01) that is enabled and stands in the Dawnstar Sanctuary: the Dawnstar
; one (property, 074766) or one of the two Falkreath coffins the questline may have moved (040166 DB10CoffinRef,
; 050FE4 NMCoffinRef). Falls back to the property. Needs the Sanctuary loaded to compare cells.
ObjectReference Function FindNightMotherCoffin()
    Cell kSanctuary = None
    If DawnstarAnchorRef
        kSanctuary = DawnstarAnchorRef.GetParentCell()
    EndIf
    If kSanctuary
        If NightMotherCoffinRef && !NightMotherCoffinRef.IsDisabled() && NightMotherCoffinRef.GetParentCell() == kSanctuary
            Return NightMotherCoffinRef
        EndIf
        ObjectReference kRef = Game.GetFormFromFile(0x040166, "Skyrim.esm") as ObjectReference
        If kRef && !kRef.IsDisabled() && kRef.GetParentCell() == kSanctuary
            Return kRef
        EndIf
        kRef = Game.GetFormFromFile(0x050FE4, "Skyrim.esm") as ObjectReference
        If kRef && !kRef.IsDisabled() && kRef.GetParentCell() == kSanctuary
            Return kRef
        EndIf
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "FindNightMotherCoffin: no enabled coffin found in the Sanctuary, using " + NightMotherCoffinRef)
    Return NightMotherCoffinRef
EndFunction

; Unused since 26.09.2026 (the call is idle dialogue now); kept so saves with a pending update stay valid.
; OnUpdate: the call, once. She speaks from her coffin like any voice in the room, so it waits (1 s steps, only
; while the player is in the Sanctuary on stage 20) until he is close enough to hear it. Spoken "in the player's
; head" the line never showed (26.09.2026): the speaker condition of the call INFO did not match there.
Function CallFromNightMother()
    If bNightMotherCalled || !NightMotherVoiceRef || !NightMotherCallTopic || !Q00 || Q00.GetStage() != 20
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer.IsInLocation(DawnstarSanctuaryLocation)
        Return ; OnEnterDawnstarSanctuary arms it again
    EndIf
    If !NightMotherVoiceRef.Is3DLoaded() || NightMotherVoiceRef.GetDistance(kPlayer) > 1500.0
        iNightMotherCallTries += 1
        If iNightMotherCallTries == 30
            NHV_Util.Log(NHV_Cfg_Debug, "CallFromNightMother: still waiting, 3D=" + NightMotherVoiceRef.Is3DLoaded() + ", distance=" + NightMotherVoiceRef.GetDistance(kPlayer))
        EndIf
        bNightMotherCallPending = True
        RegisterForSingleUpdate(1.0)
        Return
    EndIf
    If bNightMotherCalled
        Return ; the coffin was opened meanwhile
    EndIf
    bNightMotherCalled = True
    NightMotherVoiceRef.Say(NightMotherCallTopic)
    NHV_Util.Log(NHV_Cfg_Debug, "Night Mother calls the Listener (distance " + NightMotherVoiceRef.GetDistance(kPlayer) + ")")
EndFunction

; NHV_NightMotherCoffinAliasScript: the player opened the coffin (alias event, a short wait is fine here).
Function OnNightMotherCoffinActivated()
    If !Q00 || !Q00.IsRunning() || Q00.GetStage() != 20
        NHV_Util.Log(NHV_Cfg_Debug, "OnNightMotherCoffinActivated: Q00 not on stage 20, ignored")
        Return
    EndIf
    bNightMotherCalled = True ; legacy flags, only read by the unused CallFromNightMother()
    bNightMotherCallPending = False
    PrepareNightMother()
    If !NightMotherVoiceRef
        NHV_Util.Log(NHV_Cfg_Debug, "OnNightMotherCoffinActivated: no Night Mother voice")
        Return
    EndIf
    Int i = 0
    While !NightMotherVoiceRef.Is3DLoaded() && i < 10
        Utility.Wait(0.1)
        i += 1
    EndWhile
    NightMotherVoiceRef.Activate(Game.GetPlayer())
    NHV_Util.Log(NHV_Cfg_Debug, "Night Mother coffin opened, conversation started (voice 3D loaded=" + NightMotherVoiceRef.Is3DLoaded() + ")")
EndFunction

Function RemoveNightMotherVoice()
    If NightMotherVoiceRef
        NightMotherVoiceRef.Disable()
        NightMotherVoiceRef.Delete()
        NightMotherVoiceRef = None
        NHV_Util.Log(NHV_Cfg_Debug, "Night Mother voice removed")
    EndIf
    bNightMotherCalled = False
    bNightMotherCallPending = False
EndFunction

; ---------------------------------------------------------------------------------------------------------
; Q00 stage 40 -> 50 (E24): the passage is hidden by an old veil, not buried. The family gathers at the wall;
; when the player comes near, a cutscene like the Standoff runs (controls locked, watchdog): scene A
; NHV_Scn_Q00_02VeiledPassage (Veyra sees through the illusion), the door appears, scene B
; NHV_Scn_Q00_03EnterDeep (the family at the door), then everybody is moved into the Deep Sanctuary, stage 50.
; Positions are provisional (developer, 26.09.2026: exact placement later in the CK).
; ---------------------------------------------------------------------------------------------------------
Scene Property VeiledPassageScene Auto
Scene Property EnterDeepScene Auto
ObjectReference Property DeepSanctuaryEntryMarker Auto ; NHV_Mk_Q00_DeepSanctuaryEntry (door target marker)
; Walk targets in alias order (0 Veyra, 1 Nazir, 2 Babette, 3 Cicero), targets of the alias packages
; NHV_Pkg_Q00_<Name>WalkVeil (stage 40) and NHV_Pkg_Q00_<Name>WalkMemorial (stage 50-60). Developer 27.09.2026:
; the family walks to the wall itself, both in the Sanctuary and in the Deep Sanctuary.
ObjectReference[] Property VeilMarkers Auto
ObjectReference[] Property MemorialMarkers Auto

Scene ActiveCutscene ; the cutscene the lock/watchdog belongs to; None = the Standoff
Bool bPassagePollPending = False
Bool bVeiledPassageStarted = False
Bool bVeiledPassageDone = False
Bool bPassagePlacePending = False
Bool bCutsceneSeenPlaying = False
Bool bPassageEndGrace = False
Int iGatherTicks = 0 ; polls spent waiting for the family to arrive at its markers

; Stage 40 fragment: no waiting in the fragment, the family is placed in the next update.
Function BeginVeiledPassage()
    If bVeiledPassageDone || !Q00 || Q00.GetStage() != 40
        Return
    EndIf
    bPassagePlacePending = True
    RegisterForSingleUpdate(0.5)
EndFunction

Function PlaceVeiledPassageFamily()
    If bVeiledPassageDone || !Q00 || Q00.GetStage() != 40
        Return
    EndIf
    If !DawnstarAnchorRef
        NHV_Util.Log(NHV_Cfg_Debug, "PlaceVeiledPassageFamily: DawnstarAnchorRef not set, falling back to the door")
        RecoverVeiledPassage()
        Return
    EndIf
    EnsureSealedPassageState()
    If VeilMarkers.Length >= 4
        EnsureFamilyAliases()
        GatherFamily(VeilMarkers)
        NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage: family walks to the wall")
        ArmVeiledPassagePoll()
        Return
    EndIf
    ; Fallback without walk markers: teleport.
    ; E25: load door at 3200/3552 (see SpawnPassageRubble); the corridor lies at +Y (door moved 27.09.2026), the
    ; family faces the door (angle ~180). Provisional positions (developer: exact placement later).
    If VeyraRef && !VeyraRef.IsDead()
        VeyraRef.MoveTo(DawnstarAnchorRef)
        VeyraRef.SetPosition(3200.0, 3700.0, 5664.0)
        VeyraRef.SetAngle(0.0, 0.0, 180.0)
        VeyraRef.EvaluatePackage()
    EndIf
    PlaceStandoffActor(1, 0x01C3AD, 3127.0, 3765.0, 5664.0, 150.0)
    PlaceStandoffActor(2, 0x01D4BC, 3272.0, 3765.0, 5664.0, 210.0)
    Actor kFalkreathCicero = Game.GetFormFromFile(0x01E64A, "Skyrim.esm") as Actor
    If !(kFalkreathCicero && kFalkreathCicero.IsDead())
        PlaceStandoffActor(3, 0x09BCB0, 3200.0, 3850.0, 5664.0, 180.0)
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage: family gathered at the wall")
    ArmVeiledPassagePoll()
EndFunction

Function ArmVeiledPassagePoll()
    If !bVeiledPassageStarted && !bVeiledPassageDone && Q00 && Q00.IsRunning() && Q00.GetStage() == 40
        iGatherTicks = 0
        bPassagePollPending = True
        RegisterForSingleUpdate(2.0)
    EndIf
EndFunction

; OnUpdate, every 2 s while the player is in the Sanctuary on stage 40, until he comes near the wall.
Function PollVeiledPassage()
    If bVeiledPassageStarted || bVeiledPassageDone || !Q00 || Q00.GetStage() != 40
        Return
    EndIf
    If !VeiledPassageScene || !RubbleRef
        NHV_Util.Log(NHV_Cfg_Debug, "PollVeiledPassage: scene " + VeiledPassageScene + " / rubble " + RubbleRef + " missing, falling back to the door")
        RecoverVeiledPassage()
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If !kPlayer.IsInLocation(DawnstarSanctuaryLocation)
        Return ; OnEnterDawnstarSanctuary arms it again
    EndIf
    Bool bNear = RubbleRef.GetDistance(kPlayer) < 700.0
    If bNear && !FamilyGathered(VeilMarkers) && iGatherTicks < 8
        iGatherTicks += 1 ; the player is faster: wait up to ~16 s for the family, then place the rest
        bPassagePollPending = True
        RegisterForSingleUpdate(2.0)
    ElseIf bNear
        bVeiledPassageStarted = True
        EnsureFamilyAliases()
        SnapFamily(VeilMarkers)
        ; A vanilla Sanctuary scene holding Nazir or Babette would keep ours from getting them.
        StopOtherScenes()
        ActiveCutscene = VeiledPassageScene
        LockCutscene()
        VeiledPassageScene.Start()
        NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage scene started")
        RegisterForSingleUpdate(2.0) ; watchdog
    Else
        bPassagePollPending = True
        RegisterForSingleUpdate(2.0)
    EndIf
EndFunction

; End fragment of NHV_Scn_Q00_02VeiledPassage (also runs when the watchdog stops it).
Function OnVeiledPassageSceneEnd()
    If bVeiledPassageDone
        Return
    EndIf
    bVeiledPassageDone = True
    Bool bWasLocked = bCutsceneLocked
    ; Hand the lock over to scene B first (no external call before it), so the watchdog never sees "nothing playing".
    ActiveCutscene = EnterDeepScene
    iCutsceneTicks = 0
    bCutsceneSeenPlaying = False
    NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage scene finished, the veil falls")
    If !bWasLocked || Game.GetPlayer().IsInCombat() || !EnterDeepScene
        ; Aborted (watchdog, combat) or no second scene: just the door, the player walks through himself.
        ActiveCutscene = None
        SpawnPassageDoor()
        UnlockCutscene()
        Return
    EndIf
    SpawnPassageDoor()
    EnterDeepScene.Start()
    NHV_Util.Log(NHV_Cfg_Debug, "Enter-deep scene started")
EndFunction

; End fragment of NHV_Scn_Q00_03EnterDeep.
Function OnEnterDeepSceneEnd()
    FinishVeiledPassage()
EndFunction

; Everybody through the door together: player and family into the Deep Sanctuary, stage 50, controls back.
Function FinishVeiledPassage()
    ActiveCutscene = None
    Actor kPlayer = Game.GetPlayer()
    If !Q00 || Q00.GetStage() != 40 || !DeepSanctuaryEntryMarker || kPlayer.IsInCombat() || !kPlayer.IsInLocation(DawnstarSanctuaryLocation)
        ; The door stands; the player can walk through (NHV_SealedPassageDoorScript sets stage 50).
        UnlockCutscene()
        Return
    EndIf
    ; The marker faces +Y into the room (see NHV_SealedPassageDoorScript); the family spreads out ahead.
    ; Stage first: the moved actors evaluate their packages at once and walk on to the memorial wall.
    Q00.SetStage(50)
    MovePassageActor(0, 0.0, 320.0)
    MovePassageActor(1, -10.0, 270.0) ; offsets checked against the exported navmesh (27.09.2026)
    MovePassageActor(2, 40.0, 250.0)
    MovePassageActor(3, 0.0, 420.0)
    kPlayer.MoveTo(DeepSanctuaryEntryMarker, 0.0, 128.0, 8.0, True)
    UnlockCutscene()
    NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage: family entered the Deep Sanctuary")
    OnEnterDeepSanctuary() ; arms the memorial poll
EndFunction

; The cutscene did not run to its end (did not start, was stopped, or a load cut it off): the veil falls anyway,
; so stage 40 can always be finished through the door.
Function RecoverVeiledPassage()
    ActiveCutscene = None
    If PassageDoorRef
        bVeiledPassageDone = True
        Return
    EndIf
    bVeiledPassageDone = True
    NHV_Util.Log(NHV_Cfg_Debug, "Veiled passage: cutscene did not finish, door placed as fallback")
    SpawnPassageDoor()
EndFunction

Function MovePassageActor(Int aiAlias, Float afX, Float afY)
    If !Q00 || !DeepSanctuaryEntryMarker
        Return
    EndIf
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    If !kAlias
        Return
    EndIf
    Actor kActor = kAlias.GetActorReference()
    If kActor && !kActor.IsDead()
        kActor.MoveTo(DeepSanctuaryEntryMarker, afX, afY, 8.0, True)
        kActor.EvaluatePackage()
    EndIf
EndFunction

; ---------------------------------------------------------------------------------------------------------
; Q00 stage 50 -> 60 -> 100: the Memorial Wall in the Deep Sanctuary. Coming near the wall (spot given by the
; developer 27.09.2026, provisional) sets stage 60 and plays scene C NHV_Scn_Q00_05Memorial (locked). The
; Astrid choice is free dialogue with Veyra (Memorial01-03); its fragments call OnMemorialChosen(), which plays
; scene D NHV_Scn_Q00_06Contract (Nazir's reaction, the first candidate); its end sets stage 100.
; Not yet: the ledger book (text not transferred) and the Q01 start (Q01 does not exist yet).
; ---------------------------------------------------------------------------------------------------------
Scene Property MemorialScene Auto
Scene Property ContractScene Auto
; Memorial Wall plaques (27.09.2026), initially disabled refs in the Deep Sanctuary: Festus, Gabriella, Arnbjorn,
; Veezara; Astrid by NHV_AstridMemorial (1 with the others, 2 none, 3 beneath, smaller).
ObjectReference[] Property MemorialPlaques Auto
ObjectReference Property AstridPlaque Auto
ObjectReference Property AstridPlaqueSmall Auto
GlobalVariable Property NHV_AstridMemorial Auto
Book Property GleanersLedger Auto ; The Gleaner's Ledger, Veyra hands it over at the end of Q00

Bool bMemorialPollPending = False
Bool bMemorialStarted = False
Bool bContractStarted = False
Bool bContractDone = False

Function ArmMemorialPoll()
    If !bMemorialStarted && Q00 && Q00.IsRunning() && Q00.GetStage() == 50
        ; Family members still outside (player went through the door alone) join; the others walk there.
        GatherFamily(MemorialMarkers)
        If !bMemorialPollPending
            iGatherTicks = 0 ; entering again does not extend the wait
        EndIf
        bMemorialPollPending = True
        RegisterForSingleUpdate(2.0)
    EndIf
EndFunction

; OnUpdate, every 2 s while the player is in the Deep Sanctuary on stage 50, until he comes near the wall.
Function PollMemorial()
    If bMemorialStarted || !Q00 || Q00.GetStage() != 50 || !DeepSanctuaryEntryMarker
        Return
    EndIf
    Actor kPlayer = Game.GetPlayer()
    If kPlayer.GetParentCell() != DeepSanctuaryEntryMarker.GetParentCell()
        Return ; OnEnterDeepSanctuary arms it again
    EndIf
    Float fDX = kPlayer.GetPositionX() + 5232.0 ; in front of the plaques at -5232/-1728 (developer 27.09.2026)
    Float fDY = kPlayer.GetPositionY() + 1690.0
    Bool bFar = fDX * fDX + fDY * fDY > 202500.0 ; 450 units squared (no constant expression: the compiler folds it with the system locale, 27.09.2026)
    Bool bWait = bFar
    If !bFar && !FamilyGathered(MemorialMarkers) && iGatherTicks < 8
        iGatherTicks += 1 ; wait up to ~16 s for the family, then place the rest
        bWait = True
    EndIf
    If bWait
        bMemorialPollPending = True
        RegisterForSingleUpdate(2.0)
        Return
    EndIf
    bMemorialStarted = True
    Q00.SetStage(60)
    If MemorialMarkers.Length >= 4
        EnsureFamilyAliases()
        SnapFamily(MemorialMarkers)
    Else
        PlaceMemorialActor(0, -5212.0, -1620.0, 190.5)
        PlaceMemorialActor(1, -5320.0, -1625.0, 139.5)
        PlaceMemorialActor(2, -5220.0, -1550.0, 183.9)
        PlaceMemorialActor(3, -5195.0, -1485.0, 188.7)
    EndIf
    If !MemorialScene
        NHV_Util.Log(NHV_Cfg_Debug, "PollMemorial: MemorialScene not set, the choice is still open in dialogue")
        Return
    EndIf
    StopOtherScenes()
    ActiveCutscene = MemorialScene
    LockCutscene()
    MemorialScene.Start()
    NHV_Util.Log(NHV_Cfg_Debug, "Memorial scene started")
    RegisterForSingleUpdate(2.0) ; watchdog
EndFunction

; Plaques at -5232/-1728 (developer 27.09.2026), floor z ~-16, target z 0; the family faces them.
; SnapFamily uses the markers.
Function PlaceMemorialActor(Int aiAlias, Float afX, Float afY, Float afAngle)
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    If !kAlias
        Return
    EndIf
    Actor kActor = kAlias.GetActorReference()
    If kActor && !kActor.IsDead() && !kActor.IsDisabled()
        ; MoveTo with offsets from the entry marker: SetPosition left the actors invisible here (test 27.09.2026).
        ; Target z 0 = just above the floor in front of the plaques (navmesh -16 there; -240 was the wall object's origin).
        Float fOX = afX - DeepSanctuaryEntryMarker.GetPositionX()
        Float fOY = afY - DeepSanctuaryEntryMarker.GetPositionY()
        Float fOZ = 0.0 - DeepSanctuaryEntryMarker.GetPositionZ()
        kActor.MoveTo(DeepSanctuaryEntryMarker, fOX, fOY, fOZ, False)
        kActor.SetAngle(0.0, 0.0, afAngle)
        kActor.EvaluatePackage()
    EndIf
EndFunction

; ---------------------------------------------------------------------------------------------------------
; Family walk (developer, 27.09.2026): the alias packages walk the family to its markers; these helpers only
; send them off, check arrival and place the stragglers when the cutscene starts.
; ---------------------------------------------------------------------------------------------------------
Actor Function GetFamilyActor(Int aiAlias)
    If !Q00
        Return None
    EndIf
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    If !kAlias
        Return None
    EndIf
    Actor kActor = kAlias.GetActorReference()
    If kActor && !kActor.IsDead() && !kActor.IsDisabled()
        Return kActor
    EndIf
    Return None
EndFunction

; What PlaceStandoffActor does for the aliases, without the move: fill an empty alias, clear a dead actor (a
; scene does not start with a dead actor among its aliases), no Cicero once the Falkreath Cicero is dead.
Function EnsureFamilyAliases()
    EnsureFamilyAlias(0, 0)
    EnsureFamilyAlias(1, 0x01C3AD)
    EnsureFamilyAlias(2, 0x01D4BC)
    Actor kFalkreathCicero = Game.GetFormFromFile(0x01E64A, "Skyrim.esm") as Actor
    If kFalkreathCicero && kFalkreathCicero.IsDead()
        ReferenceAlias kCicero = Q00.GetAlias(3) as ReferenceAlias
        If kCicero
            kCicero.Clear()
        EndIf
    Else
        EnsureFamilyAlias(3, 0x09BCB0)
    EndIf
EndFunction

Function EnsureFamilyAlias(Int aiAlias, Int aiRefFormID)
    If !Q00
        Return
    EndIf
    ReferenceAlias kAlias = Q00.GetAlias(aiAlias) as ReferenceAlias
    If !kAlias
        Return
    EndIf
    Actor kActor = kAlias.GetActorReference()
    If !kActor && aiRefFormID
        kActor = Game.GetFormFromFile(aiRefFormID, "Skyrim.esm") as Actor
        If kActor
            kAlias.ForceRefTo(kActor)
        EndIf
    EndIf
    If kActor && kActor.IsDead()
        kAlias.Clear()
        NHV_Util.Log(NHV_Cfg_Debug, "EnsureFamilyAlias: alias " + aiAlias + " actor is dead, alias cleared")
    EndIf
EndFunction

; Sends every family member to its marker. Someone outside the marker's cell is moved there (no walk across Skyrim
; or through a door without navmesh link); the rest walk.
Function GatherFamily(ObjectReference[] akMarkers)
    If akMarkers.Length < 4
        Return
    EndIf
    Int i = 0
    While i < 4
        Actor kActor = GetFamilyActor(i)
        If kActor && akMarkers[i]
            If kActor.GetParentCell() != akMarkers[i].GetParentCell()
                kActor.MoveTo(akMarkers[i])
            EndIf
            kActor.EvaluatePackage()
        EndIf
        i += 1
    EndWhile
EndFunction

; True when every living family member stands within 250 units of its marker.
Bool Function FamilyGathered(ObjectReference[] akMarkers)
    If akMarkers.Length < 4
        Return True
    EndIf
    Int i = 0
    While i < 4
        Actor kActor = GetFamilyActor(i)
        If kActor && akMarkers[i] && (kActor.GetParentCell() != akMarkers[i].GetParentCell() || kActor.GetDistance(akMarkers[i]) > 250.0)
            Return False
        EndIf
        i += 1
    EndWhile
    Return True
EndFunction

; Cutscene start: only someone in another cell is moved onto the marker; in the same cell everybody stays where the
; walk ended and turns to the marker's heading (test 27.09.2026: a MoveTo onto a marker off the navmesh made Veyra
; and Babette vanish; the real cause were memorial markers below the floor, fixed in v28). Someone stuck more than
; 1000 units away is still moved.
Function SnapFamily(ObjectReference[] akMarkers)
    If akMarkers.Length < 4
        Return
    EndIf
    Int i = 0
    While i < 4
        Actor kActor = GetFamilyActor(i)
        If kActor && akMarkers[i]
            Float fDist = kActor.GetDistance(akMarkers[i])
            If kActor.GetParentCell() != akMarkers[i].GetParentCell() || fDist > 1000.0
                kActor.MoveTo(akMarkers[i]) ; other cell, or stuck far away after the gather timeout
            Else
                If fDist > 250.0
                    NHV_Util.Log(NHV_Cfg_Debug, "SnapFamily: alias " + i + " stopped " + fDist + " units from its marker")
                EndIf
                kActor.SetAngle(0.0, 0.0, akMarkers[i].GetAngleZ())
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

; End fragment of NHV_Scn_Q00_05Memorial: the choice follows in free dialogue.
Function OnMemorialSceneEnd()
    NHV_Util.Log(NHV_Cfg_Debug, "Memorial scene finished, Astrid choice open")
    If ActiveCutscene == MemorialScene
        ActiveCutscene = None
        UnlockCutscene()
    EndIf
EndFunction

; Fragments of the Astrid choice (TIF__02000819/0821/0823), after NHV_AstridMemorial is set.
Function OnMemorialChosen()
    If bContractStarted || !Q00 || Q00.GetStage() != 60
        Return
    EndIf
    bContractStarted = True
    ShowMemorialPlaques()
    If !ContractScene
        FinishQ00Contract()
        Return
    EndIf
    StopOtherScenes()
    ActiveCutscene = ContractScene
    LockCutscene()
    ContractScene.Start()
    NHV_Util.Log(NHV_Cfg_Debug, "Contract scene started")
    RegisterForSingleUpdate(2.0) ; watchdog
EndFunction

; End fragment of NHV_Scn_Q00_06Contract.
Function OnContractSceneEnd()
    FinishQ00Contract()
EndFunction

Function FinishQ00Contract()
    If bContractDone
        Return
    EndIf
    bContractDone = True
    ActiveCutscene = None
    UnlockCutscene()
    ShowMemorialPlaques()
    GiveLedger()
    If Q00 && Q00.GetStage() < 100
        Q00.SetStage(100)
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Q00 finished (stage 100); Q01 start still to come")
EndFunction

; Idempotent: enabling an enabled ref does nothing.
Function ShowMemorialPlaques()
    Int i = 0
    While i < MemorialPlaques.Length
        If MemorialPlaques[i]
            MemorialPlaques[i].Enable()
        EndIf
        i += 1
    EndWhile
    Int iAstrid = 0
    If NHV_AstridMemorial
        iAstrid = NHV_AstridMemorial.GetValueInt()
    EndIf
    If iAstrid == 1 && AstridPlaque
        AstridPlaque.Enable()
    ElseIf iAstrid == 3 && AstridPlaqueSmall
        AstridPlaqueSmall.Enable()
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Memorial plaques shown (Astrid choice " + iAstrid + ")")
EndFunction

Bool bLedgerGiven = False

Function GiveLedger()
    If bLedgerGiven
        Return
    EndIf
    If !GleanersLedger
        NHV_Util.Log(NHV_Cfg_Debug, "GiveLedger: GleanersLedger not set")
        Return
    EndIf
    bLedgerGiven = True
    Game.GetPlayer().AddItem(GleanersLedger, 1)
EndFunction

; A cutscene lock was released without the scene's End fragment (did not start, watchdog, combat, load).
Function RecoverActiveCutscene()
    Scene kScene = ActiveCutscene
    ActiveCutscene = None
    If kScene == VeiledPassageScene || kScene == EnterDeepScene
        RecoverVeiledPassage()
    ElseIf kScene == ContractScene
        NHV_Util.Log(NHV_Cfg_Debug, "Contract scene did not finish, stage 100 set as fallback")
        FinishQ00Contract()
    EndIf
    ; MemorialScene: nothing to recover, the Astrid choice is open in dialogue anyway.
EndFunction

; ---------------------------------------------------------------------------------------------------------
; E25: real load door to the Deep Sanctuary (NHV_DeepSanctuaryDoorRef in DawnstarSanctuary, initially disabled,
; linked to the Deep Sanctuary exit door ExitDoorRef). Enabled by SpawnPassageDoor() at the end of the stage 40
; cutscene; NPCs path through it once the navmesh of both cells is finalized.
; ---------------------------------------------------------------------------------------------------------
ObjectReference Property DeepSanctuaryDoorRef Auto
Location Property DeepSanctuaryLocation Auto

; Migrate 24: remove the script door / script return door of earlier builds and move the rubble.
Function MigrateToLoadDoor()
    If !DeepSanctuaryDoorRef
        NHV_Util.Log(NHV_Cfg_Debug, "MigrateToLoadDoor: DeepSanctuaryDoorRef missing")
        Return
    EndIf
    If ReturnDoorRef
        ReturnDoorRef.Disable()
        ReturnDoorRef.Delete()
        ReturnDoorRef = None
    EndIf
    If ExitDoorRef
        ExitDoorRef.Enable()
    EndIf
    Bool bOpen = bVeiledPassageDone || (Q00 && Q00.GetStage() >= 50)
    If PassageDoorRef && PassageDoorRef != DeepSanctuaryDoorRef
        PassageDoorRef.Disable()
        PassageDoorRef.Delete()
        PassageDoorRef = None
    EndIf
    If bOpen
        If RubbleRef
            RubbleRef.Disable()
            RubbleRef.Delete()
            RubbleRef = None
        EndIf
        DeepSanctuaryDoorRef.Enable()
        PassageDoorRef = DeepSanctuaryDoorRef
    ElseIf RubbleRef
        ; Rubble of an earlier build stands at the old wall: put it on the load door, and a family already
        ; gathered at the old wall (stage 40 before the veil) moves along.
        RubbleRef.SetPosition(3200.0, 3552.0, 5664.0)
        RubbleRef.SetAngle(0.0, 0.0, 180.0)
        If Q00 && Q00.IsRunning() && Q00.GetStage() == 40 && !bVeiledPassageStarted
            PlaceVeiledPassageFamily()
        EndIf
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Migrated to the Deep Sanctuary load door (open=" + bOpen + ")")
EndFunction
