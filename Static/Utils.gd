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

# Cherche la clé d'une valeur dir dans le dictionnaire des direction
static func find_direction_name(dir: Vector2) -> String:
	var direction_index = dir_dict.values().find(dir) # cherche l'index de la valeur dir dans le dictionnaire des directions
	if direction_index == -1: # vérifie que la valeur dir est dans le dictionnaire de direction
		return ""
	return dir_dict.keys()[direction_index] # cherche la clé de l'index direction_index


#### INPUTS ####




#### SIGNAL RESPONSES ####


