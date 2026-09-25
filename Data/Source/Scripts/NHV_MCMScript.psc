Scriptname NHV_MCMScript extends SKI_ConfigBase
{MCM front-end for Night's Harvest. Pages: 1 Status (read-only), 2 General (Cfg-Globals).
Concept section 16, M1.1. Family/Black Ledger/Finale/Compatibility/Maintenance pages follow
once their systems exist (M1.6+). Attached to NHV_Sys_MCM (Start Game Enabled); that quest's
PlayerAlias carries SKI_PlayerLoadGameAlias per the SkyUI MCM Quickstart, so OnGameReload()/
CheckVersion() are wired by SkyUI itself, not by us.
MCM texts are English literals for now, not $NHV_* translation keys (E19, revisit in M6).}

GlobalVariable Property NHV_Cfg_Debug Auto
GlobalVariable Property NHV_Cfg_Enabled Auto
GlobalVariable Property NHV_Cfg_StartDelay Auto
GlobalVariable Property NHV_Cfg_Notify Auto
GlobalVariable Property NHV_Cfg_Markers Auto
GlobalVariable Property NHV_Cfg_Delivery Auto

; Optional, filled once the systems that produce them exist in the CK (M1.1/M1.5/M1.6). The
; Status page falls back to a placeholder while they are None, so this MCM works standalone
; with only the current build state.
NHV_CoreScript Property Core Auto
Quest Property Q00 Auto
GlobalVariable Property NHV_FamilyStrength Auto

Int Property VERSION = 2 AutoReadOnly

String[] asMarkerOptions
String[] asDeliveryOptions

Int iOptEnabled
Int iOptQuest
Int iOptFamily

Int Function GetVersion()
    Return VERSION
EndFunction

Event OnConfigInit()
    ModName = "Night's Harvest"
    BuildOptionArrays()
    BuildPages(0)
EndEvent

Event OnVersionUpdate(Int aiVersion)
    ; aiVersion = the version this save was on before the update. Rebuild the option
    ; arrays (harmless if unchanged) and the page list so new pages from a later VERSION
    ; show up in existing saves without a fresh OnConfigInit().
    BuildOptionArrays()
    BuildPages(aiVersion)
EndEvent

Function BuildOptionArrays()
    asMarkerOptions = new String[3]
    asMarkerOptions[0] = "Always"
    asMarkerOptions[1] = "Vague"
    asMarkerOptions[2] = "Off"
    asDeliveryOptions = new String[2]
    asDeliveryOptions[0] = "Courier"
    asDeliveryOptions[1] = "Veyra only"
EndFunction

; v1: Status, General. v2 (25.09.2026): + Debug. A later VERSION that adds a page (e.g. v2: + Family once M1.6 is in
; the CK) appends here and branches on aiFromVersion - never remove or reorder existing
; entries, existing saves rely on the page list staying stable (docs/CONVENTIONS.md).
Function BuildPages(Int aiFromVersion)
    Pages = new String[3]
    Pages[0] = "Status"
    Pages[1] = "General"
    Pages[2] = "Debug"
EndFunction

Event OnPageReset(String asPage)
    If asPage == "Status"
        ShowStatusPage()
    ElseIf asPage == "General"
        ShowGeneralPage()
    ElseIf asPage == "Debug"
        ShowDebugPage()
    EndIf
EndEvent

; ---------------------------------------------------------------------------- Status page --

Function ShowStatusPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(GetHeaderText())
    iOptEnabled = AddTextOption("Mod active", GetEnabledText(), OPTION_FLAG_DISABLED)
    iOptQuest = AddTextOption("Current quest", GetCurrentQuestText(), OPTION_FLAG_DISABLED)
    iOptFamily = AddTextOption("Family strength", GetFamilyStrengthText(), OPTION_FLAG_DISABLED)
EndFunction

Event OnOptionHighlight(Int aiOption)
    If aiOption == iOptEnabled
        SetInfoText("Whether Night's Harvest is currently active.")
    ElseIf aiOption == iOptQuest
        SetInfoText("The stage of the currently active Night's Harvest quest, if any.")
    ElseIf aiOption == iOptFamily
        SetInfoText("Combined strength of all recruited family members.")
    EndIf
