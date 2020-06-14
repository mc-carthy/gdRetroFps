extends Area

export var damage: int = 40

func explode() -> void:
	$ParticlesInner.emitting = true
	$ParticlesOuter.emitting = true
	var query: PhysicsShapeQueryParameters = PhysicsShapeQueryParameters.new()
	query.set_transform(global_transform)
	query.set_shape($CollisionShape.shape)
	query.collision_mask = collision_mask
	var space_state: PhysicsDirectSpaceState = get_world().get_direct_space_state()
	var results = space_state.intersect_shape(query)
	for result in results:
		if result.collider.has_method('hurt'):
			result.collider.hurt(damage, global_transform.origin.direction_to(result.collider.global_transform.origin))
