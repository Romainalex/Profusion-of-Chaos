extends Resource
class_name SoundEffectData

@export var sound : AudioStream = null
@export var frame_to_start : int = 0
@export var time_to_start : float = 0.0

@export_range(-20.0, 24.0, 0.25) var volume_db : float = 0.0
