extends CharacterBody2D

var motion = Vector2()
var stunned_timer = NumericAttribute.new(0, NumericAttribute.new(0.1, 0.3).randomize_value().value)
var health_points = NumericAttribute.new(2, 6)
var dying_timer = NumericAttribute.new(0, 100)
var player =  null
var speed = NumericAttribute.new(100, 300) 
var vocal_timer_max_range = NumericAttribute.new(1,6)
var vocal_timer = NumericAttribute.new(1, 3)
var speed_increase_factor = 0.5
var projectiles_dmg_velocity = 100
var stategy = preload("res://character/enemy/path_finding/path_finding_strategy.gd")
var path_finding_stategy = stategy.random_strategy()
var voices = ArrayCollection.new([GameSoundManager.Sounds.ZOMBIE_VOICE_1, GameSoundManager.Sounds.ZOMBIE_VOICE_2, GameSoundManager.Sounds.ZOMBIE_VOICE_3])
var death_sounds = ArrayCollection.new([GameSoundManager.Sounds.ZOMBIE_DEATH_1, GameSoundManager.Sounds.ZOMBIE_DEATH_2, GameSoundManager.Sounds.ZOMBIE_DEATH_3, GameSoundManager.Sounds.ZOMBIE_DEATH_4])
var sound_manager = GameSoundManager.get_instance()
@onready var audio_player = $AudioStreamPlayer

func _ready():
	randomize_stats()
	vocal_timer.randomize_value()
	var players = get_tree().get_nodes_in_group("player")
	if !players.is_empty():
		player = players[0] #FIXME future support for coop

func randomize_stats():
	health_points.randomize_value()
	speed.randomize_value()

func _process(delta):
	growl_on(delta)
	
func _physics_process(delta):
	if dying_timer.value > 0:
		play_death()
		dying_timer.decrement_by(delta)
	elif dying_timer.value < 0:
		die()	
	elif stunned_timer.value > 0:		
		stunned_timer.decrement_by(delta)
		play_stunned()
	else:
		hunt_player(delta)
# TODO: make it common, so every enemy  could use similar logic. Maybe some new node?
func growl_on(delta):
	if dying_timer.value > 0:
		return
	if (vocal_timer.value <= 0):
		sound_manager.play_sound(voices.random_element(), audio_player)
		vocal_timer.randomize_max_value_in_range(vocal_timer_max_range.value, vocal_timer_max_range.max_value)
		vocal_timer.assign_max_value()
	else:
		vocal_timer.decrement_by(delta)
			
		
func hunt_player(delta):
	if player != null:
		play_walk()
		look_at(player.position)
		match path_finding_stategy:
			stategy.PathFindingAlgorithm.DUMB_COLLIDE:
				dumb_path_finding_collide(player, delta)
			stategy.PathFindingAlgorithm.DUMB_SLIDE:	
				dumb_path_finding_slide(player, delta)

func dumb_path_finding_collide(player, delta):
	position += dumb_path_finding(player, delta)
	move_and_collide(motion)

func dumb_path_finding_slide(player, delta):
	position += dumb_path_finding(player, delta)
	move_and_slide()

func dumb_path_finding(player, delta) -> Vector2:
	var direction = (player.position - position).normalized()
	var distance = position.distance_to(player.position)
	speed.new_value(speed.value + (distance * speed_increase_factor))
	speed.new_value(min(speed.value, speed.max_value))
	return direction * speed.value * delta

func play_stunned():
	$AnimatedSprite2D.play("stunned")

func play_walk():
	$AnimatedSprite2D.play("walk")

func play_death():
	$AnimatedSprite2D.play("death")

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (body.linear_velocity.length() >= projectiles_dmg_velocity):
			body.queue_free()
			stun()		
			take_dmg()				

func stun():
	if (stunned_timer.value <= 0):
		stunned_timer.assign_max_value()

func take_dmg():
	health_points.decrement_by()
	if health_points.value <= 0:
		dying()
	
func dying():
	if (dying_timer.value <= 0):
		play_death_sound()	
		dying_timer.assign_max_value()
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)

func play_death_sound():
	audio_player.stop()
	sound_manager.play_sound(death_sounds.random_element(), audio_player)

func die():
	queue_free()
