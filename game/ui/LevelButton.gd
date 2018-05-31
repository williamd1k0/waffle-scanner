tool
extends TextureButton

export(int) var level = 0 setget set_level

func set_level(l):
	level = l
	call_deferred('update_level')

func update_level():
	$Level.text = str(level)