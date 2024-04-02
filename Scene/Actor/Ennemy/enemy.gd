extends Actor
class_name Ennemy

@onready var behavior_tree = $BehaviorTree
@onready var chase_area = $ChaseArea
@onready var attack_area = $AttackArea

var target : Node2D = null

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

func _ready() -> void :
	var __ = chase_area.connect("body_entered", Callable(self, "_on_ChaseArea_body_entered"))
	__ = chase_area.connect("body_exited", Callable(self, "_on_ChaseArea_body-exited"))
	__ = attack_area.connect("body_entered",  Callable(self, "_on_AttackArea_body_entered"))
	__ = attack_area.connect("body_exited",  Callable(self, "_on_AttackArea_body-exited"))
	__ = connect("target_in_chase_area_changed", Callable(self, "_on_target_in_chase_area_changed"))
	#__ = connect("target_in_chase_area_changed", Callable(self, "_on_target_in_chase_area_changed"))

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

func _on_target_in_ChaseArea_changed(value: bool) -> void:
	_update_target()
	_update_behavior_state()

func _on_target_in_AttackArea_changed(value: bool) -> void:
	_update_target()
	_update_behavior_state()


