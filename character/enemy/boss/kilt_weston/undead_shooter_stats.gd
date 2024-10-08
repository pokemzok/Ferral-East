extends Node
class_name UndeadShooterStats

var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.25) 
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(20, 20)
var accuracy = NumericAttribute.new(1, 1)
var consumable_cooldown = NumericAttribute.new(0, 0.3)
var projectiles_dmg_velocity = 100

var item_actions = {
	Item.ItemID.PENTAGRAM: "increment_health"
}

func _init(
	invincible_frames: NumericAttribute,
	stunned_timer: NumericAttribute,
	reload_timer: NumericAttribute,
	health_points: NumericAttribute
):
	self.invincible_frames = invincible_frames
	self.stunned_timer = stunned_timer
	self.reload_timer = reload_timer
	self.health_points = health_points
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

