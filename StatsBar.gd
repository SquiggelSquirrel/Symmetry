tool
extends Node2D

export(int) var player1_hearts = 4 setget set_player1_hearts
export(int) var player1_powerup_id = 0 setget set_player1_powerup_id
export(int) var player2_hearts = 4 setget set_player2_hearts
export(int) var player2_powerup_id = 0 setget set_player2_powerup_id


func _ready():
	var c
	c = Globals.connect("player1_hearts_change", self, "update_player1_hearts")
	assert(c == OK)
	c = Globals.connect("player1_powerup_change", self, "update_player1_powerup")
	assert(c == OK)
	c = Globals.connect("player2_hearts_change", self, "update_player2_hearts")
	assert(c == OK)
	c = Globals.connect("player2_powerup_change", self, "update_player2_powerup")
	assert(c == OK)


func update_player1_hearts():
	set_player1_hearts(Globals.player1_hearts)


func update_player1_powerup():
	set_player1_powerup_id(Globals.player1_powerup_id)


func update_player2_hearts():
	set_player2_hearts(Globals.player2_hearts)


func update_player2_powerup():
	set_player2_powerup_id(Globals.player2_powerup_id)


func set_player1_hearts(new_value :int) -> void:
	assert(new_value > -1)
	var i = 0
	for child in $Player1.get_children():
		if ! child.get("powerup_id") is int:
			child.active = (i < new_value)
		i += 1
	player1_hearts = new_value


func set_player2_hearts(new_value :int) -> void:
	assert(new_value > -1)
	var i = 0
	for child in $Player2.get_children():
		if ! child.get("powerup_id") is int:
			child.active = (i < new_value)
		i += 1
	player2_hearts = new_value


func set_player1_powerup_id(new_value :int) -> void:
	$Player1/PowerUp.powerup_id = new_value
	player1_powerup_id = new_value


func set_player2_powerup_id(new_value :int) -> void:
	$Player2/PowerUp.powerup_id = new_value
	player2_powerup_id = new_value
