class_name NumericAttribute 
extends Node

var value: float 
var max_value: float

func _init(value: float, max_value: float):
	self.value = value
	self.max_value = max_value

func increment_by(delta: float = 1) -> NumericAttribute:
	if(self.value < self.max_value):
		self.value += delta
		if(self.value > self.max_value):
			self.assign_max_value()
	return self

func decrement_if_not_zero_by(delta: float = 1) ->NumericAttribute:
	if(value > 0):
		value -= delta
	return self	
	
func decrement_by(delta: float = 1) -> NumericAttribute:
	self.value -= delta	
	return self	

func assign_max_value() -> NumericAttribute:
	self.value = self.max_value
	return self

func assign_half_of_max_value() -> NumericAttribute:
	self.value = self.max_value / 2 
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

func randomize_max_value_in_range(min_value: float, max_value: float):
	return randf_range(min_value, max_value)

func is_max_value():
	return value == max_value

func decrement_max_value(delta: float = 1):
	self.max_value -= delta

func increment_max_value(delta: float = 1):
	self.max_value += delta

func change_by(delta):
	self.value += delta

func is_lte_zero() -> bool:
	return self.value <= 0

func is_gt_zero() -> bool:
	return !is_lte_zero()
