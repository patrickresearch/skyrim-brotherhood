Scriptname NHV_OculatusScript extends Quest
{Controller for the Oculatus main-arc (Hauptbogen, E28-E31): a hidden heat counter fed by contract
quests, interludes and the Dawnstar informant. The counter is only ever told, never shown to the
player except as an MCM debug value (E28). Attached to NHV_Sys_Oculatus (Start Game Enabled).
docs/plan/Hauptbogen-Oculatus.md, docs/plan/Hauptbogen-Technik.md.

Public API for other quests/scripts (never rename or remove once released, Regel 3):
  Function ReportEvidence(Int aiAmount, String asReason) - any contract/interlude/informant script
    calls this to raise or lower the heat counter. aiAmount is added to iHeat, clamped 0-5. asReason
    is a short tag for the Papyrus log only, not shown to the player.
  Int Function GetHeat() - current heat value (0-5).
  Int Function GetHeatStage() - bucketed stage for narrative use only (0 Unbemerkt 0-1, 1 Fragt nach
    2-3, 2 Handelt 4, 3 Vollalarm 5, docs/plan/Hauptbogen-Oculatus.md 2.2). CK Conditions on individual
    interludes compare the raw heat value directly (GetGlobalValue NHV_Status_OculatusHeat >= N), not
    this bucketed stage - see NHV_IL01Script/NHV_IL02Script for the exact thresholds.
  Bool Function TryClaimInterlude(Int aiInterludeId) - 1 = First Blood, 2 = Knock at Dawnstar. Returns
    True only the first time for a given ID, False on every later call. The authoritative,
    quest-independent completion flag for each interlude (bIL01Done/bIL02Done below): a quest restart
    resets the interlude quest's own local state, but NHV_Sys_Oculatus itself is never restarted, so
    this is where the "already booked" guard has to live to prevent double heat booking.

CK Conditions read NHV_Status_OculatusHeat (a GlobalVariable, type Short, mirroring iHeat), never this
script directly - a custom quest script's Int property is not a valid Condition source, and
Papyrus-Regel 2 ("Conditions vor Scripts") asks for a Condition-readable value wherever one already
exists.

Maintenance()/Migrate() follow the NHV_CoreScript pattern (docs/ARCHITECTURE.md) but are this quest's
own, independent version chain - NHV_CoreScript.VERSION is not touched or reused here, the same
exception NHV_MCMScript already uses for its own VERSION (docs/CONVENTIONS.md, Papyrus-Regel 10).
Maintenance() runs from NHV_OculatusPlayerAliasScript.OnPlayerLoadGame() (a new alias script on this
quest's own PlayerRef alias, not the existing NHV_PlayerAliasScript - Regel: no existing .psc touched).}

GlobalVariable Property NHV_Cfg_Debug Auto
; Mirrors iHeat for MCM debug display and for CK Conditions. E28: never surfaced on a normal MCM page,
; only the debug page. Type Short in the CK, not Constant (Team-Lead review round 2).
GlobalVariable Property NHV_Status_OculatusHeat Auto

; This quest's own script version. Bump for every save-relevant change and add one idempotent step
; to Migrate(). Independent of NHV_CoreScript.VERSION (documented exception, see class doc comment).
Int Property VERSION = 1 AutoReadOnly
Int iInstalledVersion = 0

Int iHeat = 0

; Authoritative, quest-independent completion flags for the two v1.0 interludes - see
; TryClaimInterlude() in the class doc comment. Never rename (Regel 3).
Bool bIL01Done = False
Bool bIL02Done = False

Event OnInit()
    Maintenance()
EndEvent

; Safe to run any number of times (OnInit now, on every game load via NHV_OculatusPlayerAliasScript).
Function Maintenance()
    If iInstalledVersion < VERSION
        Migrate(iInstalledVersion)
        iInstalledVersion = VERSION
    EndIf
    EnsureHeatMirror()
    NHV_Util.Log(NHV_Cfg_Debug, "NHV_Sys_Oculatus Maintenance done, heat=" + iHeat)
EndFunction

Function Migrate(Int aiFrom)
    ; One block per script version, in order, each idempotent. Never renumber or remove steps.
    ; If aiFrom < 2
    ;     ...
    ; EndIf
EndFunction

; Refills NHV_Status_OculatusHeat from iHeat (the script variable, not the ESP default) whenever it
; might be stale - a fresh install, or a save from before this Global existed. Idempotent.
Function EnsureHeatMirror()
    If NHV_Status_OculatusHeat
        NHV_Status_OculatusHeat.SetValueInt(iHeat)
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "EnsureHeatMirror: NHV_Status_OculatusHeat property not set in the CK")
    EndIf
EndFunction

; Public entry point, see the class-level doc comment. Never renamed/removed once released (Regel 3).
Function ReportEvidence(Int aiAmount, String asReason)
    Int iBefore = iHeat
    iHeat += aiAmount
    If iHeat < 0
        iHeat = 0
    ElseIf iHeat > 5
        iHeat = 5
    EndIf
    EnsureHeatMirror()
    If iHeat != iBefore
        NHV_Util.Log(NHV_Cfg_Debug, "ReportEvidence: " + asReason + " (" + iBefore + " -> " + iHeat + ")")
    Else
        NHV_Util.Log(NHV_Cfg_Debug, "ReportEvidence: " + asReason + " (no change, heat=" + iHeat + ")")
    EndIf
EndFunction

Int Function GetHeat()
    Return iHeat
EndFunction

; 0 Unbemerkt (0-1), 1 Fragt nach (2-3), 2 Handelt (4), 3 Vollalarm (5). Narrative use only (Veyra's
; comments, journal text) - CK Conditions never call this, see class doc comment.
Int Function GetHeatStage()
    If iHeat >= 5
        Return 3
    ElseIf iHeat >= 4
        Return 2
    ElseIf iHeat >= 2
        Return 1
    EndIf
    Return 0
EndFunction

; See the class-level doc comment. aiInterludeId: 1 = First Blood, 2 = Knock at Dawnstar. Called from
; the interlude quest's own Conclude() before it reports any heat change, so a restarted interlude
; quest (its own bResolved is quest-instance state and resets with the quest) can never book heat
; twice. Unknown IDs are logged and refused, never silently claimed.
Bool Function TryClaimInterlude(Int aiInterludeId)
    If aiInterludeId == 1
        If bIL01Done
            Return False
        EndIf
        bIL01Done = True
        Return True
    ElseIf aiInterludeId == 2
        If bIL02Done
            Return False
        EndIf
        bIL02Done = True
        Return True
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "TryClaimInterlude: unknown interlude id " + aiInterludeId)
    Return False
EndFunction
