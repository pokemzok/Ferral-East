extends CharacterBody2D

var pausable = PausableNodeBehaviour.new(self)
var weapon = Revolver.new()
var stats: PlayerStats = SurbiStatsFactory.create()
var wallet: Wallet = Wallet.new()
var enemies_in_player_collision_area =  []
var is_dead = false
var reloading = false
var sound_manager = GameSoundManager.get_instance()
var grunts_audio = sound_manager.surbi_grunts
var death_audio = GameSoundManager.Sounds.SURBI_DEATH
var run_audio = GameSoundManager.Sounds.PLAYER_RUN
var pickup_audio = GameSoundManager.Sounds.PLAYER_PICKUP_ITEM
var item_collection = ArrayCollection.new([])
@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var effects_audio_player = $EffectsAudioStreamPlayer
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $GameAmbientAudioPool
@onready var monolog_bubble = $MonologBubble

func after_external_init():
	stats = SurbiStatsFactory.create()

func _ready():
	animations.connect("animation_looped", on_animation_finished)
	animations.connect("animation_finished", on_animation_finished)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, on_start_conversation_with)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, on_finish_conversation)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_MONOLOG, monolog_bubble.show_bubble)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ENTERS_SHOP, on_player_enters_shop)

func on_animation_finished():
	animations.stop()	
	if animations.animation == "teleporting":
		animations.play("invisible")
		GlobalEventBus.player_teleported.emit()
	
func _physics_process(delta):
	if (!is_dead):
		on_dmg()
		on_reload(delta)
		if (stats.dying_timer.value > 0):
			on_dying(delta)
		elif stats.stunned_timer.value > 0:
			on_stun(delta)	
		else:
			if (stats.invincible_frames.value > 0):
				stats.invincible_frames.decrement_by()
			on_player_actions(delta)	

func on_start_conversation_with(npc_name: String):
	pausable.set_pause(true)
	on_idle()

func on_finish_conversation():
	pausable.set_pause(false)

func on_player_enters_shop(shop_level):
	animations.play("teleporting")
	animations.animation_looped

func on_dmg():
	if (stats.invincible_frames.value < 1 && enemies_in_player_collision_area.size() > 0):
		stats.decrement_health()
		if (stats.health_points.value < 1):
			dying()
		else:
			GlobalEventBus.player_damaged.emit()
			stun()	

func stun():
	if (stats.stunned_timer.value <= 0):
		stats.stunned_timer.assign_max_value()
		audio_pool.play_sound_effect(grunts_audio.random_element())

func dying():
	if (stats.dying_timer.value <= 0):
		stats.dying_timer.assign_max_value()
		audio_pool.play_sound_effect(death_audio)
	
func on_stun(delta):
	stats.stunned_timer.decrement_by(delta)
	play_stunned()
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	stats.reload_timer.assign_max_on_more_then_zero()

func on_dying(delta):
	stats.dying_timer.decrement_by(delta)
	animations.play("dying")
	if (stats.dying_timer.value <= 0):
		die()

func die():
	is_dead = true
	animations.play("death")	
	GlobalEventBus.player_death.emit()
	
func on_reload(delta):
	if(stats.reload_timer.value > 0 ):
		stats.reload_timer.decrement_by(delta)
	elif(stats.reload_timer.value <= 0 && reloading):
		weapon.reload_with(self)
		reloading = false
		
func on_player_actions(delta):
	look_at(get_global_mouse_position())	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()	
	if velocity.length() > 0:
		on_walk()
	else:
		on_idle()	
	if Input.is_action_just_pressed("attack") && stats.reload_timer.value <= 0:
		attack()

func knockback():
	if (stats.invincible_frames.value < 1):
		velocity = -velocity.normalized() * 5000
		move_and_slide()
	
			
# Try different approach for animation for  Halina or Aneta (animation tree + animation player setup)
func on_idle():
	walking_audio_player.stop()
	if(stats.reload_timer.value > 0 ):
		animations.play("idle_reload")	
	else:
		animations.play("idle")	

func on_walk():
	sound_manager.play_sound(run_audio, walking_audio_player)
	if(stats.reload_timer.value > 0 ):
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
	stats.reload_timer.assign_max_value()
	reloading = true
	audio_pool.play_sound_effect(weapon.get_reload_audio())

func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)
	elif body.is_in_group("item"):
		on_consume_item(body)
		

func on_consume_item(item: Item):
	sound_manager.play_inerrupt_sound(pickup_audio, effects_audio_player)
	stats.apply_item(item)
	var weapon_modified = weapon.apply_item(item)
	wallet.apply_item(item)
	if (!item.is_coin()):
		item_collection.append(item.get_item_type())
	item.queue_free()
	if (weapon_modified):
		start_reloading()
		
func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

