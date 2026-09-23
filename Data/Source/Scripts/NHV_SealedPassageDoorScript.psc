Scriptname NHV_SealedPassageDoorScript extends ObjectReference
{Attached to the NHV_SealedPassageDoor base record (M1.3/M1.5 Q00 Szene 4, E16/E09). Every
reference spawned from that base - just the one PlaceAtMe'd by NHV_CoreScript.SpawnPassageDoor() -
inherits this script and its Property value, so no per-reference wiring is needed at runtime.}

; NHV_Mk_Q00_DeepSanctuaryEntry, XMarker placed by the developer inside NHV_DeepSanctuaryCell
; (M1.3 CK work). Filled once on the base object itself, not per reference.
ObjectReference Property TargetMarker Auto

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == Game.GetPlayer() && TargetMarker
        akActionRef.MoveTo(TargetMarker)
    EndIf
EndEvent
