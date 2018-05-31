extends Control

var colors

func _ready():
	colors = PostProcessing.DEFAULT_COLORS
	$VBoxContainer/Green/LineEdit.text = '#'+colors['sgreen'].to_html(false)
	$VBoxContainer/Yellow/LineEdit.text = '#'+colors['syellow'].to_html(false)
	$VBoxContainer/Purple/LineEdit.text = '#'+colors['spurple'].to_html(false)
	$VBoxContainer/Green/LineEdit.connect('text_changed', self, 'update_colors')
	$VBoxContainer/Yellow/LineEdit.connect('text_changed', self, 'update_colors')
	$VBoxContainer/Purple/LineEdit.connect('text_changed', self, 'update_colors')

func update_colors(__=null):
	var colors_ = {}
	colors_['sgreen'] = Color($VBoxContainer/Green/LineEdit.text)
	colors_['syellow'] = Color($VBoxContainer/Yellow/LineEdit.text)
	colors_['spurple'] = Color($VBoxContainer/Purple/LineEdit.text)
	PostProcessing.change_colors(colors_)


func _on_Back_pressed():
	get_tree().change_scene('res://game/screens/Splash.tscn')
