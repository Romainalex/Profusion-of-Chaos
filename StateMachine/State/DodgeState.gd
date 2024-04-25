extends State

@onready var timer = $Timer
@onready var dodge_audio = $DodgeAudio

var direction_to_dodge = Vector2.ZERO


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))



#### LOGICS ####

func update(_delta: float) -> void:
	owner.set_velocity(direction_to_dodge * owner.dodge_data.dodge_speed)
	owner.move_and_slide()


func enter_state() -> void:
	if owner.moving_direction == Vector2.ZERO:
		direction_to_dodge = owner.facing_direction
	else:
		direction_to_dodge = owner.moving_direction
	dodge_audio.play()
	timer.start()
	



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_Timer_timeout() -> void:
	owner.state_machine.set_state("Idle")
