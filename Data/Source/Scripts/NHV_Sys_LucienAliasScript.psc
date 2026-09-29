Scriptname NHV_Sys_LucienAliasScript extends ReferenceAlias
{Attached to the Lucien alias (ID 4) of NHV_Sys_Sanctuary. Diagnostics and self-repair for "Lucien cannot be talked
to" (ingame tests 29.09.2026): when the player activates him, it releases a hanging arrival scene and, with
NHV_Cfg_Debug = 1, logs every state the dialogue conditions depend on. No dialogue logic of its own. M1.5.}

NHV_SanctuaryScript Property Sanctuary Auto
GlobalVariable Property NHV_Q00_LucienSummoned Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Event OnActivate(ObjectReference akActionRef)
    If akActionRef != Game.GetPlayer()
        Return
    EndIf
    Actor kLucien = GetActorRef()
    If !kLucien
        NHV_Util.Log(NHV_Cfg_Debug, "Lucien activated, but the alias is empty")
        Return
    EndIf
    NHV_SanctuaryScript kSanctuary = Sanctuary
    If !kSanctuary
        kSanctuary = GetOwningQuest() as NHV_SanctuaryScript ; property not bound in an older save
    EndIf
    If kSanctuary
        kSanctuary.ReleaseArrivalScene() ; a scene that holds him blocks every player topic
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "Lucien activated: Sanctuary script not reachable")
    EndIf
    If NHV_Cfg_Debug && NHV_Cfg_Debug.GetValueInt() == 1
        Float fSummoned = -1.0
        If NHV_Q00_LucienSummoned
            fSummoned = NHV_Q00_LucienSummoned.GetValue()
        EndIf
        NHV_Util.Log(NHV_Cfg_Debug, "Lucien activated: summoned=" + fSummoned + " base=" + kLucien.GetActorBase() + \
            " leveledBase=" + kLucien.GetLeveledActorBase() + " quest=" + GetOwningQuest().IsRunning() + \
            " combat=" + kLucien.IsInCombat() + " ai=" + kLucien.IsAIEnabled() + " ghost=" + kLucien.IsGhost() + \
            " scene=" + (kLucien.GetCurrentScene() != None))
        Utility.Wait(1.0)
        NHV_Util.Log(NHV_Cfg_Debug, "Lucien activated: in dialogue with player after 1 s = " + \
            kLucien.IsInDialogueWithPlayer())
    EndIf
EndEvent
