tool
extends AnimatedSprite

export(String) var default


func _on_animation_finished():
	play(default)
