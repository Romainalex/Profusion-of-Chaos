extends AudioStreamPlayer2D




#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	connect("finished", Callable(self, "_on_finished"))
	
	await get_tree().create_timer(1.0).timeout
	play()



#### LOGICS ####




#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	play()


