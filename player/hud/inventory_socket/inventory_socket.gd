extends Node2D

@export var active: bool = false
@export var opacity: float = 1.0

@onready var activeSocket = $ActiveSocketIcon
@onready var inactiveSocket = $InactiveSocketIcon
@onready var item_quantity = $ItemQuantity
@onready var item_icon = $ItemIcon

const outline_prefix = "[outline_color=black][outline_size=5]"
const outline_suffix = "[/outline_size][/outline_color]"

var item: Item

func _ready():
	process_socket_state()
	self.modulate.a = opacity

func activate():
	active = true
	process_socket_state()

func desactivate():
	active = false
	process_socket_state()	

func process_socket_state():
	if (active):
		activeSocket.show()
		inactiveSocket.hide()
	else:
		activeSocket.hide()	
		inactiveSocket.show()

func put_item(_item: Item):
	item = _item
	if (item != null):
		var new_texture = load(item.inventory_texture_path)
		if new_texture:
			item_icon.texture = new_texture
		item_quantity.text = outline_prefix+str(item.quantity)+outline_suffix
	else:
		item_icon.texture = null
		item_quantity.text = ""	
	