EndEvent

String Function GetHeaderText()
    If Core
        Return "Night's Harvest " + Core.VERSION_TEXT
    EndIf
    Return "Night's Harvest"
EndFunction

String Function GetEnabledText()
    If GetGlobalBool(NHV_Cfg_Enabled)
        Return "Yes"
    EndIf
    Return "No"
EndFunction

String Function GetCurrentQuestText()
    If !Q00
        Return "not available yet"
    ElseIf Q00.IsCompleted()
        Return "Q00 completed"
    ElseIf Q00.IsRunning()
        Return "Q00 running (stage " + Q00.GetStage() + ")"
    EndIf
    Return "not started"
EndFunction

String Function GetFamilyStrengthText()
    If !NHV_FamilyStrength
        Return "not available yet"
    EndIf
    Int iStrength = NHV_FamilyStrength.GetValue() as Int
    Return iStrength as String
EndFunction

; ---------------------------------------------------------------------------- Debug page --

Function ShowDebugPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Testing tools")
    AddTextOptionST("StartQ00", "Start Q00 now", "Start")
EndFunction

State StartQ00
    Event OnHighlightST()
        SetInfoText("Testing only: starts A Shadow at the Door immediately and ignores the start conditions (Hail Sithis, The Dark Brotherhood Forever, delay). Use it inside the Dawnstar Sanctuary, then close the menu.")
    EndEvent

    Event OnSelectST()
        ; Saves made with an earlier build keep None for properties filled later (see
        ; NHV_CoreScript.EnsureProperties()), so resolve them here too.
        If !Core
            Core = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
        EndIf
        If !Q00
            Q00 = Game.GetFormFromFile(0x000815, "NightsHarvest.esp") as Quest
        EndIf
        If Core
            Core.EnsureProperties()
        EndIf
        If !Core || !Q00
            ShowMessage("Night's Harvest is not fully set up yet (Core or Q00 missing).", False)
        ElseIf Q00.IsRunning() || Q00.IsCompleted()
            ShowMessage("Q00 is already running or completed.", False)
        Else
            Core.StartQ00()
            ShowMessage("Q00 started. Close the menu.", False)
        EndIf
    EndEvent
EndState

; --------------------------------------------------------------------------- General page --

Function ShowGeneralPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddToggleOptionST("Enabled", "Enable Night's Harvest", GetGlobalBool(NHV_Cfg_Enabled))
    AddSliderOptionST("StartDelay", "Start delay (days)", GetGlobalFloat(NHV_Cfg_StartDelay), "{0} day(s)")
    AddToggleOptionST("Notify", "Contract notifications", GetGlobalBool(NHV_Cfg_Notify))
    AddMenuOptionST("Markers", "Quest map markers", GetMenuText(asMarkerOptions, GetGlobalInt(NHV_Cfg_Markers)))
    AddMenuOptionST("Delivery", "Letter delivery", GetMenuText(asDeliveryOptions, GetGlobalInt(NHV_Cfg_Delivery)))
EndFunction

String Function GetMenuText(String[] asOptions, Int aiIndex)
    If aiIndex < 0 || aiIndex >= asOptions.Length
        Return asOptions[0]
    EndIf
    Return asOptions[aiIndex]
EndFunction

State Enabled
    Event OnHighlightST()
        SetInfoText("Turn Night's Harvest on or off. Running quests keep going when off; only new starts are blocked.")
    EndEvent

    Event OnSelectST()
        Bool bNewValue = !GetGlobalBool(NHV_Cfg_Enabled)
        SetGlobalBool(NHV_Cfg_Enabled, bNewValue)
        SetToggleOptionValueST(bNewValue)
    EndEvent

    Event OnDefaultST()
        SetGlobalBool(NHV_Cfg_Enabled, True)
        SetToggleOptionValueST(True)
    EndEvent
EndState

