extends State
class_name CollectableFollowState

@onready var object = owner.owner
var target : Node2D = null
var speed : float = 400.0

func update(delta: float) -> void:
	if target == null:
		return
	
	if owner.state_machine.get_state_name() == "Follow":
		var target_pos = target.get_position()
		var dist = object.position.distance_to(target_pos)
		var spd = speed * delta
		
		if dist < spd:
			object.position = target_pos
			if get_parent().get_state_name() == "Follow":
				owner.collect()
		else:
			object.position = object.position.move_toward(target_pos, spd)
