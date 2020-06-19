extends Spatial

func _ready() -> void:
	hide()

func enable_gibs() -> void:
	show()
	for child in get_children():
		if child.has_method('init'):
			child.init()
		if 'emitting' in child:
			child.emitting = true
