Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: SKSE check, versioning, maintenance, startbedingung. Attached to NHV_Sys_Core (Start Game Enabled). Concept sections 2 and 14.}

; Script version. Bump for every save-relevant change and add one idempotent step to Migrate().
Int Property VERSION = 2 AutoReadOnly
; Human-readable mod version, keep in sync with fomod/info.xml and the git tag.
String Property VERSION_TEXT = "0.0.1" AutoReadOnly

GlobalVariable Property NHV_Cfg_Debug Auto
; Master switch (M0.6). Off: no new quest starts, running quests are not paused.
GlobalVariable Property NHV_Cfg_Enabled Auto
; Days between "Hail Sithis!" and Q00, MCM slider 0-7, default 2 (E14).
GlobalVariable Property NHV_Cfg_StartDelay Auto

; DB11 "Hail Sithis!", verified 22.09.2026 via houseCARL against Skyrim.esm (docs/GOAL.md).
Quest Property HailSithisQuest Auto
; DBDestroy "Destroy the Dark Brotherhood!", the alternate path that keeps the mod inactive.
Quest Property DestroyQuest Auto
; NHV_Q00_ShadowAtTheDoor. Filled once the quest exists in the CK (M1.5).
Quest Property Q00 Auto
; DawnstarSanctuaryLocation, verified 22.09.2026 via houseCARL against Skyrim.esm.
Location Property DawnstarSanctuaryLocation Auto

Int iInstalledVersion = 0
; True between registering the start-delay timer and it firing; guards against a second
; registration if the player leaves and re-enters the Sanctuary before the delay elapses.
Bool bStartTimerPending = False

Event OnInit()
    Maintenance()
EndEvent

; Safe to run any number of times (OnInit now, on every game load once NHV_PlayerAliasScript exists).
Function Maintenance()
    If SKSE.GetVersion() <= 0
        NHV_Util.Log(NHV_Cfg_Debug, "SKSE missing, core inactive")
        Debug.MessageBox("Night's Harvest requires SKSE64 and stays inactive without it.")
        Return
    EndIf
    If iInstalledVersion < VERSION
        Migrate(iInstalledVersion)
        iInstalledVersion = VERSION
        Debug.Notification("Night's Harvest " + VERSION_TEXT + " loaded")
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Maintenance done, mod " + VERSION_TEXT + ", script version " + iInstalledVersion)
EndFunction

Function Migrate(Int aiFrom)
    ; One block per script version, in order, each idempotent. Never renumber or remove steps.
    ; If aiFrom < 2
    ;     ...
    ; EndIf
EndFunction

; All conditions from concept section 2, "Startbedingungen", except the Story Manager /
; location-change trigger itself, which the caller (NHV_PlayerAliasScript) already handled.
Bool Function CanStartQ00()
    If !NHV_Cfg_Enabled || NHV_Cfg_Enabled.GetValueInt() != 1
        Return False
    EndIf
    If !HailSithisQuest || !HailSithisQuest.IsCompleted()
        Return False
    EndIf
    If DestroyQuest && (DestroyQuest.IsRunning() || DestroyQuest.IsCompleted())
        Return False
    EndIf
    If !Q00 || Q00.IsRunning() || Q00.IsCompleted()
        Return False
    EndIf
    Return True
EndFunction

; Called by NHV_PlayerAliasScript.OnLocationChange() whenever the player enters any location.
; Cheap to call often: the location check happens before anything else runs.
Function OnEnterDawnstarSanctuary(Location akNewLoc)
    If akNewLoc != DawnstarSanctuaryLocation
        Return
    EndIf
    If bStartTimerPending || !CanStartQ00()
        Return
    EndIf
    Float fDelay = 0.0
    If NHV_Cfg_StartDelay
        fDelay = NHV_Cfg_StartDelay.GetValue()
    EndIf
    If fDelay <= 0.0
        StartQ00()
    Else
        bStartTimerPending = True
        RegisterForSingleUpdateGameTime(fDelay * 24.0)
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 start delayed by " + fDelay + " day(s)")
    EndIf
EndFunction

Event OnUpdateGameTime()
    bStartTimerPending = False
    ; Re-check: conditions may no longer hold (mod disabled, Destroy path taken meanwhile).
    If CanStartQ00()
        StartQ00()
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "Q00 start delay elapsed, but conditions no longer met")
    EndIf
EndEvent

Function StartQ00()
    Q00.Start()
    NHV_Util.Log(NHV_Cfg_Debug, "Q00 started")
EndFunction
