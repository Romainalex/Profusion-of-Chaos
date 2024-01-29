extends Node


@export var game_data : GameData = null

var nb_coins : int = 0
var perso_selected = null
var attack_principal = null
var attack_secondaire = null
var attack_special1 = null
var attack_special2 = null

#### ACCESSEUR ####

func set_nb_coins(val : int) -> void:
	if val != nb_coins:
		nb_coins = val
		EVENTS.emit_signal("nb_coins_changed", nb_coins)

func get_nb_coins() -> int:
	return nb_coins

#### BUILT-IN ####

func _ready() -> void:
	randomize()
	EVENTS.connect("object_collected", Callable(self,"_on_EVENTS_object_collected"))


#### SIGNAL RESPONSES ####

#func _on_EVENTS_object_collected(object) -> void:
	#if object is Coin:
		#set_nb_coins(nb_coins + 1)
	
