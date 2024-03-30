extends Menu
class_name MenuPause



#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	$VBoxContainer/ContinueButton.connect("pressed", Callable(self, "_on_ContinueButton_pressed"))
	$VBoxContainer/OptionsButton.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	$VBoxContainer/MainMenuButton.connect("pressed", Callable(self, "_on_MainMenuButton_pressed"))
	$VBoxContainer/QuitButton.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	
	set_visible(false)

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
	pass

func _on_MainMenuButton_pressed() -> void:
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

