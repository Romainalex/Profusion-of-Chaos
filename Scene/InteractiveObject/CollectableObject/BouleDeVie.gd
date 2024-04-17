extends Node2D
class_name BouleDeVie


@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var shadow_sprite = $ShadowSprite


#### ACCESSEUR ####


#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_coin_sprite_animation_finished"))
	
	


#### LOGICS ####

func appear() -> void:
	shadow_sprite.set_visible(true)
	animation_player.play("Wave")


#### SIGNAL RESPONSES ####





