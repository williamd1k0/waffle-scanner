extends CanvasLayer

const DEFAULT_COLORS = {
	'sgreen': Color('#288e6e'),
	'syellow': Color('#d6ab3d'),
	'spurple': Color('#6b2e8f')
}

func _ready():
	if ProjectSettings.get_setting('rendering/quality/driver/driver_name') == 'GLES3':
		change_colors(DEFAULT_COLORS)
	else:
		queue_free()

func change_colors(colors):
	for c in colors:
		$PaletteSwap.material.set_shader_param(c, colors[c])
