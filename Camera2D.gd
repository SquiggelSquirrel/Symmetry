extends Camera2D

export(NodePath) var game
export(int) var player_id
onready var player = get_node(game).get_player_node(player_id)


func _process(_delta):
	if ! player:
		return
	position = player.position
#	if player_id == 1:
#		position.y = 480
#	else:
#		position.y = 160
