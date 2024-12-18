class_name ScoreDetails

var score
var enemy_value: int
var score_multiplier: int

func _init(_score, _enemy_value, _score_multiplier):
	self.score = _score
	self.enemy_value = _enemy_value
	self.score_multiplier = _score_multiplier
