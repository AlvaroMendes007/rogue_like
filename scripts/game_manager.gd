extends Node

var player_position: Vector2

func flip_sprite(input_vector_x: int, sprite_2d: Sprite2D):
	if input_vector_x > 0:
		sprite_2d.flip_h = false
		pass
	if input_vector_x < 0:
		sprite_2d.flip_h = true
		
func flip_sprite_animated_sprite(input_vector_x: int, animated_sprite_2d: AnimatedSprite2D):
	if input_vector_x > 0:
		animated_sprite_2d.flip_h = false
		pass
	if input_vector_x < 0:
		animated_sprite_2d.flip_h = true
