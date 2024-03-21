class_name ArrayCollection
extends Node

var collection: Array

func _init(collection: Array):
	self.collection = collection

func random_element():
	var index = randi() % collection.size()
	return collection[index]
