extends VBoxContainer

@onready var settings = %Settings
var scene_path = "res://levels/test/test-level.tscn"

func _on_start_pressed():
	get_tree().change_scene_to_file(scene_path)

func _on_options_pressed():
	print("working")
	print(settings)
	settings.show()
	self.hide()

func _on_quit_pressed():
	get_tree().quit()
