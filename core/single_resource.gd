extends Node

class_name SingleResource

var resources_group: ResourcesGroup

func _init(resource_key, resource_dictionary):
	resources_group = ResourcesGroup.new([resource_key], resource_dictionary)

func load_resource():
	resources_group.load_resource_group()

func is_loaded() -> bool:
	return resources_group.is_group_loaded()
	
func get_loaded_resource():
	return resources_group.get_loaded_resources().get_element_by_index(0)	
