extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite
@onready var hitbox = $Hitbox
@onready var state_machine = $StateMachine

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite_animation_changed"))
	
	animated_sprite.play("PyramideIdle")



#### LOGICS ####

func destroy() -> void:
	if state_machine.get_state_name() != "Idle":
		return
	
	state_machine.set_state("Break")
	animated_sprite.play("PyramideBreak")
	$DropperBehaviour.drop_item()

#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_changed() -> void:
	if "Break".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Broken")
		hitbox.set_disabled(true)
		EVENTS.emit_signal("obstacle_destroyed", self)
		
		await get_tree().create_timer(2).timeout
		queue_free()


