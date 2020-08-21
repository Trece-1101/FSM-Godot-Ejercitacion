extends Node2D

enum States {IDLE, ALERT, SHOOTING}

var state: int
var can_shoot := false
var player: Player
var follow_player := false
var state_text: String

export var bullet: PackedScene

onready var turret_arm := $TurretArm
onready var text_panel := $TextEdit
onready var shoot_timer := $ShootTimer
onready var alert_timer := $AlertTimer
onready var shoot_point := $TurretArm/ShootPoint

func _ready() -> void:
	state = States.IDLE
	state_text = "Idle"
	player = owner.get_node("Player")

func _process(delta: float) -> void:
	text_panel.text = state_text
	if not state in [States.IDLE]:
		turret_arm.look_at(player.get_global_position())
	
	if state in [States.SHOOTING] and can_shoot:
		can_shoot = false
		shoot_timer.start()
		shoot()

func shoot() -> void:
	var container := owner.get_node("BulletContainer")
	var new_bullet := bullet.instance()
	new_bullet.start(shoot_point.global_position, turret_arm.rotation)
	container.add_child(new_bullet)

func change_state(new_state: int) -> void:
	match new_state:
		States.IDLE:
			alert_timer.stop()
			state_text = "Idle"
			can_shoot = false
			follow_player = false
		States.ALERT:
			state_text = "Alert"
			follow_player = true
			alert_timer.start()
		States.SHOOTING:
			state_text = "Shooting"
			shoot_timer.start()
	
	state = new_state


func _on_ShootRange_body_entered(body: Node) -> void:
	change_state(States.ALERT)


func _on_ShootRange_body_exited(body: Node) -> void:
	change_state(States.IDLE)


func _on_CloseRange_body_entered(body: Node) -> void:
	change_state(States.SHOOTING)


func _on_AlertTimer_timeout() -> void:
	change_state(States.SHOOTING)


func _on_ShootTimer_timeout() -> void:
	can_shoot = true
