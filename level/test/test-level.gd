extends Node

var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var spawn_time = NumericAttribute.new(3, 3)
var spawn_points 

func _ready():
	spawn_points = ArrayCollection.new(
		[$EnemiesSpawn, $EnemiesSpawn2, $EnemiesSpawn3, $EnemiesSpawn4, $EnemiesSpawn5]
	)
		
func _process(delta):
	spawn_enemies(delta)

func spawn_enemies(delta):
	spawn_time.decrement_by(delta)
	if  (spawn_time.value <= 0):
		spawn_time.assign_max_value()
		var spawner = spawn_points.random_element()
		spawner.add_child(zombie.instantiate())
