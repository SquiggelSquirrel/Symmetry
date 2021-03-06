extends Node

signal player1_hearts_change
signal player1_powerup_change
signal player2_hearts_change
signal player2_powerup_change
signal game_over
signal level_complete
signal level_start(path)
signal game_complete

var player1_hearts = 4 setget set_player1_hearts
var player1_powerup_id = -1 setget set_player1_powerup
var player2_hearts = 4 setget set_player2_hearts
var player2_powerup_id = -1 setget set_player2_powerup
var player_waypoints = [[],[]]
var is_game_over := false
var score := 0
var players_on_goals = 0 setget set_players_on_goals
var current_level = 1
var levels = {
	1: "res://Level1.tscn",
	2: "res://Level2.tscn",
	3: "res://Level3.tscn"
}


func set_players_on_goals(new_value :int) -> void:
	players_on_goals = new_value
	if players_on_goals == 2:
		emit_signal("level_complete")
		get_tree().call_deferred("set_pause", true)


func restart() -> void:
	player1_hearts = 4
	player1_powerup_id = -1
	player2_hearts = 4
	player2_powerup_id = -1
	player_waypoints = [[],[]]
	score = 0
	current_level = 1
	is_game_over = false
	var ok = get_tree().reload_current_scene()
	assert(ok == OK)


func next_level():
	current_level += 1
	player_waypoints = [[],[]]
	score = 0
	set_player1_powerup(-1)
	set_player2_powerup(-1)
	if levels.has(current_level):
		get_tree().paused = false
		emit_signal("level_start", levels[current_level])
	else:
		emit_signal("game_complete")


func set_player1_hearts(new_value :int) -> void:
	player1_hearts = new_value
	emit_signal("player1_hearts_change")


func set_player1_powerup(new_value :int) -> void:
	player1_powerup_id = new_value
	emit_signal("player1_powerup_change")


func set_player2_hearts(new_value :int) -> void:
	player2_hearts = new_value
	emit_signal("player2_hearts_change")


func set_player2_powerup(new_value :int) -> void:
	player2_powerup_id = new_value
	emit_signal("player2_powerup_change")


func on_Waypoint_body_entered(waypoint :Node2D, body :Node2D) -> void:
	var i = 0 if body.name == 'Player1' else 1
	if waypoint in player_waypoints[i]:
		return
	if waypoint == player_waypoints[1-i][0]:
		return
	if body.name == 'Player1':
		if player_waypoints[i].size() > 0:
			player_waypoints[i][-1].player1 = false
		waypoint.player1 = true
	else:
		if player_waypoints[i].size() > 0:
			player_waypoints[i][-1].player2 = false
		waypoint.player2 = true
	player_waypoints[i].append(waypoint)


func pop_waypoint(i :int) -> Node2D:
	var waypoint = player_waypoints[i][-1]
	
	if player_waypoints[i].size() > 1:
		player_waypoints[i].pop_back()
		waypoint.set_active(false)
		if i == 0:
			player_waypoints[i][-1].player1 = true
		else:
			player_waypoints[i][-1].player2 = true
	
	if player_waypoints[1-i][0] != waypoint:
		player_waypoints[1-i].erase(waypoint)
		if i == 0:
			player_waypoints[1-i][-1].player2 = true
		else:
			player_waypoints[1-i][-1].player1 = true
	
	return waypoint


func game_over():
	is_game_over = true
	emit_signal("game_over")
	get_tree().call_deferred("set_pause", true)
