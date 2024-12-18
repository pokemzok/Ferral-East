class_name WeaponArm

var weapon: Node2D
var owner: CharacterBody2D
var root_node: Node2D

func _init(_weapon: Node2D, _owner: CharacterBody2D, _root_node: Node2D):
	self.root_node = _root_node
	self.owner = _owner
	change_weapon(_weapon)
	
func change_weapon(_weapon: Node2D):
	if (self.weapon != null):
		root_node.remove_child(self.weapon)
	
	self.weapon = _weapon
	self.weapon.add_owner(owner)
	root_node.add_child(self.weapon)	
	
func attack():
	self.weapon.attack()
