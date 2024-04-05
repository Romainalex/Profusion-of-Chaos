extends StaticBody2D
class_name Door

@onready var state_machine = $StateMachine
@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

enum DIRECTION {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

@export var direction: DIRECTION = DIRECTION.UP


var dir_name = ["Up", "Right", "Down", "Left"]

#### BUILT-IN ####

func _ready() -> void:
	state_machine.connect("state_changed", Callable(self, "_on_StateMachine_state_changed"))
	animated_sprite.connect("animation_changed", Callable(self, "_on_AnimatedSprite_animation_changed"))


#### LOGICS ####

func _update_animation() -> void:
	animated_sprite.play(state_machine.get_state_name()+dir_name[direction])






#### SIGNAL RESPONSES ####

func _on_StateMachine_state_changed(state: State) -> void:
	_update_animation()

func _on_AnimatedSprite_animation_changed() -> void:
	if "Close".is_subsequence_of(animated_sprite.get_animation()):
		collision_shape.set_disable(false)
	if "Open".is_subsequence_of(animated_sprite.get_animation()):
		collision_shape.set_disable(true)

