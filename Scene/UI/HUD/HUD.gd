extends Control
class_name HUD

@onready var life_progress_bar = $LifeProgressBar
@onready var principal_texture_rect = $Principal
@onready var secondaire_texture_rect = $Secondaire
@onready var special1_texture_rect = $Special1
@onready var special2_texture_rect = $Special2
@onready var object_texture_rect = $Object

var tween: Tween

#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	EVENTS.connect("character_pv_changed", Callable(self, "_on_EVENTS_chracter_pv_changed"))
	EVENTS.connect("attack_create", Callable(self, "_on_EVENTS_attack_create"))
	EVENTS.connect("attack_cooldown_start", Callable(self, "_on_EVENTS_attack_cooldown_start"))
	
	



#### LOGICS ####

func _find_attack(type: int) -> Node:
	match type:
		0:
			return principal_texture_rect
		1:
			return secondaire_texture_rect
		2:
			return special1_texture_rect
		3:
			return special2_texture_rect
		_:
			return null

func _get_subnode(node: Node, subnode_name: String) -> Node:
	return get_node(str(node.get_path())+"/"+subnode_name)

func _update_attack(attack: Node, texture) -> void:
	_get_subnode(attack, "TextureRect").set_texture(texture)

func _update_attack_cooldown(attack: Node, cooldown: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(_get_subnode(attack, "ColorRect"), "size", Vector2(32,0), cooldown).from(Vector2(32,32))


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_EVENTS_chracter_pv_changed(pv: int, max_pv: int) -> void:
	life_progress_bar.set_value(pv*life_progress_bar.get("max_value")/float(max_pv))

func _on_EVENTS_attack_create(type_attack: int, texture) -> void:
	_update_attack(_find_attack(type_attack), texture)

func _on_EVENTS_attack_cooldown_start(type_attack: int, cooldown: float) -> void:
	_update_attack_cooldown(_find_attack(type_attack), cooldown)
