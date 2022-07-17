extends CenterContainer


func _ready():
	var ok = Globals.connect("game_complete", self, "show")
	assert(ok == OK)
