extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 50
const speed_up_multiplier := 10.0
const title_color := Color.brown

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var bbtext:String = ""
var current_scroll = 0


func _process(delta):
		
	var scroll_speed = base_speed * delta
	if speed_up:
		scroll_speed *= speed_up_multiplier
		
	var v:VScrollBar = $CreditsContainer/RichLine.get_v_scroll()
	v.set_value(current_scroll)
	v.hide()
	
	if current_scroll > v.max_value :
		finish()
		
	current_scroll += scroll_speed

func finish():
	if not finished:
		finished = true
		Transition.change_scene("res://src/UserInterface/MainMenu/startmenu.tscn")
		


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_accept") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_accept") and !event.is_echo():
		speed_up = false

