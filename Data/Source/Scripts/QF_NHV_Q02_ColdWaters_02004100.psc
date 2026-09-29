;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname QF_NHV_Q02_ColdWaters_02004100 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(10)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.FillVeyraAlias()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(30)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.SetHaldorSaved(False)
    kQ02.BeginNightWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SetObjectiveCompleted(30)
SetObjectiveDisplayed(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
SetObjectiveCompleted(40)
SetObjectiveDisplayed(50)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.MoveSingsToHollow()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveCompleted(50)
SetObjectiveDisplayed(60)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.BeginKillWatch()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
SetObjectiveCompleted(60)
SetObjectiveDisplayed(70)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.GiveOculatusFragment()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
SetObjectiveCompleted(70)
SetObjectiveDisplayed(100)
NHV_Q02Script kQ02 = (Self as Quest) as NHV_Q02Script
If kQ02 != None
    kQ02.FillVeyraAlias()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

