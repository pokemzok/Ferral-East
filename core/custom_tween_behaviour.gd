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

func fade_in_component(component: Node, component_tween: Tween):
	if component && component_tween:
		component_tween.tween_property(component, "modulate:a", 1, 0.3)

func fade_out_component(component: Node, component_tween: Tween):
	if component && component_tween:
		component_tween.tween_property(component, "modulate:a", 0, 0.3)		

	
