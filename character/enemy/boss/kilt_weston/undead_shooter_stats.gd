extends CharacterStats
class_name UndeadShooterStats

var type: Enemy.EnemyType
var death_score = 1000

var item_actions = {
	Item.ItemID.PENTAGRAM: "increment_health"
}

func _init(
	_type: Enemy.EnemyType,
	_invincible_frames: NumericAttribute,
	_stunned_timer: NumericAttribute,
	_reload_timer: NumericAttribute,
	_staggered_timer: NumericAttribute,
	_health_points: NumericAttribute,
	_speed: NumericAttribute
):
	self.type = _type
	self.invincible_frames = _invincible_frames
	self.stunned_timer = _stunned_timer
	self.reload_timer = _reload_timer
	self.staggered_timer = _staggered_timer
	self.health_points = _health_points
	self.speed = _speed
	emit_hp_information()

func emit_hp_information():
	GlobalEventBus.boss_enemy_hp_changed.emit(health_points.value)

func apply_item(item: Item) -> bool:
	if(item_actions.has(item.id)):
		call(item_actions[item.id])
		return true
	return false	
		
func increment_health():
	if (!health_points.is_max_value()):
		health_points.increment_by(3)
		emit_hp_information()	

func decrement_health_by(value):
	health_points.decrement_till_zero_by(value)
	emit_hp_information()
