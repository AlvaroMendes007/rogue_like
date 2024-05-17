extends Area2D

@export var speed = 750
@export var bullet_damage: int = 1

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
	queue_free()
