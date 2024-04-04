extends Attack
class_name ChargedAttack




#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	pass



#### LOGICS ####

func start_attack_behaviour(facing_direction: Vector2, character_data: CharacterData) -> void:
	
	super.start_attack_behaviour(facing_direction, character_data)

func stop_attack_behaviour(facing_direction: Vector2, _character_data: CharacterData) -> void:
	if "Charged".is_subsequence_of(animated_sprite_attack.get_animation()):
		_update_hitbox_and_attack_direction(facing_direction)
		_start_attack_animation(facing_direction,"Charged")
	elif "Charging".is_subsequence_of(animated_sprite_attack.get_animation()):
		_update_hitbox_and_attack_direction(facing_direction)
		_start_attack_animation(facing_direction,"Charging")

#### INPUTS ####




#### SIGNAL RESPONSES ####


