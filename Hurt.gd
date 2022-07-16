extends PlayerState

var t = 0.0


func state_enter() -> void:
	$SFX.play()
	.state_enter()
	begin_knockback()
	decrease_health()


func state_exit() -> void:
	.state_exit()
	var player = get_player()
	player.get_node("CollisionShape2D").disabled = false


func _state_physics_process(delta):
	var player = get_player()
	player.velocity.y += GRAVITY * get_up() * delta * 0.4
	player.velocity = player.move_and_slide(player.velocity)
	
	t += delta
	if t > 1.0:
		if ! Globals.is_game_over:
			resolve_hurt()
			next_state_name = "Idle"


func decrease_health():
	var player = get_player()
	if player.name == "Player1":
		if Globals.player1_powerup_id == 3:
			Globals.player1_powerup_id = -1
		else:
			Globals.player1_hearts -= 1
			if Globals.player1_hearts <= 0:
				pass
				Globals.game_over()
	else:
		if Globals.player2_powerup_id == 3:
			Globals.player2_powerup_id = -1
		else:
			Globals.player2_hearts -= 1
			if Globals.player2_hearts <= 0:
				Globals.game_over()


func begin_knockback():
	var player = get_player()
	player.get_node("CollisionShape2D").disabled = true
	player.velocity.x *= -0.6
	player.velocity.y = 160.0 * get_up()
	t = 0.0


func resolve_hurt():
	var player = get_player()
	var i = 0 if player.name == "Player1" else 1
	var waypoint = Globals.pop_waypoint(i)
	player.position = waypoint.position
