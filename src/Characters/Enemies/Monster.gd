extends KinematicBody

onready var anim_player: AnimationPlayer = $Model/AnimationPlayer
onready var health_controller: HealthController = $HealthController

enum STATES { IDLE, CHASE, ATTACK, DEAD }
var current_state = STATES.IDLE

func _ready() -> void:
	var bone_attachments: Array = $Model/Armature/Skeleton.get_children()
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is HitBox:
				child.connect('hurt', self, 'hurt')
	health_controller.connect('dead', self, 'set_state_dead')
	set_state_idle()

func _process(delta: float) -> void:
	match current_state:
		STATES.IDLE:
			pass
		STATES.CHASE:
			pass
		STATES.ATTACK:
			pass
		STATES.DEAD:
			pass

func set_state_idle() -> void:
	current_state = STATES.IDLE
	anim_player.play('idle_loop')

func set_state_chase() -> void:
	current_state = STATES.CHASE

func set_state_attack() -> void:
	current_state = STATES.ATTACK

func set_state_dead() -> void:
	current_state = STATES.DEAD
	anim_player.play('die')


func hurt(damage: int, direction: Vector3) -> void:
	health_controller.hurt(damage, direction)
