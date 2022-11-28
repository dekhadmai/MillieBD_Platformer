extends InteractableObject

onready var gameplay_effect_template = $PickupEffect

func _ready(): 
	var Room_Position = get_parent().Room_Position
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if !room_data.bStartRoom : 
		queue_free()

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
	if !GlobalSettings.tutorial_up :
		var ui = load("res://src/UserInterface/TutorialUI.tscn")
		add_child(ui.instance())
		GlobalSettings.tutorial_up = true
	
