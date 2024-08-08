class_name ShopItems
extends Node

# FIXME create Water and a CATNIP
static var res_dictionary  = {
	Item.ItemID.REVOLVER_PARTS: "res://item/shop/revolver_parts/revolver_parts.tscn",
	Item.ItemID.WATER: "res://item/shop/water/water.tscn",
	Item.ItemID.CATNIP: "res://item/shop/catnip/catnip.tscn",
}

static var common_items = {
	Sharik.character_name: [Item.ItemID.WATER, Item.ItemID.CATNIP, Item.ItemID.REVOLVER_PARTS],
}

static var rare_items = {
	Sharik.character_name: [Item.ItemID.REVOLVER_PARTS] #FIXME something different here
}

static var legendary_items = {
	Sharik.character_name: [Item.ItemID.REVOLVER_PARTS] #FIXME gods favours
}
