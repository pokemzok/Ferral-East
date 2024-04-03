class_name EnemyStats

var type: Enemy.EnemyType
var health_points: NumericAttribute
var speed: NumericAttribute

var stunned_timer = NumericAttribute.new(0, NumericAttribute.new(0.1, 0.3).randomize_value().value)
var speed_increase_factor = 0.5
var projectiles_dmg_velocity = 100

func _init(type: Enemy.EnemyType, health_points: NumericAttribute, speed: NumericAttribute):
	self.health_points = health_points
	self.speed = speed
	self.type = type
	self.health_points.randomize_value()
	self.speed.randomize_value()
