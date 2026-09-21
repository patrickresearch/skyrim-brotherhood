# Papyrus-Vorlagen – Night's Harvest

Ausgangspunkte, keine fertigen Scripts. Namen, Properties und Logik an das Konzept anpassen.

## Inhalt

1. Core-Controller
2. Player-Alias
3. Util (globale Funktionen)
4. Contract-Basisklasse
5. Magic Effect (Sense the Darkness)
6. MCM mit SkyUI-State-API
7. Fragmente

## 1. Core-Controller

```papyrus
Scriptname NHV_CoreScript extends Quest
{Controller for Night's Harvest: versioning, maintenance, runtime faction setup. Concept section 14.}

Int Property VERSION = 1 AutoReadOnly  ; bump for every save-relevant change

Actor Property PlayerRef Auto
GlobalVariable Property NHV_Cfg_Enabled Auto
GlobalVariable Property NHV_Cfg_Debug Auto
Faction Property NHV_FamilyFaction Auto
Faction Property DarkBrotherhoodFaction Auto
Message Property NHV_Msg_SkseMissing Auto

Int iInstalledVersion = 0

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    If SKSE.GetVersion() <= 0
        NHV_Msg_SkseMissing.Show()
        Return
    EndIf
    If iInstalledVersion < VERSION
        Migrate(iInstalledVersion)
        iInstalledVersion = VERSION
        NHV_Util.Log(NHV_Cfg_Debug, "Migrated to version " + VERSION)
    EndIf
    NHV_FamilyFaction.SetAlly(DarkBrotherhoodFaction)  ; runtime only, no record edit
EndFunction

Function Migrate(Int aiFrom)
    ; One block per version, in order, each idempotent.
    ; If aiFrom < 2
    ;     ...
    ; EndIf
EndFunction
```

## 2. Player-Alias

Alias `Player` in `NHV_Sys_Core`, Fill-Type „Specific Reference“ → PlayerRef.

```papyrus
Scriptname NHV_PlayerAliasScript extends ReferenceAlias
{Runs maintenance on every save load.}

NHV_CoreScript Property Core Auto

Event OnPlayerLoadGame()
    Core.Maintenance()
EndEvent
```

## 3. Util

```papyrus
Scriptname NHV_Util Hidden
{Global helpers. No state, no properties.}

Function Log(GlobalVariable akDebugFlag, String asMsg) Global
    If akDebugFlag && akDebugFlag.GetValueInt() == 1
        Debug.Trace("[NHV] " + asMsg)
    EndIf
EndFunction

Function SendRecruitEvent(String asEventName, Form akRecruit) Global
    Int iHandle = ModEvent.Create(asEventName)
    If iHandle
        ModEvent.PushForm(iHandle, akRecruit)
        ModEvent.Send(iHandle)
    EndIf
EndFunction
```

## 4. Contract-Basisklasse

Status-Werte der Globals `NHV_Status_<Name>` laut Konzept Abschnitt 5: 0 = unbekannt, 1 = rekrutiert, 2 = getötet, 3 = freigelassen, 4 = Sonderfall (ausgeliefert, verhaftet). Nicht umnummerieren.

```papyrus
Scriptname NHV_ContractBaseScript extends Quest
{Shared logic for recruitment contracts Q01-Q05. Concept section 5.}

GlobalVariable Property StatusGlobal Auto        ; NHV_Status_<Name>
GlobalVariable Property NHV_FamilyStrength Auto
GlobalVariable Property NHV_Cfg_Debug Auto
Faction Property NHV_FamilyFaction Auto
ReferenceAlias Property RecruitAlias Auto
ObjectReference Property HomeMarker Auto         ; bed/sandbox marker in Deep Sanctuary

Int Property STATUS_UNKNOWN = 0 AutoReadOnly
Int Property STATUS_RECRUITED = 1 AutoReadOnly
Int Property STATUS_KILLED = 2 AutoReadOnly
Int Property STATUS_RELEASED = 3 AutoReadOnly
Int Property STATUS_SPECIAL = 4 AutoReadOnly  ; delivered, arrested

Function Homecoming()
    Actor kRecruit = RecruitAlias.GetActorRef()
    If !kRecruit || kRecruit.IsDead()
        NHV_Util.Log(NHV_Cfg_Debug, GetID() + ": Homecoming without living recruit")
        Return
    EndIf
    kRecruit.AddToFaction(NHV_FamilyFaction)
    kRecruit.MoveTo(HomeMarker)
    StatusGlobal.SetValueInt(STATUS_RECRUITED)
    NHV_FamilyStrength.Mod(1)
    NHV_Util.SendRecruitEvent("NHV_RecruitJoined", kRecruit)
    OnHomecoming(kRecruit)  ; hook for the concrete contract
EndFunction

Function RecruitDied()
    StatusGlobal.SetValueInt(STATUS_KILLED)
    NHV_Util.SendRecruitEvent("NHV_RecruitDied", RecruitAlias.GetActorRef())
    OnRecruitDied()
EndFunction

; Hooks - override in NHV_Q0xScript
Function OnHomecoming(Actor akRecruit)
EndFunction

Function OnRecruitDied()
EndFunction
```

