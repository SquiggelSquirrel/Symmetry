extends Node2D

export(NodePath) var player_1
export(NodePath) var player_2
var is_swapped := false


func get_player_node(id):
	if id == 1:
		return get_node(player_1)
	else:
		return get_node(player_2)


func swap_players():
	var tmp = player_1
	player_1 = player_2
	player_2 = tmp
	is_swapped = ! is_swapped
