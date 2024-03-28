extends Resource
class_name AttackAnimationData



@export var animation_body_sprite_frames : SpriteFrames = null
@export var animation_attack_sprite_frames : SpriteFrames = null
@export var shape : Shape2D = null
@export var position : Vector2 = Vector2.INF ##Position of shape
@export var hit_frame : int = -1
@export var projectil : PackedScene = null

@export var damage_data : DamageData = null
