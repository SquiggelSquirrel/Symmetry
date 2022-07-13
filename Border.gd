tool
extends TileMap

enum {BLUE_BORDER, SKULL, PINK_BORDER, HEART}


func _process(_delta :float) -> void:
	if ! Engine.editor_hint:
		return
	var parent := get_parent() as TileMap
	var changed = false
	
	var parent_cells = parent.get_used_cells()
	
	for parent_cell in parent_cells:
		var required_id
		if parent.get_cellv(parent_cell) == SKULL:
			required_id = BLUE_BORDER
		else:
			required_id = PINK_BORDER
		
		for my_cell in get_subcells(parent_cell):
			if get_cellv(my_cell) != required_id:
				changed = true
				set_cellv(my_cell, required_id)
	
	for old_cell in get_used_cells():
		var parent_cell = get_parent_cell(old_cell)
		if ! parent_cell in parent_cells:
			changed = true
			set_cellv(old_cell, -1)
	
	if changed:
		var used = get_used_rect()
		update_bitmask_region(used.position, used.end)


func get_subcells(parent_cell: Vector2) -> Array:
	var top_left = parent_cell * 2
	return [
		top_left,
		top_left + Vector2.RIGHT,
		top_left + Vector2.DOWN,
		top_left + Vector2.ONE
	]


func get_parent_cell(sub_cell :Vector2) -> Vector2:
	return Vector2(
		floor(sub_cell.x / 2),
		floor(sub_cell.y / 2)
	)
