extends Node

#menu
signal start_button_pressed
signal resume_button_pressed
signal restart_button_pressed
signal quit_to_menu_button_pressed
signal main_menu_displayed
signal main_menu_hidden
# signal_names
const START_BUTTON_PRESSED = "start_button_pressed"
const RESUME_BUTTON_PRESSED = "resume_button_pressed"
const RESTART_BUTTON_PRESSED = "restart_button_pressed"
const QUIT_TO_MENU_BUTTON_PRESSED = "quit_to_menu_button_pressed"
const MAIN_MENU_DISPLAYED = "main_menu_displayed"
const MAIN_MENU_HIDDEN =  "main_menu_hidden"

#player
signal player_selected
signal player_death
signal player_hp_changed
signal player_damaged
signal player_used_projectile_weapon
signal player_leveled_up
signal player_collected_coins
signal player_monolog
signal player_enters_shop
signal player_left_shop
signal player_ready_to_buy
signal player_teleported
signal player_arrived_to_level
signal player_clicked_shop_item
# signal_names
const PLAYER_SELECTED = "player_selected"
const PLAYER_DEATH = "player_death"
const PLAYER_HP_CHANGED = "player_hp_changed"
const PLAYER_DAMAGED = "player_damaged"
const PLAYER_USED_PROJECTILE_WEAPON = "player_used_projectile_weapon"
const PLAYER_LEVELED_UP = "player_leveled_up"
const PLAYER_COLLECTED_COINS = "player_collected_coins"
const PLAYER_MONOLOG = "player_monolog"
const PLAYER_ENTERS_SHOP = "player_enters_shop"
const PLAYER_LEFT_SHOP = "player_left_shop"
const PLAYER_READY_TO_BUY = "player_ready_to_buy"
const PLAYER_TELEPORTED = "player_teleported"
const PLAYER_ARRIVED_TO_LEVEL = "player_arrived_to_level"
const PLAYER_CLICKED_SHOP_ITEM = "player_clicked_shop_item"
#trader
signal trader_damaged
#signal_names
const TRADER_DAMAGED = "trader_damaged"
#enemy
signal enemy_damaged
signal enemy_death 
# signal_names
const ENEMY_DAMAGED = "enemy_damaged"
const ENEMY_DEATH = "enemy_death"

#score
signal score_changed
#signal_names
const SCORE_CHANGED = "score_changed"

#surival
signal wave_started
signal wave_completed
#signal_names
const WAVE_STARTED = "wave_started"
const WAVE_COMPLETED = "wave_completed"

#interactions
signal interaction_hint
signal interaction_hint_hide
signal start_conversation_with
signal finish_conversation
#signal_names
const INTERACTION_HINT = "interaction_hint"
const INTERACTION_HINT_HIDE = "interaction_hint_hide"
const START_CONVERSATION_WITH = "start_conversation_with"
const FINISH_CONVERSATION = "finish_conversation"


func emit_signal_for(signal_name):
	var name = signal_name.to_lower()
	if has_signal(name):
		call_deferred("emit_signal", name)
	else:
		print("No such signal")
