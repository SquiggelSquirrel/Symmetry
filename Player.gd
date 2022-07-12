extends KinematicBody2D

export(bool) var upside_down = false
export(NodePath) var anim_tree
var velocity = Vector2()
var run_speed = 300
var gravity = 900
var jump_speed = -500
var facing = 1


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
