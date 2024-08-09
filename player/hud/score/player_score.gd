extends VBoxContainer

@onready var level_score_label: RichTextLabel = $LevelScore
@onready var last_enemy_points_label: RichTextLabel = $LastEnemyPoints
var tween_behaviour = CustomTweenBehaviour.new(self)
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()

var level_score_tween: Tween
var enemy_points_tween: Tween
var original_color: Color
var original_color_transparent: Color

var enemy_points_colors = {
	1: Color("#ffffff", 0),
	2: Color("#00ff00", 0), 
	3: Color("#6bc3fe", 0),
	4: Color("#f25932", 0),
	5: Color("#833e19",0),
	6: Color("#b22727",0),
	7: Color("#9c0000",0),
	8: Color("#9c4af3",0)
}

func _ready():
	score_setup()
	handle_events()
	
func score_setup():
	original_color_transparent = Color(last_enemy_points_label.modulate, 0)
	original_color = Color(last_enemy_points_label.modulate, 1)
	last_enemy_points_label.modulate.a = 0
	level_score_label.text = rich_text_behaviour.outline_text(tr("HUD_SCORE")+": " + str(0))

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.SCORE_CHANGED, on_score_changed)
	
func on_score_changed(details: ScoreDetails):
	level_score_update(details)
	enemy_points_update(details)

func level_score_update(details: ScoreDetails):
	level_score_tween = tween_behaviour.clear_tween(level_score_tween)
	level_score_label.text = rich_text_behaviour.outline_text(tr("HUD_SCORE")+": " + str(details.score))	
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1.1, 1.1), 0.15)
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1, 1), 0.15)

func enemy_points_update(details: ScoreDetails):
	enemy_points_tween = tween_behaviour.clear_tween(enemy_points_tween)	
	var color = original_color_transparent
	if (enemy_points_colors.has(details.score_multiplier)):
		color = enemy_points_colors[details.score_multiplier]
	last_enemy_points_label.modulate = Color(color,1)
	last_enemy_points_label.text  = rich_text_behaviour.outline_text(str(details.enemy_value)+" x "+str(details.score_multiplier))
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1.25, 1.25), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1, 1), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "modulate", color, 2)
	
