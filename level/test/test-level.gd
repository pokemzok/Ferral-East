extends Node

var zombie = preload("res://character/enemy/default_zombie/default_zombie.tscn")
var game_mode: GameMode 

func _ready():
	var spawn_points = ArrayCollection.new(
		[$EnemiesSpawn, $EnemiesSpawn2, $EnemiesSpawn3, $EnemiesSpawn4, $EnemiesSpawn5]
	)
	game_mode = SurvivalGameMode.new(spawn_points)
	
func _process(delta):
	game_mode._process(delta)

