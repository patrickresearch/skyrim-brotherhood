Scriptname NHV_SealedPassageDoorScript extends ObjectReference
{Attached to the NHV_SealedPassageDoor base record (M1.3/M1.5 Q00 Szene 4, E16/E09). Every
reference spawned from that base - just the one PlaceAtMe'd by NHV_CoreScript.SpawnPassageDoor() -
inherits this script and its Property values, so no per-reference wiring is needed at runtime.}

; NHV_Mk_Q00_DeepSanctuaryEntry, XMarker placed by the developer inside NHV_DeepSanctuaryCell
; (M1.3 CK work). Filled once on the base object itself, not per reference.
ObjectReference Property TargetMarker Auto
; NHV_Q00_ShadowAtTheDoor. Stage 50 ("Explore the Deep Sanctuary") is set the first time the
; player uses the door while the quest sits on stage 40 (concept section 6, stage table).
Quest Property Q00 Auto

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == Game.GetPlayer() && TargetMarker
        ; TargetMarker (the cell's COCMarkerHeading) sits in the plane of the cell's exit door
        ; (Y -2944 vs door Y -2942), so arriving exactly on it pushed the player to the wrong side.
        ; The marker faces +Y = into the room, hence the offset along +Y. Rotation is matched.
        akActionRef.MoveTo(TargetMarker, 0.0, 128.0, 8.0, True)
        (Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript).OnEnterDeepSanctuary()
        If Q00 && Q00.GetStage() == 40
            Q00.SetStage(50)
        EndIf
    EndIf
EndEvent
