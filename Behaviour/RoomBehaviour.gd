extends Behaviour
class_name RoomBehaviour

@onready var character_detection_area = $CharacterDetectionArea

@export var collision_shape : CollisionShape2D = null

@export var ennemies_array : Array[Ennemy] = [] 
@export var doors_array : Array[Door] = []


#### ACCESSORS ####




#### BUILT-IN ####

func _ready() -> void:
	character_detection_area.connect("body_entered", Callable(self, "_on_ChracterDetectionArea_body_entered"))
	EVENTS.connect("actor_died", Callable(self, "_on_EVENTS_actor_died"))
	
	character_detection_area.add_child(collision_shape)


#### LOGICS ####


func _open_doors(open: bool) -> void:
	for door in doors_array:
		if open:
			door.open()
		else:
			door.close()

func _start_chase(target: Node2D) -> void:
	for ennemy in ennemies_array:
		ennemy.set_target_in_chase_area(true)
		ennemy.target = target

func _check_is_ennemies_array_is_empty() -> void:
	if ennemies_array.is_empty():
		_open_doors(true)

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_ChracterDetectionArea_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("Character"):
		if !ennemies_array.is_empty():
			_open_doors(false)
			_start_chase(body)

func _on_EVENTS_actor_died(target: Actor) -> void:
	if target in ennemies_array:
		ennemies_array.pop_at(ennemies_array.find(target))
		_check_is_ennemies_array_is_empty()


