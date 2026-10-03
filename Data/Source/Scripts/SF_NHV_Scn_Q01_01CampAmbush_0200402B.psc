;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Scn_Q01_01CampAmbush_0200402B Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Q01Script kQ01_23 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
If kQ01_23 != None
    kQ01_23.EndCampAmbush()
EndIf
NHV_Util.FlowSet(0x007001, 7)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
