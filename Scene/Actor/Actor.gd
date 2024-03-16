extends CharacterBody2D
class_name Actor




## VARIABLES ##

@onready var state_machine = $StateMachine
@onready var animated_sprite = $AnimatedSprite
@onready var interaction_area = $InteractionArea
@onready var tween

@export var speed = 300.0

var dir_dict = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}
var moving_direction  := Vector2.ZERO # créer un vecteur x-y dont x et y sont initialisé à 0
var facing_direction := Vector2.DOWN

@export var max_pv : int = 100
@onready var pv : int = max_pv


## SIGNALS ##
signal facing_direction_changed
signal moving_direction_changed
signal pv_changed
signal death_feedback_finished


#### ACCESSEUR ####

func set_facing_direction(val : Vector2) -> void:
	if facing_direction != val:
		facing_direction = val
		emit_signal("facing_direction_changed")
func get_facing_direction() -> Vector2:
	return facing_direction

func set_moving_direction(val: Vector2) -> void:
	if moving_direction != val:
		moving_direction = val
		emit_signal("moving_direction_changed")
func get_moving_direction() -> Vector2:
	return moving_direction

func set_pv(val: int) -> void:
	val = Maths.clampi(val, 0, max_pv)
	
	if val != pv:
		pv = val
		emit_signal("pv_changed", val)

func get_pv() -> int:
	return pv


#### BUILT-IN ####

func _ready() -> void:
	state_machine.connect("state_changed", Callable(self, "_on_StateMachine_state_changed"))
	connect("facing_direction_changed", Callable(self, "_on_facing_direction_changed"))
	connect("moving_direction_changed", Callable(self, "_on_moving_direction_changed"))
	connect("pv_changed", Callable(self, "_on_pv_changed"))
	animated_sprite.connect("frame_changed", Callable(self, "_on_AnimatedSprite_frame_changed"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_finished"))
	connect("death_feedback_finished", Callable(self, "_on_death_feedback_finished"))
	


#### LOGICS ####

# Cherche la clé d'une valeur dir dans le dictionnaire des direction
func _find_direction_name(dir: Vector2) -> String:
	var direction_index = dir_dict.values().find(dir) # cherche l'index de la valeur dir dans le dictionnaire des directions
	if direction_index == -1: # vérifie que la valeur dir est dans le dictionnaire de direction
		return ""
	return dir_dict.keys()[direction_index] # cherche la clé de l'index direction_index

# update animation based on current state and facing_direction
func _update_animation() -> void:
	var direction_name = _find_direction_name(facing_direction)
	var state_name = state_machine.get_state_name()
	
	animated_sprite.play(state_name + direction_name)

# update interaction_area_direction based on facing_direction
func _update_interaction_area_direction() -> void:
	var angle = facing_direction.angle()
	
	interaction_area.set_rotation_degrees(rad_to_deg(angle) - 90)

# start the hurt actions
func hurt(damage: int) -> void:
	state_machine.set_state("Hurt")
	set_pv(pv - damage)
	_hurt_feedback()

func die() -> void:
	EVENTS.emit_signal("actor_died", self)
	state_machine.set_state("Dead")
	_death_feedback()
	$CollisionShape2D.set_disabled(true)
	

func _hurt_feedback() -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(animated_sprite, "material:shader_parameter/opacity", 1.0, 0.1).from(0.0)
	tween.tween_property(animated_sprite, "material:shader_parameter/opacity", 0.0, 0.1).from(1.0)

func _death_feedback() -> void:
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.8)
	
	await tween.finished
	
	emit_signal("death_feedback_finished")

func face_position(pos: Vector2) -> void:
	var dir = global_position.direction_to(pos)
	face_direction(dir)

func face_direction(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		set_facing_direction(Vector2(sign(dir.x), 0))
	else:
		set_facing_direction(Vector2(0, sign(dir.y)))



#### SIGNAL RESPONSES ####

func _on_StateMachine_state_changed(_new_state: Object) -> void:
	_update_animation()

func _on_AnimatedSprite_animation_finished() -> void:
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Idle")
	elif "Hurt".is_subsequence_of(animated_sprite.get_animation()):
		if pv == 0:
			die()
		else:
			state_machine.set_state("Idle")

func _on_facing_direction_changed() -> void:
	_update_animation()
	_update_interaction_area_direction()

func _on_moving_direction_changed() -> void:
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return
	
	var sign_direction = Vector2(sign(moving_direction))
	
	if sign_direction == moving_direction: # Si le mouvement n'est pas diagonal
		set_facing_direction(moving_direction)
	else: # si le mouvement est diagonal
		if sign_direction.x == facing_direction.x:
			set_facing_direction(Vector2(0, sign_direction.y))
		else:
			set_facing_direction(Vector2(sign_direction.x, 0))


func _on_AnimatedSprite_frame_changed() -> void:
	#if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		#if animated_sprite.get_frame() == 1:
			#_attack_effect()
	pass

func _on_pv_changed(new_hp: int) -> void:
	#print(name + " : " + str(new_hp))
	if new_hp == 0:
		die()

func _on_death_feedback_finished() -> void:
	queue_free()
