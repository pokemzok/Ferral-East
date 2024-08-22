class_name EnemyStats

var type: Enemy.EnemyType
var health_points: NumericAttribute
var speed: NumericAttribute
var dmg_score: int
var death_score: int
var stunned_timer = NumericAttribute.new(0, NumericAttribute.new(0.1, 0.3).randomize_value().value)
var attack_timer = NumericAttribute.new(0, NumericAttribute.new(0.4, 0.6).randomize_value().value)
var dying_timer = NumericAttribute.new(0, 50)
var reanimation_timer = NumericAttribute.new(0, 5)
var speed_increase_factor = 0.5
var projectiles_dmg_velocity = 100
var reanimates_times: int
var starting_health: int
var path_finding_algo: PathFindingStrategy.PathFindingAlgorithm  
	
func _init(type: Enemy.EnemyType, health_points: NumericAttribute, speed: NumericAttribute, reanimates_times: int, path_finding_algo: PathFindingStrategy.PathFindingAlgorithm):
	self.health_points = health_points
	self.speed = speed
	self.type = type
	self.reanimates_times = reanimates_times	
	self.health_points.randomize_value()
	self.starting_health = self.health_points.value
	self.speed.randomize_value()
	self.dmg_score = calculate_score(5, 20)
	var reanimation_multipler = reanimates_times + 1
	self.death_score = calculate_score(40*reanimation_multipler, 80*reanimation_multipler)
	self.path_finding_algo = path_finding_algo
				
func calculate_score(min: int, max: int):
	var normalized_health = (health_points.value) / (health_points.max_value)
	var normalized_speed = (speed.value) / (speed.max_value)
	var weight = 0.5
	var weighted_average = (normalized_health * weight) + (normalized_speed * weight)
	var score = min + (weighted_average * (max - min))
	return round(score)

func can_reanimate() -> bool:
	return self.reanimates_times > 0
	
func reanimated():
	self.reanimates_times -= 1
	self.health_points.value = starting_health

func get_dying_timer() -> NumericAttribute:
	if (can_reanimate()):
		return reanimation_timer
	else:
		return dying_timer	
