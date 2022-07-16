extends CenterContainer

export(NodePath) var title
export(NodePath) var gems


func _ready():
	var ok = Globals.connect("level_complete", self, "update_and_show")
	assert(ok == OK)


func update_and_show():
	get_node(title).text = (
			'Level ' + String(Globals.current_level) + ' Complete!')
	get_node(gems).text = (
		'Gems: ' + String(Globals.score) + '/100')
	show()
