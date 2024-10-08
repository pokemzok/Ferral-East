extends Node

var spawn_points: ArrayCollection
var game_mode: GameMode 
var level_music: SurvivalModeMusic
var victory_music_resources_group: ResourcesGroup
var survival_music_resources_group: ResourcesGroup
var sound_manager = GameSoundManager.get_instance()
var enemies_resources_group: ResourcesGroup
var bosses_resource_group: ResourcesGroup
var enemies_manager = EnemiesManager.get_instance() 
var level_enemies: SurvivalModeEnemies
var resources = []

@onready var level_music_player = $LevelMusicPlayer
@onready var level_victory_music_player = $LevelVictoryMusicPlayer
@onready var loading_screen = $LoadingScreen


func with_data(player):
	$PlayerSpawn.add_child(player)
	return self

func _ready():
	spawn_points = ArrayCollection.new(
		[$EnemiesSpawn, $EnemiesSpawn2, $EnemiesSpawn3, $EnemiesSpawn4, $EnemiesSpawn5]
	)
	victory_music_resources_group = ResourcesGroup.new(
		sound_manager.victory_loops_keys, 
		sound_manager.music_res
	)
	survival_music_resources_group = ResourcesGroup.new(
		sound_manager.survival_music_keys(), 
		sound_manager.music_res
	)
	enemies_resources_group = ResourcesGroup.new(enemies_manager.zombie_keys, enemies_manager.enemy_res)
	bosses_resource_group = ResourcesGroup.new(enemies_manager.bosses_keys, enemies_manager.bosses_res)
	
	resources = [victory_music_resources_group, survival_music_resources_group, enemies_resources_group, bosses_resource_group]
	
	GlobalEventBus.player_arrived_to_level.emit(LevelManager.Levels.ABANDONED_FARM)

func _process(delta):
	if(game_mode != null):
		game_mode._process(delta)
	else:
		on_loading_resources()
		
func on_loading_resources():
	if(level_music != null && game_mode == null && level_enemies != null):
		game_mode = SurvivalGameMode.new(spawn_points, level_music, level_enemies)		
		return
	else:
		var all_loaded = true
		for resource in resources:
			resource.load_resource_group()
			all_loaded = all_loaded && resource.is_group_loaded()
		on_music_loaded()
		on_enemies_loaded()
		if (all_loaded):
			loading_screen.hide()
			
func on_music_loaded():
	if (victory_music_resources_group.is_group_loaded() && survival_music_resources_group.is_group_loaded()):	
		level_music = SurvivalModeMusic.new(
					survival_music_resources_group.sort().get_loaded_resources(),
					level_music_player,				
					victory_music_resources_group.get_loaded_resources(),
					level_victory_music_player
			)

func on_enemies_loaded():
	if(enemies_resources_group.is_group_loaded() && bosses_resource_group.is_group_loaded()):
		level_enemies =  SurvivalModeEnemies.new(
			enemies_resources_group.sort().get_loaded_resources(),
			bosses_resource_group.sort().get_loaded_resources(),
			[1, 10, 15, 18, 20, 22, 25, 27, 30, 1]
		)
	
func destroy():
	if (game_mode != null):
		game_mode.clear_event_subscriptions()
	queue_free()

func pause(node: Node = self):
	set_pause(node, true)	

func resume(node: Node = self):
	set_pause(node, false)		

func set_pause(node: Node, pause: bool):
	if(node == self || node.is_in_group("character")):
		node.set_process(!pause)
		node.set_physics_process(!pause)
	
	for child in node.get_children():
		set_pause(child, pause)			
