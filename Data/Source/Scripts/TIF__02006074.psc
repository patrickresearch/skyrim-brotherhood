;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02006074 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_Util.FlowSet(0x006007, 1)
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
If kCore != None
    kCore.BeginVeyraReturnToSanctuary()
EndIf
NHV_Util.FlowObjective(0x000815, 30, 31)
NHV_Util.FlowSet(0x006000, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
