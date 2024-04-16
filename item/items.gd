extends Node
class_name Items

enum ItemName {
	PENTAGRAM
}

var res_dictionary  = {
	ItemName.PENTAGRAM: "res://item/pentagram/pentagram.tscn"
}

static var instance = null

static func get_instance() -> Items:
	if instance == null:
		instance = Items.new()
		instance.name = "Items"
		instance.add_to_group("singleton")
	return instance	
