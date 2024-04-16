class_name SurbiStatsFactory

static var invincible_frames = NumericAttribute.new(0, 10)
static var stunned_timer = NumericAttribute.new(0, 0.5) 
static var reload_timer = NumericAttribute.new(0, 1) 
static var health_points = NumericAttribute.new(3, 10)

static func create() -> PlayerStats:
	return PlayerStats.new(invincible_frames, stunned_timer, reload_timer, health_points)

