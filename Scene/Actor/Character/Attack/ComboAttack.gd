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
	animated_sprite.sprite_frames.clear_all()
	
	for i in range(animation_array.size()):
		var animation = animation_array[i]
		for facing_dir in animation.sprite_frames.get_animation_names():
			var animation_name = "Attack"+facing_dir+str(i)
			animated_sprite.sprite_frames.add_animation(animation_name)
			animated_sprite.sprite_frames.set_animation_loop(animation_name, false)
			animated_sprite.sprite_frames.set_animation_speed(animation_name, 10)
			_set_animation(animation_name, animation.sprite_frames, facing_dir)
		if animation.shape != null:
			var area = Area2D.new()
			var collision_shape = CollisionShape2D.new()
			collision_shape.set_shape(animation.shape)
			area.set_name("Hitbox"+str(i))
			area.add_child(collision_shape)
			add_child(area)
		
	# Update the number of attack animations in the combo attack
	attacks_count = animation_array.size()

func start_attack_behaviour(facing_direction: Vector2) -> void:
	if timer.is_stopped():
		attack_index = 0
	else:
		attack_index = (attack_index + 1) % attacks_count
	super.start_attack_behaviour(facing_direction)


func _start_attack_animation(facing_direction: Vector2) -> void:
	animated_sprite.set_visible(true)
	animated_sprite.play("Attack"+Util.find_direction_name(facing_direction)+str(attack_index))

# get attack_animation in index idx in attack_animation_array
func _get_attack_animation(idx: int) -> Resource:
	return attack_data.attack_animation_array[idx]



#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:
	timer.start(attack_data.time_to_restart)
	super._on_AnimatedSprite_animation_finished()

func _on_AnimatedSprite_frame_finished() -> void:
	if str(attack_index).is_subsequence_of(animated_sprite.get_animation):
		if _get_attack_animation(attack_index).hit_frame == animated_sprite.get_frame():
			_attack_attempt("Hitbox"+str(attack_index), attack_data.attack_animation_array[attack_index])
