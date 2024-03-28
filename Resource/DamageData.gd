extends Resource
class_name DamageData

@export_range(0.0, 100.0, 0.25) var crit_rate : float = 0.0
@export var min_damage : int = 0
@export var max_damage : int = 0
@export var effect_array : Array[EffectData] = []

