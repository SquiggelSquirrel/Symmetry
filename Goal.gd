tool
extends Sprite

enum Player {ONE, TWO}
export(Player) var player := Player.ONE setget set_player
var player_on_goal = false


func _ready():
	var ok = Globals.connect("level_complete", self, "_on_level_complete")
	assert(ok == OK)
	match player:
		Player.ONE:
			region_rect.position.y = 0
			scale.y = 1
			$Area2D.collision_mask = 4
		Player.TWO:
			region_rect.position.y = 128
			scale.y = -1
			$Area2D.collision_mask = 8


func set_player(new_value):
	player = new_value
	if Engine.editor_hint:
		match player:
			Player.ONE:
				region_rect.position.y = 0
				scale.y = 1
				$Area2D.collision_mask = 4
			Player.TWO:
				region_rect.position.y = 128
				scale.y = -1
				$Area2D.collision_mask = 8


func _on_level_complete():
	$AnimationPlayer.play("activate")


func _on_Area2D_body_entered(_body):
	if player_on_goal:
		return
	player_on_goal = true
	Globals.players_on_goals += 1


func _on_Area2D_body_exited(_body):
	if ! player_on_goal:
		return
	player_on_goal = false
	Globals.players_on_goals -= 1
