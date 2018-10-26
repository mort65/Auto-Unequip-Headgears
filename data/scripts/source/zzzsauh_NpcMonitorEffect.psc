Scriptname zzzsauh_NpcMonitorEffect Extends ActiveMagicEffect

zzzsauh_PlayerScript Property PlayerScript Auto
Keyword Property ArmorHelmet Auto
Keyword Property ClothingHead Auto
FormList Property HeadgearIgnoreList Auto
GlobalVariable Property sauhNPCEffectState Auto
GlobalVariable Property sauhUnusualsExclusion Auto
GlobalVariable Property sauhClothingExclusion Auto
Spell Property NPCMonitorAbility Auto
Form[] ItemList
Actor MySelf

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;Debug.Trace(Self + " started")
	If akTarget As Actor
		MySelf = akTarget
		ItemList = New Form[5]
		RegisterHeadgears(MySelf)
		If !MySelf.IsWeaponDrawn()
			GoToState("Unequipping")
			;Debug.Trace(Self + " unequipping")
		Else
			GoToState("")
		EndIf
		RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
		RegisterForAnimationEvent(MySelf,"WeaponDraw")
		RegisterForAnimationEvent(MySelf,"WeaponSheathe")
	Else
		Dispel()
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;PlayerScript.ArrayClear(ItemList)
	GoToState("Stopped")
	;Debug.Trace(Self + " finished")
EndEvent

Event OnPlayerLoadGame()
	RegisterForModEvent("AuhNpcEffectStop","OnAuhNpcEffectStop")
EndEvent

Event OnAuhNpcEffectStop(String eventName, String strArg, Float numArg, Form sender)
	;Debug.Trace(Self + " dispelling")
	GoToState("Dispelling")
EndEvent

Event OnDying(Actor akKiller)
	;PlayerScript.ArrayClear(ItemList)
	;Debug.Trace(Self + " died")
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
			;Debug.Trace(Self + " equipping")
			GoToState("Equipping")
		ElseIf asEventName == "WeaponSheathe"
			;Debug.Trace(Self + " unequipping")
			GoToState("Unequipping")
		EndIf
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If bIsArmor(akBaseObject)
		If MySelf.IsWeaponDrawn()
			If bIsHeadgear(akBaseObject) && ( sauhNPCEffectState.GetValue() != 2 || bIsHeadgearValid(akBaseObject) )
				If ItemList.Find(akBaseObject) < 0
					Int i = ItemList.Find(None)
					If i > -1
						ItemList[i] = akBaseObject
					Else
						Int SlotMask = (akBaseObject As Armor).GetSlotMask()
						i = ItemList.Length
						Bool bBreak = False
						While i > 0 && !bBreak
							i-= 1
							If ItemList[i]
								Int ItemSlotMask = (ItemList[i] As Armor).GetSlotMask()
								Int j = PlayerScript.WhiteList.Length
								While j > 0 && !bBreak
									j -= 1
									If ( Math.LogicalAnd(SlotMask, PlayerScript.WhiteList[j]) == PlayerScript.WhiteList[j] ) &&\ 
									( Math.LogicalAnd(ItemSlotMask, PlayerScript.WhiteList[j]) == PlayerScript.WhiteList[j] )
										ItemList[i] = akBaseObject
										bBreak = True
									EndIf
								EndWhile
							EndIf
						EndWhile
					EndIf
				EndIf
			EndIf
		Else
			Int SlotMask = (akBaseObject As Armor).GetSlotMask()
			Int i = ItemList.Length
			Bool bBreak = False
			While i > 0 && !bBreak
				i-= 1
				If ItemList[i]
					Int ItemSlotMask = (ItemList[i] As Armor).GetSlotMask()
					Int j = PlayerScript.WhiteList.Length
					While j > 0 && !bBreak
						j -= 1
						If ( Math.LogicalAnd(SlotMask, PlayerScript.WhiteList[j]) == PlayerScript.WhiteList[j] ) &&\ 
						( Math.LogicalAnd(ItemSlotMask, PlayerScript.WhiteList[j]) == PlayerScript.WhiteList[j] )
							ItemList[i] = None
							bBreak = True
						EndIf
					EndWhile
				EndIf
			EndWhile
		EndIf
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	If MySelf.IsWeaponDrawn()
		Bool bBreak = False
		While !bBreak
			Int i = ItemList.Find(akBaseObject)
			If i > -1
				ItemList[i] = None
			Else
				bBreak = True
			EndIf
		EndWhile
	EndIf
EndEvent

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
			;Debug.Trace(Self + " dispelling spell")
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
				Else
					ItemList[i] = None
				EndIf
			EndIf
		EndWhile
		GoToState("")
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
	Event OnObjectUnEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState

State Unequipping
	Event OnBeginState()
		Int i = ItemList.Length
		While i > 0
			i -= 1
			If ItemList[i]
				MySelf.UnequipItem(ItemList[i], abSilent = True)
			EndIf
		EndWhile
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
	If akBaseObject.HasKeyWord(ArmorHelmet) || (!sauhClothingExclusion.GetValue() && akBaseObject.HasKeyWord(ClothingHead))
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