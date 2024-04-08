extends Node
class_name Pathfinder

@onready var tilemap = get_parent()

@export var connect_diagonal: bool = true

var astar = AStar2D.new()
var room_size := Vector2.ZERO


#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("obstacle_destroyed", Callable(self, "_on_EVENTS_obstacle_destroyed"))
	
	room_size = tilemap.get_used_rect().size
	_init_astar()


#### LOGICS ####

func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var from_cell = tilemap.local_to_map(from)
	var to_cell = tilemap.local_to_map(to)
	
	var from_cell_id = _compute_point_index(from_cell)
	var to_cell_id = _compute_point_index(to_cell)
	
	var point_path = astar.get_point_path(from_cell_id,to_cell_id)
	var path := PackedVector2Array()
	
	for i in range(1,point_path.size()-1):
		var world_pos = tilemap.map_to_local(point_path[i]) + Vector2.ONE * 8
		path.append(world_pos)
	path.append(to)
	
	return path

func _get_layer_id(layer_name: String) -> int:
	for i in range(tilemap.get_layers_count()):
		if layer_name == tilemap.get_layer_name(i):
			return i
	return -1

func _init_astar() -> void:
	var sol_layer_id = _get_layer_id("Sol")
	var cells_array = tilemap.get_used_cells_by_id(0,sol_layer_id) if sol_layer_id != -1 else [] # créer un tableau de cellule du TileMap en ne prenant que les tuiles ayant pour source le TileSet de Sol
	
	for cell in cells_array:
		var point_id = _compute_point_index(cell)
		astar.add_point(point_id, cell)
	
	_astart_connect_points(cells_array, connect_diagonal)
	_disable_all_obstacles_points()

# Ajoute les connexions entre les points
func _astart_connect_points(point_array: Array, connect_diagonals: bool = true) -> void:
	for point in point_array:
		var point_index = _compute_point_index(point)
		
		if !astar.has_point(point_index):
			continue

		for x_offset in range(-1,2):
			for y_offset in range(-1,2):
				if !connect_diagonals && x_offset in [0,2] && y_offset in [0,2]:
					continue
				
				var point_relative = Vector2(point.x + x_offset, point.y + y_offset)
				var point_rel_id = _compute_point_index(point_relative)
				
				if point_relative == Vector2(float(point.x),float(point.y)) or !astar.has_point(point_rel_id):
					continue
				
				astar.connect_points(point_index, point_rel_id)


func _compute_point_index(cell: Vector2) -> int:
	return int(abs(cell.x + room_size.x * cell.y))


func _disable_all_obstacles_points() -> void:
	for obstacle in get_tree().get_nodes_in_group("Obstacle"):
		_update_obstacles_points(obstacle, true)


func _update_obstacles_points(obstacle: Node2D, disabled: bool) -> void:
	var pos_cell = obstacle.get_global_position()
	var cell = tilemap.local_to_map(pos_cell)
	var point_id = _compute_point_index(cell)
	astar.set_point_disabled(point_id, disabled)


func is_position_valid(pos: Vector2) -> bool:
	var cell = tilemap.local_to_map(pos)
	var point_id = _compute_point_index(cell)
	return astar.has_point(point_id) && !astar.is_point_disabled(point_id)


#### SIGNAL RESPONSES #####

func _on_EVENTS_obstacle_destroyed(obstacle: Node2D) -> void:
	_update_obstacles_points(obstacle, false)
	
