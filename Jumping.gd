extends PlayerState

const RUN_SPEED := 200
const INITIAL_SPEED = 500
const EARLY_RELEASE_CLAMP = 200
const GRAVITY = -900


func state_enter() -> void:
	.state_enter()
	get_player().velocity.y = INITIAL_SPEED * get_up()


func _state_physics_process(delta :float) -> void:
	var player = get_player() as KinematicBody2D
	var facing = get_input_x()
	
	if facing != 0 and facing != player.facing:
		emit_signal("facing_changed", facing)
	
	if ! Input.is_action_pressed("action_jump"):
		player.velocity.y = clamp(
				player.velocity.y,
				-EARLY_RELEASE_CLAMP,
				EARLY_RELEASE_CLAMP)
		next_state_name = "Falling"
	
	player.velocity.x = lerp(
			player.velocity.x,
			RUN_SPEED * facing,
			5.0 * delta)
	player.velocity.y += GRAVITY * get_up() * delta
	
	player.velocity = player.move_and_slide(player.velocity)
	
	if player.velocity.y * get_up() < 200.0 and next_state_name == "":
		next_state_name = "Hover"
