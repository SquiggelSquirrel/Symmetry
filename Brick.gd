extends Area2D

export(NodePath) var target_player
export(NodePath) var other_player
var velocity := Vector2.RIGHT
enum State {ORBIT, ATTACK, RETURN, ORBIT_OTHER, ATTACK_FROM_OTHER, RETURN_OTHER}
var current_state :int = State.ORBIT
onready var target_position :Vector2
onready var trigger = 'action_1' if get_node(target_player).name == 'Player1' else 'action_2'


func _process(delta):
	match current_state:
		State.ORBIT, State.ORBIT_OTHER:
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
		
		State.ATTACK, State.ATTACK_FROM_OTHER:
			velocity *= 0.9
			velocity += (target_position - position) * delta * 32.0
			velocity = velocity.clamped(
				position.distance_squared_to(target_position) / 2.0
			)
			position += velocity * delta
			if position.distance_squared_to(target_position) < 420.0:
				if current_state == State.ATTACK:
					current_state = State.RETURN_OTHER
				else:
					current_state = State.RETURN
			if ! Input.is_action_pressed(trigger):
				if current_state == State.ATTACK:
					current_state = State.RETURN_OTHER
				else:
					current_state = State.RETURN
		
		State.RETURN, State.RETURN_OTHER:
			velocity *= 0.9
			var player_node
			if current_state == State.RETURN:
				player_node = get_node(target_player)
			else:
				player_node = get_node(other_player)
			target_position = player_node.position
			
			velocity += (target_position - position) * delta * 48.0
			position += velocity * delta
			if position.distance_squared_to(target_position) < 420.0:
				velocity = velocity.clamped(210.0)
				if Input.is_action_pressed(trigger):
					if current_state == State.RETURN:
						current_state = State.ATTACK
					else:
						current_state = State.ATTACK_FROM_OTHER
					target_position = player_node.position + player_node.facing * Vector2.RIGHT * 7.0 * 64.0
				else:
					if current_state == State.RETURN:
						current_state = State.ORBIT
					else:
						current_state = State.ORBIT_OTHER


func _input(event):
	if event.is_action_pressed(trigger) and current_state in [State.ORBIT, State.ORBIT_OTHER]:
		var player_node
		if current_state == State.ORBIT:
			player_node = get_node(target_player)
			current_state = State.ATTACK
		else:
			player_node = get_node(other_player)
			current_state = State.ATTACK_FROM_OTHER
		target_position = player_node.position + player_node.facing * Vector2.RIGHT * 7.0 * 64.0
		target_position += Vector2.UP * 160.0
