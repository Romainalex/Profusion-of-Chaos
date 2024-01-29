extends ColorRect
class_name BlackVell

@onready var parent_path = get_parent().get_path()
@onready var update_weapon = get_node(str(parent_path) + "/UpdateWeapon")
#@onready var glossaire = get_node(str(parent_path) + "/Glossaire")
@onready var update_spell = get_node(str(parent_path) + "/UpdateSpell")
#@onready var cook = get_node(str(parent_path) + "/Cook")

var tween : Tween


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	update_weapon.connect("hidden_update_weapon_changed", Callable(self, "_on_UpdateWeapon_hidden_update_weapon_changed"))



#### LOGICS ####


func fade(fade_in: bool) -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var to = Color(0.0, 0.0, 0.0, 0.5) if fade_in else Color(0.0, 0.0, 0.0, 0.0)
	
	tween.tween_property(self, "color", to, 0.5).from(color)


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_UpdateWeapon_hidden_update_weapon_changed(val: bool) -> void:
	fade(!val)
