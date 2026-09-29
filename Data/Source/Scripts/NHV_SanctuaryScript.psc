Scriptname NHV_SanctuaryScript extends Quest
{Attached to NHV_Sys_Sanctuary (000809). Runs the ordered Lucien summoning sequence of the ambient Sanctuary
dialogue (docs/dialogue/Q00-Zweifel-Lucien-2026-09-29.md): the "call" scene (Veyra, LineIDs NHV_SYS_LUC_03-04), then
the Q00/summon logic in NHV_CoreScript, then the "arrival" scene (Lucien, NHV_SYS_LUC_05-06). Holds no dialogue
logic of its own: the topics are plain topics of this quest. M1.5.}

NHV_CoreScript Property Core Auto
GlobalVariable Property NHV_Cfg_Debug Auto
Quest Property Q00 Auto                 ; NHV_Q00_ShadowAtTheDoor
ReferenceAlias Property VeyraAlias Auto ; alias 5, filled at runtime from Core.GetVeyraActor()
ReferenceAlias Property LucienAlias Auto ; alias 4, forced reference NHV_Ref_Sys_Lucien
Scene Property SummonScene Auto         ; NHV_Scn_Sys_LucienCall
Scene Property ArrivalScene Auto        ; NHV_Scn_Sys_LucienArrival

Bool bSummonPending = False   ; call scene started, summon not yet done
Bool bArrivalPending = False  ; Lucien was summoned, arrival scene still to play
Bool bArrivalPlayed = False   ; the arrival scene ran once (never again, also not after loading)
Int iTicks = 0

; End fragment of the accept answer (NHV_Sys_Veyra_DoubtAccepted): Veyra calls him in the call scene first.
Function StartSummonCall()
    If !IsRunning()
        bSummonPending = True ; quest not running: no scene, no timer - summon directly
        FinishSummonCall()
        Return
    EndIf
    If bSummonPending
        If iTicks > 3 && (!SummonScene || !SummonScene.IsPlaying())
            FinishSummonCall() ; a stale pending flag (chain lost) must not block the summoning
        EndIf
        Return
    EndIf
    If !Core || !SummonScene || !VeyraAlias
        NHV_Util.Log(NHV_Cfg_Debug, "StartSummonCall: property missing, summoning without scene")
        bSummonPending = True
        FinishSummonCall()
        Return
    EndIf
    If Core.IsLucienSummoned()
        If Q00 && Q00.GetStage() == 80
            Core.OnDoubtAccepted() ; already summoned (console/test save) but Q00 still waits: finish it
        EndIf
        Return
    EndIf
    Actor kVeyra = Core.GetVeyraActor()
    If !kVeyra || kVeyra.IsDead() || kVeyra.IsDisabled() || !kVeyra.Is3DLoaded()
        NHV_Util.Log(NHV_Cfg_Debug, "StartSummonCall: Veyra unavailable, summoning without scene")
        bSummonPending = True
        FinishSummonCall()
        Return
    EndIf
    VeyraAlias.ForceRefTo(kVeyra)
    bSummonPending = True
    iTicks = 0
    SummonScene.Start()
    RegisterForSingleUpdate(2.0) ; watchdog: a scene that never reports its end must not swallow the summoning
EndFunction

; End fragment of the call scene (and the watchdog below). Does the actual work in the Core: at Q00 stage 80 the
; accept path (finish Q00, ledger, Q01, summon), later only the summoning. Idempotent through bSummonPending.
Function FinishSummonCall()
    If !bSummonPending
        Return
    EndIf
    bSummonPending = False
    If VeyraAlias
        VeyraAlias.Clear()
    EndIf
    If !Core
        Return
    EndIf
    If Q00 && Q00.GetStage() == 80
        Core.OnDoubtAccepted()
    Else
        Core.OnDoubtRetryAccepted()
    EndIf
    If !bArrivalPlayed
        bArrivalPending = True
        iTicks = 0
        RegisterForSingleUpdate(4.0) ; let the ghost shader run before he speaks
    EndIf
EndFunction

; Read by the decline fragments: a running call means the player already accepted.
Bool Function IsSummonPending()
    Return bSummonPending
EndFunction

