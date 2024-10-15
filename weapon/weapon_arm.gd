class_name WeaponArm

var weapon: Node2D
var root_node: Node2D

func _init(weapon: Node2D, root_node: Node2D):
	self.root_node = root_node
	change_weapon(weapon)
	
func change_weapon(weapon: Node2D):
	if (self.weapon != null):
		root_node.remove_child(self.weapon)
	
	self.weapon = weapon
	root_node.add_child(self.weapon)	
	
func attack():
	self.weapon.attack()
