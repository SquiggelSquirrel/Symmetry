extends PlayerState

const INITIAL_SPEED = 500
const EARLY_RELEASE_CLAMP = 200


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
	
	if is_hurt():
		next_state_name = "Hurt"
		return
	
	var is_on_ceiling = false
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i)
		if abs(collision.normal.x) < 0.1:
			is_on_ceiling = true
			var collider = collision.collider
			if player.upside_down:
				if collider.has_method("hit_top"):
					collider.hit_top(player)
			else:
				if collider.has_method("hit_bottom"):
					collider.hit_bottom(player)
	
	if player.velocity.y * get_up() < 200.0 and next_state_name == "":
		if is_on_ceiling:
			next_state_name = "Falling"
		else:
			next_state_name = "Hover"
