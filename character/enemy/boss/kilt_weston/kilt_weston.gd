extends CharacterBody2D

@export var difficulty_level = BossesMetadata.BossDifficulty.LEVEL_3
var phase = BossesMetadata.BossPhase.PHASE_1

var player_detection = PlayerDetectionBehaviour.new(self)
var taken_hits_for_stun = 0
var player =  null
var pausable = PausableNodeBehaviour.new(self)
var weapon = Revolver.new()
var secondary_weapon = preload("res://weapon/melee/skeleton_arm/left_skeleton_arm.tscn")
var stats: UndeadShooterStats = KiltStatsFactory.create()
var wallet: Wallet = Wallet.new()
var consumables_inventory: PlayerInventory = PlayerInventory.new()
var enemies_in_player_collision_area =  []
var reloading = false
var retry_reload_counter = 0
var sound_manager = GameSoundManager.get_instance()
var grunt_audio_res = preload("res://audio/enemies/kilt/kilt-grunt.wav")
var death_audio_res = preload("res://audio/enemies/kilt/kilt-death.wav")
var run_audio = GameSoundManager.Sounds.RUN 
var bullet_hit_audio = GameSoundManager.Sounds.BULLET_HIT_BODY
var items_collection = ArrayCollection.new([])
var phasing_counter = 0
var left_arm: WeaponArm
var sideways_position
@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var effects_audio_player = $EffectsAudioStreamPlayer
@onready var animations = $AnimatedSprite2D
@onready var audio_pool = $GameAmbientAudioPool
@onready var raycast: RayCast2D = $RayCast2D
@onready var navigation_agent = $NavigationAgent2D
@onready var preview_navigation_agent = $PreviewNavigationAgent2D
@onready var left_arm_container = $LeftArmContainer

# TODO
# If player is too passive Kilt should attempt healing via pentagram
# jeśli gracz jest pasywny i się skitrał, że nie da się sensownie podejść, zacząć dropić heale i się leczyć. Mogę to sprawdzać, przy pomocy raycasta (jak długo minęło od ostatniego momentu, gdy widział gracza.

# I can make only half of his face visible in graphics, since the other half might be a skeleton
# TODO: events to HUD, so the player can see a boss fight bar?
# TODO: will need a guaranteed drop, legendary drop would be a phasing_orb (item which would allow Surbi to teleport short distance). 
func _ready():
	self.z_index = 1
	animations.connect("animation_looped", on_animation_finished)
	animations.connect("animation_finished", on_animation_finished)
	left_arm = WeaponArm.new(secondary_weapon.instantiate(), self, left_arm_container)
	player = player_detection.get_player()
	# FIXME adapt so villain can have a conversation with a Surbi
	#GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, on_start_conversation_with)
	#GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, on_finish_conversation)
	on_phasing_in()
	
func on_animation_finished():
	animations.stop()
	if animations.animation == "dying_phasing_out":
		queue_free()
	if  animations.animation == "phasing_in":
		phasing_counter = phasing_counter + 1
	elif animations.animation == "phasing_out":
		after_phasing_out()	
	
func _physics_process(delta):
	stats.secondary_attack_cooldown.decrement_if_not_zero_by(delta)	
	stats.consumable_cooldown.decrement_if_not_zero_by(delta)	
	stats.invincible_frames.decrement_if_not_zero_by()
	if (phasing_counter > 0 && !is_phasing_out()):

		match(stats.state):
			CharacterState.State.DYING:
				on_dying(delta)
			CharacterState.State.KNOCKBACK:
				on_knockback(delta)	
			CharacterState.State.STUNNED:
				on_stun(delta)
			CharacterState.State.STAGGERED:		
				on_staggered(delta)
			CharacterState.State.NORMAL:
				on_reload(delta)
				attack_player(delta)

func attack_player(delta):
	if player != null:
		var distance_to_player = raycast_calc()
		determine_boss_phase()
		on_movement(distance_to_player)
		look_at(player.global_position)
		on_attack(delta, distance_to_player)

func on_knockback(delta):
	stats.knockback_timer.decrement_by(delta)
	velocity = stats.knockback_velocity * delta
	stats.decrease_knockback(delta)
	play_knockback()	
	move_and_slide()
	common_irregular_state_action()
	if(stats.knockback_timer.is_lte_zero()):
		stats.reset_knockback()

func common_irregular_state_action():	
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	retry_reload_if_needed()
	
