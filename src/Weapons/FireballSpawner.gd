extends Spatial

var fireball = preload('res://src/Weapons/Fireball.tscn')
var bodies_to_exclude: Array = []
var damage: int = 1

func set_damage(value: int) -> void:
	damage = value

func set_bodies_to_exclude(value: Array) -> void:
	bodies_to_exclude = value

func fire() -> void:
	var fireball_inst = fireball.instance()
	fireball_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(fireball_inst)
	fireball_inst.global_transform = global_transform
	fireball_inst.impact_damage = damage
