extends Control


onready var text = get_parent().get_node("Dialog").dialog_script

var millie = preload("res://assets/art/ui/CharacterPortrait.png")
var bot = preload("res://assets/art/ui/CharacterPortrait2.png")
var pic_default = preload("res://assets/art/ui/char_expression/Default.png")

var pic_base_path = "res://assets/art/ui/char_expression/"

onready var dialog_container = $DialogContainer
onready var dialog_speakername = $SpeakerName
onready var dialog_text = $DialogContainer/DialogBox/Dialog
onready var dialog_portrait = $Portrait
onready var portrait_left = $DialogContainer/PortraitBoxLeft
onready var portrait_right = $DialogContainer/PortraitBoxRight
onready var text_timer = $DialogTextTimer
onready var button_choice = $Choices/Choice1
onready var button_choice2 = $Choices/Choice2
onready var talking_sound = $Talking
onready var dialog_arrow = $DialogArrow
onready var dialog_anim = $DialogAnim

var talking_sound_delay = 2
var talking_sound_count = talking_sound_delay

export(float) var text_speed = 0.02

var dialog_index = 0
var is_finished
var is_active

var position
var expression
var sfx = ""

var bAlreadyPlaySfx = false

func _ready():
	text_timer.wait_time = text_speed
#	show_dialog()

func init():
	text = get_parent().get_node("Dialog").dialog_script
	dialog_index = 0

		
func _process(_delta):
	if is_active:
		
		if sfx != "" and !bAlreadyPlaySfx : 
			dialog_text.visible_characters = len(dialog_text.text)
			is_finished = true
			AutoLoadMapData.PlaySfxProcessPause(sfx)
			bAlreadyPlaySfx = true
		
		if (Input.is_action_just_pressed("ui_accept") and GlobalSettings.settings_menu_up == false) and (
		GlobalSettings.character_menu_up == false and GlobalSettings.ability_menu_up == false):
			
			if is_finished == true:
				show_dialog()
				
			else:
				dialog_text.visible_characters = len(dialog_text.text)
				is_finished = true

		var str_path = pic_base_path + str(dialog_speakername.text) + "_" + expression + ".png"
		var pic = load(str_path)
		if pic : 
			dialog_portrait.texture = pic
		else : 
			dialog_portrait.texture = pic_default
			
				
		talking_sound.pitch_scale = 2
		
		if position == "1":
			dialog_portrait.show()
			dialog_portrait.global_position = get_parent().get_node("LeftPortraitPosition").position
			dialog_speakername.rect_global_position = get_parent().get_node("LeftNamePosition").rect_position
#			portrait_left.show()
#			portrait_right.hide()
			
		elif position == "2":
			dialog_portrait.show()
			dialog_portrait.global_position = get_parent().get_node("RightPortraitPosition").position
			dialog_speakername.rect_global_position = get_parent().get_node("RightNamePosition").rect_position
#			portrait_left.hide()
#			portrait_right.show()
		else : 
			dialog_portrait.hide()
#			portrait_left.hide()
#			portrait_right.hide()
			
	else :
		dialog_portrait.hide()

func show_dialog():
	if dialog_index < text.size() and get_node("Choices").choice_dialog_is_up == false:
		dialog_arrow.hide()
		is_active = true
		is_finished = false
		
		dialog_container.show()
		dialog_portrait.show()
		dialog_speakername.hide()
		dialog_speakername.text = text[dialog_index]["Name"]
		dialog_text.bbcode_text = text[dialog_index]["Text"]
		button_choice.text = text[dialog_index]["Choices"][0]
		button_choice2.text = text[dialog_index]["Choices"][1]
		
		position = text[dialog_index]["Position"]
		expression = text[dialog_index]["Expression"]
		
		bAlreadyPlaySfx = false
		if text[dialog_index].has("Sfx") : 
			sfx = text[dialog_index]["Sfx"]
		else : 
			sfx = ""
		
		dialog_text.visible_characters = 0
		
		while dialog_text.visible_characters < len(dialog_text.text):
			dialog_text.visible_characters += 1
			
			text_timer.start()
			yield(text_timer, "timeout")
			
			if talking_sound_count < talking_sound_delay:
				talking_sound_count += 1
			else:
				talking_sound_count = 0
				talking_sound.play()
		
		if button_choice.text == "":
			dialog_arrow.show()
			if position == "1":
				dialog_anim.play("DialogNextArrow")
				
			else:
				dialog_anim.play("DialogNextArrow2")
			
		Choices()
		
		is_finished = true
	
	elif dialog_index < text.size() and get_node("Choices").choice_dialog_is_up == true:
		dialog_index -= 1
	
	else:
		GlobalSettings.dialog_test_up = false
		GlobalSettings.dialog_reset = true
		dialog_arrow.hide()
		dialog_container.hide()
		dialog_portrait.hide()
		dialog_speakername.hide()
		is_finished = true
		is_active = false
		get_tree().paused = false
	
	dialog_index += 1
	
func Choices():
		
	if button_choice.text == "":
		button_choice.hide()
	else:
		button_choice.show()
		get_node("Choices").choice_dialog_is_up = true
		
		if position == "2":
			dialog_anim.play("ChoiceButtonPos2")
			print("works?")
		else:
			dialog_anim.play("ChoiceButtonPos")
			print("here")
			
	if button_choice2.text == "":
		button_choice2.hide()
	else:
		button_choice2.show()
		get_node("Choices").choice_dialog_is_up = true
		
		if position == "2":	
			dialog_anim.play("ChoiceButtonPos2")
		else:
			dialog_anim.play("ChoiceButtonPos")

