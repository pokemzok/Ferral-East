class_name SurvivalGameMode
extends GameMode

var music_player: AudioStreamPlayer
var music: SurvivalModeMusic
var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var spawn_points: ArrayCollection
var spawn_time = NumericAttribute.new(3, 3)
var is_resting_period = false
var wave_cooldown = NumericAttribute.new(5,5)
var wave_enemies  = [5, 10, 15, 25, 30, 40, 50, 60, 80, 100]
var wave_index = 0
var enemies_to_kill = wave_enemies[wave_index]
var enemies_to_spawn = wave_enemies[wave_index]
var spawn_enemies_nr = NumericAttribute.new(1, 3)

func _init(spawn_points: ArrayCollection, music_player: AudioStreamPlayer, music: SurvivalModeMusic):
	self.spawn_points = spawn_points
	self.music_player = music_player
	self.music = music
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	GlobalEventBus.wave_started.emit(wave_index+1, enemies_to_kill)	

func _process(delta):
	music_processing()
	on_keyboard_pressed()	
	wave_processing(delta)	

func music_processing():
	if (!self.music_player.is_playing()):
		if(!is_resting_period):
			self.music_player.stream = music.get_music_for_wave(wave_index)	
			self.music_player.play()

func on_keyboard_pressed():
	if(is_resting_period && Input.is_action_just_pressed("action")):
		GlobalEventBus.wave_started.emit(wave_index+1, enemies_to_kill)
		is_resting_period = false
		
func wave_processing(delta):
	if(!is_resting_period):
		if(wave_cooldown.value <= 0):
			spawn_enemies(delta)
		else:
			wave_cooldown.decrement_by(delta)		
	
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
		on_wave_complete()
		
func on_wave_complete():
	wave_index += 1
	if (wave_index < wave_enemies.size()):
		enemies_to_kill = wave_enemies[wave_index]
		increase_difficulty()
	else:
		enemies_to_kill = wave_enemies[wave_enemies.size()-1]	
	is_resting_period = true
	wave_cooldown.assign_max_value()
	enemies_to_spawn = enemies_to_kill
	GlobalEventBus.wave_completed.emit(wave_index)
	on_wave_complete_music()	

func on_wave_complete_music():
	self.music_player.stop()
	self.music_player.stream = music.get_victory_music()
	self.music_player.play()
	
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
	
