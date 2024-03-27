extends CharacterBody2D

var weapon = Revolver.new()
var invincible_frames = NumericAttribute.new(0, 10)
var stunned_timer = NumericAttribute.new(0, 0.5) 
var dying_timer = NumericAttribute.new(0, 1) 
var reload_timer = NumericAttribute.new(0, 1) 
var health_points = NumericAttribute.new(3, 10)
var enemies_in_player_collision_area =  []
var is_dead = false

var sound_manager = GameSoundManager.get_instance()
var grunts_audio = sound_manager.surbi_grunts
var death_audio = GameSoundManager.Sounds.SURBI_DEATH
var run_audio = GameSoundManager.Sounds.PLAYER_RUN

@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $GameAmbientAudioPool

func after_external_init():
	GlobalEventBus.player_hp_changed.emit(health_points.value)

func _physics_process(delta):
	if (!is_dead):
		on_dmg()
		on_reload(delta)
		if (dying_timer.value > 0):
			on_dying(delta)
		elif stunned_timer.value > 0:
			on_stun(delta)	
		else:
			if (invincible_frames.value > 0):
				invincible_frames.decrement_by()
			on_player_actions(delta)	

func on_dmg():
	if (invincible_frames.value < 1 && enemies_in_player_collision_area.size() > 0):
		health_points.decrement_by()
		GlobalEventBus.player_hp_changed.emit(health_points.value)
		if (health_points.value < 1):
			dying()
		else:
			stun()	

func stun():
	if (stunned_timer.value <= 0):
		stunned_timer.assign_max_value()
		audio_pool.play_sound_effect(grunts_audio.random_element())

func dying():
	if (dying_timer.value <= 0):
		dying_timer.assign_max_value()
		audio_pool.play_sound_effect(death_audio)
	#TODO: dying timer plus dying animation
	
func on_stun(delta):
	stunned_timer.decrement_by(delta)
	play_stunned()
	walking_audio_player.stop()
	invincible_frames.assign_max_value()	
	reload_timer.assign_max_on_more_then_zero()

func on_dying(delta):
	dying_timer.decrement_by(delta)
	animations.play("dying")
	if (dying_timer.value <= 0):
		die()

func die():
	is_dead = true
	animations.play("death")	
	GlobalEventBus.player_death.emit()
	
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
		on_walk()
	else:
		on_idle()	
	if Input.is_action_just_pressed("attack") && reload_timer.value <= 0:
		attack()

func knockback():
	if (invincible_frames.value < 1):
		velocity = -velocity.normalized() * 5000
		move_and_slide()
	
			
# Try different approach for animation for  Halina or Aneta (animation tree + animation player setup)
func on_idle():
	walking_audio_player.stop()
	if(reload_timer.value > 0 ):
		animations.play("idle_reload")	
	else:
		animations.play("idle")	

func on_walk():
	sound_manager.play_sound(run_audio, walking_audio_player)
	if(reload_timer.value > 0 ):
		animations.play("walk_reload")
	else:	
		animations.play("walk")

func play_stunned():
	animations.play("stunned")

func attack():
	var success = weapon.attack_with(self, get_global_mouse_position())
	audio_pool.play_sound_effect(weapon.get_shoot_audio())
	if(!success):
		start_reloading()

func start_reloading():
	reload_timer.assign_max_value()
	audio_pool.play_sound_effect(weapon.get_reload_audio())

func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)

func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

