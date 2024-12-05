extends InteractableItem

var item_to_initialize = preload("res://weapon/magic/teleportation_orb/teleportation_orb.tscn")

func _ready():
	type = ItemType.LEFT_HAND_ITEM
	id = ItemID.TELEPORTATION_ORB
	interaction_name = "Teleportation_orb"
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, interaction_ended)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_PICKED_UP_LEFT_ARM_ITEM, on_pickup)

func _process(delta):
	process_interactions(delta)

func instantiate():
	return item_to_initialize.instantiate()
