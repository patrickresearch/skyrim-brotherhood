Scriptname NHV_IL02Script extends Quest
{Interlude "Knock at Dawnstar" (E30, docs/plan/Hauptbogen-Oculatus.md 3.3): an optional encounter with
3-4 Oculatus agents scouting the Dawnstar Sanctuary from outside - placed in a wilderness cell around
Dawnstar, never inside DawnstarSanctuary or the Deep Sanctuary itself, so it creates no new E16 cell
copy and does not pre-empt Q06's own raid moment. CK condition: GetGlobalValue
NHV_Status_OculatusHeat >= 4 (raw heat, not the bucketed stage - docs/plan/Hauptbogen-Oculatus.md 2.2).

CK note: this quest must be "Run Once" - see docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md. Even so,
Conclude() double-checks with NHV_OculatusScript.TryClaimInterlude(2) before reporting anything, for
the same reason as NHV_IL01Script: a quest's own instance state resets on restart, NHV_Sys_Oculatus
does not.}

GlobalVariable Property NHV_Cfg_Debug Auto
NHV_OculatusScript Property OculatusSys Auto
; Optional: set in the CK only if the developer wires the same NPC into both this interlude and the
; Dawnstar informant (docs/plan/Hauptbogen-Oculatus.md 3.3 - the informant can resurface here). None
; is a valid, supported state. When set, its already-resolved outcome (see
; NHV_InformantAliasScript.GetOutcome()) is appended to the Papyrus-log reason string below, so a
; developer reading the log can see whether the informant had already been turned/killed/released
; before this interlude concluded - no new heat effect from the tie-in itself, purely diagnostic.
NHV_InformantAliasScript Property Informant Auto

Bool bResolved = False

; aiOutcome: 0 = the agents are defeated/driven off in combat (heat -1), 1 = a captured agent is
; successfully interrogated (Speech success, heat -1), 2 = the player observes and follows instead of
; fighting (loot only, no heat change). Called once from the stage fragment that ends the encounter.
; bResolved is set only after aiOutcome is validated (unlike NHV_IL01Script.Conclude(), whose Bool
; parameter has no invalid state) - an invalid call is logged and left retryable instead of silently
; consuming the one-time flag, matching NHV_InformantAliasScript.Resolve()'s treatment of an invalid
; aiChoice.
Function Conclude(Int aiOutcome)
    If bResolved
        Return
    EndIf
    If aiOutcome != 0 && aiOutcome != 1 && aiOutcome != 2
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_IL02Script.Conclude: invalid outcome " + aiOutcome)
        Return
    EndIf
    If !OculatusSys
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_IL02Script.Conclude: OculatusSys property not set in the CK")
        Return ; left retryable: the heat change must not be lost to a missing property
    EndIf
    bResolved = True
    If !OculatusSys.TryClaimInterlude(2)
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_IL02Script.Conclude: interlude 2 already claimed, heat not booked again")
        Return
    EndIf
    String sInformantNote = ""
    If Informant
        sInformantNote = " (informant outcome " + Informant.GetOutcome() + ")"
    EndIf
    If aiOutcome == 0
        OculatusSys.ReportEvidence(-1, "IL02 Knock at Dawnstar: circle driven off" + sInformantNote)
    ElseIf aiOutcome == 1
        OculatusSys.ReportEvidence(-1, "IL02 Knock at Dawnstar: agent talked" + sInformantNote)
    Else
        OculatusSys.ReportEvidence(0, "IL02 Knock at Dawnstar: observed and followed, no heat change" + sInformantNote)
    EndIf
EndFunction
