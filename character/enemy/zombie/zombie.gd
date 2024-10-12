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
var run_audio = GameSoundManager.Sounds.PLAYER_RUN
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
	if stats.get_dying_timer().value > 0:
		on_dying(delta)
	elif stats.get_dying_timer().value < 0:
		die()	
	elif stats.stunned_timer.value > 0:		
		on_stun(delta)
	elif stats.attack_timer.value > 0:
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

func on_animation_finished():
	if sprite.animation == "dying":
		sprite.play("dead")
	elif sprite.animation == "despawn":
		queue_free()
		
func on_stun(delta):
	walking_audio_player.stop()
	stats.stunned_timer.decrement_by(delta)
	sprite.play("stunned")

func on_attack(delta):
	walking_audio_player.stop()
	stats.attack_timer.decrement_by(delta)
	sprite.play("idle")		
# TODO: make it common, so every enemy  could use similar logic. Maybe as a behaviours (composition pattern)?
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

func nav_agent_pathfinding(player, delta):
	var direction = Vector2()
	var distance = global_position.distance_to(player.global_position)
	navigation_agent.target_position = player.global_position
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

func dumb_path_finding_collide(player, delta):
	global_position += dumb_path_finding(player, delta)
	move_and_collide(motion)

func dumb_path_finding(player, delta) -> Vector2:
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	stats.speed.new_value(stats.speed.value + (distance * stats.speed_increase_factor))
	stats.speed.new_value(min(stats.speed.value, stats.speed.max_value))
	return direction * stats.speed.value * delta

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (body.linear_velocity.length() >= stats.projectiles_dmg_velocity):
			body.queue_free()
			stun()		
			take_dmg(body.damage)
	elif body.is_in_group("player"):
		attack()						

func stun():
	if (stats.stunned_timer.value <= 0):
		stats.stunned_timer.assign_max_value()

func attack():
	if (stats.attack_timer.value <= 0):
		stats.attack_timer.assign_max_value()

func take_dmg(dmg: float):
	audio_pool.play_sound_effect(bullet_hit_audio)	
	stats.health_points.decrement_by(dmg)
	GlobalEventBus.enemy_damaged.emit(stats.type, stats.dmg_score)
	if stats.health_points.value <= 0:
		dying()
	
func dying():
	if (stats.get_dying_timer().value <= 0):
		if (!stats.can_reanimate()):
			var death_details = EnemyDeathDetails.new(stats.type, stats.death_score, global_position)
			GlobalEventBus.enemy_death.emit(death_details)
		play_death_sound()	
		stats.get_dying_timer().assign_max_value()
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)

func play_death_sound():
	voice_audio_player.stop()
	sound_manager.play_sound(death_sounds.random_element(), voice_audio_player)

func die():
	if (stats.can_reanimate()):
		reanimate()
	else:
		sprite.play("despawn")
		
func reanimate():
	$CollisionShape2D.set_deferred("disabled",  false)
	$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  false)			
	stats.reanimated()
	self.z_index = 1
	played_dying = false
