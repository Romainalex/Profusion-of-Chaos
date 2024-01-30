extends Commerce
class_name UpgradeWeapon



var hidden_upgrade_weapon : bool = true


signal hidden_upgrade_weapon_changed(value)


#### ACCESSORS ####

func set_hidden_update_weapon(val: bool) -> void:
	if val != hidden_upgrade_weapon:
		hidden_upgrade_weapon = val
		print(hidden_upgrade_weapon)
		emit_signal("hidden_upgrade_weapon_changed", hidden_upgrade_weapon)
func get_hidden_upgrade_weapon() -> bool: return hidden_upgrade_weapon


#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.DOWN
	connect("hidden_upgrade_weapon_changed", Callable(self, "_on_hidden_upgrade_weapon_changed"))



#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if hidden_upgrade_weapon:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_update_weapon(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	if pnj == "Hephaistos":
		set_hidden_update_weapon(false)

func _on_hidden_upgrade_weapon_changed(_val: bool) -> void:
	_animation(!hidden_upgrade_weapon)
	get_tree().paused = !hidden_upgrade_weapon
	if hidden_upgrade_weapon:
		EVENTS.emit_signal("pnj_traid_finished", "Hephaistos")

