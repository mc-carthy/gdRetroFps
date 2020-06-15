extends Area
class_name HitBox

signal hurt

export var weak_spot: bool = false
export var critical_damage_multiplier: float = 2

func hurt(damage: int, direction: Vector3) -> void:
	if weak_spot:
		emit_signal('hurt', damage * critical_damage_multiplier, direction)
	else:
		emit_signal('hurt', damage, direction)
