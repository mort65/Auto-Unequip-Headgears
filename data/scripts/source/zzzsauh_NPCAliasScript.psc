Scriptname zzzsauh_NPCAliasScript extends ReferenceAlias

Spell Property zzzsauh_NpcMonitorAbility Auto

Event OnInit()
	If Self.GetActorRef()
		;Debug.Trace(Self + " adding monitor spell to " + Self.GetActorRef())
		Self.GetActorRef().AddSpell(zzzsauh_NpcMonitorAbility)
	EndIf
EndEvent