extends State
class_name ChaseState

@onready var follow_audio = $FollowAudio

func enter_state() -> void:
	owner.state_machine.set_state("Move")
	follow_audio.play()

func exit_state() -> void:
	follow_audio.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	owner.update_move_path(owner.target.global_position)
