extends Label

var ammo: int = 0
var health: int = 0

func update_ammo(value: int) -> void:
	ammo = value
	update_display()

func update_health(value: int) -> void:
	health = value
	update_display()

func update_display() -> void:
	var ammoStr: String = str(ammo) if ammo >= 0 else 'INF'
	text = "Health: " + str(health) + "\nAmmo: " + ammoStr
