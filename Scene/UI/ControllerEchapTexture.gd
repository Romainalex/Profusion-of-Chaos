extends TextureRect
class_name BackControllerTexture




func _ready() -> void:
	EVENTS.connect("input_scheme_changed", Callable(self, "_on_EVENTS_input_scheme_changed"))
	texture.set_region(Rect2(64*GAME.INPUT_SCHEME, 0,64,64))



func _on_EVENTS_input_scheme_changed() -> void:
	texture.set_region(Rect2(64*GAME.INPUT_SCHEME, 0,64,64))
