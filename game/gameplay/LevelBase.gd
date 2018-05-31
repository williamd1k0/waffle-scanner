extends Navigation2D

const Wire = preload('res://game/gameplay/Wire.tscn')

export(int) var level_goal = 180
export(float) var level_time = 80

var scanners = 0
var plug_pos_cache = []
var wire_origin_cache = []
var goal_reached = false
var first_click = false

func _ready():
	Music.play(Music.GAME)
	scanners = $Scanners.get_child_count()
	init_ui()
	init_wires()
	if get_parent() == get_tree().root:
		play()

func _process(delta):
	update_lines()
	update_ui()

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		set_pause(not get_tree().paused)

func play(wait_click=true):
	if wait_click:
		for p in $Plugs.get_children():
			p.connect('dragging', self, 'on_Plug_dragging')
	else:
		$UI/Timebar.start()

func init_wires():
	for i in range($Plugs.get_child_count()):
		$Scanners.get_child(i).connect('blowup', self, 'on_Scanner_blowup')
		plug_pos_cache.append(null)
		wire_origin_cache.append($Scanners.get_child(i).get_node('Position2D').global_position)
		$Plugs.get_child(i).connect('plug_update', $Scanners.get_child(i), 'plug_update')
		$Wires.add_child(Wire.instance())
	update_lines()

func init_ui():
	$UI/Overlay.visible = false
	$UI/Timebar.level_time = level_time
	$UI/LevelStats.update_goal(level_goal)
	$UI/Timebar.connect('timeout', self, 'on_level_timeout')
	$UI/PauseButton.connect('pressed', self, 'set_pause', [true])
	$UI/Overlay/Resume.connect('pressed', self, 'set_pause', [false])
	$UI/Overlay/MainMenu.connect('pressed', self, 'main_menu', [], CONNECT_ONESHOT)
	$UI/BlockScreen.mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_pause(p):
	get_tree().paused = p
	$UI/Overlay.visible = p
	$UI/PauseButton.pressed = p
	if p:
		Music.play(Music.PAUSE)
	else:
		Music.play(Music.GAME)

func main_menu():
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	get_tree().change_scene('res://game/screens/MainMenu.tscn')

func update_ui():
	var waffles = 0
	var rate = 0
	for scanner in $Scanners.get_children():
		waffles += scanner.waffle_count
		rate += scanner.waffle_rate
	$UI/LevelStats.update_waffles(waffles)
	$UI/LevelStats.update_rate(rate)
	if not goal_reached and waffles >= level_goal:
		goal_reached = true
		$UI/LevelStats.goal_reached()

func update_lines():
	# The *Magic* goes here
	for i in range($Plugs.get_child_count()):
		if plug_pos_cache[i] != $Plugs.get_child(i).position:
			plug_pos_cache[i] = $Plugs.get_child(i).position
			$Wires.get_child(i).points = get_simple_path(
				to_local(wire_origin_cache[i]),
				plug_pos_cache[i]
			)

func scanners_power_off():
	for s in $Scanners.get_children():
		s.power_off()

func game_over():
	yield(get_tree().create_timer(2.0), "timeout")
	$UI/GameOver.defeat()

func winner():
	Levels.unlock_next()
	yield(get_tree().create_timer(2.0), "timeout")
	var waffles = 0
	for scanner in $Scanners.get_children():
		waffles += scanner.waffle_count
	Levels.update_highscore(waffles)
	$UI/GameOver.victory(waffles, Levels.high_scores[Levels.current_level])

func on_level_timeout():
	print('LEVEL TIMEOUT')
	$UI/BlockScreen.mouse_filter = Control.MOUSE_FILTER_STOP
	scanners_power_off()
	if goal_reached:
		winner()
	else:
		game_over()

func on_Scanner_blowup():
	scanners -= 1
	if scanners == 0:
		$UI/Timebar.stop()
		if not goal_reached:
			game_over()
		else:
			winner()

func on_Plug_dragging():
	if not first_click:
		first_click = true
		for p in $Plugs.get_children():
			p.disconnect('dragging', self, 'on_Plug_dragging')
		play(false)
