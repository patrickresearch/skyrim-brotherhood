Scriptname NHV_Q01_ReedbedSackScript extends ObjectReference
{Attach to the placed sack NHV_Cont_Q01_ReedbedSack (ref 0x0089E1) in the CK. While the scavengers are still alive and the
fight is not over the sack cannot be opened; NHV_Q01Script releases it (BlockActivation False) afterwards. Without this
script the quest script locks the sack on its own as soon as the fight starts, only the lock before the talk is missing.}

Event OnLoad()
    NHV_Q01Script kQ01 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
    If kQ01 && !kQ01.IsReedbedLootFree()
        BlockActivation(True)
        kQ01.BeginReedbedWatch()
    EndIf
EndEvent

; A blocked reference still reports the activation: tell the player why nothing happens.
Event OnActivate(ObjectReference akActionRef)
    If akActionRef != Game.GetPlayer()
        Return
    EndIf
    NHV_Q01Script kQ01 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
    If kQ01 && !kQ01.IsReedbedLootFree()
        Debug.Notification("The scavengers still guard the sack.")
    EndIf
EndEvent
