extends Area2D

var collected = false


func _on_Gem_body_entered(_body):
	if collected:
		return
	collected = true
	visible = false
	$SFX.play()
	Globals.score += 1
	var ok = $SFX.connect("finished", self, "queue_free")
	assert(ok == OK)
