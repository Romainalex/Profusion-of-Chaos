extends Room
class_name  CloseRoom

@onready var actor_detection_area = $ActorDetectionArea

var closable : bool = true

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	actor_detection_area.connect("body_entered", Callable(self, "_on_ActorDetectionArea_body_entered"))
	EVENTS.connect("actor_died", Callable(self, "_on_EVENTS_actor_died"))



#### LOGICS ####

func _is_ennemy_in() -> bool:
	for child in get_children():
		if child in get_tree().get_nodes_in_group("Ennemy"):
			return true
	return false

func _give_door_array() -> Array:
	var door_array = []
	for child in get_children():
		if child in get_tree().get_nodes_in_group("Door"):
			door_array.append(child)
	return door_array



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_ActorDetectionArea_body_entered(body: Node2D) -> void:
	if closable and body in get_tree().get_nodes_in_group("Character") and _is_ennemy_in():
		for door in _give_door_array():
			door.close()

func _on_EVENTS_actor_died(target: Actor) -> void:
	if !_is_ennemy_in():
		for door in _give_door_array():
			door.open()
