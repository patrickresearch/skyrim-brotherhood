Scriptname NHV_NightMotherCoffinAliasScript extends ReferenceAlias
{Q00 alias "NightMotherCoffin" on the vanilla coffin in the Dawnstar Sanctuary (DawnstarSancNightMotherRef).
Opening it on stage 20 starts the conversation with the Night Mother (concept section 6, Q00 scene 2).
The vanilla record stays untouched.}

NHV_CoreScript Property Core Auto

Event OnActivate(ObjectReference akActionRef)
    If Core && akActionRef == Game.GetPlayer()
        NHV_Util.Log(Core.NHV_Cfg_Debug, "Night Mother coffin activated: " + GetReference())
        Core.OnNightMotherCoffinActivated()
    EndIf
EndEvent
