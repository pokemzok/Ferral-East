class_name GameScore
extends Node

var global_score = 0
var level_score = 0
var global_kills = 0
var perfect_kills = 0
var score_multiplier = 1
var multiplier_thresholds = [5, 10, 20, 35, 50, 75, 100]

func _init():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_DAMAGED, on_player_damaged)
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DAMAGED, on_enemy_damaged)
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)

func on_player_damaged():
	perfect_kills = 0
	score_multiplier = 1
	if (level_score > 0):
		increment_score(-20)
	
func on_enemy_damaged(type):
	var enemy_value = 0
	match(type):
		Enemy.EnemyType.DEFAULT_ZOMBIE:
			enemy_value = 10
	increment_score(enemy_value)

func on_enemy_death(type):
	perfect_kills += 1
	global_kills += 1
	var enemy_value = 0
	match(type):
		Enemy.EnemyType.DEFAULT_ZOMBIE:
			enemy_value = 50
	score_multiplier = select_score_multiplier()
	increment_score(enemy_value)
			
func select_score_multiplier() -> int:
	var multiplier = 1 
	for i in multiplier_thresholds.size():
		if perfect_kills >= multiplier_thresholds[i]:
			multiplier += 1
		else:
			break
	return multiplier			

func increment_score(enemy_value):
	level_score += (enemy_value * score_multiplier)
	GlobalEventBus.score_changed.emit(ScoreDetails.new(level_score, enemy_value, score_multiplier))

func on_level_end():
	global_score += level_score
	level_score = 0
	score_multiplier = 1
