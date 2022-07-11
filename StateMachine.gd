extends Node

onready var active_state :StateMachineState = $Idle


func _physics_process(delta :float) -> void:
	if ! active_state:
		return
	active_state._state_physics_process(delta)
	if active_state.next_state_name != "":
		set_state(active_state.next_state_name)


func _input(event :InputEvent) -> void:
	if ! active_state:
		return
	active_state._state_input(event)
	if active_state.next_state_name != "":
		set_state(active_state.next_state_name)


func set_state(state_name :String) -> void:
	if active_state:
		active_state.state_exit()
	active_state = get_node(state_name)
	if active_state:
		active_state.state_enter()
