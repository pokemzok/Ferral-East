class_name DayNightCycle
extends CanvasModulate

enum DayTime  {
	MORNING,
	NOON,
	AFTERNOON,
	EVENING,
	NIGHT,
	MIDNIGHT,
	DAWN
}

@export var day_duration: float = 240.0
var current_color_index = 0
var current_color_duration = 0

var colors = [
	Color("ffe9a6"),  # Morning
	Color("FFFFFF"),  # Noon
	Color("ffc36c"),  # Afternoon
	Color("FF46E0"),  # Evening
	Color("001A57"),  # Night
	Color("09071a"),  # Midnight
	Color("47354b")	  # Dawn
]
var color_durations = [0.3, 0.4, 0.3, 0.3, 0.2, 0.3, 0.2]

func _process(delta):
	color = process_current_color(delta)

func process_current_color(delta) -> Color:
	# Find which segment of the day we're in
	emit_day_time_event()
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
		return process_current_color(delta)	

func emit_day_time_event():
	if  (current_color_duration == 0):
		GlobalEventBus.day_time.emit(current_color_index)
