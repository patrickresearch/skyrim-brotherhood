Scriptname NHV_MapTableScript extends ObjectReference
{Veyra's Map Table in the Ledger Room (Deep Sanctuary), attached to the activator base NHV_Act_MapTable
(decision E42, concept section 5). After Q01 the player picks the next recruitment contract here.
Only one contract runs at a time. Selecting a pin starts that contract's quest at Stage 10; Veyra's
briefing itself is the quest's own ForceGreet package (NHV_Pkg_Q02_BriefGreet for Q02), so this script only
makes sure she is close enough to greet. M2.0.

Button order of NHV_Msg_MapTable is fixed: 0 Windhelm (Q02), 1 Winterhold (Q03), 2 Riften (Q04),
3 The Reach (Q05), 4 Step away. Q03..Q05 stay None until their packages exist (additive, no re-save
of this script needed): the pin then answers "not marked yet".}

Actor Property PlayerRef Auto
GlobalVariable Property NHV_Cfg_Debug Auto
NHV_CoreScript Property Core Auto ; GetVeyraActor()
Message Property NHV_Msg_MapTable Auto ; the menu, see docs/ck/M2.0-Map-Table.md
Quest Property Q01 Auto ; unlock: Q01 Stage 100 reached
Quest Property Q02 Auto
Quest Property Q03 Auto ; None until M2.3
Quest Property Q04 Auto ; None until M2.4
Quest Property Q05 Auto ; None until M2.5
ObjectReference Property VeyraTableMarker Auto ; NHV_Mk_MapTable_Veyra, XMarker beside the table

Int Property UNLOCK_STAGE = 100 AutoReadOnly ; Q01 Homecoming
Int Property BRIEF_STAGE = 10 AutoReadOnly ; every contract opens with its briefing at Stage 10
Float Property VEYRA_NEAR_DISTANCE = 1200.0 AutoReadOnly ; farther than this she is moved to the table

; No re-entry guard state on purpose: Message.Show() is modal, and a state left behind by a save would
; lock the table for good.
Event OnActivate(ObjectReference akActionRef)
    If !PlayerRef
        NHV_Util.Log(NHV_Cfg_Debug, "MapTable: PlayerRef property not set in the CK")
        Return
    EndIf
    If akActionRef != PlayerRef
        Return
    EndIf
    ShowMenu()
EndEvent

Function ShowMenu()
    If !Q01 || !Q01.GetStageDone(UNLOCK_STAGE)
        NHV_Util.Log(NHV_Cfg_Debug, "MapTable: locked, Q01 Stage " + UNLOCK_STAGE + " not reached (or Q01 property empty)")
        Debug.Notification("The map shows only old marks. Veyra has not set a new pin.")
        Return
    EndIf
    If !NHV_Msg_MapTable
        NHV_Util.Log(NHV_Cfg_Debug, "MapTable: NHV_Msg_MapTable property not set in the CK")
        Return
    EndIf
    Int iButton = NHV_Msg_MapTable.Show()
    If iButton >= 0 && iButton <= 3
        Choose(iButton + 2) ; button 0 -> Q02 ... button 3 -> Q05
    EndIf
EndFunction

Quest Function GetContract(Int aiNumber)
    If aiNumber == 2
        Return Q02
    ElseIf aiNumber == 3
        Return Q03
    ElseIf aiNumber == 4
        Return Q04
    ElseIf aiNumber == 5
        Return Q05
    EndIf
    Return None
EndFunction

; True while any contract quest has been started and not yet completed (one recruitment contract at a time).
Bool Function IsAnyContractActive()
    Int iNumber = 2
    While iNumber <= 5
        Quest kQuest = GetContract(iNumber)
        If kQuest && kQuest.IsRunning() && !kQuest.IsCompleted()
            Return True
        EndIf
        iNumber += 1
    EndWhile
    Return False
EndFunction

Function Choose(Int aiNumber)
    Quest kContract = GetContract(aiNumber)
    If !kContract
        Debug.Notification("Veyra has not marked this place yet.")
        Return
    EndIf
    If kContract.IsCompleted()
        Debug.Notification("That pin is gone. The work there is done.")
        Return
    EndIf
    If IsAnyContractActive()
        Debug.Notification("Finish the contract you already carry first.")
        Return
    EndIf
    Actor kVeyra
    If Core
        kVeyra = Core.GetVeyraActor()
    EndIf
    If !kVeyra || kVeyra.IsDead()
        ; Her briefing is Veyra-only dialogue: starting the quest without her would leave it without an exit.
        NHV_Util.Log(NHV_Cfg_Debug, "MapTable: Veyra unavailable, contract " + aiNumber + " not started")
        Debug.Notification("Veyra is not here.")
        Return
    EndIf
    If kVeyra.IsInCombat()
        Debug.Notification("Not now.")
        Return
    EndIf
    ; Start() only when the quest is not running yet; SetStage() then opens the briefing.
    If !kContract.IsRunning()
        If !kContract.Start()
            NHV_Util.Log(NHV_Cfg_Debug, "MapTable: Start() failed for contract " + aiNumber)
            Return
        EndIf
    EndIf
    BringVeyraToTable(kVeyra) ; only after the start succeeded, so a failed start never leaves her displaced
    kContract.SetStage(BRIEF_STAGE)
    NHV_Util.Log(NHV_Cfg_Debug, "MapTable: contract " + aiNumber + " started")
EndFunction

; Her ForceGreet package only fires in hearing range; if she is elsewhere she is placed beside the table.
Function BringVeyraToTable(Actor akVeyra)
    If !VeyraTableMarker
        NHV_Util.Log(NHV_Cfg_Debug, "MapTable: VeyraTableMarker property not set in the CK")
        Return
    EndIf
    If akVeyra.IsDisabled()
        akVeyra.Enable()
    EndIf
    Cell kVeyraCell = akVeyra.GetParentCell()
    Bool bNear = kVeyraCell && kVeyraCell == PlayerRef.GetParentCell() && akVeyra.GetDistance(PlayerRef) < VEYRA_NEAR_DISTANCE
    If !bNear
        akVeyra.MoveTo(VeyraTableMarker)
    EndIf
EndFunction
