extends Commerce
class_name UpgradeSpell

var hidden_upgrade_spell : bool = true


signal hidden_upgrade_spell_changed(value)

#### ACCESSORS ####

func set_hidden_upgrade_spell(val: bool) -> void:
	if val != hidden_upgrade_spell:
		hidden_upgrade_spell = val
		print(hidden_upgrade_spell)
		emit_signal("hidden_upgrade_spell_changed", hidden_upgrade_spell)
func get_hidden_upgrade_spell() -> bool: return hidden_upgrade_spell



#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.UP
	connect("hidden_upgrade_spell_changed", Callable(self, "_on_hidden_upgrade_spell_changed"))



#### LOGICS ####




#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if hidden_upgrade_spell:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_upgrade_spell(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	if pnj == "Tezcatlipoca":
		set_hidden_upgrade_spell(false)

func _on_hidden_upgrade_spell_changed(_val: bool) -> void:
	_animation(!hidden_upgrade_spell)
	get_tree().paused = !hidden_upgrade_spell
	if hidden_upgrade_spell:
		EVENTS.emit_signal("pnj_traid_finished", "Tezcatlipoca")
