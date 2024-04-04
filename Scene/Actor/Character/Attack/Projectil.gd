extends Area2D
class_name Projectil


@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

@export var speed : int = 100
@export var damage_data : DamageData = null


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	connect("body_shape_entered", Callable(self, "_on_bidy_shape_entered"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "_on_VisibleOnScreenNotifier_screen_exited"))
	animated_sprite.play("Throw")

func _physics_process(delta: float) -> void:
	var dir = Vector2.RIGHT.rotated(rotation)
	global_position += speed * dir * delta



#### LOGICS ####

func _touch() -> void:
	speed = 0
	animated_sprite.play("Touch")


#### INPUTS ####




#### SIGNAL RESPONSES ####




func _on_bidy_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body in get_tree().get_nodes_in_group("Ennemy") or body in get_tree().get_nodes_in_group("InteractiveObject"):
		if body.has_method("hurt"):
			body.hurt(damage_data, 1.0)
			animated_sprite.play("Touch")
		if body.has_method("destroy"):
			body.destroy()
		_touch()
	if body is TileMap:
		var layer_body = body.get_layer_for_body_rid(body_rid)
		var tile = body.get_cell_tile_data(layer_body, body.get_coords_for_body_rid(body_rid))
		if tile.get_collision_polygons_count(layer_body) > 0:
			_touch()
	

func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()

func _on_VisibleOnScreenNotifier_screen_exited() -> void:
	queue_free()
