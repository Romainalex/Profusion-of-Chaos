extends Menu
class_name Commerce



@onready var panel = $Panel
@onready var hidden_position = position
@onready var visible_position = hidden_position - panel.size * Vector2.ZERO


#### ACCESSORS ####




#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	EVENTS.connect("pnj_traid_started", Callable(self, "_on_EVENTS_pnj_traid_started"))


#### INPUTS ####

func _input(event: InputEvent) -> void:
	
	if hidden_menu:
		return
	
	super._input(event)




#### LOGICS ####

func _animation(appear: bool) -> void:
	var from = position
	var to = visible_position if appear else hidden_position
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", to, 0.7).from(from)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(_pnj: String) -> void:
	pass

