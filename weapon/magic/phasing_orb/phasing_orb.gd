extends Node2D

var arm_owner: Node2D
@onready var effect =  $PhasingOrbEffect

func add_owner(arm_owner: Node2D):
	self.arm_owner = arm_owner

#FIXME more effects, one on this item pickup (MAGICAL_INTERACTION event)
func attack():
	var position = get_global_mouse_position()
	arm_owner.on_phasing_out(position)
	effect.global_position = position
	effect.one_shot_emitting()
	
