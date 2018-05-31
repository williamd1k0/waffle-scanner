extends Node

var source_res = OS.window_size
var zoom = 1

func _input(event):
	if event.is_action_pressed('pc-zoom') and not OS.window_fullscreen:
		zoom += 1
		if zoom > 3:
			zoom = 1
		OS.window_size = source_res*zoom
	elif event.is_action_pressed('pc-fullscreen'):
		OS.window_fullscreen = not OS.window_fullscreen
