class_name EnemyDeathDetails

var enemy_type: Enemy.EnemyType
var score: int
var death_position: Vector2

func _init(enemy_type: Enemy.EnemyType, death_score: int, death_position: Vector2):
	self.enemy_type = enemy_type
	self.score = death_score
	self.death_position = death_position
