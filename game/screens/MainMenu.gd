extends Control

export(bool) var secret_version = false

func _ready():
	$Debug.visible = OS.is_debug_build()
	if OS.is_debug_build():
		$Debug.connect('pressed', self, '_on_Debug_pressed', [], CONNECT_ONESHOT)
	$Secret.visible = secret_version
	if secret_version:
		$Secret/Colors.connect('pressed', self, '_on_Colors_pressed', [], CONNECT_ONESHOT)
	Music.play(Music.MENU)

func _on_Play_pressed():
	$Buttons.hide()
	$Click.play()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene('res://game/screens/LevelMenu.tscn')


func _on_Tutorial_pressed():
	$Click.play()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene('res://game/screens/tutorial/Tutorial1-1.tscn')


func _on_Quit_pressed():
	$Click.play()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().quit()

func _on_Debug_pressed():
	get_tree().change_scene('res://devel/DebugLevel.tscn')

func _on_Colors_pressed():
	get_tree().change_scene('res://devel/PaletteSelection.tscn')


