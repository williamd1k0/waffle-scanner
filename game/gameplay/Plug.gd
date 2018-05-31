extends KinematicBody2D

signal dragging
signal plug_update(state)
enum {SDISABLE, SLOWV, SHIGHV}

var dragging = false
var connected = false

func _ready():
	$Sprite.frame = 0

func _input(event):
	if event is InputEventScreenTouch and not event.pressed:
		dragging = false

func _physics_process(delta):
	if dragging:
		var diff = get_global_mouse_position()-global_position
		if abs(diff.x) > 1.5 or abs(diff.y) > 1.5:
			move_and_slide(diff.normalized()*200)

func power_connect(type):
	dragging = type == 0
	connected = type != 0
	$Sprite.frame = int(connected)
	emit_signal('plug_update', type)
	if connected:
		$Plugged.play()


func _on_Touch_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		dragging = event.pressed
		if dragging:
			emit_signal('dragging')

