extends Item


# FIXME
# I can draw those differently too. Those could either increase damage or add more bullets to the weapon.

func _ready():
	type = ItemType.BULLET_UPGRADE
	price = 10
