extends Resource
class_name EffectData

enum EFFECT_TYPE {
	NORMAL,
	SOIN,
	FEU,
	GLACE,
	POISON,
	RALENTISSEMENT,
	REPOUSSE,
	GRAB
}

@export var effect_type : EFFECT_TYPE = EFFECT_TYPE.NORMAL
@export var damage_effect : int = 0
@export_range(0.0, 100.0) var hit_chance : float = 0.0
