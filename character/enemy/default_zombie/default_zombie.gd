extends CharacterBody2D

var player =  null
var motion = Vector2()
var vocal_timer_max_range = NumericAttribute.new(1,6)
var vocal_timer = NumericAttribute.new(1, 3)
var dying_timer = NumericAttribute.new(0, 100)

var stats: EnemyStats = ZombieStatsFactory.create()

var stategy = preload("res://character/enemy/path_finding/path_finding_strategy.gd")
var path_finding_stategy = stategy.random_strategy()

var sound_manager = GameSoundManager.get_instance()
var voices = sound_manager.zombie_voices
var death_sounds = sound_manager.zombie_death
var run_audio = GameSoundManager.Sounds.PLAYER_RUN
var bullet_hit_audio = GameSoundManager.Sounds.BULLET_HIT_BODY

@onready var voice_audio_player = $VoiceAudioStreamPlayer
@onready var walking_audio_player = $WalkingAudioStreamPlayer
@onready var audio_pool = $GameAmbientAudioPool

func _ready():
	self.z_index = 1
	vocal_timer.randomize_value()
	var players = get_tree().get_nodes_in_group("player")
	if !players.is_empty():
		player = players[0] #FIXME future support for coop

func _process(delta):
	growl_on(delta)
	
func _physics_process(delta):
	if dying_timer.value > 0:
		on_dying(delta)
	elif dying_timer.value < 0:
		die()	
	elif stats.stunned_timer.value > 0:		
		on_stun(delta)
	else:
		hunt_player(delta)

func on_dying(delta):
	self.z_index = 0
	walking_audio_player.stop()
	$AnimatedSprite2D.play("death")
	dying_timer.decrement_by(delta)
		
func on_stun(delta):
	walking_audio_player.stop()
	stats.stunned_timer.decrement_by(delta)
	$AnimatedSprite2D.play("stunned")
			
# TODO: make it common, so every enemy  could use similar logic. Maybe some new node?
func growl_on(delta):
	if dying_timer.value > 0:
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
		look_at(player.position)
		match path_finding_stategy:
			stategy.PathFindingAlgorithm.DUMB_COLLIDE:
				dumb_path_finding_collide(player, delta)
			stategy.PathFindingAlgorithm.DUMB_SLIDE:	
				dumb_path_finding_slide(player, delta)

func on_walk():
	$AnimatedSprite2D.play("walk")
	sound_manager.play_sound(run_audio, walking_audio_player)

func dumb_path_finding_collide(player, delta):
	global_position += dumb_path_finding(player, delta)
	move_and_collide(motion)

func dumb_path_finding_slide(player, delta):
	global_position += dumb_path_finding(player, delta)
	move_and_slide()

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
			take_dmg()				

func stun():
	if (stats.stunned_timer.value <= 0):
		stats.stunned_timer.assign_max_value()

func take_dmg():
	audio_pool.play_sound_effect(bullet_hit_audio)	
	stats.health_points.decrement_by()
	GlobalEventBus.enemy_damaged.emit(stats.type)
	if stats.health_points.value <= 0:
		dying()
	
func dying():
	if (dying_timer.value <= 0):
		GlobalEventBus.enemy_death.emit(stats.type)
		play_death_sound()	
		dying_timer.assign_max_value()
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)

func play_death_sound():
	voice_audio_player.stop()
	sound_manager.play_sound(death_sounds.random_element(), voice_audio_player)

func die():
	queue_free()
