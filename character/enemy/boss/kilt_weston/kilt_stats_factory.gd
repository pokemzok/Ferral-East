class_name  KiltStatsFactory

static func create() -> UndeadShooterStats:
	var invincible_frames = NumericAttribute.new(0, 20)
	var stunned_timer = NumericAttribute.new(0, 0.25) 
	var reload_timer = NumericAttribute.new(0, 0.75)
	var staggered_timer = NumericAttribute.new(0, 0.35)  
	var health_points = NumericAttribute.new(0.5, 20)
	var speed = NumericAttribute.new(400, 700)
	return UndeadShooterStats.new(
		Enemy.EnemyType.KILT_WESTON,
		invincible_frames,
		stunned_timer,
		reload_timer,
		staggered_timer,
		health_points,
		speed
	)
