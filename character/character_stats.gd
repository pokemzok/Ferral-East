extends Node
class_name CharacterStats

var state = CharacterState.State.NORMAL
var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var staggered_timer = NumericAttribute.new(0, 0.25)
var stagger_force = 25000
var stagger_velocity = Vector2.ZERO
var knockback_timer = NumericAttribute.new(0, 0.75) 
var knockback_velocity  = Vector2.ZERO
var knockback_decay = 20000
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(5, 10)
var attack_cooldown = NumericAttribute.new(0.1, 0.3)
var secondary_attack_cooldown = NumericAttribute.new(0, 2)
var accuracy = NumericAttribute.new(1, 5)
var consumable_cooldown = NumericAttribute.new(0, 0.3)
var projectiles_dmg_velocity = 100
var speed = NumericAttribute.new(600, 800)
var reanimates_times: int = 0
var starting_health: int  = 1
var reanimation_timer = NumericAttribute.new(0, 5)

func apply_stun():
	stunned_timer.assign_max_value()
	state = CharacterState.State.STUNNED

func apply_stagger(stagger: Vector2):
	stagger_velocity = stagger * stagger_force
	assign_state(CharacterState.State.STAGGERED)
	staggered_timer.assign_max_value()

func apply_knockback(knockback: Vector2):
	knockback_velocity = knockback
	state = CharacterState.State.KNOCKBACK
	knockback_timer.assign_max_value()

func decrease_stun(delta):
	stunned_timer.decrement_by(delta)	
	if(stunned_timer.is_lte_zero()):
		remove_state(CharacterState.State.STUNNED)

func decrease_knockback(delta):
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	if knockback_velocity.length() < 10:
		reset_knockback()

func decrease_stagger(delta):
	if stagger_velocity.length() < 10:
		stagger_velocity = stagger_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)

func reset_knockback():
	if (has_knockback()):
		knockback_velocity = Vector2.ZERO
		knockback_timer.assign_zero()
		remove_state(CharacterState.State.KNOCKBACK)

func reset_stagger():
	stagger_velocity = Vector2.ZERO
	staggered_timer.assign_zero()
	assign_state(CharacterState.State.NORMAL)

func reloading():
	reload_timer.assign_max_value()

func complete_reloading(delta) -> bool:
	reload_timer.decrement_by(delta)
	if(reload_timer.value <= 0):
		return true
	return false	

func force_complete_reloading():
	reload_timer.assign_zero()

func has_knockback():
	return state == CharacterState.State.KNOCKBACK

func assign_state(state_to_assign: CharacterState.State):
	if(!is_dead() && !is_dying() ):
		self.state = state_to_assign

func remove_state(state_to_remove: CharacterState.State):
	if (self.state == state_to_remove):
		self.state = CharacterState.State.NORMAL

func dying():
	assign_state(CharacterState.State.DYING)
	dying_timer.assign_max_value()
	reanimation_timer.assign_max_value()

func dead():
	state = CharacterState.State.DEAD

func is_dead():
	return state == CharacterState.State.DEAD	

func is_dying():
	return state == CharacterState.State.DYING	

func is_teleporting():
	return state == CharacterState.State.TELEPORTING

func is_stunned():
	return state == CharacterState.State.STUNNED	
	
func can_reanimate() -> bool:
	return self.reanimates_times > 0
	
func reanimated():
	self.reanimates_times -= 1
	self.health_points.value = starting_health
	self.state = CharacterState.State.NORMAL

func get_dying_timer() -> NumericAttribute:
	if (can_reanimate()):
		return reanimation_timer
	else:
		return dying_timer	
	
