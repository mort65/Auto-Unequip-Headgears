Scriptname zzzsauh_mcmscript extends SKI_ConfigBase

GlobalVariable Property sauhState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhClothingExclusion Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhNPCEffectMethod Auto
GlobalVariable Property sauhNPCModifMethod Auto
GlobalVariable Property sauhEnemiesExclusion Auto
GlobalVariable Property sauhFollowersExclusion Auto
GlobalVariable Property sauhGuardsExclusion Auto
GlobalVariable Property sauhLocsExclusion Auto
GlobalVariable Property sauhLocsInclusion Auto
GlobalVariable Property sauhIsBusy Auto
Spell Property CellChangeDetector Auto
zzzsauh_PlayerScript Property PlayerScript Auto
Quest Property PlayerQuest Auto
Quest Property NPCDetector Auto
Quest Property FollowerDetector Auto
ReferenceAlias Property PlayerAlias Auto
Spell Property NpcCloakAbility Auto
Spell Property NpcModifSpell Auto
MagicEffect Property ConfigEffect Auto
Bool Property bIsBusy = False Auto Hidden
Objectreference Property StalkerObject Auto
Int flags
Bool bOnConfigOpen = False

String[] _npcInclusionStates
String[] _npcDistroMethods
String[] _headgearIncStates
String[] _npcModifMethods
String[] _locsExclusion
String[] _locsInclusion
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
	_headgearIncStates = New String[3]
	_headgearIncStates[0] = "$HeadgearIncStates_0"
	_headgearIncStates[1] = "$HeadgearIncStates_1"
	_headgearIncStates[2] = "$HeadgearIncStates_2"
	_npcModifMethods = New String[3]
	_npcModifMethods[0] = "$npcModifMethod_0"
	_npcModifMethods[1] = "$npcModifMethod_1"
	_npcModifMethods[2] = "$npcModifMethod_2"
	_locsExclusion = New String[3]
	_locsExclusion[0] = "$locExclusionState_0"
	_locsExclusion[1] = "$locExclusionState_1"
	_locsExclusion[2] = "$locExclusionState_2"
	_locsInclusion = New String[3]
	_locsInclusion[0] = "$locInclusionState_0"
	_locsInclusion[1] = "$locInclusionState_1"
	_locsInclusion[2] = "$locInclusionState_2"
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
	AddToggleOptionST("GUARDS_TOGGLE", "$mrt_AUH_GUARDS_TOGGLE", sauhGuardsExclusion.GetValueInt(), flags)
	AddToggleOptionST("FOLLOWERS_TOGGLE", "$mrt_AUH_FOLLOWERS_TOGGLE", sauhFollowersExclusion.GetValueInt(), flags)
	AddToggleOptionST("ENEMIES_TOGGLE", "$mrt_AUH_ENEMIES_TOGGLE", sauhEnemiesExclusion.GetValueInt(), flags)
	AddMenuOptionST("NPC_DISTRO_METHOD_MENU", "$mrt_AUH_NPC_DISTRO_METHOD_MENU", _npcDistroMethods[sauhNPCEffectMethod.GetValueInt()], flags)
	AddMenuOptionST("NPC_MODIF_METHOD_MENU", "$mrt_AUH_NPC_MODIF_METHOD_MENU", _npcModifMethods[sauhNPCModifMethod.GetValueInt()], flags)
	SetCursorPosition(1)
	AddHeaderOption("$mrt_AUH_Head_Headgear")
	If (sauhState.GetValueInt() != 0) && (sauhNPCEffectState.GetValueInt() == 2)
		flags = OPTION_FLAG_NONE
	Else
		flags = OPTION_FLAG_DISABLED
	EndIf
	AddMenuOptionST("HEADGEARS_INCLUSION_MENU", "$mrt_AUH_HEADGEARS_INCLUSION_MENU", _headgearIncStates[sauhClothingExclusion.GetValueInt()], flags)
	AddToggleOptionST("UNUSUALS_TOGGLE", "$mrt_AUH_UNUSUALS_TOGGLE", sauhUnusualsExclusion.GetValueInt(), flags)
	AddEmptyOption()
	AddHeaderOption("$mrt_AUH_Head_Loc")
	AddMenuOptionST("LOCS_INCLUSION_MENU", "$mrt_AUH_LOCS_INCLUSION_MENU", _locsInclusion[sauhLocsInclusion.GetValueInt()], flags)
	AddMenuOptionST("LOCS_EXCLUSION_MENU", "$mrt_AUH_LOCS_EXCLUSION_MENU", _locsExclusion[sauhLocsExclusion.GetValueInt()], flags)
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

