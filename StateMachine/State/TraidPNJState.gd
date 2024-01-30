extends State
class_name TraidPNJState




#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	pass



#### LOGICS ####

func enter_state() -> void:
	EVENTS.emit_signal("pnj_traid_started", owner.pnj_data.pnj_name)


#### INPUTS ####




#### SIGNAL RESPONSES ####


