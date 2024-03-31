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
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))
	buttons_container.connect("visibility_changed", Callable(self, "_on_ButtonContainer_visibility_changed"))
	options.connect("return_menu", Callable(self, "_on_return_menu"))
	
	set_visible(false)
	buttons_container.set_visible(false)
	options.set_visible(false)

#### INPUTS ####

func _input(event: InputEvent) -> void:
	super._input(event)
	

	



#### LOGICS ####

func _animation(appear: bool) -> void:
	set_visible(appear)



#### SIGNAL RESPONSES ####

func _on_hidden_menu_changed(val: bool) -> void:
	super._on_hidden_menu_changed(val)

func _on_ContinueButton_pressed() -> void:
	set_hidden_menu(!hidden_menu)

func _on_OptionsButton_pressed() -> void:
	buttons_container.set_visible(false)
	options.set_visible(true)

func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/UI/MainMenu.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		buttons_container.set_visible(true)

func _on_ButtonContainer_visibility_changed() -> void:
	if buttons_container.visible:
		continue_button.grab_focus()

func _on_return_menu(previous_menu: Control) -> void:
	previous_menu.set_visible(false)
	buttons_container.set_visible(true)

