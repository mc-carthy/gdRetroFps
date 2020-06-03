extends Spatial
class_name WeaponController

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
	current_slot = (current_slot + 1) % slots_unlocked.size()
	if !slots_unlocked[current_slot]:
		switch_to_next_weapon()
	else:
		switch_to_weapon_index(current_slot)

func switch_to_prev_weapon() -> void:
	current_slot = posmod(current_slot - 1, slots_unlocked.size())
	if !slots_unlocked[current_slot]:
		switch_to_prev_weapon()
	else:
		switch_to_weapon_index(current_slot)

func switch_to_weapon_index(index: int) -> void:
	if index < 0 or index > slots_unlocked.size() or !slots_unlocked[index]:
		return
	disable_all_weapons()
	current_weapon = weapons[index]
	if current_weapon.has_method('set_active'):
		current_weapon.set_active()
	else:
		current_weapon.show()

func disable_all_weapons() -> void:
	for weapon in weapons:
		if weapon.has_method('set_inactive'):
			weapon.set_inactive()
		else:
			weapon.hide()
