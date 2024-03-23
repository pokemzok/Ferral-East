extends Button

var scene_path = "res://levels/test/test-level.tscn"

func _on_pressed():
	get_tree().change_scene_to_file(scene_path)
