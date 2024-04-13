class_name EnemyStats

var type: Enemy.EnemyType
var health_points: NumericAttribute
var speed: NumericAttribute
var dmg_score: int
var death_score: int
var stunned_timer = NumericAttribute.new(0, NumericAttribute.new(0.1, 0.3).randomize_value().value)
var attack_timer = NumericAttribute.new(0, NumericAttribute.new(0.2, 0.4).randomize_value().value)
var speed_increase_factor = 0.5
var projectiles_dmg_velocity = 100

func _init(type: Enemy.EnemyType, health_points: NumericAttribute, speed: NumericAttribute):
	self.health_points = health_points
	self.speed = speed
	self.type = type
	self.health_points.randomize_value()
	self.speed.randomize_value()
	self.dmg_score = calculate_score(5, 20)
	self.death_score = calculate_score(40, 80)
	
func calculate_score(min: int, max: int):
	var normalized_health = (health_points.value) / (health_points.max_value)
	var normalized_speed = (speed.value) / (speed.max_value)
	var weight = 0.5
	var weighted_average = (normalized_health * weight) + (normalized_speed * weight)
	var score = min + (weighted_average * (max - min))
	return round(score)
