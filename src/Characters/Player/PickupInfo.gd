extends Label

const MAX_LINES: int = 5
var pickups_info: Array = []

func _ready() -> void:
	text = ''

func add_pickups_info(pickup_type: int, amount: int) -> void:
	$RemoveTimer.start()
	match pickup_type:
		Pickup.PICKUP_TYPES.MACHINE_GUN:
			pickups_info.push_back('Picked up Machine Gun')
		Pickup.PICKUP_TYPES.MACHINE_GUN_AMMO:
			pickups_info.push_back('Picked up Machine Gun ammo x ' + str(amount))
		Pickup.PICKUP_TYPES.SHOTGUN:
			pickups_info.push_back('Picked up Shotgun')
		Pickup.PICKUP_TYPES.SHOTGUN_AMMO:
			pickups_info.push_back('Picked up Shotgun ammo x ' + str(amount))
		Pickup.PICKUP_TYPES.ROCKET_LAUNCHER:
			pickups_info.push_back('Picked up Rocket Launcher')
		Pickup.PICKUP_TYPES.ROCKET_LAUNCHER_AMMO:
			pickups_info.push_back('Picked up Rocket Launcher ammo x ' + str(amount))
	while pickups_info.size() > MAX_LINES:
		pickups_info.pop_front()
	update_display()

func update_display() -> void:
	text = ''
	for pickup_info in pickups_info:
		text += pickup_info + "\n"

func remove_pickups_info() -> void:
	if pickups_info.size() > 0:
		pickups_info.pop_front()
	update_display()
