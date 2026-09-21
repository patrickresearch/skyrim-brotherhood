Scriptname NHV_Util Hidden
{Global helpers for Night's Harvest. No state, no properties. Concept section 14.}

; Writes "[NHV] <message>" to the Papyrus log, but only while the debug flag is set.
; Pass the NHV_Cfg_Debug global. An unfilled property (None) keeps the log silent.
Function Log(GlobalVariable akDebugFlag, String asMsg) Global
    If akDebugFlag && akDebugFlag.GetValueInt() == 1
        Debug.Trace("[NHV] " + asMsg)
    EndIf
EndFunction
