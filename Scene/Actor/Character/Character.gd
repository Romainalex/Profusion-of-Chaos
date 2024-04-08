extends Actor
class_name Character


@onready var attack_behaviour = $AttackBehaviour
@onready var interaction_area = $InteractionArea
@onready var dodge_raycast = $RayCast2D

@export var dodge_data : DodgeData = null

var attack_array = ["AttackPrincipal", "AttackSecondaire", "AttackSpecial1", "AttackSpecial2"]

enum ATTACK {
	PRINCIPAL,
	SECONDAIRE,
	SPECIAL1,
	SPECIAL2
}

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	attack_behaviour.connect("attack_finished", Callable(self, "_on_AttackBehaviour_attack_finished"))
	attack_behaviour.connect("hooked", Callable(self, "_on_AttackBehaviour_hooked"))
	interaction_area.connect("body_entered", Callable(self, "_on_InteractionArea_body_entered"))
	interaction_area.connect("body_exited", Callable(self, "_on_InteractionArea_body_exited"))
	


#### INPUT ####

## Gère les inputs du jeu
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
	
	if Input.is_action_just_released("AttackPrincipal_action"):
		attack_behaviour.stop_attack_behaviour(ATTACK.PRINCIPAL, get_facing_direction())
	if Input.is_action_just_released("AttackSecondaire_action"):
		attack_behaviour.stop_attack_behaviour(ATTACK.SECONDAIRE, get_facing_direction())
	if Input.is_action_just_released("AttackSpecial1_action"):
		attack_behaviour.stop_attack_behaviour(ATTACK.SPECIAL1, get_facing_direction())
	if Input.is_action_just_released("AttackSpecial2_action"):
		attack_behaviour.stop_attack_behaviour(ATTACK.SPECIAL2, get_facing_direction())
	
	_update_state()
	


#### LOGIC ####

func _update_state() -> void:
	if not (state_machine.get_state_name() in attack_array):
		if Input.is_action_just_pressed("Esquive_action"):
			state_machine.set_state("Dodge")
		elif moving_direction == Vector2.ZERO:
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Move")

##Update interaction_area_direction based on [member Actor.facing_direction]
func _update_interaction_area_direction() -> void:
	var angle = facing_direction.angle()
	
	interaction_area.set_rotation_degrees(rad_to_deg(angle) - 90)

func _update_animation() -> void:
	if not(state_machine.get_state_name() == "Hooked"):
		super._update_animation()

##Lance une tentative d'intéraction et retourne vrai si l'intéraction a été effectué, faux sinon
func _interacting_attempt() -> bool:
	var bodies_array = interaction_area.get_overlapping_bodies()
	var interaction_success : bool = false
	for body in bodies_array:
		if body.has_method("interact"):
			body.interact()
			interaction_success = true
	return interaction_success

func hurt(damage_data: DamageData, crit: float) -> void:
	if state_machine.get_state_name() != "Dodge":
		super.hurt(damage_data, crit)


func _update_dodge_raycast() -> void:
	dodge_raycast.set_target_position(Vector2(0, dodge_data.dodge_distance))
	var vector_direction = Util.give_angle_direction(self, facing_direction)
	
	dodge_raycast.set_rotation_degrees(rad_to_deg(vector_direction.normalized().angle()) - 90)

func _check_collision() -> Vector2:
	var collision_point
	var point_to_dodge = global_position + (dodge_data.dodge_distance * Util.give_angle_direction(self, facing_direction).normalized())
	if dodge_raycast.is_colliding():
		collision_point = dodge_raycast.get_collision_point()
		point_to_dodge = collision_point
	return point_to_dodge


func _dodge() -> void:
	_update_dodge_raycast()
	var tween = create_tween()
	var point_to_dodge = _check_collision()
	
	tween.tween_property(self, "position", point_to_dodge, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	state_machine.set_state("Idle")


#### SIGNAL RESPONSES ####

func _on_facing_direction_changed() -> void:
	super._on_facing_direction_changed()
	_update_interaction_area_direction()

func _on_state_changed(_new_state: Object) -> void:
	if state_machine.get_previous_state_name() in attack_array:
		_update_state()
	
	super._on_StateMachine_state_changed(state_machine.get_state())
	
func _on_pv_changed(new_pv: int) -> void:
	super._on_pv_changed(new_pv)
	
	EVENTS.emit_signal("character_pv_changed", new_pv, max_pv)

func _on_Sprite_animation_finished() -> void:
	if "Esquive".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Idle")
	else:
		super._on_AnimatedSprite_animation_finished()

func _on_AttackBehaviour_attack_finished(_attack: Object) -> void:
	animated_sprite.set_visible(true)
	state_machine.set_state("Idle")

func _on_AttackBehaviour_hooked(hooked_position: Vector2, time_to_throw: float, time_hooked: float) -> void:
	await get_tree().create_timer(time_to_throw).timeout
	animated_sprite.set_visible(true)
	state_machine.set_state("Hooked")
	tween = create_tween()
	tween.tween_property(self, "position", hooked_position, time_hooked)
	await get_tree().create_timer(time_hooked).timeout
	state_machine.set_state("Idle")
