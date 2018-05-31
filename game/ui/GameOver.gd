extends TextureRect

enum { VICTORY, DEFEAT }
var state = -1

func _ready():
	hide()
	$Defeat.hide()
	$Victory.hide()

func show_screen():
	$Level.text = str(Levels.current_level)
	show()
	$AnimationPlayer.play('blink')
	Music.mute()

func victory(total=0, best=0):
	state = VICTORY
	show_screen()
	$Victory/Sfx.play()
	$Victory/Total/Text.text = str(total)
	$Victory/Best/Text.text = str(best)
	$Victory.show()

func defeat():
	state = DEFEAT
	show_screen()
	$Defeat/Sfx.play()
	$Defeat.show()

func to_level(level):
	if level <= 4:
		Levels.current_level = level
		yield(get_tree().create_timer(0.4), "timeout")
		get_tree().change_scene(
			'res://game/gameplay/levels/{0}/LevelBase{0}.tscn'.format([level])
		)
	else:
		to_main_menu()

func to_main_menu():
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene('res://game/screens/MainMenu.tscn')

func _on_Yes_pressed():
	$Click.play()
	if state == VICTORY:
		to_level(Levels.current_level+1)
	elif state == DEFEAT:
		to_level(Levels.current_level)

func _on_No_pressed():
	$Click.play()
	to_main_menu()
