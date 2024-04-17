class_name ZombieStatsFactory



static func create() -> EnemyStats:
	var type = Enemy.EnemyType.DEFAULT_ZOMBIE
	var health_points = NumericAttribute.new(2, 6)
	var speed = NumericAttribute.new(100, 300) 
	return EnemyStats.new(type, health_points, speed)
