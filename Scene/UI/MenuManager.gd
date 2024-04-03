extends Control
class_name MenuManager

@onready var pause_menu = $MenuPause


var traid_menu_dict := {
	"Héphaistos": ["SellObject", "ChangeWeapon"],
	"Tezcatlipoca": ["UpgradeSpell","ChangeSpell"],
	"Inari": ["SellCook"],
	"Thot": ["Glossary"],
	"Papa Legba": ["ChoiseDungeon"]}



#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("pnj_traid_started", Callable(self, "_on_EVENTS_pnj_traid_started"))



#### LOGICS ####

func _open_traid_menu(menu_array: Array) -> void:
	for child in get_children():
		if child.name in menu_array:
			child.set_visible(true)

func _all_is_hide() -> bool:
	for child in get_children():
		if child.visible:
			return false
	return true


#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Menu_action"):
		if _all_is_hide():
			pause_menu.set_visible(true)


#### SIGNAL RESPONSES ####

func _on_EVENTS_pnj_traid_started(pnj: String) -> void:
	match pnj:
		"Héphaistos":
			_open_traid_menu(traid_menu_dict[pnj])
		"Tezcatlipoca":
			_open_traid_menu(traid_menu_dict[pnj])
		"Papa Legba":
			_open_traid_menu(traid_menu_dict[pnj])
		"Inari":
			_open_traid_menu(traid_menu_dict[pnj])
		"Thot":
			_open_traid_menu(traid_menu_dict[pnj])
		_:
			push_error("Error: pnj named %s no found" % pnj)
