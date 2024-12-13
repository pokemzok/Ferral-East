extends CharacterBody2D

var pausable = PausableNodeBehaviour.new(self)
var tween_behaviour = CustomTweenBehaviour.new(self)
var weapon = Revolver.new()
var stats: PlayerStats = SurbiStatsFactory.create()
var wallet: Wallet = Wallet.new()
var consumables_inventory: PlayerInventory = PlayerInventory.new()
var enemies_in_player_collision_area =  []
var sound_manager = GameSoundManager.get_instance()
var grunts_audio = sound_manager.surbi_grunts
var death_audio = GameSoundManager.Sounds.SURBI_DEATH
var run_audio = GameSoundManager.Sounds.RUN
var pickup_audio = GameSoundManager.Sounds.PICKUP_ITEM
var evil_pickup_audio = GameSoundManager.Sounds.PICKUP_EVIL_ITEM
var teleport_audio = GameSoundManager.Sounds.TELEPORT
var warp_audio = GameSoundManager.Sounds.WARP
var items_collection = ArrayCollection.new([])
var phasing_out_position
var left_arm: WeaponArm
var reloading = false
var evil_tween: Tween

@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var effects_audio_player = $EffectsAudioStreamPlayer
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $GameAmbientAudioPool
@onready var monolog_bubble = $MonologBubble
@onready var left_arm_container = $LeftArmContainer

func _ready():
	self.z_index = 1
	animations.connect("animation_looped", on_animation_finished)
	animations.connect("animation_finished", on_animation_finished)
	
	GlobalEventBus.connect(GlobalEventBus.START_INTERACTION_WITH, on_start_interaction_with)
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, on_finish_interaction)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_MONOLOG, monolog_bubble.show_bubble)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ENTERS_SHOP, on_player_enters_shop)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_LEFT_SHOP, on_player_left_shop)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ARRIVED_TO_LEVEL, on_new_level)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_BOUGHT_ITEM, on_picked_item)
	GlobalEventBus.connect(GlobalEventBus.WEAPON_NEEDS_RELOAD, start_reloading)
	GlobalEventBus.connect(GlobalEventBus.PAINFUL_INTERACTION, on_painful_interaction)

func on_new_level(level: LevelManager.Levels):
	stats.emit_information()
	wallet.emit_coins_nr()
	GlobalEventBus.player_consumables.emit(consumables_inventory)

func on_animation_finished():
	animations.stop()
	if animations.animation == "teleporting":
		animations.play("invisible")
		GlobalEventBus.player_teleported.emit()
	elif animations.animation == "phasing" || animations.animation == "phasing_out":	
		if(animations.animation == "phasing_out"):
			after_phasing_out()
		stats.remove_state(CharacterState.State.TELEPORTING)	
		on_idle()		
	
func _physics_process(delta):
	
	if (!stats.is_dead() && !stats.is_teleporting()):
		if(enemies_in_player_collision_area.size() > 0):
			on_dmg()
		
		stats.consumable_cooldown.decrement_if_not_zero_by(delta)
		stats.secondary_attack_cooldown.decrement_if_not_zero_by(delta)
		stats.invincible_frames.decrement_if_not_zero_by()
		
		match(stats.state):
			CharacterState.State.DYING:
				on_dying(delta)
			CharacterState.State.STAGGERED:
				on_staggered(delta)
			CharacterState.State.STUNNED:
				on_stun(delta)	
			CharacterState.State.KNOCKBACK:
				on_knockback(delta)
			CharacterState.State.NORMAL:
				on_reload(delta)				
				on_player_actions(delta)

func on_staggered(delta):
	play_staggered()
	retry_reload_if_needed()	
	stats.invincible_frames.assign_max_on_less_or_zero()
	stats.staggered_timer.decrement_by(delta)
	
	velocity = stats.stagger_velocity * delta
	stats.decrease_stagger(delta)
	move_and_slide()
	
	if(stats.staggered_timer.is_lte_zero()):
		stats.reset_stagger()

func on_start_interaction_with(npc_name: String):
	pausable.set_pause(true)
	on_idle()

func on_finish_interaction():
	pausable.set_pause(false)

func on_player_enters_shop(shop_level):
	animations.play("teleporting")
	stats.assign_state(CharacterState.State.TELEPORTING)
	audio_pool.play_sound_effect(teleport_audio)

func on_player_left_shop():
	look_at(get_global_mouse_position())	
	animations.play("phasing")	
	audio_pool.play_sound_effect(warp_audio)

func on_dmg():
	if (stats.invincible_frames.value < 1):
		stats.decrement_health()
		if (stats.health_points.value < 1):
			self.z_index = 0	
			dying()
		else:
			GlobalEventBus.player_damaged.emit()
			if(!stats.has_knockback()):
				stun()	

