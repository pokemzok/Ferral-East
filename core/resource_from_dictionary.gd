class_name ResourceFromDictionaryLoader

static func start_async_resource_load(resource_keys: Array, resource_dictionary) -> Array: 
	var loading_resources = []
	for resource_key in resource_keys:
		if  (resource_dictionary.has(resource_key)):
			var resource_path = resource_dictionary[resource_key]
			ResourceLoader.load_threaded_request(resource_path)
			loading_resources.append(resource_path)
	return loading_resources

static func load_async_resource_into(resource_collection: ArrayCollection, loading_resources: Array):
	for loading_resource in loading_resources:
		if (ResourceLoader.load_threaded_get_status(loading_resource) == ResourceLoader.THREAD_LOAD_LOADED):
			var loaded_resource = ResourceLoader.load_threaded_get(loading_resource)
			resource_collection.append(loaded_resource)
