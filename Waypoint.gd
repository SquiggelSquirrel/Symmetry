tool
extends Area2D

export(bool) var infinite = false
export(bool) var player1 = false setget set_player1
export(bool) var player2 = false setget set_player2
var active = true setget set_active


func _ready():
	if player1:
		print("P1 waypoint ready")
		Globals.player_waypoints[0].append(self)
	if player2:
		Globals.player_waypoints[1].append(self)


func _on_Waypoint_body_entered(body):
	Globals.on_Waypoint_body_entered(self, body)


func set_player1(new_value):
	player1 = new_value
	update_flag()


func set_player2(new_value):
	player2 = new_value
	update_flag()


func update_flag():
	match int(player1) + 2 * int(player2):
		0:
			$flag.visible = false
		1:
			$flag.visible = true
			$flag.set_color_id(0)
		2:
			$flag.visible = true
			$flag.set_color_id(1)
		3:
			$flag.visible = true
			$flag.set_color_id(2)


func set_active(new_value):
	active = new_value
	if ! active:
		set_player1(false)
		set_player2(false)
		$Pole.region_rect.position.y = 128
		monitoring = false
