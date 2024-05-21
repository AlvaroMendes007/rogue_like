extends Area2D

var laser_damage = 1
var player_position = Vector2.ZERO

var direction = Vector2.ZERO
var speed = 700

func _process(delta):
	update_laser_position(delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_position = body.global_position
		body.damage(laser_damage)
		queue_free()

func update_laser_position(delta):
	global_position += direction * speed * delta

func _on_timer_timeout():
	queue_free()
