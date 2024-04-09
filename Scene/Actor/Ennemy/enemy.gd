extends Actor
class_name Ennemy

@onready var behavior_tree = $BehaviorTree
@onready var chase_area = $ChaseArea
@onready var attack_area = $AttackArea
@onready var attack_hitbox = $AttackHitbox

@export var dammage_data : DamageData = null
@export_range(0.0, 100.0, 0.25) var crit_rate : float = 0.0

var target : Node2D = null
var path : Array = []
var pathfinder : Pathfinder = null

var target_in_chase_area : bool = false
var target_in_attack_area : bool = false

signal target_in_chase_area_changed
signal target_in_attack_area_changed
signal move_path_finished


#### ACCESSORS ####

func set_target_in_chase_area(value: bool) -> void:
	if value != target_in_chase_area:
		target_in_chase_area = value
		emit_signal("target_in_chase_area_changed", target_in_chase_area)

func set_target_in_attack_area(value: bool) -> void:
	if value != target_in_attack_area:
		target_in_attack_area = value
		emit_signal("target_in_attack_area_changed", target_in_attack_area)

#### BUILT-IN ####

func _ready() -> void :
	super._ready()
	chase_area.connect("body_entered", Callable(self, "_on_ChaseArea_body_entered"))
	chase_area.connect("body_exited", Callable(self, "_on_ChaseArea_body_exited"))
	attack_area.connect("body_entered",  Callable(self, "_on_AttackArea_body_entered"))
	attack_area.connect("body_exited",  Callable(self, "_on_AttackArea_body_exited"))
	connect("target_in_chase_area_changed", Callable(self, "_on_target_in_chase_area_changed"))
	connect("target_in_attack_area_changed", Callable(self, "_on_target_in_attack_area_changed"))

#### LOGIC ####

func _update_target() -> void:
	if !target_in_attack_area && !target_in_chase_area:
		target = null

func _update_behavior_state() -> void:
	if can_attack():
		behavior_tree.set_state("Attack")
	elif target_in_chase_area:
		behavior_tree.set_state("Chase")
	else:
		behavior_tree.set_state("Wander")

func update_move_path(dest: Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)

func _update_attack_hitbox_direction() -> void:
	var angle = facing_direction.angle()
	attack_hitbox.set_rotation_degrees(rad_to_deg(angle) - 90)

# A appeler dans le physics_process
func move_along_path(delta : float) -> void:
	if path.is_empty():
		return
	
	# Je veux qui tu trouves la direction pour aller au premier point du chemin
	var direction = global_position.direction_to(path[0])
	
	# Maintenant je veux la distance
	var distance = global_position.distance_to(path[0])
	
	set_moving_direction(direction)
	
	if distance <= speed * delta:
		# On arrive sur le prochain point
		move_and_collide(direction * distance)
		path.pop_front()
		
		if path.is_empty():
			emit_signal("move_path_finished")
	else:
		# On va vers le prochain point
		move_and_collide(direction * speed * delta)

func can_attack() -> bool:
	return !$BehaviorTree/Attack.is_cooldown_running() && target_in_attack_area

func _attack_effect() -> void:
	for body in attack_hitbox.get_overlapping_bodies():
		if body in get_tree().get_nodes_in_group("Character"):
			body.hurt()


#### SIGNAL RESPONSE ####


# Masquage de la fonction _on_moving_direction_changed() de Actor
func _on_moving_direction_changed() -> void:
	face_direction(moving_direction)

func _on_ChaseArea_body_entered(body : Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(true)
		target = body

func _on_ChaseArea_body_exited(body : Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(false)

func _on_AttackArea_body_entered(body : Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(true)
		target = body

func _on_AttackArea_body_exited(body : Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(false)

func _on_target_in_chase_area_changed(_value: bool) -> void:
	_update_target()
	_update_behavior_state()

func _on_target_in_attack_area_changed(_value: bool) -> void:
	_update_target()
	if target_in_attack_area:
		_update_behavior_state()

func _on_StateMachine_state_changed(state) -> void:
	if state_machine == null:
		return
	_update_animation()
	if state_machine.previous_state == $StateMachine/Attack or state_machine.previous_state == $StateMachine/Hurt:
		_update_behavior_state()
	
	if state.name == "Attack":
		face_position(target.global_position)

func _on_facing_direction_changed() -> void:
	super._on_facing_direction_changed()
	_update_attack_hitbox_direction()

func _on_AnimatedSprite_frame_changed() -> void:
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		if animated_sprite.get_frame() == 1:
			_attack_effect()
