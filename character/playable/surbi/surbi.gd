extends CharacterBody2D

signal hp_changed(current_hp)
var bullet_speed = 2000
var bullet = preload("res://projectiles/bullet/bullet.tscn")
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
		fire()	

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

func fire():
	var bullet_instance  = bullet.instantiate()
	var offset = Vector2(40, 33) 
	var mouse_position = get_global_mouse_position()
	var character_position = global_position
	bullet_instance.position = character_position + offset.rotated(rotation)
	bullet_instance.rotation_degrees = rotation_degrees
	
	var innacurracy_radious = 200	
	var direction_to_mouse = (mouse_position - bullet_instance.position).angle()
	var distance_to_mouse = character_position.distance_to(mouse_position)
	var bullet_direction = rotation
	if distance_to_mouse > innacurracy_radious:
		bullet_direction = direction_to_mouse
	
	bullet_instance.rotation = bullet_direction
	bullet_instance.apply_impulse(Vector2(bullet_speed,  0).rotated(bullet_direction), Vector2()) 
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)

func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

