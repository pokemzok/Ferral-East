extends CanvasModulate

@export var day_duration: float = 480.0

var current_color_index = 0
var current_color_duration = 0

var colors = [
	Color("FFD580"),  # Morning
	Color("FFFFFF"),  # Noon
	Color("FF46E0"),  # Evening
	Color("001A57")   # Night
]
var color_durations = [0.25, 0.5, 0.25, 0.5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color = get_current_color(delta)

func get_current_color(delta) -> Color:
	# Find which segment of the day we're in
	current_color_duration += delta / day_duration
	var segment_duration = color_durations[current_color_index]
	var local_time = (current_color_duration) / segment_duration
	var next_color_index = (current_color_index + 1) % colors.size()
	if (current_color_duration < segment_duration):
		var current_color = colors[current_color_index].lerp(colors[next_color_index], local_time)
		return current_color
	else:
		current_color_index = next_color_index
		current_color_duration = 0
		return get_current_color(delta)	
