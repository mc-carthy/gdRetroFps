extends Spatial
class_name HealthController

signal dead
signal hurt
signal healed
signal health_changed
signal gibbed

export var max_health: int = 100
export var gib_at: int = -10

var current_health: int = 0
var blood_splatter = preload('res://src/Effects/BloodSplatter.tscn')

func _ready() -> void:
	init()

func init() -> void:
	current_health = max_health
	emit_signal('health_changed', current_health)

func hurt(damage: int, dir: Vector3) -> void:
	spawn_blood(dir)
	if current_health <= 0:
		return
	current_health -= damage
	if current_health <= gib_at:
		emit_signal('gibbed')
	if current_health <= 0:
		emit_signal('dead')
	emit_signal('hurt')
	emit_signal('health_changed', current_health)

func heal(amount: int) -> void:
	if current_health <= 0:
		return
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal('healed')
	emit_signal('health_changed', current_health)

func spawn_blood(dir: Vector3) -> void:
	var blood_splatter_instance = blood_splatter.instance()
	# Consider adding this to an effect folder
	get_tree().get_root().add_child(blood_splatter_instance)
	blood_splatter_instance.global_transform.origin = global_transform.origin
	if dir.angle_to(Vector3.UP) < 0.0005:
		return
	elif dir.angle_to(Vector3.DOWN) < 0.0005:
		blood_splatter_instance.rotate(Vector3.RIGHT, PI)
		return
	
	var y: Vector3 = dir
	var x: Vector3 = y.cross(Vector3.UP)
	var z: Vector3 = x.cross(y)
	
	blood_splatter_instance.global_transform.basis = Basis(x, y, z)
