extends Control
class_name Credits


@onready var label = $Label
@onready var timer = $Timer
@onready var credit_music = $CreditMusic

var text = tr("CREDITS_MEMBERS")+" :
HOARAU Romain
BEURARD Kilian
CABIAS Simon
RIVIERE Anaïs

"+tr("CREDITS_THANKS")+" :
MANGLOU Loïc
Baba Des Bois
VELIA Bastien
Taiga
"

var tween : Tween

var label_start_position : Vector2

signal return_menu(previous_menu)

#### ACCESSORS ####




#### BUILT-IN ####

func _ready() -> void:
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	label_start_position = label.position
	label.text = text
	Util.set_ui_visible(self, false)



#### LOGICS ####

func _scroll_text() -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var to = Vector2(label_start_position.x, 0 - label.size.y)
	
	var time = label.get_line_count() * 2
	
	tween.tween_property(label, "position", to, time).from(label_start_position)
	timer.start(time)

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	
	if !visible:
		return
	

	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("Menu_action"):
		timer.stop()
		credit_music.stop()
		emit_signal("return_menu", self)



#### SIGNAL RESPONSES ####

func _on_visibility_changed() -> void:
	if visible:
		_scroll_text()
		credit_music.play()

func _on_Timer_timeout() -> void:
	credit_music.stop()
	emit_signal("return_menu", self)
