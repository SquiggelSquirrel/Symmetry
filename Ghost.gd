extends KinematicBody2D

const SPEED = 100.0
var velocity = Vector2.ZERO
var facing = -1
var active = true setget set_active
var t := 0.0


func _process(delta):
	if active:
		velocity = move_and_slide(velocity)
		if velocity.length_squared() < 100.0:
			facing *= -1
			velocity = Vector2(SPEED,0) * facing
	else:
		for body in $Nearby.get_overlapping_bodies():
			if body.has_method("hurt"):
				return
		t += delta
		if t < 4.0:
			return
		set_active(true)


func _on_Area2D_body_entered(body):
	if body.has_method('hurt'):
		body.hurt()


func exorcise():
	set_active(false)
	t = 0.0


func set_active(new_value):
	active = new_value
	visible = new_value
	$Area2D.monitoring = new_value
