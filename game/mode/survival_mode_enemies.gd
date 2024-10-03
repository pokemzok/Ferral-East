class_name SurvivalModeEnemies
extends Node

var enemies_for_waves: ArrayCollection
var num_enemies: int
var base_probabilities: Array = []
var base_total_weight = 0.0

func _init(enemies: ArrayCollection):
	self.enemies_for_waves = enemies
	num_enemies = enemies_for_waves.size()
	if num_enemies == 0:
		push_error("No enemies to draw from")
	calculate_base_probabilities()	

func calculate_base_probabilities():
	for i in range(num_enemies):
		var weight = pow(0.5, i)  # Exponential falloff (0.5 for every next enemy)
		base_probabilities.append(weight)
		base_total_weight += weight
 	#Normalize probabilities to sum up to 1.0
	for i in range(base_probabilities.size()):
		base_probabilities[i] /= base_total_weight

func calculate_wave_adjusted_probabilities(wave_index: int) -> Array:
	var adjusted_probabilities: Array = []
	var adjusted_total_weight = 0.0
	# Scale factor, adjusting difficulty. Starts near 0 for early waves, increases over time
	var scale_factor = clamp(float(wave_index) / 10.0, 0.0, 1.0)
	# Recalculate the probabilities based on wave_index
	for i in range(num_enemies):
		# Flatten the probability curve as wave_index increases
		var adjusted_weight = lerp(base_probabilities[i], 1.0 / num_enemies, scale_factor)
		adjusted_probabilities.append(adjusted_weight)
		adjusted_total_weight += adjusted_weight
	
	# Normalize again to make the sum equal 1.0
	for i in range(adjusted_probabilities.size()):
		adjusted_probabilities[i] /= adjusted_total_weight
	
	return adjusted_probabilities
		
func get_enemy_for_wave(wave_index: int):
	var adjusted_probabilities = calculate_wave_adjusted_probabilities(wave_index)
	var random_value = randf()
	var cumulative_probability = 0.0
	for i in range(adjusted_probabilities.size()):
		cumulative_probability += adjusted_probabilities[i]
		if random_value <= cumulative_probability:
			return enemies_for_waves.get_element_by_index(i)

	
