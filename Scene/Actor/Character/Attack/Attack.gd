extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite = $AnimatedSprite


signal attack_finished(attack)
signal attack_data_changed()

#### ACCESSORS ####

func set_attack_data(data: Resource) -> void:
	if attack_data != data:
		attack_data = data
		emit_signal("attack_data_changed")




#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))
	connect("attack_data_changed", Callable(self, "_on_attack_data_changed"))



#### LOGICS ####

# init the animation and add Area2D and ColisionShape
func _init_animation() -> void:
	var attack_animation = attack_data.attack_animation
	animated_sprite.sprite_frames.clear_all()
	
	for facing_dir in attack_animation.sprite_frames.get_animation_names():
		var animation_name = "Attack"+facing_dir
		animated_sprite.sprite_frames.add_animation(animation_name)
		animated_sprite.sprite_frames.set_animation_loop(animation_name, false)
		_set_animation(animation_name, attack_animation.sprite_frames, facing_dir)
	if attack_animation.shape != null:
		var area = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		collision_shape.set_shape(attack_animation.shape)
		area.set_name("Hitbox")
		area.add_child(collision_shape.instantiate())
		add_child(area)

# start the attack's behaviour
func start_attack_behaviour(facing_direction: Vector2) -> void:
	_update_hitbox_direction(facing_direction)
	_start_attack_animation(facing_direction)

func _start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite.set_visible(true)
	animated_sprite.play("Attack"+Util.find_direction_name(facing_direction))

# set frames from frames in animation named name 
func _set_animation(anim_name: String, frames: SpriteFrames, anim: String) -> void:
	for i in range(frames.get_frame_count(anim)):
		animated_sprite.sprite_frames.add_frame(anim_name, frames.get_frame_texture(anim,i),frames.get_frame_duration(anim, i))

# start attack attemption with every bodies in the area hitbox at the attack_index
func _attack_attempt(hitbox_name: String, attack_anim: AttackAnimationData) -> void:
	var area = find_child(hitbox_name,false, false)
	var bodies_array = area.get_overlapping_bodies()
	for body in bodies_array:
		if body.has_method("hurt"):
			body.hurt(attack_anim.damage_data)

# update hitbox_direction based on facing_direction
func _update_hitbox_direction(facing_direction: Vector2) -> void:
	var angle = facing_direction.angle()
	var children = get_children()
	for child in children: 
		if "Hitbox".is_subsequence_of(child.name):
			child.set_rotation_degrees(rad_to_deg(angle) - 90)

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	animated_sprite.set_visible(false)
	emit_signal("attack_finished", self)

func _on_AnimatedSprite_frame_finished() -> void:
	if attack_data.sprite_frames.hit_frame == animated_sprite.get_frame():
		_attack_attempt("Hitbox", attack_data.attack_animation)

func _on_attack_data_changed() -> void:
	_init_animation()
