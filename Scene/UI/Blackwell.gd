extends ColorRect
class_name BlackVell

@onready var parent_path = get_parent().get_path()
@onready var upgrade_weapon = get_node(str(parent_path) + "/UpgradeWeapon")
#@onready var glossaire = get_node(str(parent_path) + "/Glossaire")
@onready var change_spell = get_node(str(parent_path) + "/ChangeSpell")
#@onready var cook = get_node(str(parent_path) + "/Cook")

var tween : Tween


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	upgrade_weapon.connect("hidden_menu_changed", Callable(self, "_on_UpgradeWeapon_hidden_menu_changed"))
	change_spell.connect("hidden_menu_changed", Callable(self, "_on_ChangeSpell_hidden_menu_changed"))


#### LOGICS ####


func fade(fade_in: bool) -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var to = Color(0.0, 0.0, 0.0, 0.5) if fade_in else Color(0.0, 0.0, 0.0, 0.0)
	
	tween.tween_property(self, "color", to, 0.5).from(color)


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_UpgradeWeapon_hidden_menu_changed(val: bool) -> void:
	fade(!val)

func _on_ChangeSpell_hidden_menu_changed(val: bool) -> void:
	fade(!val)
