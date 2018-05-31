extends Area2D

enum VOLTAGE { LOW, HIGH }
export(VOLTAGE) var voltage = 1
var connected

func _on_body_entered(body):
	if connected == null and body.is_in_group('plug'):
		connected = body
		body.power_connect(voltage+1)
		body.global_position = global_position + Vector2(0, 5)
		get_parent().enable()


func _on_body_exited(body):
	if connected == body:
		connected = null
		body.power_connect(0)
		get_parent().disable()
