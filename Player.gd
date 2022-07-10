extends KinematicBody2D

export var upside_down = false
var velocity = Vector2()
var run_speed = 300
var gravity = 900
var jump_speed = -500


func _physics_process(delta):
	var input_vector = (
		int(Input.is_action_pressed("action_right"))
		- int(Input.is_action_pressed("action_left"))
	)
	velocity.x = lerp(
			velocity.x,
			input_vector * run_speed,
			delta * 2.0)
	
	if velocity.y == 0.0 and Input.is_action_just_pressed("action_jump"):
		velocity.y = -jump_speed if upside_down else jump_speed
	else:
		velocity.y += (-gravity if upside_down else gravity) * delta
	
	velocity = move_and_slide(velocity)
