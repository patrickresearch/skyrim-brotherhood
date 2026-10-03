;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__020060E9 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
If kCore != None
    kCore.CompleteQ00()
EndIf
NHV_Util.FlowSet(0x006000, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
