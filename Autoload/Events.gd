extends Node

# warnings-disable



signal pnj_traid_started(pnj)
signal pnj_traid_finished(pnj)


signal start_blackvell_animation(show: bool)
signal character_pv_changed(pv: int, max_pv: int)
signal nb_coins_changed(nb_coins)
signal object_collected(object)
signal attack_create(type_attack: int, image_texture)
signal attack_cooldown_start(type_attack: int, cooldown: float)


signal spawn_item(item, pos)
signal spawn_special_item(item, pos)
signal actor_died(target)
signal obstacle_destroyed(obstacle)
signal room_finished()

signal input_scheme_changed()

# pour le prototype
signal victory()
