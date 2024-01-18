extends Behaviour
class_name AttackBehaviour



@export var attack_principal : PackedScene = null
@export var attack_secondaire : PackedScene = null
@export var attack_special1 : PackedScene = null
@export var attack_special2 : PackedScene = null



#### BUILT-IN ####

func _ready() -> void:
	pass


#### LOGICS ####

func update_attack_animation(type: String) -> void:
	match(type):
		"AttackPrincipal" : attack_principal.update_animation(object)
		"AttackSecondaire" : attack_secondaire.update_animation(object)
		"AttackSpecial1" : attack_special1.update_animation(object)
		"AttackSpecial2" : attack_special2.update_animation(object)


#### SIGNAL RESPONSES ####



