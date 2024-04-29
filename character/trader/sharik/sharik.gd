extends Trader

@onready var animations = $AnimatedSprite2D
var teleporting = false
var phasing_into = true
var phasing_period = NumericAttribute.new(0, 1)
var transgression_count = NumericAttribute.new(0, 5)
var character_name = "Sharik"

func _ready():
	animations.connect("animation_looped", on_animation_finished)
	GlobalEventBus.connect(GlobalEventBus.WAVE_STARTED, on_wave_started)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, conversation_started)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, conversation_ended)

func _process(delta):
	process_interaction(character_name)

func _physics_process(delta):
	_interaction_cooldown(delta)		
	on_player_actions(delta)

func _interaction_cooldown(delta):
	if(interaction_info_cooldown.is_gt_zero()):
		interaction_info_cooldown.decrement_by(delta)
	if(interaction_cooldown.is_gt_zero()):
		interaction_cooldown.decrement_by(delta)	

func on_player_actions(delta):
	if (phasing_into):
		on_phasing_into()
	elif (teleporting || transgression_count.is_max_value()):
		on_teleporting()
	else:	
		if velocity.length() > 0:
			on_walk(delta)
		else:
			on_idle(delta)

func on_phasing_into():
	animations.play("phasing_into")	

func on_teleporting():
	animations.play("teleport")	

func on_walk(delta):
	if (phasing_period.is_lte_zero()):
		animations.play("walk")
	else:	
		animations.play("phasing_walk")
		phasing_period.decrement_by(delta)
		
func on_idle(delta):
	if (phasing_period.is_lte_zero()):
		animations.play("idle")			
	else:
		animations.play("phasing_idle")
		phasing_period.decrement_by(delta)

func on_wave_started(wave_nr, enemies_left):
	start_teleporting()
	
func start_teleporting():
	teleporting = true

func on_animation_finished():
	if animations.animation == "teleport":
		queue_free()
	elif animations.animation == "phasing_into":
		phasing_into = false

func _on_hurtbox_body_entered(body):
	if body.is_in_group("projectiles"):
		if (phasing_period.is_lte_zero()):
			transgression_count.increment_by()
			GlobalEventBus.trader_damaged.emit(character_name)			
		phasing_period.assign_max_on_less_or_zero()
		body.queue_free()

func conversation_started(npc_name: String):
	pausable.set_pause(true)
	on_idle(0)

func conversation_ended():
	interaction_cooldown.assign_max_on_less_or_zero()
	pausable.set_pause(false)

