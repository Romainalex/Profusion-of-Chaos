extends Commerce
class_name ChangeSpell


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.UP



#### LOGICS ####




#### INPUTS ####

func _input(event: InputEvent) -> void:
	
	
	super._input(event)


#### SIGNAL RESPONSES ####

func _on_visibility_changed() -> void:
	super._on_visibility_changed()
	if !visible:
		EVENTS.emit_signal("pnj_traid_finished", "Tezcatlipoca")
