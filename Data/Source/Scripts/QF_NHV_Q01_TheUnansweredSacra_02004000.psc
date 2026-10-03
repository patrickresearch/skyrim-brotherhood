;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 14
Scriptname QF_NHV_Q01_TheUnansweredSacra_02004000 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9001)
SetObjectiveDisplayed(9002)
NHV_Util.FlowSet(0x007001, 32)
NHV_Util.FlowSet(0x007000, 35)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.FillVeyraAlias()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9003)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9005)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.FillVeyraAlias()
    kQ01.BeginVeyraWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9007)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.EnableMarker(2)
    kQ01.BeginWatchpostWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9008)
SetObjectiveDisplayed(9009)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.EnableMarker(3)
    kQ01.BeginCampWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9010)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9014)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9014)
    SetObjectiveCompleted(9014)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9015)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.MakeQuintusMortal()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9014)
    SetObjectiveCompleted(9014)
EndIf
If IsObjectiveDisplayed(9015)
    SetObjectiveCompleted(9015)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9016)
SetObjectiveDisplayed(9017)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9014)
    SetObjectiveCompleted(9014)
EndIf
If IsObjectiveDisplayed(9015)
    SetObjectiveCompleted(9015)
EndIf
If IsObjectiveDisplayed(9016)
    SetObjectiveCompleted(9016)
EndIf
If IsObjectiveDisplayed(9017)
    SetObjectiveCompleted(9017)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9018)
SetObjectiveDisplayed(9019)
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
If kCore != None
    kCore.CompleteVeyraReturnToSanctuary()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
If IsObjectiveDisplayed(9001)
    SetObjectiveCompleted(9001)
EndIf
If IsObjectiveDisplayed(9002)
    SetObjectiveCompleted(9002)
EndIf
If IsObjectiveDisplayed(9003)
    SetObjectiveCompleted(9003)
EndIf
If IsObjectiveDisplayed(9005)
    SetObjectiveCompleted(9005)
EndIf
If IsObjectiveDisplayed(9007)
    SetObjectiveCompleted(9007)
EndIf
If IsObjectiveDisplayed(9008)
    SetObjectiveCompleted(9008)
EndIf
If IsObjectiveDisplayed(9009)
    SetObjectiveCompleted(9009)
EndIf
If IsObjectiveDisplayed(9010)
    SetObjectiveCompleted(9010)
EndIf
If IsObjectiveDisplayed(9014)
    SetObjectiveCompleted(9014)
EndIf
If IsObjectiveDisplayed(9015)
    SetObjectiveCompleted(9015)
EndIf
If IsObjectiveDisplayed(9016)
    SetObjectiveCompleted(9016)
EndIf
If IsObjectiveDisplayed(9017)
    SetObjectiveCompleted(9017)
EndIf
If IsObjectiveDisplayed(9018)
    SetObjectiveCompleted(9018)
EndIf
If IsObjectiveDisplayed(9019)
    SetObjectiveCompleted(9019)
EndIf
If IsObjectiveDisplayed(9004)
    SetObjectiveCompleted(9004)
EndIf
If IsObjectiveDisplayed(9006)
    SetObjectiveCompleted(9006)
EndIf
If IsObjectiveDisplayed(9011)
    SetObjectiveCompleted(9011)
EndIf
If IsObjectiveDisplayed(9012)
    SetObjectiveCompleted(9012)
EndIf
If IsObjectiveDisplayed(9013)
    SetObjectiveCompleted(9013)
EndIf
SetObjectiveDisplayed(9020)
SetObjectiveDisplayed(9021)
NHV_Q01Script kQ01 = (Self as Quest) as NHV_Q01Script
If kQ01 != None
    kQ01.BeginDebriefWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
