extends InteractableObject

onready var gameplay_effect_template = $PickupEffect

func Init():
	if !autoload_globalresource : 
		autoload_globalresource = $"/root/AutoloadGlobalResource"
		
	if !autoload_mapdata : 
		autoload_mapdata = $"/root/AutoLoadMapData"
		
	if item_name_label : 
		item_name_label = find_node("ItemName")
		
	item_name_label.set_text(Name)
	
	.Init()

func TapAction():
	#print("Tap")
	if InteractedPlayer : 
		var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
		var body_asc: BaseAbilitySystemComponent = InteractedPlayer.GetAbilitySystemComponent()
		body_asc.ApplyGameplayEffectToSelf(effect)
		
		queue_free()
	pass
