Scriptname NHV_NightMotherCallerScript extends Actor
{Attached to NHV_NightMotherVoiceNPC, the invisible voice actor that speaks the Night Mother's call in Q00 stage 20
(NHV_Q00_NM_Call). NHV_CoreScript.PlayNightMotherCall() places it at the coffin; this script waits (update timer,
no latent calls in an event) until no menu is open, says the topic once and deletes the actor again.}

Topic Property CallTopic Auto           ; NHV_Q00_NM_Call (0037ED)
GlobalVariable Property NHV_Cfg_Debug Auto

Int iPhase = 0 ; 0 = waiting to speak, 1 = spoken, waiting to be deleted
Int iTicks = 0

Event OnInit()
    RegisterForSingleUpdate(3.0) ; let the scene settle (Veyra just left)
EndEvent

Event OnUpdate()
    NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
    If iPhase == 1
        Disable()
        Delete()
        Return
    EndIf
    If !kCore || !CallTopic
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_NightMotherCallerScript: Core or CallTopic missing")
        If kCore
            kCore.OnNightMotherCallFinished(False)
        EndIf
        Delete()
        Return
    EndIf
    If !kCore.CanNightMotherCall()
        kCore.OnNightMotherCallFinished(False) ; stage moved on or the player left: try again on the next entry
        Delete()
        Return
    EndIf
    iTicks += 1
    If Utility.IsInMenuMode() && iTicks < 40
        RegisterForSingleUpdate(0.5)
        Return
    EndIf
    If Utility.IsInMenuMode()
        kCore.OnNightMotherCallFinished(False) ; menu open for 20 s: give up for now
        Delete()
        Return
    EndIf
    If !Is3DLoaded() && iTicks < 10
        RegisterForSingleUpdate(0.5) ; no 3D yet: up to 5 s, then speak anyway
        Return
    EndIf
    Say(CallTopic)
    iPhase = 1
    NHV_Util.Log(NHV_Cfg_Debug, "Night Mother calls the Listener (3D=" + Is3DLoaded() + ", distance " + GetDistance(Game.GetPlayer()) + ")")
    kCore.OnNightMotherCallFinished(True)
    RegisterForSingleUpdate(10.0) ; the line runs about 8 s; deleting the speaker earlier would cut it off
EndEvent
