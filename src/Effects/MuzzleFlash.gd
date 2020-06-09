extends Spatial

export var flash_time: float = 0.05

var timer: Timer = null

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = flash_time
	timer.connect('timeout', self, '_on_timeout')
	hide()

func _on_timeout() -> void:
	end_flash()

func start_flash() -> void:
	timer.start()
	rotation.z = rand_range(0.0, 2 * PI)
	show()

func end_flash() -> void:
	hide()
