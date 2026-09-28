Scriptname NHV_OculatusPlayerAliasScript extends ReferenceAlias
{PlayerRef alias script for NHV_Sys_Oculatus, mirrors NHV_PlayerAliasScript's role for NHV_Sys_Core
(docs/ARCHITECTURE.md) but is its own, separate alias/script so the existing NHV_PlayerAliasScript is
never touched (Team-Lead instruction, E28-E31 rollout). Runs NHV_OculatusScript.Maintenance() on every
load, the same safety net Q00 and the contract quests already rely on.}

NHV_OculatusScript Property OculatusSys Auto

Event OnPlayerLoadGame()
    If OculatusSys
        OculatusSys.Maintenance()
    EndIf
EndEvent
