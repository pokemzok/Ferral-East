extends Node2D

@onready var clouds = $Clouds
@onready var fog =  $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_on_clouds()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func turn_off_clouds():
	clouds.hide()

func turn_on_clouds():
	clouds.show()
	#clouds.modulate.a = 1

func turn_on_fog(_delta):
	fog.show()
	#fog.modulate.a = 1
