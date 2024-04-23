extends CharacterBody2D

@onready var animations = $AnimatedSprite2D

func _physics_process(delta):
	on_player_actions(delta)	

func on_player_actions(delta):
	look_at(get_global_mouse_position())	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 100
	move_and_slide()	
	if velocity.length() > 0:
		animations.play("walk")
	else:
		animations.play("idle")	
	