Event OnUpdate()
    If bSummonPending
        iTicks += 1
        If SummonScene && SummonScene.IsPlaying() && iTicks < 45
            RegisterForSingleUpdate(2.0)
        ElseIf iTicks <= 3 && SummonScene
            RegisterForSingleUpdate(2.0) ; Start() lags: IsPlaying() reads False for a few ticks
        Else
            If SummonScene && SummonScene.IsPlaying()
                SummonScene.Stop() ; ran too long: stop it so the arrival cannot overlap
            EndIf
            FinishSummonCall() ; ended without its fragment (save/load, combat), or ran too long
        EndIf
        Return
    EndIf
    If bArrivalWatch
        ; Arrival scene watchdog (ingame test 29.09.2026: the scene started but never ended and blocked all
        ; dialogue with Lucien). Give it ~16 s, then stop it so the player can talk to him.
        iArrivalTicks += 1
        If ArrivalScene && (ArrivalScene.IsPlaying() || iArrivalTicks <= 2) && iArrivalTicks < 8
            RegisterForSingleUpdate(2.0)
        Else
            If ArrivalScene && ArrivalScene.IsPlaying()
                ArrivalScene.Stop()
                NHV_Util.Log(NHV_Cfg_Debug, "Lucien arrival scene stopped by watchdog")
            EndIf
            bArrivalWatch = False
        EndIf
        Return
    EndIf
    If bArrivalPending
        TryArrival()
    EndIf
EndEvent

Bool bArrivalWatch = False
Int iArrivalTicks = 0

; Called from NHV_CoreScript.EnsureSanctuaryQuest() on every load (Maintenance): refills what an old save lacks
; (Lucien's alias was added after the quest first ran in test saves) and re-arms the chain if it was lost.
Function Resume()
    If LucienAlias && !LucienAlias.GetReference() && Core && Core.LucienRef
        LucienAlias.ForceRefTo(Core.LucienRef)
    EndIf
    If ArrivalScene && ArrivalScene.IsPlaying() && bArrivalPlayed
        ArrivalScene.Stop() ; a save made while the arrival scene hung
        NHV_Util.Log(NHV_Cfg_Debug, "Resume: hanging Lucien arrival scene stopped")
    EndIf
    bArrivalWatch = False ; the watchdog chain does not survive a load
    If bSummonPending || bArrivalPending
        RegisterForSingleUpdate(2.0)
    EndIf
EndFunction

; Called by NHV_Sys_LucienAliasScript when the player activates Lucien: once the arrival was played, a scene still
; holding him only blocks the player's topics.
Function ReleaseArrivalScene()
    If bArrivalPlayed && ArrivalScene && ArrivalScene.IsPlaying()
        ArrivalScene.Stop()
        bArrivalWatch = False
        NHV_Util.Log(NHV_Cfg_Debug, "Lucien activated: hanging arrival scene stopped")
    EndIf
EndFunction

Function TryArrival()
    If bArrivalPlayed || !bArrivalPending
        bArrivalPending = False
        Return
    EndIf
    Actor kLucien = None
    If LucienAlias
        kLucien = LucienAlias.GetActorRef()
    EndIf
    If LucienAlias && !kLucien && Core && Core.LucienRef
        LucienAlias.ForceRefTo(Core.LucienRef)
        kLucien = LucienAlias.GetActorRef()
    EndIf
    If !kLucien || !ArrivalScene || !Core || !Core.IsLucienSummoned()
        NHV_Util.Log(NHV_Cfg_Debug, "TryArrival: Lucien alias, arrival scene or summon state missing, skipped")
        bArrivalPending = False
        Return
    EndIf
    If !kLucien.Is3DLoaded()
        ; Lucien lives in the Deep Sanctuary: if the call was spoken elsewhere he arrives (speaks) once the player
        ; is there. Slow poll, ends with the arrival scene; Resume() re-arms it after loading.
        RegisterForSingleUpdate(5.0)
        Return
    EndIf
    bArrivalPending = False
    bArrivalPlayed = True
    ArrivalScene.Start()
    NHV_Util.Log(NHV_Cfg_Debug, "Lucien arrival scene started")
    bArrivalWatch = True
    iArrivalTicks = 0
    RegisterForSingleUpdate(2.0)
EndFunction
