extends State
class_name EnnemyMoveState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	owner.move_along_path(delta)
