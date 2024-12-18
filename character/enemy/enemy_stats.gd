extends CharacterStats
class_name EnemyStats

var type: Enemy.EnemyType
var dmg_score: int
var death_score: int
var attack_timer = NumericAttribute.new(0, NumericAttribute.new(0.4, 0.6).randomize_value().value)
var speed_increase_factor = 0.5
var path_finding_algo: PathFindingStrategy.PathFindingAlgorithm  
	
func _init(_type: Enemy.EnemyType, _health_points: NumericAttribute, _speed: NumericAttribute, _reanimates_times: int, _path_finding_algo: PathFindingStrategy.PathFindingAlgorithm):
	self.health_points = _health_points
	self.speed = _speed
	self.type = _type
	self.reanimates_times = _reanimates_times	
	self.health_points.randomize_value()
	self.starting_health = self.health_points.value
	self.speed.randomize_value()
	self.dmg_score = calculate_score(5, 20)
	self.dying_timer = NumericAttribute.new(0, 50)
	self.stunned_timer = NumericAttribute.new(0, NumericAttribute.new(0.1, 0.3).randomize_value().value)
	var reanimation_multipler = reanimates_times + 1
	self.death_score = calculate_score(40*reanimation_multipler, 80*reanimation_multipler)
	self.path_finding_algo = _path_finding_algo
				
func calculate_score(_min: int, _max: int):
	var normalized_health = (health_points.value) / (health_points.max_value)
	var normalized_speed = (speed.value) / (speed.max_value)
	var weight = 0.5
	var weighted_average = (normalized_health * weight) + (normalized_speed * weight)
	var score = _min + (weighted_average * (_max - _min))
	return round(score)

