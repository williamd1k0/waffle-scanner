extends Control


func _ready():
	for lb in $Center/Levels.get_children():
		lb.connect('pressed', self, 'start_level', [lb.level], CONNECT_ONESHOT)
		lb.disabled = not lb.level in Levels.unlocked

func start_level(level):
	Levels.current_level = level
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene(
		'res://game/gameplay/levels/{0}/LevelBase{0}.tscn'.format([level])
	)

func _on_Previous_pressed():
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene('res://game/screens/MainMenu.tscn')
