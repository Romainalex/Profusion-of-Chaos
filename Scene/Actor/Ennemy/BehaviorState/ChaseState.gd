extends State
class_name ChaseState



func enter_state() -> void:
	owner.state_machine.set_state("Move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	owner.update_move_path(owner.target.global_position)
