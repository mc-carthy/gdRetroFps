extends KinematicBody

signal attack

enum STATES { IDLE, CHASE, ATTACK, DEAD }

export var view_angle: float = 45
export var view_dist: float = 50
export var turn_speed: float = 360
export var attack_distance: float = 2
export var attack_rate: float = 1
export var attack_angle: float = 5

onready var anim_player: AnimationPlayer = $Model/AnimationPlayer
onready var health_controller: HealthController = $HealthController
onready var character_controller: CharacterController = $CharacterController
onready var nav: Navigation = get_parent()

var current_state = STATES.IDLE
var player = null
var path_to_target: Array = []
var attack_timer: Timer
var can_attack: bool = true

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect('timeout', self, '_on_attack_finished')
	attack_timer.one_shot = true
	add_child((attack_timer))
	
	player = get_tree().get_nodes_in_group('Player')[0]
	var bone_attachments: Array = $Model/Armature/Skeleton.get_children()
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is HitBox:
				child.connect('hurt', self, 'hurt')
	health_controller.connect('dead', self, 'set_state_dead')
	health_controller.connect('gibbed', $Model, 'hide')
	character_controller.init(self)
	set_state_idle()

func _process(delta: float) -> void:
	match current_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func start_attack() -> void:
	attack_timer.start()
	anim_player.stop()
	anim_player.play('attack')
	can_attack = false

func emit_attack_signal() -> void:
	emit_signal('attack')

func _on_attack_finished() -> void:
	can_attack = true
	attack_timer.wait_time = attack_rate

func set_state_idle() -> void:
	current_state = STATES.IDLE
	anim_player.stop()
	anim_player.play('idle_loop')

func set_state_chase() -> void:
	current_state = STATES.CHASE
	anim_player.stop()
	anim_player.play('walk_loop')

func set_state_attack() -> void:
	current_state = STATES.ATTACK

func set_state_dead() -> void:
	current_state = STATES.DEAD
	anim_player.stop()
	anim_player.play('die')
	character_controller.freeze()
	$CollisionShape.disabled = true

func process_state_idle(delta: float) -> void:
	if can_see_player():
		set_state_chase()

func process_state_chase(delta: float) -> void:
	if within_attack_range_of_player() and has_los_player():
		set_state_attack()
		return
	var pos: Vector3 = global_transform.origin
	var target_pos: Vector3 = player.global_transform.origin
	path_to_target = nav.get_simple_path(pos, target_pos)
	var next_waypoint: Vector3 = target_pos
	if path_to_target.size() > 1:
		next_waypoint = path_to_target[1]
	var dir: Vector3 = pos.direction_to(next_waypoint)
	dir.y = 0
	character_controller.set_move_vector(dir)
	face_direction(dir, delta)

func process_state_attack(delta: float) -> void:
	character_controller.set_move_vector(Vector3.ZERO)
	if !player_within_angle(attack_angle):
		face_direction(global_transform.origin.direction_to(player.global_transform.origin), delta)
	if can_attack:
		if !within_attack_range_of_player() or !can_see_player():
			set_state_chase()
		else:
			start_attack()

func process_state_dead(delta: float) -> void:
	pass

func hurt(damage: int, direction: Vector3) -> void:
	health_controller.hurt(damage, direction)
	if current_state == STATES.IDLE:
		set_state_chase()

func can_see_player() -> bool:
	return player_within_view_dist() and player_within_angle(view_angle) and has_los_player()
	

func player_within_view_dist() -> bool:
	# Currently hard coded to allow weapon area to use distance-based query
	return true
	#return global_transform.origin.distance_squared_to(player.global_transform.origin) < pow(view_dist, 2)

func player_within_angle(angle: float) -> bool:
	var dir_to_player: Vector3 = global_transform.origin.direction_to(player.global_transform.origin)
	var forward_vector: Vector3 = global_transform.basis.z
	var angle_to_player: float = rad2deg(forward_vector.angle_to(dir_to_player))
	return angle_to_player < angle

func has_los_player() -> bool:
	# The monster/player origins are on the floor, raise them to eye level to prevent unintentional collisions
	var floor_offset = Vector3.UP * 1.8
	var pos: Vector3 = global_transform.origin + floor_offset
	var player_pos: Vector3 = player.global_transform.origin + floor_offset
	var space_state: PhysicsDirectSpaceState = get_world().get_direct_space_state()
	var result = space_state.intersect_ray(pos, player_pos, [], 1)
	if result:
		 return false
	return true

func alert(check_los: bool = true) -> void:
	if current_state != STATES.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()

func face_direction(dir: Vector3, delta: float) -> void:
	var angle_diff: float = global_transform.basis.z.angle_to(dir)
	var turn_right: float = sign(global_transform.basis.x.dot(dir))
	if abs(angle_diff) < deg2rad(turn_speed) * delta:
		rotation.y = atan2(dir.x, dir.z)
	else:
		rotation.y += deg2rad(turn_speed) * delta * turn_right

func within_attack_range_of_player() ->  bool:
	return global_transform.origin.distance_squared_to(player.global_transform.origin) < pow(attack_distance, 2)
