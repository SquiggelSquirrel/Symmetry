extends PlayerState

const RUN_SPEED := 200
signal skid
signal coyote_time_start


func _state_physics_process(delta :float) -> void:
	var player = get_player() as KinematicBody2D
	var facing = get_input_x()
	
	if facing != 0 and facing != player.facing:
		emit_signal("skid")
		emit_signal("facing_changed", facing)
	
	player.velocity.x = lerp(
			player.velocity.x,
			RUN_SPEED * facing,
			20.0 * delta)
	
	player.velocity = player.move_and_slide(player.velocity)
	
	if ! player.is_on_floor():
		emit_signal("coyote_time_start")
		next_state_name = "Falling"
		return
	
	if facing == 0 and abs(player.velocity.x) < 0.1:
		player.velocity = Vector2.ZERO
		next_state_name = "Idle"


func _state_input(event :InputEvent) -> void:
	if event.is_action_pressed("action_jump"):
		next_state_name = "Jumping"
