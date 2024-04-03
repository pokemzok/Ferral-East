class_name ZombieStatsFactory

static var type = Enemy.EnemyType.DEFAULT_ZOMBIE
static var health_points = NumericAttribute.new(2, 6)
static var speed = NumericAttribute.new(100, 300) 

static func create() -> EnemyStats:
	return EnemyStats.new(type, health_points, speed)
