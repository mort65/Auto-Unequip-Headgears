Scriptname zzzsauh_ConfigScript extends activemagiceffect

Quest Property PlayerQuest Auto
Quest Property NPCDetector Auto
Quest Property FollowerDetector Auto
Message Property sauhConfigMenu Auto
Message Property sauhConfigMenu0 Auto
Message Property sauhConfigMenu1 Auto
Message Property sauhConfigMenu2 Auto
Message Property sauhConfigMenu3 Auto
Message Property sauhConfigMenu4 Auto
Message Property sauhConfigMenu5 Auto
Message Property sauhConfigMenu6 Auto
Message Property sauhConfigMenu7 Auto
Message Property sauhConfigMenu8 Auto
Message Property sauhConfigMenu9 Auto
Message Property sauhConfigMenu10 Auto
Message Property sauhConfigMenu11 Auto
Message Property sauhConfigMenu12 Auto
Message Property sauhConfigMenu13 Auto
GlobalVariable Property sauhState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhNPCEffectMethod Auto
GlobalVariable Property sauhNPCModifMethod Auto
GlobalVariable Property sauhClothingExclusion Auto
GlobalVariable Property sauhFollowersExclusion Auto
GlobalVariable Property sauhEnemiesExclusion Auto
GlobalVariable Property sauhGuardsExclusion Auto
GlobalVariable Property sauhLocsExclusion Auto
GlobalVariable Property sauhLocsInclusion Auto
ReferenceAlias Property PlayerAlias Auto
Spell Property NpcCloakAbility Auto
Spell Property NpcModifSpell Auto
Spell Property CellChangeDetector Auto
Objectreference Property StalkerObject Auto
zzzsauh_PlayerScript Property PlayerScript Auto
zzzsauh_mcmscript Property MCMScript Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If MCMScript.GetState() == "Commit"
		Dispel()
	Else
		GoToState("Busy")
		If akTarget == Game.GetPlayer()
			checkGlobals()
			configMenu()
		EndIf
		GoToState("")
	EndIf
EndEvent

Function configMenu(Int aiMessage = 0, Int aiButton = 0)
	While True
		If aiButton == -1
		ElseIf aiMessage == 0
			aiButton = sauhConfigMenu.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				aiMessage = 1
			ElseIf aiButton == 1
				aiMessage = 7
			ElseIf aiButton == 2
				aiMessage = 8
			ElseIf aiButton == 3
				aiMessage = 9
			ElseIf aiButton == 4
				aiMessage = 12
			ElseIf aiButton == 5
				aiMessage = 6
			ElseIf aiButton == 6
				Return
			EndIf
		ElseIf aiMessage == 1
			aiButton = sauhConfigMenu0.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False,False)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 2
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(2)
				toggleSAUH(True)
			ElseIf aiButton == 3
				aiMessage = 0
			ElseIf aiButton == 4
				return
			EndIf
		ElseIf aiMessage == 2
			aiButton = sauhConfigMenu1.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
				sauhFollowersExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhFollowersExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 2
				aiMessage = 8
			ElseIf aiButton == 3
				Return
			EndIf
		ElseIf aiMessage == 3
			aiButton = sauhConfigMenu2.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
				sauhEnemiesExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhEnemiesExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 2
				aiMessage = 8
			ElseIf aiButton == 3
				Return
			EndIf
		ElseIf aiMessage == 4
			aiButton = sauhConfigMenu4.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
				sauhUnusualsExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhUnusualsExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 2
				aiMessage = 9
			ElseIf aiButton == 3
				return
			EndIf
		ElseIf aiMessage == 5
			aiButton = sauhConfigMenu3.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				sauhNPCEffectMethod.SetValue(0)
			ElseIf aiButton == 1
				sauhNPCEffectMethod.SetValue(1)
			ElseIf aiButton == 2
				aiMessage = 8
			ElseIf aiButton == 3
				return
			EndIf
		ElseIf aiMessage == 6
			aiButton = sauhConfigMenu5.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(True,False)
			ElseIf aiButton == 1
				toggleSAUH(False,False)
			ElseIf aiButton == 2
				aiMessage = 0
			ElseIf aiButton == 3
				Return
			EndIf
		ElseIf aiMessage == 7
			aiButton = sauhConfigMenu6.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
				sauhClothingExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhClothingExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 2
				toggleSAUH(False)
				sauhClothingExclusion.SetValue(2)
				toggleSAUH(True)
			ElseIf aiButton == 3
				aiMessage = 0
			ElseIf aiButton == 4
				Return
			EndIf
		ElseIf aiMessage == 8
			aiButton = sauhConfigMenu7.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				aiMessage = 2
			ElseIf aiButton == 1
				aiMessage = 10
			ElseIf aiButton == 2
				aiMessage = 3
			ElseIf aiButton == 3
				aiMessage = 5
			ElseIf aiButton == 4
				aiMessage = 11
			ElseIf aiButton == 5
				aiMessage = 0
			ElseIf aiButton == 6
				Return
			EndIf
		ElseIf aiMessage == 9
			aiButton = sauhConfigMenu8.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				aiMessage = 4
			ElseIf aiButton == 1
				aiMessage = 0
			ElseIf aiButton == 2
				Return
			EndIf
		ElseIf aiMessage == 10
			aiButton = sauhConfigMenu9.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
				sauhGuardsExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 1
				toggleSAUH(False)
				sauhGuardsExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 2
				aiMessage = 8
			ElseIf aiButton == 3
				Return
			EndIf
		ElseIf aiMessage == 11
			aiButton = sauhConfigMenu10.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				Game.GetPlayer().RemoveSpell(NpcModifSpell)
				sauhNPCModifMethod.SetValue(0)
			ElseIf aiButton == 1
				Game.GetPlayer().AddSpell(NpcModifSpell)
				sauhNPCModifMethod.SetValue(1)
			ElseIf aiButton == 2
				Game.GetPlayer().AddSpell(NpcModifSpell)
				sauhNPCModifMethod.SetValue(2)
			ElseIf aiButton == 3
				aiMessage = 8
			ElseIf aiButton == 4
				Return
			EndIf
		ElseIf aiMessage == 12
			aiButton = sauhConfigMenu11.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				aiMessage = 13
			ElseIf aiButton == 1
				aiMessage = 14
			ElseIf aiButton == 2
				aiMessage = 0
			ElseIf aiButton == 3
				Return
			EndIf
		ElseIf aiMessage == 13
			aiButton = sauhConfigMenu13.Show()
			If aiButton == -1
			ElseIf aiButton < 3
				toggleSAUH(False)
				sauhLocsInclusion.SetValue(aiButton)
				toggleSAUH(True)
			ElseIf aiButton == 3
				aiMessage = 12
			ElseIf aiButton == 4
				Return
			EndIf
		ElseIf aiMessage == 14
			aiButton = sauhConfigMenu12.Show()
			If aiButton == -1
			ElseIf aiButton < 3
				toggleSAUH(False)
				sauhLocsExclusion.SetValue(aiButton)
				toggleSAUH(True)
			ElseIf aiButton == 3
				aiMessage = 12
			ElseIf aiButton == 4
				Return
			EndIf
		EndIf
	EndWhile
EndFunction

Function checkGlobals()
	Float g = sauhNPCEffectState.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhNPCEffectState.SetValue(0)
	EndIf
	g == sauhClothingExclusion.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhClothingExclusion.SetValue(0)
	EndIf
EndFunction

State Busy
	Event OnEffectStart(Actor akTarget, Actor akCaster)
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