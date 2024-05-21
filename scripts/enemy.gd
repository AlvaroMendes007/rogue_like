class_name Enemy

extends CharacterBody2D

@export var health: int = 5
@onready var area: Area2D = $Area2D
var laser_scene = preload("res://scenes/laser.tscn")       

func damage(amount: int) -> void:
	health -= amount
	$Label.text = str(health)
	if health <= 0:
		queue_free()

func attack(player_position: Vector2):
	var laser_instance = laser_scene.instantiate()
	add_child(laser_instance)
	
	var direction = (player_position - global_position).normalized()
	laser_instance.global_position = global_position + direction * 20
	laser_instance.rotation = direction.angle()
	
	laser_instance.direction = direction

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		attack(body.global_position)
