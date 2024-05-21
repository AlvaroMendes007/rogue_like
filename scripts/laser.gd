extends Area2D

var bullet_damage = 10
var player_position = Vector2.ZERO
var velocity = 200

var direction = Vector2.ZERO
var speed = 500

func _process(delta):
	update_laser_position(delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_position = body.global_position
		print("body: " + str(player_position))
		#body.damage(bullet_damage)d
		

func update_laser_position(delta):
	global_position += direction * speed * delta
