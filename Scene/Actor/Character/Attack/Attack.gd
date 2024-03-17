extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite = $AnimatedSprite


signal attack_finished(attack, action)


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))



#### LOGICS ####

# init the animation and add Area2D and ColisionShape
func _init_animation() -> void:
	var attack_animation = attack_data.attack_animation
	
	for facing_dir in attack_animation.sprite_frames.get_names():
		var animation_name = "Attack"+facing_dir
		animated_sprite.sprite_frames.add_animation(animation_name)
		_set_animation(animation_name, attack_animation.sprite_frames, facing_dir)
	if attack_animation.shape.can_instantiate():
		var area = Area2D.new()
		area.name = "Hitbox"
		area.add_child(attack_animation.shape.instantiate())
		add_child(area)

# start the attack's behaviour
func start_attack_behaviour(facing_direction: Vector2) -> void:
	_update_hitbox_direction(facing_direction)
	start_attack_animation(facing_direction)

func start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite.play("Attack"+Util.find_direction_name(facing_direction))

# set frames from frames in animation named name 
func _set_animation(name: String, frames: SpriteFrames, anim: String) -> void:
	for i in range(frames.get_frame_count(anim)):
		animated_sprite.sprite_frames.add_frame(name, frames.get_frame_texture(anim,i),frames.get_frame_duration(anim, i))

# start attack attemption with every bodies in the area hitbox at the attack_index
func _attack_attempt(hitbox_name: String) -> void:
	var area = find_child(hitbox_name,false, false)
	var bodies_array = area.get_overlapping_bodies()
	for body in bodies_array:
		if body.has_method("hurt"):
			body.hurt()

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
	emit_signal("attack_finished", self)

func _on_AnimatedSprite_frame_finished() -> void:
	if attack_data.sprite_frames.hit_frame == animated_sprite.get_frame():
		_attack_attempt("Hitbox")
