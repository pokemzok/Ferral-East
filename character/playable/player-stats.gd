class_name PlayerStats

var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(3, 10)

var item_actions = {
	Item.ItemType.HEAL: "increment_health"
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
	GlobalEventBus.player_hp_changed.emit(health_points.value)	

func apply_item(type: Item.ItemType) -> bool:
	if(item_actions.has(type)):
		call(item_actions[type])
		return true
	return false	
		
func increment_health():
	health_points.increment_by()
	if (health_points.is_max_value()):
		## TODO: add regen stat here. I will have a timer which would regen after lets say 2 minutes 
		pass
	GlobalEventBus.player_hp_changed.emit(health_points.value)	

func decrement_health():
	health_points.decrement_by()
	GlobalEventBus.player_hp_changed.emit(health_points.value)	
