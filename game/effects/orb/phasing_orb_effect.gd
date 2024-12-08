extends Node2D

@export var emitting = false
@export var lifetime = 0.5

func _ready():
	$CPUParticles2D.emitting = emitting
	$CPUParticles2D.lifetime = lifetime

func stop_emitting():
	$CPUParticles2D.emitting = false

func one_shot_emitting():
	$CPUParticles2D.one_shot = true
	start_emitting()
	
func start_emitting():
	$CPUParticles2D.emitting = true	
