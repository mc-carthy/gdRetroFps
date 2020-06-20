extends Area
class_name PickupController

signal got_pickup

var max_player_health: int = 0
var current_player_health: int = 0

func _ready() -> void:
	connect('area_entered', self, '_on_area_entered')

func _on_area_entered(pickup: Pickup) -> void:
	if pickup.pickup_type == Pickup.PICKUP_TYPES.HEALTH:
		if current_player_health < max_player_health:
			emit_signal('got_pickup', pickup.pickup_type, pickup.amount)
			update_player_health(current_player_health + pickup.amount)
			pickup.queue_free()

func update_player_health(value: int) -> void:
	current_player_health = value

