extends InteractableObject

export var ResourceTemplateKey = ""
enum ItemType {Random, Weapon, SpecialAbility}
export(ItemType) var InteractableType = ItemType.Random
export var bRandomizeDrop = true
export var RandomizeWeaponChance = 30
export var bRandomFromPool = true

func Init():
	if !autoload_globalresource : 
		autoload_globalresource = $"/root/AutoloadGlobalResource"
		
	if !autoload_mapdata : 
		autoload_mapdata = $"/root/AutoLoadMapData"
		
	RandomizeDrop()
	if item_name_label : 
		item_name_label = find_node("ItemName")
		
	item_name_label.set_text(ResourceTemplateKey)
	var icon = AutoloadGlobalResource.IconResource[ResourceTemplateKey]
	if icon : 
		item_sprite.set_texture(load(icon))
	
	.Init()

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
	
	if ResourceTemplateKey == "" : 
		if bRandomFromPool : 
			if InteractableType == ItemType.SpecialAbility : 
				ResourceTemplateKey = AutoLoadTransientData.GetRandomAbilityDropFromPool()
			else : 
				ResourceTemplateKey = keys[randi() % keys.size()]
		else : 
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
