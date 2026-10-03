;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Q01V2_020071C8 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Util.FlowSet(0x007124, 2)
NHV_Q01Script kQ01_11 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
If kQ01_11 != None
    kQ01_11.CaptureOutcome()
EndIf
NHV_Util.FlowSet(0x007001, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
