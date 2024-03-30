extends Control
class_name Menu

var hidden_menu : bool = true

var tween : Tween

signal hidden_menu_changed(val)

#### SET-GET ####

func set_hidden_menu(val: bool) -> void:
	if val != hidden_menu:
		hidden_menu = val
		emit_signal("hidden_menu_changed", hidden_menu)
func get_hidden_menu() -> bool: return hidden_menu


#### BUILT-IN ####

func _ready() -> void:
	connect("hidden_menu_changed", Callable(self, "_on_hidden_menu_changed"))

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_menu(!hidden_menu)
	
	if hidden_menu:
		return
	
	if Input.is_action_just_pressed("Back_action"):
		set_hidden_menu(true)



#### LOGICS ####

func _animation(_appear: bool) -> void:
	pass



#### SIGNAL RESPONSES ####

func _on_hidden_menu_changed(_val: bool) -> void:
	_animation(!hidden_menu)
	get_tree().paused = !hidden_menu


