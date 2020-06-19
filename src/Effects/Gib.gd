extends KinematicBody

export var start_move_speed: float = 30
export var gravity: float = 35
export var drag: float = 0.01
export var vel_retained_on_bounce: float = 0.8

var vel: Vector3 = Vector3.ZERO
var initialised: bool = false

func init():
	initialised = true
	vel = -global_transform.basis.y * start_move_speed

func _physics_process(delta: float) -> void:
	if not initialised:
		return
	vel += -vel * drag + Vector3.DOWN * gravity * delta
	var col: KinematicCollision = move_and_collide(vel * delta)
	if col:
		var d: Vector3 = vel
		var n: Vector3 = col.normal
		var r: Vector3 = d - 2 * d.dot(n) * n
		vel = r * vel_retained_on_bounce
