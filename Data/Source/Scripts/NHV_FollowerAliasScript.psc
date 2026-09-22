Scriptname NHV_FollowerAliasScript extends ReferenceAlias
{Attached to FollowerSlot1 (M1.6) / FollowerSlot2 (M2.1) in NHV_Sys_Family. Own follower
system, no CurrentFollowerFaction entry, so the vanilla follower slot stays free and
follower frameworks do not pick the recruit up (docs/ARCHITECTURE.md). Commands come from
dialogue fragments calling the functions below; catch-up runs only while State == Following,
via a re-registering single update, never a permanent OnUpdate loop (docs/CONVENTIONS.md rule 1).}

Actor Property PlayerRef Auto
GlobalVariable Property NHV_Cfg_Debug Auto

; Distance in game units before a catch-up teleport, and how often to check.
Float Property CATCHUP_DISTANCE = 2500.0 AutoReadOnly
Float Property CATCHUP_INTERVAL = 5.0 AutoReadOnly

Function StartFollowing()
    If GetState() == "Following"
        Return  ; RegisterForSingleUpdate does not dedupe; a second call would stack timers
    EndIf
    GotoState("Following")
    NHV_Util.Log(NHV_Cfg_Debug, "Follower: start following")
    RegisterForSingleUpdate(CATCHUP_INTERVAL)
EndFunction

Function WaitHere()
    GotoState("")
    NHV_Util.Log(NHV_Cfg_Debug, "Follower: wait here")
EndFunction

Function GoHome(ObjectReference akHomeMarker)
    GotoState("")
    Actor kFollower = GetActorRef()
    If kFollower && akHomeMarker
        kFollower.MoveTo(akHomeMarker)
    EndIf
    NHV_Util.Log(NHV_Cfg_Debug, "Follower: sent home")
EndFunction

Function OpenGear()
    Actor kFollower = GetActorRef()
    If kFollower && PlayerRef
        kFollower.OpenInventory(True)
    EndIf
EndFunction

; Only registered while State == Following; stops re-registering as soon as WaitHere()/
; GoHome() switches back to the default state, so no update ever fires after that.
State Following
    Event OnUpdate()
        Actor kFollower = GetActorRef()
        If !kFollower || kFollower.IsDead() || !PlayerRef
            Return  ; do not re-register: the alias is empty or the follower died
        EndIf
        If kFollower.GetDistance(PlayerRef) > CATCHUP_DISTANCE && !kFollower.IsInCombat()
            kFollower.MoveTo(PlayerRef)
            NHV_Util.Log(NHV_Cfg_Debug, "Follower: catch-up teleport")
        EndIf
        RegisterForSingleUpdate(CATCHUP_INTERVAL)
    EndEvent
EndState
