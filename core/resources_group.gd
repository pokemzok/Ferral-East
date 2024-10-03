extends Node

class_name ResourcesGroup

var resources_paths: Array
var loaded_resources: ArrayCollection

func _init(resource_keys: Array, resource_dictionary):
	resources_paths = ResourceFromDictionaryLoader.start_async_resource_load(resource_keys, resource_dictionary)
	loaded_resources = ArrayCollection.new([])

func load_resource_group():
	ResourceFromDictionaryLoader.load_async_resource_into(loaded_resources, resources_paths)

func is_group_loaded() -> bool:
	return resources_paths.size() == loaded_resources.size()

func sort()-> ResourcesGroup:
	var sorted_resources = ArrayCollection.new([])
	for path in resources_paths:
		for resource in loaded_resources.collection:
			if (path == resource.resource_path):
				sorted_resources.append(resource)
	loaded_resources = sorted_resources			
	return self

func get_loaded_resources() -> ArrayCollection:
	return loaded_resources
