Scriptname NHV_Q02_DispatchRefScript extends ObjectReference
{Attached to NHV_Q02_DispatchDeskRef, the Oculatus dispatch on Aelius' desk (Initially Disabled, enabled
by NHV_Q02Script.GiveOculatusFragment() on Stage 70). Reading it in place or taking it counts as
finding it. M2.2, 30.09.2026.}

NHV_Q02Script Property OwningQuest Auto
GlobalVariable Property NHV_Cfg_Debug Auto

Event OnRead()
    ReportFound()
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    If akNewContainer == Game.GetPlayer()
        ReportFound()
    EndIf
EndEvent

Function ReportFound()
    If !OwningQuest
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_Q02_DispatchRefScript: OwningQuest not set")
        Return
    EndIf
    OwningQuest.OnDispatchFound() ; idempotent
EndFunction
