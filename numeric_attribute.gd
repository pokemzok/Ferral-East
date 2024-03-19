class_name NumericAttribute 
extends Node

var value: float 
var max_value: float

func _init(value: float, max_value: float):
	self.value = value
	self.max_value = max_value

func increment_by(delta: float = 1) -> NumericAttribute:
	self.value += delta
	return self
	
func decrement_by(delta: float = 1) -> NumericAttribute:
	self.value -= delta	
	return self	

func assign_max_value() -> NumericAttribute:
	self.value = self.max_value
	return self

func randomize_value() -> NumericAttribute:
	self.value = randf_range(value, max_value)
	return self

func new_value(value:  float) -> NumericAttribute:
	self.value = value
	return self

func assign_zero() -> NumericAttribute:
	self.value  = 0
	return self

func assign_max_on_less_or_zero() -> NumericAttribute:
	if (value <= 0):
		assign_max_value()
	return self

func assign_max_on_more_then_zero() -> NumericAttribute:
	if (value > 0):
		assign_max_value()
	return self		
