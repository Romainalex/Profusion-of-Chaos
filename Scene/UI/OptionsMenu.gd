extends Control
class_name OptionsMenu

var language_codes = ["fr_FR","en_EN"]

@onready var controller_panel = $ControllerPanel
@onready var main_panel = $MainPanel

@onready var keyboard_mouse_scheme_button = $ControllerPanel/InputSchemePanel/ButtonInputSchemesContainer/KeyboardMouseScheme
@onready var xbox_scheme_button = $ControllerPanel/InputSchemePanel/ButtonInputSchemesContainer/XboxScheme
@onready var dualshock_scheme_button = $ControllerPanel/InputSchemePanel/ButtonInputSchemesContainer/DualshockScheme
@onready var keyboard_mouse_scheme = $ControllerPanel/Panel/KeyMouseScrollContainer
@onready var gamepad_scheme = $ControllerPanel/Panel/GamepadScrollContainer
@onready var scrollbar :ScrollBar

@onready var language_button = $MainPanel/ScrollContainer/VBoxContainer/HBoxContainer/LanguageOptionButton
@onready var controller_button = $MainPanel/ScrollContainer/VBoxContainer/ControllerButton

var menu_selected

signal return_menu(previous_menu)

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	connect("visibility_changed", Callable(self,"_on_visibility_changed"))
	main_panel.connect("visibility_changed", Callable(self,"_on_MainPanel_visibility_changed"))
	
	controller_panel.connect("visibility_changed", Callable(self,"_on_ControllerPanel_visibility_changed"))
	keyboard_mouse_scheme_button.connect("focus_entered", Callable(self, "_on_KeyboardMouseSchemeButton_focus_entered"))
	xbox_scheme_button.connect("focus_entered", Callable(self, "_on_XboxSchemeButton_focus_entered"))
	dualshock_scheme_button.connect("focus_entered", Callable(self, "_on_DualshockSchemeButton_focus_entered"))
	keyboard_mouse_scheme_button.connect("focus_exited", Callable(self, "_on_KeyboardMouseSchemeButton_focus_exited"))
	xbox_scheme_button.connect("focus_exited", Callable(self, "_on_XboxSchemeButton_focus_exited"))
	dualshock_scheme_button.connect("focus_exited", Callable(self, "_on_DualshockSchemeButton_focus_exited"))
	
	language_button.connect("item_selected", Callable(self, "_on_LanguageOptionButton_item_selected"))
	controller_button.connect("pressed", Callable(self, "_on_ControllerButton_pressed"))
	
	
	set_visible(false)
	keyboard_mouse_scheme.set_visible(false)
	gamepad_scheme.set_visible(false)



#### LOGICS ####

func _update_image_gamepad(input_scheme: int) -> void:
	var node_array
	if input_scheme != GAME.INPUT_SCHEMES.KEYBOARD_AND_MOUSE:
		node_array = $ControllerPanel/Panel/GamepadScrollContainer/GridContainer.get_children()
	else:
		node_array = $ControllerPanel/Panel/KeyMouseScrollContainer/GridContainer.get_children()
	
	for node in node_array:
		if node is TextureRect:
			node.texture.set_region(Rect2(64*input_scheme, 0,64,64))

func _update_scrollbar(movement: int):
	if keyboard_mouse_scheme_button.has_focus():
		keyboard_mouse_scheme.scroll_vertical = clampf(scrollbar.value + movement, scrollbar.min_value, scrollbar.max_value)
	else:
		gamepad_scheme.scroll_vertical = clampf(scrollbar.value + movement, scrollbar.min_value, scrollbar.max_value)

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if !visible:
		return
	
	if controller_panel.visible:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("Menu_action"):
			Util.set_ui_visible(controller_panel, false)
			Util.set_ui_visible(main_panel, true)
		if Input.is_action_pressed("ui_down"):
			_update_scrollbar(10)
		if Input.is_action_pressed("ui_up"):
			_update_scrollbar(-10)
	elif main_panel.visible:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("Menu_action"):
			emit_signal("return_menu", self)


#### SIGNAL RESPONSES ####

func _on_visibility_changed() -> void:
	if visible:
		Util.set_ui_visible(main_panel, true)

func _on_MainPanel_visibility_changed() -> void:
	if visible:
		language_button.select(language_codes.find(TranslationServer.get_locale()))
		language_button.grab_focus()

func _on_ControllerPanel_visibility_changed() -> void:
	if visible:
		match GAME.INPUT_SCHEME:
			GAME.INPUT_SCHEMES.KEYBOARD_AND_MOUSE:
				keyboard_mouse_scheme_button.grab_focus()
				keyboard_mouse_scheme.set_visible(true)
			GAME.INPUT_SCHEMES.XBOX:
				xbox_scheme_button.grab_focus()
				_update_image_gamepad(1)
				gamepad_scheme.set_visible(true)
			GAME.INPUT_SCHEMES.DUALSHOCK:
				dualshock_scheme_button.grab_focus()
				_update_image_gamepad(2)
				gamepad_scheme.set_visible(true)

func _on_KeyboardMouseSchemeButton_focus_entered() -> void:
	_update_image_gamepad(GAME.INPUT_SCHEMES.KEYBOARD_AND_MOUSE)
	keyboard_mouse_scheme.set_visible(true)
	scrollbar = keyboard_mouse_scheme.get_v_scroll_bar()

func _on_XboxSchemeButton_focus_entered() -> void:
	_update_image_gamepad(GAME.INPUT_SCHEMES.XBOX)
	gamepad_scheme.set_visible(true)
	scrollbar = gamepad_scheme.get_v_scroll_bar()

func _on_DualshockSchemeButton_focus_entered() -> void:
	_update_image_gamepad(GAME.INPUT_SCHEMES.DUALSHOCK)
	gamepad_scheme.set_visible(true)
	scrollbar = gamepad_scheme.get_v_scroll_bar()

func _on_KeyboardMouseSchemeButton_focus_exited() -> void:
	Util.set_ui_visible(keyboard_mouse_scheme, false)

func _on_XboxSchemeButton_focus_exited() -> void:
	Util.set_ui_visible(gamepad_scheme, false)

func _on_DualshockSchemeButton_focus_exited() -> void:
	Util.set_ui_visible(gamepad_scheme, false)

func _on_LanguageOptionButton_item_selected(index: int) -> void:
	TranslationServer.set_locale(language_codes[index])

func _on_ControllerButton_pressed() -> void:
	Util.set_ui_visible(main_panel, false)
	Util.set_ui_visible(controller_panel,true)
