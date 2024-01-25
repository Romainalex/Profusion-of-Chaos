extends Control
class_name Commerce


var hephaistos = preload("res://Scene/UI/Commerce/Commerce.gd")
var inari = preload("res://Scene/UI/Commerce/Commerce.gd")
var tezcatlipoca = preload("res://Scene/UI/Commerce/Commerce.gd")

var hidden_commerce : bool = true


signal hidden_commerce_changed(value)


#### ACCESSORS ####

func set_hidden_commerce(val: bool) -> void:
	if val != hidden_commerce:
		hidden_commerce = val
		print(hidden_commerce)
		emit_signal("hidden_commerce_changed", hidden_commerce)
func get_hidden_commerce() -> bool: return hidden_commerce


#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("pnj_interaction", Callable(self, "_on_EVENTS_pnj_interaction"))
	connect("hidden_commerce_changed", Callable(self, "_on_hidden_commerce_changed"))


func _input(_event: InputEvent) -> void:
	
	if hidden_commerce:
		return
	
	if Input.is_action_just_pressed("Menu_action"):
		set_hidden_commerce(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_interaction(_pnj: String) -> void:
	
	
	set_hidden_commerce(false)

func _on_hidden_commerce_changed(_val: bool) -> void:
	get_tree().paused = !hidden_commerce

