Scriptname NHV_Q02_StageActivatorScript extends ObjectReference
{Generic Q02 activator: shows an optional Message and advances the Q02 stage when the player activates it.
Used for the latest victim (Stage 10 -> 20), the three tracking clues (Stage 40, the last one -> 50) and,
attached to the Drowned Hollow entrance door reference in the CK, Stage 40 -> 50 (Pfad A). M2.2.}

Quest Property OwningQuest Auto
Int Property RequiredStage = 0 Auto ; only reacts while GetStage() == this (0 = any stage)
Int Property TargetStage = 0 Auto   ; SetStage(this) if the quest is below it (0 = none)
Message Property ClueMessage Auto   ; optional popup (text lives in the plugin, from dialogue/Q02.csv)
GlobalVariable Property NHV_Cfg_Debug Auto
Bool bShown = False ; the popup appears once per reference

Event OnActivate(ObjectReference akActionRef)
    If akActionRef != Game.GetPlayer()
        Return
    EndIf
    If !OwningQuest
        NHV_Util.Log(NHV_Cfg_Debug, "NHV_Q02_StageActivatorScript: OwningQuest not set")
        Return
    EndIf
    If RequiredStage > 0 && OwningQuest.GetStage() != RequiredStage
        Return
    EndIf
    If ClueMessage && !bShown
        bShown = True
        ClueMessage.Show()
    EndIf
    If TargetStage > 0 && OwningQuest.GetStage() < TargetStage
        OwningQuest.SetStage(TargetStage)
    EndIf
EndEvent
