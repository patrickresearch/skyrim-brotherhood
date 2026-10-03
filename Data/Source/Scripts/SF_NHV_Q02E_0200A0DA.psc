;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Q02E_0200A0DA Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Q02Script kQ02_13 = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_13 != None
    kQ02_13.FinishSurrender()
EndIf
NHV_Util.FlowSet(0x00A007, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
