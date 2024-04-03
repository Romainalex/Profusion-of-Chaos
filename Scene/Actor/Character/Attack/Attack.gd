extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite_body = $AnimatedSpriteBody
@onready var animated_sprite_attack = $AnimatedSpriteAttack
@onready var cooldown = $Cooldown

@export var normalized_name_attack : String = "Attack"
@export var normalized_name_hitbox : String =  "Hitbox"

var crit : float = 0.0
var direction : Vector2 = Vector2.ZERO

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
	cooldown.connect("timeout", Callable(self, "_on_Cooldown_timeout"))
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
	
	if attack_animation.shape_array != null:
		for shape in attack_animation.shape_array:
			if shape != null:
				_add_hitbox(shape, normalized_name_hitbox)

func _add_hitbox(shape_resource: ShapeData, hitbox_name: String) -> void:
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.set_shape(shape_resource.shape)
	collision_shape.set_position(shape_resource.position)
	area.set_name(hitbox_name+"_"+str(shape_resource.hit_frame))
	area.add_child(collision_shape)
	add_child(area)

func _add_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	animated_sprite_to_change.sprite_frames.add_animation(animated_sprite_name)
	animated_sprite_to_change.sprite_frames.set_animation_loop(animated_sprite_name, sprite_frames_to_add.get_animation_loop(sprite_frames_name))
	animated_sprite_to_change.sprite_frames.set_animation_speed(animated_sprite_name, sprite_frames_to_add.get_animation_speed(sprite_frames_name))
	_set_animation(animated_sprite_to_change, animated_sprite_name, sprite_frames_to_add, sprite_frames_name)

##Start the attack's behaviour
func start_attack_behaviour(facing_direction: Vector2, crit_rate: float) -> void:
	if cooldown.is_stopped():
		crit = crit_rate
		direction = facing_direction
		_update_hitbox_and_attack_direction(facing_direction)
		_start_attack_animation(facing_direction)
	else:
		emit_signal("attack_finished", self)

##Start the attack's animation
func _start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite_body.set_visible(true)
	animated_sprite_attack.set_visible(true)
	animated_sprite_body.play(normalized_name_attack+Util.find_direction_name_8_dir(facing_direction))
	animated_sprite_attack.play(normalized_name_attack)
	

##Set frames named [param sprite_frames_name] from frames [param sprite_frames_to_add] in animated_sprite [param animated_sprite_to_change] named [param animated_sprite_name]
func _set_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	for i in range(sprite_frames_to_add.get_frame_count(sprite_frames_name)):
		animated_sprite_to_change.sprite_frames.add_frame(animated_sprite_name, sprite_frames_to_add.get_frame_texture(sprite_frames_name,i),sprite_frames_to_add.get_frame_duration(sprite_frames_name, i))

##Start attack attemption with every bodies in the area hitbox named [param hitbox_name]
func _attack_attempt(hitbox_name: String, attack_anim: AttackAnimationData) -> void:
	var area = find_child(hitbox_name,false, false)
	var bodies_array = area.get_overlapping_bodies()
	for body in bodies_array:
		if body.has_method("hurt") and (body in get_tree().get_nodes_in_group("Ennemy")):
			body.hurt(attack_anim.damage_data, crit)
		if body.has_method("destroy"):
			body.destroy()

##Update [member Attack.hitbox_direction] and [member Attack.animated_sprite_attack] based on [param facing_direction]
func _update_hitbox_and_attack_direction(facing_direction: Vector2) -> void:
	var angle = facing_direction.normalized().angle()
	var children = get_children()
	for child in children:
		if normalized_name_hitbox.is_subsequence_of(child.name):
			child.set_rotation_degrees(rad_to_deg(angle) - 90) 
	animated_sprite_attack.set_rotation_degrees(rad_to_deg(angle) - 90)

func _throw_projectil() -> void:
	var projectil = attack_data.attack_animation.projectil.scene.instantiate()
	get_tree().current_scene.add_child(projectil)
	projectil.rotation = direction.angle() - 90

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	animated_sprite_body.set_visible(false)
	animated_sprite_attack.set_visible(false)
	if attack_data.cooldown > 0.0:
		cooldown.start(attack_data.cooldown)
	emit_signal("attack_finished", self)

func _on_AnimatedSprite_frame_changed() -> void:
	for shape in attack_data.attack_animation.shape_array:
		if shape.hit_frame == animated_sprite_attack.get_frame():
			_attack_attempt(normalized_name_hitbox+"_"+str(shape.hit_frame), attack_data.attack_animation)
	if attack_data.attack_animation.projectil != null:
		if animated_sprite_attack.get_frame() == attack_data.attack_animation.projectil.frame_to_start:
			_throw_projectil()

func _on_Cooldown_timeout() ->  void:
	pass

func _on_attack_data_changed() -> void:
	_init_animation()
