extends HBoxContainer

@onready var projectiles_left_label: RichTextLabel = $ProjectilesLeft


var projectiles_image= "[img]res://assets/hud/hud-bullet.png[/img]"

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_USED_PROJECTILE_WEAPON, on_projectile_weapon_used)	

func on_projectile_weapon_used(projectiles_left):
	projectiles_left_label.text = projectiles_image+rich_text_behaviour.outline_text(" x "+str(projectiles_left))
	