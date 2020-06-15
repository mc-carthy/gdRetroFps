extends Area

var bodies_to_exclude: Array = []
var damage: int = 1

func set_damage(value: int) -> void:
	damage = value

func set_bodies_to_exclude(value: Array) -> void:
	bodies_to_exclude = value

func fire() -> void:
	for body in get_overlapping_bodies():
		if body in bodies_to_exclude:
			continue
		if body.has_method('hurt'):
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
		
