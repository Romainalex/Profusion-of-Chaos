extends Node2D
class_name Attack


@export var attack_data : AttackData = null

@onready var animated_sprite_body = $AnimatedSpriteBody
@onready var animated_sprite_attack = $AnimatedSpriteAttack
@onready var cooldown = $Cooldown

@export var normalized_name_attack : String = "Attack"
@export var normalized_name_hitbox : String =  "Hitbox"
@export var normalized_name_hit_sound_effect : String =  "AudioHit"
@export var normalized_name_start_sound_effect : String =  "AudioStart"

var crit : float = 0.0
var direction : Vector2 = Vector2.ZERO

signal attack_finished(attack, cooldown)
signal attack_data_changed()

#### ACCESSORS ####

func set_attack_data(data: Resource) -> void:
	if attack_data != data:
		attack_data = data
		emit_signal("attack_data_changed")




#### BUILT-IN ####


func _ready() -> void:
	animated_sprite_body.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	animated_sprite_body.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))
	cooldown.connect("timeout", Callable(self, "_on_Cooldown_timeout"))
	connect("attack_data_changed", Callable(self, "_on_attack_data_changed"))



#### LOGICS ####

## init the animation and also add Area2D and ColisionShape
func _init_animation() -> void:
	var attack_animation = attack_data.attack_animation
	animated_sprite_attack.set_sprite_frames(SpriteFrames.new())
	animated_sprite_body.set_sprite_frames(SpriteFrames.new())
	var animation_name = normalized_name_attack
	_add_animation(animated_sprite_attack, animation_name, attack_animation.animation_attack_sprite_frames, "Attack")
	for facing_dir in attack_animation.animation_body_sprite_frames.get_animation_names():
		animation_name = normalized_name_attack+facing_dir
		_add_animation(animated_sprite_body, animation_name, attack_animation.animation_body_sprite_frames, facing_dir)
	
	if attack_animation.shape_array != null:
		for shape in attack_animation.shape_array:
			if shape != null:
				_add_hitbox(shape, normalized_name_hitbox)
	if attack_animation.hit_sound_effect != null:
		if attack_animation.hit_sound_effect.sound != null:
			_add_sound_effect(attack_animation.hit_sound_effect.sound, normalized_name_hit_sound_effect, attack_animation.hit_sound_effect.volume_db)
	if attack_animation.start_sound_effect != null:
		if attack_animation.start_sound_effect.sound != null:
			_add_sound_effect(attack_animation.start_sound_effect.sound, normalized_name_start_sound_effect, attack_animation.start_sound_effect.volume_db)

func _add_hitbox(shape_resource: ShapeData, hitbox_name: String) -> void:
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.set_shape(shape_resource.shape)
	collision_shape.set_position(shape_resource.position)
	area.set_name(hitbox_name+"_"+str(shape_resource.hit_frame))
	area.add_child(collision_shape)
	add_child(area)

func _add_sound_effect(sound: AudioStream, sound_name: String, db: float) -> void:
	var audio_stream = AudioStreamPlayer2D.new()
	audio_stream.set_stream(sound)
	audio_stream.set_name(sound_name)
	audio_stream.set_volume_db(db)
	add_child(audio_stream)

func _add_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	animated_sprite_to_change.sprite_frames.add_animation(animated_sprite_name)
	animated_sprite_to_change.sprite_frames.set_animation_loop(animated_sprite_name, sprite_frames_to_add.get_animation_loop(sprite_frames_name))
	animated_sprite_to_change.sprite_frames.set_animation_speed(animated_sprite_name, sprite_frames_to_add.get_animation_speed(sprite_frames_name))
	_set_animation(animated_sprite_to_change, animated_sprite_name, sprite_frames_to_add, sprite_frames_name)

##Start the attack's behaviour
func start_attack_behaviour(facing_direction: Vector2, character_data: CharacterData) -> void:
	if cooldown.is_stopped():
		crit = character_data.crit_rate
		direction = facing_direction
		_update_hitbox_and_attack_direction(facing_direction)
		_start_attack_animation(facing_direction)
	else:
		emit_signal("attack_finished", self, 0.0)

func stop_attack_behaviour(_facing_direction: Vector2, _character_data: CharacterData) -> void:
	pass

