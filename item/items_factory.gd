extends Node2D
# FiXME So I think here we could take lots of possible arguments.
# Lets start vanilla though, let the kill score determine possible drop.
# I can also have here enemy dictionary with weights

var current_item_resource: SingleResource
var current_enemy_death_details: EnemyDeathDetails
var item_spawn_delay = NumericAttribute.new(0.5, 0.5)
var items: Items = Items.get_instance()
var item_instance
func _ready():
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)

func _process(delta):
	on_loading_resource()
	on_loading_completed(delta)
	
func on_loading_resource():
	if(current_item_resource != null && current_enemy_death_details != null):
		if( current_item_resource.is_loaded()):
			var item = current_item_resource.get_loaded_resource()
			item_instance = item.instantiate()
			item_instance.global_position = current_enemy_death_details.death_position
			current_item_resource = null
			current_enemy_death_details = null
		else:
			current_item_resource.load_resource()		

func on_loading_completed(delta):
	if (item_instance):
		if(item_spawn_delay.is_lte_zero()):
			add_child(item_instance)
			item_instance = null
			item_spawn_delay.assign_max_value()
		else:
			item_spawn_delay.decrement_by(delta)	
	
# FIXme better logic, plus more then one item
func on_enemy_death(enemy_death_details: EnemyDeathDetails):
	var drop_chance = 0.2
	var random_number = randf()
	if  (random_number < drop_chance):
		drop_item(enemy_death_details)
	
func drop_item(enemy_death_details: EnemyDeathDetails):
	if (current_item_resource == null):
		current_enemy_death_details = enemy_death_details
		current_item_resource = SingleResource.new(items.ItemName.PENTAGRAM, items.res_dictionary)
