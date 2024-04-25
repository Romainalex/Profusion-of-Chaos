extends Behaviour
class_name RoomBehaviour

@onready var character_detection_area = $CharacterDetectionArea
@onready var control_children_area = $ControlChildrenArea

@export var control_children_position : Vector2 = Vector2(-90,-90)
@export var control_children_dimension : Vector2 = Vector2(200,200)

var ennemies_array = []
var doors_array = []

signal control_children_dimension_changed
signal control_children_position_changed

#### ACCESSORS ####

func set_control_children_dimension(dim: Vector2) -> void:
	if control_children_dimension != dim:
		if dim >= Vector2(200,200):
			control_children_dimension = dim
			emit_signal("control_children_dimension_changed")
		else:
			push_error("Error : control_children_dimension from %d to small (%d)" % [self, str(dim)])
func set_control_children_position(pos: Vector2) -> void:
	if control_children_position != pos:
		control_children_position = pos
		emit_signal("control_children_position_changed")


#### BUILT-IN ####

func _ready() -> void:
	character_detection_area.connect("body_entered", Callable(self, "_on_ChracterDetectionArea_body_entered"))
	EVENTS.connect("actor_died", Callable(self, "_on_EVENTS_actor_died"))
	connect("control_children_dimension_changed", Callable(self, "_on_control_children_dimension_changed"))
	connect("control_children_position_changed", Callable(self, "_on_control_children_position_changed"))
	
	


#### LOGICS ####

func _init_children_controllable() -> void:
	ennemies_array = []
	doors_array = []
	print(control_children_area.get_overlapping_bodies())
	for body in control_children_area.get_overlapping_bodies():
		
		if body is Door:
			doors_array.append(body)
		if body is Ennemy:
			ennemies_array.append(body)
	print("--------")
	print(ennemies_array)
	print("--------")
	print(doors_array)

func _open_doors(open: bool) -> void:
	for door in doors_array:
		if open:
			door.open()
		else:
			door.close()

func _check_is_ennemies_array_is_empty() -> void:
	if ennemies_array.is_empty():
		_open_doors(true)

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_ChracterDetectionArea_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("Character"):
		_init_children_controllable()
		if !ennemies_array.is_empty():
			_open_doors(false)

func _on_EVENTS_actor_died(target: Actor) -> void:
	if target in ennemies_array:
		ennemies_array.pop_at(ennemies_array.find(target))


#func _on_control_children_dimension_changed() -> void:
	#$ControlChildrenArea/CollisionShape2D.set_size(control_children_dimension)
	#$CharacterDetectionArea/CollisionShape2D.set_size(control_children_dimension - Vector2(180,180))
	#_init_children_controllable()
#
#func _on_control_children_position_changed() -> void:
	#$ControlChildrenArea/CollisionShape2D.set_position(control_children_position)
	#$CharacterDetectionArea/CollisionShape2D.set_position(control_children_position + Vector2(90,90))
	#_init_children_controllable()

