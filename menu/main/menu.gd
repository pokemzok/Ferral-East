extends VBoxContainer

@onready var settings = %Settings

func _on_start_pressed():
	get_tree().change_scene_to_file(
		LevelManager.get_instance().get_level(LevelManager.Levels.TEST)
	)

func _on_options_pressed():
	print("working")
	print(settings)
	settings.show()
	self.hide()

func _on_quit_pressed():
	get_tree().quit()
