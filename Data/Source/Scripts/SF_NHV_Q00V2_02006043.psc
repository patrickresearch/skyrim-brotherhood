;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Q00V2_02006043 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Util.FlowStage(0x000815, 12)
NHV_Util.FlowSet(0x006000, 0)
NHV_SanctuaryScript kSanct = Game.GetFormFromFile(0x000809, "NightsHarvest.esp") as NHV_SanctuaryScript
If kSanct != None
    kSanct.StartSummonCall(Game.GetFormFromFile(0x006042, "NightsHarvest.esp") as Scene)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
