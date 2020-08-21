extends Area2D

var velocity: Vector2

export var speed := 300.0

func start(pos, dir) -> void:
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _process(delta: float) -> void:
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	queue_free()
