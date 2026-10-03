;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02007146 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Util.FlowSet(0x00711D, 1)
NHV_Q01Script kQ01_3 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
If kQ01_3 != None
    kQ01_3.OnMarkerReturned()
EndIf
NHV_Util.FlowObjective(0x004000, 9003, 9004)
NHV_Util.FlowStage(0x004000, 20)
NHV_Util.FlowSet(0x007000, 0)
NHV_Util.FlowSet(0x007001, 43)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
