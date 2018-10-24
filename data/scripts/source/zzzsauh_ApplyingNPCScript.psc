Scriptname zzzsauh_ApplyingNPCScript Extends ActiveMagicEffect

Spell Property NPCMonitorAbility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;Debug.Trace(Self + " adding monitor spell to " + akTarget)
	akTarget.AddSpell(NPCMonitorAbility)
EndEvent