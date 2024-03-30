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

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	if pnj == "Tezcatlipoca":
		set_hidden_menu(false)

func _on_hidden_menu_changed(val: bool):
	super._on_hidden_menu_changed(val)
	if hidden_menu:
		EVENTS.emit_signal("pnj_traid_finished", "Tezcatlipoca")
