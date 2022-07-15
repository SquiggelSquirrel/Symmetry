extends Button


func _pressed():
	#var ok = get_tree().reload_current_scene()
	#assert(ok == OK)
	Globals.restart()
	get_tree().paused = false
