extends Actor
class_name PNJ


@onready var interaction_sprite = $InteractingSprite


#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	interaction_area.connect("body_entered", Callable(self, "_on_InteractionArea_body_entered"))
	interaction_area.connect("body_exited", Callable(self, "_on_InteractionArea_body_exited"))



#### LOGICS ####

# Masquage de la fonction hurt() de Actor.gd pour rendre les PNJ invulnérable
func hurt(damage: int) -> void:
	pass

func interact() -> void:
	print("interaction")


#### SIGNAL RESPONSES ####

func _on_InteractionArea_body_entered(body) -> void:
	if body is Character:
		interaction_sprite.visible = true

func _on_InteractionArea_body_exited(body) -> void:
	if body is Character:
		interaction_sprite.visible = false