func on_movement(distance_to_player):
	match difficulty_level:
		BossesMetadata.BossDifficulty.LEVEL_1:
			level_1_movement()
		BossesMetadata.BossDifficulty.LEVEL_2:
			level_2_movement(distance_to_player)
		BossesMetadata.BossDifficulty.LEVEL_3:
			level_3_movement(distance_to_player)	

func level_3_movement(distance_to_player):
	if(phase == BossesMetadata.BossPhase.PHASE_2 || distance_to_player > 800):
		move_sideways()
	else:
		charge()

func level_2_movement(distance_to_player):
	if(phase != BossesMetadata.BossPhase.PHASE_1):
		move_sideways()
	else:
		charge()

func level_1_movement():
	charge()

func determine_boss_phase():
	var result = stats.health_points.max_value/stats.health_points.value
	if(result >= 3):
		phase = BossesMetadata.BossPhase.PHASE_3	
	elif(result >= 2):
		phase = BossesMetadata.BossPhase.PHASE_2	
	else:
		phase = BossesMetadata.BossPhase.PHASE_1	

func move_sideways():
	if (sideways_position == null || (global_position - sideways_position).length() < 50):
		sideways_position = pick_reachable_position()

	move_to(sideways_position)
	
func pick_reachable_position() -> Vector2:
# Try to find a valid reachable position in a given range
	for i in range(25):
		# Pick a random direction and distance within the range
		var angle = randf() * TAU  # Random angle in radians (0 to 2*PI)
		var distance = random_distance()
		# Calculate the random target position using polar coordinates
		var random_position = global_position + Vector2(cos(angle), sin(angle)) * distance
 		# Use the navigation agent's get_simple_path to check for reachability
		preview_navigation_agent.target_position = random_position
		# If the path is valid and has more than one point, use it
		if preview_navigation_agent.is_target_reachable():
			return random_position
		
	return player.global_position()	

func random_distance() -> float:
	if randi() % 2 == 0:
		return randf_range(200, 300)
	else:
		return randf_range(-200, -300) 
			
func on_attack(delta, distance_to_player):
	if (raycast_check()):
			if(distance_to_player > 200 || stats.secondary_attack_cooldown.value > 0):
				attack(delta)
				pass
			else:
				secondary_attack(delta)
				pass

func charge():
	move_to(player.global_position)

func move_to(position):
	navigation_agent.target_position = position
	var direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * stats.speed.value
	if(velocity.length() > 0):
		on_walk()
		move_and_slide()
	else:
		on_idle()	

func raycast_calc():
	var player_direction = global_position - player.global_position 
	var ray_length = player_direction.length()
	raycast.target_position = Vector2(ray_length, 0)
	raycast.force_raycast_update()
	return ray_length

func raycast_check():
	if (raycast.is_colliding()):
		var collider = raycast.get_collider()
		return collider.get_parent() == player
	return false	

func after_phasing_out():
	if (difficulty_level == BossesMetadata.BossDifficulty.LEVEL_3 && phase == BossesMetadata.BossPhase.PHASE_3):
		teleport()
		clear_teleporting_state()

func teleport():
	stats.assign_state(CharacterState.State.TELEPORTING)
	var distance_to_player = global_position - player.global_position
	var distance_length = distance_to_player.length()
	if distance_length > 125:
		preview_navigation_agent.target_position = global_position - (distance_to_player * 0.5)
	else:
		preview_navigation_agent.target_position = global_position + (distance_to_player * 0.5)				

	if preview_navigation_agent.is_target_reachable():
		global_position = preview_navigation_agent.target_position

func clear_teleporting_state():
	stats.remove_state(CharacterState.State.TELEPORTING)

func on_start_conversation_with(npc_name: String):
	pausable.set_pause(true)
	on_idle()

func on_finish_conversation():
	pausable.set_pause(false)

func stun():
	if (!stats.is_stunned()):
		stats.apply_stun()
		sound_manager.play_interrupt_sound_resource(grunt_audio_res, effects_audio_player)	

func dying():
	if (!stats.is_dying()):
		stats.dying()
		self.z_index = 0
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)
		sound_manager.play_interrupt_sound_resource(death_audio_res, effects_audio_player)	
		var death_details = EnemyDeathDetails.new(stats.type, stats.death_score, global_position)
		GlobalEventBus.enemy_death.emit(death_details)

func on_phasing_in():
	animations.play("phasing_in")

func on_phasing_out():
	stats.invincible_frames.assign_max_value()	
	animations.stop()
	animations.play("phasing_out")

func is_phasing_out() -> bool:
	return animations.animation == "phasing_out" && animations.is_playing()
	
