extends Node2D

@export var active: bool = false
@export var opacity: float = 1.0

@onready var activeSocket = $ActiveSocketIcon
@onready var inactiveSocket = $InactiveSocketIcon
@onready var item_quantity = $ItemQuantity
@onready var item_icon = $ItemIcon

var rich_text_behaviour = RichTextCustomBehaviour.get_instance()

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
		item_quantity.text = rich_text_behaviour.small_outline_text(str(item.quantity))
	else:
		item_icon.texture = null
		item_quantity.text = ""	
	
