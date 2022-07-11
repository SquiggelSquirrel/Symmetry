extends Camera2D

export(NodePath) var game
export(int) var player_id
onready var player = get_node(game).get_player_node(player_id)


func _process(_delta):
	position.x = player.position.x
	if player_id == 1:
		position.y = max(player.position.y, 160)
	else:
		position.y = min(player.position.y, 480)
