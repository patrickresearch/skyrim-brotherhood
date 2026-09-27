Scriptname NHV_ContractRecruitAliasScript extends ReferenceAlias
{Attached to a contract candidate's alias WHILE her/his recruitment quest (NHV_Q01Script ..
NHV_Q05Script) is still running, i.e. before Judgement/Homecoming. Reports an unscripted death
(e.g. the player kills the candidate by accident, or a random encounter goes wrong) to the owning
contract so its status Global still ends up on STATUS_KILLED. After Homecoming the candidate's
death is watched by NHV_RecruitAliasScript instead (docs/ARCHITECTURE.md draws that exact line).
Reusable as-is for Q02-Q05; only the alias properties differ per quest. M1.7.}

NHV_ContractBaseScript Property OwningContract Auto
GlobalVariable Property StatusGlobal Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Event OnDeath(Actor akKiller)
    Actor kRecruit = GetActorRef()
    If !kRecruit
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_ContractRecruitAliasScript.OnDeath: alias reference is None")
        Return
    EndIf
    If !OwningContract
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_ContractRecruitAliasScript.OnDeath: OwningContract property not set in the CK")
        Return
    EndIf
    OwningContract.RecruitDied(kRecruit, StatusGlobal)
EndEvent
