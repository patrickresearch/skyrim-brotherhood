;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname QF_NHV_Q02_ColdWaters_02004100 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(10)
NHV_Util.FlowSet(0x00A005, 1)
NHV_Util.FlowSet(0x00A008, 3)
NHV_Util.FlowSet(0x00A001, 5)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.FillVeyraAlias()
    kQ02.PatchStageActivators()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(15)
NHV_Util.FlowSet(0x00A003, 7)
NHV_Util.FlowSet(0x00A002, 1000)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.PatchStageActivators()
    kQ02.BeginTidehouse()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(20)
NHV_Util.FlowSet(0x00A008, 13)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.PatchStageActivators()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(30)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.PatchStageActivators()
    kQ02.SetHaldorSaved(False)
    kQ02.BeginNightWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(45)
NHV_Util.FlowSet(0x00A006, 15)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.PatchStageActivators()
    kQ02.BeginSaltYard()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(45)
    SetObjectiveCompleted(45)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(50)
NHV_Util.FlowSet(0x00A007, 19)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.MoveSingsToHollow()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(45)
    SetObjectiveCompleted(45)
EndIf
If IsObjectiveDisplayed(50)
    SetObjectiveCompleted(50)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(55)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.BeginAeliusObservation()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(45)
    SetObjectiveCompleted(45)
EndIf
If IsObjectiveDisplayed(50)
    SetObjectiveCompleted(50)
EndIf
If IsObjectiveDisplayed(55)
    SetObjectiveCompleted(55)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(60)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.BeginKillWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(45)
    SetObjectiveCompleted(45)
EndIf
If IsObjectiveDisplayed(50)
    SetObjectiveCompleted(50)
EndIf
If IsObjectiveDisplayed(55)
    SetObjectiveCompleted(55)
EndIf
If IsObjectiveDisplayed(60)
    SetObjectiveCompleted(60)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(70)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.OnStage70()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
If IsObjectiveDisplayed(10)
    SetObjectiveCompleted(10)
EndIf
If IsObjectiveDisplayed(15)
    SetObjectiveCompleted(15)
EndIf
If IsObjectiveDisplayed(20)
    SetObjectiveCompleted(20)
EndIf
If IsObjectiveDisplayed(30)
    SetObjectiveCompleted(30)
EndIf
If IsObjectiveDisplayed(40)
    SetObjectiveCompleted(40)
EndIf
If IsObjectiveDisplayed(45)
    SetObjectiveCompleted(45)
EndIf
If IsObjectiveDisplayed(50)
    SetObjectiveCompleted(50)
EndIf
If IsObjectiveDisplayed(55)
    SetObjectiveCompleted(55)
EndIf
If IsObjectiveDisplayed(60)
    SetObjectiveCompleted(60)
EndIf
If IsObjectiveDisplayed(70)
    SetObjectiveCompleted(70)
EndIf
If IsObjectiveDisplayed(71)
    SetObjectiveCompleted(71)
EndIf
If IsObjectiveDisplayed(101)
    SetObjectiveCompleted(101)
EndIf
SetObjectiveDisplayed(100)
NHV_Util.FlowSet(0x00A005, 35)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.FillVeyraAlias()
    kQ02.BeginDebriefWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
