extends InteractableObject

onready var autoload_globalresource = $"/root/AutoloadGlobalResource"

export var ResourceTemplateKey = ""
enum ItemType {Random, Weapon, SpecialAbility}
export(ItemType) var InteractableType = ItemType.Random
export var bRandomizeDrop = true
export var RandomizeWeaponChance = 30

func Init():
	if !autoload_globalresource : 
		autoload_globalresource = $"/root/AutoloadGlobalResource"
		
	if !autoload_mapdata : 
		autoload_mapdata = $"/root/AutoLoadMapData"
		
	var room = get_parent()
	var room_data = autoload_mapdata.LevelRoomMap[room.Room_Position.x][room.Room_Position.y]
	if room_data.bIsAlreadyCleared : 
		queue_free()
		return
		
	RandomizeDrop()
	if item_name_label : 
		item_name_label = find_node("ItemName")
		
	item_name_label.set_text(ResourceTemplateKey)
	pass

func RandomizeDrop(): 
	var keys
	
	if InteractableType == ItemType.Weapon : 
		keys = autoload_globalresource.PlayerWeaponAbilityTemplates.keys()
		
	if InteractableType == ItemType.SpecialAbility : 
		keys = autoload_globalresource.PlayerSpecialAbilityTemplates.keys()
		
	if InteractableType == ItemType.Random : 
		if randi() % 100 < RandomizeWeaponChance : 
			InteractableType = ItemType.Weapon
			keys = autoload_globalresource.PlayerWeaponAbilityTemplates.keys()
		else : 
			InteractableType = ItemType.SpecialAbility
			keys = autoload_globalresource.PlayerSpecialAbilityTemplates.keys()
	
	ResourceTemplateKey = keys[randi() % keys.size()]

func TapAction():
	#print("Tap")
	if ResourceTemplateKey : 
		if InteractedPlayer : 
			if InteractableType == ItemType.Weapon : 
				InteractedPlayer.AddWeaponAbility(ResourceTemplateKey)
				
			if InteractableType == ItemType.SpecialAbility : 
				InteractedPlayer.AddSpecialAbility(ResourceTemplateKey)
		
	queue_free()
	pass