Konkreter Contract:

```papyrus
Scriptname NHV_Q01Script extends NHV_ContractBaseScript
{Q01 The Unanswered Sacrament - Hrefna Stormhollow. Concept section 7.}

Function OnHomecoming(Actor akRecruit)
    ; quest-specific: enable kitchen furniture, give reward, etc.
EndFunction
```

## 5. Magic Effect

Eignungs-Conditions stehen am Magic-Effect-Record (nativ, schnell); das Script markiert nur.

```papyrus
Scriptname NHV_SenseDarknessEffect extends ActiveMagicEffect
{Marks eligible recruitment candidates. Conditions live on the MGEF record.}

Faction Property NHV_CandidateFaction Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    If akTarget && !akTarget.IsInFaction(NHV_CandidateFaction)
        akTarget.AddToFaction(NHV_CandidateFaction)
    EndIf
EndEvent
```

## 6. MCM (SkyUI, State-API)

```papyrus
Scriptname NHV_MCMScript extends SKI_ConfigBase
{Night's Harvest MCM. Concept section 16. All values live in NHV_Cfg_* globals.}

GlobalVariable Property NHV_Cfg_StartDelay Auto

Int Function GetVersion()
    Return 1
EndFunction

Event OnConfigInit()
    Pages = new String[2]
    Pages[0] = "$NHV_Page_Status"
    Pages[1] = "$NHV_Page_General"
EndEvent

Event OnPageReset(String a_page)
    If a_page == "$NHV_Page_General"
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddSliderOptionST("StartDelay", "$NHV_StartDelay", NHV_Cfg_StartDelay.GetValue(), "{0}")
    EndIf
EndEvent

State StartDelay
    Event OnSliderOpenST()
        SetSliderDialogStartValue(NHV_Cfg_StartDelay.GetValue())
        SetSliderDialogDefaultValue(2.0)
        SetSliderDialogRange(0.0, 7.0)
        SetSliderDialogInterval(1.0)
    EndEvent

    Event OnSliderAcceptST(Float a_value)
        NHV_Cfg_StartDelay.SetValue(a_value)
        SetSliderOptionValueST(a_value, "{0}")
    EndEvent

    Event OnDefaultST()
        NHV_Cfg_StartDelay.SetValue(2.0)
        SetSliderOptionValueST(2.0, "{0}")
    EndEvent

    Event OnHighlightST()
        SetInfoText("$NHV_StartDelay_Info")
    EndEvent
EndState
```

Neue Seiten oder Optionen in bestehenden Spielständen: `GetVersion()` erhöhen und `OnVersionUpdate(Int a_version)` nutzen.

## 7. Fragmente

Quest-Stage (im CK im Feld „kmyQuest“ das Quest-Script wählen):

```papyrus
; NHV_Q01_UnansweredSacrament, Stage 100
kmyQuest.Homecoming()
```

Dialog-INFO (End-Fragment):

```papyrus
GetOwningQuest().SetStage(40)
; call contract functions via cast: (GetOwningQuest() as NHV_Q01Script).SomeFunction()
```

Szene (Phase-Fragment): nur Stage setzen oder eine Funktion des Quest-Scripts aufrufen, keine Logik im Fragment.
