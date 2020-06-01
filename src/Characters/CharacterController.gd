extends Spatial
class_name CharacterController

var body_to_move: KinematicBody = null

export var move_acceleration: float = 4
export var max_speed: float = 25
export var drag: float = 0
export var jump_force: float = 20
export var gravity: float = -60
export var use_local_rotation: bool = false

var jump_pressed: bool = false
var move_vector: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var snap_vector: Vector3 = Vector3.ZERO
var frozen: bool = false

signal movement_info

func init(_body_to_move: KinematicBody) -> void:
	body_to_move = _body_to_move

func _ready() -> void:
	drag = move_acceleration / max_speed

func jump() -> void:
	jump_pressed = true

# TODO: Look to replace this with setget
func set_move_vector(_move_vector: Vector3) -> void:
	move_vector = _move_vector.normalized()

func _physics_process(delta: float) -> void:
	if frozen:
		return
	var current_move_vector: Vector3 = move_vector
	if not use_local_rotation:
		current_move_vector = current_move_vector.rotated(Vector3.UP, body_to_move.rotation.y)
	velocity += move_acceleration * current_move_vector - velocity * Vector3(drag, 0, drag) + gravity * Vector3.UP * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)
	
	var grounded: bool = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01
	if grounded and jump_pressed:
		velocity.y = jump_force
		snap_vector = Vector3.ZERO
	else:
		snap_vector = Vector3.DOWN
		jump_pressed = false
	emit_signal('movement_info', velocity, grounded)

func freeze() -> void:
	frozen = true

func unfreeze() -> void:
	frozen = false
