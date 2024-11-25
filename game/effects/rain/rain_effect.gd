extends Node2D

@onready var particles = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#turn_off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turn_on():
	particles.emitting = true

func turn_off():
	particles.emitting = false
