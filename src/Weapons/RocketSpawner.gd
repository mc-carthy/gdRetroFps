extends Spatial

var rocket = preload('res://src/Weapons/Rocket.tscn')
var bodies_to_exclude: Array = []
var damage: int = 1

func set_damage(value: int) -> void:
	damage = value

func set_bodies_to_exclude(value: Array) -> void:
	bodies_to_exclude = value

func fire() -> void:
	var rocket_inst = rocket.instance()
	rocket_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(rocket_inst)
	rocket_inst.global_transform = global_transform
	rocket_inst.impact_damage = damage
