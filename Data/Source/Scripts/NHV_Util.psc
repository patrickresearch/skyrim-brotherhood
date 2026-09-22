Scriptname NHV_Util Hidden
{Global helpers for Night's Harvest. No state, no properties. Concept section 14.}

; Writes "[NHV] <message>" to the Papyrus log, but only while the debug flag is set.
; Pass the NHV_Cfg_Debug global. An unfilled property (None) keeps the log silent.
Function Log(GlobalVariable akDebugFlag, String asMsg) Global
    If akDebugFlag && akDebugFlag.GetValueInt() == 1
        Debug.Trace("[NHV] " + asMsg)
    EndIf
EndFunction

; Fires a SKSE ModEvent carrying akForm, for patches/addons to hook without editing our
; scripts (docs/ARCHITECTURE.md: NHV_RecruitJoined, NHV_RecruitDied, NHV_ContractCompleted).
Function SendRecruitEvent(String asEventName, Form akForm) Global
    Int iHandle = ModEvent.Create(asEventName)
    If iHandle
        ModEvent.PushForm(iHandle, akForm)
        ModEvent.Send(iHandle)
    EndIf
EndFunction
