class_name CustomTweenBehaviour

var parent: Node

func _init(parent_node: Node):
	parent = parent_node

func clear_paralel_tween(tween: Tween)-> Tween:
	if (tween != null):
		tween.kill()
	return parent.create_tween().set_parallel(true)

func clear_tween(tween: Tween)-> Tween:
	if (tween != null):
		tween.kill()
	return parent.create_tween()
	

func fade_in_out_component(component: Node, component_tween: Tween):
	if component && component_tween:
		component_tween.tween_property(component, "modulate:a", 1, 1)
		component_tween.tween_property(component, "modulate:a", 1, 2)
		component_tween.tween_property(component, "modulate:a", 0, 2)

func fade_in_component(component: Node, component_tween: Tween, fade_time: float = 0.3):
	if component && component_tween:
		component_tween.tween_property(component, "modulate:a", 1, fade_time)

func fade_out_component(component: Node, component_tween: Tween, fade_time: float = 0.3):
	if component && component_tween:
		component_tween.tween_property(component, "modulate:a", 0, fade_time)		

func modulate_to_red_and_out(component: Node, component_tween: Tween)	:
	if component && component_tween:
		var prev_color = component.modulate
		component_tween.tween_property(component, "modulate", Color(1, 0, 0, 1), 0.75 )
		component_tween.tween_property(component, "modulate", prev_color, 0.5 )
