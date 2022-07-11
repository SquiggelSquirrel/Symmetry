extends AnimatedSprite

export(NodePath) var dust
var queue = []


func begin_idle():
	play("Idle")


func begin_run():
	play("Starting")
	queue.push("Running")


func _on_animation_finished():
	if queue.size() > 0:
		play(queue.pop())
