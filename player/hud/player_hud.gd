extends CanvasLayer

var pausable = PausableNodeBehaviour.new(self)

var conversation_in_progress = false

func _ready():
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, conditional_show_hud)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, show_hud)

func hide_hud(arg: String = ""):
	if (arg.length() > 0):
		conversation_in_progress = true
	hide()
	pausable.set_pause(true)

func conditional_show_hud():
	show_hud(conversation_in_progress)

func show_hud(conversation_in_progress: bool = false):
	if(!conversation_in_progress):
		pausable.set_pause(false)
		show()
		self.conversation_in_progress = false	
