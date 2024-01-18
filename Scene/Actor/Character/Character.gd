extends Actor
class_name Character


@onready var attack_behaviour = $AttackBehaviour

var attack_array : Array = ["AttackPrincipal", "AttackSecondaire", "AttackSpecial1", "AttackSpecial2"]

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	pass


#### INPUT ####

# Gère les inputs du jeu
func _input(_event: InputEvent) -> void:
	var dir = Vector2(
		int(Input.is_action_pressed("Right_action")) - int(Input.is_action_pressed("Left_action")),
		int(Input.is_action_pressed("Down_action")) - int(Input.is_action_pressed("Up_action"))
	)
	
	set_moving_direction(dir.normalized())
	
	if Input.is_action_just_pressed("Interact_action"):
		_interacting_attempt()
	
	# Les inputs d'attaques
	if Input.is_action_just_pressed("AttackPrincipal_action"): 
		state_machine.set_state("AttackPrincipal")
	if Input.is_action_just_pressed("AttackSecondaire_action"): 
		state_machine.set_state("AttackSecondaire")
	if Input.is_action_just_pressed("AttackSpecial1_action"): 
		state_machine.set_state("AttackSpecial1")
	if Input.is_action_just_pressed("AttackSpecial2_action"): 
		state_machine.set_state("AttackSpecial2")
	
	_update_state()
	


#### LOGIC ####

func _update_state() -> void:
	if not (state_machine.get_state_name() in attack_array):
		if Input.is_action_pressed("Esquive_action"):
			state_machine.set_state("Esquive")
		elif moving_direction == Vector2.ZERO:
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Move")

# Lance une tentative d'intéraction et retourne vrai si l'intéraction a été effectué, faux sinon
func _interacting_attempt() -> bool:
	var bodies_array = interaction_area.get_overlapping_bodies()
	var interaction_success : bool = false
	for body in bodies_array:
		if body.has_method("interact"):
			body.interact()
			interaction_success = true
	return interaction_success

func hurt(damage: int) -> void:
	if state_machine.get_state_name() != "Esquive":
		super.hurt(damage)

# Met à jour l'animation en se basant sur l'état courant et facing_direction
func _update_animation() -> void:
	var state = state_machine.get_state_name
	if state in attack_array:
		attack_behaviour.update_attack_animation(state)
	else:
		super._update_animation()


#### SIGNAL RESPONSES ####

func _on_state_changed(_new_state: Object) -> void:
	if state_machine.get_previous_state_name() in attack_array:
		_update_state()
	
	super._on_state_changed(state_machine.get_state())
	
func _on_pv_changed(new_pv: int) -> void:
	super._on_pv_changed(new_pv)
	
	EVENTS.emit_signal("character_pv_changed", new_pv, max_pv)

func _on_Sprite_animation_finished() -> void:
	if "Esquive".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Idle")
	else:
		super._on_Sprite_animation_finished()