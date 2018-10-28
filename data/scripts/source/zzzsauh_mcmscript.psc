Scriptname zzzsauh_mcmscript extends SKI_ConfigBase

GlobalVariable Property sauhState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhClothingExclusion Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhNPCEffectMethod Auto
GlobalVariable Property sauhEnemiesExclusion Auto
GlobalVariable Property sauhFollowersExclusion Auto
zzzsauh_PlayerScript Property PlayerScript Auto
Quest Property PlayerQuest Auto
Quest Property NPCDetector Auto
Quest Property FollowerDetector Auto
ReferenceAlias Property PlayerAlias Auto
Spell Property NpcCloakAbility Auto
MagicEffect Property ConfigEffect Auto
Bool Property bIsBusy = False Auto Hidden
Int flags
Bool bOnConfigOpen = False

String[] _npcInclusionStates
String[] _npcDistroMethods
Int[] _globals

Int Function getVersion()
	Return 101
EndFunction

Function initPages()
EndFunction

Function setArrays()
	_npcInclusionStates = New String[3]
	_npcInclusionStates[0] = "$NPCInclusionStates_0"
	_npcInclusionStates[1] = "$NPCInclusionStates_1"
	_npcInclusionStates[2] = "$NPCInclusionStates_2"
	_npcDistroMethods = New String[2]
	_npcDistroMethods[0] = "$NPCDistroMethods_0"
	_npcDistroMethods[1] = "$NPCDistroMethods_1"
EndFunction

Event OnVersionUpdate(Int version)
	If (version >= 101 && CurrentVersion < 101)
		Debug.Trace(self + ": Updating script to version " + 101)
	EndIf
EndEvent

Event OnGameReload()
	Parent.OnGameReload()
EndEvent

Event OnConfigInit()
	ModName = "AU Headgears"
	initPages()
EndEvent

Event OnConfigClose()
	GoToState("Commit")
EndEvent

Event OnConfigOpen()
	bOnConfigOpen = True
	getGlobals()
	bOnConfigOpen = False
EndEvent

Event OnPageReset(String page)
	SetTitleText("$mrt_AUH_ModName")
	SetCursorFillMode(TOP_TO_BOTTOM)
	If (GetState() == "Commit") || Game.GetPlayer().HasMagicEffect(ConfigEffect)
		AddHeaderOption("$mrt_AUH_Head_Busy")
		Return
	EndIf
	setArrays()
	AddHeaderOption("Auto Unequip Headgears v" + PlayerScript.getCurrentVersion())
	AddToggleOptionST("ENABLED_TOGGLE", "$mrt_AUH_ENABLED_TOGGLE", sauhState.GetValueInt())
	AddEmptyOption()
	AddHeaderOption("$mrt_AUH_Head_Headgear")
	If (sauhState.GetValueInt() != 0) && (sauhNPCEffectState.GetValueInt() == 2)
		flags = OPTION_FLAG_NONE
	Else
		flags = OPTION_FLAG_DISABLED
	EndIf
	AddToggleOptionST("CLOTHINGS_TOGGLE", "$mrt_AUH_CLOTHINGS_TOGGLE", sauhClothingExclusion.GetValueInt(), flags)
	AddToggleOptionST("UNUSUALS_TOGGLE", "$mrt_AUH_UNUSUALS_TOGGLE", sauhUnusualsExclusion.GetValueInt(), flags)
	
	SetCursorPosition(1)
	AddHeaderOption("$mrt_AUH_Head_NPC")
	If (sauhState.GetValueInt() != 0)
		flags = OPTION_FLAG_NONE
	Else
		flags = OPTION_FLAG_DISABLED
	EndIf
	AddMenuOptionST("NPC_INCLUSION_MENU", "$mrt_AUH_NPC_INCLUSION_MENU", _npcInclusionStates[sauhNPCEffectState.GetValueInt()], flags)
	If (sauhState.GetValueInt() != 0) && (sauhNPCEffectState.GetValueInt() == 2)
		flags = OPTION_FLAG_NONE
	Else
		flags = OPTION_FLAG_DISABLED
	EndIf
	AddToggleOptionST("FOLLOWERS_TOGGLE", "$mrt_AUH_FOLLOWERS_TOGGLE", sauhFollowersExclusion.GetValueInt(), flags)
	AddToggleOptionST("ENEMIES_TOGGLE", "$mrt_AUH_ENEMIES_TOGGLE", sauhEnemiesExclusion.GetValueInt(), flags)
	AddMenuOptionST("NPC_DISTRO_METHOD_MENU", "$mrt_AUH_NPC_DISTRO_METHOD_MENU", _npcDistroMethods[sauhNPCEffectMethod.GetValueInt()], flags)
