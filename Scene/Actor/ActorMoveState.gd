extends State
class_name ActorMoveState

func update(_delta: float) -> void:
	owner.set_velocity(owner.moving_direction * owner.speed)
	owner.move_and_slide()
