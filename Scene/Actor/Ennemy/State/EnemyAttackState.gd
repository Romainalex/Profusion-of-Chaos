extends State
class_name AttackState

@onready var cooldown = $Cooldown

func enter_state() -> void:
	owner.state_machine.set_state("Attack")
	owner.animated_sprite.set_scale(Vector2(4,4))
	$SlapAudio.play()
	cooldown.start()

func exit_state() -> void:
	owner.animated_sprite.set_scale(Vector2(1,1))

