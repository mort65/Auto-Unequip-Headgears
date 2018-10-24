Scriptname zzzsauh_ConfigScript extends activemagiceffect

Quest Property PlayerQuest Auto
Quest Property NPCDetector Auto
Quest Property FollowerDetector Auto
Message Property sauhConfigMenu Auto
Message Property sauhConfigMenu0 Auto
Message Property sauhConfigMenu3 Auto
Message Property sauhConfigMenu4 Auto
GlobalVariable Property sauhState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhNPCEffectMethod Auto
GlobalVariable Property sauhClothingExclusion Auto
ReferenceAlias Property PlayerAlias Auto
Spell Property NpcCloakAbility Auto
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
				aiMessage = 2
			ElseIf aiButton == 2
				aiMessage = 3
			ElseIf aiButton == 3
				toggleSAUH(True)
			ElseIf aiButton == 4
				toggleSAUH(False)
			ElseIf aiButton == 5 ;Exit
				Return
			EndIf
		ElseIf aiMessage == 1
			aiButton = sauhConfigMenu0.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				toggleSAUH(False)
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
			aiButton = sauhConfigMenu4.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				Float g = sauhNPCEffectState.GetValue()
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(g)
				sauhUnusualsExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 1
				Float g = sauhNPCEffectState.GetValue()
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(g)
				sauhUnusualsExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 2
				Float g = sauhNPCEffectState.GetValue()
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(g)
				sauhClothingExclusion.SetValue(0)
				toggleSAUH(True)
			ElseIf aiButton == 3
				Float g = sauhNPCEffectState.GetValue()
				toggleSAUH(False)
				sauhNPCEffectState.SetValue(g)
				sauhClothingExclusion.SetValue(1)
				toggleSAUH(True)
			ElseIf aiButton == 4
				aiMessage = 0
			ElseIf aiButton == 5
				return
			EndIf
		ElseIf aiMessage == 3
			aiButton = sauhConfigMenu3.Show()
			If aiButton == -1
			ElseIf aiButton == 0
				sauhNPCEffectMethod.SetValue(0)
			ElseIf aiButton == 1
				sauhNPCEffectMethod.SetValue(1)
			ElseIf aiButton == 2
				aiMessage = 0
			ElseIf aiButton == 3
				return
			EndIf
		EndIf
	EndWhile
EndFunction

Function checkGlobals()
	Float g = sauhNPCEffectState.GetValue()
	If g != 0.0 && g != 1.0 && g != 2.0
		sauhNPCEffectState.SetValue(0)
	EndIf
EndFunction

State Busy
	Event OnEffectStart(Actor akTarget, Actor akCaster)
	EndEvent
EndState

Function toggleSAUH(Bool bToggle)
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
		sauhNPCEffectState.SetValue(0)
		PlayerAlias.SendModEvent("AuhNpcEffectStop")
		Utility.Wait(3.0)
		Debug.notification("Auto Unequip Headgears Stopped")
	EndIf
EndFunction
