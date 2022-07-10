extends VBoxContainer


func _ready():
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d
