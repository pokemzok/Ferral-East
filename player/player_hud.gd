extends CanvasLayer

var health_point_res = preload("res://player/Health.png")

@onready var level_score_label = %LevelScore
@onready var last_enemy_points_label = %LastEnemyPoints

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_HP_CHANGED, on_hp_changed)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, on_menu_displayed)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, on_menu_hidden)
	GlobalEventBus.connect(GlobalEventBus.SCORE_CHANGED, on_score_changed)

func on_hp_changed(hp):
	clear_hearts()
	for i in range(hp):
		add_hp()

func on_menu_displayed():
	hide()

func on_menu_hidden():
	show()

func clear_hearts():
	var health_container = $HealthContainer
	while health_container.get_child_count() > 0:
		var heart = health_container.get_child(0)
		health_container.remove_child(heart)

func add_hp():
	var health_point_icon = TextureRect.new()
	health_point_icon.texture = health_point_res
	$HealthContainer.add_child(health_point_icon)

# TODO: Fade out animation  on last_enemy_points_label
# TODO: push outline color?
# TODO: red color for when use was damaged
# TODO: different colors for the LastEnemyPoints if multiplier is bigger then 1
func on_score_changed(details: ScoreDetails):
	level_score_label.text = "Score: " + str(details.score)
	last_enemy_points_label.show()
	last_enemy_points_label.text  = str(details.enemy_value)+" x "+str(details.score_multiplier)
