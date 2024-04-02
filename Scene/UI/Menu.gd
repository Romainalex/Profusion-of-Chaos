extends Control
class_name Menu

var hidden_menu : bool = true

var tween : Tween


#### SET-GET ####




#### BUILT-IN ####

func _ready() -> void:
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))
	

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if !visible:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		_animation(false)
		await get_tree().create_timer(1).timeout
		set_visible(false)

	if Input.is_action_just_pressed("ui_cancel"):
		_animation(false)
		await get_tree().create_timer(1).timeout
		set_visible(true)



#### LOGICS ####

func _animation(_appear: bool) -> void:
	pass



#### SIGNAL RESPONSES ####

func _on_visibility_changed() -> void:
	_animation(visible)
	get_tree().paused = visible


