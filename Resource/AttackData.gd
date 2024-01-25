extends Resource
class_name AttackData

enum EFFECT_TYPE {
	NORMAL,
	SOIN,
	FEU,
	GLACE,
	POISON,
	RALENTISSEMENT,
	REPOUSSE
}

@export var attack_name : String = ""
@export var description : String = ""
@export var evolution : Array = []
@export var path : PackedScene = null

@export_range(0.0, 100.0) var crit_rate : float = 0.0
@export var min_damage : int = 0
@export var max_damage : int = 0
@export var effect_type : EFFECT_TYPE = EFFECT_TYPE.NORMAL
@export var damage_effect : int = 0



@export var texture_inventory : Texture2D = null
@export var texture_description : Texture2D = null
