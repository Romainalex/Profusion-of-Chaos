extends Commerce
class_name UpdateSpell

var hidden_update_spell : bool = true


signal hidden_update_spell_changed(value)

#### ACCESSORS ####

func set_hidden_update_spell(val: bool) -> void:
	if val != hidden_update_spell:
		hidden_update_spell = val
		print(hidden_update_spell)
		emit_signal("hidden_update_spell_changed", hidden_update_spell)
func get_hidden_update_spell() -> bool: return hidden_update_spell



#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	visible_position = hidden_position - panel.size * Vector2.UP
	connect("hidden_update_spell_changed", Callable(self, "_on_hidden_update_spell_changed"))



#### LOGICS ####




#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if hidden_update_spell:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_update_spell(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_interaction(pnj: String) -> void:
	if pnj == "Tezcatlipoca":
		set_hidden_update_spell(false)

func _on_hidden_update_spell_changed(_val: bool) -> void:
	_animation(!hidden_update_spell)
	get_tree().paused = !hidden_update_spell
