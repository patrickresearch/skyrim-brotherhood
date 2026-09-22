Scriptname NHV_RecruitAliasScript extends ReferenceAlias
{Attached to each permanent Story-Rekrut alias in NHV_Sys_Family (e.g. HrefnaSlot), filled
after Homecoming. Catches death AFTER a recruit has joined the family - death DURING a
contract is handled by NHV_ContractBaseScript.RecruitDied() instead. Concept section 5, M1.6.}

; NHV_Status_<Name> for THIS recruit. One property value per alias, set in the CK.
GlobalVariable Property StatusGlobal Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Int Property STATUS_KILLED = 2 AutoReadOnly  ; E18: death, not the Q04-style "special case" (4)

Event OnDeath(Actor akKiller)
    Actor kRecruit = GetActorRef()
    If !kRecruit
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_RecruitAliasScript.OnDeath: alias reference is None")
        Return
    EndIf
    If !StatusGlobal
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_RecruitAliasScript.OnDeath: StatusGlobal property not set in the CK")
        Return
    EndIf
    If StatusGlobal.GetValueInt() == STATUS_KILLED
        Return  ; guard against a duplicate OnDeath (e.g. killmove + damage event both firing)
    EndIf
    StatusGlobal.SetValueInt(STATUS_KILLED)
    NHV_Util.SendRecruitEvent("NHV_RecruitDied", kRecruit)
    NHV_Util.Log(NHV_Cfg_Debug, kRecruit.GetLeveledActorBase().GetName() + " died, status set to killed")
EndEvent
