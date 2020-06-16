extends Spatial
class_name WeaponController

enum WEAPON_SLOTS { MACHETE, SHOTGUN, MACHINE_GUN, ROCKET_LAUNCHER }

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var weapons: Array = $Weapons.get_children()
onready var alert_area_hearing: Area = $AlertAreaHearing
onready var alert_area_los: Area = $AlertAreaLos

var slots_unlocked: Dictionary = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true
}
var current_slot: int = 0
var current_weapon = null
var bullet_origin: Spatial = null
var bodies_to_exclude: Array = []

func _ready() -> void:
	pass

func init(_bullet_origin: Spatial, _bodies_to_exclude: Array) -> void:
	bullet_origin = _bullet_origin
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method('init'):
			weapon.init(bullet_origin, bodies_to_exclude)
	weapons[WEAPON_SLOTS.MACHINE_GUN].connect('fired', self, 'alert_nearby_enemies')
	weapons[WEAPON_SLOTS.SHOTGUN].connect('fired', self, 'alert_nearby_enemies')
	weapons[WEAPON_SLOTS.ROCKET_LAUNCHER].connect('fired', self, 'alert_nearby_enemies')
	switch_to_weapon_index(WEAPON_SLOTS.MACHETE)

func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if current_weapon.has_method('attack'):
		current_weapon.attack(attack_input_just_pressed, attack_input_held)

func alert_nearby_enemies() -> void:
	var nearby_enemies: Array = alert_area_los.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method('alert'):
			nearby_enemy.alert()
	nearby_enemies = alert_area_hearing.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method('alert'):
			nearby_enemy.alert(false)

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

func update_animation(velocity: Vector3, grounded: bool) -> void:
	if current_weapon.has_method('is_idle') and not current_weapon.is_idle():
		anim_player.play('Idle')
	if !grounded or velocity.length() < 15:
		anim_player.play('Idle', 0.05)
	anim_player.play('Moving')
