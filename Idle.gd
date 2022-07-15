extends PlayerState


func _state_input(event :InputEvent) -> void:
	if event.is_action_pressed("action_jump"):
		next_state_name = "Jumping"
		return
	
	if get_input_x() != 0:
		next_state_name = "Running"
		return


func _state_physics_process(delta :float) -> void:
	._state_physics_process(delta)
	
	if ! get_player().is_on_floor():
		next_state_name = "Falling"
