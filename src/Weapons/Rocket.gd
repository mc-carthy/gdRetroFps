extends KinematicBody

var explosion = preload("res://src/Weapons/Explosion.tscn")

var speed: float = 80
var impact_damage: int = 20
var exploded: bool = false

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
		explode()

func explode() -> void:
	if exploded:
		return
	exploded = true
	$CollisionShape.disabled = true
	var explosion_inst = explosion.instance()
	get_tree().get_root().add_child(explosion_inst)
	explosion_inst.global_transform.origin = global_transform.origin
	explosion_inst.explode()
	$SmokeTrail.emitting = false
	$Graphics.hide()
	$DestroyAfter.start()
