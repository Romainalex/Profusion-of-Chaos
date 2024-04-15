extends State
class_name HurtState

@onready var timer = $Timer

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))



#### LOGICS ####

func enter_state() -> void:
	timer.start()
	



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_Timer_timeout() -> void:
	owner.state_machine.set_state("Idle")
