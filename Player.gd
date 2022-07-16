extends KinematicBody2D

signal teleport

export(bool) var upside_down = false
export(NodePath) var anim_tree
var velocity = Vector2()
var run_speed = 300
var gravity = 900
var jump_speed = -500
var facing = 1
onready var trigger = 'action_1' if name == 'Player1' else 'action_2'


func _input(event):
	if ! event.is_action_pressed(trigger):
		return
	
	var powerup_key
	var other_player
	var hearts_key
	if name == 'Player1':
		powerup_key = "player1_powerup_id"
		other_player = get_node("../Player2")
		hearts_key = "player1_hearts"
	else:
		powerup_key = "player2_powerup_id"
		other_player = get_node("../Player1")
		hearts_key = "player2_hearts"
	
	match Globals.get(powerup_key):
		3:
			if Globals.get(hearts_key) < 4:
				Globals.set(hearts_key, Globals.get(hearts_key) + 1)
				Globals.set(powerup_key, -1)
		5:
			var tmp = position
			position = other_player.position
			other_player.position = tmp
			emit_signal("teleport")
			other_player.emit_signal("teleport")
			get_node("../..").swap_players()


func hurt():
	if $StateMachine.active_state.name != "Hurt":
		$StateMachine.set_state("Hurt")


func is_on_floor() -> bool:
	return $RayCast2D.is_colliding()


func get_state_machine() -> AnimationNodeStateMachine:
	return get_node(anim_tree)["parameters/playback"]


func _on_facing_changed(new_facing):
	facing = new_facing
	$puppet.scale.x = abs($puppet.scale.x) * facing


func _on_Idle_state_entered():
	get_state_machine().travel("PlayerSpriteIdle")


func _on_Running_state_entered():
	get_state_machine().travel("PlayerSpriteRunning")


func _on_Running_skid():
	get_state_machine().travel("Skid")


func _on_Jumping_state_entered():
	get_state_machine().travel("PlayerSpriteJumping")


func _on_Hover_state_entered():
	get_state_machine().travel("PlayerSpriteJumpingToFalling")


func _on_Falling_state_entered():
	get_state_machine().travel("PlayerSpriteFalling")


func _on_Hurt_state_entered():
	$puppet.modulate.v = 0.3
	get_state_machine().travel("PlayerSpriteFalling")


func _on_Hurt_state_exited():
	$puppet.modulate.v = 1.0
	emit_signal("teleport")
