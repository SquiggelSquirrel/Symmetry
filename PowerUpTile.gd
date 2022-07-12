tool
extends StateTile

export(int) var powerup_id setget set_powerup_id


func set_powerup_id(new_id) -> void:
	print('set_powerup_id ' + String(new_id))
	powerup_id = new_id
	region_rect.position.y = (new_id % 3) * 64
	region_rect.position.x = 224 + (new_id / 3) * 64
