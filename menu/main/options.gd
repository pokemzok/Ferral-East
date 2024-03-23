extends Button

@onready var settings = %Settings


func _on_pressed():
	settings.show()
	get_parent().hide()