EndEvent


State ENABLED_TOGGLE
	Event OnSelectST()
		If sauhState.GetValueInt()
			sauhState.SetValueInt(0)
		Else
			sauhState.SetValueInt(1)
		EndIf
		ForcePageReset()
	EndEvent

	Event OnDefaultST()
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_ENABLED_TOGGLE")
	EndEvent
EndState

State CLOTHINGS_TOGGLE
	Event OnSelectST()
		If sauhClothingExclusion.GetValueInt()
			sauhClothingExclusion.SetValueInt(0)
		Else
			sauhClothingExclusion.SetValueInt(1)
		EndIf
		SetToggleOptionValueST(sauhClothingExclusion.GetValueInt())
	EndEvent

	Event OnDefaultST()
		sauhClothingExclusion.SetValueInt(0)
		SetToggleOptionValueST(sauhClothingExclusion.GetValueInt())
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_CLOTHINGS_TOGGLE")
	EndEvent
EndState

State UNUSUALS_TOGGLE
	Event OnSelectST()
		If sauhUnusualsExclusion.GetValueInt()
			sauhUnusualsExclusion.SetValueInt(0)
		Else
			sauhUnusualsExclusion.SetValueInt(1)
		EndIf
		SetToggleOptionValueST(sauhUnusualsExclusion.GetValueInt())
	EndEvent

	Event OnDefaultST()
		sauhUnusualsExclusion.SetValueInt(1)
		SetToggleOptionValueST(sauhUnusualsExclusion.GetValueInt())
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_UNUSUALS_TOGGLE")
	EndEvent
EndState

State FOLLOWERS_TOGGLE
	Event OnSelectST()
		If sauhFollowersExclusion.GetValueInt()
			sauhFollowersExclusion.SetValueInt(0)
		Else
			sauhFollowersExclusion.SetValueInt(1)
		EndIf
		SetToggleOptionValueST(sauhFollowersExclusion.GetValueInt())
	EndEvent

	Event OnDefaultST()
		sauhFollowersExclusion.SetValueInt(0)
		SetToggleOptionValueST(sauhFollowersExclusion.GetValueInt())
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_FOLLOWERS_TOGGLE")
	EndEvent
EndState

State ENEMIES_TOGGLE
	Event OnSelectST()
		If sauhEnemiesExclusion.GetValueInt()
			sauhEnemiesExclusion.SetValueInt(0)
		Else
			sauhEnemiesExclusion.SetValueInt(1)
		EndIf
		SetToggleOptionValueST(sauhEnemiesExclusion.GetValueInt())
	EndEvent

	Event OnDefaultST()
		sauhEnemiesExclusion.SetValueInt(0)
		SetToggleOptionValueST(sauhEnemiesExclusion.GetValueInt())
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_ENEMIES_TOGGLE")
	EndEvent
EndState

