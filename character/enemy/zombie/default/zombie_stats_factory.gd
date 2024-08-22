class_name ZombieStatsFactory



static func create(type: Enemy.EnemyType) -> EnemyStats:
	var health_points = NumericAttribute.new(2, 6)
	return EnemyStats.new(type, health_from(type), speed_from(type), reanimating_times_from(type), path_finding_from(type)) 


static func path_finding_from(type: Enemy.EnemyType):
	match type:
		Enemy.EnemyType.DEFAULT_ZOMBIE:
			return PathFindingStrategy.PathFindingAlgorithm.DUMB_COLLIDE
		Enemy.EnemyType.FAST_ZOMBIE:
			return PathFindingStrategy.PathFindingAlgorithm.NAVIGATION_AGENT
		Enemy.EnemyType.REANIMATING_ZOMBIE:
			return PathFindingStrategy.PathFindingAlgorithm.NAVIGATION_AGENT


static func reanimating_times_from(type: Enemy.EnemyType):
	if(type == Enemy.EnemyType.REANIMATING_ZOMBIE):
		return 1
	else:
		return 0	


static func speed_from(type: Enemy.EnemyType):
	if (type == Enemy.EnemyType.FAST_ZOMBIE):
		return NumericAttribute.new(300, 400) 
	else:
		return NumericAttribute.new(100, 300) 
		
static func health_from(type: Enemy.EnemyType):
	match type:
		Enemy.EnemyType.DEFAULT_ZOMBIE:
			return NumericAttribute.new(3, 6)
		Enemy.EnemyType.FAST_ZOMBIE:
			return NumericAttribute.new(3, 5)
		Enemy.EnemyType.REANIMATING_ZOMBIE:
			return NumericAttribute.new(4, 6)		
