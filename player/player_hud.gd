extends CanvasLayer

var health_point_res = preload("res://player/Health.png")

func on_hp_changed(hp):
	clear_hearts()
	for i in range(hp):
		add_hp()

func clear_hearts():
	var health_container = $HealthContainer
	while health_container.get_child_count() > 0:
		var heart = health_container.get_child(0)
		health_container.remove_child(heart)

func add_hp():
	var health_point_icon = TextureRect.new()
	health_point_icon.texture = health_point_res
	$HealthContainer.add_child(health_point_icon)
