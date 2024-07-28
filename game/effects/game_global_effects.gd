extends Node2D

@onready var bullet_timer = $BulletTimer
var bullet_time_tween: Tween

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
	
# FIXME LSD colors		
# TODO: I would need to use shader like they use it on this tutorial https://www.youtube.com/watch?v=DlwyfdDOxLc
func slow_time():
	bullet_time_tween = clear_paralel_tween(bullet_time_tween)
	bullet_time_tween.tween_property(Engine, "time_scale", 0.5, 0.5)
	bullet_time_tween.tween_property(AudioServer, "playback_speed_scale", 0.5, 0.5)

	bullet_timer.wait_time = 6
	bullet_timer.start()
	bullet_timer.connect("timeout", reset_time_speed)
	
func reset_time_speed():
	bullet_timer.stop()
	bullet_time_tween = clear_paralel_tween(bullet_time_tween)
	bullet_time_tween.tween_property(Engine, "time_scale", 1, 0.5)
	bullet_time_tween.tween_property(AudioServer, "playback_speed_scale", 1, 0.5)

func clear_paralel_tween(tween: Tween)-> Tween:
	if (tween != null):
		tween.kill()
	return create_tween().set_parallel(true)
