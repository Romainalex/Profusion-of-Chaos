extends Control
class_name GameOverUI

@onready var button = $Button

@export var time : float = 0.0

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	
	button.connect("pressed", Callable(self, "on_Button_pressed"))
	
	set_visible(false)



#### LOGICS ####

func start_game_over() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(time).timeout
	get_tree().paused = true
	Util.set_ui_visible(self, true)
	
	await get_tree().create_timer(1.0).timeout
	button.grab_focus()



#### INPUTS ####




#### SIGNAL RESPONSES ####


func on_Button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Dungeon/Prototype.tscn")
