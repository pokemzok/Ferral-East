class_name ScoreDetails

var score
var enemy_value: int
var score_multiplier: int

func _init(score, enemy_value, score_multiplier):
	self.score = score
	self.enemy_value = enemy_value
	self.score_multiplier = score_multiplier
