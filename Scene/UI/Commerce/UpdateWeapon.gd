extends Commerce
class_name UpdateWeapon



var hidden_update_weapon : bool = true


signal hidden_update_weapon_changed(value)


#### ACCESSORS ####

func set_hidden_update_weapon(val: bool) -> void:
	if val != hidden_update_weapon:
		hidden_update_weapon = val
		print(hidden_update_weapon)
		emit_signal("hidden_update_weapon_changed", hidden_update_weapon)
func get_hidden_update_weapon() -> bool: return hidden_update_weapon


#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.DOWN
	connect("hidden_update_weapon_changed", Callable(self, "_on_hidden_update_weapon_changed"))



#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if hidden_update_weapon:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_update_weapon(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_interaction(pnj: String) -> void:
	if pnj == "Hephaistos":
		set_hidden_update_weapon(false)

func _on_hidden_update_weapon_changed(_val: bool) -> void:
	_animation(!hidden_update_weapon)
	get_tree().paused = !hidden_update_weapon

