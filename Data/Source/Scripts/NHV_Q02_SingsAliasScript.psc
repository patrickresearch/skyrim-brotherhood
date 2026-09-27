Scriptname NHV_Q02_SingsAliasScript extends ReferenceAlias
{Attached to Q02's SingsAlias, alongside the reusable NHV_ContractRecruitAliasScript (which already
covers an unscripted death -> RecruitDied()). This script only adds the two Q02-specific reactions
that are not part of the shared contract schema: the player attacking Sings during the Stage 30
night scene counts as rescuing Haldor, and the player attacking Sings during the Stage 40 stealth
tail counts as being spotted. See docs/plan/Q02-Cold-Waters.md section 6. M1.7.}

NHV_Q02Script Property OwningQuest Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
    If akAggressor != Game.GetPlayer() || !OwningQuest
        Return
    EndIf
    Int iStage = OwningQuest.GetStage()
    If iStage == 30
        OwningQuest.OnHaldorRescued() ; attacking Sings mid-scene is an intervention, same as the dedicated rescue choice
    ElseIf iStage == 40 && OwningQuest.IsTailWatchActive()
        ; Only counts as "spotted" while the Pfad-A tail-watch is actually running. On Pfad B
        ; (Haldor already saved) Stage 40 is dialogue-/marker-driven tracking with no watch active;
        ; an attack there must not interrupt Sings' CK-side tracking package via a spurious call.
        OwningQuest.OnSingsSpotted() ; attacking during the tail is the loudest possible way to be spotted
    EndIf
EndEvent
