Scriptname NHV_ContractPlayerAliasScript extends ReferenceAlias
{Attached to the PlayerRef alias of a contract quest (NHV_Q01Script .. NHV_Q05Script). Releases a
stale cutscene lock on load - scenes never resume across a save/load, so a lock still flagged True
right after loading is stale by definition - and gives the concrete quest script a chance to
reconcile its own load-time state (NHV_ContractBaseScript.OnContractLoadGame(), e.g. NHV_Q01Script
re-arming a pending release-letter timer). Mirrors NHV_PlayerAliasScript.OnPlayerLoadGame() ->
Maintenance() on NHV_Sys_Core, kept as its own small script instead of touching that one. Reusable
as-is for Q02-Q05; only OwningContract differs per quest. M1.7.}

NHV_ContractBaseScript Property OwningContract Auto

Event OnPlayerLoadGame()
    If OwningContract
        OwningContract.RecoverCutsceneOnLoad()
        OwningContract.OnContractLoadGame()
    EndIf
EndEvent
