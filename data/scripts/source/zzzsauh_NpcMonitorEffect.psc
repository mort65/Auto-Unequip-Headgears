Scriptname zzzsauh_NpcMonitorEffect Extends ActiveMagicEffect

zzzsauh_PlayerScript Property PlayerScript Auto
Keyword Property ArmorHelmet Auto
Keyword Property ClothingHead Auto
FormList Property HeadgearIgnoreList Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhClothingExclusion Auto
GlobalVariable Property sauhEnemiesExclusion Auto
GlobalVariable Property sauhFollowersExclusion Auto
GlobalVariable Property sauhGuardsExclusion Auto
Actor Property PlayerRef Auto
Spell Property NPCMonitorAbility Auto
Form[] ItemList
Actor MySelf
Int iNumRefresher = 0
Bool bUpdating = False

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If (akTarget As Actor) 
		If bIsIncluded(akTarget)
			MySelf = akTarget
			ItemList = New Form[5]
			RegisterHeadgears(MySelf)
			RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
			If !MySelf.IsPlayerTeammate()
				RegisterForModEvent("AuhOtherNpcEffectStop","OnAuhNpcEffectStop")
			EndIf
			RegisterForAnimationEvent(MySelf,"WeaponDraw")
			RegisterForAnimationEvent(MySelf,"WeaponSheathe")
			If !MySelf.IsWeaponDrawn()
				GoToState("Unequipping")
			Else
				GoToState("")
			EndIf
		Else
			Dispel()
		EndIf
	Else
		Dispel()
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If akTarget && !akTarget.IsDead()
		GoToState("Equipping")
	EndIf
	GoToState("Stopped")
EndEvent

Event OnPlayerLoadGame()
	RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
	If !MySelf.IsPlayerTeammate()
		RegisterForModEvent("AuhOtherNpcEffectStop","OnAuhNpcEffectStop")
	EndIf
EndEvent

Event OnAuhNpcEffectStop(String eventName, String strArg, Float numArg, Form sender)
	GoToState("Dispelling")
EndEvent

Event OnDying(Actor akKiller)
	GoToState("Stopped")
EndEvent

Event OnRaceSwitchComplete()
	If PlayerScript.DLC1VampireBeastRace && ( MySelf.GetRace() == PlayerScript.DLC1VampireBeastRace )
		GoToState("Waiting")
	Else
		GoToState("Resetting")
	EndIf
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	If ( akSource == MySelf ) && sauhNPCEffectState.GetValue()
		If asEventName == "WeaponDraw"
			GoToState("Equipping")
		ElseIf asEventName == "WeaponSheathe"
			GoToState("Unequipping")
		EndIf
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If ((sauhClothingExclusion.GetValue() != 2) && akBaseObject.HasKeyWord(ArmorHelmet)) || \
	((sauhClothingExclusion.GetValue() != 1) && akBaseObject.HasKeyWord(ClothingHead))
		UnRegisterForAnimationEvent(MySelf,"WeaponDraw")
		UnRegisterForAnimationEvent(MySelf,"WeaponSheathe")
		RegisterForSingleUpdate(1.0)
		bUpdating = True
	EndIf
EndEvent

Event OnUpdate()
	GoToState("Refreshing")
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
EndEvent

State Refreshing
	Event OnBeginState()
		iNumRefresher += 1
		bUpdating = False
		PlayerScript.ArrayClear(ItemList)
		If MySelf As Actor
			RegisterHeadgears(MySelf)
			iNumRefresher -= 1
			If !bUpdating && iNumRefresher <= 0
				RegisterForAnimationEvent(MySelf,"WeaponDraw")
				RegisterForAnimationEvent(MySelf,"WeaponSheathe")
			EndIf
			GoToState("")
		EndIf
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	EndEvent
	Event OnRaceSwitchComplete()
	EndEvent
EndState

State Resetting
	Event OnBeginState()
		PlayerScript.ArrayClear(ItemList)
		If MySelf As Actor
			RegisterHeadgears(MySelf)
			RegisterForAnimationEvent(MySelf,"WeaponDraw")
			RegisterForAnimationEvent(MySelf,"WeaponSheathe")
			GoToState("")
		EndIf
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	EndEvent
	Event OnRaceSwitchComplete()
	EndEvent
EndState

State Waiting
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	EndEvent
	Event OnRaceSwitchComplete()
		If MySelf.GetRace() != PlayerScript.DLC1VampireBeastRace
			RegisterForAnimationEvent(MySelf,"WeaponDraw")
			RegisterForAnimationEvent(MySelf,"WeaponSheathe")
			GoToState("")
		EndIf
	EndEvent
EndState

