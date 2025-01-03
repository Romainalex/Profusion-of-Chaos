extends Data
class_name AttackData


enum TYPE_ATTACK {
	NORMAL,
	COMBO,
	CHARGED,
	HOOK
}

@export var type_attack : TYPE_ATTACK

@export var evolution_array : Array[AttackData] = []


@export var cooldown : float = 0.0

@export var texture_inventory : Texture2D = null
@export var texture_description : Texture2D = null
