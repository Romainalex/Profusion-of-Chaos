extends Area2D
class_name Projectil


@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape
@onready var hit_audio = $HitAudio

@export var speed : int = 100
@export var damage_data : DamageData = null

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	connect("body_shape_entered", Callable(self, "_on_body_shape_entered"))
	hit_audio.connect("finished", Callable(self, "_on_HitAudio_finished"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite.play("Throw")

func _physics_process(delta: float) -> void:
	var dir = Vector2.RIGHT.rotated(rotation)
	global_position += speed * dir * delta

func add_audio(audio: AudioStream) -> void:
	hit_audio.set_stream(audio)

#### LOGICS ####

func _touch() -> void:
	speed = 0
	if hit_audio.stream != null:
		if !hit_audio.is_playing():
			hit_audio.play()
	animated_sprite.play("Touch")


#### INPUTS ####




#### SIGNAL RESPONSES ####




func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if animated_sprite.get_animation() == "Touch":
		return
	
	if body in get_tree().get_nodes_in_group("Ennemy") or body in get_tree().get_nodes_in_group("InteractiveObject"):
		if body.has_method("hurt"):
			body.hurt(damage_data, 1.0)
		if body.has_method("destroy"):
			body.destroy()
		_touch()
	if body is TileMap:
		var layer_body = body.get_layer_for_body_rid(body_rid)
		var tile = body.get_cell_tile_data(layer_body, body.get_coords_for_body_rid(body_rid))
		if tile.get_collision_polygons_count(layer_body) > 0:
			_touch()
	

func _on_AnimatedSprite_animation_finished() -> void:
	if hit_audio.stream == null:
		queue_free()
	else:
		animated_sprite.set_visible(false)

func _on_HitAudio_finished() -> void:
	queue_free()

