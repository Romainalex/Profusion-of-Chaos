extends ColorRect
class_name BlackVell

var tween : Tween

#### ACCESSORS ####





#### BUILT-IN ####





#### LOGICS ####


func fade(fade_in: bool) -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var to = Color(0.0, 0.0, 0.0, 0.5) if fade_in else Color(0.0, 0.0, 0.0, 0.0)
	
	tween.tween_property(self, "color", to, 0.5).from(color)


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_Commerce_hidden_commerce_changed(value: bool) -> void:
	fade(!value)