State HEADGEARS_INCLUSION_MENU

	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhClothingExclusion.GetValueInt())
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_headgearIncStates)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhClothingExclusion.SetValue(index)
		SetMenuOptionValueST(_headgearIncStates[sauhClothingExclusion.GetValueInt()],True)
	EndEvent

	Event OnDefaultST()
		sauhClothingExclusion.SetValue(0)
		SetMenuOptionValueST(_headgearIncStates[sauhClothingExclusion.GetValueInt()],True)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_HEADGEARS_INCLUSION_MENU")
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

State GUARDS_TOGGLE
	Event OnSelectST()
		If sauhGuardsExclusion.GetValueInt()
			sauhGuardsExclusion.SetValueInt(0)
		Else
			sauhGuardsExclusion.SetValueInt(1)
		EndIf
		SetToggleOptionValueST(sauhGuardsExclusion.GetValueInt())
	EndEvent

	Event OnDefaultST()
		sauhGuardsExclusion.SetValueInt(0)
		SetToggleOptionValueST(sauhGuardsExclusion.GetValueInt())
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_GUARDS_TOGGLE")
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
		SetOptionFlagsST(flags, True, "HEADGEARS_INCLUSION_MENU")
		SetOptionFlagsST(flags, True, "UNUSUALS_TOGGLE")
		SetOptionFlagsST(flags, True, "NPC_DISTRO_METHOD_MENU")
		SetOptionFlagsST(flags, "NPC_MODIF_METHOD_MENU")
		ForcePageReset()
	EndEvent

	Event OnDefaultST()
		sauhNPCEffectState.SetValue(0)
		SetMenuOptionValueST(_npcInclusionStates[sauhNPCEffectState.GetValueInt()],True)
		flags = OPTION_FLAG_DISABLED
		SetOptionFlagsST(flags, True, "HEADGEARS_INCLUSION_MENU")
		SetOptionFlagsST(flags, True, "UNUSUALS_TOGGLE")
		SetOptionFlagsST(flags, True, "NPC_MODIF_METHOD_MENU")
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

State LOCS_EXCLUSION_MENU
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhLocsExclusion.GetValueInt())
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_locsExclusion)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhLocsExclusion.SetValue(index)
		SetMenuOptionValueST(_locsExclusion[sauhLocsExclusion.GetValueInt()])
	EndEvent

	Event OnDefaultST()
		sauhLocsExclusion.SetValue(0)
		SetMenuOptionValueST(_locsExclusion[sauhLocsExclusion.GetValueInt()])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_LOCS_EXCLUSION")
	EndEvent
EndState

State LOCS_INCLUSION_MENU
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhLocsInclusion.GetValueInt())
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_locsInclusion)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhLocsInclusion.SetValue(index)
		SetMenuOptionValueST(_locsInclusion[sauhLocsInclusion.GetValueInt()])
	EndEvent

	Event OnDefaultST()
		sauhLocsInclusion.SetValue(0)
		SetMenuOptionValueST(_locsInclusion[sauhLocsInclusion.GetValueInt()])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_LOCS_INCLUSION")
	EndEvent
EndState

