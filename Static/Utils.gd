extends Object
class_name Util


static var dir_dict = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN,
	"Down-Right": Vector2(0.5,-0.5),
	"Down-Left": Vector2(-0.5,-0.5),
	"Up-Left": Vector2(-0.5, 0.5),
	"Up-Right": Vector2(0.5,0.5)
}


#### ACCESSORS ####





#### BUILT-IN ####





#### LOGICS ####

##Cherche la clé d'une valeur [param dir] dans le dictionnaire des directions [member Util.dir_dict]
static func find_direction_name(dir: Vector2) -> String:
	var direction_index = dir_dict.values().find(dir) # cherche l'index de la valeur dir dans le dictionnaire des directions
	if direction_index == -1: # vérifie que la valeur dir est dans le dictionnaire de direction
		return ""
	return dir_dict.keys()[direction_index] # cherche la clé de l'index direction_index

static func find_direction_name_8_dir(dir: Vector2) -> String:
	match rad_to_deg(dir.normalized().angle()):
		var a when -112.5 <= a and a <= -67.5 : #Up
			return "Up"
		var a when 67.5 <= a and a <= 112.5: #Down
			return "Down"
		var a when 157.5 <= a or a <= -157.5: #Left
			return "Left"
		var a when 22.5 >= a and a >= -22.5: #Right
			return "Right"
		var a when -67.5 < a and a < -22.5 : #Up-Right
			return "Up-Right"
		var a when 22.5 < a and a < 67.5: #Down-Right
			return "Down-Right"
		var a when 112.5 < a and a < 157.5: #Down-Left
			return "Down-Left"
		var a when -157.5 < a and a < -112.5: #Up-Left
			return "Up-Left"
		_: #default
			var d = dir.normalized()
			push_error("Error: No angle found for (%s, %s) or angle %s" % [d.x, d.y, rad_to_deg(d.angle())])
			return "NO-DIRECTION-FOUND"

static func give_angle_direction(object: Object, facing_direction: Vector2) -> Vector2:
	var face_direction = facing_direction
	if GAME.INPUT_SCHEME in [GAME.INPUT_SCHEMES.XBOX, GAME.INPUT_SCHEMES.DUALSHOCK]:
		var attack_direction = Input.get_vector("Attack_direction_Left","Attack_direction_Right","Attack_direction_Up","Attack_direction_Down")
		var move_direction = Input.get_vector("Left_action","Right_action","Up_action","Down_action")
		if attack_direction != Vector2.ZERO:
			face_direction = attack_direction
		elif move_direction != Vector2.ZERO:
			face_direction = move_direction
	elif GAME.INPUT_SCHEME == GAME.INPUT_SCHEMES.KEYBOARD_AND_MOUSE:
		face_direction = object.get_global_mouse_position() - object.global_position
	return face_direction

static func set_ui_visible(object: Control, val: bool) -> void:
	object.set_visible(val)
	object.set_as_top_level(val)




#### SIGNAL RESPONSES ####


