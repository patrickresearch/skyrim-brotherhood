;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Scn_Q00_09DeepIntro_02006F02 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
If kCore != None
    kCore.OnDeepIntroEnd()
EndIf
NHV_Util.FlowSet(0x006000, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
