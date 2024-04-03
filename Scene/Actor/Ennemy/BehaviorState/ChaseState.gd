extends State
class_name ChaseState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	owner.update_move_path(owner.target.global_position)
