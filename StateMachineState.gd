extends Node
class_name StateMachineState

signal state_entered
signal state_exited

var next_state_name := ""


func _state_physics_process(_delta :float) -> void:
	pass


func _state_input(_event :InputEvent) -> void:
	pass


func state_exit() -> void:
	emit_signal("state_exited")


func state_enter() -> void:
	next_state_name = ""
	emit_signal("state_entered")
