extends Node

@export var speed:float = 10
@export var velocity: float = 100

var sprite: AnimatedSprite2D
var enemy: Enemy

func _ready():
	enemy = get_parent()	
	sprite = enemy.get_node("AnimatedSprite2D")
	
func _physics_process(delta: float) -> void:
	if GameManager.is_game_over: return
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * velocity
	enemy.move_and_slide()
	GameManager.flip_sprite_animated_sprite(input_vector.x, sprite)


