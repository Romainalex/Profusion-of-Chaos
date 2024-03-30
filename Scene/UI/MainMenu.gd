extends Control
class_name MainMenu




#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	$VBoxContainer/ContinueButton.connect("pressed", Callable(self, "_on_ContinueButton_pressed"))
	$VBoxContainer/NewGameButton.connect("pressed", Callable(self, "_on_NewGameButton_pressed"))
	$VBoxContainer/OptionsButton.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	$VBoxContainer/CreditsButton.connect("pressed", Callable(self, "_on_CreditsButton_pressed"))
	$VBoxContainer/QuitButton.connect("pressed", Callable(self, "_on_QuitButton_pressed"))



#### LOGICS ####




#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_ContinueButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Level/hub.tscn")

func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Level/hub.tscn")

func _on_OptionsButton_pressed() -> void:
	pass

func _on_CreditsButton_pressed() -> void:
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
