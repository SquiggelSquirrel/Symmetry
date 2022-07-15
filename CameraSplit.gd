extends PanelContainer

export(NodePath) var cam1
export(NodePath) var cam2


func _process(delta) -> void:
	var c1 = get_node(cam1)
	var c2 = get_node(cam2)
	if (
			abs(c1.position.x - c2.position.x) < 0.5
			and abs(c2.position.y - c1.position.y - 320) < 0.5
	):
		modulate.a = lerp(modulate.a, 0.0, delta)
	else:
		modulate.a = lerp(modulate.a, 1.0, delta)
