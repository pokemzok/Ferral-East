extends HBoxContainer

@onready var projectiles_left_label: RichTextLabel = $ProjectilesLeft

var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var projectiles_image= "[img]res://player/hud/projectiles/bullet.png[/img]"

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_USED_PROJECTILE_WEAPON, on_projectile_weapon_used)	

func on_projectile_weapon_used(projectiles_left):
	projectiles_left_label.text = projectiles_image+rich_text_behaviour.outline_text(" x "+str(projectiles_left))
	
