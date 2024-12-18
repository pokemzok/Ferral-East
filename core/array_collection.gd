class_name ArrayCollection
extends Node

var collection: Array

func _init(_collection: Array):
	randomize()	
	self.collection = _collection

func append(element):
	self.collection.append(element)

func size() -> int:
	return self.collection.size()
	
func random_element():
	var index = random_index()
	return collection[index]

func random_elements(nr: int) -> Array:
	var result = []
	var indices = Array(range(collection.size()))
	indices.shuffle()
	for i in range(nr):
		result.append(collection[indices[i]])
	return result

func random_index():
	return randi() % collection.size()	

func get_element_by_index(index: int):
	if(index < self.size()):
		return collection[index]
