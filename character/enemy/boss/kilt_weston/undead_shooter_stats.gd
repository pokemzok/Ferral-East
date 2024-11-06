extends CharacterStats
class_name UndeadShooterStats

var type: Enemy.EnemyType
var death_score = 1000

var item_actions = {
	Item.ItemID.PENTAGRAM: "increment_health"
}

func _init(
	type: Enemy.EnemyType,
	invincible_frames: NumericAttribute,
	stunned_timer: NumericAttribute,
	reload_timer: NumericAttribute,
	staggered_timer: NumericAttribute,
	health_points: NumericAttribute,
	speed: NumericAttribute
):
	self.type = type
	self.invincible_frames = invincible_frames
	self.stunned_timer = stunned_timer
	self.reload_timer = reload_timer
	self.staggered_timer = staggered_timer
	self.health_points = health_points
	self.speed = speed
	# FIXME boss consume item instead
	#GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMED_ITEM, apply_item)
	emit_information()

func emit_information():
	# FIXME emit boss HP instead 
	# GlobalEventBus.player_hp_changed.emit(health_points.value)
	pass

func apply_item(item: Item) -> bool:
	if(item_actions.has(item.id)):
		call(item_actions[item.id])
		return true
	return false	
		
func increment_health():
	if (!health_points.is_max_value()):
		health_points.increment_by()
		#FIXME boss HP instead		
		# GlobalEventBus.player_hp_changed.emit(health_points.value)	

func decrement_health():
	health_points.decrement_by()
	# FIXME boss hp instead
	# GlobalEventBus.player_hp_changed.emit(health_points.value)	
