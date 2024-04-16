extends Node

var spawn_points: ArrayCollection
var game_mode: GameMode 
var level_music: SurvivalModeMusic
var victory_music_resources_group: ResourcesGroup
var survival_music_resources_group: ResourcesGroup
var sound_manager = GameSoundManager.get_instance()
@onready var level_music_player = $LevelMusicPlayer
@onready var level_victory_music_player = $LevelVictoryMusicPlayer
@onready var loading_screen = $LoadingScreen

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
	
func _process(delta):
	if(game_mode != null):
		game_mode._process(delta)
	else:
		on_loading_resources()
		
func on_loading_resources():
	if(level_music != null):
		if (game_mode == null):
			game_mode = SurvivalGameMode.new(spawn_points, level_music)		
			return
	else:
		survival_music_resources_group.load_resource_group()		
		victory_music_resources_group.load_resource_group()
		if (victory_music_resources_group.is_group_loaded() && survival_music_resources_group.is_group_loaded()):
			loading_screen.hide()
			level_music = SurvivalModeMusic.new(
				survival_music_resources_group.get_loaded_resources(),
				level_music_player,				
				victory_music_resources_group.get_loaded_resources(),
				level_victory_music_player
			)		
	
func destroy():
	if (game_mode != null):
		game_mode.clear_event_subscriptions()
	queue_free()
