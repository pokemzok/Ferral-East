class_name SurvivalGameMode
extends GameMode

var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var spawn_points: ArrayCollection
var spawn_time = NumericAttribute.new(3, 4)

func _init(spawn_points: ArrayCollection):
	self.spawn_points = spawn_points
	
func spawn_enemies(delta):
	spawn_time.decrement_by(delta)
	if  (spawn_time.value <= 0):
		spawn_time.assign_max_value()
		var spawner = spawn_points.random_element()
		spawner.add_child(zombie.instantiate())
