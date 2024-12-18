class_name SurvivalGameMode
extends GameMode

var music: SurvivalModeMusic
var enemies: SurvivalModeEnemies
var spawn_points: ArrayCollection
var spawn_time = NumericAttribute.new(3, 3)
var is_resting_period = false
var wave_cooldown = NumericAttribute.new(5,5)
var wave_index = 0
var enemies_to_kill = 0
var enemies_to_spawn = 0
var spawn_enemies_nr = NumericAttribute.new(1, 3)
var pause = false

func _init(_spawn_points: ArrayCollection, _music: SurvivalModeMusic, _enemies: SurvivalModeEnemies):
	self.spawn_points = _spawn_points
	self.music = _music
	self.enemies = _enemies
	self.enemies_to_kill = _enemies.nr_enemies_per_wave[wave_index]
	self.enemies_to_spawn = _enemies.nr_enemies_per_wave[wave_index]
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	GlobalEventBus.wave_started.emit(wave_index+1, enemies_to_kill)	
	GlobalEventBus.connect(GlobalEventBus.START_INTERACTION_WITH, on_start_interaction_with)
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, on_finish_interaction)
	

func clear_event_subscriptions():
	GlobalEventBus.disconnect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	GlobalEventBus.disconnect(GlobalEventBus.START_INTERACTION_WITH, on_start_interaction_with)
	GlobalEventBus.disconnect(GlobalEventBus.FINISH_INTERACTION, on_finish_interaction)
	
func _process(delta):
	if(!pause):
		music_processing()
		on_keyboard_pressed()	
		wave_processing(delta)	

func music_processing():
	if(!is_resting_period):
		music.play_on_wave(wave_index)

func on_keyboard_pressed():
	if(is_resting_period && Input.is_action_just_pressed("start_wave")):
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
			var enemy = enemies.get_enemy_for_wave(wave_index)
			spawner.add_child(enemy.instantiate())
			enemies_to_spawn -= 1		

func on_enemy_death(_death_details: EnemyDeathDetails):
	enemies_to_kill -= 1

	if (enemies_to_kill <= 0):
		on_wave_complete()
		
func on_wave_complete():
	wave_index += 1
	if (wave_index < enemies.nr_enemies_per_wave.size()):
		enemies_to_kill = enemies.nr_enemies_per_wave[wave_index]
		increase_difficulty()
	else:
		enemies_to_kill = enemies.nr_enemies_per_wave[enemies.nr_enemies_per_wave.size()-1]	
	is_resting_period = true
	wave_cooldown.assign_max_value()
	enemies_to_spawn = enemies_to_kill
	GlobalEventBus.wave_completed.emit(wave_index)
	on_wave_complete_music()	

func on_wave_complete_music():
	self.music.play_on_wave_complete()	
	
# TODO more difficulty settings
func increase_difficulty():
	if(spawn_enemies_nr.value < spawn_enemies_nr.max_value):
		spawn_enemies_nr.value += 1
		spawn_time.increment_max_value()
		return
	if(spawn_time.max_value > 4):
		spawn_time.decrement_max_value()
		return
	
func on_start_interaction_with(_npc_name: String):
	pause = true
	
func on_finish_interaction():
	pause = false	
