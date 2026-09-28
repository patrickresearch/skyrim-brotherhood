;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__02004087 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If NHV_Status_Hrefna != None && NHV_Status_Hrefna.GetValueInt() == 1
    Actor kHrefna = HrefnaFamilySlot.GetActorRef()
    If kHrefna
        kHrefna.Say(HrefnaStewTopic)
    EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property NHV_Status_Hrefna Auto
ReferenceAlias Property HrefnaFamilySlot Auto
Topic Property HrefnaStewTopic Auto
