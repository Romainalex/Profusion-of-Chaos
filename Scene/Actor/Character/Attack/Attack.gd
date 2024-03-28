extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite_body = $AnimatedSpriteBody
@onready var animated_sprite_attack = $AnimatedSpriteAttack

@export var normalized_name_attack : String = "Attack"
@export var normalized_name_hitbox : String =  "Hitbox"


signal attack_finished(attack)
signal attack_data_changed()

#### ACCESSORS ####

func set_attack_data(data: Resource) -> void:
	if attack_data != data:
		attack_data = data
		emit_signal("attack_data_changed")




#### BUILT-IN ####


func _ready() -> void:
	animated_sprite_attack.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite_attack.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))
	connect("attack_data_changed", Callable(self, "_on_attack_data_changed"))



#### LOGICS ####

## init the animation and also add Area2D and ColisionShape
func _init_animation() -> void:
	var attack_animation = attack_data.attack_animation
	animated_sprite_attack.sprite_frames.clear_all()
	animated_sprite_body.sprite_frames.clear_all()
	var animation_name = normalized_name_attack
	_add_animation(animated_sprite_attack, animation_name, attack_animation.animation_attack_sprite_frames, "Attack")
	for facing_dir in attack_animation.animation_body_sprite_frames.get_animation_names():
		animation_name = normalized_name_attack+facing_dir
		_add_animation(animated_sprite_body, animation_name, attack_animation.animation_body_sprite_frames, facing_dir)
	if attack_animation.shape != null:
		var area = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		collision_shape.set_shape(attack_animation.shape)
		collision_shape.set_position(attack_animation.position)
		area.set_name(normalized_name_hitbox)
		area.add_child(collision_shape)
		add_child(area)

func _add_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	animated_sprite_to_change.sprite_frames.add_animation(animated_sprite_name)
	animated_sprite_to_change.sprite_frames.set_animation_loop(animated_sprite_name, sprite_frames_to_add.get_animation_loop(sprite_frames_name))
	animated_sprite_to_change.sprite_frames.set_animation_speed(animated_sprite_name, sprite_frames_to_add.get_animation_speed(sprite_frames_name))
	_set_animation(animated_sprite_to_change, animated_sprite_name, sprite_frames_to_add, sprite_frames_name)

# start the attack's behaviour
func start_attack_behaviour(facing_direction: Vector2) -> void:
	_update_hitbox_and_attack_direction(facing_direction)
	_start_attack_animation(facing_direction)

func _start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite_body.set_visible(true)
	animated_sprite_attack.set_visible(true)
	animated_sprite_body.play(normalized_name_attack+Util.find_direction_name(facing_direction))
	animated_sprite_attack.play(normalized_name_attack)
	

# set frames from frames in animation named name 
func _set_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	for i in range(sprite_frames_to_add.get_frame_count(sprite_frames_name)):
		animated_sprite_to_change.sprite_frames.add_frame(animated_sprite_name, sprite_frames_to_add.get_frame_texture(sprite_frames_name,i),sprite_frames_to_add.get_frame_duration(sprite_frames_name, i))

# start attack attemption with every bodies in the area hitbox at the attack_index
func _attack_attempt(hitbox_name: String, attack_anim: AttackAnimationData) -> void:
	var area = find_child(hitbox_name,false, false)
	var bodies_array = area.get_overlapping_bodies()
	for body in bodies_array:
		if body.has_method("hurt"):
			body.hurt(attack_anim.damage_data)

# update hitbox_direction based on facing_direction
func _update_hitbox_and_attack_direction(facing_direction: Vector2) -> void:
	var angle = facing_direction.angle()
	var children = get_children()
	for child in children:
		if normalized_name_hitbox.is_subsequence_of(child.name):
			child.set_rotation_degrees(rad_to_deg(angle) - 90)
	animated_sprite_attack.set_rotation_degrees(rad_to_deg(angle) - 90)

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	animated_sprite_body.set_visible(false)
	animated_sprite_attack.set_visible(false)
	emit_signal("attack_finished", self)

func _on_AnimatedSprite_frame_finished() -> void:
	if attack_data.sprite_frames.hit_frame == animated_sprite_attack.get_frame():
		_attack_attempt(normalized_name_hitbox, attack_data.attack_animation)

func _on_attack_data_changed() -> void:
	_init_animation()
