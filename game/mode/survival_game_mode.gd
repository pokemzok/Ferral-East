class_name SurvivalGameMode
extends GameMode

var music_player: AudioStreamPlayer
var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var spawn_points: ArrayCollection
var spawn_time = NumericAttribute.new(3, 3)
var rest_time = NumericAttribute.new(5,5)
var wave_enemies  = [5, 10, 15, 25, 30, 40, 50, 60, 80, 100]
var wave_index = 0
var enemies_to_kill = wave_enemies[wave_index]
var enemies_to_spawn = wave_enemies[wave_index]
var spawn_enemies_nr = NumericAttribute.new(1, 3)

func _init(spawn_points: ArrayCollection, music_player: AudioStreamPlayer):
	self.spawn_points = spawn_points
	self.music_player = music_player
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)

func _process(delta):
	if(rest_time.value > 0):
		if(rest_time.is_max_value()):
			GlobalEventBus.wave_started.emit(wave_index+1, enemies_to_kill)
		rest_time.decrement_by(delta)
	else: 
		spawn_enemies(delta)	
	
func spawn_enemies(delta):
	spawn_time.decrement_by(delta)
	if  (spawn_time.value <= 0 && enemies_to_spawn > 0):
		spawn_time.assign_max_value()
		var spawners = spawn_points.random_elements(spawn_enemies_nr.value)
		for i in range(spawners.size()):
			if(enemies_to_spawn <= 0):
				break
			var spawner = spawners[i]	
			spawner.add_child(zombie.instantiate())
			enemies_to_spawn -= 1		

func on_enemy_death(type, score):
	enemies_to_kill -= 1
	if (enemies_to_kill <= 0):
		wave_index += 1
		if (wave_index < wave_enemies.size()):
			enemies_to_kill = wave_enemies[wave_index]
			increase_difficulty()
		else:
			enemies_to_kill = wave_enemies[wave_enemies.size()-1]	
		enemies_to_spawn = enemies_to_kill
		rest_time.assign_max_value()

# TODO more difficulty settings
# TODO rethink difficulty improvement. Currently it is too hard
# TODO alternatively I can introduce some powers to improve player experience (like increase mag capacity)
func increase_difficulty():
	if(spawn_enemies_nr.value < spawn_enemies_nr.max_value):
		spawn_enemies_nr.value += 1
		spawn_time.increment_max_value()
		return
	if(spawn_time.max_value > 4):
		spawn_time.decrement_max_value()
		return
	