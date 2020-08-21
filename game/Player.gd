extends KinematicBody2D
class_name Player


export var speed := Vector2(100.0, 100.0)


func _physics_process(delta: float) -> void:
	var movement := speed * get_direction()
	
	move_and_slide(movement, Vector2.ZERO)


func get_direction() -> Vector2:
	var x_direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_direction := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return Vector2(x_direction, y_direction)

func hurt() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")
