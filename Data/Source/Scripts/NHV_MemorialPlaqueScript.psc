Scriptname NHV_MemorialPlaqueScript extends ObjectReference
{Memorial Wall plaque in the Deep Sanctuary (Q00, concept Szene 5 / Memorial Wall): activating it shows the epitaph.
Placed refs NHV_Ref_Q00_Plaque* (003DA6-003DAB), bases NHV_Act_Q00_Plaque*; texts dialogue/Books.csv NHV_SYS_BOOK_76-81.}

Message Property Epitaph Auto ; NHV_Msg_Q00_Epitaph<Name>
Actor Property PlayerRef Auto

Event OnActivate(ObjectReference akActionRef)
    If akActionRef != PlayerRef
        Return
    EndIf
    If Epitaph
        Epitaph.Show()
    Else
        Debug.Trace("[NHV] NHV_MemorialPlaqueScript: Epitaph not set on " + Self)
    EndIf
EndEvent
