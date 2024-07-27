extends Node2D

@onready var bullet_timer = $BulletTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_events()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_events():
	# fixme I would actually need some player action instead
	GlobalEventBus.connect(GlobalEventBus.PLAYER_BOUGHT_ITEM, on_player_bought_item)


func on_player_bought_item(item: ShopItem):
	if (item.id == Item.ItemName.CATNIP):
		slow_time()
		
func slow_time():
	bullet_timer.wait_time = 6
	bullet_timer.start()
	bullet_timer.connect("timeout", reset_time_speed)
	Engine.time_scale = 0.5
	AudioServer.playback_speed_scale = 0.5

func reset_time_speed():
	bullet_timer.stop()
	Engine.time_scale = 1
	AudioServer.playback_speed_scale = 1
