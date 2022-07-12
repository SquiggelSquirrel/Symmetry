tool
extends StaticBody2D

export(int) var powerup_id setget set_powerup_id
export(bool) var upside_down = false setget set_upside_down


func hit_top(player):
	$Shake.play("shake down")


func hit_bottom(player):
	$Shake.play("shake up")


func set_powerup_id(new_id) -> void:
	powerup_id = new_id
	if get_node("Textures/Icon"):
		$Textures/Icon.region_rect.position.y = (new_id % 3) * 64
		$Textures/Icon.region_rect.position.x = 224 + (new_id / 3) * 64


func set_upside_down(new_value):
	upside_down = new_value
	if get_node("Textures/Icon"):
		$Textures/Icon.flip_v = new_value
