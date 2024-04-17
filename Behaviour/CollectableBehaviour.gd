extends Behaviour
class_name CollectableBehaviour


@onready var state_machine = $StateMachine
@onready var collect_sound = $CollectSound
@onready var animation = $AnimationPlayer

@export var follow_area : Area2D = null

signal collected


#### ACCESSORS ####



#### BUILT-IN ####

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.connect("state_changed", Callable(self, "_on_StateMachine_state_changed"))
	follow_area.connect("body_entered", Callable(self, "_on_FollowArea_body_entered"))
	animation.connect("animation_finished", Callable(self, "_on_AnimationPlayer_animation_finished"))


#### LOGICS ####

func collect() -> void:
	state_machine.set_state("Collect")
	emit_signal("collected")
	EVENTS.emit_signal("object_collected", object)
	
	if animation.has_animation("Collect"):
		animation.play("Collect")
	else:
		object.queue_free()

func _follow_target(target: Node2D) -> void:
	state_machine.set_state("Follow")
	$StateMachine/Follow.target = target


#### SIGNAL RESPONSES ####

func _on_FollowArea_body_entered(body : Node2D) -> void:
	if state_machine.get_state_name() == "Idle":
		_follow_target(body)

func _on_StateMachine_state_changed(_new_state: Object):
	if state_machine.get_previous_state_name() == "Spawn":
		if owner.has_method("appear"):
			owner.appear()
	
	if state_machine.get_state_name() == "Idle":
		for body in follow_area.get_overlapping_bodies():
			if body is Character:
				_follow_target(body)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Collect":
		object.queue_free()
