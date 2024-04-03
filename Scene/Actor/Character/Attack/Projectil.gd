extends Area2D
class_name Projectil


@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

@export var speed : int = 100
@export var projectil_data : Projectil = null


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite.play("Throw")

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta



#### LOGICS ####




#### INPUTS ####




#### SIGNAL RESPONSES ####


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(projectil_data.damage_data)
	if body.has_method("destroy"):
		body.destroy()
	animated_sprite.play("Touch")

func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
