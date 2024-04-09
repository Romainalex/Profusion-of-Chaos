extends StaticBody2D

@onready var area = $Area2D


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	area.connect("area_entered", Callable(self, "_on_area_entered"))



#### LOGICS ####




#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_area_entered(body: Node2D) -> void:
	EVENTS.emit_signal("victory")
