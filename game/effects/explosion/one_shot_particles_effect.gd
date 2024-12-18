extends Node2D

@onready var particles = $CPUParticles2D

func _ready():
	turn_off()

func turn_on(_position):
	global_position  = _position
	particles.emitting = true

func turn_off():
	particles.emitting = false