State NPC_INCLUSION_MENU
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhNPCEffectState.GetValueInt())
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_npcInclusionStates)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhNPCEffectState.SetValue(index)
		SetMenuOptionValueST(_npcInclusionStates[sauhNPCEffectState.GetValueInt()],True)
		If sauhNPCEffectState.GetValueInt() == 2
			flags = OPTION_FLAG_NONE
		Else
			flags = OPTION_FLAG_DISABLED
		EndIf
		SetOptionFlagsST(flags, True, "CLOTHINGS_TOGGLE")
		SetOptionFlagsST(flags, True, "UNUSUALS_TOGGLE")
		SetOptionFlagsST(flags, "NPC_DISTRO_METHOD_MENU")
		ForcePageReset()
	EndEvent

	Event OnDefaultST()
		sauhNPCEffectState.SetValue(0)
		SetMenuOptionValueST(_npcInclusionStates[sauhNPCEffectState.GetValueInt()],True)
		flags = OPTION_FLAG_DISABLED
		SetOptionFlagsST(flags, True, "CLOTHINGS_TOGGLE")
		SetOptionFlagsST(flags, True, "UNUSUALS_TOGGLE")
		SetOptionFlagsST(flags, "NPC_DISTRO_METHOD_MENU")
		ForcePageReset()
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_NPC_INCLUSION")
	EndEvent
EndState

State NPC_DISTRO_METHOD_MENU
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhNPCEffectMethod.GetValueInt())
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(_npcDistroMethods)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhNPCEffectMethod.SetValue(index)
		SetMenuOptionValueST(_npcDistroMethods[sauhNPCEffectMethod.GetValueInt()])
	EndEvent

	Event OnDefaultST()
		sauhNPCEffectMethod.SetValue(1)
		SetMenuOptionValueST(_npcDistroMethods[sauhNPCEffectMethod.GetValueInt()])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_DISTRO_METHOD")
	EndEvent
EndState

Function checkGlobals()
	Float g = sauhNPCEffectState.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhNPCEffectState.SetValue(0)
	EndIf
EndFunction

Function getGlobals()
	checkGlobals()
	_globals = New Int[6]
	_globals[0] = sauhState.GetValueInt()
	_globals[1] = sauhUnusualsExclusion.GetValueInt()
	_globals[2] = sauhClothingExclusion.GetValueInt()
	_globals[3] = sauhNPCEffectState.GetValueInt()
	_globals[4] = sauhFollowersExclusion.GetValueInt()
	_globals[5] = sauhEnemiesExclusion.GetValueInt()
EndFunction

State Commit
	Event OnBeginState()
		If !bOnConfigOpen
			If _globals[0] != sauhState.GetValueInt()
				toggleSAUH(sauhState.GetValueInt(),False)
			ElseIf \
			(_globals[1] != sauhUnusualsExclusion.GetValueInt()) || \
			(_globals[2] != sauhClothingExclusion.GetValueInt()) || \
			(_globals[3] != sauhNPCEffectState.GetValueInt()) || \
			(_globals[4] != sauhFollowersExclusion.GetValueInt()) || \
			(_globals[5] != sauhEnemiesExclusion.GetValueInt())
				toggleSAUH(False)
				toggleSAUH(True)
			EndIf
		EndIf
		GoToState("")
	EndEvent
EndState

Function toggleSAUH(Bool bToggle, Bool bReset = True)
	If bToggle
		PlayerQuest.Start()
		sauhState.SetValue(1)
	Else
		PlayerQuest.Stop()
		Int i = 0
		While !PlayerQuest.IsStopped() && i < 50
			Utility.Wait(0.1)
			i += 1
		EndWhile
		NPCDetector.Stop()
		FollowerDetector.Stop()
		Game.GetPlayer().DispelSpell(NpcCloakAbility)
		Game.GetPlayer().RemoveSpell(NpcCloakAbility)
		sauhState.SetValue(0)
		If !bReset
			sauhNPCEffectState.SetValue(0)
		EndIf
		PlayerAlias.SendModEvent("AuhNpcEffectStop")
		Utility.Wait(3.0)
		Debug.notification("Auto Unequip Headgears Stopped")
	EndIf
EndFunction

