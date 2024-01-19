extends Node2D
class_name Attack


@onready var attack_hitbox = $AttackHitBox
@onready var animated_sprite = $AnimatedSprite

@export var hit_frame : int = -1
@export var attack_data : AttackData = null

var proprio : Actor = null

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))



#### LOGICS ####

func _attack_effect() -> void:
	var bodies_array = attack_hitbox.get_overlapping_bodies()
	for body in bodies_array:
		if body == proprio:
			continue
		
		if body.has_method("hurt"):
			body.face_position(owner.global_position)
			var damage = _compute_damage(body)
			body.hurt(damage)
		if body.has_method("destroy"):
			body.destroy()

func update_animation(_proprio: Actor):
	proprio = _proprio
	animated_sprite.play(animated_sprite.sprite_frames.get_animation_names()[0])

func _compute_damage(_target: Actor) -> int:
	return randi_range(attack_data.min_damage,attack_data.max_damage)


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_frame_changed() -> void:
	if animated_sprite.get_frame() == hit_frame:
		_attack_effect()
