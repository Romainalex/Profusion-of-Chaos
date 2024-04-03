extends Control
class_name MainMenu

@onready var buttons_container = $ButtonsContainer
@onready var continue_button = $ButtonsContainer/ContinueButton
@onready var new_game_button = $ButtonsContainer/NewGameButton
@onready var options_button = $ButtonsContainer/OptionsButton
@onready var credits_button = $ButtonsContainer/CreditsButton
@onready var quit_button = $ButtonsContainer/QuitButton

@onready var credits = $Credits
@onready var options = $OptionsMenu


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	continue_button.connect("pressed", Callable(self, "_on_ContinueButton_pressed"))
	new_game_button.connect("pressed", Callable(self, "_on_NewGameButton_pressed"))
	options_button.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	credits_button.connect("pressed", Callable(self, "_on_CreditsButton_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	buttons_container.connect("visibility_changed", Callable(self, "_on_ButtonsContainer_visibility_changed"))
	credits.connect("return_menu", Callable(self, "_on_return_menu"))
	options.connect("return_menu", Callable(self, "_on_return_menu"))
	
	continue_button.grab_focus()
	



#### LOGICS ####



#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	
	if !visible:
		return
	
	


#### SIGNAL RESPONSES ####

func _on_ContinueButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Dungeon/Prototype.tscn")

func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Dungeon/Prototype.tscn")

func _on_OptionsButton_pressed() -> void:
	buttons_container.set_visible(false)
	options.set_visible(true)

func _on_CreditsButton_pressed() -> void:
	buttons_container.set_visible(false)
	credits.set_visible(true)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_ButtonsContainer_visibility_changed() -> void:
	if buttons_container.visible:
		continue_button.grab_focus()

func _on_return_menu(previous_menu: Control) -> void:
	buttons_container.set_visible(true)
	previous_menu.set_visible(false)
