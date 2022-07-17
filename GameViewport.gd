extends Viewport


func _ready():
	var ok = Globals.connect("level_start", self, "switch_level")
	assert(ok == OK)


func switch_level(new_level):
	var new_scene = load(new_level) as PackedScene
	var instance = new_scene.instance()
	$Game.name = "OldGame"
	$OldGame.queue_free()
	add_child(instance)
	instance.name = "Game"
