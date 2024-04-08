extends Control
class_name GameOverUI

@onready var button = $Button


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	
	button.connect("pressed", Callable(self, "on_Button_pressed"))
	
	set_visible(false)



#### LOGICS ####

func start_game_over() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.5).timeout
	Util.set_ui_visible(self, true)
	button.grab_focus()


#### INPUTS ####




#### SIGNAL RESPONSES ####


func on_Button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Dungeon/Prototype.tscn")
