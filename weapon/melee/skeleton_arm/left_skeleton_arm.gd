extends Area2D

var knockback_force = 50000
var damage =  1
@onready var animations = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	
	disable_collisions()
	animations.connect("animation_looped", on_animation_finished)
	animations.connect("animation_finished", on_animation_finished)

func attack():
	animations.play("materialize_hand")
	
func finish_punching():
	enable_collisions()
	animations.play("punch")	

func on_animation_finished():
	animations.stop()
	if animations.animation == "materialize_hand":
		finish_punching()
	elif animations.animation == "punch":
		disable_collisions()
		animations.play("default")

func disable_collisions():
	collision_shape.set_deferred("disabled",  true)

func enable_collisions():
	collision_shape.set_deferred("disabled",  false)	

func get_knockback_force():
	return knockback_force

func _on_body_entered(body):
	if (body.is_in_group("player") || body.is_in_group("enemy") || body.is_in_group("character")):
		body.on_hurtbox_entered(self)
