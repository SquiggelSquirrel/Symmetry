tool
extends StaticBody2D

export(int) var powerup_id setget set_powerup_id
export(bool) var upside_down = false setget set_upside_down
var double_tap_prevented := false


func hit_top(player):
	$Shake.play("shake down")
	hit(player)


func hit_bottom(player):
	$Shake.play("shake up")
	hit(player)


func hit(player):
	if double_tap_prevented:
		return
	double_tap_prevented = true
	var ok = get_tree().create_timer(0.5).connect(
			"timeout", self, "double_tap_timeout")
	assert(ok == OK)
	match player.name:
		'Player1':
			var tmp_powerup_id = Globals.player1_powerup_id
			Globals.player1_powerup_id = powerup_id
			set_powerup_id(tmp_powerup_id)
		'Player2':
			var tmp_powerup_id = Globals.player2_powerup_id
			Globals.player2_powerup_id = powerup_id
			set_powerup_id(tmp_powerup_id)
		_:
			assert(false)


func double_tap_timeout():
	double_tap_prevented = false


func set_powerup_id(new_id) -> void:
	powerup_id = new_id
	if get_node_or_null("Textures/Icon"):
		$Textures/Icon.region_rect.position.y = (new_id % 3) * 64
		$Textures/Icon.region_rect.position.x = 224 + (new_id / 3) * 64


func set_upside_down(new_value):
	upside_down = new_value
	if get_node_or_null("Textures/Icon"):
		$Textures/Icon.flip_v = new_value
