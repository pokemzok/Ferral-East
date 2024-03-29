extends CanvasLayer

@onready var settings = %Settings
@onready var menu = %Menu
@onready var resume_button = %Resume
@onready var start_button = %Start
@onready var restart_button = %Restart
@onready var quit_to_menu_button = %QuitToMenu

func _on_start_pressed():
	GlobalEventBus.start_button_pressed.emit()
	start_button.hide()
	restart_button.show()
	resume_button.show()
	quit_to_menu_button.show()

func _on_resume_pressed():
	GlobalEventBus.resume_button_pressed.emit()

func _on_restart_pressed():
	GlobalEventBus.restart_button_pressed.emit()
	
func _on_options_pressed():
	settings.show()
	menu.hide()

func show_main_menu():
	menu.show()
	settings.hide()
	GlobalEventBus.main_menu_displayed.emit()	

func _on_quit_pressed():
	get_tree().quit()

func toggle() -> bool:
	if (!start_button.visible && !settings.visible):
		visible = !visible 
	
	if (visible):
		show_main_menu()
	else:
		GlobalEventBus.main_menu_hidden.emit()			
	return visible

func reset():
	start_button.show()
	resume_button.hide()
	restart_button.hide()
	quit_to_menu_button.hide()

func _on_quit_to_main_menu_pressed():
	GlobalEventBus.quit_to_menu_button_pressed.emit()
