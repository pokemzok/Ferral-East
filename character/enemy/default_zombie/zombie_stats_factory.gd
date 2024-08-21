class_name ZombieStatsFactory



static func create() -> EnemyStats:
	var type = Enemy.EnemyType.DEFAULT_ZOMBIE
	var health_points = NumericAttribute.new(2, 6)
	var speed = NumericAttribute.new(100, 300) 
	return EnemyStats.new(type, health_points, speed, 0) 


# TODO probably would have different factory instead (instead of default zombie it would be REANIMATING_ZOMBIE)
static func create_reanimating() -> EnemyStats:
	var type = Enemy.EnemyType.DEFAULT_ZOMBIE
	var health_points = NumericAttribute.new(2, 6)
	var speed = NumericAttribute.new(100, 300) 
	return EnemyStats.new(type, health_points, speed, 1)
