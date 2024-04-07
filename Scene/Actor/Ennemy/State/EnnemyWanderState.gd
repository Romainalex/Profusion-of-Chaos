extends StateMachine
class_name WanderState

@export var min_wander_distance = 40.0
@export var max_wander_distance = 70.0

func _ready() -> void:
	super._ready()
	$Wait.connect("wait_time_finished", Callable(self, "_on_Wait_wait_time_finished"))
	owner.connect("move_path_finished", Callable(self, "_on_Ennemy_move_path_finished"))

#### VIRTUAL ####



#### LOGIC ####

# Pour générer une destination aléatoire, on génère un angle aléatoire, on prend la direction
# correspondant à l'angle puis on va par là sur une distance elle aussi aléatoire
func _generate_new_destination() -> Vector2:
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	var direction = Vector2(cos(angle), sin(angle)) # cos -> abs, sin -> ord
	var distance = randf_range(min_wander_distance, max_wander_distance)
	
	return owner.global_position + direction * distance



#### SIGNAL RESPONSES ####

func _on_Wait_wait_time_finished() -> void:
	var destination = _generate_new_destination()
	owner.update_move_path(destination)
	
	set_state("GoTo")

func _on_Ennemy_move_path_finished() -> void:
	if is_current_state():
		set_state("Wait")
