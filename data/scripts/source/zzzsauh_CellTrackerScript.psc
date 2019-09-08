Scriptname zzzsauh_CellTrackerScript extends activemagiceffect

Actor Property PlayerRef Auto
GlobalVariable Property sauhLocsExclusion Auto
GlobalVariable Property sauhLocsInclusion Auto
GlobalVariable Property sauhCurrentLocExcluded Auto
GlobalVariable Property sauhCurrentLocIncluded Auto
Objectreference Property StalkerObject Auto
GlobalVariable Property sauhCurrentLocState Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdate(0.5)
EndEvent

Event OnUpdate()
	sauhCurrentLocExcluded.SetValueInt(bIsCurLocExcluded() As Int)
	sauhCurrentLocState.SetValueInt(((!sauhLocsInclusion.GetValueInt() || sauhCurrentLocIncluded.GetValue()) && !sauhCurrentLocExcluded.GetValue()) As Int)
	StalkerObject.MoveTo(PlayerRef)
EndEvent


Bool Function bIsCurLocExcluded()
	Int iExclude = sauhLocsExclusion.GetValueInt()
	If iExclude
		Return PlayerRef.IsInInterior() == (iExclude - 1) As Bool
	EndIf
	Return False
EndFunction