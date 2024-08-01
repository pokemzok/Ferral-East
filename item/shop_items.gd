class_name ShopItems
extends Node

# FIXME create Water and a CATNIP
static var res_dictionary  = {
	Item.ItemName.REVOLVER_PARTS: "res://item/shop/revolver_parts/revolver_parts.tscn",
	Item.ItemName.WATER: "res://item/shop/water/water.tscn",
	Item.ItemName.CATNIP: "res://item/shop/catnip/catnip.tscn",
}

static var common_items = {
	Sharik.character_name: [Item.ItemName.WATER, Item.ItemName.CATNIP, Item.ItemName.REVOLVER_PARTS],
}

static var rare_items = {
	Sharik.character_name: [Item.ItemName.REVOLVER_PARTS] #FIXME something different here
}

static var legendary_items = {
	Sharik.character_name: [Item.ItemName.REVOLVER_PARTS] #FIXME gods favours
}
