extends State
class_name ChaseState

@onready var follow_audio = $"../../FollowAudio"

func _ready() -> void:
	follow_audio.connect("finished", Callable(self, "_on_FollowAudio_finished"))

func enter_state() -> void:
	owner.state_machine.set_state("Move")
	follow_audio.play(0.5)

func exit_state() -> void:
	follow_audio.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	owner.update_move_path(owner.target.global_position)



func _on_FollowAudio_finished() -> void:
	follow_audio.play(1.5)
