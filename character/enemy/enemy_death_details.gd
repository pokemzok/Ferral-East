class_name EnemyDeathDetails

var enemy_type: Enemy.EnemyType
var score: int
var death_position: Vector2
var enemy: CharacterBody2D

func _init(_enemy: CharacterBody2D):
	self.enemy_type = _enemy.stats.type
	self.score = _enemy.stats.death_score
	self.death_position = _enemy.global_position
	self.enemy = _enemy
