extends CharacterBody2D

var motion = Vector2()
var stunned_timer = 0 # TODO we can make a stun  also random to make thing more interesting=
var health_points = 4 #TODO we cane make it random (within the specific range) to make things more interesting
var dying_timer = 0
var player =  null
var min_speed = 100
var speed_increase_factor = 0.5
var max_speed = min_speed * 3

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if !players.is_empty():
		player = players[0] #FIXME future support for coop

func _physics_process(delta):
	if dying_timer > 0:
		play_death()
		dying_timer -= delta
	elif dying_timer < 0:
		die()	
	elif stunned_timer > 0:		
		stunned_timer -= delta
		play_stunned()
	else:
		hunt_player(delta)
		
func hunt_player(delta):
	if player != null:
		var direction = (player.position - position).normalized()
		var distance = position.distance_to(player.position)
		var speed = min_speed + (distance * speed_increase_factor)
		speed = min(speed, max_speed)
		var velocity = direction * speed * delta
		position += velocity
		play_walk()
		look_at(player.position)
		move_and_collide(motion)

func play_stunned():
	$AnimatedSprite2D.play("stunned")

func play_walk():
	$AnimatedSprite2D.play("walk")

func play_death():
	$AnimatedSprite2D.play("death")

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		body.queue_free()
		stun()		
		take_dmg()

func stun():
	if (stunned_timer <= 0):
		stunned_timer =  0.3

func take_dmg():
	health_points -= 1
	print(health_points)
	if health_points <= 0:
		dying()
	
func dying():
	if (dying_timer <= 0):
		dying_timer = 100
		$CollisionShape2D.set_deferred("disabled",  true)
		$HurtboxArea2D/CollisionShape2D.set_deferred("disabled",  true)

func die():
	queue_free()
