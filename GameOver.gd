extends CenterContainer


func _ready():
	var ok = Globals.connect("game_over", self, "show")
	assert(ok == OK)