State NPC_MODIF_METHOD_MENU
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(sauhNPCModifMethod.GetValueInt())
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_npcModifMethods)
	EndEvent

	Event OnMenuAcceptST(int index)
		sauhNPCModifMethod.SetValue(index)
		If sauhNPCModifMethod.GetValueInt() > 0
			Game.GetPlayer().AddSpell(NpcModifSpell)
		Else
			Game.GetPlayer().RemoveSpell(NpcModifSpell)
		EndIf
		SetMenuOptionValueST(_npcModifMethods[sauhNPCModifMethod.GetValueInt()])
	EndEvent

	Event OnDefaultST()
		sauhNPCModifMethod.SetValue(0)
		Game.GetPlayer().RemoveSpell(NpcModifSpell)
		SetMenuOptionValueST(_npcModifMethods[sauhNPCModifMethod.GetValueInt()])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$mrt_AUH_DESC_MODIF_METHOD")
	EndEvent
EndState

Function checkGlobals()
	Float g = sauhNPCEffectState.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhNPCEffectState.SetValue(0)
	EndIf
	g == sauhClothingExclusion.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhClothingExclusion.SetValue(0)
	EndIf
	g = sauhLocsInclusion.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhLocsInclusion.SetValue(0)
	EndIf
	g = sauhLocsExclusion.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhLocsExclusion.SetValue(0)
	EndIf
EndFunction

Function getGlobals()
	checkGlobals()
	_globals = New Int[9]
	_globals[0] = sauhState.GetValueInt()
	_globals[1] = sauhUnusualsExclusion.GetValueInt()
	_globals[2] = sauhClothingExclusion.GetValueInt()
	_globals[3] = sauhNPCEffectState.GetValueInt()
	_globals[4] = sauhFollowersExclusion.GetValueInt()
	_globals[5] = sauhEnemiesExclusion.GetValueInt()
	_globals[6] = sauhGuardsExclusion.GetValueInt()
	_globals[7] = sauhLocsExclusion.GetValueInt()
	_globals[8] = sauhLocsInclusion.GetValueInt()
EndFunction

State Commit
	Event OnBeginState()
		sauhIsBusy.SetValueInt(1)
		If !bOnConfigOpen
			If _globals[0] != sauhState.GetValueInt()
				toggleSAUH(sauhState.GetValueInt(),False)
			ElseIf \
			(_globals[1] != sauhUnusualsExclusion.GetValueInt()) || \
			(_globals[2] != sauhClothingExclusion.GetValueInt()) || \
			(_globals[3] != sauhNPCEffectState.GetValueInt()) || \
			(_globals[4] != sauhFollowersExclusion.GetValueInt()) || \
			(_globals[5] != sauhEnemiesExclusion.GetValueInt()) || \
			(_globals[6] != sauhGuardsExclusion.GetValueInt()) || \
			(_globals[7] != sauhLocsExclusion.GetValueInt()) || \
			(_globals[8] != sauhLocsInclusion.GetValueInt())
				toggleSAUH(False)
				toggleSAUH(True)
			EndIf
		EndIf
		sauhIsBusy.SetValueInt(0)
		GoToState("")
	EndEvent
EndState

Function toggleSAUH(Bool bToggle, Bool bReset = True)
	If bToggle
		PlayerQuest.Start()
		sauhState.SetValue(1)
		If sauhNPCEffectState.GetValueInt() == 2
			PlayerScript.updateLocState(Game.GetPlayer().GetCurrentLocation())
			If sauhLocsExclusion.GetValueInt()
				Game.GetPlayer().AddSpell(CellChangeDetector,False)
			EndIf
		EndIf
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
		Game.GetPlayer().RemoveSpell(NpcModifSpell)
		sauhState.SetValue(0)
		If !bReset
			sauhNPCEffectState.SetValue(0)
			Game.GetPlayer().RemoveSpell(CellChangeDetector)
			StalkerObject.MoveToMyEditorLocation()
		EndIf
		PlayerAlias.SendModEvent("AuhNpcEffectStop")
		Utility.Wait(3.0)
		Debug.notification("Auto Unequip Headgears Stopped")
	EndIf
EndFunction

