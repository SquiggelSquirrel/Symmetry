extends StateMachineState
class_name PlayerState

# warning-ignore-all:unused_signal
signal facing_changed(new_facing)
signal hurt

const RUN_SPEED := 200
const GRAVITY = -900


func get_input_x() -> int:
	return (
		int(Input.is_action_pressed("action_right"))
		- int(Input.is_action_pressed("action_left"))
	)


func get_player() -> Node:
	return get_parent().get_parent()


func get_up() -> int:
	return 1 if get_player().upside_down else -1


func is_hurt() -> bool:
	var player = get_player()
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i)
		var collider = collision.collider
		if collider.name == "Spikes":
			return true
	return false
