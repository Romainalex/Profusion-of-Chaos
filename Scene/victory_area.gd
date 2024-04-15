extends StaticBody2D

@onready var area = $Area2D


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	area.connect("body_entered", Callable(self, "_on_body_entered"))



#### LOGICS ####




#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("Character"):
		body.set_visible(false)
		EVENTS.emit_signal("victory")
