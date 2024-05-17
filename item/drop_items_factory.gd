extends Node2D

var current_item_resource: SingleResource
var current_enemy_death_details: EnemyDeathDetails
var item_spawn_delay = NumericAttribute.new(0.5, 0.5)
var items: DropItems = DropItems.get_instance()
var item_instance
var drop_chance_increase = 0

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
	
func on_enemy_death(enemy_death_details: EnemyDeathDetails):
	var base_drop_chance = DropItems.drop_chances[enemy_death_details.enemy_type]
	var score_factor = calculate_score_factor(enemy_death_details.score)
	var drop_chance = base_drop_chance + score_factor + drop_chance_increase
	var drawn_chance = randf()
	if  (drawn_chance < drop_chance):
		current_enemy_death_details = enemy_death_details
		drop_item(select_item(drawn_chance, drop_chance, enemy_death_details.enemy_type))
		drop_chance_increase = -0.03
	else:
		if(drop_chance_increase < 0.15):
			drop_chance_increase += 0.015	

func calculate_score_factor(score: int) -> float:
	var max_drop_chance = 1
	var min_drop_chance = 0
	var max_score = 100.0
	var normalized_score = float(score) / max_score
	normalized_score = clamp(normalized_score, 0.0, 1.0)
	var score_factor = lerp(min_drop_chance, max_drop_chance, normalized_score)
	return score_factor/10

func select_item(drawn_chance: float, chance_threshold: float, enemy_type: Enemy.EnemyType) -> Item.ItemName:
	var legendary_tier_threshold = chance_threshold/9
	if (drawn_chance <= legendary_tier_threshold):
		return items.legendary_items[enemy_type]
	elif(drawn_chance <= legendary_tier_threshold * 3):	
		return items.rare_items[enemy_type]
	else:	
		return items.common_items[enemy_type]
	
func drop_item(item: Item.ItemName):
	if (current_item_resource == null):
		current_item_resource = SingleResource.new(item, items.res_dictionary)
