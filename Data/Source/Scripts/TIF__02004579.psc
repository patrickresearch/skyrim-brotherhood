;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02004579 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
NHV_CoreScript kCore = Game.GetFormFromFile(0x000801, "NightsHarvest.esp") as NHV_CoreScript
NHV_SanctuaryScript kS = Game.GetFormFromFile(0x000809, "NightsHarvest.esp") as NHV_SanctuaryScript
If kS != None && kS.IsSummonPending()
    ; the player already accepted (call scene running): ignore the decline
ElseIf kCore != None
    kCore.OnDoubtDeclined()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
