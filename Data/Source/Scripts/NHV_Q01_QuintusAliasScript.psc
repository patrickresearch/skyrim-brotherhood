Scriptname NHV_Q01_QuintusAliasScript extends ReferenceAlias
{Attached to the QuintusAlias in NHV_Q01_TheUnansweredSacrament. Quintus Aufidius is the Trial's
target, not a recruit, so this is deliberately separate from NHV_ContractRecruitAliasScript: his
death is expected and required to advance the quest, whoever delivers it (Hrefna during the
scripted Trial, or the player stepping in on the "Step aside" option). Concept section 7, M1.7.}

NHV_Q01Script Property Q01 Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Event OnDeath(Actor akKiller)
    Actor kQuintus = GetActorRef()
    If !kQuintus
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_Q01_QuintusAliasScript.OnDeath: alias reference is None")
        Return
    EndIf
    If !Q01
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_Q01_QuintusAliasScript.OnDeath: Q01 property not set in the CK")
        Return
    EndIf
    Q01.OnQuintusKilled(akKiller)
EndEvent
