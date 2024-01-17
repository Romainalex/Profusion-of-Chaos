extends Behaviour
class_name AttackBehaviour



@export var attack_data : AttackData = null

@export var attack_array : Array = []

@export var cooldown : float = 0.0

@onready var cooldown_timer = $Cooldown
@onready var delay_combo = $DelayCombo

var current_attack : int = 0


#### BUILT-IN ####

func _ready() -> void:
	cooldown_timer.connect("timeout", Callable(self, "_on_Cooldown_timeout"))


#### LOGICS ####

func _attack_effect() -> void:
	var attack = attack_array[current_attack]
	var bodies_array = attack.attack_hitbox.get_overlapping_bodies()
	for body in bodies_array:
		if body == owner:
			continue
		
		if body.has_method("hurt"):
			body.face_position(owner.global_position)
			var damage = _compute_damage(body)
			body.hurt(damage)
		if body.has_method("destroy"):
			body.destroy()

func _compute_damage(_target: Actor) -> int:
	return 1

func procede_attack(sprite_frame: int) -> void:
	if current_attack <= attack_array.size() - 2:
		if is_delay_combo_running():
			current_attack += 1
			delay_combo.stop()
	
	var attack = attack_array[current_attack]
	if sprite_frame == attack.hit_frame:
		_attack_effect()

func is_delay_combo_running() -> bool:
	return !delay_combo.is_stopped() && !delay_combo.is_paused()

#### SIGNAL RESPONSES ####


func _on_Cooldown_timeout() -> void:
	pass

