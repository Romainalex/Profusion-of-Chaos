extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite = $AnimatedSprite
@onready var attack_hitbox = $AttackHitbox


signal attack_finished(attack, action)


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))



#### LOGICS ####

# start the attack's behaviour
func start_attack_behaviour() -> void:
	pass


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	emit_signal("attack_finished", self)

