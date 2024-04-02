extends CanvasLayer

var health_point_res = preload("res://player/Health.png")

@onready var level_score_label = %LevelScore
@onready var last_enemy_points_label = %LastEnemyPoints
var enemy_points_colors = {
	1: Color("#ffffff", 0),
	2: Color("#00ff00", 0), 
	3: Color("#0421a2", 0),
	4: Color("#833e19", 0),
	5: Color("#b22727",0),
	6: Color("#9c0000",0),
	7: Color("#430805",0), 
	8: Color("#000000",0) 
}

var original_color_transparent: Color
var enemy_points_tween: Tween
var level_score_tween: Tween

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_HP_CHANGED, on_hp_changed)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, on_menu_displayed)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, on_menu_hidden)
	GlobalEventBus.connect(GlobalEventBus.SCORE_CHANGED, on_score_changed)
	original_color_transparent = Color(last_enemy_points_label.modulate, 0)
	last_enemy_points_label.modulate.a = 0

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

# TODO: push outline color?
# TODO: red color for when use was damaged
# TODO: different colors for the LastEnemyPoints if multiplier is bigger then 1
func on_score_changed(details: ScoreDetails):
	level_score_update(details)
	enemy_points_update(details)

func level_score_update(details: ScoreDetails):
	if (level_score_tween != null):
		level_score_tween.kill()
	level_score_label.text = "Score: " + str(details.score)	
	level_score_tween = create_tween()
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1.1, 1.1), 0.15)
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1, 1), 0.15)
	
	
func enemy_points_update(details: ScoreDetails):
	if (enemy_points_tween != null):
		enemy_points_tween.kill()
	var color = original_color_transparent
	if (enemy_points_colors.has(details.score_multiplier)):
		color = enemy_points_colors[details.score_multiplier]
	last_enemy_points_label.modulate = Color(color,1)
	last_enemy_points_label.text  = str(details.enemy_value)+" x "+str(details.score_multiplier)
	enemy_points_tween = create_tween()
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1.25, 1.25), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1, 1), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "modulate", color, 2)
