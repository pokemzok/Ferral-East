extends CharacterBody2D

var pausable = PausableNodeBehaviour.new(self)
var weapon = Revolver.new()
var stats: PlayerStats = SurbiStatsFactory.create()
var wallet: Wallet = Wallet.new()
var consumables_inventory: PlayerInventory = PlayerInventory.new()
var enemies_in_player_collision_area =  []
var is_dead = false
var is_teleporting = false
var reloading = false
var sound_manager = GameSoundManager.get_instance()
var grunts_audio = sound_manager.surbi_grunts
var death_audio = GameSoundManager.Sounds.SURBI_DEATH
var run_audio = GameSoundManager.Sounds.PLAYER_RUN
var pickup_audio = GameSoundManager.Sounds.PLAYER_PICKUP_ITEM
var teleport_audio = GameSoundManager.Sounds.TELEPORT
var warp_audio = GameSoundManager.Sounds.WARP
var items_collection = ArrayCollection.new([])

@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var effects_audio_player = $EffectsAudioStreamPlayer
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $GameAmbientAudioPool
@onready var monolog_bubble = $MonologBubble

func _ready():
	animations.connect("animation_looped", on_animation_finished)
	animations.connect("animation_finished", on_animation_finished)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, on_start_conversation_with)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, on_finish_conversation)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_MONOLOG, monolog_bubble.show_bubble)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ENTERS_SHOP, on_player_enters_shop)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_LEFT_SHOP, on_player_left_shop)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ARRIVED_TO_LEVEL, on_new_level)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_BOUGHT_ITEM, on_picked_item)
	GlobalEventBus.connect(GlobalEventBus.WEAPON_NEEDS_RELOAD, start_reloading)

func on_new_level(level: LevelManager.Levels):
	stats.emit_information()
	GlobalEventBus.player_consumables.emit(consumables_inventory)

func on_animation_finished():
	if animations.animation == "teleporting":
		animations.stop()			
		animations.play("invisible")
		GlobalEventBus.player_teleported.emit()
	elif animations.animation == "phasing":	
		animations.stop()
		on_idle()		
		is_teleporting = false
	
func _physics_process(delta):
	if (!is_dead && !is_teleporting):
		if(enemies_in_player_collision_area.size() > 0):
			on_dmg()
		on_reload(delta)
		
		stats.consumable_cooldown.decrement_if_not_zero_by(delta)
		
		if (stats.dying_timer.value > 0):
			on_dying(delta)
		elif stats.has_status_effect():
			on_status_effect(delta)
		else:
			if (stats.invincible_frames.value > 0):
				stats.invincible_frames.decrement_by()
			on_player_actions(delta)	

func on_status_effect(delta):
	if stats.knockback_timer.value > 0:
		on_knockback(delta)	
	elif stats.stunned_timer.value > 0:
		on_stun(delta)	
	else:
		after_knockback()
		stats.clear_status()

func on_start_conversation_with(npc_name: String):
	pausable.set_pause(true)
	on_idle()

func on_finish_conversation():
	pausable.set_pause(false)

func on_player_enters_shop(shop_level):
	animations.play("teleporting")
	is_teleporting = true	
	audio_pool.play_sound_effect(teleport_audio)

func on_player_left_shop():
	look_at(get_global_mouse_position())	
	animations.play("phasing")	
	audio_pool.play_sound_effect(warp_audio)

func on_dmg():
	if (stats.invincible_frames.value < 1):
		stats.decrement_health()
		if (stats.health_points.value < 1):
			dying()
		else:
			GlobalEventBus.player_damaged.emit()
			if(!stats.has_knockback_status()):
				stun()	

func stun():
	if (stats.stunned_timer.value <= 0):
		stats.apply_stun()
		audio_pool.play_sound_effect(grunts_audio.random_element())

func dying():
	if (stats.dying_timer.value <= 0):
		stats.dying_timer.assign_max_value()
		audio_pool.play_sound_effect(death_audio)

func on_knockback(delta):
	stats.knockback_timer.decrement_by(delta)
	velocity = stats.knockback_velocity * delta
	stats.decrease_knockback(delta)
	play_knockback()	
	move_and_slide()
	common_status_effect_action()

func after_knockback():
	stats.reset_knockback()
	
func on_stun(delta):
	stats.stunned_timer.decrement_by(delta)
	play_stunned()
	common_status_effect_action()
	
func common_status_effect_action():	
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	stats.reload_timer.assign_max_on_more_then_zero()

func on_dying(delta):
	stats.dying_timer.decrement_by(delta)
	animations.play("dying")
	self.z_index = 0
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
	velocity = direction * stats.speed.value
	move_and_slide()	
	if velocity.length() > 0:
		on_walk()
	else:
		on_idle()	
	if Input.is_action_just_pressed("attack") && stats.reload_timer.is_lte_zero():
		attack()
	if (Input.is_action_just_pressed("consume") && stats.consumable_cooldown.is_lte_zero()):
		on_consume()
		stats.consumable_cooldown.assign_max_value()		

func on_consume():
	var item = consumables_inventory.get_quick_access_item()
	if (item != null):
		item.use()

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

func play_knockback():
	animations.play("knockback")

func attack():
	var success = weapon.attack_with(self, get_global_mouse_position())
	audio_pool.play_sound_effect(weapon.get_shoot_audio())
	if(!success):
		start_reloading()

func start_reloading():
	stats.reload_timer.assign_max_value()
	reloading = true
	audio_pool.play_sound_effect(weapon.get_reload_audio())
#TODO Surbi is not detecting enemy hand, therefore couldn't test knockback
func on_hurtbox_entered(body):
	if body.is_in_group("enemy"):
		if not enemies_in_player_collision_area.has(body):
			enemies_in_player_collision_area.append(body)
	elif body.is_in_group("melee"):
		knockback_from(body)
	elif body.is_in_group("item"):
		on_picked_item(body)
	elif body.is_in_group("projectiles"):
		on_dmg() 	

func knockback_from(body):
	var knockback_direction = (global_position - body.global_position).normalized()
	var knockback_force = body.get_knockback_force()
	stats.apply_knockback(knockback_direction * knockback_force)
	audio_pool.play_sound_effect(grunts_audio.random_element())
	on_dmg()	
		
func on_picked_item(item: Item):
	sound_manager.play_inerrupt_sound(pickup_audio, effects_audio_player)	
	if (item.is_consumable()):
		on_consumable_item(item)
	else:
		on_immediate_item(item)
	item.queue_free()

func on_consumable_item(item: Item):
	var item_copy = item.duplicate()
	var status = consumables_inventory.add(item_copy)
	if (status == PlayerInventory.InsertStatus.INCREMENT):
		item_copy.queue_free()

func on_immediate_item(item: Item):
	stats.apply_item(item)
	if (!item.is_coin()):
		items_collection.append(item.get_item_type())
		weapon.apply_item(item)
	else:
		wallet.add(item)
		
func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

