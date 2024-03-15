extends Node

var zombie = preload("res://characters/enemies/default_zombie/default_zombie.tscn")
var spawn_time = 5
		
func _process(delta):
	spawn_enemies(delta)

func spawn_enemies(delta):
	spawn_time -= delta
	if  (spawn_time <= 0):
		spawn_time = 5
		$EnemiesSpawn.add_child(zombie.instantiate())
