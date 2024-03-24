extends Actor
class_name PNJ



@onready var interaction_sprite = $InteractingSprite

@export var pnj_data : PNJData = null


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	state_machine.connect("state_changed", Callable(self, "_on_StateMachine_state_changed"))
	interaction_area.connect("body_entered", Callable(self, "_on_InteractionArea_body_entered"))
	interaction_area.connect("body_exited", Callable(self, "_on_InteractionArea_body_exited"))
	EVENTS.connect("pnj_traid_finished", Callable(self, "_on_EVENTS_pnj_traid_finished"))



#### LOGICS ####

# Masquage de la fonction hurt() de Actor.gd pour rendre les PNJ invulnérable
func hurt(_damage_data: DamageData) -> void:
	pass

func interact() -> void:
	state_machine.set_state("Traid")


#### SIGNAL RESPONSES ####

func _on_StateMachine_state_changed(_new_state: Object) -> void:
	_update_animation()

func _on_InteractionArea_body_entered(body) -> void:
	if body is Character:
		interaction_sprite.visible = true

func _on_InteractionArea_body_exited(body) -> void:
	if body is Character:
		interaction_sprite.visible = false

func _on_EVENTS_pnj_traid_finished(pnj_name: String) -> void:
	if pnj_name == pnj_data.pnj_name:
		state_machine.set_state("Work")

