extends Node

signal start_button_pressed
signal resume_button_pressed

@onready var settings = %Settings
@onready var menu = %Menu
@onready var menu_ui = $UI
@onready var resume_button = %Resume
@onready var start_button = %Start

func _on_start_pressed():
	emit_signal("start_button_pressed")
	start_button.hide()
	resume_button.show()

func _on_resume_pressed():
	emit_signal("resume_button_pressed")

func _on_options_pressed():
	settings.show()
	menu.hide()

func back_to_main_menu():
	menu.show()
	settings.hide()

func _on_quit_pressed():
	get_tree().quit()

func hide():
	menu_ui.hide()

func toggle() -> bool:
	if (!settings.visible && !start_button.visible):
		menu_ui.visible = !menu_ui.visible 
		if (menu_ui.visible):
			back_to_main_menu()
		return menu_ui.visible
	return menu_ui.visible
