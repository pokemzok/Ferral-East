extends Node2D

var arm_owner: Node2D

func add_owner(arm_owner: Node2D):
	self.arm_owner = arm_owner

#FIXME for pads I would need different handling, like move arrow or somethin
#FIXME more effects, one on this item pickup (MAGICAL_INTERACTION event), second during the teleportation
func attack():
	arm_owner.on_phasing_out(get_global_mouse_position())
	
