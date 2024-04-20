extends State
class_name DeadState

@onready var dead_audio = $DeadAudio

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	pass



#### LOGICS ####

func enter_state() -> void:
	dead_audio.play()


#### INPUTS ####




#### SIGNAL RESPONSES ####


