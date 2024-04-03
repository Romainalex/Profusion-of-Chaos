extends ColorRect
class_name BlackVell

@onready var parent_path = get_parent().get_path()

var tween : Tween


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("start_blackvell_animation", Callable(self, "_on_EVENTS_start_blackvell_animation"))
	
	visible = false


#### LOGICS ####


func fade(fade_in: bool) -> void:
	if fade_in:
		visible = fade_in
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var to = Color(0.0, 0.0, 0.0, 0.5) if fade_in else Color(0.0, 0.0, 0.0, 0.0)
	
	tween.tween_property(self, "color", to, 0.5).from(color)
	if !fade_in:
		visible = fade_in


#### INPUTS ####




#### SIGNAL RESPONSES ####

func start_blackvell_animation(show_blackvell: bool) -> void:
	fade(show_blackvell)