func on_stun(delta):
	play_stunned()	
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	retry_reload_if_needed()
	stats.decrease_stun(delta)	

func on_staggered(delta):
	play_staggered()
	stats.invincible_frames.assign_half_of_max_value()
	walking_audio_player.stop()
	retry_reload_if_needed()
	stats.staggered_timer.decrement_by(delta)
	if(stats.staggered_timer.is_lte_zero()):
		stats.remove_state(CharacterState.State.STAGGERED)

func retry_reload_if_needed():
	if(stats.reload_timer.is_gt_zero()):
		retry_reload_counter += 1
		start_reloading()

func on_dying(delta):
	stats.dying_timer.decrement_by(delta)
	animations.play("dying")
	if (stats.dying_timer.value <= 0):
		die()

func die():
	stats.dead()
	animations.play("dying_phasing_out")	
	
func on_reload(delta):
	if(reloading):
		var is_completed = stats.complete_reloading(delta)
		if(retry_reload_counter  > 1):
			stats.force_complete_reloading()
			is_completed  = true
		if(is_completed):
			weapon.reload_with(self)
			reloading = false			

func on_consume():
	var item = consumables_inventory.get_quick_access_item()
	if (item != null):
		item.use()

func on_idle():
	walking_audio_player.stop()
	if(stats.reload_timer.value > 0 ):
		animations.play("idle_reload")	
	else:
		animations.play("idle")	

func on_walk():
	sound_manager.play_sound(run_audio, walking_audio_player)
	if(stats.reload_timer.value > 0 ):
		play_animation_no_restart("walk_reload")
	else:	
		play_animation_no_restart("walk")

func play_animation_no_restart(animation_name: String):
	if (animations.animation != animation_name || !animations.is_playing()):
		animations.play(animation_name)

func play_stunned():
	animations.play("stunned")

func play_staggered():
	animations.play("staggered")

func attack(delta):
	if (stats.attack_cooldown.value <= 0 && weapon.bullets_in_cylinder.value > 0):
		var success = weapon.attack_with(self, player.global_position)
		audio_pool.play_sound_effect(weapon.get_shoot_audio())
		if(!success):
			start_reloading()
		else:
			stats.attack_cooldown.assign_max_value()
	else:
		stats.attack_cooldown.decrement_by(delta)			

func secondary_attack(delta):
	if(stats.secondary_attack_cooldown.value <= 0):
		left_arm.attack()
		stats.secondary_attack_cooldown.assign_max_value()

func start_reloading():
	stats.reloading()
	reloading = true
	sound_manager.play_inerrupt_sound(weapon.get_reload_audio(), effects_audio_player)	

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (body.linear_velocity.length() >= stats.projectiles_dmg_velocity):
			dmg_processing(body)
			stun_processing()
			body.queue_free()
	elif body.is_in_group("melee"):
		if(body.get_knockback_force() > 0):
			knockback_from(body)
		else:
			stun_processing()	
		dmg_processing(body)
	elif body.is_in_group("player") || body.is_in_group("enemy"):
		on_character_collision(body)

func on_character_collision(body):
		if(body.stats.has_knockback()):
			knockback_from(body)
		else:	
			staggered()	

func knockback_from(body):
	if(!stats.is_dead()):
		var knockback_direction = (global_position - body.global_position).normalized()
		var knockback_force = body.get_knockback_force()
		stats.assign_character_knockback_force(knockback_force/2)
		stats.apply_knockback(knockback_direction * knockback_force)		
		sound_manager.play_interrupt_sound_resource(grunt_audio_res, effects_audio_player)	

func staggered():
	if(!stats.has_knockback() && !stats.is_staggered()):
		stats.staggered_timer.assign_max_value()
		stats.assign_state(CharacterState.State.STAGGERED)

func dmg_processing(body):
	if(stats.invincible_frames.value  <= 0):
		take_dmg(body.damage)
		
func stun_processing():	
	if(stats.invincible_frames.value  <= 0):
		if (phase != BossesMetadata.BossPhase.PHASE_3 || taken_hits_for_stun > 1):
			taken_hits_for_stun = 0
			stun()
		else:	
			taken_hits_for_stun += 1
			on_phasing_out()	

func take_dmg(dmg: float):
	audio_pool.play_sound_effect(bullet_hit_audio)	
	stats.health_points.decrement_by(dmg)
	if stats.health_points.value <= 0:
		dying()

func play_knockback():
	animations.play("knockback")

func get_knockback_force():
	return stats.get_character_knockback_force()
