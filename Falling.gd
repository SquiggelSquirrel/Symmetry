extends PlayerState

const RUN_SPEED := 200
const GRAVITY = -900
const JUMP_BUFFER := 0.2
const COYOTE_LIMIT := 0.1
var jump_time := 0.0
var coyote_time := 1.0


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
	
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i)
		if abs(collision.normal.x) < 0.1:
			var collider = collision.collider
			if ! player.upside_down:
				if collider.has_method("hit_top"):
					collider.hit_top(self)
			else:
				if collider.has_method("hit_bottom"):
					collider.hit_bottom(self)
	
	jump_time += delta
	coyote_time += delta
	if player.is_on_floor():
		if jump_time < JUMP_BUFFER and Input.is_action_pressed("action_jump"):
			next_state_name = "Jumping"
		elif abs(player.velocity.x) < 0.1:
			next_state_name = "Idle"
		else:
			next_state_name = "Running"


func _state_input(event :InputEvent) -> void:
	if event.is_action_pressed("action_jump"):
		if coyote_time < COYOTE_LIMIT:
			coyote_time = 1.0
			next_state_name = "Jumping"
		jump_time = 0.0


func _on_Running_coyote_time_start():
	coyote_time = 0.0
