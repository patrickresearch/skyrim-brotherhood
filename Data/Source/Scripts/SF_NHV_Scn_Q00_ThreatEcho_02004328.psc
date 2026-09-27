;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Scn_Q00_ThreatEcho_02004328 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; NHV_Q00_010_71: Nazir's suspicion (010_52,70-71) hands off to the shared closing scene (010_72-73)
Scene kNext = Game.GetFormFromFile(0x00432F, "NightsHarvest.esp") as Scene
; Not after a combat/death abort: the regular 010_62 path still leads to stage 15.
If kNext != None && !Game.GetPlayer().IsInCombat()
    kNext.Start()
Else
    Debug.Trace("[NHV] ThreatEcho ended without starting the closing scene (combat or scene missing)")
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
