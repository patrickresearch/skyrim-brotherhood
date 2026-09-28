Scriptname NHV_IL01Script extends Quest
{Interlude "First Blood" (E30, docs/plan/Hauptbogen-Oculatus.md 3.1): an optional wayside ambush by
2-3 Oculatus mercenaries. CK condition: GetGlobalValue NHV_Status_OculatusHeat >= 2 (raw heat, not the
bucketed stage - docs/plan/Hauptbogen-Oculatus.md 2.2). Starts via a Story Manager quest-start event
once the CK-side encounter is placed; this script only resolves the outcome and reports back to
NHV_Sys_Oculatus. Pure flavour episode by design (docs/plan/Hauptbogen-Oculatus.md 3.1 assigns it no
heat effect) - Conclude() still reports 0 so the attempt is visible in the Papyrus log.

CK note: this quest must be "Run Once" - see docs/ck/M3-Hauptbogen-Oculatus-CK-Anleitung.md. Even so,
Conclude() double-checks with NHV_OculatusScript.TryClaimInterlude(1) before reporting anything, since
a quest's own instance state (bResolved) resets if the quest is ever restarted by the CK/a dev save,
while NHV_Sys_Oculatus itself never restarts.}

GlobalVariable Property NHV_Cfg_Debug Auto
NHV_OculatusScript Property OculatusSys Auto

; Cheap short-circuit for repeat calls within the same quest run. Not the authoritative guard - see
; the class doc comment and OculatusSys.TryClaimInterlude(). Never rename (Regel 3).
Bool bResolved = False

; Called once from the stage fragment that ends the encounter (combat resolved, letter found or not).
; Set bResolved right away, unlike NHV_IL02Script.Conclude(): abLetterFound is a Bool, so every call
; is a valid outcome - there is no "invalid parameter" case to check for before committing to it, and
; the real double-booking guard is OculatusSys.TryClaimInterlude() below, not this flag.
Function Conclude(Bool abLetterFound)
    If bResolved
        Return
    EndIf
    If !OculatusSys
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_IL01Script.Conclude: OculatusSys property not set in the CK")
        Return ; left retryable, same order as NHV_IL02Script
    EndIf
    bResolved = True
    If !OculatusSys.TryClaimInterlude(1)
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_IL01Script.Conclude: interlude 1 already claimed, heat not booked again")
        Return
    EndIf
    If abLetterFound
        OculatusSys.ReportEvidence(0, "IL01 First Blood: letter found")
    Else
        OculatusSys.ReportEvidence(0, "IL01 First Blood: resolved without the letter")
    EndIf
EndFunction