func stun():
	if (!stats.is_stunned()):
		stats.apply_stun()
		audio_pool.play_sound_effect(grunts_audio.random_element())

func dying():
	if (!stats.is_dying()):
		stats.dying()
		audio_pool.play_sound_effect(death_audio)

func on_knockback(delta):
	stats.knockback_timer.decrement_by(delta)
	velocity = stats.knockback_velocity * delta
	stats.decrease_knockback(delta)
	play_knockback()	
	move_and_slide()
	common_irregular_state_action()
	if(stats.knockback_timer.is_lte_zero()):
		stats.reset_knockback()
	
func on_stun(delta):
	play_stunned()	
	common_irregular_state_action()
	stats.decrease_stun(delta)
	
func common_irregular_state_action():	
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	retry_reload_if_needed()

func retry_reload_if_needed():
	if(stats.reload_timer.is_gt_zero()):
		start_reloading()

func on_dying(delta):
	animations.play("dying")
	stats.dying_timer.decrement_by(delta)
	if (stats.dying_timer.value <= 0):
		die()

func die():
	stats.dead()
	animations.play("death")	
	GlobalEventBus.player_death.emit()

func on_reload(delta):
	if(reloading):
		var is_completed = stats.complete_reloading(delta)
		if(is_completed):
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
	elif Input.is_action_just_pressed("secondary_attack") && stats.secondary_attack_cooldown.is_lte_zero():
		secondary_attack() 	
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

func play_staggered():
	animations.play("walk_reload")
	
func attack():
	if(!reloading):
		var success = weapon.attack_with(self, get_global_mouse_position())
		audio_pool.play_sound_effect(weapon.get_shoot_audio())
		if(!success):
			start_reloading()

func secondary_attack():
	if (left_arm != null):
		left_arm.attack()
		stats.secondary_attack_cooldown.assign_max_value()

func start_reloading():
	stats.reloading()
	reloading = true
	sound_manager.play_inerrupt_sound(weapon.get_reload_audio(), effects_audio_player)	
	
func on_hurtbox_entered(body):
	if body.is_in_group("enemy") ||  body.is_in_group("boss"):
		on_enemy_character_colision(body)
	elif body.is_in_group("melee") && (left_arm == null || body != left_arm.weapon):
		if(body.get_knockback_force() > 0):
			knockback_from(body)
		on_dmg()	
	elif body.is_in_group("item"):
		on_picked_item(body)
	elif body.is_in_group("projectiles"):
		on_dmg()

func on_enemy_character_colision(body):
	if(body.stats.has_knockback()):
		knockback_from(body)
	elif (body.is_in_group("boss")):
		staggered_by(body)
	elif not enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.append(body)
			
func staggered_by(body):
	if(!stats.is_dead()):
		var staggered_direction = (global_position - body.global_position).normalized()
		stats.staggered_timer.assign_max_value()
		stats.apply_stagger(staggered_direction)

func knockback_from(body):
	if(!stats.is_dead()):
		var knockback_direction = (global_position - body.global_position).normalized()
		var knockback_force = body.get_knockback_force()
		stats.apply_knockback(knockback_direction * knockback_force)
		stats.assign_character_knockback_force(knockback_force/2)
		audio_pool.play_sound_effect(grunts_audio.random_element())
		
func on_picked_item(item: Item):
	if (item.is_evil()):
		sound_manager.play_inerrupt_sound(evil_pickup_audio, effects_audio_player)
		consumed_evil_effect()
	else:	
		sound_manager.play_inerrupt_sound(pickup_audio, effects_audio_player)	

	match item.type:
		Item.ItemType.CONSUMABLE:
			on_consumable_item(item)
		Item.ItemType.IMMEDIATE:
			on_immediate_item(item)
		Item.ItemType.LEFT_HAND_ITEM:
			on_left_hand_item(item)	
	item.queue_free()

func consumed_evil_effect():
	evil_tween = tween_behaviour.clear_tween(evil_tween)
	tween_behaviour.modulate_to_red_and_out(animations, evil_tween)

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

func on_left_hand_item(item: Item):
	left_arm = WeaponArm.new(item.instantiate(), self, left_arm_container)
	
			
func on_hurtbox_leave(body):
	if enemies_in_player_collision_area.has(body):
		enemies_in_player_collision_area.erase(body)

func get_knockback_force():
	return stats.get_character_knockback_force()

func on_painful_interaction():
	play_stunned()
	audio_pool.play_sound_effect(grunts_audio.random_element())

func on_phasing_out(new_position):
	play_phasing_out()
	stats.assign_state(CharacterState.State.TELEPORTING)
	audio_pool.play_sound_effect(warp_audio)
	phasing_out_position = new_position

func after_phasing_out():
	self.global_position = phasing_out_position
	phasing_out_position = null

func play_phasing_out():
	animations.play("phasing_out")
