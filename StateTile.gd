tool
extends Sprite
class_name StateTile

export(bool) var active = true setget set_active


func set_active(new_value :bool) -> void:
	active = new_value
	if active:
		modulate = Color(1.2,1.2,1.2,1.0)
	else:
		modulate = Color(0.1,0.1,0.1,0.5)
