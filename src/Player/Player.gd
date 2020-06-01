extends KinematicBody

func _process(delta: float) -> void:
	if Input.is_action_pressed('exit'):
		get_tree().quit()
