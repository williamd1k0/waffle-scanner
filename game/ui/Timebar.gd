extends Sprite

signal timeout
const MAX_TILES = 88

export(float) var level_time = 80.0
var current_time = 0.0
var started = false

func _ready():
	if get_parent() == get_tree().root:
		start()

func start():
	started = true

func stop():
	$Warn.stop()
	started = false

func _process(delta):
	if started:
		current_time += delta
		if current_time <= level_time:
			frame = int(current_time*88/level_time)
			if frame >= MAX_TILES-15 and $AnimationPlayer.current_animation != 'clock2':
				$Warn.play()
				$AnimationPlayer.play('clock2')
		else:
			stop()
			emit_signal('timeout')
			set_process(false)
