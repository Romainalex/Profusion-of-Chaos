extends Node2D
class_name Coin


@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer


#### ACCESSEUR ####


#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_coin_sprite_animation_finished"))
	
	animation_player.play("Wave")

#### LOGICS ####




#### SIGNAL RESPONSES ####





