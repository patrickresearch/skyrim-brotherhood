;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__020071A0 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Util.FlowSet(0x007123, 2)
NHV_Q01Script kQ01_6 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
If kQ01_6 != None
    kQ01_6.QuintusToFarm()
EndIf
NHV_Util.FlowStage(0x004000, 48)
NHV_Util.FlowSet(0x007001, 71)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
