extends Node2D
class_name ItemFactory

#var item_scene = preload("res://Scene/Item/Item.tscn")
var boule_de_vie_scene = preload("res://Scene/InteractiveObject/CollectableObject/BouleDeVie.tscn")

#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("spawn_item", Callable(self, "_on_EVENTS_spawn_item"))
	EVENTS.connect("spawn_special_item", Callable(self, "_on_EVENTS_spawn_special_item"))


#### LOGIC ####

func _spawn_special_item(special_item_scene: PackedScene, pos: Vector2) -> void:
	var item = special_item_scene.instantiate()
	
	owner.add_child(item)
	item.set_global_position(pos)

#func _spawn_item(item_data: ItemData, pos: Vector2) -> void:
	#var item = item_scene.instantiate()
	#owner.add_child(item)
	#item.set_item_data(item_data)
	#item.set_global_position(pos)


#### SIGNAL RESPONSES ####

func _on_EVENTS_spawn_special_item(special_item_scene: PackedScene, pos: Vector2) -> void:
	_spawn_special_item(special_item_scene, pos)

#func _on_EVENTS_spawn_item(item_data: ItemData, pos: Vector2) -> void:
	#_spawn_item(item_data, pos)


