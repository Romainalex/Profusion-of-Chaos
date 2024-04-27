extends StaticBody2D
class_name Door

@onready var state_machine = $StateMachine
@onready var animated_sprite = $AnimatedSprite
@onready var hitbox = $Hitbox

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
	_update_animation()


#### LOGICS ####

func _update_animation() -> void:
	animated_sprite.play(state_machine.get_state_name()+dir_name[direction])

func close() -> void:
	state_machine.set_state("Close")
	await get_tree().create_timer(0.5).timeout
	hitbox.set_disabled(false)


func open() -> void:
	state_machine.set_state("Open")
	hitbox.set_disabled(true)




#### SIGNAL RESPONSES ####

func _on_StateMachine_state_changed(_state: State) -> void:
	_update_animation()



