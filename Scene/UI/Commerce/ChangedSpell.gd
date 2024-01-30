extends Commerce
class_name ChangeSpell


var hidden_change_spell : bool = true

signal hidden_change_spell_changed(value)

#### ACCESSORS ####

func set_hidden_change_spell(val: bool) -> void:
	if val != hidden_change_spell:
		hidden_change_spell = val
		print(hidden_change_spell)
		emit_signal("hidden_change_spell_changed", hidden_change_spell)
func get_hidden_change_spell() -> bool: return hidden_change_spell



#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.UP
	connect("hidden_change_spell_changed", Callable(self, "_on_hidden_change_spell_changed"))



#### LOGICS ####




#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if hidden_change_spell:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_change_spell(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	if pnj == "Tezcatlipoca":
		set_hidden_change_spell(false)

func _on_hidden_change_spell_changed(_val: bool):
	_animation(!hidden_change_spell)
	get_tree().paused = !hidden_change_spell
	if hidden_change_spell:
		EVENTS.emit_signal("pnj_traid_finished", "Tezcatlipoca")
