extends Actor
class_name PNJ



@onready var interaction_sprite = $InteractingSprite

@export var pnj_data : PNJData = null


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	state_machine.connect("state_changed", Callable(self, "_on_StateMachine_state_changed"))
	EVENTS.connect("pnj_traid_finished", Callable(self, "_on_EVENTS_pnj_traid_finished"))
	EVENTS.connect("input_scheme_changed", Callable(self, "_on_EVENTS_input_scheme_changed"))
	
	interaction_sprite.set_frame(GAME.INPUT_SCHEME)
	interaction_sprite.set_visible(false)



#### LOGICS ####


func hurt(_damage_data: DamageData, _crit: float) -> void:
	pass

func interact() -> void:
	state_machine.set_state("Traid")


#### SIGNAL RESPONSES ####

func _on_StateMachine_state_changed(_new_state: Object) -> void:
	_update_animation()

func _on_InteractionArea_body_entered(body) -> void:
	if body is Character:
		interaction_sprite.set_visible(true)

func _on_InteractionArea_body_exited(body) -> void:
	if body is Character:
		interaction_sprite.set_visible(false)

func _on_EVENTS_pnj_traid_finished(pnj_name: String) -> void:
	if pnj_name == pnj_data.name:
		state_machine.set_state("Work")

func _on_EVENTS_input_scheme_changed() -> void:
	interaction_sprite.set_frame(GAME.INPUT_SCHEME)
