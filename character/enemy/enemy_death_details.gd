class_name EnemyDeathDetails

var enemy_type: Enemy.EnemyType
var score: int
var death_position: Vector2
var enemy: CharacterBody2D

func _init(enemy: CharacterBody2D):
	self.enemy_type = enemy.stats.type
	self.score = enemy.stats.death_score
	self.death_position = enemy.global_position
	self.enemy = enemy
