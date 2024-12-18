class_name MonologBubble
extends Node2D

@onready var label = $Polygon2D/Label
@onready var polygon = $Polygon2D
@onready var print_timer = $PrintTimer
@onready var close_timer = $CloseTimer

var bubble_tween: Tween
var polygon_color_transparent: Color
var polygon_color: Color
var printing_index = 0
var max_label_height: int
var longer_pause_characters = [".", "!", "?"]
var pause_characters = [","]
 	
func _ready():
	polygon_color_transparent = Color(polygon.modulate, 0)
	polygon_color = Color(polygon.modulate, 1)
	polygon.modulate = polygon_color_transparent
	max_label_height = label.size.y

@warning_ignore("unused_parameter")
func _process(delta):
	if self.get_parent():
		self.rotation_degrees = -self.get_parent().rotation_degrees

func show_bubble(text: String):
	clear()
	bubble_tween = create_tween()	
	bubble_tween.tween_property(polygon, "modulate", polygon_color, 0.2)
	bubble_tween.tween_callback(start_print_timer.bind(text))

func clear():
	label.text = ""		
	if (bubble_tween != null):
		bubble_tween.kill()
	if(!print_timer.is_stopped()):
		print_timer.stop()
	if(!close_timer.is_stopped()):
		close_timer.stop()		
	
	if(print_timer.is_connected("timeout", print_text_into_bubble)):	
		print_timer.disconnect("timeout", print_text_into_bubble)
	
	if(close_timer.is_connected("timeout", hide_bubble)):
		close_timer.disconnect("timeout", hide_bubble)		
	print_timer.wait_time = 0.05
	
func start_print_timer(text: String):
	printing_index = 0		
	print_timer.start()
	print_timer.connect("timeout", print_text_into_bubble.bind(text))

func print_text_into_bubble(full_text: String):
	if printing_index < full_text.length():
		var character = full_text[printing_index]
		if(label.get_visible_line_count() != label.get_line_count()):
			var last_white_space_index = get_last_white_space_index(full_text)
			var last_word = full_text.substr(last_white_space_index, printing_index-last_white_space_index)+character
			label.text = last_word
		else:
			label.text	+= character
		printing_index += 1
		update_print_text_config(character)
	else:
		on_complete()

func get_last_white_space_index(full_text: String,) -> int:
	var search_text = full_text.substr(0, printing_index)
	var last_space_index = search_text.rfind(" ")
	if last_space_index == -1:
		last_space_index = 0
	return last_space_index
	
func update_print_text_config(current_character):
	if current_character in longer_pause_characters:
		print_timer.wait_time = 1
	elif current_character in pause_characters:	
		print_timer.wait_time = 0.5
	else:
		print_timer.wait_time = 0.09

func on_complete():
	print_timer.stop()
	close_timer.start()
	close_timer.connect("timeout", hide_bubble)		

func hide_bubble():
	if (bubble_tween != null):
		bubble_tween.kill()	
	bubble_tween = create_tween()	
	bubble_tween.tween_property(polygon, "modulate", polygon_color_transparent, 0.4)
