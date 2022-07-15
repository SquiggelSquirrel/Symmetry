tool
extends Sprite


func _process(delta):
	region_rect.position.x += delta * 60.0
	if region_rect.position.x > 440:
		region_rect.position.x -= 24.0


func set_color_id(i):
	region_rect.position.y = 16 + (64.0 * i)
