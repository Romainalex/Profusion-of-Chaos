extends Actor
class_name ennemy

var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed

func _on_detection_area_body_entered(body):
	player = body #Le joueur qui rentre est le body vers lequel doit se diriger l'ennemi
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
