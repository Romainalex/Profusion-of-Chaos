extends Node

# warnings-disable

signal spawn_item(item, pos)
signal spawn_special_item(item, pos)

signal object_collected(object)
signal nb_coins_changed(nb_coins)

signal obstacle_destroyed(obstacle)

signal character_pv_changed(pv)
signal actor_died(target)
signal pnj_traid_started(pnj)
signal pnj_traid_finished(pnj)

signal room_finished
