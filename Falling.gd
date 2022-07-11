extends PlayerState

const RUN_SPEED := 200
const GRAVITY = -900
const JUMP_BUFFER := 0.3
var jump_time := 0.0


func _state_physics_process(delta :float) -> void:
	var player = get_player() as KinematicBody2D
	var facing = get_input_x()
	
	if facing != 0 and facing != player.facing:
		emit_signal("facing_changed", facing)
	
	player.velocity.x = lerp(
			player.velocity.x,
			RUN_SPEED * facing,
			5.0 * delta)
	player.velocity.y += GRAVITY * get_up() * delta
	
	player.velocity = player.move_and_slide(player.velocity)
	
	jump_time += delta
	if player.is_on_floor():
		if jump_time < JUMP_BUFFER:
			next_state_name = "Jumping"
		elif abs(player.velocity.x) < 0.1:
			next_state_name = "Idle"
		else:
			next_state_name = "Running"


func _state_input(event :InputEvent) -> void:
	if event.is_action_pressed("action_jump"):
		jump_time = 0.0
