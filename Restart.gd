extends Button


func _pressed():
	$SFX.play()
	Globals.restart()
	get_tree().paused = false
