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
 	
func _ready():
	polygon_color_transparent = Color(polygon.modulate, 0)
	polygon_color = Color(polygon.modulate, 1)
	polygon.modulate = polygon_color_transparent
	max_label_height = label.size.y

func _process(delta):
	if self.get_parent():
		self.rotation_degrees = -self.get_parent().rotation_degrees

# FIXME should be printed and not just shown
# FIXME should disappear after some time.	
func show_bubble(text: String):
	clear()
	bubble_tween = create_tween()	
	bubble_tween.tween_property(polygon, "modulate", polygon_color, 0.2)
	bubble_tween.tween_callback(start_print_timer.bind(text))

func clear():
	if (bubble_tween != null):
		bubble_tween.kill()
	if(!print_timer.is_stopped()):
		print_timer.stop()
	if(!close_timer.is_stopped()):
		close_timer.stop()		
	print_timer.disconnect("timeout", print_text_into_bubble)
	close_timer.disconnect("timeout", hide_bubble)		
	print_timer.wait_time = 0.05
	label.text = ""	
	
func start_print_timer(text: String):
	printing_index = 0		
	print_timer.start()
	print_timer.connect("timeout", print_text_into_bubble.bind(text))

# FIXME continue overflow strategy, this does not looks good yet
func print_text_into_bubble(full_text: String):
	if printing_index < full_text.length():
		var character = full_text[printing_index]
		if(label.size.y > max_label_height):
			label.text = character
		else:
			label.text	+= character
		printing_index += 1
		update_print_text_config(character)
	else:
		on_complete()

func update_print_text_config(current_character):
	if current_character ==  ".":
		print_timer.wait_time = 1
	else:
		print_timer.wait_time = 0.05

func on_complete():
	print_timer.stop()
	close_timer.start()
	close_timer.connect("timeout", hide_bubble)		

func hide_bubble():
	if (bubble_tween != null):
		bubble_tween.kill()	
	bubble_tween = create_tween()	
	bubble_tween.tween_property(polygon, "modulate", polygon_color_transparent, 0.4)
