Scriptname NHV_FamilyManagerScript extends Quest
{Registers new recruits, tracks NHV_FamilyStrength, manages the follower slot.
Attached to NHV_Sys_Family (starts at Q00 Stage 100). Concept sections 5 and 14, M1.6.}

GlobalVariable Property NHV_FamilyStrength Auto
GlobalVariable Property NHV_Cfg_Debug Auto
; Reserved for M1.7 (ReleaseFollower/Kaltstellen removing the recruit from the family faction);
; not read yet, kept as a property so the CK-side record exists before M1.7 needs it.
Faction Property NHV_FamilyFaction Auto

; One follower slot for M1.6; a second slot and the MCM cap (0-2) follow in M2.1.
; Typed as the alias script (not plain ReferenceAlias) so AssignFollower can call StartFollowing().
NHV_FollowerAliasScript Property FollowerSlot1 Auto

Event OnInit()
    RegisterForModEvent("NHV_RecruitJoined", "OnRecruitJoined")
EndEvent

; Re-registers the listener on every load; RegisterForModEvent is idempotent (Papyrus
; replaces an existing registration for the same event+callback rather than stacking it).
Event OnPlayerLoadGame()
    RegisterForModEvent("NHV_RecruitJoined", "OnRecruitJoined")
EndEvent

Event OnRecruitJoined(String asEventName, String asStrArg, Float afNumArg, Form akSender)
    Actor kRecruit = akSender as Actor
    If !kRecruit
        NHV_Util.Log(NHV_Cfg_Debug, "OnRecruitJoined: sender is not an Actor")
        Return
    EndIf
    If NHV_FamilyStrength
        NHV_Util.Log(NHV_Cfg_Debug, "Family strength now " + NHV_FamilyStrength.GetValue())
    EndIf
EndEvent

; True if the single M1.6 follower slot has no living actor in it.
Bool Function IsFollowerSlotFree()
    If !FollowerSlot1
        Return False  ; property not filled in the CK yet; treat as unavailable, not free
    EndIf
    Actor kCurrent = FollowerSlot1.GetActorRef()
    Return !kCurrent || kCurrent.IsDead()
EndFunction

; Puts akRecruit into the follower slot. Caller (dialogue fragment) checks
; IsFollowerSlotFree() first; this function does not itself release an occupied slot.
Function AssignFollower(Actor akRecruit)
    If !akRecruit || !FollowerSlot1
        Return
    EndIf
    FollowerSlot1.ForceRefTo(akRecruit)
    akRecruit.SetPlayerTeammate(True, False)
    FollowerSlot1.StartFollowing()
    NHV_Util.Log(NHV_Cfg_Debug, akRecruit.GetLeveledActorBase().GetName() + " joined the follower slot")
EndFunction

Function ReleaseFollower()
    If !FollowerSlot1
        Return
    EndIf
    Actor kCurrent = FollowerSlot1.GetActorRef()
    If kCurrent
        kCurrent.SetPlayerTeammate(False, False)
    EndIf
    FollowerSlot1.Clear()
EndFunction
