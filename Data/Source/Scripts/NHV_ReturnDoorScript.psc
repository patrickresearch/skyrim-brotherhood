Scriptname NHV_ReturnDoorScript extends ObjectReference
{Concept section 4 (Anbindung an die Vanilla-Zelle), E16/E09. Attached to the NHV_SealedPassageReturnDoor
base record. Replaces the duplicated Markarth exit door of NHV_DeepSanctuaryCell (it has no
teleport destination) and leads the player back to the sealed-passage door in DawnstarSanctuary.
All logic lives in NHV_CoreScript.ReturnToSanctuary().}

Event OnInit()
    ; The door has no teleport destination; without this its default open/close toggle would
    ; run and leave it standing open. OnActivate still fires while activation is blocked.
    BlockActivation(True)
EndEvent

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == Game.GetPlayer()
        NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
        If kCore
            kCore.ReturnToSanctuary()
        EndIf
    EndIf
EndEvent
