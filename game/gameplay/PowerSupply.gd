extends Sprite

const rate = 0.125
var time = 0
var connected = false
var v_frames = [[0, 1], [2, 3]]
onready var outlet = $ElectricalOutlet

func _ready():
	$Voltage.frame = v_frames[outlet.voltage][0]

func _process(delta):
	if connected:
		time += delta
		if time >= rate:
			time = 0
			frame = int(not frame)
			$Voltage.frame = v_frames[outlet.voltage][frame]

func enable():
	connected = true

func disable():
	connected = false
	frame = 0
	$Voltage.frame = v_frames[outlet.voltage][0]