extends Node2D
@onready var items_spawns = $ItemSpawns
var spawn_slots = 3
var statistics: GameStatistics
var drawn_chance = 0
var rare_item_chance = 0
var legendary_item_chance = 0
var resources_group: ResourcesGroup
var shop_items: ArrayCollection
var player_can_shop = false
var player

func with_data(_player, _statistics: GameStatistics):
	self.player = _player
	self.statistics = _statistics
	prepare_items()
	return self

func _ready():
	handle_events()
	hide_items()
	
func _process(delta):
	on_shop_items_loading()

func add_player(player):
	self.player = player

#FIXME I think I need to somehow add here player node as well, so the player can physically buy shit
#FIXME it seems like a correct idea, since player has a wallet and would be spending money with it.
func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_READY_TO_BUY, on_player_ready_to_buy)
	GlobalEventBus.player_arrived_to_level.emit(LevelManager.Levels.SHARIK_SHOP)
	
func on_player_ready_to_buy():
	show_items()

func show_items():
	items_spawns.show()
	
func hide_items():
	items_spawns.hide()	

func on_shop_items_loading():
	if(resources_group != null && !player_can_shop):
		if(resources_group.is_group_loaded()):
			shop_items = resources_group.get_loaded_resources()
			player_can_shop = true
			for index in shop_items.size():
				var item = shop_items.get_element_by_index(index)
				items_spawns.get_child(index).add_child(item.instantiate())
		else:
			resources_group.load_resource_group()	

func prepare_items():	
	drawn_chance = randf()
	calculate_rare_item_chance()
	calculate_legendary_item_chance()
	var common_items = random_common_items()
	var rare_items = random_rare_items()
	var legendary_items = random_legendary_items()
	var items = legendary_items + rare_items + common_items
	if items.size() > spawn_slots:
		items = items.slice(0, spawn_slots)
	resources_group = ResourcesGroup.new(items, ShopItems.res_dictionary)

func calculate_rare_item_chance():
	var base_chance = 0.1
	var increase_rate = 0.04
	var chance = base_chance + (statistics.completed_waves * increase_rate)
	chance = min(chance, 1.0)
	self.rare_item_chance = chance

func calculate_legendary_item_chance():
	var base_chance = 0.01
	var increase_rate = 0.01 if statistics.completed_waves < 20 else 0.02
	var chance = base_chance + (statistics.completed_waves * increase_rate)
	chance = min(chance, 1.0)
	self.legendary_item_chance = chance

func random_common_items()-> Array:
	return random_items(3, ArrayCollection.new(ShopItems.common_items[Sharik.character_name]))
	
func random_rare_items()-> Array:
	var items_quantity = 1 if drawn_chance < rare_item_chance else 0
	return random_items(items_quantity, ArrayCollection.new(ShopItems.rare_items[Sharik.character_name]))
	
func random_legendary_items()-> Array:
	var items_quantity = 1 if drawn_chance < legendary_item_chance else 0
	return random_items(items_quantity, ArrayCollection.new(ShopItems.legendary_items[Sharik.character_name]))
	
func random_items(quantity: int, possible_items: ArrayCollection) -> Array:
	return possible_items.random_elements(quantity)
