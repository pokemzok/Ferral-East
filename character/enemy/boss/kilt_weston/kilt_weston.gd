extends CharacterBody2D

@export var difficulty_level = BossesMetadata.BossDifficulty.LEVEL_3
var phase = BossesMetadata.BossPhase.PHASE_1
var player_detection = PlayerDetectionBehaviour.new(self)
var state = CharacterState.State.NORMAL
var player =  null
var pausable = PausableNodeBehaviour.new(self)
var weapon = Revolver.new()
var secondary_weapon = preload("res://weapon/melee/skeleton_arm/left_skeleton_arm.tscn")
var stats: UndeadShooterStats = KiltStatsFactory.create()
var wallet: Wallet = Wallet.new()
var consumables_inventory: PlayerInventory = PlayerInventory.new()
var enemies_in_player_collision_area =  []
var reloading = false
var sound_manager = GameSoundManager.get_instance()
var grunts_audio = sound_manager.surbi_grunts
var death_audio = GameSoundManager.Sounds.SURBI_DEATH
var run_audio = GameSoundManager.Sounds.PLAYER_RUN
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
# We might fight this boss 3 times, first time he is just shooting, second he is using items (like his version of bullet time for exampe), third he  is regenerating unless Surbi stops him with some Holy item (Kilton is half skeleton)
# I can make only half of his face visible, since the other half might be a skeleton
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
		clear_teleporting_state()
	elif animations.animation == "phasing_out":
		after_phasing_out()	
	
func _physics_process(delta):
	if (phasing_counter > 0):
		if (state == CharacterState.State.NORMAL && !is_phasing_out()):
			on_reload(delta)
			stats.secondary_attack_cooldown.decrement_if_not_zero_by(delta)	
			stats.consumable_cooldown.decrement_if_not_zero_by(delta)
			
			if (stats.dying_timer.value > 0):
				on_dying(delta)
			elif stats.stunned_timer.value > 0:
				on_stun(delta)	
			else:
				attack_player(delta)
	if (stats.invincible_frames.value > 0):
		stats.invincible_frames.decrement_by()

# FIXME AI pomysły
# 2. po trafieniu, pauza na nodzie i teleport w inny spawn point.
# 4. jeśli gracz jest pasywny i się skitrał, że nie da się sensownie podejść, zacząć dropić heale i się leczyć. Mogę to sprawdzać, przy pomocy raycasta (jak długo minęło od ostatniego momentu, gdy widział gracza.

# FIXME Muszę jakoś ogarnąć kod, żeby dobrze współdzielić go między postaciami (na razie mam dużo kopiuj wklej, więc po tym ficzerze przyda się refactor). 
# FIXME should not fuse with Surbi, I need some way for them to bounce back
# FIXME different voices on hit, so the player won't confuse them
func attack_player(delta):
	if player != null:
		var distance_to_player = raycast_calc()
		determine_boss_phase()
		on_movement(distance_to_player)
		look_at(player.global_position)
		on_attack(delta, distance_to_player)

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
			else:
				secondary_attack(delta)

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
	if (difficulty_level == BossesMetadata.BossDifficulty.LEVEL_3):
		teleport()

func teleport():
	state = CharacterState.State.TELEPORTING
	# FIXME actual teleporting logic
	pass

func clear_teleporting_state():
	if (state == CharacterState.State.TELEPORTING):
		state = CharacterState.State.NORMAL

func on_start_conversation_with(npc_name: String):
	pausable.set_pause(true)
	on_idle()

func on_finish_conversation():
	pausable.set_pause(false)

func stun():
	if (stats.stunned_timer.value <= 0):
		stats.stunned_timer.assign_max_value()
		audio_pool.play_sound_effect(grunts_audio.random_element())

func dying():
	if (stats.dying_timer.value <= 0):
		self.z_index = 0
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)
		stats.dying_timer.assign_max_value()
		audio_pool.play_sound_effect(death_audio)
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
	stats.stunned_timer.decrement_by(delta)
	play_stunned()	
	stats.invincible_frames.assign_max_value()	
	walking_audio_player.stop()
	stats.reload_timer.assign_max_on_more_then_zero()

func on_dying(delta):
	stats.dying_timer.decrement_by(delta)
	animations.play("dying")
	if (stats.dying_timer.value <= 0):
		die()

func die():
	state = CharacterState.State.DEAD
	animations.play("dying_phasing_out")	
	
func on_reload(delta):
	if(stats.reload_timer.value > 0 ):
		stats.reload_timer.decrement_by(delta)
	elif(stats.reload_timer.value <= 0 && reloading):
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
	stats.reload_timer.assign_max_value()
	reloading = true
	audio_pool.play_sound_effect(weapon.get_reload_audio())

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (body.linear_velocity.length() >= stats.projectiles_dmg_velocity):
			dmg_processing(body)
			body.queue_free()
	elif body.is_in_group("melee"):
		# FIXME knockback logic if melee weapon have one
		dmg_processing(body)					

func dmg_processing(body):
	if(stats.invincible_frames.value  <= 0):
		take_dmg(body.damage)
		if (phase != BossesMetadata.BossPhase.PHASE_3):
			stun()
		else:	
			on_phasing_out()	

func take_dmg(dmg: float):
	audio_pool.play_sound_effect(bullet_hit_audio)	
	stats.health_points.decrement_by(dmg)
	if stats.health_points.value <= 0:
		dying()
