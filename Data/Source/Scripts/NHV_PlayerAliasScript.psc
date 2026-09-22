Scriptname NHV_PlayerAliasScript extends ReferenceAlias
{Player alias on NHV_Sys_Core. Runs maintenance on every save load and watches for the
Dawnstar Sanctuary startbedingung (concept section 2) via an alias event, not polling.}

NHV_CoreScript Property Core Auto

Event OnPlayerLoadGame()
    If Core
        Core.Maintenance()
    EndIf
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    If Core
        Core.OnEnterDawnstarSanctuary(akNewLoc)
    EndIf
EndEvent
