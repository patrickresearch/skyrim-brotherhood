Scriptname NHV_ReturnDoorScript extends ObjectReference
{Attached to the NHV_SealedPassageReturnDoor base record (M1.3/M1.5, E16/E09). Replaces the
cell's own exit door (which has no teleport destination) and leads the player back to the
sealed-passage door in DawnstarSanctuary. All logic lives in NHV_CoreScript.ReturnToSanctuary().}

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == Game.GetPlayer()
        (Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript).ReturnToSanctuary()
    EndIf
EndEvent
