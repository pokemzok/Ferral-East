class_name  KiltStatsFactory

static func create() -> UndeadShooterStats:
	var invincible_frames = NumericAttribute.new(0, 20)
	var stunned_timer = NumericAttribute.new(0, 0.15) 
	var reload_timer = NumericAttribute.new(0, 0.75) 
	var health_points = NumericAttribute.new(20, 20)
	return UndeadShooterStats.new(Enemy.EnemyType.KILT_WESTON, invincible_frames, stunned_timer, reload_timer, health_points)
