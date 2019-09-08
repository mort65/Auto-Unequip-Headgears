Scriptname zzzsauh_NPCExclusionEffect extends activemagiceffect

Spell Property NPCExclusionAbility Auto
Actor MySelf


Event OnEffectStart(Actor akTarget, Actor akCaster)
	MySelf = akTarget
	RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
EndEvent

Event OnPlayerLoadGame()
	RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
EndEvent

Event OnAuhNpcEffectStop(String eventName, String strArg, Float numArg, Form sender)
	If MySelf As Actor
		MySelf.RemoveSpell(NPCExclusionAbility)
		MySelf.DispelSpell(NPCExclusionAbility)
	Else
		Dispel()
	EndIf
EndEvent
