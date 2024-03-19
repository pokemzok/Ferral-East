class_name Revolver
extends Node

var bullet_speed = NumericAttribute.new(1500, 2500)
var bullets_in_cylinder = NumericAttribute.new(6, 6)
var bullet = preload("res://weapon/projectile/bullet/bullet.tscn")

func attack_with(character: Node2D, target_position: Vector2) -> bool:
	return shoot_with(character, target_position)

func shoot_with(character: Node2D, target_position: Vector2):
	if (bullets_in_cylinder.value  > 0):
		var bullet_instance  = bullet.instantiate()
		var offset = Vector2(40, 33) 
		var character_position = character.global_position
		bullet_instance.position = character_position + offset.rotated(character.rotation)
		bullet_instance.rotation_degrees = character.rotation_degrees
		
		var innacurracy_radious = 200	
		var direction_to_mouse = (target_position - bullet_instance.position).angle()
		var distance_to_mouse = character_position.distance_to(target_position)
		var bullet_direction = character.rotation
		if distance_to_mouse > innacurracy_radious:
			bullet_direction = direction_to_mouse
		
		bullet_instance.rotation = bullet_direction
		bullet_instance.apply_impulse(Vector2(bullet_speed.value,  0).rotated(bullet_direction), Vector2())
		character.get_tree().get_root().call_deferred("add_child", bullet_instance)
		bullets_in_cylinder.decrement_by()
	
	return bullets_in_cylinder.value > 0 

func reload():
	bullets_in_cylinder.assign_max_value()
