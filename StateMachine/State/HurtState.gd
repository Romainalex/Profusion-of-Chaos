extends State
class_name HurtState

@onready var timer = $Timer
@onready var gpu_particul = $GPUParticles2D

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))



#### LOGICS ####

func enter_state() -> void:
	gpu_particul.process_material.set_direction(Vector3(owner.facing_direction.x * -1, owner.facing_direction.y * -1, 0))
	gpu_particul.set_emitting(true)
	timer.start(2)
	



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_Timer_timeout() -> void:
	if owner.behavior_tree.get_state_name() == "Chase":
		owner.state_machine.set_state("Move")
	else:
		owner.state_machine.set_state("Idle")
