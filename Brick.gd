extends Area2D

export(NodePath) var target_player
export(NodePath) var other_player
export(bool) var bi = false
export(bool) var active = true
var velocity := Vector2.RIGHT
enum State {ORBIT, ATTACK, RETURN, ORBIT_OTHER, ATTACK_FROM_OTHER, RETURN_OTHER}
var current_state :int = State.ORBIT
onready var trigger = 'action_1' if get_node(target_player).name == 'Player1' else 'action_2'
var start_point
var start_speed
var t
var saved_position


func _ready():
	if get_node(target_player).name == 'Player1':
		var ok = Globals.connect("player1_powerup_change", self, "powerup_change")
		assert(ok == OK)
	else:
		var ok = Globals.connect("player2_powerup_change", self, "powerup_change")
		assert(ok == OK)
	var ok = get_node(target_player).connect('teleport', self, "_on_target_player_teleport")
	assert(ok == OK)
	ok = get_node(other_player).connect('teleport', self, "_on_other_player_teleport")
	assert(ok == OK)


func powerup_change():
	var id
	if get_node(target_player).name == 'Player1':
		id = Globals.player1_powerup_id
	else:
		id = Globals.player2_powerup_id
	match id:
		0:
			set_active(true)
			bi = false
			if current_state == State.ORBIT_OTHER:
				current_state = State.ORBIT
		1:
			set_active(true)
			bi = true
		_:
			set_active(false)


func set_active(new_value):
	active = new_value
	visible = active
	current_state = State.ORBIT


# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
static func parabola(start_point, end_point, distance, t) -> Vector2:
	var y = lerp(start_point.y, end_point.y, t)
	var x
	if t <= 0.5:
		x = start_point.x + (distance * ease(t * 2.0, 0.2))
	else:
		var apex = start_point.x + distance
		x = lerp(apex, end_point.x, ease((t - 0.5) * 2.0, 4.0))
	return Vector2(x, y)


func _process(delta):
	match current_state:
		State.ORBIT, State.ORBIT_OTHER:
			var target_position
			if current_state == State.ORBIT:
				target_position = get_node(target_player).position
			else:
				target_position = get_node(other_player).position
			var h = velocity.length_squared() / 32.0 + position.distance_squared_to(target_position)
			if h < 360:
				velocity *= 1.1
			if h > 420:
				velocity *= 0.9
			if abs(velocity.angle()) > PI / 2.0:
				velocity.x *= 1.05
				velocity.y *= 0.95
			velocity += (target_position - position) * delta * 32.0
			position += velocity * delta
		
		State.ATTACK:
			if ! Input.is_action_pressed(trigger):
				var max_speed = ease(t * 2.0, 0.2) * 400
				start_speed = clamp(start_speed, -max_speed, max_speed)
			var player = get_node(target_player)
			t += delta
			var old_position = position
			if bi:
				start_point = player.position
				var up = -1 if player.upside_down == get_parent().is_swapped else 1
				var end_point = player.position + Vector2.UP * -320 * up
				position = parabola(start_point, end_point, start_speed, t)
			else:
				position = parabola(start_point, player.position, start_speed, t)
			velocity = (position - old_position) / delta
			if t > 0.5:
				if bi:
					current_state = State.RETURN_OTHER
				else:
					current_state = State.RETURN
		
		State.ATTACK_FROM_OTHER:
			if ! Input.is_action_pressed(trigger):
				var max_speed = ease(t * 2.0, 0.2) * 400
				start_speed = clamp(start_speed, -max_speed, max_speed)
			var player = get_node(other_player)
			start_point = player.position
			var up = -1 if player.upside_down == get_parent().is_swapped else 1
			var end_point = player.position + Vector2.UP * -320 * up
			t += delta
			var old_position = position
			position = parabola(start_point, end_point, start_speed, t)
			velocity = (position - old_position) / delta
			if t > 0.5:
				current_state = State.RETURN
		
		State.RETURN:
			var player = get_node(target_player)
			t += delta
			var old_position = position
			if bi:
				var up = -1 if player.upside_down == get_parent().is_swapped else 1
				start_point = player.position + Vector2.UP * -320 * up
				var end_point = player.position
				position = parabola(start_point, end_point, start_speed, t)
			else:
				position = parabola(start_point, player.position, start_speed, t)
			velocity = (position - old_position) / delta
			if t >= 1.0:
				velocity = velocity.clamped(200.0)
				if Input.is_action_pressed(trigger):
					current_state = State.ATTACK
					enter_attack_state(player)
				else:
					current_state = State.ORBIT
		
		State.RETURN_OTHER:
			var player = get_node(other_player)
			t += delta
			var old_position = position
			var up = -1 if player.upside_down == get_parent().is_swapped else 1
			start_point = player.position + Vector2.UP * -320 * up
			var end_point = player.position
			position = parabola(start_point, end_point, start_speed, t)
			velocity = (position - old_position) / delta
			if t >= 1.0:
				velocity = velocity.clamped(200.0)
				if Input.is_action_pressed(trigger):
					current_state = State.ATTACK_FROM_OTHER
					enter_attack_state(player)
				else:
					if bi:
						current_state = State.ORBIT_OTHER
					else:
						current_state = State.ORBIT


func _input(event):
	if event.is_action_pressed(trigger) and active:
		match current_state:
			State.ORBIT:
				current_state = State.ATTACK
				enter_attack_state(get_node(target_player))
				$SFX.play()
			State.ORBIT_OTHER:
				current_state = State.ATTACK_FROM_OTHER
				enter_attack_state(get_node(other_player))
				$SFX.play()


func enter_attack_state(player_node :Node2D) -> void:
	start_point = player_node.position
	start_speed = 400.0 * player_node.facing
	t = 0.0


func _on_target_player_teleport() -> void:
	if current_state == State.ORBIT:
		position = get_node(target_player).position + Vector2(0,12)


func _on_other_player_teleport() -> void:
	if current_state == State.ORBIT_OTHER:
		position = get_node(other_player).position + Vector2(0,12)


func _on_Brick_body_entered(body):
	if current_state in [State.ORBIT, State.ORBIT_OTHER]:
		return
	if body.has_method("exorcise"):
		body.exorcise()
