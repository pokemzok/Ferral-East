class_name SurvivalGameMode
extends GameMode

var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var spawn_points: ArrayCollection
var spawn_time = NumericAttribute.new(3, 4)
var rest_time = NumericAttribute.new(5,5)
var wave_enemies  = [10, 15, 20, 25, 30, 40, 50, 60, 80, 100]
var wave_index = 0
var current_wave = wave_enemies[wave_index]

func _init(spawn_points: ArrayCollection):
	self.spawn_points = spawn_points
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	GlobalEventBus.wave_started.emit(wave_index+1)

func _process(delta):
	if(rest_time.value > 0):
		rest_time.decrement_by(delta)
	else: 
		spawn_enemies(delta)	
	
func spawn_enemies(delta):
	spawn_time.decrement_by(delta)
	if  (spawn_time.value <= 0):
		spawn_time.assign_max_value()
		var spawner = spawn_points.random_element()
		spawner.add_child(zombie.instantiate())

func on_enemy_death(type, score):
	current_wave -= 1
	if (current_wave <= 0):
		wave_index += 1
		if (wave_index < wave_enemies.size()):
			current_wave = wave_enemies[wave_index]
		else:
			current_wave = wave_enemies[wave_enemies.size()-1]	
		GlobalEventBus.wave_ended.emit(wave_index)
		rest_time.assign_max_value()
