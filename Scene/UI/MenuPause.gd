extends Menu
class_name MenuPause

@onready var buttons_container = $ButtonsContainer
@onready var continue_button = $ButtonsContainer/ContinueButton
@onready var options_button = $ButtonsContainer/OptionsButton
@onready var main_menu_button = $ButtonsContainer/MainMenuButton
@onready var quit_button = $ButtonsContainer/QuitButton

@onready var options = $OptionsMenu

#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	continue_button.connect("pressed", Callable(self, "_on_ContinueButton_pressed"))
	options_button.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_MainMenuButton_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	buttons_container.connect("visibility_changed", Callable(self, "_on_ButtonContainer_visibility_changed"))
	options.connect("return_menu", Callable(self, "_on_return_menu"))
	
	set_visible(false)
	buttons_container.set_visible(false)
	options.set_visible(false)

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if !visible:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_visible(false)

	



#### LOGICS ####

func _animation(_appear: bool) -> void:
	pass



#### SIGNAL RESPONSES ####



func _on_ContinueButton_pressed() -> void:
	set_visible(false)

func _on_OptionsButton_pressed() -> void:
	buttons_container.set_visible(false)
	options.set_visible(true)

func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/UI/MainMenu.tscn")
	queue_free()

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_visibility_changed() -> void:
	get_tree().paused = visible
	if visible:
		buttons_container.set_visible(true)

func _on_ButtonContainer_visibility_changed() -> void:
	if buttons_container.visible:
		continue_button.grab_focus()

func _on_return_menu(previous_menu: Control) -> void:
	previous_menu.set_visible(false)
	buttons_container.set_visible(true)

