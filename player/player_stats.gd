extends Node
class_name PlayerStats

var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var knockback_timer = NumericAttribute.new(0, 0.75) 
var knockback_velocity  = Vector2.ZERO
var knockback_decay = 20000
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(5, 10)
var secondary_attack_cooldown = NumericAttribute.new(0, 2)
var accuracy = NumericAttribute.new(1, 5)
var consumable_cooldown = NumericAttribute.new(0, 0.3)
var projectiles_dmg_velocity = 100
var speed = NumericAttribute.new(600, 800)
var status = StatusEffect.Status.NONE
var kill_count = 0
var level_threshoulds = [10, 30, 60, 100, 150, 220, 300, 400, 520, 670, 900, 1200, 1700, 2200, 2700, 3200, 3700, 4200, 4700, 5200, 5700, 6200, 6700, 7200, 7700, 8200, 8700, 10000]
var current_level = 0

var item_actions = {
	Item.ItemID.PENTAGRAM: "increment_health",
	Item.ItemID.WATER: "increment_health"
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
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, increment_kill_count)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMED_ITEM, apply_item)
	emit_information()

func emit_information():
	GlobalEventBus.player_hp_changed.emit(health_points.value)

func apply_item(item: Item) -> bool:
	if(item_actions.has(item.id)):
		call(item_actions[item.id])
		return true
	return false	
		
func increment_health():
	if (!health_points.is_max_value()):
		health_points.increment_by()		
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
		GlobalEventBus.player_upgraded.emit("LEVEL_UP")		

func is_max_level()->bool:
	return current_level >= level_threshoulds.size()

func increment_accuracy():
	if(!accuracy.is_max_value()):
		if(accuracy.value < 2):
			accuracy.increment_by(0.25)
		else:
			accuracy.increment_by(0.15)

func has_status_effect():
	return status != StatusEffect.Status.NONE

func clear_status():
	status = StatusEffect.Status.NONE	

func apply_stun():
	stunned_timer.assign_max_value()
	status = StatusEffect.Status.STUNNED

func apply_knockback(knockback: Vector2):
	knockback_velocity = knockback
	status = StatusEffect.Status.KNOCKBACK
	knockback_timer.assign_max_value()

func decrease_knockback(delta):
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	if knockback_velocity.length() < 10:
		reset_knockback()

func reset_knockback():
	if (has_knockback_status()):
		knockback_velocity = Vector2.ZERO
		knockback_timer.assign_zero()
		clear_status()

func has_knockback_status():
	return status == StatusEffect.Status.KNOCKBACK
