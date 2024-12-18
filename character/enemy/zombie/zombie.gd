extends CharacterBody2D

@export var type: Enemy.EnemyType
var stats: EnemyStats
var player_detection = PlayerDetectionBehaviour.new(self)
var player =  null
var motion = Vector2()
var vocal_timer_max_range = NumericAttribute.new(1,6)
var vocal_timer = NumericAttribute.new(1, 3)
var played_dying = false

var sound_manager = GameSoundManager.get_instance()
var voices = sound_manager.zombie_voices
var death_sounds = sound_manager.zombie_death
var run_audio = GameSoundManager.Sounds.RUN
var bullet_hit_audio = GameSoundManager.Sounds.BULLET_HIT_BODY

@onready var voice_audio_player = $VoiceAudioStreamPlayer
@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var audio_pool = $GameAmbientAudioPool
@onready var navigation_agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	stats = ZombieStatsFactory.create(type)
	sprite.connect("animation_looped", on_animation_finished)
	self.z_index = 1
	vocal_timer.randomize_value()
	player = player_detection.get_player()

func _process(delta):
	growl_on(delta)
	
func _physics_process(delta):
	stats.invincible_frames.decrement_if_not_zero_by()
	match(stats.state):
		CharacterState.State.DYING:
			on_dying(delta)
		CharacterState.State.KNOCKBACK:
			on_knockback(delta)	
		CharacterState.State.STUNNED:
			on_stun(delta)
		CharacterState.State.NORMAL:
			if(stats.attack_timer.value > 0):
				on_attack(delta)	
			else:
				hunt_player(delta)		

func on_dying(delta):
	self.z_index = 0
	walking_audio_player.stop()
	if not played_dying:
		sprite.play("dying")
		played_dying = true

	stats.get_dying_timer().decrement_by(delta)
	if stats.get_dying_timer().value < 0:
		die()

func on_knockback(delta):
	stats.knockback_timer.decrement_by(delta)
	velocity = stats.knockback_velocity * delta
	stats.decrease_knockback(delta)
	play_knockback()	
	move_and_slide()
	walking_audio_player.stop()
	stats.invincible_frames.assign_max_value()	
	if(stats.knockback_timer.is_lte_zero()):
		stats.reset_knockback()

func on_animation_finished():
	if sprite.animation == "dying":
		sprite.play("dead")
	elif sprite.animation == "despawn":
		queue_free()
		
func on_stun(delta):
	walking_audio_player.stop()
	sprite.play("stunned")
	stats.decrease_stun(delta)

func on_attack(delta):
	walking_audio_player.stop()
	stats.attack_timer.decrement_by(delta)
	sprite.play("idle")		

func growl_on(delta):
	if stats.get_dying_timer().value > 0:
		return
	if (vocal_timer.value <= 0):
		sound_manager.play_sound(voices.random_element(), voice_audio_player)
		vocal_timer.randomize_max_value_in_range(vocal_timer_max_range.value, vocal_timer_max_range.max_value)
		vocal_timer.assign_max_value()
	else:
		vocal_timer.decrement_by(delta)
			
		
func hunt_player(delta):
	if player != null:
		on_walk()
		look_at(player.global_position)
		match stats.path_finding_algo:
			PathFindingStrategy.PathFindingAlgorithm.DUMB_COLLIDE:
				dumb_path_finding_collide(player, delta)
			PathFindingStrategy.PathFindingAlgorithm.NAVIGATION_AGENT:
				nav_agent_pathfinding(player, delta)

func on_walk():
	sprite.play("walk")
	sound_manager.play_sound(run_audio, walking_audio_player)

func nav_agent_pathfinding(_player, delta):
	var direction = Vector2()
	var distance = global_position.distance_to(_player.global_position)
	navigation_agent.target_position = _player.global_position
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	stats.speed.new_value(stats.speed.value + (distance * stats.speed_increase_factor))
	stats.speed.new_value(min(stats.speed.value, stats.speed.max_value))
	velocity = velocity.lerp(direction * stats.speed.value, 7 *  delta)
	var collision = move_and_collide(velocity*delta)
	if(collision):
		on_collision(collision)

func on_collision(collision):
	var collider = collision.get_collider()
	if(collider.is_in_group("enemy")):
		var repulsion_vector = global_position - collider.global_position
		var avoidance_strength = 100.0
		velocity += repulsion_vector.normalized() * avoidance_strength

func dumb_path_finding_collide(_player, delta):
	global_position += dumb_path_finding(_player, delta)
	move_and_collide(motion)

func dumb_path_finding(_player, delta) -> Vector2:
	var direction = (_player.global_position - global_position).normalized()
	var distance = global_position.distance_to(_player.global_position)
	stats.speed.new_value(stats.speed.value + (distance * stats.speed_increase_factor))
	stats.speed.new_value(min(stats.speed.value, stats.speed.max_value))
	return direction * stats.speed.value * delta

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (body.linear_velocity.length() >= stats.projectiles_dmg_velocity):
			body.queue_free()
			stun()		
			take_dmg(body.damage)
	elif body.is_in_group("enemy") || body.is_in_group("boss"):
		on_character_colision(body)
	elif body.is_in_group("melee"):
		take_dmg(body.damage)		
		if(body.get_knockback_force() > 0):
			knockback_from(body)
		else:
			stun()		
	elif body.is_in_group("player"):
		on_character_colision(body)
		attack()						

func on_character_colision(body):
	if(body.stats.has_knockback()):
		knockback_from(body)

func stun():
	if (!stats.is_stunned() && !stats.is_dying()):
		stats.apply_stun()

func attack():
	if (stats.attack_timer.value <= 0):
		stats.attack_timer.assign_max_value()

func knockback_from(body):
	if(!stats.is_dying() && !stats.has_knockback()):
		var knockback_direction = (global_position - body.global_position).normalized()
		var knockback_force = body.get_knockback_force()
		stats.assign_character_knockback_force(knockback_force/2)
		stats.apply_knockback(knockback_direction * knockback_force)

func take_dmg(dmg: float):
	if(stats.invincible_frames.is_lte_zero() && !stats.is_dying()):
		audio_pool.play_sound_effect(bullet_hit_audio)	
		stats.health_points.decrement_till_zero_by(dmg)
		GlobalEventBus.enemy_damaged.emit(stats.type, stats.dmg_score)
		if stats.health_points.value <= 0:
			dying()
	
func dying():
	if (!stats.is_dying()):
		play_death_sound()	
		stats.dying()
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)
		if (!stats.can_reanimate()):
			var death_details = EnemyDeathDetails.new(self)
			GlobalEventBus.enemy_death.emit(death_details)

func play_death_sound():
	voice_audio_player.stop()
	sound_manager.play_sound(death_sounds.random_element(), voice_audio_player)

func die():
	if (stats.can_reanimate()):
		reanimate()
	else:
		stats.dead()
		sprite.play("despawn")
		
func reanimate():
	$CollisionShape2D.set_deferred("disabled",  false)
	$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  false)			
	stats.reanimated()
	self.z_index = 1
	played_dying = false

func play_knockback():
	sprite.play("knockback")

func get_knockback_force():
	return stats.get_character_knockback_force()
