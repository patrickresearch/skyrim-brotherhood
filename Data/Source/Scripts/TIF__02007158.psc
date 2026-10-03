;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02007158 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Util.FlowSet(0x00711E, 1)
NHV_Q01Script kQ01_4 = Game.GetFormFromFile(0x004000, "NightsHarvest.esp") as NHV_Q01Script
If kQ01_4 != None
    kQ01_4.EnableMarker(2)
EndIf
NHV_Util.FlowObjective(0x004000, 9005, 9006)
NHV_Util.FlowStage(0x004000, 25)
NHV_Util.FlowSet(0x007001, 0)
NHV_Util.FlowSet(0x00711C, 49)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
