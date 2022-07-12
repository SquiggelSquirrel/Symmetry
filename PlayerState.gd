extends StateMachineState
class_name PlayerState

# warning-ignore:unused_signal
signal facing_changed(new_facing)


func get_input_x() -> int:
	return (
		int(Input.is_action_pressed("action_right"))
		- int(Input.is_action_pressed("action_left"))
	)


func get_player() -> Node:
	return get_parent().get_parent()


func get_up() -> int:
	return 1 if get_player().upside_down else -1
