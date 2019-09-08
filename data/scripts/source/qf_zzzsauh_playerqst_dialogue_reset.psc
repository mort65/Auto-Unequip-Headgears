;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname qf_zzzsauh_playerQst_dialogue_Reset Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If akspeaker.HasSpell(NPCExclusionAbility)
	If akspeaker.HasSpell(NPCMonitorAbility)
		akspeaker.RemoveSpell(NPCMonitorAbility)
	EndIf
Else
	akspeaker.RemoveSpell(NPCMonitorAbility)
	Utility.Wait(1.0)
	If !akspeaker.HasSpell(NPCMonitorAbility)
		akspeaker.AddSpell(NPCMonitorAbility)
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property NPCMonitorAbility Auto
Spell Property NPCExclusionAbility Auto
