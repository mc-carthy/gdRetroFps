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

func _ready() -> void:
	init()

func init() -> void:
	current_health = max_health
	emit_signal('health_changed', current_health)

func hurt(damage: int, dir: Vector3) -> void:
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
