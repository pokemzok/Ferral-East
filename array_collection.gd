class_name ArrayCollection
extends Node

var collection: Array

func _init(collection: Array):
	self.collection = collection

func random_element():
	var index = random_index()
	return collection[index]

func random_elements(nr: int) -> Array:
	var result = []
	for i in range(nr):
		result.append(collection[random_index()])
	return result

func random_index():
	randomize()
	return randi() % collection.size()	
