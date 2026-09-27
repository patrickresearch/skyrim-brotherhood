;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02000863 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; NHV_Q00_010_51: after Veyra's threat response, Nazir's suspicion hands off into the shared closing sequence (010_52,70-71)
Scene kNext = Game.GetFormFromFile(0x004328, "NightsHarvest.esp") as Scene
If kNext != None
    kNext.Start()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
