class_name PlayableLevel
extends Node

var dead_enemies_container: Node

func place_dead_in_same_container(details: EnemyDeathDetails):
	call_deferred("_move_the_dead", details)

func _move_the_dead(details: EnemyDeathDetails):
	var parent = details.enemy.get_parent()
	var global_transform =  details.enemy.global_transform
	parent.remove_child(details.enemy)
	dead_enemies_container.add_child(details.enemy)
	details.enemy.global_transform = global_transform
