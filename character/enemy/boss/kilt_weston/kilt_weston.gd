extends CharacterBody2D

var player_detection = PlayerDetectionBehaviour.new(self)
var player =  null
var pausable = PausableNodeBehaviour.new(self)
var weapon = Revolver.new()
var secondary_weapon = preload("res://weapon/melee/skeleton_arm/left_skeleton_arm.tscn")
var stats: UndeadShooterStats = KiltStatsFactory.create()
var wallet: Wallet = Wallet.new()
var consumables_inventory: PlayerInventory = PlayerInventory.new()
var enemies_in_player_collision_area =  []
var is_dead = false
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
	var weapon_instance = secondary_weapon.instantiate()
	left_arm = WeaponArm.new(weapon_instance, left_arm_container)
	weapon_instance.add_owner(self)
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
	
func _physics_process(delta):
	if (phasing_counter > 0):
		if (!is_dead && !is_phasing_out()):
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
# 1. znaleźć linię strzału, strzelić i uciec w losowym kierunku, ale tak, by dalej mieć gracza  w linii strzału
# 2. po trafieniu, pauza na nodzie i teleport w inny spawn point.
# 3. gdy mało punktów życia (np. 2-3), teleport blisko gracza i kamikaze bieg?
# 4. jeśli gracz jest pasywny i się skitrał, że nie da się sensownie podejść, przywołać zombie

func attack_player(delta):
	if player != null:
		# TODO multiple movement patterns, which can change depending on  how many  HP Kilt has
		# FIXME he can start from charging and then be more passive and then just try  to find a clear shot	
		var distance_to_player = raycast_calc()
		on_movement(distance_to_player)
		look_at(player.global_position)
		on_attack(delta, distance_to_player)

func on_movement(distance_to_player):
	#if (sideways_position != null && sideways_position != global_position):
	#	move_sideways()
	#	return
	#else:
	#	sideways_position = null	
	if(stats.health_points.max_value/stats.health_points.value >= 2  || distance_to_player > 800):
		charge()
	else:
		on_idle() 
		#move_sideways()

#FIXME character get stuck when trying to  move	
func move_sideways():
	if (sideways_position == null || sideways_position == global_position):
		sideways_position = pick_reachable_position()
	move_to(sideways_position)	

func pick_reachable_position() -> Vector2:
	var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50)) # Pick a random nearby point
	var new_position = global_position + random_offset
	var prev_position = navigation_agent.target_position
	navigation_agent.target_position = new_position
	# Check if the new position is reachable
	while not navigation_agent.is_target_reachable():
		random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50)) # Pick another random offset
		navigation_agent.target_position = global_position + random_offset
	navigation_agent.target_position = prev_position
	return new_position
			
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
	walking_audio_player.stop()
	stats.reload_timer.assign_max_on_more_then_zero()

func on_dying(delta):
	stats.dying_timer.decrement_by(delta)
	animations.play("dying")
	if (stats.dying_timer.value <= 0):
		die()

func die():
	is_dead = true
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

# FIXME should not fuse with Surbi
# FIXME I should have more behaviours so I can share code more effectivly between Surbi, Kilt and Zombies
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
		on_phasing_out()	
		#FIXME if player can attack successfully 8 times, without taking dmg, enemy is stunned
		#FIXME I can verify it by receiving events here from the player
		#stun()				

func take_dmg(dmg: float):
	audio_pool.play_sound_effect(bullet_hit_audio)	
	stats.health_points.decrement_by(dmg)
	if stats.health_points.value <= 0:
		dying()
