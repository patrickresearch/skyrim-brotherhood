;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0200A0CE Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Q02Script kQ02_1 = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_1 != None
    kQ02_1.JudgeSurrender()
EndIf
NHV_Q02Script kQ02_19 = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_19 != None
    kQ02_19.DelayScene(0x00A0CB, 3.0)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
