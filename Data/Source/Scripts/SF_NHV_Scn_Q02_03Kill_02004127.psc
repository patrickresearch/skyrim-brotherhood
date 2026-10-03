;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Scn_Q02_03Kill_02004127 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Q02Script kQ02_K = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_K != None
    kQ02_K.EndAeliusKillScene(kQ02_K.KillAelius())
EndIf
NHV_Util.FlowSet(0x00A005, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
