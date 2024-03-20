extends CharacterBody2D

signal hp_changed(current_hp)
var weapon = Revolver.new()
var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(3, 10)
var enemies_in_player_collision_area =  []
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $AudioPool
var sound_manager = GameSoundManager.new() #FIXME turn this into singleton

func after_external_init():
	emit_signal("hp_changed", health_points.value)	

func _physics_process(delta):
	on_dmg()
	on_reload(delta)
	if stunned_timer.value > 0:
		on_stun(delta)	
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
	invincible_frames.assign_max_value()	
	reload_timer.assign_max_on_more_then_zero()
	
func on_reload(delta):
	if(reload_timer.value > 0 ):
		reload_timer.decrement_by(delta)
	elif(reload_timer.value <= 0 && weapon.bullets_in_cylinder.value == 0):
		weapon.reload()
		
func on_player_actions(delta):
	look_at(get_global_mouse_position())	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()	
	if velocity.length() > 0:
		play_walk()
	else:
		play_idle()	
	if Input.is_action_just_pressed("fire") && reload_timer.value <= 0:
		attack()

func knockback():
	if (invincible_frames.value < 1):
		velocity = -velocity.normalized() * 5000
		move_and_slide()
	
			
# Try different approach for animation for  Halina or Aneta (animation tree + animation player setup)
func play_idle():
	if(reload_timer.value > 0 ):
		animations.play("idle_reload")	
	else:
		animations.play("idle")	

func play_walk():
	if(reload_timer.value > 0 ):
		animations.play("walk_reload")
	else:	
		animations.play("walk")

func play_stunned():
	animations.play("stunned")

func attack():
	var success = weapon.attack_with(self, get_global_mouse_position())
	if (success):
		sound_manager.play_sound_effect(weapon.get_shoot_audio(), get_idle_audio_player())
	if (!success):
		start_reloading()
		

func start_reloading():
	reload_timer.assign_max_value()
	sound_manager.play_sound_effect(weapon.get_reload_audio(), get_idle_audio_player())

func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)

func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

func get_idle_audio_player():
	for child in audio_pool.get_children():
		var audio_player = child as AudioStreamPlayer
		if not audio_player.is_playing():
			return audio_player
	return audio_pool.get_children()[0]
