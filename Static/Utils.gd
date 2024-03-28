extends Object
class_name Util


static var dir_dict = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
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

#### INPUTS ####




#### SIGNAL RESPONSES ####


