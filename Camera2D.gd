extends Camera2D

export(NodePath) var game
export(int) var player_id


func _process(_delta):
	if ! get_node_or_null(game):
		print(game)
		print(get_node('../../../ViewportContainer/Viewport').get_children())
		return
	var player = get_node(game).get_player_node(player_id)
	if ! player:
		return
	position = player.position
	if player.upside_down:
		position += Vector2(0,2)
	else:
		position += Vector2(0,-2)
