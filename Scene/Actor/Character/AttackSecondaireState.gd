extends State




#### ACCESSORS ####





#### BUILT-IN ####

func _ready() -> void:
	pass



#### LOGICS ####

func enter_state() -> void:
	owner.attack_behaviour.start_attack_behaviour(owner.ATTACK.SECONDAIRE,owner.get_facing_direction())


#### INPUTS ####




#### SIGNAL RESPONSES ####


