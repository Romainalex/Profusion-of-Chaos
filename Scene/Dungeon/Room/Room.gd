extends Node2D
class_name Room

@onready var tilemap = $TileMap
@onready var obstacle_tilemap = $ObstacleTileMap


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	#print(tilemap.get_used_rect())
	#print("------")
	#_reagence_tilemap()
	pass



#### LOGICS ####

func _reagence_tilemap() -> void:
	var new_origin_position = _get_tile_position_by_origin_object(tilemap)
	for tile_coords in $TileMap.get_used_cells(0):
		var tile = tilemap.get_cell_tile_data(0, tile_coords, true)
		print(tile.get_texture_origin())
		tile.set_texture_origin(new_origin_position)
		print(tile.get_texture_origin())
		print("  V  ")
		#print(str(tile)+" -> "+str(new_tile))

func _get_tile_position_by_origin_object(tile_map: TileMap) -> Vector2i:
	return Vector2i(global_position)/tile_map.get_tileset().tile_size


#### INPUTS ####




#### SIGNAL RESPONSES ####


