extends Node

signal start_button_pressed

@onready var settings = %Settings
@onready var menu = %Menu
@onready var menu_ui = $UI

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_start_pressed():
	emit_signal("start_button_pressed")

func _on_options_pressed():
	settings.show()
	menu.hide()

func _on_quit_pressed():
	get_tree().quit()

func hide():
	menu_ui.hide()

func toggle() -> bool:
	menu_ui.visible = !menu_ui.visible 
	return menu_ui.visible
