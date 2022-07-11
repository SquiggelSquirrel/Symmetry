extends Node2D

export(NodePath) var root
var Dust = preload("res://Dust.tscn")


func spawn(anim_name :String) -> void:
	var dust = Dust.instance()
	get_node(root).add_child(dust)
	dust.position = global_position
	dust.play(anim_name)
