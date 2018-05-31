extends TextureRect

export(String, FILE, '*.tscn') var next_tutorial
export(String, FILE, '*.tscn') var previous_tutorial
var current_tutorial = 0
var yielding = false

func _ready():
	$TextBox/Next.hide()

func next():
	if $AnimationPlayer.has_animation(str(current_tutorial+1)):
		$AnimationPlayer.play(str(current_tutorial+1))
		$"Waffle先生/AnimationPlayer".play('talk')
	else:
		if not yielding:
			yielding = true
			yield(get_tree().create_timer(0.4), 'timeout')
			get_tree().change_scene(next_tutorial)

func previous():
	if current_tutorial > 1 and $AnimationPlayer.has_animation(str(current_tutorial-1)):
		$AnimationPlayer.play(str(current_tutorial-1))
		$"Waffle先生/AnimationPlayer".play('talk')
	elif previous_tutorial != null and not yielding:
		yielding = true
		yield(get_tree().create_timer(0.4), 'timeout')
		get_tree().change_scene(previous_tutorial)

func _on_Skip_pressed():
	if not yielding:
		yielding = true
		yield(get_tree().create_timer(0.5), 'timeout')
		get_tree().change_scene('res://game/screens/LevelMenu.tscn')


func _on_Next_pressed():
	next()

func _on_Previous_pressed():
	previous()

func _on_animation_started(aname):
	current_tutorial = int(aname[0])
	if current_tutorial <= 1 and previous_tutorial == null:
		$TextBox/Previous.hide()
	else:
		$TextBox/Previous.show()

func _on_animation_finished(aname):
	if int(aname[0]) == 0:
		$TextBox/Next.show()
		next()

