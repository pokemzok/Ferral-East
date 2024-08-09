extends HBoxContainer

var health_point_res = preload("res://player/Health.png")

func _ready():
	handle_events()
	
func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_HP_CHANGED, on_hp_changed)

func on_hp_changed(hp):
	clear_hearts()
	for i in range(hp):
		add_hp()
	
func clear_hearts():
	while get_child_count() > 0:
		var heart = get_child(0)
		remove_child(heart)

func add_hp():
	var health_point_icon = TextureRect.new()
	health_point_icon.texture = health_point_res
	add_child(health_point_icon)
