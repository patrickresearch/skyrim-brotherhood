Scriptname NHV_Q02_HaldorAliasScript extends ReferenceAlias
{Attached to Q02's HaldorAlias. Detects the player intervening in the Stage 30 night scene
(NHV_Scn_Q02_01HaldorDocks) - either by activating Haldor directly or by attacking Sings before the
scripted drowning finishes - and reports it to NHV_Q02Script so NHV_Q02_HaldorSaved and the
Beschattung/Spurensuche branch get set exactly once. See docs/plan/Q02-Cold-Waters.md section 6.
M1.7.}

NHV_Q02Script Property OwningQuest Auto
GlobalVariable Property NHV_Cfg_Debug Auto

; Wired from the CK as the target of a "rescue Haldor" activate/dialogue choice during the scene.
; Safe to call more than once: NHV_Q02Script.OnHaldorRescued() is idempotent. The player attacking
; Sings instead (rather than using this dedicated choice) is handled separately, by
; NHV_Q02_SingsAliasScript.OnHit() calling the same NHV_Q02Script.OnHaldorRescued() - both routes
; converge on one idempotent entry point, so there is no double-counting.
Function Rescue()
    If !OwningQuest
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_Q02_HaldorAliasScript.Rescue: OwningQuest property not set in the CK")
        Return
    EndIf
    OwningQuest.OnHaldorRescued()
EndFunction
