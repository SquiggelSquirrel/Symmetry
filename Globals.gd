extends Node

signal player1_hearts_change
signal player1_powerup_change
signal player2_hearts_change
signal player2_powerup_change

var player1_hearts = 4 setget set_player1_hearts
var player1_powerup_id = 0 setget set_player1_powerup
var player2_hearts = 4 setget set_player2_hearts
var player2_powerup_id = 0 setget set_player2_powerup


func set_player1_hearts(new_value):
	player1_hearts = new_value
	emit_signal("player1_hearts_change")


func set_player1_powerup(new_value):
	player1_powerup_id = new_value
	emit_signal("player1_powerup_change")


func set_player2_hearts(new_value):
	player2_hearts = new_value
	emit_signal("player2_hearts_change")


func set_player2_powerup(new_value):
	player2_powerup_id = new_value
	emit_signal("player2_powerup_change")
