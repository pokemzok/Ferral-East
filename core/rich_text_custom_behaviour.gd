extends Node
class_name RichTextCustomBehaviour

var outline_prefix="[outline_color=black][outline_size=10]"
var small_outline_prefix="[outline_color=black][outline_size=5]"
var outline_suffix= "[/outline_size][/outline_color]"
static var instance = null

static func get_instance() -> RichTextCustomBehaviour:
	if instance == null:
		instance = RichTextCustomBehaviour.new()
		instance.name = "RichTextCustomBehaviour"
		instance.add_to_group("singleton")
	return instance	

func outline_text(text: String) -> String:
	return outline_prefix+text+outline_suffix

func small_outline_text(text: String) -> String:
	return small_outline_prefix+text+outline_suffix
	
