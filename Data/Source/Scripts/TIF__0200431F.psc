;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0200431F Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; NHV_Q00_010_127: peaceful verdict choice -> shared closing scene (070-73)
Scene kNext = Game.GetFormFromFile(0x00432F, "NightsHarvest.esp") as Scene
If kNext != None
    kNext.Start()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
