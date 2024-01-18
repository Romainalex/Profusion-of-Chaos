extends Node
class_name AttackCombo

@onready var attack_node = get_node("res://Scene/Actor/Attack/Attack.tscn")
@onready var delay_between_two_attacks = $DelayBetweenTwoAttacks

var attack_array : Array = []
var current_attack : int = 0


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	delay_between_two_attacks.connect("timeout", Callable(self, "_on_DelayBetweenTwoAttacks_timeout"))
	_update_attack_array()



#### LOGICS ####

func _update_attack_array() -> void:
	var children = get_children
	for child in children:
		if  attack_node.is_ancestor_of(child):
			attack_array.append(child)

func update_animation(proprio : Actor) -> void:
	var attack_array_size : int = attack_array.size() -1
	if current_attack == attack_array_size:
		attack_array[current_attack].update_animation(proprio)
		current_attack = 0
		delay_between_two_attacks.stop()
	elif current_attack < attack_array_size:
		attack_array[current_attack].update_animation(proprio)
		current_attack += 1
		delay_between_two_attacks.start()
	else:
		push_error("Indice de l'attaque courante (indice : %d) hors de la list d'attaques (taille : %d)" % current_attack, attack_array_size)


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_DelayBetweenTwoAttacks_timeout() -> void:
	current_attack = 0

