;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_NHV_Scn_Q00_Close_0200432F Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; NHV_Q00_010_73: shared closing sequence finished -> Stage 15 (BeginVeyraExitSanctuary runs in the quest's own Stage-15 fragment)
Quest kQuest = GetOwningQuest()
; Only from stage 10: 010_62 (TIF__02000865) may already have set 15, and a later stage must never go back.
If kQuest != None && kQuest.GetStage() == 10
    kQuest.SetStage(15)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
