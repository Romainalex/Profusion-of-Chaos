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

# init the animations and add Area2D and ColisionShape
func _init_animation() -> void:
	var animation_array = attack_data.attack_animation_array
	animated_sprite_body.sprite_frames.clear_all()
	animated_sprite_attack.sprite_frames.clear_all()
	
	for i in range(animation_array.size()):
		var animation = animation_array[i]
		var animation_name = normalized_name_attack+str(i)
		_add_animation(animated_sprite_attack, animation_name, animation.animation_attack_sprite_frames, "Attack")
		for facing_dir in animation.animation_body_sprite_frames.get_animation_names():
			animation_name = normalized_name_attack+facing_dir+str(i)
			_add_animation(animated_sprite_body, animation_name, animation.animation_body_sprite_frames, facing_dir)
		if animation.shape != null:
			var area = Area2D.new()
			var collision_shape = CollisionShape2D.new()
			collision_shape.set_shape(animation.shape)
			area.set_name(normalized_name_hitbox+str(i))
			area.add_child(collision_shape)
			add_child(area)
	print(animated_sprite_body.sprite_frames.get_animation_names())
		
	# Update the number of attack animations in the combo attack
	attacks_count = animation_array.size()

func start_attack_behaviour(facing_direction: Vector2) -> void:
	if timer.is_stopped():
		attack_index = 0
	else:
		attack_index = (attack_index + 1) % attacks_count
	super.start_attack_behaviour(facing_direction)


func _start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite_body.set_visible(true)
	animated_sprite_attack.set_visible(true)
	print(animated_sprite_body.sprite_frames.get_animation_names())
	animated_sprite_body.play(normalized_name_attack+Util.find_direction_name(facing_direction)+str(attack_index))
	animated_sprite_attack.play(normalized_name_attack+str(attack_index))

# get attack_animation in index idx in attack_animation_array
func _get_attack_animation(idx: int) -> Resource:
	return attack_data.attack_animation_array[idx]



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	timer.start(attack_data.time_to_restart)
	super._on_AnimatedSprite_animation_finished()

func _on_AnimatedSprite_frame_finished() -> void:
	if str(attack_index).is_subsequence_of(animated_sprite_attack.get_animation):
		if _get_attack_animation(attack_index).hit_frame == animated_sprite_attack.get_frame():
			_attack_attempt(normalized_name_hitbox+str(attack_index), attack_data.attack_animation_array[attack_index])
