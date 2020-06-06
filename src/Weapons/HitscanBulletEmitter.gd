extends Spatial
class_name HitScanBulletEmitter
var hit_effect = preload('res://src/Effects/BulletHitEffect.tscn')

export var distance: int = 10000
var bodies_to_exclude: Array = []
var damage: int = 1

func set_damage(value: int) -> void:
	damage = value

func set_bodies_to_exclude(value: Array) -> void:
	bodies_to_exclude = value

func fire() -> void:
	var space_state = get_world().get_direct_space_state()
	var origin_pos = global_transform.origin
	var hit = space_state.intersect_ray(origin_pos, origin_pos - global_transform.basis.z * distance, bodies_to_exclude, 1 + 2 + 4, true, true)
	if hit and hit.collider.has_method('hurt'):
		hit.collider.hurt(damage, hit.normal)
	elif hit:
		var hit_effect_instance = hit_effect.instance()
		# Consider adding this to an effect folder
		get_tree().get_root().add_child(hit_effect_instance)
		hit_effect_instance.global_transform.origin = hit.position
		if hit.normal.angle_to(Vector3.UP) < 0.0005:
			return
		elif hit.normal.angle_to(Vector3.DOWN) < 0.0005:
			hit_effect_instance.rotate(Vector3.RIGHT, PI)
			return
		
		var y: Vector3 = hit.normal
		var x: Vector3 = y.cross(Vector3.UP)
		var z: Vector3 = x.cross(y)
		
		hit_effect_instance.global_transform.basis = Basis(x, y, z)