State Dispelling
	Event OnBeginState()
		If MySelf As Actor
			If ItemList
				Int i = ItemList.Length
				While i > 0
					i -= 1
					If ItemList[i] 
						If MySelf.GetItemCount(ItemList[i] As Armor) > 0
							If PlayerScript.bSKSE
								MySelf.EquipItemEx(ItemList[i])
							Else
								MySelf.EquipItem(ItemList[i], abSilent = True)
							EndIf
							ItemList[i] = None
							Utility.Wait(0.2)
						EndIf
					EndIf
				EndWhile
				ItemList[i] 
			EndIf
			MySelf.RemoveSpell(NPCMonitorAbility)
			MySelf.DispelSpell(NPCMonitorAbility)
		Else
			Dispel()
		EndIf
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	EndEvent
	Event OnRaceSwitchComplete()
	EndEvent
EndState

State Stopped
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	EndEvent
	Event OnRaceSwitchComplete()
	EndEvent
EndState

State Equipping
	Event OnBeginState()
		EquipHeadgears()
		GoToState("")
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState

State Unequipping
	Event OnBeginState()
		UnequipHeadgears()
		GoToState("")
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState

Bool Function bIsArmor(Form akBaseObject)
	Return akBaseObject && akBaseObject.GetType() == 26
EndFunction

Bool Function bIsHeadgear(Form akBaseObject)
	If ((sauhClothingExclusion.GetValue() != 2) && akBaseObject.HasKeyWord(ArmorHelmet)) || \
	((sauhClothingExclusion.GetValue() != 1) && akBaseObject.HasKeyWord(ClothingHead))
		Int SlotMask = (akBaseObject As Armor).GetSlotMask()
		Int i = PlayerScript.BlackList.Length
		While i > 0
			i -= 1
			If Math.LogicalAnd(SlotMask, PlayerScript.BlackList[i]) == PlayerScript.BlackList[i]
				Return False
			EndIf
		EndWhile
		i = 5
		While i > 0
			i -= 1
			If Math.LogicalAnd(SlotMask, PlayerScript.WhiteList[i]) == PlayerScript.WhiteList[i]
				Return True
			EndIf
		EndWhile
		Return False
	EndIf
	Return False
EndFunction

Bool Function bIsHeadgearValid(Form akBaseObject)
	Return !akBaseObject.HasKeywordString("magicdisallowenchanting") && iIsInList(akBaseObject,HeadgearIgnoreList) < 0
EndFunction

Function EquipHeadgears()
	Int i = ItemList.Length
	While i > 0
		i -= 1
		If ItemList[i] 
			If MySelf.GetItemCount(ItemList[i] As Armor) > 0
				If PlayerScript.bSKSE
					MySelf.EquipItemEx(ItemList[i])
				Else
					MySelf.EquipItem(ItemList[i], abSilent = True)
				EndIf
				Utility.Wait(0.2)
			Else
				ItemList[i] = None
			EndIf
		EndIf
	EndWhile
EndFunction

Function UnequipHeadgears()
	Int i = ItemList.Length
	While i > 0
		i -= 1
		If ItemList[i]
			MySelf.UnequipItem(ItemList[i], abSilent = True)
			Utility.Wait(0.2)
		EndIf
	EndWhile
EndFunction

Function RegisterHeadgears(Actor akActor)
	If akActor As Actor
		Form akArmor
		Int i = PlayerScript.WhiteList.Length
		Int j
		While i > 0
			i -= 1
			akArmor = akActor.GetWornForm(PlayerScript.WhiteList[i])
			If bIsArmor(akArmor) && bIsHeadgear(akArmor) && (sauhNPCEffectState.GetValue() != 2 || (!sauhUnusualsExclusion.GetValue() || bIsHeadgearValid(akArmor)))
				If ItemList.find(akArmor) < 0
					j = ItemList.Find(None)
					If j > -1
						ItemList[j] = akArmor
					EndIf
				EndIf
			EndIf
		EndWhile
	EndIf
EndFunction

Int Function iIsInList(Form akForm, FormList akFormList)
	If akForm && akFormList
		Int i = akFormList.GetSize()
		While i > 0
			i -= 1
			If akForm == akFormList.GetAt(i) As Form
				Return i
			EndIf
		Endwhile
	EndIf
	Return -1
EndFunction

Bool Function bIsIncluded(Actor akActor)
Return (!sauhFollowersExclusion.GetValue() || !akActor.IsPlayerTeammate()) && \
(!sauhGuardsExclusion.GetValue() || !akActor.IsGuard()) && \
(!sauhEnemiesExclusion.GetValue() || (!akActor.IsHostileToActor(PlayerRef) && (akActor.GetFactionReaction(PlayerRef) != 1)))
EndFunction