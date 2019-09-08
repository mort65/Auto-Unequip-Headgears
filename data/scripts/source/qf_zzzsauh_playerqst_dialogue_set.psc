;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 15
Scriptname qf_zzzsauh_playerQst_dialogue_Set Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_14
Function Fragment_14(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akspeaker.addspell(NPCMonitorAbility)
akspeaker.removespell(NPCExclusionAbility)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property NPCMonitorAbility Auto
Spell Property NPCExclusionAbility Auto
