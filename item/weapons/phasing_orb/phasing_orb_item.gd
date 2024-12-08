extends InteractableItem

var item_to_initialize = preload("res://weapon/magic/phasing_orb/phasing_orb.tscn")

func _ready():
	type = ItemType.LEFT_HAND_ITEM
	id = ItemID.PHASING_ORB
	interaction_name = "Phasing_orb"
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, interaction_ended)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_PICKED_UP_LEFT_ARM_ITEM, on_pickup)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_DESTROYED_ITEM, on_destroy)

func _process(delta):
	process_interactions(delta)

func instantiate():
	return item_to_initialize.instantiate()
