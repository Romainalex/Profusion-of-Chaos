extends Attack
class_name ComboAttack

var attack_index : int = 0
var attacks_count : int

@onready var timer = $Timer



#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	super._ready()



#### LOGICS ####

##Init the animations and add Area2D and ColisionShape
func _init_animation() -> void:
	var animation_array = attack_data.attack_animation_array
	animated_sprite_body.set_sprite_frames(SpriteFrames.new())
	animated_sprite_attack.set_sprite_frames(SpriteFrames.new())
	
	for i in range(animation_array.size()):
		var animation = animation_array[i]
		var animation_name = normalized_name_attack+str(i)
		_add_animation(animated_sprite_attack, animation_name, animation.animation_attack_sprite_frames, "Attack")
		for facing_dir in animation.animation_body_sprite_frames.get_animation_names():
			animation_name = normalized_name_attack+facing_dir+str(i)
			_add_animation(animated_sprite_body, animation_name, animation.animation_body_sprite_frames, facing_dir)
		if animation.shape_array != null:
			for shape in animation.shape_array:
				if shape != null:
					_add_hitbox(shape, normalized_name_hitbox+str(i))
		if animation.hit_sound_effect != null:
			if animation.hit_sound_effect.sound != null:
				_add_sound_effect(animation.hit_sound_effect.sound, normalized_name_hit_sound_effect+str(i), animation.hit_sound_effect.volume_db)
		if animation.start_sound_effect != null:
			if animation.start_sound_effect.sound != null:
				_add_sound_effect(animation.start_sound_effect.sound, normalized_name_start_sound_effect+str(i), animation.start_sound_effect.volume_db)
		
	# Update the number of attack animations in the combo attack
	attacks_count = animation_array.size()

func start_attack_behaviour(facing_direction: Vector2, character_data: CharacterData) -> void:
	if timer.is_stopped():
		attack_index = 0
	else:
		attack_index = (attack_index + 1) % attacks_count
	super.start_attack_behaviour(facing_direction, character_data)


func _start_attack_animation(facing_direction: Vector2, type_animation_name: String="") -> void:
	_hide(false)
	animated_sprite_body.play(normalized_name_attack+type_animation_name+Util.find_direction_name_8_dir(facing_direction)+str(attack_index))
	animated_sprite_attack.play(normalized_name_attack+type_animation_name+str(attack_index))

##Get attack_animation in index [param idx] in attack_animation_array
func _get_attack_animation(idx: int) -> Resource:
	return attack_data.attack_animation_array[idx]



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	timer.start(attack_data.time_to_restart)
	super._on_AnimatedSprite_animation_finished()

func _on_AnimatedSprite_frame_changed() -> void:
	var frame = animated_sprite_body.get_frame()
	if str(attack_index).is_subsequence_of(animated_sprite_body.get_animation()):
		var attack = _get_attack_animation(attack_index)
		for shape in attack.shape_array:
			if shape.hit_frame == frame:
				_attack_attempt(_get_attack_animation(attack_index), normalized_name_hitbox+str(attack_index)+"_"+str(shape.hit_frame), normalized_name_hit_sound_effect+str(attack_index))
		for projectil in attack.projectil_array:
			if frame == projectil.frame_to_start:
				_throw_projectil(projectil)
		if attack.start_sound_effect != null:
			if attack.start_sound_effect.frame_to_start == frame:
				_start_audio(normalized_name_start_sound_effect+str(attack_index), attack.start_sound_effect.time_to_start)
