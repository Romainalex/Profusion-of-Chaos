extends Node2D
class_name AttackBehaviour

@onready var attack_scene = preload("res://Scene/Actor/Character/Attack/Attack.tscn")
@onready var combo_attack_scene = preload("res://Scene/Actor/Character/Attack/ComboAttack.tscn")
@onready var charged_attack_scene = preload("res://Scene/Actor/Character/Attack/ChargedAttack.tscn")

@export var attack_data_principal : AttackData = null
@export var attack_data_secondaire : AttackData = null
@export var attack_data_special1 : AttackData = null
@export var attack_data_special2 : AttackData = null


@onready var type_attack = {
	"AttackPrincipal": attack_data_principal,
	"AttackSecondaire": attack_data_secondaire,
	"AttackSpecial1": attack_data_special1,
	"AttackSpecial2": attack_data_special2
}



signal attack_data_changed(attack)
signal attack_finished(attack)

#### ACCESSORS ####

func set_attack_data_principal(data: Resource) -> void:
	if attack_data_principal != data:
		attack_data_principal = data
		emit_signal("attack_data_changed", "AttackPrincipal",type_attack.keys()[0])

func set_attack_data_secondaire(data: Resource) -> void:
	if attack_data_secondaire != data:
		attack_data_secondaire = data
		emit_signal("attack_data_changed", "AttackSecondaire", type_attack.keys()[1])

func set_attack_data_special1(data: Resource) -> void:
	if attack_data_special1 != data:
		attack_data_special1 = data
		emit_signal("attack_data_changed", "AttackSpecial1", type_attack.keys()[2])

func set_attack_data_special2(data: Resource) -> void:
	if attack_data_special2 != data:
		attack_data_special2 = data
		emit_signal("attack_data_changed", "AttackSpecial2", type_attack.keys()[3])



#### BUILT-IN ####

func _ready() -> void:
	connect("attack_data_changed", Callable(self, "_on_attack_data_changed"))
	for type in type_attack.keys():
		_create_attack(type)



#### LOGICS ####

func start_attack_behaviour(attack: int, facing_direction) -> void:
	match attack:
		0: # Attack principal
			$AttackPrincipal.start_attack_behaviour(facing_direction)
		1: # Attack secondaire
			$AttackSecondaire.start_attack_behaviour(facing_direction)
		2: # Attack special1
			$AttackSpecial1.start_attack_behaviour(facing_direction)
		3: # Attack special2
			$AttackSpecial2.start_attack_behaviour(facing_direction)

func _create_attack(attack: String) -> void:
	var a = null
	var choise_attack = type_attack[attack]
	if choise_attack != null:
		match choise_attack.type_attack:
			0: # NORMAL attack
				a = attack_scene.instantiate()
			1: # COMBO attack
				a = combo_attack_scene.instantiate()
			2: # CHARGED attack
				a = charged_attack_scene.instantiate()
	if a != null:
		add_child(a)
		a.set_name(attack)
		a.set_attack_data(type_attack[attack])
		_create_attack_signal(attack)

func _update_attack(type_old_attack: String, new_attack: String) -> void:
	find_child(type_old_attack).free() #delete old attack
	_create_attack(new_attack) #create new attack
	_create_attack_signal(type_old_attack) #create new attack signal

func _create_attack_signal(attack: String) -> void:
	_find_node_name(attack).connect("attack_finished", Callable(self, "_on_AttackSpecial2_attack_finished"))

func _find_node_name(node_name: String):
	var node_ref = null
	match node_name:
		"AttackPrincipal":
			node_ref = $AttackPrincipal
		"AttackSecondaire": 
			node_ref = $AttackSecondaire
		"AttackSpecial1": 
			node_ref = $AttackSpecial1
		"AttackSpecial2":
			node_ref = $AttackSpecial2
	
	if node_ref == null:
		push_error("Node reference not found, node_name : %s" % node_name)
	else:
		return node_ref


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_attack_data_changed(type_attack_name: String, new_attack: String) -> void:
	_update_attack(type_attack_name, new_attack)

func _on_AttackPrincipal_attack_finished(attack: Object) -> void:
	emit_signal("attack_finished", attack)

func _on_AttackSecondaire_attack_finished(attack: Object) -> void:
	emit_signal("attack_finished", attack)

func _on_AttackSpecial1_attack_finished(attack: Object) -> void:
	emit_signal("attack_finished", attack)

func _on_AttackSpecial2_attack_finished(attack: Object) -> void:
	emit_signal("attack_finished", attack)
