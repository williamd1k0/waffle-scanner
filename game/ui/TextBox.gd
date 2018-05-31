tool
extends TextureRect

export(String, MULTILINE) var text = '' setget set_text

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here.
	pass

func set_text(t):
	text = t
	call_deferred('update_text')

func update_text():
	$Text.percent_visible = 0
	$Text.bbcode_text = '[fill]%s[/fill]' % text
	$Tween.interpolate_property(
		$Text, 'percent_visible',
		0.0, 1.0, 1.0,
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
