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
	HOOK
}

@export var effect_type : EFFECT_TYPE = EFFECT_TYPE.NORMAL
@export var effect_value : int = 0
@export_range(0.0, 100.0, 0.25) var hit_chance : float = 0.0
