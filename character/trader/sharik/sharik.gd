class_name Sharik
extends Trader

static var character_name = CharacterNames.SHARIK

@onready var animations = $AnimatedSprite2D
var teleporting = false
var phasing_into = true
var phasing_period = NumericAttribute.new(0, 1)
var transgression_count = NumericAttribute.new(0, 5)
var teleport_audio = GameSoundManager.Sounds.TELEPORT
@onready var audio_pool = $GameAmbientAudioPool

func _ready():
	animations.connect("animation_looped", on_animation_finished)
	GlobalEventBus.connect(GlobalEventBus.WAVE_STARTED, on_wave_started)
	GlobalEventBus.connect(GlobalEventBus.START_INTERACTION_WITH, conversation_started)
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, conversation_ended)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ENTERS_SHOP, on_player_enters_shop)
	
func _process(_delta):
	interaction_behaviour.process_interaction(character_name)

func _physics_process(delta):
	interaction_behaviour.process_interaction_cooldown(delta)		
	on_player_actions(delta)


func on_player_actions(delta):
	if (phasing_into):
		on_phasing_into()
	elif (teleporting):
		on_teleporting()
	elif (transgression_count.is_max_value()):
		start_teleporting()			
	else:	
		if velocity.length() > 0:
			on_walk(delta)
		else:
			on_idle(delta)

func on_phasing_into():
	animations.play("phasing_into")	

func on_player_enters_shop(_shop_level):
	animations.play("phase_out")
	
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

func on_wave_started(_wave_nr, _enemies_left):
	start_teleporting()

func start_teleporting():
	teleporting = true
	audio_pool.play_sound_effect(teleport_audio)		

func on_animation_finished():
	if animations.animation == "teleport" || animations.animation == "phase_out":
		queue_free()
	elif animations.animation == "phasing_into":
		animations.stop()
		phasing_into = false
		on_idle(0)

func on_hurtbox_entered(body):
	if body.is_in_group("projectiles"):
		if (phasing_period.is_lte_zero()):
			transgression_count.increment_by()
			GlobalEventBus.trader_damaged.emit(character_name)			
		phasing_period.assign_max_on_less_or_zero()
		body.queue_free()

func conversation_started(_npc_name: String):
	pausable.set_pause(true)
	on_idle(0)

func conversation_ended():
	interaction_behaviour.max_interaction_cooldown()
	pausable.set_pause(false)

