extends Control

const XBOX_BUTTON_TO_INDEX_MAPPING = {
	JOY_XBOX_A: 0,
	JOY_XBOX_B: 2,
	JOY_XBOX_X: 1,
	JOY_XBOX_Y: 3,
	JOY_START: 14,
	JOY_SELECT: 15,
	JOY_L: 4,
	JOY_L2: 6,
	JOY_L3: 17,
	JOY_R: 5,
	JOY_R2: 7,
	JOY_R3: 16,
	JOY_DPAD_UP: 8,
	JOY_DPAD_DOWN: 9,
	JOY_DPAD_LEFT: 10,
	JOY_DPAD_RIGHT: 11
}

const KEYBOARD_BUTTON_TO_INDEX_MAPPING = {	
	KEY_ESCAPE:52, 
	KEY_TAB:59, 
	KEY_BACKSPACE:60, 
	KEY_ENTER:53, 
	KEY_LEFT:55, 
	KEY_UP:57, 
	KEY_RIGHT:56, 
	KEY_DOWN:58, 
	KEY_SHIFT:46, 
	KEY_CONTROL:48, 
	KEY_ALT:47, 
	KEY_F1:61, 
	KEY_F2:62, 
	KEY_F3:63, 
	KEY_F4:64, 
	KEY_F5:65, 
	KEY_F6:66, 
	KEY_F7:67, 
	KEY_F8:68, 
	KEY_F9:69, 
	KEY_F10:70, 
	KEY_F11:71, 
	KEY_F12:72,  
	KEY_KP_0:26, 
	KEY_KP_1:27, 
	KEY_KP_2:28, 
	KEY_KP_3:29, 
	KEY_KP_4:30, 
	KEY_KP_5:31, 
	KEY_KP_6:32, 
	KEY_KP_7:33, 
	KEY_KP_8:34, 
	KEY_KP_9:35, 
	KEY_SPACE:54, 
	KEY_A:10, 
	KEY_B:23, 
	KEY_C:21, 
	KEY_D:12, 
	KEY_E:2, 
	KEY_F:13, 
	KEY_G:14, 
	KEY_H:15, 
	KEY_I:7, 
	KEY_J:16, 
	KEY_K:17, 
	KEY_L:18, 
	KEY_M:25, 
	KEY_N:24, 
	KEY_O:8, 
	KEY_P:9, 
	KEY_Q:0, 
	KEY_R:3, 
	KEY_S:11, 
	KEY_T:4, 
	KEY_U:6, 
	KEY_V:22, 
	KEY_W:1, 
	KEY_X:20, 
	KEY_Y:5, 
	KEY_Z:19, 
}

export(String) var action_name
export(String) var label_text
export(Texture) var icon
export var bShowInputIcon = true
onready var keyboard_icon : Sprite = $KeyboardSprite
onready var controller_icon : Sprite = $ControllerSprite
onready var sprite_icon : Sprite = $IconSprite
onready var mask_progress = $IconSprite/MaskProgress
onready var name_label : Label = $ActionName

var device_id = -1

func _ready() -> void:
	sprite_icon.set_texture(icon)
	var _error = Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	if Input.get_connected_joypads().size() > 0 : 
		self.device_id = Input.get_connected_joypads()[0]
	self._set_current_icon_index(self.device_id, self.action_name)
	self.name_label.text = self.label_text

func _joy_connection_changed(device_id : int, connected: bool) -> void : 
	if connected : 
		self.device_id = device_id
	else : 
		self.device_id = -1
	self._set_current_icon_index(self.device_id, action_name)

func _set_current_icon_index(device_id : int, action_name: String) : 
	for action in InputMap.get_action_list(action_name) : 
		if action is InputEventKey and device_id == -1 : 
			if KEYBOARD_BUTTON_TO_INDEX_MAPPING.has(action.scancode) : 
				if bShowInputIcon : 
					keyboard_icon.set_visible(true)
					controller_icon.set_visible(false)
					keyboard_icon.set_frame(KEYBOARD_BUTTON_TO_INDEX_MAPPING[action.scancode])
				else : 
					keyboard_icon.set_visible(false)
					controller_icon.set_visible(false)
				return
		if action is InputEventJoypadButton and device_id != -1: 
			#if "XInput" in Input.get_joy_name(device_id):
			if XBOX_BUTTON_TO_INDEX_MAPPING.has(action.button_index) : 
				if bShowInputIcon : 
					keyboard_icon.set_visible(false)
					controller_icon.set_visible(true)
					
					var joy_offset = 0
					var joy_name = Input.get_joy_name(device_id)
					#print(joy_name)
					if "XInput" in joy_name:
						joy_offset = 0
					if "PS" in joy_name:
						joy_offset = 24
					if "Nintendo" in joy_name or "Switch" in joy_name:
						joy_offset = 48
					
					controller_icon.set_frame(XBOX_BUTTON_TO_INDEX_MAPPING[action.button_index]+joy_offset)
				else : 
					keyboard_icon.set_visible(false)
					controller_icon.set_visible(false)
				return
					
	if bShowInputIcon : 
#		keyboard_icon.set_visible(true)
#		controller_icon.set_visible(false)
#		keyboard_icon.set_frame(73)
		
		keyboard_icon.set_visible(false)
		controller_icon.set_visible(false)
	else :
		keyboard_icon.set_visible(false)
		controller_icon.set_visible(false)
