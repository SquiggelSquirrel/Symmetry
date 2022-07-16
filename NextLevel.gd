extends Button


func _pressed():
	$SFX.play()
	Globals.next_level()
	get_tree().paused = false
