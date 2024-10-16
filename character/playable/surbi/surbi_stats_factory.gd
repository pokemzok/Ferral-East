class_name SurbiStatsFactory



static func create() -> PlayerStats:
	var invincible_frames = NumericAttribute.new(0, 10)
	var stunned_timer = NumericAttribute.new(0, 0.5) 
	var reload_timer = NumericAttribute.new(0, 1) 
	var health_points = NumericAttribute.new(5, 10)
	return PlayerStats.new(invincible_frames, stunned_timer, reload_timer, health_points)

