;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Q00V2_0200603B Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_SanctuaryScript kSanct = Game.GetFormFromFile(0x000809, "NightsHarvest.esp") as NHV_SanctuaryScript
If kSanct != None
    kSanct.FinishSummonCall()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
