extends Node2D


func _on_animation_finished(anim_name):
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene('res://game/screens/MainMenu.tscn')
