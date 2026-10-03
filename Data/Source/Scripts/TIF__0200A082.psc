;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0200A082 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Util.FlowStage(0x004100, 55)
NHV_Util.FlowSet(0x00A007, 0)
NHV_Q02Script kQ02_18 = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_18 != None
    kQ02_18.BeginAeliusObservation()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
