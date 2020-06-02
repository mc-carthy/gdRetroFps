extends KinematicBody

export var mouse_sensitivity: float = 0.5

onready var camera: Camera = $Camera
onready var character_controller: CharacterController = $CharacterController
onready var health_controller: HealthController = $HealthController

var dead: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_controller.init(self)
	health_controller.init()
	health_controller.connect('dead', self, 'kill')

func _process(delta: float) -> void:
	if Input.is_action_pressed('exit'):
		get_tree().quit()
	
	if dead:
		return
	
	var move_vector: Vector3 = Vector3.ZERO
	if Input.is_action_pressed('move_forward'):
		move_vector += Vector3.FORWARD
	if Input.is_action_pressed('move_backward'):
		move_vector += Vector3.BACK
	if Input.is_action_pressed('move_left'):
		move_vector += Vector3.LEFT
	if Input.is_action_pressed('move_right'):
		move_vector += Vector3.RIGHT
	
	character_controller.set_move_vector(move_vector)
	
	if Input.is_action_just_pressed('jump'):
		character_controller.jump()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func hurt(damage: int, dir: Vector3) -> void:
	health_controller.hurt(damage, dir)

func heal(amount: int) -> void:
	health_controller.heal(amount)

func kill() -> void:
	dead = true
	character_controller.freeze()
