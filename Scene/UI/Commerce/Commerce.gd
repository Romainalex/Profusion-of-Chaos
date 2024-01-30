extends Control
class_name Commerce



@onready var panel = $Panel
@onready var hidden_position = position
@onready var visible_position = hidden_position - panel.size * Vector2.ZERO

var tween : Tween



#### ACCESSORS ####




#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("pnj_traid_started", Callable(self, "_on_EVENTS_pnj_traid_started"))


func _animation(appear: bool) -> void:
	var from = position
	var to = visible_position if appear else hidden_position
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", to, 0.7).from(from)



#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(_pnj: String) -> void:
	pass

