class_name Enemy

extends CharacterBody2D

signal enemy_died(xp_reward: int)

var xp_reward = 10
@export var health: int = 5
@onready var area: Area2D = $Area2D
@onready var timer_attack = $Timer
@onready var animation = $AnimatedSprite2D
var laser_scene = preload("res://scenes/laser.tscn")       

var player = null
var player_position = Vector2.ZERO
var player_in_area = false

func _process(delta):
	if player_in_area:
		player_position = player.global_position

func damage(amount: int) -> void:
	health -= amount
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	$Label.text = str(health)
	if health <= 0:
		if health < 0:
			$Label.text = "0"
		die()

func attack(player_position: Vector2):
	var laser_instance = laser_scene.instantiate()
	add_child(laser_instance)
	
	var direction = (player_position - global_position).normalized()
	laser_instance.global_position = global_position + direction * 20
	laser_instance.rotation = direction.angle()
	
	laser_instance.direction = direction

func die() -> void:
	GameManager.player_xp += 2
	animation.play("death")
	GameManager.defeatEnemy()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		player = body
		timer_attack.start()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		player_position = Vector2.ZERO
		timer_attack.stop()

func _on_timer_timeout():
	if player_in_area:
		attack(player_position)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