State StartDelay
    Event OnHighlightST()
        SetInfoText("Days between \"Hail Sithis!\" and the start of A Shadow at the Door.")
    EndEvent

    Event OnSliderOpenST()
        SetSliderDialogRange(0.0, 7.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogDefaultValue(2.0)
        SetSliderDialogStartValue(GetGlobalFloat(NHV_Cfg_StartDelay))
    EndEvent

    Event OnSliderAcceptST(Float afValue)
        SetGlobalFloat(NHV_Cfg_StartDelay, afValue)
        SetSliderOptionValueST(afValue, "{0} day(s)")
    EndEvent

    Event OnDefaultST()
        SetGlobalFloat(NHV_Cfg_StartDelay, 2.0)
        SetSliderOptionValueST(2.0, "{0} day(s)")
    EndEvent
EndState

State Notify
    Event OnHighlightST()
        SetInfoText("Short notifications when Night's Harvest changes phase.")
    EndEvent

    Event OnSelectST()
        Bool bNewValue = !GetGlobalBool(NHV_Cfg_Notify)
        SetGlobalBool(NHV_Cfg_Notify, bNewValue)
        SetToggleOptionValueST(bNewValue)
    EndEvent

    Event OnDefaultST()
        SetGlobalBool(NHV_Cfg_Notify, True)
        SetToggleOptionValueST(True)
    EndEvent
EndState

State Markers
    Event OnHighlightST()
        SetInfoText("\"Vague\" shows only the city, not the exact target, on the map.")
    EndEvent

    Event OnMenuOpenST()
        SetMenuDialogOptions(asMarkerOptions)
        SetMenuDialogStartIndex(GetGlobalInt(NHV_Cfg_Markers))
    EndEvent

    Event OnMenuAcceptST(Int aiIndex)
        SetGlobalInt(NHV_Cfg_Markers, aiIndex)
        SetMenuOptionValueST(GetMenuText(asMarkerOptions, aiIndex))
    EndEvent

    Event OnDefaultST()
        SetGlobalInt(NHV_Cfg_Markers, 0)
        SetMenuOptionValueST(GetMenuText(asMarkerOptions, 0))
    EndEvent
EndState

State Delivery
    Event OnHighlightST()
        SetInfoText("How Dispatch fragments and hints reach you: by courier or only from Veyra in person.")
    EndEvent

    Event OnMenuOpenST()
        SetMenuDialogOptions(asDeliveryOptions)
        SetMenuDialogStartIndex(GetGlobalInt(NHV_Cfg_Delivery))
    EndEvent

    Event OnMenuAcceptST(Int aiIndex)
        SetGlobalInt(NHV_Cfg_Delivery, aiIndex)
        SetMenuOptionValueST(GetMenuText(asDeliveryOptions, aiIndex))
    EndEvent

    Event OnDefaultST()
        SetGlobalInt(NHV_Cfg_Delivery, 0)
        SetMenuOptionValueST(GetMenuText(asDeliveryOptions, 0))
    EndEvent
EndState

; ------------------------------------------------------------------------- Global helpers --
; None-safe reads/writes so an unset property (CK not filled yet) never crashes the menu.

Bool Function GetGlobalBool(GlobalVariable akGlobal)
    If !akGlobal
        Return False
    EndIf
    Return akGlobal.GetValueInt() == 1
EndFunction

Int Function GetGlobalInt(GlobalVariable akGlobal)
    If !akGlobal
        Return 0
    EndIf
    Return akGlobal.GetValueInt()
EndFunction

Float Function GetGlobalFloat(GlobalVariable akGlobal)
    If !akGlobal
        Return 0.0
    EndIf
    Return akGlobal.GetValue()
EndFunction

Function SetGlobalBool(GlobalVariable akGlobal, Bool abValue)
    If !akGlobal
        Return
    EndIf
    If abValue
        akGlobal.SetValueInt(1)
    Else
        akGlobal.SetValueInt(0)
    EndIf
EndFunction

Function SetGlobalInt(GlobalVariable akGlobal, Int aiValue)
    If akGlobal
        akGlobal.SetValueInt(aiValue)
    EndIf
EndFunction

Function SetGlobalFloat(GlobalVariable akGlobal, Float afValue)
    If akGlobal
        akGlobal.SetValue(afValue)
    EndIf
EndFunction
