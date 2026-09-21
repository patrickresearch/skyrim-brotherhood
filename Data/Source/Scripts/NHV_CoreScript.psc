Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: SKSE check, versioning, maintenance. Attached to NHV_Sys_Core (Start Game Enabled). Concept section 14, smoke-test build 0.0.1 (M0.6).}

; Script version. Bump for every save-relevant change and add one idempotent step to Migrate().
Int Property VERSION = 1 AutoReadOnly
; Human-readable mod version, keep in sync with fomod/info.xml and the git tag.
String Property VERSION_TEXT = "0.0.1" AutoReadOnly

GlobalVariable Property NHV_Cfg_Debug Auto

Int iInstalledVersion = 0

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
