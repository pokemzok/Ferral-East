class_name SurvivalModeEnemies
extends Node

var regular_enemies: ArrayCollection
var num_enemies: int
var bosses: ArrayCollection
var boss_index = 0
var nr_enemies_per_wave = [0]
var base_probabilities: Array = []
var base_total_weight = 0.0
var max_first_weight = 0.9
var min_first_weight = 0.3

func _init(_regular_enemies: ArrayCollection, _bosses: ArrayCollection, _nr_enemies_per_wave: Array):
	self.regular_enemies = _regular_enemies
	self.bosses = _bosses
	self.nr_enemies_per_wave = _nr_enemies_per_wave
	enemies_precondition()
	calculate_base_probabilities()	

func is_boss_wave(wave_index):
	if(nr_enemies_per_wave.size() <= wave_index):
		return nr_enemies_per_wave[nr_enemies_per_wave.size()-1]
	else:
		return nr_enemies_per_wave[wave_index] == 1

func enemies_precondition():
	num_enemies = regular_enemies.size()
	if num_enemies == 0:
		push_error("No enemies to draw from")

func bosses_precondition():
	if bosses.size() == 0:
		push_error("No bosses to draw from")

func calculate_base_probabilities():
	base_probabilities.clear()
	base_total_weight = 0
	if num_enemies == 1:
		base_probabilities.append(1.0)
		return

	var first_weight_substraction = 0.0
	if (num_enemies  > 3):
		first_weight_substraction = (num_enemies - 3)/10
	var first_weight = max_first_weight - first_weight_substraction
	first_weight = clamp(first_weight, min_first_weight, max_first_weight)  # Ensure it's within the bounds
	
	base_probabilities.append(first_weight)
	var remaining_weight = 1.0 - first_weight
	
	var falloff_total_weight = 0.0
	for i in range(1, num_enemies):
		falloff_total_weight += pow(0.5, i)
	
	# Now calculate the weights for the rest of the enemies and normalize them
	for i in range(1, num_enemies):
		var weight = pow(0.5, i)
		# Scale the falloff weights to fit the remaining weight
		weight = weight * (remaining_weight / falloff_total_weight)
		base_probabilities.append(weight)

func calculate_wave_adjusted_probabilities(wave_index: int) -> Array:
	var adjusted_probabilities: Array = []
	var adjusted_total_weight = 0.0
	# Scale factor, adjusting difficulty. Starts near 0 for early waves, increases over time
	var scale_factor = clamp(float(wave_index) / 10.0, 0.0, 1.0)
	# Recalculate the probabilities based on wave_index
	var falloff_total_weight = 0.0
	if (num_enemies >  1):
		for j in range(1, num_enemies):
			falloff_total_weight += pow(0.5, j)
			
	for i in range(num_enemies):
		var adjusted_weight = 0.0
		if (i == 0):
			adjusted_weight = lerp(base_probabilities[i], 1.0 / num_enemies, scale_factor)
			adjusted_weight = clamp(adjusted_weight, min_first_weight, max_first_weight) 
		else:
			var remaining_weight = 1.0 - adjusted_probabilities[0]
			adjusted_weight = pow(0.5, i)
			adjusted_weight = adjusted_weight * (remaining_weight / falloff_total_weight)
				
		adjusted_probabilities.append(adjusted_weight)
		adjusted_total_weight += adjusted_weight
	
	# Normalize again to make the sum equal 1.0
	for i in range(adjusted_probabilities.size()):
		adjusted_probabilities[i] /= adjusted_total_weight
	
	return adjusted_probabilities
		
func get_enemy_for_wave(wave_index: int):
	return get_boss() if is_boss_wave(wave_index) else get_regular_enemy_for_wave(wave_index)

func get_regular_enemy_for_wave(wave_index: int):
	var adjusted_probabilities = calculate_wave_adjusted_probabilities(wave_index)
	var random_value = randf()
	var cumulative_probability = 0.0
	for i in range(adjusted_probabilities.size()):
		cumulative_probability += adjusted_probabilities[i]
		if random_value <= cumulative_probability:
			return regular_enemies.get_element_by_index(i)

func get_boss():
	if (bosses.size() > boss_index):
		var boss = bosses.collection[boss_index]
		boss_index = boss_index + 1
		if(bosses.size() == boss_index):
			boss_index = 0
		return boss
	else:
		push_error("All bosses were used up")	
