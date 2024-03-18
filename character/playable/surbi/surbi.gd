extends CharacterBody2D

signal hp_changed(current_hp)
var weapon = Revolver.new()
var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var health_points = NumericAttribute.new(3, 10)
var enemies_in_player_collision_area =  []

func after_external_init():
	emit_signal("hp_changed", health_points.value)	

func _physics_process(delta):
	on_dmg()
	if stunned_timer.value > 0:
		on_stun(delta)
		invincible_frames.assign_max_value()		
	else:
		if (invincible_frames.value > 0):
			invincible_frames.decrement_by()
		on_player_actions(delta)	

func on_dmg():
	if (invincible_frames.value < 1 && enemies_in_player_collision_area.size() > 0):
		stun()
		health_points.decrement_by()
		emit_signal("hp_changed", health_points.value)

func stun():
	if (stunned_timer.value <= 0):
		stunned_timer.assign_max_value()

func on_stun(delta):
	stunned_timer.decrement_by(delta)
	play_stunned()				
		
func on_player_actions(delta):
	look_at(get_global_mouse_position())	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()	
	if velocity.length() > 0:
		play_walk()
	else:
		play_idle()	
	if Input.is_action_just_pressed("fire"):
		attack()	

func knockback():
	if (invincible_frames.value < 1):
		velocity = -velocity.normalized() * 5000
		move_and_slide()
	
			
# Try different approach for animation for  Halina or Aneta (animation tree + animation player setup)
func play_idle():
	$AnimatedSprite2D.play("idle")

func play_walk():
	$AnimatedSprite2D.play("walk")

func play_stunned():
	$AnimatedSprite2D.play("stunned")

func attack():
	weapon.attack(self, get_global_mouse_position())

func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)

func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

