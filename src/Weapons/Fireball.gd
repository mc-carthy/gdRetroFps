extends KinematicBody

var speed: float = 20
var impact_damage: int = 20

func _ready() -> void:
	hide()

func set_bodies_to_exclude(bodies: Array) -> void:
	for body in bodies:
		add_collision_exception_with(body)

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision = move_and_collide(-global_transform.basis.z * speed * delta)
	if collision:
		var collider = collision.collider
		if collider.has_method('hurt'):
			collider.hurt(impact_damage, -global_transform.basis.z)
		$DestroyAfter.start()
		$CollisionShape.disabled = true
		$SmokeParticles.emitting = true
		$Graphics.hide()
		speed = 0
