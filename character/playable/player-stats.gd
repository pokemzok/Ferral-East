class_name PlayerStats

var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(3, 10)
var accuracy = NumericAttribute.new(1, 5)
var kill_count = 0
var level_threshoulds = [10, 30, 60, 100, 150, 220, 300, 400, 520, 670, 900, 1200, 1700, 2200, 2700, 3200, 3700, 4200, 4700, 5200, 5700, 6200, 6700, 7200, 7700, 8200, 8700, 10000]
var current_level = 0

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
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, increment_kill_count)

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

func increment_kill_count(death_details):
	kill_count += 1
	if (!is_max_level()):
		if( kill_count >=  level_threshoulds[current_level]):
			level_up()

func level_up():
	if (!is_max_level()):
		current_level += 1
		increment_accuracy()
		GlobalEventBus.player_leveled_up.emit()		

func is_max_level()->bool:
	return current_level >= level_threshoulds.size()

func increment_accuracy():
	if(!accuracy.is_max_value()):
		if(accuracy.value < 2):
			accuracy.increment_by(0.25)
		else:
			accuracy.increment_by(0.15)