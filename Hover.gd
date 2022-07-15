extends PlayerState

const HOVER_LIMIT := 0.3
var hover_time := 0.0


func state_enter() -> void:
	.state_enter()
	hover_time = 0.0


func _state_physics_process(delta :float) -> void:
	var player = get_player() as KinematicBody2D
	var facing = get_input_x()
	
	if facing != 0 and facing != player.facing:
		emit_signal("facing_changed", facing)
	
	if Input.is_action_pressed("action_jump"):
		hover_time += delta
		if hover_time > HOVER_LIMIT:
			next_state_name = "Falling"
		player.velocity.y = lerp(player.velocity.y, 0.0, 10.0 * delta)
	else:
		player.velocity.y += GRAVITY * get_up() * delta
		next_state_name = "Falling"
	
	player.velocity.x = lerp(
			player.velocity.x,
			RUN_SPEED * facing,
			10.0 * delta)
	
	player.velocity = player.move_and_slide(player.velocity)
	
	if is_hurt():
		next_state_name = "Hurt"
		return
