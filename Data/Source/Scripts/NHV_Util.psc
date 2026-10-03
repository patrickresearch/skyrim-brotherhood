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

; ---- Dialogue flow helpers (tools/flow_compiler.py: generated topic and scene fragments call only these) ----
; The FormIDs are plugin-local (0x00xxxxxx of NightsHarvest.esp). Each helper is a no-op when the record is missing.

; Sets a flow global (cursor or state flag) of NightsHarvest.esp.
Function FlowSet(Int aiGlobal, Int aiValue) Global
    GlobalVariable kGlobal = Game.GetFormFromFile(aiGlobal, "NightsHarvest.esp") as GlobalVariable
    If kGlobal
        kGlobal.SetValueInt(aiValue)
        Debug.Trace("[NHV] FlowSet 0x" + aiGlobal + " = " + aiValue)
    Else
        Debug.Trace("[NHV] FlowSet: global " + aiGlobal + " not found")
    EndIf
EndFunction

; Reads a flow global of NightsHarvest.esp (0 when it is missing).
Int Function FlowGet(Int aiGlobal) Global
    GlobalVariable kGlobal = Game.GetFormFromFile(aiGlobal, "NightsHarvest.esp") as GlobalVariable
    If kGlobal
        Return kGlobal.GetValueInt()
    EndIf
    Debug.Trace("[NHV] FlowGet: global " + aiGlobal + " not found")
    Return 0
EndFunction

; SetStage on a quest of NightsHarvest.esp, once (a stage that is already done is not run again).
Function FlowStage(Int aiQuest, Int aiStage) Global
    Quest kQuest = Game.GetFormFromFile(aiQuest, "NightsHarvest.esp") as Quest
    If kQuest
        If !kQuest.GetStageDone(aiStage)
            kQuest.SetStage(aiStage)
            Debug.Trace("[NHV] FlowStage " + kQuest + " -> " + aiStage)
        EndIf
    Else
        Debug.Trace("[NHV] FlowStage: quest " + aiQuest + " not found")
    EndIf
EndFunction

; Starts a scene of NightsHarvest.esp.
Function FlowScene(Int aiScene) Global
    Scene kScene = Game.GetFormFromFile(aiScene, "NightsHarvest.esp") as Scene
    If kScene
        If !kScene.IsPlaying()
            kScene.Start()
            Debug.Trace("[NHV] FlowScene start " + kScene)
        Else
            Debug.Trace("[NHV] FlowScene already playing " + kScene)
        EndIf
    Else
        Debug.Trace("[NHV] FlowScene: scene " + aiScene + " not found")
    EndIf
EndFunction

; Completes objective aiDone and shows objective aiShow of a quest of NightsHarvest.esp.
Function FlowObjective(Int aiQuest, Int aiDone, Int aiShow) Global
    Quest kQuest = Game.GetFormFromFile(aiQuest, "NightsHarvest.esp") as Quest
    If kQuest
        If aiDone > 0
            kQuest.SetObjectiveCompleted(aiDone)
        EndIf
        If aiShow > 0
            kQuest.SetObjectiveDisplayed(aiShow)
        EndIf
    Else
        Debug.Trace("[NHV] FlowObjective: quest " + aiQuest + " not found")
    EndIf
EndFunction
