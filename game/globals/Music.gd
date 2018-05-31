extends Node

enum Channels { MENU, GAME, PAUSE }

const DELAY = 0.1
var current_chan = -1
var playing = false
onready var tw = $Tween

func _ready():
	for c in get_children():
		if c is AudioStreamPlayer:
			c.volume_db = -80

func play_all():
	playing = true
	for c in get_children():
		if c is AudioStreamPlayer:
			c.play()

func mute():
	if current_chan != -1:
		tw.stop_all()
		tw.interpolate_property(
			get_child(current_chan), 'volume_db',
			0, -80, DELAY, tw.TRANS_LINEAR, tw.EASE_IN
		)
		current_chan = -1
		tw.start()

func play(chan):
	if chan != current_chan:
		tw.stop_all()
		if current_chan != -1:
			tw.interpolate_property(
				get_child(current_chan), 'volume_db',
				0, -80, DELAY, tw.TRANS_LINEAR, tw.EASE_IN
			)
		tw.interpolate_property(
			get_child(chan), 'volume_db',
			-80, 0, DELAY, tw.TRANS_LINEAR, tw.EASE_IN
		)
		current_chan = chan
		tw.start()
	if not playing:
		play_all()
