extends CharacterBody2D

var bullet_speed = 2000
var bullet = preload("res://projectiles/bullet/bullet.tscn") #FIXME doesn't look ideal, try to fix it maybe?
var hurt_timer = 0
var invincible_frames = 10
var stunned_timer = 0 
var health_points = 3

func _physics_process(delta):
	if stunned_timer > 0:
		stunned_timer -= delta
		play_stunned()
		invincible_frames = 10
	else:
		invincible_frames -= 1
		process_player_actions(delta)	
		
func process_player_actions(delta):
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
	if (invincible_frames < 1):
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
		stunned()
		take_dmg()

func stunned():
	if (stunned_timer <= 0):
		stunned_timer =  0.5

func take_dmg():
	if (invincible_frames < 1):
		health_points -= 1
		print(health_points) #  FIXME more here, for now we just decrement health and that's it
