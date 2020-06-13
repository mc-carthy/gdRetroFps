extends KinematicBody

const HOT_KEYS: Dictionary = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3
}

export var mouse_sensitivity: float = 0.5

onready var camera: Camera = $Camera
onready var character_controller: CharacterController = $CharacterController
onready var health_controller: HealthController = $HealthController
onready var weapon_controller: WeaponController = $Camera/WeaponController

var dead: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_controller.init(self)
	health_controller.init()
	health_controller.connect('dead', self, 'kill')
	weapon_controller.init($Camera/BulletOrigin, [self])

func _process(delta: float) -> void:
	if Input.is_action_pressed('exit'):
		get_tree().quit()
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()
	
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
	
	weapon_controller.attack(Input.is_action_just_pressed('attack'), Input.is_action_pressed('attack'))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if event is InputEventKey and event.pressed:
		if event.scancode in HOT_KEYS:
			weapon_controller.switch_to_weapon_index(HOT_KEYS[event.scancode])
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_controller.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_controller.switch_to_prev_weapon()

func hurt(damage: int, dir: Vector3) -> void:
	health_controller.hurt(damage, dir)

func heal(amount: int) -> void:
	health_controller.heal(amount)

func kill() -> void:
	dead = true
	character_controller.freeze()


func start_flash() -> void:
	pass # Replace with function body.
