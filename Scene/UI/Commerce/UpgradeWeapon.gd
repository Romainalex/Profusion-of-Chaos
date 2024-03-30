extends Commerce
class_name UpgradeWeapon






#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.DOWN



#### INPUTS ####

func _input(event: InputEvent) -> void:
	super._input(event)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	if pnj == "Héphaistos":
		set_hidden_menu(false)

func _on_hidden_menu_changed(val: bool) -> void:
	super._on_hidden_menu_changed(val)
	if hidden_menu:
		EVENTS.emit_signal("pnj_traid_finished", "Héphaistos")

