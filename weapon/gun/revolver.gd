class_name Revolver
extends Node

var bullet_speed = NumericAttribute.new(1500, 2500)
var max_bullet_capacity = 13
var bullets_in_cylinder = NumericAttribute.new(6, 6)
var bullet = preload("res://weapon/projectile/bullet/bullet.tscn")
var reload_audio = GameSoundManager.Sounds.REVOLVER_RELOAD
var shoot_audio = GameSoundManager.Sounds.REVOLVER_SHOOT

var item_actions = {
	Item.ItemType.BULLET_UPGRADE: "increment_bullets_capacity"
}

func get_reload_audio() -> GameSoundManager.Sounds:
		return reload_audio
		
func get_shoot_audio() -> GameSoundManager.Sounds:
		return shoot_audio

func attack_with(character: Node2D, target_position: Vector2) -> bool:
	return shoot_with(character, target_position)

func shoot_with(character: Node2D, target_position: Vector2):
	if (bullets_in_cylinder.value  > 0):
		var bullet_instance  = bullet.instantiate()
		var offset = Vector2(40, 33) 
		var character_position = character.global_position
		bullet_instance.damage = character.stats.accuracy.value
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
		if (character.is_in_group("player")):
			GlobalEventBus.player_used_projectile_weapon.emit(bullets_in_cylinder.value)		
	
	return bullets_in_cylinder.value > 0 

func reload_with(character: Node2D):
	bullets_in_cylinder.assign_max_value()
	if (character.is_in_group("player")):
		GlobalEventBus.player_used_projectile_weapon.emit(bullets_in_cylinder.value)	

func apply_item(type: Item.ItemType) -> bool:
	if(item_actions.has(type)):
		call(item_actions[type])
		return true
	return false	

func increment_bullets_capacity():
	if(bullets_in_cylinder.max_value < max_bullet_capacity):
		bullets_in_cylinder.increment_max_value()
