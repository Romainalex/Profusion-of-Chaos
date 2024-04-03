extends Actor
class_name Ennemy

@onready var behavior_tree = $BehaviorTree
@onready var chase_area = $ChaseArea
@onready var attack_area = $AttackArea

var target : Node2D = null
var path : Array = []

var target_in_chase_area : bool = false
var target_in_attack_area : bool = false

signal target_in_chase_area_changed
signal target_in_attack_area_changed


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
	if target_in_attack_area:
		behavior_tree.set_state("Attack")
	
	elif target_in_chase_area:
		behavior_tree.set_state("Chase")
	
	else:
		behavior_tree.set_state("Wander")

func update_move_path(dest: Vector2) -> void:
	path = [dest]

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
		path.remove_at(0)
	else:
		# On va vers le prochain point
		move_and_collide(direction * distance * speed * delta)

#### SIGNAL RESPONSE ####

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

func _on_target_in_chase_area_changed(value: bool) -> void:
	_update_target()
	_update_behavior_state()

func _on_target_in_attack_area_changed(value: bool) -> void:
	_update_target()
	_update_behavior_state()


