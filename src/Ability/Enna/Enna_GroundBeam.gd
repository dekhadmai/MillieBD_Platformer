extends "res://src/Ability/Base/GameplayAbility_AreaDetection.gd"


func Init():
	if SocketNode == null:
		SocketNode = AbilityOwner.get_parent().find_node(SpawnSocketName)
		
	if hurt_detection == null:
		hurt_detection = get_node(Area2D_Damage_NodeName)
		var _error = hurt_detection.connect("OnHurtDetection", self, "OnHurtDetectionHit")
		_error = hurt_detection.connect("OnEndAreaLinger", self, "_on_Area2D_Damage_OnEndAreaLinger")
	
	hurt_detection.set_as_toplevel(true)
	hurt_detection.set_global_position(SocketNode.get_global_position())
	
	
func update_physics(delta):
	pass
