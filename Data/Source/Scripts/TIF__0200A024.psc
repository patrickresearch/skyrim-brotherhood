;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0200A024 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Q02Script kQ02_3 = Game.GetFormFromFile(0x004100, "NightsHarvest.esp") as NHV_Q02Script
If kQ02_3 != None
    kQ02_3.PayBribe()
EndIf
NHV_Util.FlowSet(0x00A001, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
