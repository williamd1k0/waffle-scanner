extends StaticBody2D

signal blowup
enum {SDISABLE, SLOWV, SHIGHV}

export(float) var low_speed = 1.0
export(float) var high_speed = 2.0
export(float) var high_safe_time = 4.0
export(float) var high_blowup_time = 6.0
export(float) var recovery_time = 15.0

var waffle_count = 0
var state = SDISABLE
var time_acc = 0
var waffle_rate = 1.0 #/s
var almost_blowing = false
var blowup = false
var blowup_acc = 0
var recover_acc = 0

func _ready():
	plug_update(state)
	if get_parent() == get_tree().root:
		plug_update(SLOWV)
		yield(get_tree().create_timer(3.0),"timeout")
		plug_update(SHIGHV)

func _process(delta):
	if waffle_rate != 0:
		time_acc += delta
		if time_acc >= 1.0/waffle_rate:
			time_acc = 0
			create_waffle()
	if almost_blowing and state != SHIGHV:
		recover_acc += delta
		if recover_acc >= recovery_time:
			recover_acc = 0
			blowup_acc = 0
			almost_blowing = false
			plug_update(state)
	if state == SHIGHV:
		blowup_acc += delta
		if blowup_acc >= high_safe_time and not almost_blowing:
			almost_blowing = true
			$Shaking.play()
			$AnimationPlayer.play("3-almost-blowup")
		elif blowup_acc >= high_blowup_time+high_safe_time and not blowup:
			waffle_rate = 0
			blowup = true
			$AnimationPlayer.play("4-blowup")
			emit_signal('blowup')
			set_process(false)
	elif almost_blowing:
		blowup_acc += delta

func create_waffle():
	waffle_count += 1

func power_off():
	set_process(false)
	if not blowup:
		$AnimationPlayer.play("0-disabled")

func plug_update(p_update):
	if blowup: return
	state = p_update
	if state == SDISABLE:
		waffle_rate = 0
		if not almost_blowing:
			$AnimationPlayer.play("0-disabled")
		else:
			$Shaking.play()
			$AnimationPlayer.play("6-recovery-disabled")
	elif state == SLOWV:
		waffle_rate = low_speed
		if almost_blowing:
			$AnimationPlayer.play("5-recovery-low")
		else:
			$AnimationPlayer.play("1-working-low")
	elif state == SHIGHV:
		waffle_rate = high_speed
		if not almost_blowing:
			$AnimationPlayer.play("2-working-high")
		else:
			$Shaking.play()
			$AnimationPlayer.play("3-almost-blowup")
