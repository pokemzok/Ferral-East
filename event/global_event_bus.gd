extends Node

#menu
signal start_button_pressed
signal resume_button_pressed

#player
signal player_death
signal player_hp_changed

#signal_names so I wouldn't have to change it everywhere
const START_BUTTON_PRESSED = "start_button_pressed"
const RESUME_BUTTON_PRESSED = "resume_button_pressed"

const PLAYER_DEATH = "player_death"
const PLAYER_HP_CHANGED = "player_hp_changed"

