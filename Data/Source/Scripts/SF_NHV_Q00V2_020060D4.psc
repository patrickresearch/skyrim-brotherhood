;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Q00V2_020060D4 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
NHV_Util.FlowSet(0x006008, 2)
NHV_Util.FlowSet(0x000814, 2)
NHV_Util.FlowObjective(0x000815, 60, 61)
NHV_Util.FlowSet(0x006000, 0)
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
If kCore != None
    kCore.OnMemorialChosen()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
