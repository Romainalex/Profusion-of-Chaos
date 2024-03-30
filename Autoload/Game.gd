extends Node

enum INPUT_SCHEMES {
	KEYBOARD_AND_MOUSE,
	XBOX,
	DUALSHOCK
}
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.KEYBOARD_AND_MOUSE

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
	Input.connect("joy_connection_changed", Callable(self, "_on_Input_joy_connection_changed"))
	

func _update_input_scheme():
	if Input.get_connected_joypads().size() > 0:
		match Input.get_joy_name(Input.get_connected_joypads()[0]):
			var n when "XInput".is_subsequence_of(n):
				INPUT_SCHEME = INPUT_SCHEMES.XBOX
			var n when "PS".is_subsequence_of(n):
				INPUT_SCHEME = INPUT_SCHEMES.DUALSHOCK
	else:
		INPUT_SCHEME = INPUT_SCHEMES.KEYBOARD_AND_MOUSE

#### SIGNAL RESPONSES ####

#func _on_EVENTS_object_collected(object) -> void:
	#if object is Coin:
		#set_nb_coins(nb_coins + 1)

func _on_Input_joy_connection_changed(_device: int, _connected: bool) -> void:
	_update_input_scheme()
