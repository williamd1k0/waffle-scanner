extends Control

var level
var level_cache = [
	preload('res://game/gameplay/levels/1/LevelBase1.tscn'),
	preload('res://game/gameplay/levels/2/LevelBase2.tscn'),
	preload('res://game/gameplay/levels/3/LevelBase3.tscn'),
	preload('res://game/gameplay/levels/4/LevelBase4.tscn'),
]

var levels = []

func _ready():
	if not OS.is_debug_build():
		get_tree().quit()
	for l in level_cache:
		levels.append(l.instance())
	update_values(0)

func update_values(lv):
	$Settings/Goal/LineEdit.text = str(levels[lv].level_goal)
	$Settings/LevelTime/LineEdit.text = str(levels[lv].level_time)
	var scanner = levels[lv].get_node('Scanners').get_child(0)
	$Settings/HighSpeed/LineEdit.text = str(scanner.high_speed)
	$Settings/SafeTime/LineEdit.text = str(scanner.high_safe_time)
	$Settings/BlowTime/LineEdit.text = str(scanner.high_blowup_time)
	$Settings/RecoverTime/LineEdit.text = str(scanner.recovery_time)

func test_level():
	var level_time = float($Settings/LevelTime/LineEdit.text)
	var level_goal = int($Settings/Goal/LineEdit.text)
	level.get_node('UI/Timebar').level_time = level_time
	level.get_node('UI/LevelStats').update_goal(level_goal)
	for scanner in level.get_node('Scanners').get_children():
		scanner.high_speed = float($Settings/HighSpeed/LineEdit.text)
		scanner.high_safe_time = float($Settings/SafeTime/LineEdit.text)
		scanner.high_blowup_time = float($Settings/BlowTime/LineEdit.text)
		scanner.recovery_time = float($Settings/RecoverTime/LineEdit.text)
	hide()
	level.play()

func _on_Play_pressed():
	var lv = int($Settings/Level/LineEdit.text)
	if lv in range(1, 5):
		level = levels[lv-1]
		$Level.add_child(level)
		call_deferred('test_level')


func _on_Level_text_changed(lv):
	if int(lv) in range(1, 5):
		update_values(int(lv)-1)
