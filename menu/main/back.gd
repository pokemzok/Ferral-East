extends Button

@onready var menu = %Menu
@onready var settings = %Settings


func _on_pressed():
	settings.hide()
	menu.show()
