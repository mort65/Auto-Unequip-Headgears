Scriptname zzzsauh_NPCEffectModifier extends ActiveMagicEffect  

Message Property NPCMonitorModifierMenu Auto
Spell Property NPCMonitorAbility Auto
Spell Property NPCExclusionAbility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If !akTarget
		Return
	EndIf
	Int iIndex = NPCMonitorModifierMenu.Show()
	If iIndex == 0 ;Adjust
		If akTarget.HasSpell(NPCExclusionAbility)
			If akTarget.HasSpell(NPCMonitorAbility)
				akTarget.RemoveSpell(NPCMonitorAbility)
			EndIf
		Else
			akTarget.RemoveSpell(NPCMonitorAbility)
			Utility.Wait(1.0)
			If !akTarget.HasSpell(NPCMonitorAbility)
				akTarget.AddSpell(NPCMonitorAbility)
			EndIf
		EndIf
	ElseIf iIndex == 1 ;Always
		akTarget.AddSpell(NPCExclusionAbility)
		akTarget.RemoveSpell(NPCMonitorAbility)
	ElseIf iIndex == 2 ;in Combat
		akTarget.AddSpell(NPCMonitorAbility)
		akTarget.RemoveSpell(NPCExclusionAbility)
	EndIf
	Utility.Wait(0.5)
EndEvent