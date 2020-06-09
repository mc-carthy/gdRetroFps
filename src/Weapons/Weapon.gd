extends Spatial

signal fired
signal out_of_ammo

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var bullet_emitter_node: Spatial = $BulletEmitter
onready var bullet_emitters: Array = $BulletEmitter.get_children()
export var automatic: bool = false
export var damange: int = 5
export var ammo: int = 30
export var attack_rate: float = 0.2

var bullet_origin: Spatial
var bodies_to_exclude: Array = []
var attack_timer: Timer
var can_attack: bool = true

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect('timeout', self, '_on_attack_finished')
	attack_timer.one_shot = true
	add_child(attack_timer)

func init(_bullet_origin: Spatial, _bodies_to_exclude: Array) -> void:
	bullet_origin = _bullet_origin
	bodies_to_exclude = _bodies_to_exclude
	for bullet_emitter in bullet_emitters:
		bullet_emitter.set_damage(damange)
		bullet_emitter.set_bodies_to_exclude(bodies_to_exclude)

func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if !can_attack:
		return
	if automatic and !attack_input_held:
		return
	if !automatic and !attack_input_just_pressed:
		return
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal('out_of_ammo')
		return
	
	ammo -= 1
	
	var start_tx: Transform = bullet_emitter_node.global_transform
	bullet_emitter_node.global_transform = bullet_origin.global_transform
	
	for bullet_emitter in bullet_emitters:
		bullet_emitter.fire()
	bullet_emitter_node.global_transform = start_tx
	anim_player.stop()
	anim_player.play('Attack')
	emit_signal('fired')
	can_attack = false
	attack_timer.start()

func _on_attack_finished() -> void:
	can_attack = true

func set_active() -> void:
	show()

func set_inactive() -> void:
	anim_player.play('Idle')
	hide()