##Start the attack's animation
func _start_attack_animation(facing_direction: Vector2, type_animation_name: String="") -> void:
	_hide(false)
	animated_sprite_body.play(normalized_name_attack+type_animation_name+Util.find_direction_name_8_dir(facing_direction))
	animated_sprite_attack.play(normalized_name_attack+type_animation_name)
	

##Set frames named [param sprite_frames_name] from frames [param sprite_frames_to_add] in animated_sprite [param animated_sprite_to_change] named [param animated_sprite_name]
func _set_animation(animated_sprite_to_change: AnimatedSprite2D, animated_sprite_name: String, sprite_frames_to_add: SpriteFrames, sprite_frames_name: String) -> void:
	for i in range(sprite_frames_to_add.get_frame_count(sprite_frames_name)):
		animated_sprite_to_change.sprite_frames.add_frame(animated_sprite_name, sprite_frames_to_add.get_frame_texture(sprite_frames_name,i),sprite_frames_to_add.get_frame_duration(sprite_frames_name, i))

##Start attack attemption with every bodies in the area hitbox named [param hitbox_name]
func _attack_attempt(attack_anim: AttackAnimationData, hitbox_name: String, audio_name: String) -> void:
	var area = find_child(hitbox_name,false, false)
	var bodies_array = area.get_overlapping_bodies()
	for body in bodies_array:
		if body.has_method("hurt") and (body in get_tree().get_nodes_in_group("Ennemy")):
			body.face_position(global_position)
			body.hurt(attack_anim.damage_data, crit)
			if attack_anim.hit_sound_effect != null:
				_start_audio(audio_name, attack_anim.hit_sound_effect.time_to_start)
		if body.has_method("destroy"):
			body.destroy()
			if attack_anim.hit_sound_effect != null:
				_start_audio(audio_name, attack_anim.hit_sound_effect.time_to_start)

func _start_audio(sound_effect_name: String, time_to_start: float) -> void:
	var audio_stream = find_child(sound_effect_name, false, false)
	if audio_stream != null:
		if !audio_stream.is_playing():
			audio_stream.play(time_to_start)

##Update [member Attack.hitbox_direction] and [member Attack.animated_sprite_attack] based on [param facing_direction]
func _update_hitbox_and_attack_direction(facing_direction: Vector2) -> void:
	var angle = facing_direction.normalized().angle()
	var children = get_children()
	for child in children:
		if normalized_name_hitbox.is_subsequence_of(child.name):
			child.set_rotation_degrees(rad_to_deg(angle) - 90) 
	animated_sprite_attack.set_rotation_degrees(rad_to_deg(angle) - 90)

func _throw_projectil(projectil_data: ProjectilData) -> void:
	var projectil = projectil_data.scene.instantiate()
	add_child(projectil)
	if projectil_data.hit_sound_effect != null:
		projectil.add_audio(projectil_data.hit_sound_effect.sound)
	projectil.set_rotation(direction.angle())

func _hide(hide_animation: bool) -> void:
	animated_sprite_attack.set_visible(!hide_animation)
	animated_sprite_body.set_visible(!hide_animation)

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	_hide(true)
	if attack_data.cooldown > 0.0:
		cooldown.start(attack_data.cooldown)
	emit_signal("attack_finished", self, attack_data.cooldown)

func _on_AnimatedSprite_frame_changed() -> void:
	var frame = animated_sprite_body.get_frame()
	for shape in attack_data.attack_animation.shape_array:
		if shape.hit_frame == frame:
			_attack_attempt(attack_data.attack_animation, normalized_name_hitbox+"_"+str(shape.hit_frame), normalized_name_hit_sound_effect)
	for projectil in attack_data.attack_animation.projectil_array:
		if frame == projectil.frame_to_start:
			_throw_projectil(projectil)
	if attack_data.attack_animation.start_sound_effect != null:
		if attack_data.attack_animation.start_sound_effect.frame_to_start == frame:
			_start_audio(normalized_name_start_sound_effect, attack_data.attack_animation.start_sound_effect.time_to_start)

func _on_Cooldown_timeout() ->  void:
	pass

func _on_attack_data_changed() -> void:
	_init_animation()
