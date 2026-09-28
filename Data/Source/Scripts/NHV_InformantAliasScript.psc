Scriptname NHV_InformantAliasScript extends ReferenceAlias
{Dawnstar informant (Spitzel, E30): watches the Sanctuary entrance for the Oculatus circle. Attached to
an Optional alias on NHV_Sys_Oculatus. Detectable once heat reaches the CK condition GetGlobalValue
NHV_Status_OculatusHeat >= 2 (raw heat, docs/plan/Hauptbogen-Oculatus.md 2.3 - this script never polls
for detection itself, Papyrus-Regel 1). Three player outcomes once exposed: kill, turn (double agent,
narrative flag only, no mechanical follower/companion), or release. docs/plan/Hauptbogen-Oculatus.md
2.3, docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md.

CK note: Resolve(0) already calls Kill() itself - the confrontation dialogue's kill-branch result
script must call Resolve(0) ONLY, in the end fragment, never a separate "Kill Actor" result on top of
it (double-kill risk). The informant must not be flagged Essential or Protected, or Kill() will not
actually end him.}

GlobalVariable Property NHV_Cfg_Debug Auto
NHV_OculatusScript Property OculatusSys Auto
; Set in the CK to the player alias/reference this quest already carries (or Game.GetPlayer() resolved
; once and cached via a property, per the project's "Properties statt Lookups" rule) - used only to
; tell a player kill from a third-party death in OnDeath() below.
Actor Property PlayerRef Auto

; 0 undiscovered, 1 exposed (outcome choice offered), 2 killed, 3 turned, 4 released. Never renumber
; (Regel 3, mirrors the NHV_Status_<Name> convention in docs/ARCHITECTURE.md).
Int iOutcome = 0

; Read-only getter for other scripts (e.g. NHV_IL02Script logs it when the two are wired together).
Int Function GetOutcome()
    Return iOutcome
EndFunction

; Called from the dialogue/detection stage fragment once the player confronts him. Idempotent past the
; first call.
Function Expose()
    If iOutcome != 0
        Return
    EndIf
    iOutcome = 1
    NHV_Util.Log(NHV_Cfg_Debug, "NHV_InformantAliasScript: informant exposed")
EndFunction

; aiChoice: 0 kill, 1 turn (double agent), 2 release. Called once from the dialogue result fragment.
; iOutcome and, for a kill, Kill() itself always run once aiChoice is valid - only the ReportEvidence()
; call is guarded by whether OculatusSys is set, so a missing CK property never leaves the informant
; alive/unresolved or skips the kill (Team-Lead review round 2). An unrecognised aiChoice changes
; nothing and is only logged, leaving the informant retryable in the exposed state.
Function Resolve(Int aiChoice)
    If iOutcome != 1
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_InformantAliasScript.Resolve: not in the exposed state (iOutcome=" + iOutcome + ")")
        Return
    EndIf
    If aiChoice != 0 && aiChoice != 1 && aiChoice != 2
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_InformantAliasScript.Resolve: invalid choice " + aiChoice)
        Return
    EndIf
    If aiChoice == 0
        iOutcome = 2
        Actor kActor = GetActorReference()
        If kActor && !kActor.IsDead()
            kActor.Kill()
        EndIf
        If OculatusSys
            OculatusSys.ReportEvidence(-1, "Informant killed")
        EndIf
    ElseIf aiChoice == 1
        iOutcome = 3
        If OculatusSys
            OculatusSys.ReportEvidence(-1, "Informant turned")
        EndIf
    Else
        iOutcome = 4
        If OculatusSys
            OculatusSys.ReportEvidence(1, "Informant released, keeps reporting")
        EndIf
    EndIf
EndFunction

; Catches a kill outside the dialogue result (e.g. the player attacks him directly, or he dies to a
; third party such as a guard or wild animal before ever being exposed). Heat only changes when the
; player is the confirmed killer - a death he had no part in tells the circle nothing about the
; player, so it is only logged (Team-Lead review round 2). akKiller may be None on scripted deaths
; (Papyrus-Regel 6, None-Sicherheit: never dereferenced without a check).
Event OnDeath(Actor akKiller)
    If iOutcome == 2 || iOutcome == 3 || iOutcome == 4
        Return ; already resolved via Resolve()
    EndIf
    iOutcome = 2
    If akKiller && PlayerRef && akKiller == PlayerRef
        If OculatusSys
            OculatusSys.ReportEvidence(-1, "Informant killed outside dialogue")
        EndIf
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_InformantAliasScript.OnDeath: died without player attribution, no heat change")
    EndIf
EndEvent
