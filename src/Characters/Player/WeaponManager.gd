extends Spatial

enum WEAPON_SLOTS { MACHETE, SHOTGUN, MACHINE_GUN, ROCKET_LAUNCHER }

onready var weapons: Array = $Weapons.get_children()

var slots_unlocked: Dictionary = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true
}
var current_slot = 0
var current_weapon = null

func _ready() -> void:
	pass

func switch_to_next_weapon() -> void:
	pass

func switch_to_prev_weapon() -> void:
	pass

func switch_to_weapon_index(index: int) -> void:
	pass

func disable_all_weapons() -> void:
	pass
