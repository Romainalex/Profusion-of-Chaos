extends Attack
class_name HookAttack

@onready var hook_sprite = $HookSprite
@onready var ray_cast = $RayCast2D

signal hooked(hooked_position, time_to_throw, time_hooked)

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	super._ready()



#### LOGICS ####

func _init_animation() -> void:
	hook_sprite.set_texture(attack_data.hook_attack_texture)
	hook_sprite.set_region_rect(Rect2(0, 0, hook_sprite.texture.get_size().x, 0))
	ray_cast.set_target_position(Vector2(0, attack_data.hook_length))
	animated_sprite_body.set_sprite_frames(SpriteFrames.new())
	var animation_name = normalized_name_attack
	for facing_dir in attack_data.animation_body_sprite_frames.get_animation_names():
		animation_name = normalized_name_attack+facing_dir
		_add_animation(animated_sprite_body, animation_name, attack_data.animation_body_sprite_frames, facing_dir)
	
	if attack_data.hit_sound_effect != null:
		if attack_data.hit_sound_effect.sound != null:
			_add_sound_effect(attack_data.hit_sound_effect.sound, normalized_name_hit_sound_effect, attack_data.hit_sound_effect.volume_db)
	if attack_data.start_sound_effect != null:
		if attack_data.start_sound_effect.sound != null:
			_add_sound_effect(attack_data.start_sound_effect.sound, normalized_name_start_sound_effect, attack_data.start_sound_effect.volume_db)
	
	ray_cast.set_target_position(Vector2(0, attack_data.hook_length))

func _update_hitbox_and_attack_direction(facing_direction: Vector2) -> void:
	var angle = facing_direction.normalized().angle()
	ray_cast.set_rotation_degrees(rad_to_deg(angle) - 90)
	hook_sprite.set_rotation_degrees(rad_to_deg(angle) - 90)

##Start the attack's animation
func _start_attack_animation(facing_direction: Vector2, type_animation_name: String="") -> void:
	_hide(false)
	animated_sprite_body.play(normalized_name_attack+type_animation_name+Util.find_direction_name_8_dir(facing_direction))

func _interpolate(length: int, duration: float) -> void:
	var tween_offset = create_tween()
	var tween_rect_h = create_tween()
	
	tween_offset.tween_property(hook_sprite, "offset",Vector2(0,length/2.0), duration)
	tween_rect_h.tween_property(hook_sprite, "region_rect", Rect2(0,0, hook_sprite.get_region_rect().size.x, length), duration)

func _start_hook() -> void:
	
	#Throw hook
	_interpolate(int(await _check_collision()), attack_data.time_to_throw)
	await get_tree().create_timer(attack_data.time_to_throw).timeout
	#Retract hook
	_interpolate(0,attack_data.time_to_retract)
	await get_tree().create_timer(attack_data.time_to_throw).timeout
	super._on_AnimatedSprite_animation_finished()

func _hide(hide_animation: bool) -> void:
	hook_sprite.set_visible(!hide_animation)
	animated_sprite_body.set_visible(!hide_animation)

func _check_collision() -> float:
	var collision_point
	var distance = attack_data.hook_length
	await get_tree().create_timer(0.1).timeout
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		collision_point = ray_cast.get_collision_point()
		distance = (global_position - collision_point).length()
		if collider in get_tree().get_nodes_in_group("Ennemy"):
			collider.hurt(attack_data.damage_data, 100.0)
			emit_signal("hooked",collision_point, attack_data.time_to_throw, attack_data.time_to_retract)
	return distance

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_frame_changed() -> void:
	var frame = animated_sprite_body.get_frame()
	if attack_data.frame_to_start_hook == frame:
		_start_hook()
	if attack_data.start_sound_effect != null:
		if attack_data.start_sound_effect.frame_to_start == frame:
			_start_audio(normalized_name_start_sound_effect, attack_data.start_sound_effect.time_to_start)

func _on_AnimatedSprite_animation_finished() -> void:
	pass
